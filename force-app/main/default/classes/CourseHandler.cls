/**
 * @description       : 
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-08-2020
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
}
