global with sharing class RF_PlayerInvestmentListWrapper implements Comparable
{
    public String  name             { get; private set; }
    public Integer quantity         { get { return investmentList.size(); } private set; }

    public Decimal monthlyCost      { get; private set; }
    public String  getMonthlyCostCurrency() { return RF_CurrencyHelper.getEuroString(monthlyCost); }
     
    public List<Player_Investment__c> investmentList {get; private set; }
    
    public RF_PlayerInvestmentListWrapper(Player_Investment__c playerInvestment)
    {
        this.name        = playerInvestment.investment__r.name;
        this.monthlyCost = playerInvestment.monthly_cost__c;
        
        investmentList = new List<Player_Investment__c>{ playerInvestment }; 
    }
    
    public void add(Player_Investment__c playerInvestment)
    {
        this.monthlyCost += playerInvestment.monthly_cost__c;
        
        investmentList.add(playerInvestment);
    }

    global Integer compareTo(Object compareTo)
    {
        RF_PlayerInvestmentListWrapper compareToWrapper = (RF_PlayerInvestmentListWrapper) compareTo;
        
        String thisName       = name.toLowerCase();
        String comparableName = compareToWrapper.name.toLowerCase();
        
        if (thisName == comparableName) { return 0; }
        if (thisName >  comparableName) { return 1; }
        return -1;  
    }
}