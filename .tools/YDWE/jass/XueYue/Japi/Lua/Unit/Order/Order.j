#ifndef LibHcOrder
#define LibHcOrder

library HcOrder initializer Init requires XGJAPI
	function XG_OrderImmediate takes integer orderId returns nothing
		set XGJAPI_integer[1] = orderId
		call UnitId("XG_OrderImmediate")
	endfunction

	function XG_OrderTarget takes integer orderId, real x, real y, handle h returns nothing
		set XGJAPI_integer[1] = orderId
		set XGJAPI_real[2] = x
		set XGJAPI_real[3] = y
		set XGJAPI_integer[4] = GetHandleId(h)
		call UnitId("XG_OrderTarget")
	endfunction

	function XG_OrderTarget_Unit takes integer orderId, unit u returns nothing
		call XG_OrderTarget( orderId, GetUnitX(u), GetUnitY(u), u )
	endfunction

	function XG_OrderTarget_Destructable takes integer orderId, destructable d returns nothing
		call XG_OrderTarget( orderId, GetDestructableX(d), GetDestructableY(d), d )
	endfunction

	function XG_OrderTarget_Item takes integer orderId, item it returns nothing
		call XG_OrderTarget( orderId, GetItemX(it), GetItemY(it), it )
	endfunction

	function XG_OrderPoint takes integer orderId, real x, real y returns nothing
		set XGJAPI_integer[1] = orderId
		set XGJAPI_real[2] = x
		set XGJAPI_real[3] = y
		call UnitId("XG_OrderPoint")
	endfunction
	
	private function Init takes nothing returns nothing
		call XG_ImportFile("XueYue\\Japi\\Lua\\Unit\\Order\\Order.lua","XG_JAPI\\Lua\\Unit\\Order.lua")
        set XGJAPI_string[1] = "XG_JAPI.Lua.Unit.Order"
		//报错:需要开启Japi优化
		call UnitId( "require" )
	endfunction
endlibrary

#endif
