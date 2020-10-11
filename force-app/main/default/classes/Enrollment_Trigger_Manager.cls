/**
 * @description       : Trigger Handler Class (Enrollment__c)
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-12-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-08-2020   f.ruggieri89@gmail.com   Initial Version
**/
public with sharing class Enrollment_Trigger_Manager {

    public static CourseHandler  ch;
    public static StudentHandler sh;

    /**
    * @description Main "before" method
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    * @param newData From Trigger.new
    * @param oldData From Trigger.oldMap
    **/
    public static void runBefore(List<Enrollment__c> newData, Map<ID, Enrollment__c> oldData) {

        Map<String, SObject>   student = new Map<String, SObject>();
        Map<String, Course__c> courses = new Map<String, Course__c>();

        for (Enrollment__c enr : newData) {

            Enrollment__c oldRecord = oldData == null ? null : oldData.get(enr.ID);
            
            //Check if reparent is needed
            if (Trigger.isInsert || enr.idst__c != oldRecord.idst__c || enr.CourseId__c != oldRecord.CourseId__c) {
                student.put(enr.idst__c,     null);
                courses.put(enr.CourseId__c, null);
            }

            //Default Status
            if (String.isBlank(enr.Status__c)) enr.Status__c = 'Subscribed';

            //Set enrollment date
            if (Trigger.isInsert && enr.EnrollmentDate__c == null) enr.EnrollmentDate__c = System.today();

            //Set Completion date
            if (enr.DateCompleted__c == null && 'Completed'.equalsIgnoreCase(enr.Status__c)) enr.DateCompleted__c = System.today();
        }

        if (!student.isEmpty()) reparent(newData, student, courses);

        //Duplicate check
        for (Enrollment__c enr : newData) {
            enr.DuplicateChecker__c = enr.idst__c + enr.CourseId__c;
        }
    }

    /**
    * @description This method recalculates master-detail and lookup values when an external ID changes
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    * @param newData From Trigger.new
    * @param student Map of mixed Contacts and Users (key - external id)
    * @param courses Map of Course__c (key - external id)
    **/
    @testVisible
    private static void reparent(List<Enrollment__c> newData, Map<String, SObject> student, Map<String, Course__c> courses){

        ch = ch == null ? new CourseHandler()  : ch;
        sh = sh == null ? new StudentHandler() : sh;

        ch.findCoursesByID(courses);
        sh.findStudentsByID(student);

        for (Enrollment__c enr : newData) {
            //Reparent Courses
            enr.Course__c = courses.get(enr.CourseId__c) != null ? courses.get(enr.CourseId__c).ID : null;

            //Reparent Students
            if (String.isNotBlank(enr.idst__c)) {
                String key = enr.idst__c.left(15);
                if (key.startsWith('005') && student.get(key) != null) enr.Student_User__c = student.get(key).ID;
                else if (key.startsWith('003') && student.get(key) != null) enr.Student_Contact__c = student.get(key).ID;
            }
        }
    }
}
