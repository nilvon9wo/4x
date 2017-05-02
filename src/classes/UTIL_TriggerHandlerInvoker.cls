public class UTIL_TriggerHandlerInvoker 
{
	private static final boolean DEFAULT_SKIP_TRIGGERS_VALUE = false;
	@testVisible private static final Map<String, boolean> SKIP_OBJECT_TRIGGER_MAP = new Map<String, boolean>();

	// These should only be used for testing!
	@testVisible private static String  DUMMY_SOBJECT_NAME       = 'DummySObject';
	@testVisible private static Boolean realTrigger				 = true;
	@testVisible private static Boolean pretendTestNotRunning    = false; 
	@testVisible private static Boolean pretendSkipTriggersNull  = false; 
	@testVisible private static Boolean pretendSObjectNotNull    = false;
	@testVisible private static Boolean pretendTriggerNewNotNull = false;
	@testVisible private static Boolean pretendTriggerOldNotNull = false;
	@testVisible private static Boolean pretendBefore			 = false;
	@testVisible private static Boolean pretendAfter    		 = false;
	@testVisible private static Boolean pretendInsert  			 = false;
	@testVisible private static Boolean pretendUpdate   		 = false;
	@testVisible private static Boolean pretendDelete   		 = false;
	@testVisible private static Boolean pretendUndelete 		 = false;

    /**
     * Evaluate global trigger execution.
     */  
    public static boolean skipTriggerInvocation() 
    {
        boolean result = General_Settings__c.getInstance().Skip_Triggers__c;
        if ((result == null) || (pretendSkipTriggersNull)) { result = DEFAULT_SKIP_TRIGGERS_VALUE; }		// Value is not set, setting a default value
        return result;		  
    }
    
    /**
     * Enable/Disable per object trigger execution.
     */
    public static void skipObjectTriggerInvocation(String objectName, boolean skip) { SKIP_OBJECT_TRIGGER_MAP.put(objectName, skip); }

    /**
     * Evaluate per object trigger execution.
     */
    public static boolean skipObjectTrigger() 
    {
    	sObject obj = null;
    	if 	    ((Trigger.new != null && ! Trigger.new.isEmpty()) || (pretendTriggerNewNotNull)) { obj = (!pretendTriggerNewNotNull) ? Trigger.new.get(0) : (new Account()); } 
    	else if ((Trigger.old != null && ! Trigger.old.isEmpty()) || (pretendTriggerOldNotNull)) { obj = (!pretendTriggerOldNotNull) ? Trigger.old.get(0) : (new Account()); }
        
        if (obj == null) {  return false;  }	// This should never happen outside of tests.

        String objectName = (!pretendSObjectNotNull) ? obj.getSObjectType().getDescribe().getName() : DUMMY_SOBJECT_NAME;
        if (pretendTriggerNewNotNull || pretendTriggerOldNotNull) { objectName = DUMMY_SOBJECT_NAME; }
        return (SKIP_OBJECT_TRIGGER_MAP.get(objectName) == true);
    }
    
	/**
	 * Invoke the trigger handler according to the trigger type.
	 */
    public static void invoke(UTIL_TriggerHandlerInterface handler)  
    {
    	handler.execute();
    }
}