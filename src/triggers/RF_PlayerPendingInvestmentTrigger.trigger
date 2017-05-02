trigger RF_PlayerPendingInvestmentTrigger on Player_Pending_Investment__c (before insert) 
{
   if (UTIL_TriggerHandlerInvoker.skipTriggerInvocation()) { return; } 
   UTIL_TriggerHandlerInvoker.invoke(new RF_PlayerPendingInvestmentTriggerHandler(new UTIL_TriggerWrapper())); 
}