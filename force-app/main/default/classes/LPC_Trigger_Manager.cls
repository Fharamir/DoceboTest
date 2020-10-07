/**
 * @description       : 
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-08-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-07-2020   f.ruggieri89@gmail.com   Initial Version
**/
public with sharing class LPC_Trigger_Manager {
    
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

        if (!lnplanids.isEmpty() || !courseids.isEmpty()) reparent(newData, lnplanids, courseids);

        integrityControl(newData);
    }

    @testVisible
    private static void reparent(List<Learning_Plan_Course__c> newData, Map<String, Learning_Plan__c> lnplanids, Map<String, Course__c> courseids){

        List<Learning_Plan__c> lnplans = [SELECT ID, LearningPlanId__c FROM Learning_Plan__c WHERE LearningPlanId__c IN :lnplanids.keySet()];
        List<Course__c>        courses = [SELECT ID, courseId__c       FROM Course__c        WHERE courseId__c       IN :courseids.keySet()];

        for (Learning_Plan__c lp : lnplans) lnplanids.put(lp.LearningPlanId__c, lp);
        for (Course__c        cs : courses) courseids.put(cs.courseId__c,       cs);

        for (Learning_Plan_Course__c lpc : newData) {
            lpc.Learning_Plan__c = lnplanids.get(lpc.LearningPlanId__c).ID;
            lpc.Course__c        = courseids.get(lpc.courseId__c      ).ID;
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