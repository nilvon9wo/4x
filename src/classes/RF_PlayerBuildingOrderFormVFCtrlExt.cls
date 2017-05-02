public with sharing class RF_PlayerBuildingOrderFormVFCtrlExt extends RF_PlayerInvestmentOrderFormVFCtrlExt   
{
    public RF_PlayerBuildingOrderFormVFCtrlExt( 
                                                    ApexPages.StandardController 					  standardController, 
                                                    RF_PlayerOrderFormVFCtrlInvestmentCache           investmentCache, 
                                                    RF_PlayerVFCtrlPlayerInvestmentCache              playerInvestmentCache
                                                )
    {  
        super(standardController); 
        this.investmentCache       = investmentCache;
        this.playerInvestmentCache = playerInvestmentCache;
    }
    
    public RF_PlayerBuildingOrderFormVFCtrlExt(ApexPages.StandardController standardController) 
    {
        this(standardController, new RF_PlayerOrderFormVFCtrlInvestmentCache(), new RF_PlayerVFCtrlPlayerInvestmentCache());
    }

    protected override Id  	   getTargetInvestmentRecordTypeId() { return RF_InvestmentRecordTypeHelper.RECORDTYPE_BUILDING_ID; }
    protected override Boolean getReevaluateAfterOrder()		 { return false; }	   
}