#ifndef LibInt2Handle
#define LibInt2Handle

library HcInt2Handle initializer Init requires XGJAPI
	function XG_Int2Unit takes integer hid returns unit
		set XGJAPI_integer[1] = hid
		call UnitId("XG_Int2Unit")
		return (XGJAPI_unit[0]) //报错:需要开启Japi优化
	endfunction

	function XG_Int2Item takes integer hid returns item
		set XGJAPI_integer[1] = hid
		call UnitId("XG_Int2Item")
		return (XGJAPI_item[0]) //报错:需要开启Japi优化
	endfunction
	
	private function Init takes nothing returns nothing
		call XG_ImportFile("XueYue\\Japi\\Lua\\Int\\Convert.lua","XG_JAPI\\Lua\\Int\\Convert.lua")
        set XGJAPI_string[1] = "XG_JAPI.Lua.Int.Convert"
		//报错:需要开启Japi优化
		call UnitId( "require" )

	endfunction
endlibrary

#endif
