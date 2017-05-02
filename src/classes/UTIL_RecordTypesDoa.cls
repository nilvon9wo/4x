public with sharing class UTIL_RecordTypesDoa 
{
	public List<RecordType> getList(Schema.SObjectType token)
	{
	    Schema.DescribeSObjectResult describedSObject = token.getDescribe();										// Get the Describe Result
	    String soql = 'SELECT Id, Name, DeveloperName '											    // Obtain ALL Active Record Types for the given SObjectType token
			        + 'FROM RecordType '
			        + 'WHERE SObjectType = \'' + String.escapeSingleQuotes(describedSObject.getName()) + '\' '	// (We will filter out the Record Types that are unavailable
			        + 'AND IsActive = TRUE';														// to the Running User using Schema information)

	    List<RecordType> resultList;
	    try { resultList = Database.query(soql); } 
	    catch (Exception ex) { resultList = new List<RecordType>(); }
	    
	    return resultList;
	}
}