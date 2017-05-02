public with sharing class RF_PlayerOverviewVFCompCtrl extends VF_VirtualVFCompCtrlBase 
{
	public Player__c ctrlPlayer
	{
		get
		{
			return (Player__c) vfPageCtrl.getPageVariable('player');
		}
		set;
	} 
	
	public RF_PlayerOverviewVFCompCtrl()
	{
		key = 'playerOverview';
	} 
}