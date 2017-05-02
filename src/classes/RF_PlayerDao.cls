public with sharing class RF_PlayerDao 
{
	public Player__c get(Id playerId) { return getList(new Set<Id>{playerId})[0]; }
	
	public List<Player__c> getList(Set<Id> playerIdSet)
	{
		return [
					SELECT id, ownerId, company_name__c, in_game_name__c, wealth__c, customers__c, product_quantity__c, 
						total_monthly_cost__c, 	Lowest_Assigned_Priority__c
					FROM   Player__c
					WHERE  id IN :playerIdSet
			   ];
	}
	
	
}