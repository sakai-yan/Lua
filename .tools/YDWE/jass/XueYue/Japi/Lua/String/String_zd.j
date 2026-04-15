library HcStringzd initializer Init requires XGJAPI
	function Xg_String_zd takes string text,string left,string right returns string
		set XGJAPI_string[1] = text
		set XGJAPI_string[2] = left
		set XGJAPI_string[3] = right
		call UnitId("Xg_String_zd")
		return XGJAPI_string[0]
	endfunction
	function Xg_StringReplace_zd takes string text,string left,string right,string str returns string
		set XGJAPI_string[1] = text
		set XGJAPI_string[2] = left
		set XGJAPI_string[3] = right
		set XGJAPI_string[4] = str
		call UnitId("Xg_StringReplace_zd")
		return XGJAPI_string[0]
	endfunction
	private function Init takes nothing returns nothing
        set XGJAPI_string[1] = "XG_JAPI.Lua.String.String_zd"
		call UnitId( "require" )
	endfunction
endlibrary
