public with sharing class RF_PlayerInvestmentDao
{
	public List<Player_Investment__c> getList(Id playerId)
	{
		return [
					SELECT id, investment__c,  investment__r.name, investment__r.recordTypeId, monthly_cost__c
					FROM   Player_Investment__c
					WHERE  player__c = :playerId
			   ];
	}
	
}