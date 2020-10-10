/**
 * @description       : 
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-10-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-08-2020   f.ruggieri89@gmail.com   Initial Version
**/
public with sharing class Enrollment_Trigger_Manager {

    public static CourseHandler  ch;
    public static StudentHandler sh;

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

            //Set enrollment date
            if (Trigger.isInsert && enr.EnrollmentDate__c == null) enr.EnrollmentDate__c = System.today();
        }

        if (!student.isEmpty()) reparent(newData, student, courses);
    }

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
                else if (key.startsWith('002') && student.get(key) != null) enr.Student_Contact__c = student.get(key).ID;
            }
        }
    }
}
