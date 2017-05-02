public with sharing class RF_PlayerOrderFormVFCtrlInvestmentCache 
{
	RF_InvestmentDao 						 investmentDao;
	RF_InvestmentRequirementDao 			 investmentRequirementDao; 
	RF_PlayerVFCtrlPlayrPendingInvstmntCache playerPendingInvestmentCache;
	
	public RF_PlayerOrderFormVFCtrlInvestmentCache 
		(
			RF_InvestmentDao 						 investmentDao, 
			RF_InvestmentRequirementDao 			 investmentRequirementDao,
			RF_PlayerVFCtrlPlayrPendingInvstmntCache playerPendingInvestmentCache
		)
	{
		this.investmentDao 				  = investmentDao;
		this.investmentRequirementDao     = investmentRequirementDao;
		this.playerPendingInvestmentCache = playerPendingInvestmentCache;
	}
	
	public RF_PlayerOrderFormVFCtrlInvestmentCache () { this (new RF_InvestmentDao(), new RF_InvestmentRequirementDao(), new RF_PlayerVFCtrlPlayrPendingInvstmntCache()); }
	
	Map<Id, Map<Id, List<Investment__c>>> availableInvestmentListByRecordTypeByPlayerIdMap;
	
	public  List<Investment__c> getAvailableList(Id playerId, Id investmentRecordTypeId, Set<Id> possessedInvestmentIdSet)
	{
		if (availableInvestmentListByRecordTypeByPlayerIdMap == null) 				{ availableInvestmentListByRecordTypeByPlayerIdMap = new Map<Id, Map<Id, List<Investment__c>>>(); }
		if (availableInvestmentListByRecordTypeByPlayerIdMap.get(playerId) == null) { availableInvestmentListByRecordTypeByPlayerIdMap.put(playerId, new Map<Id, List<Investment__c>>()); }

		if (availableInvestmentListByRecordTypeByPlayerIdMap.get(playerId).get(investmentRecordTypeId) == null)
		{
			Set<Id>             enabledInvestmentIdSet  = investmentRequirementDao.getEnabledInvestmentIdSet(possessedInvestmentIdSet);
			
			if (RF_InvestmentRecordTypeHelper.isTechnology(investmentRecordTypeId))		// If player already has technology,
			{
				enabledInvestmentIdSet.removeAll(possessedInvestmentIdSet);				// Exclude from available to [re]invest in.
				
				Set<Id> pendingInvestmentIdSet = buildPendingInvestmentIdSet(playerId); 
				enabledInvestmentIdSet.removeAll(pendingInvestmentIdSet);				// Also, exclude technologies already pending. 
			}
			
			List<Investment__c> availableInvestmentList = investmentDao.getAvailableList(investmentRecordTypeId, enabledInvestmentIdSet);
								availableInvestmentListByRecordTypeByPlayerIdMap.get(playerId).put(investmentRecordTypeId, availableInvestmentList);
		}

		return availableInvestmentListByRecordTypeByPlayerIdMap.get(playerId).get(investmentRecordTypeId);
	}
	
	public void remove(Id playerId)
	{
		playerPendingInvestmentCache.remove(playerId);
		availableInvestmentListByRecordTypeByPlayerIdMap.remove(playerId);
	}
	
	private Set<Id> buildPendingInvestmentIdSet (Id playerId)
	{
		List<Player_Pending_Investment__c> playerPendingInvestmentList = playerPendingInvestmentCache.getPlayerList(playerId);
		return UTIL_SetHelper.buildIdSet (playerPendingInvestmentList, 'investment__c', false);
	}

}