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
public with sharing class CourseHandler {
    
    public void findCoursesByID(Map<String, Course__c> dataSource){

        for (Course__c course : [SELECT ID, courseId__c FROM Course__c WHERE courseId__c IN :dataSource.keySet()]) {
            dataSource.put(course.courseId__c, course);
        }
    }

    public Map<ID, List<Course__c>> findCoursesByStudent(Set<ID> students){

        Map<ID, List<Course__c>> result = new Map<ID, List<Course__c>>();

        for (Enrollment__c enr : [SELECT Course__r.ID, Course__r.Code__c, Course__r.Description__c,
                                         Student_Contact__c, Student_User__c 
                                  FROM   Enrollment__c 
                                  WHERE (Student_Contact__c IN :students OR Student_User__c IN :students)]) {

            ID student = enr.Student_Contact__c == null ? enr.Student_User__c : enr.Student_Contact__c;

            if (result.get(student) == null) result.put(student, new List<Course__c>{enr.Course__r});
            else result.get(student).add(enr.Course__r);
        }
 
        return result;
    }
}
