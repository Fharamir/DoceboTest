/**
 * @description       : 
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-11-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-10-2020   f.ruggieri89@gmail.com   Initial Version
**/
trigger LearningPlanEnrollment_Trigger on LearningPlanEnrollment__c (before insert, before update, after insert, after update) {

    if (!TriggerManager.shouldGo('LearningPlanEnrollment_Trigger') || !Boolean.valueOf(Label.LPEnrollment_Trigger_Enabled)) return;

    if (Trigger.isBefore) LearningPlanEnrollment_Trigger_Manager.runBefore(Trigger.New, Trigger.oldMap);
    if (Trigger.isAfter)  LearningPlanEnrollment_Trigger_Manager.runAfter( Trigger.New, Trigger.oldMap);
}