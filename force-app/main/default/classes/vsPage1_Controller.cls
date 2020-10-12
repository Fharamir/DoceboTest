/**
 * @description       : Visualforce page controller (VSPage1.page)
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-13-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-10-2020   f.ruggieri89@gmail.com   Initial Version
**/
public with sharing class vsPage1_Controller {

    //FE Data
    public String                searchbar   {get; set;}
    public Student_wrapper       highlighted {get; set;}
    public GenericDataWrapper    wrapperData {get; set;}

    //Utilities
    public  StudentHandler        studentH;
    public  String                clickedStudent     {get; set;}
    private List<Student_wrapper> students           {get; set;}
    public  vsPage1_Controller    controllerInstance {get { return this; }}

    /**
    * @description Constructor
    * @author f.ruggieri89@gmail.com | 10-12-2020
    **/
    public vsPage1_Controller() { students = new List<Student_wrapper>(); }

    /**
    * @description Clicked on SEARCH button, makes SOQL and initialize relatedlist component
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    **/
    public void retrieveStudent() {
        if (String.isBlank(searchbar)) return;

        studentH = studentH == null ? new StudentHandler() : studentH;
        students = studentH.getStudentsByName(searchbar);
        highlighted = null;
        wrapperData = new GenericDataWrapper();
        wrapperData.studentData = students;
    }

    /**
    * @description A student has been clicked - Initialize student_viewer component
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    **/
    public void selectedStudent() {
        if (String.isBlank(clickedStudent)) return;

        for (Student_wrapper sw : students) {
            if (sw.sf_id.equals(clickedStudent)) highlighted = sw;
        }
    }
}