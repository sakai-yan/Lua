#ifndef LibHcItemAttribute
#define LibHcItemAttribute

library HcItemAttribute initializer Init requires XGJAPI //XGJAPI报错:需要开启Japi优化系统
	function XG_GetItemAttribute takes item it, string attrName returns real
        set XGJAPI_item[1] = it
        set XGJAPI_string[2] = attrName

		call UnitId("XG_GetItemAttribute")

		set XGJAPI_item[1] = null

		return XGJAPI_real[0]
	endfunction

	function XG_GetItemAttribute_String takes item it, string attrName, string sFormat returns string
        set XGJAPI_item[1] = it
        set XGJAPI_string[2] = attrName
		set XGJAPI_string[3] = sFormat

		call UnitId("XG_GetItemAttribute_String")

		set XGJAPI_item[1] = null

		return XGJAPI_string[0]
	endfunction

    function XG_AdjustItemAttribute takes item it, string attrName, string adjustMethod, real value returns nothing
        set XGJAPI_item[1] = it
        set XGJAPI_string[2] = attrName
        set XGJAPI_string[3] = adjustMethod // =  +=  -=
        set XGJAPI_real[4] = value

		call UnitId("XG_AdjustItemAttribute")
		
		set XGJAPI_item[1] = null
	endfunction

	function XG_TransferItemAttribute takes item it, item target returns nothing
        set XGJAPI_item[1] = it
        set XGJAPI_item[2] = target

		call UnitId("XG_TransferItemAttribute")

		set XGJAPI_item[1] = null
		set XGJAPI_item[2] = null
	endfunction

	function XG_CopyItemAttribute takes item it, item target, boolean overwriteOrOverride returns nothing
        set XGJAPI_item[1] = it
        set XGJAPI_item[2] = target
		set XGJAPI_bool[3] = overwriteOrOverride

		call UnitId("XG_CopyItemAttribute")

		set XGJAPI_item[1] = null
		set XGJAPI_item[2] = null
	endfunction

	function XG_RemoveItemAttribute takes item it returns nothing
        set XGJAPI_item[1] = it

		call UnitId("XG_RemoveItemAttribute")

		set XGJAPI_item[1] = null
	endfunction

	function XG_GetItemAttributeDataId takes item it returns integer
        set XGJAPI_item[1] = it

		call UnitId("XG_GetItemAttributeDataId")

		set XGJAPI_item[1] = null
		return XGJAPI_integer[0]
	endfunction

	function XG_SetItemAttributeDataId takes item it, integer v returns nothing
        set XGJAPI_item[1] = it
		set XGJAPI_integer[2] = v

		call UnitId("XG_SetItemAttributeDataId")

		set XGJAPI_item[1] = null
	endfunction

	private function Init takes nothing returns nothing
		call XG_ImportFile("XueYue\\Japi\\Lua\\Item\\Attribute\\init.lua","XG_JAPI\\Lua\\Item\\Attribute.lua")
        set XGJAPI_string[1] = "XG_JAPI.Lua.Item.Attribute"
		
		call UnitId( "require" )
	endfunction
endlibrary

#endif
