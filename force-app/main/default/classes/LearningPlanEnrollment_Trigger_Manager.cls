/**
 * @description       : Trigger Handler Class (LearningPlanEnrollment__c)
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-12-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-10-2020   f.ruggieri89@gmail.com   Initial Version
**/
public with sharing class LearningPlanEnrollment_Trigger_Manager {
    
    public static LearningPlanHandler lph;
    public static StudentHandler      sh;
    public static List<LearningPlanEnrollment__c> toRecalc;

    /**
    * @description Main "before" method
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    * @param newData From Trigger.new
    * @param oldData From Trigger.oldMap
    **/
    public static void runBefore(List<LearningPlanEnrollment__c> newData, Map<ID, LearningPlanEnrollment__c> oldData) {

        Map<String, SObject>            student  = new Map<String, SObject>();
        Map<String, Learning_Plan__c>   lplans   = new Map<String, Learning_Plan__c>();
        toRecalc = new List<LearningPlanEnrollment__c>();

        for (LearningPlanEnrollment__c lpe : newData) {

            LearningPlanEnrollment__c oldRecord = oldData == null ? null : oldData.get(lpe.ID);
            
            //Check if reparent is needed
            if (Trigger.isInsert || lpe.idst__c != oldRecord.idst__c || lpe.LearningPlanId__c != oldRecord.LearningPlanId__c) {
                student.put(lpe.idst__c,           null);
                lplans.put(lpe.LearningPlanId__c, null);
            }

            //Set enrollment date
            if (Trigger.isInsert && lpe.EnrollmentDate__c == null) lpe.EnrollmentDate__c = System.today();

            if (lpe.CoursesRecalculation__c) {
                lpe.CoursesRecalculation__c = false;
                toRecalc.add(lpe);
            }
        }

        if (!student.isEmpty()) reparent(newData, student, lplans);

        //Duplicate check
        for (LearningPlanEnrollment__c lpe : newData) {
            lpe.DuplicateChecker__c = lpe.idst__c + lpe.LearningPlanId__c;
        }
    }

    /**
    * @description Main "after" method
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    * @param newData From Trigger.new
    * @param oldData From Trigger.oldMap
    **/
    public static void runAfter(List<LearningPlanEnrollment__c> newData, Map<ID, LearningPlanEnrollment__c> oldData) {

        List<LearningPlanEnrollment__c> newPlans = new List<LearningPlanEnrollment__c>();

        if (toRecalc != null && !toRecalc.isEmpty()) newPlans.addAll(toRecalc);

        for (LearningPlanEnrollment__c lpe : newData) {

            //Manage new plan enrollment
            if (Trigger.isInsert) newPlans.add(lpe);
        }

        //New Learning plan enrollments means new enrollment for each course of the learning plan
        if (!newPlans.isEmpty() && newPlans.size() <= 5) LearningPlanHandler.manageNewPlanEnrollments(newPlans);
        else if (newPlans.size() > 5) {
            System.debug('Starting Async LP Enrollment for ' + newPlans.size() + ' records');
            if (!Test.isRunningTest()) System.enqueueJob(new manageNewPlans_async(newPlans));
        }
    }

    /**
    * @description This method recalculates master-detail and lookup values when an external ID changes
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    * @param newData From Trigger.new
    * @param student Map of mixed Contacts and Users (key - external id)
    * @param lplans  Map of Learning_Plan__c (key - external id)
    **/
    @testVisible
    private static void reparent(List<LearningPlanEnrollment__c> newData, Map<String, SObject> student, Map<String, Learning_Plan__c> lplans){

        lph = lph == null ? new LearningPlanHandler()  : lph;
        sh  = sh  == null ? new StudentHandler()       : sh;

        lph.findLearningplansByID(lplans);
        sh.findStudentsByID(student);

        for (LearningPlanEnrollment__c lpe : newData) {
            //Reparent lplans
            lpe.Learning_Plan__c = lplans.get(lpe.LearningPlanId__c) != null ? lplans.get(lpe.LearningPlanId__c).ID : null;

            //Reparent Students
            if (String.isNotBlank(lpe.idst__c)) {
                String key = lpe.idst__c.left(15);
                if (key.startsWith('005') && student.get(key) != null) lpe.Student_User__c = student.get(key).ID;
                else if (key.startsWith('003') && student.get(key) != null) lpe.Student_Contact__c = student.get(key).ID;
            }
        }
    }

    /*
     * In case of larger number of operations, the method (manageNewPlanEnrollments) will be executed in async mode
     */
    public class manageNewPlans_async implements Queueable {

        private List<LearningPlanEnrollment__c> newPlans;
        public manageNewPlans_async(List<LearningPlanEnrollment__c> plans) {
            newPlans = plans;
        }

        public void execute(QueueableContext qc){

            if (newPlans == null) return;
            if (!Test.isRunningTest()) LearningPlanHandler.manageNewPlanEnrollments(newPlans);
        }
    }
}