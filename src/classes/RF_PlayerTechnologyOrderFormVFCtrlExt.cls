public with sharing class RF_PlayerTechnologyOrderFormVFCtrlExt extends RF_PlayerInvestmentOrderFormVFCtrlExt   
{
    public RF_PlayerTechnologyOrderFormVFCtrlExt( 
                                                    ApexPages.StandardController 					  standardController, 
                                                    RF_PlayerOrderFormVFCtrlInvestmentCache           investmentCache, 
                                                    RF_PlayerVFCtrlPlayerInvestmentCache              playerInvestmentCache
                                                ) 
    { 
        super(standardController); 
        this.investmentCache       = investmentCache;
        this.playerInvestmentCache = playerInvestmentCache;
    }
    
    public RF_PlayerTechnologyOrderFormVFCtrlExt(ApexPages.StandardController standardController) 
    {
        this(standardController, new RF_PlayerOrderFormVFCtrlInvestmentCache(), new RF_PlayerVFCtrlPlayerInvestmentCache());
    }

    protected override Id  	   getTargetInvestmentRecordTypeId() { return RF_InvestmentRecordTypeHelper.RECORDTYPE_TECHNOLOGY_ID; }
    protected override Boolean getReevaluateAfterOrder()		 { return true; }	 
    
    
    public Boolean getHasResearchCenter()
    {
    	return playerInvestmentCache.getHasResearchCenter(player.id);
    }

    
}