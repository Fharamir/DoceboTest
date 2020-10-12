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
public with sharing class studentviewer_CTRL_Test {

    @TestSetup
    static void makeData(){

        ID userID = [SELECT ID FROM User LIMIT 1].ID;
        insert new Course__c(courseid__c = 'test_course');
        insert new Learning_Plan__c(learningplanid__c = 'test_lp');
        insert new Learning_Plan_Course__c(learningplanid__c = 'test_lp', courseid__c = 'test_course');
        insert new LearningPlanEnrollment__c(idst__c = userID, learningplanid__c = 'test_lp');
    }

    @isTest
    public static void test_controller() {
        Student_wrapper sw  = new Student_wrapper();
        sw.sf_id = [SELECT ID FROM User LIMIT 1].ID;
        sw.name  = 'TEST STUDENT';
        sw.type  = 'USER';

        Test.startTest();
        studentviewer_CTRL swc = new studentviewer_CTRL();
        swc.student = sw;
        Test.stopTest();

        System.assert(swc.student.coursesVal != null, 'Data correctly loaded');
        System.assert(swc.student.lPlansPercentages != null, 'Data correctly calculated');
    }
}
