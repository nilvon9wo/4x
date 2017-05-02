public with sharing class RF_PlayerInvestmentOverviewVFCompCtrl extends VF_VirtualVFCompCtrlBase 
{
	RF_PlayerVFCtrlPlayerInvestmentCache playerInvestmentCache;

	public RF_PlayerInvestmentOverviewVFCompCtrl(RF_PlayerVFCtrlPlayerInvestmentCache playerInvestmentCache)
	{
		this.playerInvestmentCache = playerInvestmentCache;
		key = 'playerInvestmentOverview';
	} 

	public RF_PlayerInvestmentOverviewVFCompCtrl() { this(new RF_PlayerVFCtrlPlayerInvestmentCache()); }
	
	// ----------------------------------------------------------------------------------
		
	public Player__c ctrlPlayer
	{
		get
		{
			return (Player__c) vfPageCtrl.getPageVariable('player');
		}
		private set;
	} 

	public List<Player_Investment__c> playerInvestmentList
	{
		get
		{
			if (playerInvestmentList == null)
			{
				playerInvestmentList = playerInvestmentCache.getPlayerList(ctrlPlayer.id);
			}
			return playerInvestmentList;
		}
		private set;
	}
	
	public Map<String, Map<String, RF_PlayerInvestmentListWrapper>> playerInvestmentListWrapperByInvestmentNameMapByRecordTypeNameMap
	{
		get
		{
			if (playerInvestmentListWrapperByInvestmentNameMapByRecordTypeNameMap == null)
			{
				playerInvestmentListWrapperByInvestmentNameMapByRecordTypeNameMap = new Map<String, Map<String, RF_PlayerInvestmentListWrapper>>();
				for (Player_Investment__c playerInvestment : playerInvestmentList)
				{
					String recordTypeName = RF_InvestmentRecordTypeHelper.getDevName(playerInvestment.investment__r.recordTypeId);
					if (!playerInvestmentListWrapperByInvestmentNameMapByRecordTypeNameMap.containsKey(recordTypeName))
					{
						playerInvestmentListWrapperByInvestmentNameMapByRecordTypeNameMap.put(recordTypeName, new Map<String, RF_PlayerInvestmentListWrapper>());
					}
					
					String investmentName = playerInvestment.investment__r.name;
					if(!playerInvestmentListWrapperByInvestmentNameMapByRecordTypeNameMap.get(recordTypeName).containsKey(investmentName))
					{
						playerInvestmentListWrapperByInvestmentNameMapByRecordTypeNameMap.get(recordTypeName).put(investmentName, new RF_PlayerInvestmentListWrapper(playerInvestment));
					}
					else
					{
						playerInvestmentListWrapperByInvestmentNameMapByRecordTypeNameMap.get(recordTypeName).get(investmentName).add(playerInvestment);
					}
				}	
			}
			return playerInvestmentListWrapperByInvestmentNameMapByRecordTypeNameMap;
		}
		set;
	}

	public List<RF_PlayerInvestmentListWrapper> buildingList   { get { return getSortedPlayerInvestmentList(RF_InvestmentRecordTypeHelper.RECORDTYPE_BUILDING  ); } private set; }
	public List<RF_PlayerInvestmentListWrapper> technologyList { get { return getSortedPlayerInvestmentList(RF_InvestmentRecordTypeHelper.RECORDTYPE_TECHNOLOGY); } private set; }
	public List<RF_PlayerInvestmentListWrapper> unitList       { get { return getSortedPlayerInvestmentList(RF_InvestmentRecordTypeHelper.RECORDTYPE_UNIT      ); } private set; }
	
	private List<RF_PlayerInvestmentListWrapper> getSortedPlayerInvestmentList(String recordTypeName)
	{
		Map<String, RF_PlayerInvestmentListWrapper> playerInvestmentListWrapperByInvestmentName = playerInvestmentListWrapperByInvestmentNameMapByRecordTypeNameMap.get(recordTypeName);
		
		List<RF_PlayerInvestmentListWrapper> investmentListWrapper = playerInvestmentListWrapperByInvestmentName.values();
					                  		 investmentListWrapper.sort();
					                  return investmentListWrapper;
	}

}