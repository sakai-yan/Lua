XG_ImportFile("XueYue\\Japi\\Lua\\String\\ascii.lua","XG_JAPI\\Lua\\String\\ascii.lua")
library XGASCII initializer Init requires XGJAPI
	function XG_Ascii2Char takes integer a returns string
		set XGJAPI_integer[1] = a
		call UnitId("XG_Ascii2Char")
		return XGJAPI_string[0]
	endfunction

	function XG_Char2Ascii takes string s returns integer
		set XGJAPI_string[1] = s
		call UnitId("XG_Char2Ascii")
		return XGJAPI_integer[0]
	endfunction

	private function Init takes nothing returns nothing
        set XGJAPI_string[1] = "XG_JAPI.Lua.String.ascii"
		call UnitId( "require" )
	endfunction
endlibrary
