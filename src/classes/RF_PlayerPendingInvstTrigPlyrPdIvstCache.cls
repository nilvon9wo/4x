public with sharing class RF_PlayerPendingInvstTrigPlyrPdIvstCache 
{
	public List<Player_Pending_Investment__c> getList(Map<Id, Decimal> newMinPriorityByPlayerMap)
	{
		String queryString =  ' SELECT id, player__c, priority__c '
							+ ' FROM Player_Pending_Investment__c '
							+ ' WHERE ';

		List<Id> playerIdList = new List<Id>(newMinPriorityByPlayerMap.keySet());
		
		for (Integer i=1; i<=playerIdList.size(); i++)
		{
			Id playerId = playerIdList[i-1];
			if (playerId == null) { continue; }								// This should NEVER happen. 

			if (i > 1) 			  { queryString += ' OR '; }
			
			Double priority = (double) newMinPriorityByPlayerMap.get(playerId);
			queryString += '('
						 + '     ( player__c    = \'' + playerId + '\')'
						 + ' AND ( priority__c >= '   + priority +   ')'
						 + ')';
		}							
							
		return (List<Player_Pending_Investment__c>) Database.query(queryString);
	}
}