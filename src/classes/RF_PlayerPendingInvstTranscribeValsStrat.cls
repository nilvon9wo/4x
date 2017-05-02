public with sharing class RF_PlayerPendingInvstTranscribeValsStrat extends UTIL_TriggerStrategyAbstract 
{
	RF_PlayerPendingInvstTrigInvestmentCache investmentCache;

	public RF_PlayerPendingInvstTranscribeValsStrat(RF_PlayerPendingInvstTrigInvestmentCache investmentCache) { this.investmentCache = investmentCache; }
	public RF_PlayerPendingInvstTranscribeValsStrat() 														  { this(new RF_PlayerPendingInvstTrigInvestmentCache()); }
	
	// ------------------------------------------------------------------------------------------
	 
	
	public override Boolean execute (SObject currentSObject, SObject oldSObject)
	{
		Player_Pending_Investment__c playerPendingInvestment = (Player_Pending_Investment__c) currentSObject;

		Investment__c investment = investmentCache.get(playerPendingInvestment.investment__c);
		
		playerPendingInvestment.upfront_cost__c = investment.upfront_cost__c;
		playerPendingInvestment.monthly_cost__c = investment.monthly_cost__c;
		
		return true;
	} 


}