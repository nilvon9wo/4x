public interface UTIL_TriggerStrategyInterface 
{
	/**
     * @return boolean True if the execution is considered successful, false otherwise.
     *                 If the return value is false, the execution chain can be stopped.
     */
     Boolean execute (SObject currentSObject, SObject oldSObject);
}