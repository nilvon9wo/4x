// Helper class to reduce need for looking up record type Ids multiple times.
// @see: http://salesforce.stackexchange.com/questions/11968/what-would-be-the-best-approach-to-get-the-recordtype-id
public class UTIL_RecordTypesCache 
{
	UTIL_RecordTypesDoa recordTypesDoa;
	
	public UTIL_RecordTypesCache(UTIL_RecordTypesDoa recordTypesDoa) { this.recordTypesDoa = recordTypesDoa; }
	public UTIL_RecordTypesCache() { this(new UTIL_RecordTypesDoa()); }
	
	
	// Build a local cache so that we don't request this multiple times
	private Map<Schema.SObjectType,Map<String,Id>> 	   recordTypeIdByDeveloperNameCache = new Map<Schema.SObjectType,Map<String,Id>>();
	private Map<Schema.SObjectType,Map<Id,RecordType>> recordTypesByIdCache			    = new Map<Schema.SObjectType,Map<Id,RecordType>>(); 
	
	// Returns a map of active, user-available RecordType IDs for a given SObjectType,
	// keyed by each RecordType's unique, unchanging DeveloperName 
	public Map<String, Id> getRecordTypeIdsByDeveloperNameMap( Schema.SObjectType token ) 
	{
	    if (
	    		   (recordTypeIdByDeveloperNameCache == null)
	    		|| (recordTypeIdByDeveloperNameCache.get(token) == null)
	    		|| (recordTypeIdByDeveloperNameCache.get(token).isEmpty())
	       )	
	       { 
	       		buildCaches ( token ); 				// If not, build a map of RecordTypeIds keyed by DeveloperName
	       }										 
	    return recordTypeIdByDeveloperNameCache.get(token);
	}

	// Returns a map of active, user-available RecordType IDs for a given SObjectType,
	// keyed by each RecordType's unique, unchanging DeveloperName 
	public Map<Id,RecordType> getRecordTypesByIdMap( Schema.SObjectType token ) 
	{
	    if (
	    		   (recordTypesByIdCache == null)
	    		|| (recordTypesByIdCache.get(token) == null)
	    		|| (recordTypesByIdCache.get(token).isEmpty())
	       )	
	       { 
	       		buildCaches ( token ); 				// If not, build a map of RecordTypeIds keyed by DeveloperName
	       }										 
	    return recordTypesByIdCache.get(token);
	}
	
	private void buildCaches ( Schema.SObjectType token )
	{
        Map<String, Id>    recordTypeIdByDevNameMap = recordTypeIdByDeveloperNameCache.get(token);                  // Do we already have a result?
		Map<Id,RecordType> recordTypeByIdMap 		= recordTypesByIdCache.get(token);	
	    if (recordTypeIdByDevNameMap == null)																	// If not, build a map of RecordTypeIds keyed by DeveloperName 
	    {
	    	recordTypeIdByDevNameMap = new Map<String, Id>();
	    	recordTypeIdByDeveloperNameCache.put(token, recordTypeIdByDevNameMap);

	    	recordTypeByIdMap		 = new Map<Id,RecordType>();
	    	recordTypesByIdCache.put (token, recordTypeByIdMap);
	    }

		List<RecordType> recordTypeList = recordTypesDoa.getList(token);

	    for (RecordType recordType : (List<RecordType>) recordTypeList) 								// Loop through all of the Record Types we found,
	    {  																							//      and weed out those that are unavailable to the Running User
			//        if (recordTypeInfoMap.get(recordType.Id).isAvailable()) -- not used because we do NOT want this to be User sensitive. 									 
	        {																						// This RecordType IS available to the running user,
	            recordTypeIdByDevNameMap.put(String.valueOf(recordType.get('DeveloperName')),recordType.Id);	//      so add it to our map of RecordTypeIds by DeveloperName
	            recordTypeByIdMap.put(recordType.Id, recordType);										//      so add it to our map of RecordTypeIds by DeveloperName
		    }
		}
	}
}