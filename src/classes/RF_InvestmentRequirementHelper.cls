public with sharing class RF_InvestmentRequirementHelper 
{
	public static List<Investment_Requirement__c> filterUnmetAdditionalRequirements(List<Investment_Requirement__c> investmentRequirementList, Set<Id> possessedInvestmentIdSet)
	{
		List<Investment_Requirement__c> filteredRequirementList = null;
		
		for (Investment_Requirement__c investmentRequirement : filteredRequirementList)
		{
			String additionalRequiredInvestments = ''; //investmentRequirement.additional_required_investments__c; 
			
			if (
						(String.isBlank(additionalRequiredInvestments))
					||  isRequirementMet(additionalRequiredInvestments, possessedInvestmentIdSet)
				)
			{
				filteredRequirementList.add(investmentRequirement);
			}
		}
		
		 return filteredRequirementList;
	}
	
	private static Boolean isRequirementMet(String additionalRequiredInvestments, Set<Id> possessedInvestmentIdSet)
	{
		List<String> additionalRequirementList = additionalRequiredInvestments.split(';');
		
		for (String additionalRequirement : additionalRequirementList)
		{
			if (!possessedInvestmentIdSet.contains(additionalRequirement))
			{
				return false;
			}
		}
		return true;
	}
}