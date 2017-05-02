public with sharing class RF_InvestmentRequirementDao 
{
	public Set<Id> getEnabledInvestmentIdSet(Set<Id> possessedInvestmentIdSet)
	{
	    Set<Id> potentiallyEnabledInvestmentIdSet = getPotentiallyEnabledIdSet(possessedInvestmentIdSet);
		Set<Id> notEnabledInvestmentIdSet = getExclusionIdSet(possessedInvestmentIdSet, potentiallyEnabledInvestmentIdSet);			   
			   
		 	    potentiallyEnabledInvestmentIdSet.removeAll(notEnabledInvestmentIdSet);
		 return potentiallyEnabledInvestmentIdSet;
	}
	
	private Set<Id> getPotentiallyEnabledIdSet(Set<Id> possessedInvestmentIdSet)
	{
		possessedInvestmentIdSet.add(null);	// So investments with no requirements will be included.
		
		List<Investment_Requirement__c> potentiallyEnabledInvestmentRequirementList =
				[
					SELECT enabled_investment__c
					FROM   Investment_Requirement__c
					WHERE  required_investment__c IN :possessedInvestmentIdSet
		        ];
		        
		return UTIL_SetHelper.buildIdSet(potentiallyEnabledInvestmentRequirementList, 'Enabled_Investment__c', false);
	}
	
	private Set<Id> getExclusionIdSet(Set<Id> possessedInvestmentIdSet, Set<Id> potentiallyEnabledInvestmentIdSet)
	{
		List<Investment_Requirement__c> notEnabledInvestmentRequirementList =
			[
					SELECT enabled_investment__c
					FROM   Investment_Requirement__c
					WHERE  enabled_investment__c IN :potentiallyEnabledInvestmentIdSet
						AND	required_investment__c NOT IN :possessedInvestmentIdSet
			];
			   
		return UTIL_SetHelper.buildIdSet(notEnabledInvestmentRequirementList, 'Enabled_Investment__c', false);		}
}