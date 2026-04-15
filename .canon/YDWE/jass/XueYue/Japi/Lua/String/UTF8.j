XG_ImportFile("XueYue\\Japi\\Lua\\String\\UTF8.lua","XG_JAPI\\Lua\\String\\UTF8.lua")
library XGUTF8 initializer Init requires XGJAPI

	function XG_SubUTF8 takes string s, integer i, integer j returns string
		set XGJAPI_string[1] = s
		set XGJAPI_integer[2] = i
		set XGJAPI_integer[3] = j
		call UnitId("XG_SubUTF8")
		return XGJAPI_string[0]
	endfunction

	function XG_LenUTF8 takes string s returns integer
		set XGJAPI_string[1] = s
		call UnitId("XG_LenUTF8")
		return XGJAPI_integer[0]
	endfunction

	private function Init takes nothing returns nothing
        set XGJAPI_string[1] = "XG_JAPI.Lua.String.UTF8"
		call UnitId( "require" )
	endfunction

endlibrary
