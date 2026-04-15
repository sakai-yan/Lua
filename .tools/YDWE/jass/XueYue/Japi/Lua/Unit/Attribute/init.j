#ifndef LibHcUnitAttribute
#define LibHcUnitAttribute

library HcUnitAttribute initializer Init requires XGJAPI //XGJAPI报错:需要开启Japi优化系统
	function XG_GetUnitAttribute takes unit u, string attrName returns real
        set XGJAPI_unit[1] = u
        set XGJAPI_string[2] = attrName

		call UnitId("XG_GetUnitAttribute")

		set XGJAPI_unit[1] = null

		return XGJAPI_real[0]
	endfunction

	function XG_GetUnitAttribute_Integer takes unit u, string attrName returns integer
        set XGJAPI_unit[1] = u
        set XGJAPI_string[2] = attrName

		call UnitId("XG_GetUnitAttribute_Integer")

		set XGJAPI_unit[1] = null

		return XGJAPI_integer[0]
	endfunction

	function XG_GetUnitAttribute_String takes unit u, string attrName, string sFormat returns string
        set XGJAPI_unit[1] = u
        set XGJAPI_string[2] = attrName
		set XGJAPI_string[3] = sFormat

		call UnitId("XG_GetUnitAttribute_String")

		set XGJAPI_unit[1] = null

		return XGJAPI_string[0]
	endfunction

    function XG_AdjustUnitAttribute takes unit u, string attrName, string adjustMethod, real value returns nothing
        set XGJAPI_unit[1] = u
        set XGJAPI_string[2] = attrName
        set XGJAPI_string[3] = adjustMethod // =  +=  -=
        set XGJAPI_real[4] = value

		call UnitId("XG_AdjustUnitAttribute")
		
		set XGJAPI_unit[1] = null
	endfunction
	
	function XG_AdjustUnitAttribute_Integer takes unit u, string attrName, string adjustMethod, integer value returns nothing
        set XGJAPI_unit[1] = u
        set XGJAPI_string[2] = attrName
        set XGJAPI_string[3] = adjustMethod // =  +=  -=
        set XGJAPI_integer[4] = value

		call UnitId("XG_AdjustUnitAttribute_Integer")
		
		set XGJAPI_unit[1] = null
	endfunction

	function XG_TransferUnitAttribute takes unit u, unit target returns nothing
        set XGJAPI_unit[1] = u
        set XGJAPI_unit[2] = target

		call UnitId("XG_TransferUnitAttribute")

		set XGJAPI_unit[1] = null
		set XGJAPI_unit[2] = null
	endfunction

	function XG_CopyUnitAttribute takes unit u, unit target, boolean overwriteOrOverride returns nothing
        set XGJAPI_unit[1] = u
        set XGJAPI_unit[2] = target
		set XGJAPI_bool[3] = overwriteOrOverride

		call UnitId("XG_CopyUnitAttribute")

		set XGJAPI_unit[1] = null
		set XGJAPI_unit[2] = null
	endfunction

	function XG_RemoveUnitAttribute takes unit u returns nothing
        set XGJAPI_unit[1] = u

		call UnitId("XG_RemoveUnitAttribute")

		set XGJAPI_unit[1] = null
	endfunction

	function XG_GetUnitAttributeDataId takes unit u returns integer
        set XGJAPI_unit[1] = u

		call UnitId("XG_GetUnitAttributeDataId")

		set XGJAPI_unit[1] = null
		return XGJAPI_integer[0]
	endfunction

	function XG_SetUnitAttributeDataId takes unit u,integer v returns nothing
        set XGJAPI_unit[1] = u
		set XGJAPI_integer[2] = v

		call UnitId("XG_SetUnitAttributeDataId")

		set XGJAPI_unit[1] = null
	endfunction

	private function Init takes nothing returns nothing
		call XG_ImportFile("XueYue\\Japi\\Lua\\Unit\\Attribute\\init.lua","XG_JAPI\\Lua\\Unit\\Attribute.lua")
        set XGJAPI_string[1] = "XG_JAPI.Lua.Unit.Attribute"
		
		call UnitId( "require" )
	endfunction
endlibrary

#endif
