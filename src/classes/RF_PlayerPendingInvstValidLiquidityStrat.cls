public with sharing class RF_PlayerPendingInvstValidLiquidityStrat  extends UTIL_TriggerStrategyAbstract 
{
	RF_PlayerPendingInvstTrigPlayerCache playerCache;

	public RF_PlayerPendingInvstValidLiquidityStrat(RF_PlayerPendingInvstTrigPlayerCache playerCache) { this.playerCache = playerCache; }
	public RF_PlayerPendingInvstValidLiquidityStrat() 												  { this(new RF_PlayerPendingInvstTrigPlayerCache()); }
	
	// -------------------------------------------------------------------------------------------
	
	public override Boolean execute (SObject currentSObject, SObject oldSObject)
	{
		Player_Pending_Investment__c playerPendingInvestment = (Player_Pending_Investment__c) currentSObject;
		
		if (playerPendingInvestment.ignore_liquidity__c) { return true; }			// Player doesn't care about current finances, so don't check this; just que the investment.
		
		Player__c player     = playerCache.get(playerPendingInvestment.player__c); 
		Decimal   liquidity  = player.wealth__c;
		Decimal   upfrontCost = playerPendingInvestment.upfront_cost__c; 
		
		// TBD: Should monthlyCost matter here?
		
		if (liquidity < upfrontCost)
		{
			playerPendingInvestment.addError(
						player.company_name__c + ' has only ' + RF_CurrencyHelper.getEuroString(liquidity) + ', which is insufficent funding.'
						+ '  To order anyway, check \'Ignore Liquidity\' and click the \'Order\' button again.');
			return false;
		}
		
		return true;
	}
}