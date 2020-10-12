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
public with sharing class LPE_Trigger_Manager_Test {

    @TestSetup
    static void makeData(){
        Course__c c = new Course__c(courseId__c = 'TestData');
        insert c;

        Learning_Plan__c lp = new Learning_Plan__c(LearningPlanId__c = 'TEST');
        insert lp;

        TriggerManager.skipTrigger('LPC_Trigger');
        insert new Learning_Plan_Course__c(Learning_Plan__c = lp.ID, Course__c = c.ID);
    }
    
    @isTest
    public static void test_runTrigger() {
        User u = [SELECT ID FROM User LIMIT 1];

        Test.startTest();
        insert new LearningPlanEnrollment__c(idst__c = String.valueOf(u.ID), LearningPlanId__c = 'TEST', CoursesRecalculation__c = true);
        LearningPlanEnrollment_Trigger_Manager.manageNewPlans_async async = new LearningPlanEnrollment_Trigger_Manager.manageNewPlans_async([SELECT ID FROM LearningPlanEnrollment__c]);
        System.enqueueJob(async);
        Test.stopTest();

        System.assert(!([SELECT ID FROM LearningPlanEnrollment__c]).isEmpty(), 'Record added');
    }
}