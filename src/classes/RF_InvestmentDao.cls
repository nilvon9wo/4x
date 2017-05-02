public with sharing class RF_InvestmentDao 
{
	public List<Investment__c> getList(Set<Id> investmentIdSet)
	{
		return [
					SELECT id, name, 
						description__c, upfront_cost__c, monthly_cost__c, development_manhours__c	 
					FROM   Investment__c
					WHERE  id IN :investmentIdSet
			   ];
		
	}

	public List<Investment__c> getAvailableList(Id recordTypeId, Set<Id> enabledInvestmentIdSet)
	{
		return [
					SELECT id, name, 
						description__c, upfront_cost__c, monthly_cost__c, development_manhours__c	 
					FROM   Investment__c
					WHERE  recordTypeId = :recordTypeId
						AND id IN :enabledInvestmentIdSet
			   ];
	}
	
}