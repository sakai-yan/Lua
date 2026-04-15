#ifndef included_Optimize_UnitEvent
#define included_Optimize_UnitEvent

library XGOptimizeUnitEvent
    
    globals
        private trigger array triggers
        private hashtable map = InitHashtable()
    endglobals
    //====  eventType  ====
    #define EVENT_TYPE_DEATH        1  /*死亡*/
    #define EVENT_TYPE_KILL         2  /*击杀*/
    #define EVENT_TYPE_LEVELUP      3  /*升级*/
    #define EVENT_TYPE_ATTACKED     4  /*被攻击*/
    #define EVENT_TYPE_ATTACK       5  /*攻击*/



    //=====================

    #define TRIGGER_EVENT_DEATH   triggers[EVENT_TYPE_DEATH]
    #define TRIGGER_EVENT_KILL    triggers[EVENT_TYPE_KILL]
    #define TRIGGER_EVENT_LEVELUP triggers[EVENT_TYPE_LEVELUP]
    #define TRIGGER_EVENT_ATTACKED  triggers[EVENT_TYPE_ATTACKED]
    #define TRIGGER_EVENT_ATTACK   triggers[EVENT_TYPE_ATTACK]
    //=====================

    private function getNode takes integer unitId, integer eventType returns integer
        local integer node = LoadInteger(map, unitId, eventType)
        if node != 0 then
            return node
        endif
        
        set node = LoadInteger(map, 0, 0) + 1
        call SaveInteger(map, 0, 0, node)

        call SaveInteger(map, unitId, eventType, node)

        return node
    endfunction

    // i    unitId  单位id
    // count (eventType) 事件类型
    private function onUnitCenter takes integer i, integer count returns nothing
        local trigger trig
        local integer node = getNode( i, count)
        local integer empty = 0
        local integer count_empty = 0

        set i = 0
        set count = LoadInteger(map, node, 0)

        loop

            set i = i + 1
            exitwhen i > count

            set trig = LoadTriggerHandle(map, node, i)
            if trig != null then

                if IsTriggerEnabled(trig) then
                    if TriggerEvaluate(trig) then
                        call TriggerExecute(trig)
                    endif
                endif

                if empty != 0 then
                    call SaveTriggerHandle(map, node, empty, trig)
                    set empty = empty + 1
                endif
            else
                if empty == 0 then
                    set empty = i
                endif
                set count_empty = count_empty + 1   
            endif

        endloop

        set trig = null
        //清除空位
        if count_empty > 0 then
            call SaveInteger(map, node, 0, count - count_empty)
            // [1] [2] [] [] [5] [6]
            loop
                set count_empty = count_empty - 1
                call RemoveSavedHandle(map, node, count - count_empty)
                exitwhen count_empty == 0
            endloop
            
        endif
    endfunction

    //死亡
    private function onEventDeath takes nothing returns nothing
        call onUnitCenter(GetUnitTypeId( GetKillingUnit() ), EVENT_TYPE_KILL)
        call onUnitCenter(GetUnitTypeId( GetDyingUnit() ), EVENT_TYPE_DEATH)
    endfunction
    //升级
    private function onEventLevelUp takes nothing returns nothing
        call onUnitCenter(GetUnitTypeId( GetLevelingUnit() ), EVENT_TYPE_LEVELUP)
    endfunction
    //被攻击
    private function onEventAttacked takes nothing returns nothing
        call onUnitCenter(GetUnitTypeId( GetAttacker() ), EVENT_TYPE_ATTACK)
        call onUnitCenter(GetUnitTypeId( GetTriggerUnit() ), EVENT_TYPE_ATTACKED)
    endfunction

    //=====================

    function XG_OptimizeEvent_Register_Unit takes trigger trig, integer unitId, integer eventType returns nothing
        local integer node = getNode(unitId, eventType)
        local integer count =  LoadInteger(map, node, 0) + 1
        
        call SaveInteger(map, node, 0, count)

        call SaveTriggerHandle(map, node, count,  trig)
        
        if LoadBoolean(map, eventType, 0) == false then
            call SaveBoolean(map, eventType, 0, true)
            set node = 0

            if eventType == EVENT_TYPE_KILL then
                call SaveBoolean(map, EVENT_TYPE_DEATH, 0, true)
                set eventType = EVENT_TYPE_DEATH

            elseif eventType == EVENT_TYPE_ATTACK then
                call SaveBoolean(map, EVENT_TYPE_ATTACKED, 0, true)
                set eventType = EVENT_TYPE_ATTACKED
            
            endif
            
            if eventType == EVENT_TYPE_DEATH then
                set TRIGGER_EVENT_DEATH = CreateTrigger()
                loop
                    call TriggerRegisterPlayerUnitEvent(    \
                        TRIGGER_EVENT_DEATH,                \
                        Player(node),                       \
                        EVENT_PLAYER_UNIT_DEATH,            \
                        null                                \
                    )
                    set node = node + 1
                    exitwhen node > 15
                endloop
                call TriggerAddAction( TRIGGER_EVENT_DEATH,  function onEventDeath )
            elseif eventType == EVENT_TYPE_LEVELUP then
                set TRIGGER_EVENT_LEVELUP = CreateTrigger()
                loop
                    call TriggerRegisterPlayerUnitEvent(    \
                        TRIGGER_EVENT_LEVELUP,              \
                        Player(node),                       \
                        EVENT_PLAYER_HERO_LEVEL,            \
                        null                                \
                    )
                    set node = node + 1
                    exitwhen node > 15
                endloop
                call TriggerAddAction( TRIGGER_EVENT_LEVELUP,  function onEventLevelUp )
            elseif eventType == EVENT_TYPE_ATTACKED then
                set TRIGGER_EVENT_ATTACKED = CreateTrigger()
                loop
                    call TriggerRegisterPlayerUnitEvent(    \
                        TRIGGER_EVENT_ATTACKED,             \
                        Player(node),                       \
                        EVENT_PLAYER_UNIT_ATTACKED,         \
                        null                                \
                    )
                    set node = node + 1
                    exitwhen node > 15
                endloop
                call TriggerAddAction( TRIGGER_EVENT_ATTACKED,  function onEventAttacked )

            
            endif


        endif
    endfunction

    #undef EVENT_TYPE_DEATH
    #undef EVENT_TYPE_KILL
    #undef EVENT_TYPE_LEVELUP
    #undef EVENT_TYPE_ATTACKED
    #undef EVENT_TYPE_ATTACK

    #undef TRIGGER_EVENT_DEATH
    #undef TRIGGER_EVENT_KILL
    #undef TRIGGER_EVENT_LEVELUP
    #undef TRIGGER_EVENT_ATTACKED
    #undef TRIGGER_EVENT_ATTACK


endlibrary

#endif

