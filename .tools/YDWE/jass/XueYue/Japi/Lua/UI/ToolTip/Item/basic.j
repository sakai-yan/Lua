#ifndef  XG_UI_TOOLTIP_ITEM_BASIC_INCLUDED
#define  XG_UI_TOOLTIP_ITEM_BASIC_INCLUDED

library XGUIToolTipItemBasic initializer Init requires XGJAPI
	/*
	function XG_UI_ToolTip_Item_Basic_IconShow takes boolean isShow returns nothing
        set XGJAPI_bool[1] = isShow
		call UnitId("XG_UI_ToolTip_Item_Basic_IconShow")
	endfunction
	*/
	function XG_UI_ToolTip_Item_Basic_On takes nothing returns nothing

	endfunction

	function XG_UI_ToolTip_Item_GetFrame takes string frameName returns integer
		set XGJAPI_string[1] = frameName
		call UnitId("XG_UI_ToolTip_Item_GetFrame")
		return XGJAPI_integer[0]
	endfunction

	function XG_UI_ToolTip_Item_SetFrame takes string frameName, integer f returns nothing
		set XGJAPI_string[1] = frameName
		set XGJAPI_integer[2] = f
		call UnitId("XG_UI_ToolTip_Item_SetFrame")
	endfunction

	function XG_UI_ToolTip_Item_SetString takes item it, string p, string str returns nothing
        set XGJAPI_item[1] = it
        set XGJAPI_string[2] = p
        set XGJAPI_string[3] = str
		call UnitId("XG_UI_ToolTip_Item_SetString")
		set XGJAPI_item[1] = null
	endfunction
	function XG_UI_ToolTip_Item_GetString takes item it, string p returns string
        set XGJAPI_item[1] = it
        set XGJAPI_string[2] = p
		call UnitId("XG_UI_ToolTip_Item_GetString")
		return XGJAPI_string[0]
	endfunction

	function XG_UI_ToolTip_Item_gc takes item it returns nothing
        set XGJAPI_item[1] = it
		call UnitId("XG_UI_ToolTip_Item_gc")
	endfunction

	function XG_UI_ToolTip_Item_SetBoolConstant takes string constName, boolean val returns nothing
        set XGJAPI_string[1] = constName
        set XGJAPI_bool[2] = val
		call UnitId("XG_UI_ToolTip_Item_SetBoolConstant")
	endfunction
	
	private function Init takes nothing returns nothing
		call XG_ImportFile("XueYue\\Japi\\Lua\\UI\\ToolTip\\Item\\basic.lua","XG_JAPI\\Lua\\UI\\ToolTip\\Item\\basic.lua")
		call XG_ImportFile("XueYue\\Japi\\Lua\\UI\\ToolTip\\Item\\fdf.fdf","XG_JAPI\\Lua\\UI\\ToolTip\\Item\\fdf.fdf")
		call XG_ImportFile("XueYue\\Japi\\Lua\\UI\\ToolTip\\Item\\toc.toc","XG_JAPI\\Lua\\UI\\ToolTip\\Item\\toc.toc")

        set XGJAPI_string[1] = "XG_JAPI.Lua.UI.ToolTip.Item.basic"
		//报错:需要开启Japi优化
		call UnitId( "require" )
	endfunction
    
endlibrary
#endif
