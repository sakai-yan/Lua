#ifndef LibHcStringOpt
#define LibHcStringOpt

library HcStringOpt initializer Init requires XGJAPI //XGJAPI报错:需要开启Japi优化系统

	function XG_IntToStringArray takes integer n returns integer
		set XGJAPI_integer[1] = n
		call UnitId("XG_IntToStringArray")
		//返回数组长度
    	return XGJAPI_integer[1]
	endfunction

	function XG_RealToStringArray takes real f returns integer
		set XGJAPI_real[1] = f
		call UnitId("XG_RealToStringArray")
		//返回数组长度
    	return XGJAPI_integer[1]
	endfunction

	function XG_String_Match takes string str, string pattern returns integer
		set XGJAPI_string[1] = str
		set XGJAPI_string[2] = pattern
		call UnitId("XG_String_Match")
		//返回匹配到的数量
    	return XGJAPI_integer[1]
	endfunction

	function XG_String_GMatch takes string str, string pattern returns integer
		set XGJAPI_string[1] = str
		set XGJAPI_string[2] = pattern
		call UnitId("XG_String_GMatch")
		//返回匹配到的数量
    	return XGJAPI_integer[1]
	endfunction

	function XG_String_Format takes string sFormat, string sParams returns string
		set XGJAPI_string[8190] = sFormat
		set XGJAPI_string[8191] = sParams
		call UnitId("XG_String_Format")
    	return XGJAPI_string[0]
	endfunction

    private function Init takes nothing returns nothing
		call XG_ImportFile("XueYue\\Japi\\Lua\\String\\StringOpt.lua","XG_JAPI\\Lua\\String\\StringOpt.lua")
        set XGJAPI_string[1] = "XG_JAPI.Lua.String.StringOpt"
		
		call UnitId( "require" )
	endfunction
    
endlibrary

#endif
