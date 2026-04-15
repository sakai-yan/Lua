#ifndef LibHcDZGetRealPlayerNmae
#define LibHcDZGetRealPlayerNmae

library HcDZGetRealPlayerNmae initializer Init requires XGJAPI
	
	function XG_DZAPI_GetRealPlayerNmae takes player p, string fake_name, integer fake_id returns string
		set XGJAPI_player[1] = p
		set XGJAPI_string[2] = fake_name
		set XGJAPI_integer[3] = fake_id
		call UnitId("XG_DZAPI_GetRealPlayerNmae")
		return XGJAPI_string[0]
	endfunction

	private function Init takes nothing returns nothing
		call XG_ImportFile("XueYue\\Japi\\Lua\\Player\\DZAPI\\init.lua","XG_JAPI\\Lua\\Player\\DZAPI\\init.lua")
        set XGJAPI_string[1] = "XG_JAPI.Lua.Player.DZAPI"
		//报错:需要开启Japi优化
		call UnitId( "require" )
	endfunction

endlibrary

#endif
