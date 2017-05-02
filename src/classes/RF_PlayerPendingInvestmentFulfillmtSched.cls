global with sharing class RF_PlayerPendingInvestmentFulfillmtSched implements Schedulable
{
	public static final String JOB_NAME = 'RF_PlayerPendingInvestmentFulfillmtSched';
	
    global void execute(SchedulableContext schedulableContext) 
    {
        RF_PlayerPendingInvestmentFulfillmtBatch playerPendingInvestmentFulfillmtBatch = new RF_PlayerPendingInvestmentFulfillmtBatch();
        Database.executeBatch(playerPendingInvestmentFulfillmtBatch);
    }
    
    public static void schedule(String targetDatetime) 
    {
        RF_PlayerPendingInvestmentFulfillmtSched investmentfulfillmentSchedulable = new RF_PlayerPendingInvestmentFulfillmtSched();
        UTIL_ScheduleHelper.scheduleJob(JOB_NAME, investmentfulfillmentSchedulable, targetDatetime);
    }
}