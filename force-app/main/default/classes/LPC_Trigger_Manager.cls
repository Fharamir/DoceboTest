/**
 * @description       : 
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-09-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-07-2020   f.ruggieri89@gmail.com   Initial Version
**/
public with sharing class LPC_Trigger_Manager {
    
    public static LearningPlanHandler lph;
    public static CourseHandler       ch;

    public static void runBefore(List<Learning_Plan_Course__c> newData, Map<ID, Learning_Plan_Course__c> oldData) {
        
        Map<String, Learning_Plan__c> lnplanids = new Map<String, Learning_Plan__c>();
        Map<String, Course__c>        courseids = new Map<String, Course__c>       ();

        for (Learning_Plan_Course__c lpc : newData) {

            Learning_Plan_Course__c oldRecord = oldData == null ? null : oldData.get(lpc.ID);

            if (Trigger.isInsert || lpc.LearningPlanId__c != oldRecord.LearningPlanId__c  || lpc.courseId__c != oldRecord.courseId__c) {
                lnplanids.put(lpc.LearningPlanId__c, null);
                courseids.put(lpc.courseId__c,       null);
            }
        }

        if (!lnplanids.isEmpty()) reparent(newData, lnplanids, courseids);

        integrityControl(newData);
    }

    @testVisible
    private static void reparent(List<Learning_Plan_Course__c> newData, Map<String, Learning_Plan__c> lnplanids, Map<String, Course__c> courseids){

        ch  = ch  == null ? new CourseHandler()       : ch;
        lph = lph == null ? new LearningPlanHandler() : lph;

        ch.findCoursesByID(courseids);
        lph.findLearningplansByID(lnplanids);

        for (Learning_Plan_Course__c lpc : newData) {
            //Reparent learningplans
            lpc.Learning_Plan__c = lnplanids.get(lpc.LearningPlanId__c) != null ? lnplanids.get(lpc.LearningPlanId__c).ID : null;

            //Reparent Courses
            lpc.Course__c = courseids.get(lpc.courseId__c) != null ? courseids.get(lpc.courseId__c).ID : null;
        }
    }

    @testVisible
    private static void integrityControl(List<Learning_Plan_Course__c> newData) {

        for (Learning_Plan_Course__c lpc : newData) {
            if (lpc.Learning_Plan__c == null) { lpc.addError('Errore : non è stata trovata una corrispondenza per l\'ID : ' + lpc.LearningPlanId__c); continue; }
            if (lpc.Course__c        == null) { lpc.addError('Errore : non è stata trovata una corrispondenza per l\'ID : ' + lpc.courseId__c      ); continue; }
        }
    }
}