public with sharing class RF_PlayerPendingInvestmentsVFCompCtrl  extends VF_VirtualVFCompCtrlBase 
{
	RF_PlayerVFCtrlPlayrPendingInvstmntCache playerPendingInvestmentCache;

	public RF_PlayerPendingInvestmentsVFCompCtrl(RF_PlayerVFCtrlPlayrPendingInvstmntCache playerPendingInvestmentCache)
	{
		this.playerPendingInvestmentCache = playerPendingInvestmentCache;
		
		key = 'playerPendingInvestments'; 
	}

	public RF_PlayerPendingInvestmentsVFCompCtrl() { this(new RF_PlayerVFCtrlPlayrPendingInvstmntCache()); }

	public Player__c ctrlPlayer
	{
		get
		{
			return (Player__c) vfPageCtrl.getPageVariable('player');
		}
		set;
	} 

	// --------------------------------------------------------------------------------

	public List<Player_Pending_Investment__c> playerPendingInvestmentList
	{
		get
		{
			if (playerPendingInvestmentList == null) { playerPendingInvestmentList = playerPendingInvestmentCache.getPlayerList(ctrlPlayer.id); }
			return playerPendingInvestmentList;
		}
		set;
	}	

	public Map<String, Map<String, RF_PlayerPendingInvestmentListWrapper>> playerPendingInvestmentListWrapperByInvestmentNameMapByRecordTypeNameMap
	{
		get
		{
			if (playerPendingInvestmentListWrapperByInvestmentNameMapByRecordTypeNameMap == null)
			{
				playerPendingInvestmentListWrapperByInvestmentNameMapByRecordTypeNameMap = new Map<String, Map<String, RF_PlayerPendingInvestmentListWrapper>>();
				for (Player_Pending_Investment__c playerPendingInvestment : playerPendingInvestmentList)
				{
					String recordTypeName = RF_InvestmentRecordTypeHelper.getDevName(playerPendingInvestment.investment__r.recordTypeId);
					if (!playerPendingInvestmentListWrapperByInvestmentNameMapByRecordTypeNameMap.containsKey(recordTypeName))
					{
						playerPendingInvestmentListWrapperByInvestmentNameMapByRecordTypeNameMap.put(recordTypeName, new Map<String, RF_PlayerPendingInvestmentListWrapper>());
					}
					
					String investmentName = playerPendingInvestment.investment__r.name;
					if(!playerPendingInvestmentListWrapperByInvestmentNameMapByRecordTypeNameMap.get(recordTypeName).containsKey(investmentName))
					{
						playerPendingInvestmentListWrapperByInvestmentNameMapByRecordTypeNameMap.get(recordTypeName).put(investmentName, new RF_PlayerPendingInvestmentListWrapper(playerPendingInvestment));
					}
					else
					{
						playerPendingInvestmentListWrapperByInvestmentNameMapByRecordTypeNameMap.get(recordTypeName).get(investmentName).add(playerPendingInvestment);
					}
				}	
			}
			return playerPendingInvestmentListWrapperByInvestmentNameMapByRecordTypeNameMap;
		}
		set;
	}

	// --------------------------------------------------------------------------------
	
	public List<RF_PlayerPendingInvestmentListWrapper> buildingList   { get { return getSortedPlayerPendingInvestmentList(RF_InvestmentRecordTypeHelper.RECORDTYPE_BUILDING  ); } private set; }
	public List<RF_PlayerPendingInvestmentListWrapper> technologyList { get { return getSortedPlayerPendingInvestmentList(RF_InvestmentRecordTypeHelper.RECORDTYPE_TECHNOLOGY); } private set; }
	public List<RF_PlayerPendingInvestmentListWrapper> unitList       { get { return getSortedPlayerPendingInvestmentList(RF_InvestmentRecordTypeHelper.RECORDTYPE_UNIT      ); } private set; }
	
	private List<RF_PlayerPendingInvestmentListWrapper> getSortedPlayerPendingInvestmentList(String recordTypeName)
	{
		Map<String, RF_PlayerPendingInvestmentListWrapper> playerPendingInvestmentListWrapperByInvestmentName = playerPendingInvestmentListWrapperByInvestmentNameMapByRecordTypeNameMap.get(recordTypeName);
		
		if ((playerPendingInvestmentListWrapperByInvestmentName == null) || (playerPendingInvestmentListWrapperByInvestmentName.isEmpty()))
		{
			return null;
		}

		List<RF_PlayerPendingInvestmentListWrapper> investmentListWrapper = playerPendingInvestmentListWrapperByInvestmentName.values();
				  		                  		    investmentListWrapper.sort();
				                  	 		 return investmentListWrapper;
	}

	// --------------------------------------------------------------------------------
	
	public String getNow()
	{
		return (System.now().format()).substring(11);
	}
}