public with sharing class RF_CurrencyHelper 
{
	public static String getEuroString (Decimal amount)
	{
		return '\u20AC' + amount.format();
	}
}