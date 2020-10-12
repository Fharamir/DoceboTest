/**
 * @description       : Generic Trigger Handler logics (No need for testclass until now)
 * @author            : f.ruggieri89@gmail.com
 * @group             : 
 * @last modified on  : 10-12-2020
 * @last modified by  : f.ruggieri89@gmail.com
 * Modifications Log 
 * Ver   Date         Author                   Modification
 * 1.0   10-07-2020   f.ruggieri89@gmail.com   Initial Version
**/
public with sharing class TriggerManager {
    
    private static list<String> skippedTriggers;

    /**
    * @description This method allows the capability to skip triggers logic by its name (Note - every trigger can be turned off 'globally' by setting to FALSE their label)
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    * @param triggerName 
    **/
    public static void skipTrigger(String triggerName) {
        if (String.isNotBlank(triggerName)) {
            skippedTriggers = skippedTriggers == null ? new List<String>() : skippedTriggers;
            skippedTriggers.add(triggerName.toUpperCase());
        }
    }

    /**
    * @description Generic check method to know if the trigger must be skipped
    * @author f.ruggieri89@gmail.com | 10-12-2020 
    * @param triggerName 
    * @return Boolean 
    **/
    public static Boolean shouldGo(String triggerName) {
        return (skippedTriggers == null || String.isBlank(triggerName)) ? true : !skippedTriggers.contains(triggerName.toUpperCase());
    }
}