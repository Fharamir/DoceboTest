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
public with sharing class CourseHandler_Test {
    
    @TestSetup
    static void makeData(){
        Course__c c = new Course__c(courseId__c = 'TestData');
        insert c;
        User u = [SELECT ID FROM User LIMIT 1];

        TriggerManager.skipTrigger('Enrollment_Trigger');
        insert new Enrollment__c(Course__c = c.ID, Student_User__c = u.ID, idst__c = 'TEST', CourseId__c = 'TEST');

        Learning_Plan__c lp = new Learning_Plan__c(LearningPlanId__c = 'TEST');
        insert lp;

        TriggerManager.skipTrigger('LPC_Trigger');
        insert new Learning_Plan_Course__c(Learning_Plan__c = lp.ID, Course__c = c.ID);
    }

    @isTest
    public static void test_findCoursesByID() {
        String courseid = [SELECT courseId__c FROM Course__c LIMIT 1].courseId__c;
        Map<String, Course__c> data = new Map<String, Course__c>{courseid => null};
        Test.startTest();
        CourseHandler ch = new CourseHandler();
        ch.findCoursesByID(data);
        Test.stopTest();

        System.assert(data.get(courseid) != null, 'Record found');
    }

    @isTest
    public static void test_findCoursesByStudent(){
        ID userID = [SELECT Student_User__c FROM Enrollment__c LIMIT 1].Student_User__c;

        Test.startTest();
        CourseHandler ch = new CourseHandler();
        Map<ID, List<Course__c>> slc = ch.findCoursesByStudent(new Set<ID>{userID});
        Test.stopTest();

        System.assert(slc.get(userID) != null && !slc.get(userID).isEmpty(), 'Had results');
    }

    @isTest
    public static void test_findCoursesByLearningPlan() {
        ID lpID = [SELECT Learning_Plan__c FROM Learning_Plan_Course__c LIMIT 1].Learning_Plan__c;

        Test.startTest();
        CourseHandler ch = new CourseHandler();
        Map<ID, List<Course__c>> slc = ch.findCoursesByLearningPlan(new Set<ID>{lpID});
        Test.stopTest();

        System.assert(slc.get(lpID) != null && !slc.get(lpID).isEmpty(), 'Had results');
    }
}