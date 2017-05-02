public with sharing class RF_PlayerPendingInvstTrigInvestmentCache 
{
	RF_InvestmentDao 			investmentDao;
	
	public RF_PlayerPendingInvstTrigInvestmentCache (RF_InvestmentDao investmentDao) { this.investmentDao 	= investmentDao; }
	public RF_PlayerPendingInvstTrigInvestmentCache () 								 { this (new RF_InvestmentDao()); }

	Map<Id, Investment__c> investmentByIdMap;
	
	public Investment__c get(Id investmentId)
	{
		if ((investmentByIdMap != null) && (investmentByIdMap.get(investmentId) != null)) { return investmentByIdMap.get(investmentId); }

		Set<Id> investmentIdSet = RF_PlayerPendingInvestmentTriggerHandler.investmentIdSet;				// This should NEVER be null.
				investmentByIdMap = new Map<Id, Investment__c>(investmentDao.getList(investmentIdSet)); 	// This should NEVER have values from the current Trigger's investmentIdSet.
		 return investmentByIdMap.get(investmentId); 
	}
}