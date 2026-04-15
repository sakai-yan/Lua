#ifndef LibHcGetSelectedUnit
#define LibHcGetSelectedUnit

library HcGetSelectedUnit initializer Init requires XGJAPI
	function XG_GetSelectedUnit takes nothing returns unit
		call UnitId("GetSelectedUnit")
		return (XGJAPI_unit[0]) //报错:需要开启Japi优化
	endfunction
	
	private function Init takes nothing returns nothing
		call XG_ImportFile("XueYue\\Japi\\Lua\\Unit\\GetSelectedUnit\\GetSelectedUnit.lua","XG_JAPI\\Lua\\Unit\\GetSelectedUnit.lua")
        set XGJAPI_string[1] = "XG_JAPI.Lua.Unit.GetSelectedUnit"
		//报错:需要开启Japi优化
		call UnitId( "require" )

	endfunction
endlibrary

#endif
