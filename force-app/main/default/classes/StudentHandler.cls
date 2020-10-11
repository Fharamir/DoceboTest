/**
 * @description       : 
 * @author            : f.ruggieri89@gmail.com
 * @group             : Utility class
 * @last modified on  : 10-12-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-09-2020   f.ruggieri89@gmail.com   Initial Version
**/
public with sharing class StudentHandler {
    
    /**
    * @description Retrieves a Student (User or Contact) from its external ID [Bulk]
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    * @param dataSource 
    **/
    public void findStudentsByID(Map<String, SObject> dataSource) {

        Set<String> users    = new Set<String>();
        Set<String> contacts = new Set<String>();

        for (String code : dataSource.keySet()) {
            String key = string.isBlank(code) ? '' : code.left(15);
            if (key.startsWith('005')) users.add(key);
            else if (key.startsWith('003')) contacts.add(key);
            //This is possible working with Standard Objects only!
        }

        if (!contacts.isEmpty()) dataSource.putAll(getContacts(contacts));
        if (!users.isEmpty())    dataSource.putAll(getUsers(users));
    }

    /**
    * @description Gets complete SF IDs (18-digit) from partial IDs this is useful to clean data from external source and allow only corrects information to be inserted [Contact version]
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    * @param contacts Contacts external ids (first 15-characters)
    * @return Map<String, SObject> 
    **/
    @testVisible
    private Map<String, SObject> getContacts(Set<String> contacts) {

        Map<String, SObject> recordsMap = new Map<String, SObject>();

        for (Contact cont : [SELECT ID FROM Contact WHERE ID IN :contacts]) {
            recordsMap.put(((String)cont.ID).left(15), cont);
        }
        return recordsMap;
    }

    /**
    * @description Gets complete SF IDs (18-digit) from partial IDs this is useful to clean data from external source and allow only corrects information to be inserted [User version]
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    * @param users Users external ids (first 15-characters)
    * @return Map<String, SObject> 
    **/
    @testVisible
    private Map<String, SObject> getUsers(Set<String> users) {

        Map<String, SObject> recordsMap = new Map<String, SObject>();

        for (User us : [SELECT ID FROM User WHERE ID IN :users]) {
            recordsMap.put(((String)us.ID).left(15), us);
        }
        return recordsMap;
    }

    /**
    * @description Retrieve a student (User or Contact) from a text (Name field) - can be improved to extend the SOQL to other fields
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    * @param name partial or complete Name of the Student
    * @return List<Student_wrapper> 
    **/
    public List<Student_wrapper> getStudentsByName(string name) {

        List<Student_wrapper> swList = new List<Student_wrapper>();
        name = String.escapeSingleQuotes('%' + name + '%');

        for (User student : [SELECT Name, ID FROM User WHERE Name LIKE :name]) {
            Student_wrapper sw = new Student_wrapper();

            sw.name  = student.Name;
            sw.sf_id = student.ID;
            sw.type  = 'User';
            swList.add(sw);
        }

        for (Contact student : [SELECT Name, ID FROM Contact WHERE Name LIKE :name]) {
            Student_wrapper sw = new Student_wrapper();

            sw.name  = student.Name;
            sw.sf_id = student.ID;
            sw.type  = 'Contact';
            swList.add(sw);
        }

        //sort(swList, 'ASC'); <-- no enough time for this :)

        return swList;
    }
}