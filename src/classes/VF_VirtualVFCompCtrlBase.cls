public with sharing virtual class VF_VirtualVFCompCtrlBase 
{
	public VF_VirtualVFPageCtrlBase vfPageCtrl
	{
		get;
		set
		{
			if (value != null)
			{
				vfPageCtrl = value; 
				if (key != null)       { vfPageCtrl.putInCompCtrlByKeyMap(key, this); }
			}
		} 
	}
	
	public String key
	{
		get;
		set
		{
			if (value != null)
			{
				key = value;
				if (vfPageCtrl != null) { vfPageCtrl.putInCompCtrlByKeyMap(key, this); }
			}
		}
	}
}