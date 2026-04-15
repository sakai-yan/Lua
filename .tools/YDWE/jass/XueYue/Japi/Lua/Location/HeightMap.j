#ifndef XGHeightMapIncluded
#define XGHeightMapIncluded


library XGHeightMap initializer Init requires XGJAPI

    function XG_HeightMap_GetTerrainZ takes real x, real y returns real        
        set XGJAPI_real[1] = x
        set XGJAPI_real[2] = y
        call UnitId("XG_HeightMap_GetTerrainZ")
        return XGJAPI_real[0]
    endfunction

    function XG_HeightMap_GetLocZ takes location p returns real        
        set XGJAPI_real[1] = GetLocationX(p)
        set XGJAPI_real[2] = GetLocationY(p)
        call UnitId("XG_HeightMap_GetTerrainZ")
        return XGJAPI_real[0]
    endfunction

    function XG_HeightMap_GetUnitZ takes unit u returns real
        set XGJAPI_unit[1] = u
        call UnitId("XG_HeightMap_GetUnitZ")
        set XGJAPI_unit[1] = null
        return XGJAPI_real[0]
    endfunction

    private function Init takes nothing returns nothing
        call XG_ImportFile("XueYue\\Japi\\Lua\\Location\\PrecomputedHeightMap.lua","XG_JAPI\\Lua\\Location\\PrecomputedHeightMap.lua")
        set XGJAPI_string[1] = "XG_JAPI.Lua.Location.PrecomputedHeightMap"
		//报错:需要开启Japi优化
		call UnitId( "require" )
    endfunction

endlibrary
#endif

