#ifndef XGHashtableIncluded
#define XGHashtableIncluded


library XGHashtable initializer Init requires XGJAPI

    function XG_Hashtable_SetBoolConstant takes string constName, boolean b returns nothing
        set XGJAPI_string[1] = constName
        set XGJAPI_bool[2] = b
        call UnitId("XG_Hashtable_SetBoolConstant")
    endfunction

    private function Init takes nothing returns nothing
        call XG_ImportFile("XueYue\\Japi\\Lua\\Hashtable\\Hashtable.lua","XG_JAPI\\Lua\\Hashtable\\Hashtable.lua")
        set XGJAPI_string[1] = "XG_JAPI.Lua.Hashtable.Hashtable"
		//报错:需要开启Japi优化
		call UnitId( "require" )
    endfunction

endlibrary
#endif

