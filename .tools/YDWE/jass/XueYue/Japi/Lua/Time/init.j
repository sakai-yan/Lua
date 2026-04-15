#ifndef XGJAPITimeLibIncluded
#define XGJAPITimeLibIncluded

library XGJAPITimeLib initializer Init requires XGJAPI
    //报错:需要开启Japi优化

    //时间戳转日期部分 返回类型错误会返回-1
    function XG_Stamp2DatePart takes integer stamp, integer retType returns integer
        set XGJAPI_integer[1] = stamp
        set XGJAPI_integer[2] = retType
        call UnitId("XG_Stamp2DatePart")
        return XGJAPI_integer[0]
    endfunction

    //时间戳转日期字符串 %Y %m %D %H %M %S
    function XG_Stamp2Date takes integer stamp, string format returns string
        set XGJAPI_integer[1] = stamp
        set XGJAPI_string[2] = format
        call UnitId("XG_Stamp2Date")
        return XGJAPI_string[0]
    endfunction

    function XG_String2Stamp takes string str returns integer
        set XGJAPI_string[1] = str
        call UnitId("XG_String2Stamp")
        return XGJAPI_integer[0]
    endfunction

    //启动时间 : 魔兽启动时间 毫秒
    function XG_GetTickCount takes nothing returns integer
        call UnitId("XG_GetTickCount")
        return XGJAPI_integer[0]
    endfunction

    //服务端 时间戳
    function XG_GetCurServerTimeStamp takes nothing returns integer
        call UnitId("XG_GetCurServerTimeStamp")
        return XGJAPI_integer[0]
    endfunction

    //客户端 时间戳
    function XG_GetCurClientTimeStamp takes nothing returns integer
        call UnitId("XG_GetCurClientTimeStamp")
        return XGJAPI_integer[0]
    endfunction

	private function Init takes nothing returns nothing
		call XG_ImportFile("XueYue\\Japi\\Lua\\time\\init.lua","XG_JAPI\\Lua\\time\\init.lua")
        set XGJAPI_string[1] = "XG_JAPI.Lua.time"
		//报错:需要开启Japi优化
		call UnitId( "require" )
	endfunction


endlibrary

#endif
