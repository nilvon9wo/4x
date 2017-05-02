public with sharing class UTIL_MapHelper 
{
	public static Map<Object, Object> buildMap (List<SObject> sobjectList, String keyFieldName, String valueFieldName, Boolean includeNullAsKey)
	{
		Map<Object, Object> valueObjectByKeyObjectMap = new Map<Object, Object>();
		for (SObject currentSObject : sObjectList)
		{
			Object keyObject = currentSObject.get(keyFieldName);
			if (includeNullAsKey || (keyObject != null))
			{
				valueObjectByKeyObjectMap.put(currentSObject.get(keyFieldName), currentSObject.get(valueFieldName));
			}
		}
		return valueObjectByKeyObjectMap;
	}

	public static Map<Id, Object> buildMapById (List<SObject> sobjectList, String valueFieldName)
	{
		Map<Object, Object> valueObjectByIdMap = buildMap(sObjectList, 'id', valueFieldName, false);
		return UTIL_MapCastHelper.castObjectMapToIdMap(valueObjectByIdMap);
	}
	
}