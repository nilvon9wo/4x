public with sharing class RF_PlayerVFCtrlPlayerInvestmentCache 
{
	RF_PlayerInvestmentDao playerInvestmentDao;
	
	public RF_PlayerVFCtrlPlayerInvestmentCache(RF_PlayerInvestmentDao playerInvestmentDao) { this.playerInvestmentDao = playerInvestmentDao; }
	public RF_PlayerVFCtrlPlayerInvestmentCache() { this( new RF_PlayerInvestmentDao()); }
	
	// -----------------------------------------------------------------------------------------------------------------------
	
	
	private Map<Id, List<Player_Investment__c>> playerInvestmentListByPlayerIdMap;
	
	public List<Player_Investment__c> getPlayerList(Id playerId)
	{
		if (playerInvestmentListByPlayerIdMap == null) { playerInvestmentListByPlayerIdMap = new Map<Id, List<Player_Investment__c>>(); }
		
		if (playerInvestmentListByPlayerIdMap.get(playerId) == null)
		{
			playerInvestmentListByPlayerIdMap.put(playerId, playerInvestmentDao.getList(playerId));
		}
		
		return playerInvestmentListByPlayerIdMap.get(playerId);
	}
	
	private Map<Id, Boolean> hasRearchCenterByPlayerMap;
	
	public Boolean getHasResearchCenter(Id playerId)
	{ 
		if (hasRearchCenterByPlayerMap == null) { hasRearchCenterByPlayerMap = new Map<Id, Boolean>(); }
		
		if (hasRearchCenterByPlayerMap.get(playerId) != null) { return hasRearchCenterByPlayerMap.get(playerId); }
		
		hasRearchCenterByPlayerMap.put(playerId, false);
		for (Player_Investment__c playerInvestment : getPlayerList(playerId))
		{
			if (playerInvestment.investment__r.name == RF_InvestmentBuildingHelper.RESEARCH_CENTER)
			{
				hasRearchCenterByPlayerMap.put(playerId, true);
				break;
			}
		}
		
		return hasRearchCenterByPlayerMap.get(playerId);
	}
}