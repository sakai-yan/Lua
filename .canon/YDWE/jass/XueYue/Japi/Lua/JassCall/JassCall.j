#ifndef XG_JassCall_H
#define XG_JassCall_H

#include "BlizzardAPI.j"
#define XG_JassCall_Debug //
$def XGJASSCALL
library XGJassCall initializer Init requires XGJAPI,BzAPI
	globals
		private trigger mainTrigger = CreateTrigger()
		private hashtable ht = InitHashtable()
		boolean XG_JassCall_IsLoaded = false
		private trigger tempTrigger = CreateTrigger()
	endglobals

	//注册一个函数到lua,注册后的函数可以由lua调用,返回true表示注册成功
    function XG_JassCall_RegisterWithLua takes string funcName, code c returns boolean
        set XGJAPI_string[1] = funcName
		set XGJAPI_code = c
		call UnitId("XG_JassCall_RegisterWithLua") 
		return XGJAPI_integer[0] == 0
    endfunction

	function XG_JassCall_C2I takes code c returns integer
		set XGJAPI_code = c
		call UnitId("XG_JassCall_C2I")
		return XGJAPI_integer[0]
	endfunction
	//safe call: 必须使用XG_JassCall_C2I转化过的code才支持，避免一些危险操作导致崩溃
	function XG_JassCall_I2C takes integer i returns code
		set XGJAPI_integer[1] = i
		call UnitId("XG_JassCall_I2C")
		return XGJAPI_code
	endfunction

	function XG_JassCall_CallRegisterCode takes string funcName returns nothing
		set XGJAPI_string[1] = funcName
		call UnitId("XG_JassCall_CallRegisterCode")
	endfunction

	function XG_JassCall_CallByIndex takes integer i returns nothing
		set XGJAPI_integer[1] = i
		call UnitId("XG_JassCall_CallByIndex")
	endfunction

	function XG_JassCall_Redirect takes nothing returns nothing
		local integer f 
		local code c

		//call UnitId("XG_JassCall_GetTrigger")
		set f = XGJAPI_integer[1]
		set c = XGJAPI_code
		XG_JassCall_Debug call BJDebugMsg("XG_JassCall triggerAction:" + I2S(f) + "; " + I2S( XGJAPI_integer[1] ))
		//call TriggerAddCondition( tempTrigger, Condition(c) )
		//call TriggerEvaluate( tempTrigger )
		//call TriggerClearConditions( tempTrigger )

	endfunction

	private function triggerAction takes nothing returns nothing
		
	endfunction

	private function Init takes nothing returns nothing
		call XG_ImportFile("XueYue\\Japi\\Lua\\JassCall\\JassCall.lua","XG_JAPI\\Lua\\JassCall\\JassCall.lua")
        set XGJAPI_string[1] = "XG_JAPI.Lua.JassCall.JassCall"
		call UnitId( "require" )

		call TriggerAddCondition(mainTrigger, Condition(function XG_JassCall_Redirect))
		set XGJAPI_trigger[1] = mainTrigger
		call UnitId("XG_JassCall_Init")
		set XGJAPI_trigger[1] = null
	endfunction

endlibrary

#endif
