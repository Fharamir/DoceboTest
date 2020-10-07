/**
 * @description       : 
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-07-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-07-2020   f.ruggieri89@gmail.com   Initial Version
**/
public with sharing class TriggerManager {
    
    private static list<String> skippedTriggers;

    public static void skipTrigger(String triggerName) {
        if (String.isNotBlank(triggerName)) {
            skippedTriggers = skippedTriggers == null ? new List<String>() : skippedTriggers;
            skippedTriggers.add(triggerName.toUpperCase());
        }
    }

    public static Boolean shouldGo(String triggerName) {
        return (skippedTriggers == null || String.isBlank(triggerName)) ? true : !skippedTriggers.contains(triggerName.toUpperCase());
    }
}