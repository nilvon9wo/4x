abstract public class UTIL_TriggerStrategyAbstract implements UTIL_TriggerStrategyInterface
{
	// @param SObject currentSObject : The current record to process.
	// @param SObject oldSObject	 : The old version, if there is one (should be null if trigger is NOT an update).
	public virtual Boolean execute (SObject currentSObject, SObject oldSObject)
	{
        System.debug(LoggingLevel.ERROR, '!!!!! Method not implemented.'); // how about throwing a custom exception? :)
        return false;
    }
}