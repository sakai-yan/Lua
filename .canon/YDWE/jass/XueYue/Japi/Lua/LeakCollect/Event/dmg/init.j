#ifndef LibHcLeakCollectOfEventDmgOnDying
#define LibHcLeakCollectOfEventDmgOnDying

library HcLeakCollectOfEventDmgOnDying initializer Init requires HcLeakCollect
	
	//开启单位死亡自动排泄
	function XG_LeakCollect_evt_dmg_onDying takes nothing returns nothing
		call UnitId("XG_LeakCollect_evt_dmg_onDying")
	endfunction

	//添加例外名单
	function XG_LeakCollect_evt_dmg_onDying_addExcept takes integer uid returns nothing
		set XGJAPI_integer[1] = uid
		call UnitId("XG_LeakCollect_evt_dmg_onDying_addExcept")
	endfunction
	
	private function Init takes nothing returns nothing
		call XG_ImportFile("XueYue\\Japi\\Lua\\LeakCollect\\Event\\dmg\\init.lua","XG_JAPI\\Lua\\LeakCollect\\Event\\dmg\\init.lua")
        set XGJAPI_string[1] = "XG_JAPI.Lua.LeakCollect.Event.dmg"
		//报错:需要开启Japi优化
		call UnitId( "require" )
	endfunction

endlibrary

#endif
