public with sharing class UTIL_SetHelper 
{
	public static Set<Id> buildIdSet (List<SObject> sobjectList, String fieldName, Boolean includeNull)
	{
		Set<Id> idSet = new Set<Id>();
		for (SObject currentSObject : sObjectList)
		{
			Object fieldValue = currentSObject.get(fieldName);
			if (includeNull || (fieldValue != null))
			{
				idSet.add((Id) currentSObject.get(fieldName));
			}
		}
		return idSet;
	} 
}