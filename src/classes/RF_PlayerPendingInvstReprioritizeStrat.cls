public with sharing class RF_PlayerPendingInvstReprioritizeStrat  extends UTIL_TriggerStrategyAbstract  
{
	public override Boolean execute (SObject currentSObject, SObject oldSObject)
	{
		Player_Pending_Investment__c triggerPlayerPendingInvestment = (Player_Pending_Investment__c) currentSObject;

		Map<Id, Map<Decimal, Player_Pending_Investment__c>> databasePendingInvestmentByPriorityByPlayerMap = RF_PlayerPendingInvestmentTriggerHandler.databasePendingInvestmentByPriorityByPlayerMap; 
	
		Id 	    playerId        = triggerPlayerPendingInvestment.player__c;

		if (
				   (databasePendingInvestmentByPriorityByPlayerMap == null)
				|| (databasePendingInvestmentByPriorityByPlayerMap.isEmpty())
				|| (!databasePendingInvestmentByPriorityByPlayerMap.containsKey(playerId))
		   ) 
		 { return true; } // Nothing to do here.

		for (Player_Pending_Investment__c databasePlayerPendingInvestment : databasePendingInvestmentByPriorityByPlayerMap.get(playerId).values())
		{
			if (databasePlayerPendingInvestment.priority__c >=  triggerPlayerPendingInvestment.priority__c) 	// We don't care we create or widen gaps, only that we push the priority down. 
			{
				databasePlayerPendingInvestment.priority__c += 1;
				RF_PlayerPendingInvestmentTriggerHandler.updatePlayerPendingInvestment(databasePlayerPendingInvestment);
			} 
			
		}
		
		return true;
	} 

}