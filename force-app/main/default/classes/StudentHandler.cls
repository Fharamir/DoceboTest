/**
 * @description       : 
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-10-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-09-2020   f.ruggieri89@gmail.com   Initial Version
**/
public with sharing class StudentHandler {
    
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

    @testVisible
    private Map<String, SObject> getContacts(Set<String> contacts) {

        Map<String, SObject> recordsMap = new Map<String, SObject>();

        for (Contact cont : [SELECT ID FROM Contact WHERE ID IN :contacts]) { // <----- Getting 18-Digit ID from 15-Digit IDs, necessary to manage (and clean) unknown data
            recordsMap.put(((String)cont.ID).left(15), cont);
        }
        return recordsMap;
    }

    @testVisible
    private Map<String, SObject> getUsers(Set<String> users) {

        Map<String, SObject> recordsMap = new Map<String, SObject>();

        for (User us : [SELECT ID FROM User WHERE ID IN :users]) { // <----- Getting 18-Digit ID from 15-Digit IDs, necessary to manage (and clean) unknown data
            recordsMap.put(((String)us.ID).left(15), us);
        }
        return recordsMap;
    }

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
