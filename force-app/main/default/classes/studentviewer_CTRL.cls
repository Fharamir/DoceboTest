/**
 * @description       : Visualforce component Controller class (StudentViewer.component)
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-12-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-11-2020   f.ruggieri89@gmail.com   Initial Version
**/
public with sharing class studentviewer_CTRL {
    
    public Student_wrapper student {get; set{ Boolean changed = (value != student); student = value; setinfo(changed); }}

    /**
    * @description Student data are loaded only when passed from the main page
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    * @param isChanged  Checks if the data received are new from the main page or simple rerender (avoid unnecessary logic)
    **/
    private void setInfo(Boolean isChanged){
        if (student != null && student.sf_id != null && isChanged) loadinfo();
    }

    /**
    * @description Fills the main student wrapper with every information needed to the FE
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    **/
    private void loadinfo(){

        student.enrolledCourses = new Map<ID, Enrollment__c>();
        student.enrolledLplans = new Map<ID, LearningPlanEnrollment__c>();

        for (Enrollment__c e : [SELECT ID, Course__c, CourseId__c, EnrollmentDate__c, Status__c, DateCompleted__c FROM Enrollment__c WHERE (Student_Contact__c = :student.sf_id OR Student_User__c = :student.sf_id)]) {
            student.enrolledCourses.put(e.Course__c, e);
        }
        for (LearningPlanEnrollment__c l : [SELECT ID, Learning_Plan__c, LearningPlanId__c, EnrollmentDate__c FROM LearningPlanEnrollment__c WHERE (Student_Contact__c = :student.sf_id OR Student_User__c = :student.sf_id)]) {
            student.enrolledLplans.put(l.Learning_Plan__c, l);
        }

        student.courses = new Map<ID, Course__c>([SELECT ID, Name, Code__c, Description__c, courseId__c FROM Course__c WHERE ID IN :student.enrolledCourses.keySet()]);
        student.lPlans  = new Map<ID, Learning_Plan__c>([SELECT ID, Name, Code__c, Description__c, LearningPlanId__c, Courses_in_LP__c FROM Learning_Plan__c WHERE ID IN :student.enrolledLplans.keySet()]);
        student.lpCompledCourses = new Map<ID, Integer>();

        for (Learning_Plan_Course__c lpc : [SELECT Course__c, Learning_Plan__c FROM Learning_Plan_Course__c WHERE Learning_Plan__c IN :student.enrolledLplans.keySet()]){
            Integer total = student.lpCompledCourses.get(lpc.Learning_Plan__c) != null ? student.lpCompledCourses.get(lpc.Learning_Plan__c) : 0;
            if (student.enrolledCourses.get(lpc.Course__c) != null && 'Completed'.equalsIgnoreCase(student.enrolledCourses.get(lpc.Course__c).Status__c)) total++;
            student.lpCompledCourses.put(lpc.Learning_Plan__c, total);
        }

        student.lPlansPercentages = new Map<Id,Decimal>();
        for (Learning_Plan__c lp : student.lplansVal) {
            if (student.lpCompledCourses.get(lp.ID) == null) student.lpCompledCourses.put(lp.ID, 0);
            if (lp.Courses_in_LP__c == 0) student.lPlansPercentages.put(lp.ID, 100);
            else student.lPlansPercentages.put(lp.ID, (Decimal)((Decimal)student.lpCompledCourses.get(lp.ID) * 100 / (Decimal)lp.Courses_in_LP__c));
        }
    }
}
