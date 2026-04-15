#ifndef XGJAPIIncluded
#define XGJAPIIncluded
    $def XG_JAPI
    //#define XGJAPI_MAX_PARAM_SIZE 32
    //#define XGJAPI_MAX_STACK 200

    //#define XGJAPI_STACK_ALLOC set XGJAPI_integer[8191] = XGJAPI_integer[8191] + 1
    //#define XGJAPI_STACK_FREE set XGJAPI_integer[8191] = XGJAPI_integer[8191] - 1

    //#define XGJAPI_ADDRESS_CUR (XGJAPI_integer[8191] * XGJAPI_MAX_PARAM_SIZE)
    //#define XGJAPI_ADDRESS_LAST ((XGJAPI_integer[8191]+1) * XGJAPI_MAX_PARAM_SIZE)

library XGJAPI initializer Init

	globals
        private trigger JassCall = CreateTrigger()
        private hashtable VaildCodes = InitHashtable()

		string  array   XGJAPI_string
        integer array   XGJAPI_integer
        real    array   XGJAPI_real
        boolean array   XGJAPI_bool
        unit    array   XGJAPI_unit
        item    array   XGJAPI_item
        trigger array   XGJAPI_trigger
        player  array   XGJAPI_player
        code XGJAPI_code

	endglobals

    function XGJAPI_DoNothing takes nothing returns nothing

    endfunction

    // === 暂时不使用,有bug ===
    //====================================
    function XGJAPI_ReturnUnit takes unit u returns unit
        set XGJAPI_unit[0] = null
        return u
    endfunction
    function XGJAPI_ReturnItem takes item it returns item
        set XGJAPI_item[0] = null
        return it
    endfunction
    function XGJAPI_ReturnTrigger takes trigger trig returns trigger
        set XGJAPI_trigger[0] = null
        return trig
    endfunction
    //player作为常驻handle就不用排了
    //===================================
    
    function XG_StringContact_Lv3 takes string s1, string s2, string s3 returns string

		set XGJAPI_string[ 1] = s1
		set XGJAPI_string[ 2] = s2
		set XGJAPI_string[ 3] = s3
		call UnitId("XG_StringContact_Lv3")

		return XGJAPI_string[0]
    endfunction

	function XG_JAPI_ON takes nothing returns nothing
        call XG_ImportFile("XueYue\\Japi\\Lua\\XGEDITOR_DEBUG.lua","XG_JAPI\\XGEDITOR_DEBUG.lua")

        call XG_ImportFile("XueYue\\Japi\\Lua\\Main.lua","XG_JAPI\\Lua\\Main.lua")
        call XG_ImportFile("XueYue\\Japi\\Lua\\Common.lua","XG_JAPI\\Lua\\Common.lua")
        call XG_ImportFile("XueYue\\Japi\\Lua\\PatchCJ.lua","XG_JAPI\\Lua\\PatchCJ.lua")
        call XG_ImportFile("XueYue\\Japi\\Lua\\Message.lua","XG_JAPI\\Lua\\Message.lua")
        call XG_ImportFile("XueYue\\Japi\\Lua\\Queue.lua","XG_JAPI\\Lua\\Queue.lua")
        call XG_ImportFile("XueYue\\Japi\\Lua\\time\\timer.lua","XG_JAPI\\Lua\\time\\timer.lua")

        call XG_ImportFile("XueYue\\Japi\\Lua\\Mouse.lua","XG_JAPI\\Lua\\Mouse.lua")
        call XG_ImportFile("XueYue\\Japi\\Lua\\Window.lua","XG_JAPI\\Lua\\Window.lua")
        call XG_ImportFile("XueYue\\Japi\\Lua\\EventPool.lua","XG_JAPI\\Lua\\EventPool.lua")
        call XG_ImportFile("XueYue\\Japi\\Lua\\Trigger.lua","XG_JAPI\\Lua\\Trigger.lua")
        call XG_ImportFile("XueYue\\Japi\\Lua\\Const.lua","XG_JAPI\\Lua\\Const.lua")
        call XG_ImportFolder("XueYue\\Japi\\Lua\\XUI","XG_JAPI\\Lua\\XUI")


        //如果这里报错说明雪月编译器出BUG 或者 你用的不是雪月编辑器，而是整合的，整合者未整合完全，缺少雪月编译器
	endfunction

    private function initVariable takes nothing returns nothing
        local integer i = 0
        if XGJAPI_integer[8191] == -1 then //destroy
            call DestroyTrigger(JassCall)
            set JassCall = null
        elseif XGJAPI_integer[8191] == 1 then //unit
            loop
                set i = i + 1
                set XGJAPI_unit[i] = null
    
                exitwhen i >= 8190
            endloop
        elseif XGJAPI_integer[8191] == 2 then //item
            loop
                set i = i + 1
                set XGJAPI_item[i] = null
    
                exitwhen i >= 8190
            endloop
        elseif XGJAPI_integer[8191] == 3 then //trigger
            loop
                set i = i + 1
                set XGJAPI_trigger[i] = null
    
                exitwhen i >= 8190
            endloop
        elseif XGJAPI_integer[8191] == 4 then //string
            loop
                set i = i + 1
                set XGJAPI_string[i] = null

                exitwhen i >= 8190
            endloop
        elseif XGJAPI_integer[8191] == 5 then //code
            set XGJAPI_code = function XGJAPI_DoNothing
        endif

    endfunction

    private function raiseHand takes nothing returns nothing
        if XGJAPI_integer[8191] == -1 then //destroy
            call TriggerClearActions(JassCall)
            call TriggerAddAction( JassCall, function initVariable )
        elseif XGJAPI_integer[8191] == 1 then //unit
            set XGJAPI_unit[8191] = null
        elseif XGJAPI_integer[8191] == 2 then //item
            set XGJAPI_item[8191] = null
        elseif XGJAPI_integer[8191] == 3 then //trigger
            set XGJAPI_trigger[8191] = null
        elseif XGJAPI_integer[8191] == 4 then //player
            set XGJAPI_player[8191] = null
        elseif XGJAPI_integer[8191] == 5 then //code
            set XGJAPI_code = null
        endif
    endfunction

    function XGJAPI_GetStr takes integer index returns string
        return XGJAPI_string[index]
    endfunction
    function XGJAPI_SetStr takes integer index, string str returns nothing
        set XGJAPI_string[index] = str
    endfunction

    function XGJAPI_GetInt takes integer index returns integer
        return XGJAPI_integer[index]
    endfunction
    function XGJAPI_SetInt takes integer index, integer num returns nothing
        set XGJAPI_integer[index] = num
    endfunction

    function XGJAPI_GetReal takes integer index returns real
        return XGJAPI_real[index]
    endfunction
    function XGJAPI_SetReal takes integer index, real num returns nothing
        set XGJAPI_real[index] = num
    endfunction

    private function Init takes nothing returns nothing
        
        call TriggerAddAction( JassCall, function raiseHand )
        //初始化
		set XGJAPI_string[0]    = ""
        set XGJAPI_integer[0]   = 0
        set XGJAPI_real[0]      = 0.00
        set XGJAPI_bool[0]      = false
        set XGJAPI_unit[0]      = null
        set XGJAPI_item[0]      = null
        set XGJAPI_trigger[0] = null
        set XGJAPI_player[0] = null

        //防混淆 lua识别码
        set XGJAPI_string[8191] = "XGJAPI_string"
        set XGJAPI_integer[8191] = StringHash("XGJAPI_integer")
        set XGJAPI_real[8191] = I2R(StringHash("XGJAPI_real"))
        set XGJAPI_bool[8191]  =   true

        //特殊处理
        set XGJAPI_integer[1] = GetHandleId(JassCall)
        set XGJAPI_code = null //function Init

        set XGJAPI_unit[8191] = null
        set XGJAPI_item[8191] = null
        set XGJAPI_trigger[8191] = null
        set XGJAPI_player[8191] = null

		call Lua_Exec( "exec-lua:\"XG_JAPI.Lua.Main\"" )

    endfunction
endlibrary

#endif
