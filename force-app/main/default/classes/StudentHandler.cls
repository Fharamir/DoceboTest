/**
 * @description       : 
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-09-2020
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
}
