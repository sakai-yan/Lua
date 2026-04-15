#ifndef  XG_UI_TOOLTIP_Ability_BASIC_INCLUDED
#define  XG_UI_TOOLTIP_Ability_BASIC_INCLUDED
$def XGUITipToolAbilityBasic
#include "XueYue\\Base.j"
library XGUIToolTipAbilityBasic initializer Init requires XGJAPI,XGbase

	globals
		trigger XGUITipToolAbility_AsyncEventTrigger_Show = CreateTrigger()
		trigger XGUITipToolAbility_AsyncEventTrigger_Hide = CreateTrigger()
	endglobals
	

	function XG_UI_ToolTip_Ability_Basic_On takes nothing returns nothing

	endfunction

	function XG_UI_ToolTip_Ability_GetInt takes integer cons returns integer
		return LoadInteger( Xg_htb, GetHandleId(XGUITipToolAbility_AsyncEventTrigger_Show), cons )
	endfunction

	function XG_UI_ToolTip_Ability_GetFrame takes string frameName returns integer
		set XGJAPI_string[1] = frameName
		call UnitId("XG_UI_ToolTip_Ability_GetFrame")
		return XGJAPI_integer[0]
	endfunction

	function XG_UI_ToolTip_Ability_SetFrame takes string frameName, integer f returns nothing
		set XGJAPI_string[1] = frameName
		set XGJAPI_integer[2] = f
		call UnitId("XG_UI_ToolTip_Ability_SetFrame")
	endfunction

	function XG_UI_ToolTip_Ability_EnableFormulaSupport takes nothing returns nothing
		call UnitId("XG_UI_ToolTip_Ability_EnableFormulaSupport")
	endfunction

	function XG_UI_ToolTip_Ability_SetBoolConstant takes string constName, boolean val returns nothing
        set XGJAPI_string[1] = constName
        set XGJAPI_bool[2] = val
		call UnitId("XG_UI_ToolTip_Ability_SetBoolConstant")
	endfunction

	function XG_UI_ToolTip_Ability_SetString takes unit u, integer abilcode, integer lv, string p, string str returns nothing
		set XGJAPI_unit[1] = u
        set XGJAPI_integer[2] = abilcode
        set XGJAPI_integer[3] = lv
        set XGJAPI_string[4] = p
        set XGJAPI_string[5] = str
		call UnitId("XG_UI_ToolTip_Ability_SetString")
		set XGJAPI_unit[1] = null
	endfunction

	function XG_UI_ToolTip_Ability_GetString takes unit u, integer abilcode, integer lv, string p returns string
		set XGJAPI_unit[1] = u
        set XGJAPI_integer[2] = abilcode
        set XGJAPI_integer[3] = lv
        set XGJAPI_string[4] = p
		call UnitId("XG_UI_ToolTip_Ability_GetString")
		return XGJAPI_string[0]
	endfunction

	function XG_UI_ToolTip_Ability_GetFormulaValue takes unit u, integer abilcode, integer lv, string p returns real
		set XGJAPI_unit[1] = u
        set XGJAPI_integer[2] = abilcode
        set XGJAPI_integer[3] = lv
        set XGJAPI_string[4] = p
		call UnitId("XG_UI_ToolTip_Ability_GetFormulaValue")
		return XGJAPI_real[0]
	endfunction

	function XG_UI_ToolTip_Ability_gc takes unit u, integer abilcode, integer lv returns nothing
		set XGJAPI_unit[1] = u
        set XGJAPI_integer[2] = abilcode
        set XGJAPI_integer[3] = lv
		call UnitId("XG_UI_ToolTip_Ability_gc")
	endfunction

	private function Init takes nothing returns nothing
		call XG_ImportFile("XueYue\\Japi\\Lua\\UI\\ToolTip\\Ability\\basic.lua","XG_JAPI\\Lua\\UI\\ToolTip\\Ability\\basic.lua")
		call XG_ImportFile("XueYue\\Japi\\Lua\\UI\\ToolTip\\Ability\\fdf.fdf","XG_JAPI\\Lua\\UI\\ToolTip\\Ability\\fdf.fdf")
		call XG_ImportFile("XueYue\\Japi\\Lua\\UI\\ToolTip\\Ability\\toc.toc","XG_JAPI\\Lua\\UI\\ToolTip\\Ability\\toc.toc")

        set XGJAPI_string[1] = "XG_JAPI.Lua.UI.ToolTip.Ability.basic"
		set XGJAPI_trigger[1] = XGUITipToolAbility_AsyncEventTrigger_Show
		set XGJAPI_trigger[2] = XGUITipToolAbility_AsyncEventTrigger_Hide
		set XGJAPI_integer[3] = GetHandleId( Xg_htb )
		call UnitId( "require" )
		set XGJAPI_trigger[1] = null
		set XGJAPI_trigger[2] = null
	endfunction
    
endlibrary
#endif
