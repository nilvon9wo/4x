public with sharing class RF_PlayerPendingInvstTrigPlayerCache
{
	RF_PlayerDao playerDao;
	
	public RF_PlayerPendingInvstTrigPlayerCache(RF_PlayerDao playerDao) {this.playerDao = playerDao;}
	public RF_PlayerPendingInvstTrigPlayerCache() 						{ this(new RF_PlayerDao()); }
	
	Map<Id, Player__c> playerByIdMap;
	
	public Player__c get(Id playerId)
	{
		if ((playerByIdMap != null) && (playerByIdMap.get(playerId) != null)) { return playerByIdMap.get(playerId); }

		Set<Id> playerIdSet = RF_PlayerPendingInvestmentTriggerHandler.playerIdSet;		// This should NEVER be null.
				playerByIdMap = new Map<Id, Player__c>(playerDao.getList(playerIdSet)); 	// This should NEVER have values from the current Trigger's playerIdSet.
		 return playerByIdMap.get(playerId); 
	}
}