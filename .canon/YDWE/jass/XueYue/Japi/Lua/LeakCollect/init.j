#ifndef LibHcLeakCollect
#define LibHcLeakCollect

library HcLeakCollect initializer Init requires XGJAPI
	
	private function Init takes nothing returns nothing
		call XG_ImportFile("XueYue\\Japi\\Lua\\LeakCollect\\init.lua","XG_JAPI\\Lua\\LeakCollect\\init.lua")
        set XGJAPI_string[1] = "XG_JAPI.Lua.LeakCollect"
		//报错:需要开启Japi优化
		call UnitId( "require" )
	endfunction

endlibrary

#endif
