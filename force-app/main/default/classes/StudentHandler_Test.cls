/**
 * @description       : 
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-13-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-13-2020   f.ruggieri89@gmail.com   Initial Version
**/
@isTest
public with sharing class StudentHandler_Test {
    
    @TestSetup
    static void makeData(){
        insert new Contact(FirstName = 'Admin', LastName = 'Tester');
    }

    @isTest
    public static void test_findStudentsByID() {
        Contact cont = [SELECT ID FROM Contact LIMIT 1];
        User    us   = [SELECT ID FROM User    LIMIT 1];
        Map<String, SObject> data = new Map<String, SObject>{ cont.ID => null, us.ID => null };

        Test.startTest();
        StudentHandler sh = new StudentHandler();
        sh.findStudentsByID(data);
        Test.stopTest();

        System.assert(data.get(String.valueOf(cont.ID).left(15)) != null, 'Record found');
        System.assert(data.get(String.valueOf(us.ID  ).left(15)) != null, 'Record found');
    }

    @isTest
    public static void test_getStudentsByName() {

        Test.startTest();
        StudentHandler sh = new StudentHandler();
        List<Student_wrapper> swList = sh.getStudentsByName('A');
        Test.stopTest();

        System.assert(!swList.isEmpty(), 'Record found');
    }
}
