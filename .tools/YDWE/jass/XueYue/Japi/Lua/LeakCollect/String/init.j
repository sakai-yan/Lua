#ifndef LibHcLeakCollectOfString
#define LibHcLeakCollectOfString

library HcLeakCollectOfString initializer Init requires HcLeakCollect

	//添加字符串排泄
	function XG_LeakCollect_StringRelease takes string str returns string
		set XGJAPI_string[1] = str
		call UnitId("XG_LeakCollect_StringRelease")
		return str
	endfunction
	
	private function Init takes nothing returns nothing
		call XG_ImportFile("XueYue\\Japi\\Lua\\LeakCollect\\String\\init.lua","XG_JAPI\\Lua\\LeakCollect\\String\\init.lua")
        set XGJAPI_string[1] = "XG_JAPI.Lua.LeakCollect.String"
		//报错:需要开启Japi优化
		call UnitId( "require" )
	endfunction

endlibrary

#endif
