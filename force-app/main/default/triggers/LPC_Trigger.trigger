/**
 * @description       : 
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-08-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-07-2020   f.ruggieri89@gmail.com   Initial Version
**/
trigger LPC_Trigger on Learning_Plan_Course__c (before insert, before update) {

    if (!TriggerManager.shouldGo('LPC_Trigger') || !Boolean.valueOf(Label.LPC_Trigger_Enabled)) return;

    LPC_Trigger_Manager.runBefore(Trigger.New, Trigger.oldMap);
}