global with sharing class RF_PlayerPendingInvestmentListWrapper implements Comparable
{
	public String  name 			{ get; private set; } 
	public Integer priority			{ get; private set; }
	public String  status			{ get; private set; }
	public Integer quantity			{ get; private set; }  

	public Decimal monthlyCost		{ get; private set; }
	public String  getMonthlyCostCurrency()  { return RF_CurrencyHelper.getEuroString(monthlyCost); }

	public Decimal upfrontCost		{ get; private set; }
	public String  getUpfrontCostCurrency()  { return RF_CurrencyHelper.getEuroString(upfrontCost); }
	
	public List<Player_Pending_Investment__c> investmentList {get; private set; }
	
	public RF_PlayerPendingInvestmentListWrapper(Player_Pending_Investment__c playerPendingInvestment)
	{
		this.name        	  = playerPendingInvestment.investment__r.name;
		this.priority	 	  = (Integer) playerPendingInvestment.priority__c;
		this.quantity    	  = 1;
		this.upfrontCost 	  = playerPendingInvestment.upfront_cost__c;
		this.monthlyCost      = playerPendingInvestment.monthly_cost__c;
		this.status		      = playerPendingInvestment.status__c;
		
		investmentList = new List<Player_Pending_Investment__c>{ playerPendingInvestment }; 
	} 
	 
	public void add(Player_Pending_Investment__c playerPendingInvestment)
	{
		if (playerPendingInvestment.priority__c < this.priority) { this.priority = (Integer) playerPendingInvestment.priority__c; }

		this.quantity++;
		this.upfrontCost += playerPendingInvestment.upfront_cost__c;
		this.monthlyCost += playerPendingInvestment.monthly_cost__c;

		if (playerPendingInvestment.status__c == RF_PlayerPendingInvestmentHelper.STATUS_IN_PROGRESS)
		{
			this.status = RF_PlayerPendingInvestmentHelper.STATUS_IN_PROGRESS;
		}

		investmentList.add(playerPendingInvestment);
	}

	global Integer compareTo(Object compareTo)
	{
		RF_PlayerPendingInvestmentListWrapper compareToWrapper = (RF_PlayerPendingInvestmentListWrapper) compareTo;
		
		
		if (this.priority == compareToWrapper.priority) { return 0; }
		if (this.priority >  compareToWrapper.priority) { return 1; }
		return -1;	
	}
}