public class RF_PlayerPendingInvestmentTriggerHandler extends UTIL_TriggerHandlerAbstract
{
	private RF_PlayerPendingInvstTrigPlyrPdIvstCache playerPreviousPendingInvestmentCache;

	public RF_PlayerPendingInvestmentTriggerHandler (UTIL_TriggerWrapper triggerWrapper, RF_PlayerPendingInvstTrigPlyrPdIvstCache playerPreviousPendingInvestmentCache)
	{ 
		super(triggerWrapper); 
		this.playerPreviousPendingInvestmentCache = playerPreviousPendingInvestmentCache;
	} 
	
	public RF_PlayerPendingInvestmentTriggerHandler (UTIL_TriggerWrapper triggerWrapper){ this(triggerWrapper, new RF_PlayerPendingInvstTrigPlyrPdIvstCache()); } 
	
	// -------------------------------------------------------------------------------------------------------------------------------------------------------
	
	public static Set<Id> 		playerIdSet;  
	public static Set<Id> 		investmentIdSet;
	
	public static Map<Id, Decimal> newMinPriorityByPlayerMap { get; private set; }
	
	public static Map<Id, Map<Decimal, Player_Pending_Investment__c>> triggerPendingInvestmentByPriorityByPlayerMap  		 { get; private set; }
	public static Map<Id, Map<Decimal, Player_Pending_Investment__c>> databasePendingInvestmentByPriorityByPlayerMap 		 { get; private set; }
	
	private static Map<Id, Player_Pending_Investment__c> playerPendingInvestmentsToUpdateMap;
	public  static void updatePlayerPendingInvestment(Player_Pending_Investment__c playerPendingInvestment)
	{
		if (playerPendingInvestmentsToUpdateMap == null) { playerPendingInvestmentsToUpdateMap = new Map<Id, Player_Pending_Investment__c>(); }
			
		playerPendingInvestmentsToUpdateMap.put(playerPendingInvestment.id, playerPendingInvestment);
	} 
	
	protected override void doPreSteps()			
	{ 
		// We need to populate these NOW so we can bulkify our SOQL queries; However, we will be "lazy" about doing the queries themselves. 
		playerIdSet 	= UTIL_SetHelper.buildIdSet (triggerWrapper.newSObjectList, 'player__c',     false);
		investmentIdSet = UTIL_SetHelper.buildIdSet (triggerWrapper.newSObjectList, 'investment__c', false);
		
		triggerPendingInvestmentByPriorityByPlayerMap  = RF_PlayerPendingInvestmentPriorityHelper.buildPendingInvestmentByPriorityByPlayerMap(triggerWrapper.newSObjectList);
		newMinPriorityByPlayerMap                      = RF_PlayerPendingInvestmentPriorityHelper.buildNewMinPriorityByPlayerMap(triggerPendingInvestmentByPriorityByPlayerMap);	
	
		List<Player_Pending_Investment__c> alreadyPendingInvestmentList = playerPreviousPendingInvestmentCache.getList(newMinPriorityByPlayerMap);
		
		if ((alreadyPendingInvestmentList != null) && (!alreadyPendingInvestmentList.isEmpty()))
		{
			databasePendingInvestmentByPriorityByPlayerMap = RF_PlayerPendingInvestmentPriorityHelper.buildPendingInvestmentByPriorityByPlayerMap(alreadyPendingInvestmentList);
		}
	} 
	
    protected override void buildStrategyList()	  
    { 
    	this.strategyList = new List<UTIL_TriggerStrategyInterface>();
    	
    	// Before Insert Strategies
    	if (triggerWrapper.isBefore && (triggerWrapper.isInsert))		
    	{
    		this.strategyList = new List<UTIL_TriggerStrategyInterface>
    		{ 
    			new RF_PlayerPendingInvstTranscribeValsStrat(),	// Copy values from investment into Player Pending Investment; this must happen first to enable validation against these values.
    			new RF_PlayerPendingInvstValidLiquidityStrat(),	// Player Pending Investment Conditional Validate Liquidity Strategy: If player has not opt'd to ignore, checks if player can afford investment before que'ing

    			// TBD: Should we check, again, whether this Investment is available to the player?  Or should we consider the order form's check to be sufficent?

    			new RF_PlayerPendingInvstReprioritizeStrat()	// Revalues lesser priorities if priority has already been assigned

    		}; 
    	}
    }  

    protected override void doPostSteps()			
    { 
    	if ((playerPendingInvestmentsToUpdateMap != null) && (!playerPendingInvestmentsToUpdateMap.isEmpty()))
    	{
    		UTIL_ResultListWrapper resultListWrapper = UTIL_SObjectDMLHelper.doUpdate(playerPendingInvestmentsToUpdateMap.values());
    	}
    }	
	
}