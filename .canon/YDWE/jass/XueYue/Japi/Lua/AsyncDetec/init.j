#ifndef LibHcAsyncDetec
#define LibHcAsyncDetec

library HcAsyncDetec initializer Init requires XGJAPI

	//设置异步提示次数
	function XG_AsyncDetec_setTimes takes integer times returns nothing
		set XGJAPI_integer[1] = times
		call UnitId("XG_AsyncDetec_setTimes")
	endfunction
	
	private function Init takes nothing returns nothing
		call XG_ImportFile("XueYue\\Japi\\Lua\\AsyncDetec\\init.lua","XG_JAPI\\Lua\\AsyncDetec\\init.lua")
        set XGJAPI_string[1] = "XG_JAPI.Lua.AsyncDetec"
		//报错:需要开启Japi优化
		call UnitId( "require" )
	endfunction

endlibrary

#endif
