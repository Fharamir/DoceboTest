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
public with sharing class LearningPlanHandler {
    
    public void findLearningplansByID(Map<String, Learning_Plan__c> dataSource){

        for (Learning_Plan__c lp : [SELECT ID, LearningPlanId__c FROM Learning_Plan__c WHERE LearningPlanId__c IN :dataSource.keySet()]) {
            dataSource.put(lp.LearningPlanId__c, lp);
        }
    }
}
