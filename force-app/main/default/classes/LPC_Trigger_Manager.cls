/**
 * @description       : Trigger Handler Class (Learning_Plan_Course__c)
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-12-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-07-2020   f.ruggieri89@gmail.com   Initial Version
**/
public with sharing class LPC_Trigger_Manager {
    
    public static LearningPlanHandler lph;
    public static CourseHandler       ch;

    /**
    * @description Main 'before' method
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    * @param newData From Trigger.new
    * @param oldData From Trigger.oldMap
    **/
    public static void runBefore(List<Learning_Plan_Course__c> newData, Map<ID, Learning_Plan_Course__c> oldData) {
        
        Map<String, Learning_Plan__c> lnplanids = new Map<String, Learning_Plan__c>();
        Map<String, Course__c>        courseids = new Map<String, Course__c>       ();

        for (Learning_Plan_Course__c lpc : newData) {

            Learning_Plan_Course__c oldRecord = oldData == null ? null : oldData.get(lpc.ID);

            //Check if reparent is needed
            if (Trigger.isInsert || lpc.LearningPlanId__c != oldRecord.LearningPlanId__c  || lpc.courseId__c != oldRecord.courseId__c) {
                lnplanids.put(lpc.LearningPlanId__c, null);
                courseids.put(lpc.CourseId__c,       null);
            }
        }

        if (!lnplanids.isEmpty()) reparent(newData, lnplanids, courseids);

        integrityControl(newData);

        //Duplicate check
        for (Learning_Plan_Course__c lpc : newData) {
            lpc.DuplicateChecker__c = lpc.LearningPlanId__c + lpc.CourseId__c;
        }
    }

    /**
    * @description Main 'after' method
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    * @param newData From Trigger.new
    * @param oldData From Trigger.oldMap
    **/
    public static void runAfter(List<Learning_Plan_Course__c> newData, Map<ID, Learning_Plan_Course__c> oldData) {

        Set<ID> lpRecalc = new Set<ID>();
        
        for (Learning_Plan_Course__c lpc : newData) {
            if (Trigger.isInsert) lpRecalc.add(lpc.Learning_Plan__c);
        }

        if (!lpRecalc.isEmpty() && lpRecalc.size() < 5) LearningPlanHandler.manageNewPlanCourses(lpRecalc);
        else {
            System.debug('Starting Async LP Recalculation for ' + lpRecalc.size() + ' records');
            if (!Test.isRunningTest()) System.enqueueJob(new ManageNewCoursePlan(lpRecalc));
        }
    }

    /**
    * @description This method recalculates master-detail values when an external ID changes
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    * @param newData   From Trigger.new
    * @param lnplanids Map of Learning_Plan__c (key - external id)
    * @param courseids Map of Course__c (key - external id)
    **/
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

    /**
    * @description Checks if master-detail fields are correctly populated - Can be accomplished also via ValidationRules
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    * @param newData 
    **/
    @testVisible
    private static void integrityControl(List<Learning_Plan_Course__c> newData) {

        for (Learning_Plan_Course__c lpc : newData) {
            if (lpc.Learning_Plan__c == null) { lpc.addError('Errore : non è stata trovata una corrispondenza per l\'ID : ' + lpc.LearningPlanId__c); continue; }
            if (lpc.Course__c        == null) { lpc.addError('Errore : non è stata trovata una corrispondenza per l\'ID : ' + lpc.courseId__c      ); continue; }
        }
    }

    /*
     * In case of larger number of operations, the method (manageNewPlanCourses) will be executed in async mode
     */
    public class ManageNewCoursePlan implements Queueable {

        private Set<ID> lpRecalc;
        public ManageNewCoursePlan(Set<ID> cplans) {
            lpRecalc = cplans;
        }

        public void execute(QueueableContext qc){

            if (lpRecalc == null) return;
            LearningPlanHandler.manageNewPlanCourses(lpRecalc);
        }
    }
}