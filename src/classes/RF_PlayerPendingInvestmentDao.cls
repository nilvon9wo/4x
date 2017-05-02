public with sharing class RF_PlayerPendingInvestmentDao 
{
    private final Set<String> DEFAULT_EXCLUDE_STATUS = new Set<String>
    { 
        RF_PlayerPendingInvestmentHelper.STATUS_ON_HOLD,
        RF_PlayerPendingInvestmentHelper.STATUS_CLOSED,
        RF_PlayerPendingInvestmentHelper.STATUS_CANCELED
    };
    
    public List<Player_Pending_Investment__c> getList(Id playerId)
    {
        return [
                    SELECT id, investment__c,  investment__r.name, investment__r.recordTypeId,  
                        monthly_cost__c, upfront_cost__c, 
                        priority__c, status__c
                    FROM   Player_Pending_Investment__c
                    WHERE  (player__c = :playerId)
                        AND status__c NOT IN :DEFAULT_EXCLUDE_STATUS
                    ORDER BY Priority__c ASC
               ];
    }
    
}