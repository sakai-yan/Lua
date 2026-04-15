#ifndef LibHcLeakCollectOfPlayerEvent
#define LibHcLeakCollectOfPlayerEvent

//报错:需要开启Japi优化 + 自动排泄系统
library HcLeakCollectOfPlayerEvent initializer Init requires HcLeakCollect
	function XG_LeakCollect_PlayerEvent_On takes nothing returns nothing

	endfunction

	private function Init takes nothing returns nothing
		call XG_ImportFile("XueYue\\Japi\\Lua\\LeakCollect\\Event\\Player\\init.lua","XG_JAPI\\Lua\\LeakCollect\\Event\\Player\\init.lua")
        set XGJAPI_string[1] = "XG_JAPI.Lua.LeakCollect.Event\\Player"
		
		call UnitId( "require" )
	endfunction

endlibrary

#endif
