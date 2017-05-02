public with sharing virtual class RF_PlayerVFCtrlExt extends VF_VirtualVFPageCtrlBase  
{
        private static final List<String> PLAYER_FIELD_LIST = new List<String> 
        { 
                'id', 'ownerId', 'company_name__c', 'in_game_name__c', 
                'wealth__c', 'customers__c', 'product_quantity__c', 
                
                'total_monthly_cost__c',                                                                                                                                // From Investments
                
                'pending_monthly_cost__c', 'pending_upfront_cost__c', 'pending_total_monthly_cost__c',  // From Pending Investments
                'lowest_assigned_priority__c'
        }; 
        
    public Player__c player { get; private set; }

    public RF_PlayerVFCtrlExt(ApexPages.StandardController standardController) 
    { 
                standardController.addFields(PLAYER_FIELD_LIST);
        player = (Player__c) standardController.getRecord();

        if (player.ownerId != UserInfo.getUserId()) { throw new RF_InappropriatePlayerException ('Parameterized Player\'s Owner Id must match current User Id.'); }
           
        putInPageVariableByKeyMap('player',   player);
    }

}