public with sharing virtual class VF_VirtualVFPageCtrlBase 
{
	public VF_VirtualVFPageCtrlBase getThis() { return this; }

	// ----------------------------------------------- 

	// Map of communicable Custom Components by key
	private  Map<String, VF_VirtualVFCompCtrlBase> vfCompCtrlByKeyMap;
	public virtual Map<String, VF_VirtualVFCompCtrlBase> getVFCompCtrlByKeyMap()   { return vfCompCtrlByKeyMap; }
	public virtual VF_VirtualVFCompCtrlBase              getVFCompCtrl(String key) { return vfCompCtrlByKeyMap.get(key); }
	public virtual void putInCompCtrlByKeyMap (String key, VF_VirtualVFCompCtrlBase vfCompCtrl)
	{
		if (vfCompCtrlByKeyMap == null) { vfCompCtrlByKeyMap= new Map<String, VF_VirtualVFCompCtrlBase>(); }
		
		vfCompCtrlByKeyMap.put(key, vfCompCtrl); 		
	}
	 
	// ----------------------------------------------- 

	// Map of Variables by key
	private Map<String, Object> pageVariableByKeyMap;
	public virtual Map<String, Object> getPageVariableByKeyMap()   { return pageVariableByKeyMap; }
	public virtual Object              getPageVariable(String key) { return pageVariableByKeyMap.get(key); }
	public virtual void 			   putInPageVariableByKeyMap (String key, Object value)
	{
		if (pageVariableByKeyMap == null) { pageVariableByKeyMap= new Map<String, Object>(); }
		
		pageVariableByKeyMap.put(key, value); 		
	}

	// ----------------------------------------------- 

	// Map of Lists by key  (Lists can't go into the above map without first wrapping them.)
	private Map<String, List<Object>> pageListByKeyMap;
	public virtual Map<String, List<Object>> getPageListByKeyMap()   { return pageListByKeyMap; }
	public virtual List<Object>              getPageList(String key) { return pageListByKeyMap.get(key); }
	public virtual void 			         putInPageListByKeyMap (String key, List<Object> objectList)
	{
		if (pageListByKeyMap == null) { pageListByKeyMap= new Map<String, List<Object>>(); }
		
		pageListByKeyMap.put(key, objectList); 		
	}
		
}