abstract public class UTIL_TriggerHandlerAbstract implements UTIL_TriggerHandlerInterface 
{
    @testVisible protected UTIL_TriggerWrapper		 		   triggerWrapper = null;
    @testVisible protected List<UTIL_TriggerStrategyInterface> strategyList   = null; 
    
    public UTIL_TriggerHandlerAbstract(UTIL_TriggerWrapper triggerWrapper) { this.triggerWrapper = triggerWrapper; }
    
    public virtual SObject getOld (Id sObjectId) { return triggerWrapper.oldSObjectByIdMap.get(sObjectId); } 
    
    public virtual void execute()
    {
    	doPreSteps();
    	buildStrategyList(); 
    	iterateSObjectRecords();
    	doPostSteps();
    }
    
    protected abstract void doPreSteps();
    protected abstract void buildStrategyList(); 
    protected abstract void doPostSteps(); 
    
	protected  void iterateSObjectRecords()
	{
		List<SObject> targetSObjectList = (!this.triggerWrapper.isDelete) ? this.triggerWrapper.newSObjectList : this.triggerWrapper.oldSObjectList;
		if ((strategyList == null) || strategyList.isEmpty())
		{
			System.debug(LoggingLevel.WARN, targetSObjectList[0].getSObjectType().getDescribe().getName() + ' Trigger has no Strategies to execute');
			return; 
		}

		for (SObject currentSObject : targetSObjectList) { iterateStrategies(currentSObject); }
	}

	protected  virtual void iterateStrategies(SObject currentSObject)
	{
		// oldSObject SHOULD get a value IF and ONLY IF this.triggerWrapper.isUpdate.
		SObject oldSObject = ((this.triggerWrapper.isUpdate) && (currentSObject.id != null)) ? getOld (currentSObject.id) : null;
		
		for (UTIL_TriggerStrategyInterface strategy : strategyList) 
		{ 
			if (!strategy.execute(currentSObject, oldSObject)) { break; } 
		}
	}
	
	
}