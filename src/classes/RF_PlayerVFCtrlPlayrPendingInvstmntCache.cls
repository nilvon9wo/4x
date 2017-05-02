public with sharing class RF_PlayerVFCtrlPlayrPendingInvstmntCache 
{
	RF_PlayerPendingInvestmentDao playerPendingInvestmentDao;
	
	public RF_PlayerVFCtrlPlayrPendingInvstmntCache(RF_PlayerPendingInvestmentDao playerPendingInvestmentDao)
	{
		this.playerPendingInvestmentDao = playerPendingInvestmentDao;
	}
	
	public RF_PlayerVFCtrlPlayrPendingInvstmntCache() { this( new RF_PlayerPendingInvestmentDao()); }
	
	Map<Id, List<Player_Pending_Investment__c>> playerPendingInvestmentListByPlayerIdMap;
	
	public List<Player_Pending_Investment__c> getPlayerList(Id playerId)
	{
		if (playerPendingInvestmentListByPlayerIdMap == null) { playerPendingInvestmentListByPlayerIdMap = new Map<Id, List<Player_Pending_Investment__c>>(); }
		
		if (playerPendingInvestmentListByPlayerIdMap.get(playerId) == null)
		{
			playerPendingInvestmentListByPlayerIdMap.put(playerId, playerPendingInvestmentDao.getList(playerId)); 
		}
		
		return playerPendingInvestmentListByPlayerIdMap.get(playerId);
	} 

	public void remove(Id playerId)
	{
		playerPendingInvestmentListByPlayerIdMap.remove(playerId); 
	}
	
	
}