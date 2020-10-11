/**
 * @description       : Utility wrapper - this class represents a student and can contains all FE and BE necessary information
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-12-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-10-2020   f.ruggieri89@gmail.com   Initial Version
**/
public with sharing class Student_wrapper {
    
    public String ext_id {get; set;}
    public String sf_id  {get; set;}
    public String name   {get; set;}
    public String type   {get; set;}
    public Map<ID, Course__c>                 courses           {get; set;}
    public Map<ID, Learning_Plan__c>          lPlans            {get; set;}
    public Map<ID, Decimal>                   lPlansPercentages {get; set;}
    public Map<ID, Integer>                   lpCompledCourses  {get; set;}
    public Map<ID, LearningPlanEnrollment__c> enrolledLplans    {get; set;}
    public Map<ID, Enrollment__c>             enrolledCourses   {get; set;}
    public List<Learning_Plan__c>             lplansVal         {get { return lPlans.values();  }}
    public List<Course__c>                    coursesVal        {get { return courses.values(); }}
}