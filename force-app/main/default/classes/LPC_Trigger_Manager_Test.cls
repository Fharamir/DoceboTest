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
public with sharing class LPC_Trigger_Manager_Test {
    
    
    @TestSetup
    static void makeData(){

        insert new Learning_Plan__c(LearningPlanId__c = 'TEST');
        insert new Course__c(courseid__c = 'TEST');

        User u = [SELECT ID FROM User LIMIT 1];
        insert new LearningPlanEnrollment__c( idst__c = u.ID, LearningPlanId__c = 'TEST');
    }
    
    @isTest
    public static void test_trigger() {
        Learning_Plan__c lp = [SELECT ID FROM Learning_Plan__c LIMIT 1];
        Test.startTest();
        insert new Learning_Plan_Course__c(LearningPlanId__c = 'TEST', courseid__c = 'TEST');
        LPC_Trigger_Manager.ManageNewCoursePlan mncp = new LPC_Trigger_Manager.ManageNewCoursePlan(new Set<ID>{lp.ID});
        System.enqueueJob(mncp);
        Test.stopTest();
    }
}
