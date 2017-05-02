/**
 *  This class exists to:
 * 		1. Improve the names of the Trigger variables
 *		2. To enable unit tests to implant values into these variables without the Trigger actually executing. 
 **/
public class UTIL_TriggerWrapper 
{
	@testVisible public Boolean 		 isExecuting 	   = null;
	@testVisible public Boolean 		 isInsert   	   = null;
	@testVisible public Boolean 		 isUpdate   	   = null;
	@testVisible public Boolean 		 isDelete   	   = null;
	@testVisible public Boolean 		 isUndelete 	   = null;
	@testVisible public Boolean 		 isBefore          = null;
	@testVisible public Boolean 		 isAfter           = null;
	@testVisible public List<sObject> 	 oldSObjectList    = null;
	@testVisible public List<sObject>	 newSObjectList    = null;
	@testVisible public Map<ID, sObject> oldSObjectByIdMap = null; 
	@testVisible public Map<ID, sObject> newSObjectByIdMap = null;
	@testVisible public Integer		  	 size			   = null;
	
	public UTIL_TriggerWrapper()
	{
		this.isExecuting 		= Trigger.isExecuting;
		this.isInsert 			= Trigger.isInsert;
		this.isUpdate 			= Trigger.isUpdate;
		this.isDelete 			= Trigger.isDelete;
		this.isUndelete 		= Trigger.isUndelete;
		this.isBefore 			= Trigger.isBefore;
		this.isAfter 			= Trigger.isAfter;
		this.oldSObjectList 	= Trigger.old;
		this.newSObjectList 	= Trigger.new;
		this.oldSObjectByIdMap 	= Trigger.oldMap;
		this.newSObjectByIdMap 	= Trigger.newMap;
		this.size 				= Trigger.size;
	}
}