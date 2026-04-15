#ifndef H_XG_HANDLEHELPER
#define H_XG_HANDLEHELPER

$def XGHandleHelperOn
library XGHandleHelper initializer Init requires XGJAPI

    function XG_HandleHelper_CodeRecord takes code c, string cName returns nothing
        set XGJAPI_code = c
        set XGJAPI_string[1] = cName
        call UnitId("XG_HandleHelper_CodeRecord")
        call Filter(c)
    endfunction

    private function Init takes nothing returns nothing
        call XG_ImportFile("XueYue\\Japi\\Lua\\HandleHelper\\HandleHelper.lua","XG_JAPI\\Lua\\HandleHelper\\HandleHelper.lua")

        set XGJAPI_string[1] = "XG_JAPI.Lua.HandleHelper.HandleHelper"
		call UnitId( "require" )

        call ExecuteFunc("XG_HandleHelper_CodeInit")
    endfunction

endlibrary


#endif // H_XG_HANDLEHELPER
