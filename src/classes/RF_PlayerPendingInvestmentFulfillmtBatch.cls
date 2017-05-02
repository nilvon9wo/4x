global with sharing class RF_PlayerPendingInvestmentFulfillmtBatch implements Database.Batchable<SObject> 
{
	private RF_PlayerDao playerDao
	{
		get // To ensure this allowence for dependency injection does not result in a null value during an actual execution!
		{
			if (playerDao == null) { playerDao = new RF_PlayerDao(); }	
			return playerDao;
		}
		set;
	}  
	
	
	private RF_PlayerPendingInvestmentFulfillmtBatch(RF_PlayerDao playerDao){ this.playerDao = playerDao; }
    global  RF_PlayerPendingInvestmentFulfillmtBatch()					    { this(new RF_PlayerDao());   }
	
	// ---------------------------------------------------------------------------------------------------------
	
    global final String QUERY_STRING = ' SELECT id, investment__c,  monthly_cost__c, upfront_cost__c, priority__c '
									+ ' FROM  Player_Pending_Investment__c '
									+ ' WHERE status__c = \'' + RF_PlayerPendingInvestmentHelper.STATUS_OPEN +  '\''
									+ ' ORDER BY priority__c ASC';   


    global Database.QueryLocator start(Database.BatchableContext batchableContext)
    {
    	return Database.getQueryLocator(QUERY_STRING);
    }

	// ---------------------------------------------------------------------------------------------------------

	private List<Player__c> 				   playerList;
	private Map<Id, Object> 				   wealthByPlayerIdMap;
	private List<Player_Investment__c>		   newPlayerInvestmentToInsertList		= new List<Player_Investment__c>();
	private List<Player_Pending_Investment__c> playerPendingInvestmentToUpdateList	= new List<Player_Pending_Investment__c>();

    global void execute(Database.BatchableContext batchableContext, List<Player_Pending_Investment__c> pendingPlayerInvestmentList)
    {
		playerList  		= playerDao.getList(UTIL_SetHelper.buildIdSet(pendingPlayerInvestmentList, 'player__c', false));
        wealthByPlayerIdMap = UTIL_MapHelper.buildMapById(playerList, 'wealth__c');
   		
   		for (Player_Pending_Investment__c pendingPlayerInvestment : pendingPlayerInvestmentList)
   		{
   			if (pendingPlayerInvestment.upfront_cost__c <= ((Decimal) wealthByPlayerIdMap.get(pendingPlayerInvestment.player__c)))
   			{
   				convertToInvestment(pendingPlayerInvestment);
   			}
   		}
   		
   		updatePlayerWealth();

   		if (!newPlayerInvestmentToInsertList.isEmpty()) 
   		{ 
   			UTIL_SObjectDMLHelper.doInsert(newPlayerInvestmentToInsertList); 

	   		// TODO: Inspect insert results for unexpected errors (possibly caused by future validation rules) 
	   		// 		 Modify playerPendingInvestmentToUpdateList accordingly.
			
			UTIL_SObjectDMLHelper.doUpdate(playerPendingInvestmentToUpdateList);		// This should never be empty if newPlayerInvestmentToInsertList has contents.
   		}
    }
    
    private void convertToInvestment(Player_Pending_Investment__c pendingPlayerInvestment)
    {
    	Decimal playerRemainingWealth = ( ((Decimal) wealthByPlayerIdMap.get(pendingPlayerInvestment.player__c)) - pendingPlayerInvestment.upfront_cost__c );
		wealthByPlayerIdMap.put( pendingPlayerInvestment.player__c, playerRemainingWealth);
		
		newPlayerInvestmentToInsertList.add(
						new Player_Investment__c(
													player__c 		= pendingPlayerInvestment.player__c,
													investment__c   = pendingPlayerInvestment.investment__c,
													monthly_cost__c = pendingPlayerInvestment.monthly_cost__c
													// TODO: geolocation	   =  
													// TODO: first_to_discover =  
												)
										   );
		
		pendingPlayerInvestment.status__c = RF_PlayerPendingInvestmentHelper.STATUS_CLOSED;
		playerPendingInvestmentToUpdateList.add(pendingPlayerInvestment);
    }

	private void updatePlayerWealth()
	{
		List<Player__c> updatedPlayerList = new List<Player__c>();
		for (Player__c player : playerList)
		{
			if (player.wealth__c != (Decimal) wealthByPlayerIdMap.get(player.id))
			{
				player.wealth__c = (Decimal) wealthByPlayerIdMap.get(player.id);
				updatedPlayerList.add(player);
			}
		}
		
		if (!updatedPlayerList.isEmpty()) { UTIL_SObjectDMLHelper.doUpdate(updatedPlayerList); } 
	}

	// ---------------------------------------------------------------------------------------------------------

    global void finish(Database.BatchableContext batchableContext)
    {
    	schedule(); 
    }
    
    public void schedule()
    { 
    	if (UTIL_ScheduleHelper.isScheduledJob(RF_PlayerPendingInvestmentFulfillmtSched.JOB_NAME))
    	{
    		UTIL_ScheduleHelper.deleteJob(RF_PlayerPendingInvestmentFulfillmtSched.JOB_NAME); 
    	}
    	
    	Datetime now = System.now(); 

        Integer year      = now.year(); 
        Integer month     = now.month(); 
        Integer day       = now.day() + 1; 
        Integer hour      = 0; 
        Integer minute    = 0; 
        Integer second    = 0;
        
        String targetTime =  second + ' ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ? ' + year;
        RF_PlayerPendingInvestmentFulfillmtSched.schedule(targetTime); 
    }
}