public with sharing abstract class RF_PlayerInvestmentOrderFormVFCtrlExt extends RF_PlayerVFCtrlExt   
{
    protected RF_PlayerOrderFormVFCtrlInvestmentCache       investmentCache; 
    protected RF_PlayerVFCtrlPlayerInvestmentCache          playerInvestmentCache; 
     
    protected abstract Id      getTargetInvestmentRecordTypeId();
    protected abstract Boolean getReevaluateAfterOrder();    
    
    public RF_PlayerInvestmentOrderFormVFCtrlExt(
                                                    ApexPages.StandardController                      standardController, 
                                                    RF_PlayerOrderFormVFCtrlInvestmentCache           investmentCache, 
                                                    RF_PlayerVFCtrlPlayerInvestmentCache              playerInvestmentCache
                                                )
    { 
        super(standardController);
        this.investmentCache       = investmentCache;
        this.playerInvestmentCache = playerInvestmentCache;
    }
    
    public RF_PlayerInvestmentOrderFormVFCtrlExt(ApexPages.StandardController standardController) 
    {
        this(standardController, new RF_PlayerOrderFormVFCtrlInvestmentCache(), new RF_PlayerVFCtrlPlayerInvestmentCache());
    }
    
    public String selectedInvestmentId   { get; set; }
     
    public Boolean getHasAvailableInvestment()
    {
        return ((availableInvestmentSelectOptionRowList != null) && (!availableInvestmentSelectOptionRowList.isEmpty()));
    }

    public List<RF_InvestmentSelectOptionRow> availableInvestmentSelectOptionRowList
    {
        get
        {
            if (availableInvestmentSelectOptionRowList == null)
            {
                availableInvestmentSelectOptionRowList = new List<RF_InvestmentSelectOptionRow>();
                for (Investment__c availableInvestment : availableInvestmentByIdMap.values()) 
                {
                    availableInvestmentSelectOptionRowList.add(new RF_InvestmentSelectOptionRow(availableInvestment));
                }
            }
            else if (!String.isBlank(selectedInvestmentId))
            {
                for (RF_InvestmentSelectOptionRow availableInvestmentSelectOptionRow : availableInvestmentSelectOptionRowList)
                {
                    if ((String.valueOf(availableInvestmentSelectOptionRow.getId()).equals(selectedInvestmentId)))
                    {
                        availableInvestmentSelectOptionRow.isChecked = true;
                        break;
                    }
                }
            }
            
            return availableInvestmentSelectOptionRowList;
        }
        private set;
    }

    private Map<Id, Investment__c> availableInvestmentByIdMap
    {
        get
        {
            if (availableInvestmentByIdMap == null)
            {
                availableInvestmentByIdMap = new Map<Id, Investment__c>(investmentCache.getAvailableList(player.id, getTargetInvestmentRecordTypeId(), possessedInvestmentIdSet));
            } 
            
            return availableInvestmentByIdMap;
        }
        set;
    }
    
    private Set<Id> possessedInvestmentIdSet
    {
        get
        {
            if (possessedInvestmentIdSet == null)
            {
                List<Player_Investment__c> possessedInvestmentList = playerInvestmentCache.getPlayerList(player.id);
                possessedInvestmentIdSet = UTIL_SetHelper.buildIdSet(possessedInvestmentList, 'investment__c', true); 
            }
            return possessedInvestmentIdSet;
        }
        set;
    }
    
    public Integer priorityValue
    {
        get
        {
                if (priorityValue == null)
                {
                    priorityValue = ((player.Lowest_Assigned_Priority__c == null) || (player.Lowest_Assigned_Priority__c < 1))
                                  ? 1
                                  : ((Integer) player.Lowest_Assigned_Priority__c + 1);
                }
                return priorityValue;
        }
        set;
    }
    
    public Boolean ignoreLiquidity { get; set; }
    
    public String successMessage 
    { 
        get
        {
            if (ApexPages.currentPage().getParameters().get('successMessage') != null)
            {
                successMessage = ApexPages.currentPage().getParameters().get('successMessage');
            }
            
            if (String.isBlank(successMessage)){ successMessage = null; }               
                                
            return successMessage;
        } 
        private set; 
    }
    
    public virtual void order()
    {
        List<Player_Pending_Investment__c> newPlayerInvestmentList = buildPlayerInvestmentList(); 
            
        Boolean isPending = true;               
        try {  insert newPlayerInvestmentList; } 
        catch (DmlException ex)
        {
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getDmlMessage(0));
            ApexPages.addMessage(message);
            isPending = false;
            ApexPages.currentPage().getParameters().put('successMessage', ''); 
        }
        
        if (isPending) 
        { 
            successMessage = availableInvestmentByIdMap.get(selectedInvestmentId).name + ' has been ordered successfully.';
            ApexPages.currentPage().getParameters().put('successMessage', successMessage); 

            if (getReevaluateAfterOrder())
            {
                // Clear these on successful submission so options will be reevaluated
                investmentCache.remove(player.id);              
                availableInvestmentByIdMap             = null;
                availableInvestmentSelectOptionRowList = null;
            }
        } 
    }
    
    public virtual List<Player_Pending_Investment__c> buildPlayerInvestmentList()
    {
        return new List<Player_Pending_Investment__c>
        {
            new Player_Pending_Investment__c
            (
                player__c           = player.id,
                investment__c       = selectedInvestmentId,
                priority__c         = priorityValue,
                ignore_liquidity__c = ignoreLiquidity,
                status__c           = RF_PlayerPendingInvestmentHelper.STATUS_OPEN 
            )
        };
    }
}