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
public with sharing class vsPage1_Controller_Test {

    @isTest
    public static void test_controller() {

        User u = [SELECT ID, Name FROM User LIMIT 1];

        Test.startTest();
        vsPage1_Controller vfpc = new vsPage1_Controller();
        vfpc.clickedStudent = u.ID;
        vfpc.searchbar = u.Name;
        vfpc.retrieveStudent();
        vfpc.selectedStudent();
        Test.stopTest();

        System.assert(vfpc.controllerInstance == vfpc, 'Check for itself');
        System.assert(vfpc.wrapperData != null, 'Data correctly loaded');
    }
}
