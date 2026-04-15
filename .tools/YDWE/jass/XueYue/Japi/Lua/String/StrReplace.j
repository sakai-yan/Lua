library XGStrReplace initializer Init requires XGJAPI
    //字符串替换 单个
    function XG_StrReplace_Single takes string str,integer i,string s returns string
        set XGJAPI_string[1] = str
        set XGJAPI_integer[2] = i
        set XGJAPI_string[3] = s
        call UnitId("XG_StrReplace_Single")
		return XGJAPI_string[0]
    endfunction
    //字符串替换 多个
    function XG_StrReplace_Multiple takes string str,integer i,integer j,string s returns string
        set XGJAPI_string[1] = str
        set XGJAPI_integer[2] = i
        set XGJAPI_integer[3] = j
        set XGJAPI_string[4] = s
        call UnitId("XG_StrReplace_Multiple")
		return XGJAPI_string[0]
    endfunction
    //字符串替换 指定字符串 完整字符串 作用字符串 欲替换字符串 次数
    function XG_StringReplace takes string text,string os,string ns,integer num returns string
        set XGJAPI_string[1] = text
        set XGJAPI_string[2] = os
        set XGJAPI_string[3] = ns
        set XGJAPI_integer[4] = num
        call UnitId("XG_StringReplace")
		return XGJAPI_string[0]
	endfunction

	private function Init takes nothing returns nothing
        set XGJAPI_string[1] = "XG_JAPI.Lua.String.StrReplace"
		call UnitId( "require" )
	endfunction
endlibrary
