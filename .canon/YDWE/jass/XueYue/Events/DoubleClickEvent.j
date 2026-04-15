#ifndef XGDoubleClickEventIncluded
#define XGDoubleClickEventIncluded
#include "XueYue\Base.j"
library XGDoubleClickEvent initializer Init requires XGbase

    
    globals
        private trigger array Trigger
        private timer Timer
        private integer array IX
    endglobals

    //最大玩家数
    #define MAX_PLAYER_COUNT 16
    //当前tick
    #define CURRENT_TICK IX[99]
    //双击的tick间隔
    #define DELAY_TICK 25
    //事件计数
    #define TRIGGER_COUNT IX[98]
    //玩家选中单位
    #define PLAYER_SELECTED_UNIT(pid) IX[pid]
    //玩家选中单位时的tick
    #define PLAYER_SELECTED_TICK(pid) IX[pid + MAX_PLAYER_COUNT]

    private function Timer_Code takes nothing returns nothing
        set CURRENT_TICK = CURRENT_TICK + 1
    endfunction

    function XG_DoubleClick_Reg takes trigger trg returns nothing
        set TRIGGER_COUNT = TRIGGER_COUNT + 1
        set Trigger[TRIGGER_COUNT] = trg
    endfunction

    private function Action takes nothing returns nothing
        local integer hUnit = GetHandleId(GetTriggerUnit())
        local integer i = GetPlayerId(GetTriggerPlayer())

        if PLAYER_SELECTED_UNIT(i) == hUnit and PLAYER_SELECTED_TICK(i) + DELAY_TICK >= CURRENT_TICK then
            set PLAYER_SELECTED_UNIT(i) = 0
            set PLAYER_SELECTED_TICK(i) = 0
            
            set i = 1
            loop
                exitwhen i > TRIGGER_COUNT
                if IsTriggerEnabled(Trigger[i]) then
                    if TriggerEvaluate(Trigger[i]) then
                        call TriggerExecute(Trigger[i])
                    endif
                endif
                set i = i + 1
            endloop

        else
            set PLAYER_SELECTED_UNIT(i) = hUnit
            set PLAYER_SELECTED_TICK(i) = CURRENT_TICK
        endif

    endfunction
    private function Init takes nothing returns nothing
        local integer i = 0

        set TRIGGER_COUNT = 0
        set CURRENT_TICK = 0
        set Timer = CreateTimer()
        call TimerStart(Timer, 0.01, true, function Timer_Code)

        set Trigger[0] = CreateTrigger()
        loop
            set PLAYER_SELECTED_TICK(i) = 0
            set PLAYER_SELECTED_UNIT(i) = 0
            call TriggerRegisterPlayerUnitEvent(Trigger[0], Player(i), EVENT_PLAYER_UNIT_SELECTED, null)
            set i = i + 1
            exitwhen i == MAX_PLAYER_COUNT
        endloop

        call TriggerAddAction(Trigger[0], function Action)
    endfunction

    #undef MAX_PLAYER_COUNT
    #undef CURRENT_TICK
    #undef DELAY_TICK
    #undef TRIGGER_COUNT
    #undef PLAYER_SELECTED_UNIT
    #undef PLAYER_SELECTED_TICK

endlibrary
#endif
