/**
 * @description       : 
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-13-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-13-2020   f.ruggieri89@gmail.com   Initial Version
**/
@isTest
public with sharing class relatedlist_controller_Test {
    
    @TestSetup
    static void makeData(){
        Learning_Plan__c lp = new Learning_Plan__c(LearningPlanId__c = 'TEST');
        insert lp;
    }
    
    @isTest
    public static void testmaincontroller() {

        GenericDataWrapper gdw = new GenericDataWrapper();
        gdw.studentData        = new List<Student_wrapper>();
        Student_wrapper    sw  = new Student_wrapper();
        sw.sf_id = [SELECT ID FROM User LIMIT 1].ID;
        sw.name  = 'TEST STUDENT';
        sw.type  = 'USER';
        gdw.studentData.add(sw);

        Test.startTest();
        relatedlist_controller rlc = new relatedlist_controller();
        rlc.dataSource = gdw;
        List<Student_wrapper> md = rlc.maindata;
        String footer = rlc.footerText;
        vsPage1_Controller vfp = rlc.controller;
        rlc.dataManager.goNext();
        rlc.dataManager.goPrev();
        rlc.dataManager.goEnd();
        rlc.dataManager.goStart();
        Test.stopTest();

        System.assert(!md.isEmpty(), 'Data are loaded');
    }
}
