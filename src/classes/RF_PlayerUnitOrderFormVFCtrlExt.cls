public with sharing class RF_PlayerUnitOrderFormVFCtrlExt extends RF_PlayerInvestmentOrderFormVFCtrlExt   
{
    public RF_PlayerUnitOrderFormVFCtrlExt ( 
                                                    ApexPages.StandardController                      standardController, 
                                                    RF_PlayerOrderFormVFCtrlInvestmentCache           investmentCache, 
                                                    RF_PlayerVFCtrlPlayerInvestmentCache              playerInvestmentCache
                                                )
    {  
        super(standardController);  
        this.investmentCache       = investmentCache;
        this.playerInvestmentCache = playerInvestmentCache;
    }
    
    public RF_PlayerUnitOrderFormVFCtrlExt (ApexPages.StandardController standardController) 
    {
        this(standardController, new RF_PlayerOrderFormVFCtrlInvestmentCache(), new RF_PlayerVFCtrlPlayerInvestmentCache());
    }

    protected override Id      getTargetInvestmentRecordTypeId() { return RF_InvestmentRecordTypeHelper.RECORDTYPE_UNIT_ID; }
    protected override Boolean getReevaluateAfterOrder()         { return false; }    
    
    public Integer quantity 
    { 
        get
        {
            if (quantity == null) { quantity = 1; } 
            return quantity;
        } 
        set; 
    }
    
    public override void order()
    {
    	super.order();
    	quantity = 1;
    }

    public override List<Player_Pending_Investment__c> buildPlayerInvestmentList()
    {
    	List<Player_Pending_Investment__c> playerInvestmentList = new List<Player_Pending_Investment__c>();
    	
    	for (Integer i=1; i<=quantity; i++)
    	{
    		playerInvestmentList.add(new Player_Pending_Investment__c
       		(
       			player__c			= player.id,
       			investment__c  		= selectedInvestmentId,
       			priority__c 		= priorityValue + (i-1),
       			ignore_liquidity__c = ignoreLiquidity,
       			status__c			= RF_PlayerPendingInvestmentHelper.STATUS_OPEN 
       		));
    	}
    	
    	return playerInvestmentList;
    }
}