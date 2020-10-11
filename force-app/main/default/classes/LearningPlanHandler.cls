/**
 * @description       : Utility Class
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-12-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-08-2020   f.ruggieri89@gmail.com   Initial Version
**/
public with sharing class LearningPlanHandler {

    public static CourseHandler ch;
    
    /**
    * @description Retrieves a learning plan from its external ID [Bulk]
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    * @param dataSource 
    **/
    public void findLearningplansByID(Map<String, Learning_Plan__c> dataSource){

        for (Learning_Plan__c lp : [SELECT ID, LearningPlanId__c FROM Learning_Plan__c WHERE LearningPlanId__c IN :dataSource.keySet()]) {
            dataSource.put(lp.LearningPlanId__c, lp);
        }
    }

    /**
    * @description When a new learningPlanEnrollment is inserted (or recalculated), students will be enrolled for every course in the learning plan (Exept for those already enrolled)
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    * @param newPlans 
    **/
    public static void manageNewPlanEnrollments(List<LearningPlanEnrollment__c> newPlans) {

        ch = ch == null ? new CourseHandler() : ch;

        Map<ID, List<Course__c>> lplansCourses  = new Map<ID, List<Course__c>>();

        for (LearningPlanEnrollment__c lpe : newPlans) {
            lplansCourses.put(lpe.Learning_Plan__c, null);
        }

        lplansCourses = ch.findCoursesByLearningPlan(lplansCourses.keySet());

        List<Enrollment__c> newEnrollments = new List<Enrollment__c>();

        for(LearningPlanEnrollment__c lpe : newPlans) {
            if (lplansCourses.get(lpe.Learning_Plan__c) == null) continue;

            for (Course__c cs : lplansCourses.get(lpe.Learning_Plan__c)) {
                newEnrollments.add(new Enrollment__c(CourseId__c = cs.courseId__c, idst__c = lpe.idst__c));
            }
        }

        if (!newEnrollments.isEmpty()) Database.insert(newEnrollments, false);        
    }

    /**
    * @description When a course is added to a learning plan, that learning plan will be recalculated in order to have every student enrolled on that learning plan also enrolled to the new course
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    * @param plans 
    **/
    public static void manageNewPlanCourses(Set<ID> plans) {

        List<LearningPlanEnrollment__c> lpes = [SELECT ID FROM LearningPlanEnrollment__c WHERE Learning_Plan__c IN :plans];
        for (LearningPlanEnrollment__c lpe : lpes) {
            lpe.CoursesRecalculation__c = true;
        }

        update lpes;
    }
}
