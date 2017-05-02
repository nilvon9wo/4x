public with sharing class RF_InvestmentRecordTypeHelper 
{
	private static final UTIL_RecordTypesCache RECORD_TYPE_CACHE          = new UTIL_RecordTypesCache();
	public  static final Map<Id,RecordType>    RECORD_TYPE_BY_ID_MAP      = RECORD_TYPE_CACHE.getRecordTypesByIdMap(Investment__c.SObjectType);
	public  static final Map<String, Id>       RECORD_TYPE_ID_BY_NAME_MAP = RECORD_TYPE_CACHE.getRecordTypeIdsByDeveloperNameMap(Investment__c.SObjectType);
	
	public  static final String RECORDTYPE_BUILDING      = 'Building';
	public  static final String RECORDTYPE_TECHNOLOGY    = 'Technology';
	public  static final String RECORDTYPE_UNIT 		 = 'Unit';
	
	public  static final String RECORDTYPE_BUILDING_ID   = RECORD_TYPE_ID_BY_NAME_MAP.get(RECORDTYPE_BUILDING);
	public  static final String RECORDTYPE_TECHNOLOGY_ID = RECORD_TYPE_ID_BY_NAME_MAP.get(RECORDTYPE_TECHNOLOGY);
	public  static final String RECORDTYPE_UNIT_ID 	     = RECORD_TYPE_ID_BY_NAME_MAP.get(RECORDTYPE_UNIT);
	
	public static String getDevName(Id recordTypeId)
	{
		return RECORD_TYPE_BY_ID_MAP.get(recordTypeId).developerName;
	}
	
	public static Boolean isBuilding  (String value) { return isMatchForIdOrDevName(value, RECORDTYPE_BUILDING); }
	public static Boolean isTechnology(String value) { return isMatchForIdOrDevName(value, RECORDTYPE_TECHNOLOGY); }
	public static Boolean isUnit      (String value) { return isMatchForIdOrDevName(value, RECORDTYPE_UNIT); }
	
	private static Boolean isMatchForIdOrDevName(String queryValue, String targetValue)
	{
		return (
					   (queryValue == targetValue)
					|| (queryValue == RECORD_TYPE_ID_BY_NAME_MAP.get(targetValue)) 
			   );
	}
}