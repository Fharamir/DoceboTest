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
trigger Enrollment_Trigger on Enrollment__c (before insert, before update) {

    if (!TriggerManager.shouldGo('Enrollment_Trigger') || !Boolean.valueOf(Label.Enrollment_Trigger_Enabled)) return;

    if (Trigger.isBefore) Enrollment_Trigger_Manager.runBefore(Trigger.New, Trigger.oldMap);
}