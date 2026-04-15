#ifndef LibHcLeakCollectOfGroup
#define LibHcLeakCollectOfGroup

//报错:需要开启Japi优化 + 自动排泄系统
library HcLeakCollectOfGroup initializer Init requires HcLeakCollect
	
	private function Init takes nothing returns nothing
		call XG_ImportFile("XueYue\\Japi\\Lua\\LeakCollect\\Group\\init.lua","XG_JAPI\\Lua\\LeakCollect\\Group\\init.lua")
        set XGJAPI_string[1] = "XG_JAPI.Lua.LeakCollect.Group"
		
		call UnitId( "require" )
	endfunction

endlibrary

#endif
