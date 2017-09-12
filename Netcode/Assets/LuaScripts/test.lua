function awake( ... )
	
end

function start( ... )
	local go = ResourcesMgr.LoadPrefab('Characters/16011002_Diffuse_Prefab')
	LuaInterface.SetScale(go, 2.5, 2.5, 2.5)
end
