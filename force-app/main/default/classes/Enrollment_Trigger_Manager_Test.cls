/**
 * @description       : 
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-12-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-12-2020   f.ruggieri89@gmail.com   Initial Version
**/
@isTest
public with sharing class Enrollment_Trigger_Manager_Test {

    @TestSetup
    static void makeData(){
        Course__c c = new Course__c(courseId__c = 'TestData');
        insert c;
    }
    
    @isTest
    public static void test_runTrigger() {
        User u = [SELECT ID FROM User LIMIT 1];

        Test.startTest();
        insert new Enrollment__c(idst__c = String.valueOf(u.ID), CourseId__c = 'TestData');
        Test.stopTest();

        System.assert(!([SELECT ID FROM Enrollment__c]).isEmpty(), 'Record added');
    }
}
