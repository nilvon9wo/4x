public with sharing class RF_PlayerPendingInvestmentPriorityHelper 
{
	public static Map<Id, Map<Decimal, Player_Pending_Investment__c>> buildPendingInvestmentByPriorityByPlayerMap (List<Player_Pending_Investment__c> playerPendingInvestmentList)
	{
		Map<Id, Map<Decimal, Player_Pending_Investment__c>> pendingInvestmentByPriorityByPlayerMap = new Map<Id, Map<Decimal, Player_Pending_Investment__c>>();
		
		for (Player_Pending_Investment__c playerPendingInvestment : playerPendingInvestmentList)
		{
			Id playerId = playerPendingInvestment.player__c;
			if (pendingInvestmentByPriorityByPlayerMap.get(playerId) == null) { pendingInvestmentByPriorityByPlayerMap.put(playerId, new Map<Decimal, Player_Pending_Investment__c>()); }
			
			Decimal priority = playerPendingInvestment.priority__c;
			if (pendingInvestmentByPriorityByPlayerMap.get(playerId).get(priority) != null)
			{
				playerPendingInvestment.addError('Priority duplication in unsupported context; cannot resolve automatically.');	
				pendingInvestmentByPriorityByPlayerMap.get(playerId).get(priority).addError('Priority duplication in unsupported context; cannot resolve automatically.');	
			} 
			else
			{
				pendingInvestmentByPriorityByPlayerMap.get(playerId).put(priority, playerPendingInvestment);
			}
		}

		return pendingInvestmentByPriorityByPlayerMap;
	}
	
	public static Map<Id, Decimal> buildNewMinPriorityByPlayerMap(Map<Id, Map<Decimal, Player_Pending_Investment__c>> triggerPendingInvestmentByPriorityByPlayerMap)
	{
		Map<Id, Decimal> newMinPriorityByPlayerMap = new Map<Id, Decimal>();

		for (Id playerId : triggerPendingInvestmentByPriorityByPlayerMap.keySet())
		{
			Set<Decimal>  prioritySet  = triggerPendingInvestmentByPriorityByPlayerMap.get(playerId).keySet();
			List<Decimal> priorityList = new List<Decimal>(prioritySet);
						  priorityList.sort();
		 
		 	newMinPriorityByPlayerMap.put(playerId, priorityList[0]);
		}
		return newMinPriorityByPlayerMap;
	}
}