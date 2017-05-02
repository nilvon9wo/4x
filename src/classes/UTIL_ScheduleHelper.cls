public  with sharing class UTIL_ScheduleHelper 
{
    public static String convertDateTimeToCronExpression(Datetime thisTime)
    {
        Integer year      = thisTime.year(); 
        Integer month     = thisTime.month(); 
        Integer day       = thisTime.day(); 
        Integer hour      = thisTime.hour(); 
        Integer minute    = thisTime.minute(); 
        Integer second    = thisTime.second(); 
        return second + ' ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ? ' + year;
    } 

	public static void scheduleJob(String jobName, Schedulable schedulableClass, Datetime targetDatetime)
	{
		scheduleJob(jobName, schedulableClass, convertDateTimeToCronExpression(targetDatetime)); 
	}

	public static void scheduleJob(String jobName, Schedulable schedulableClass, String cronExpression)
	{
        if (!(UTIL_ScheduleHelper.isScheduledJob(jobName)))
        {
            try
            {
                System.Schedule ( 
                                    jobName, 
                                    cronExpression + ' ' + jobName,  // We add the jobName to the cronExpress so we can find it again.  See http://salesforce.stackexchange.com/questions/374/linking-crontrigger-sobjects-to-scheduled-jobs-listings  
                                    schedulableClass
                                 );
            }
            catch (AsyncException ex) {}                       // Nothing to do here; this is just a backup if isScheduledBatchJob() fails. 
        }
	}

    public static void scheduleJob(String jobName, Schedulable schedulableClass)  
    {
    	scheduleJob(jobName, schedulableClass, System.now().addMinutes(1));
	}

    public static Boolean isScheduledJob(String jobName)    
    {
        List<CronTrigger> cronTriggerList = [SELECT id FROM CronTrigger WHERE cronExpression LIKE :('% ' + jobName)];
        return (cronTriggerList.size() > 0); 
    }
    
    public static void deleteJob(String jobName)  
    {
        CronTrigger cronTrigger = [SELECT id FROM CronTrigger WHERE cronExpression LIKE :('% ' + jobName) LIMIT 1];
        System.abortJob(cronTrigger.id);
    }    
     

}