public with sharing class RF_InvestmentSelectOptionRow 
{
	public RF_InvestmentSelectOptionRow(Investment__c investment)
	{
		this.investment = investment;
	}

	
	public Investment__c investment { get; private set; }
	
	public Id      getId()	        		{ return investment.id;   } 
	public String  getName()	    		{ return investment.name; }
	public String  getDescription()   		{ return investment.description__c; }
	public String  getDevelopmentManhours() { return investment.development_manhours__c.format(); } 
	public String  getUpfrontCost() 		{ return RF_CurrencyHelper.getEuroString(investment.upfront_cost__c); } 
	public String  getMonthlyCost() 		{ return RF_CurrencyHelper.getEuroString(investment.monthly_cost__c); } 

	public Boolean isChecked { get; set; }
	
	public String getRadioButton()
	{
		return '<input '
					+ ' type="radio" '
					+ ' name="Investment" '
					+ ' value="'+investment.id+'" '
					+ ' onClick="roboForceApp.changeRow(this);" '
					+ getChecked()
			+ ' />';
	}
	
	private String getChecked() 
	{ 
		return ((isChecked != null) && isChecked)
				?  'checked="checked"'
				:  '';
	} 
	
	

}