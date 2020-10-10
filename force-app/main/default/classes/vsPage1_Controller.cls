/**
 * @description       : 
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-10-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-10-2020   f.ruggieri89@gmail.com   Initial Version
**/
public with sharing class vsPage1_Controller {

    //FE Data
    public String                searchbar   {get; set;}
    public List<Student_wrapper> students    {get; set;}
    public Student_wrapper       highlighted {get; set;}

    //Utilities
    public StudentHandler        studentH;
    public String                clickedStudent {get; set;}

    public vsPage1_Controller() { students = new List<Student_wrapper>(); }

    public void retrieveStudent() {
        if (String.isBlank(searchbar)) return;

        studentH = studentH == null ? new StudentHandler() : studentH;
        students = studentH.getStudentsByName(searchbar);
        highlighted = null;
    }

    public void selectedStudent() {
        if (String.isBlank(clickedStudent)) return;

        for (Student_wrapper sw : students) {
            if (sw.sf_id.equals(clickedStudent)) highlighted = sw;
        }
    }
}
