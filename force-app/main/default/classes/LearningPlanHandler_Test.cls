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
public with sharing class LearningPlanHandler_Test {
    
    @TestSetup
    static void makeData(){
        Learning_Plan__c lp = new Learning_Plan__c(LearningPlanId__c = 'TEST');
        insert lp;
    }
    
    @isTest
    public static void test_findLearningplansByID() {
        String lpId = [SELECT LearningPlanId__c FROM Learning_Plan__c LIMIT 1].LearningPlanId__c;
        Map<String, Learning_Plan__c> lplans = new Map<String, Learning_Plan__c>{lpId => null};

        Test.startTest();
        LearningPlanHandler lph = new LearningPlanHandler();
        lph.findLearningplansByID(lplans);
        Test.stopTest();

        System.assert(lplans.get(lpId) != null, 'Record found');
    }
    
    @isTest
    public static void test_manageNewPlanEnrollments() {
        Learning_Plan__c lp = [SELECT ID FROM Learning_Plan__c LIMIT 1];
        User u = [SELECT ID FROM User LIMIT 1];

        Test.startTest();
        LearningPlanHandler.ch = (CourseHandler) Test.createStub(CourseHandler.class, new MokCourseHandler());
        LearningPlanHandler.manageNewPlanEnrollments(new List<LearningPlanEnrollment__c>{new LearningPlanEnrollment__c(Learning_Plan__c = lp.ID, idst__c = u.ID)});
        Test.stopTest();
    }
    
    @isTest
    public static void test_manageNewPlanCourses() {
        Learning_Plan__c lp = [SELECT ID FROM Learning_Plan__c LIMIT 1];

        Test.startTest();
        LearningPlanHandler.manageNewPlanCourses(new Set<ID>{lp.ID});
        Test.stopTest();
    }

    public class MokCourseHandler implements StubProvider {
        
        public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, System.Type returnType, List<System.Type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs){
            
            switch on stubbedMethodName {
                when 'findCoursesByLearningPlan' { return new Map<ID, List<Course__c>>{[SELECT ID FROM Learning_Plan__c LIMIT 1].ID => new List<Course__c>{new Course__c(courseId__c = 'TEST')}}; }
            }
            return null;
        }
     }
}