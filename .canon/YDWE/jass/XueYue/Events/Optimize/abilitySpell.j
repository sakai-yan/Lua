#ifndef included_Optimize_AbilityEvent
#define included_Optimize_AbilityEvent

library XGOptimizeAbilityEvent
    
    globals
        private trigger array triggers
        private hashtable map = InitHashtable()
    endglobals
    //====  spellType  ====
    #define SPELL_TYPE_CHANNEL    1  /*准备施放技能(前摇开始)*/
    #define SPELL_TYPE_CAST       2  /*开始施放技能(前摇结束)*/
    #define SPELL_TYPE_ENDCAST    3  /*停止施放技能*/
    #define SPELL_TYPE_EFFECT     4  /*发动技能效果(后摇开始)*/
    #define SPELL_TYPE_FINISH     5  /*施放技能结束(后摇结束)*/
    //=====================

    #define TRIGGER_SPELL_CHANNEL   triggers[SPELL_TYPE_CHANNEL]
    #define TRIGGER_SPELL_CAST      triggers[SPELL_TYPE_CAST]
    #define TRIGGER_SPELL_ENDCAST   triggers[SPELL_TYPE_ENDCAST]
    #define TRIGGER_SPELL_EFFECT    triggers[SPELL_TYPE_EFFECT]
    #define TRIGGER_SPELL_FINISH    triggers[SPELL_TYPE_FINISH]

    private function getNode takes integer abilId, integer spellType returns integer
        local integer node = LoadInteger(map, abilId, spellType)
        if node != 0 then
            return node
        endif
        
        set node = LoadInteger(map, 0, 0) + 1
        call SaveInteger(map, 0, 0, node)

        call SaveInteger(map, abilId, spellType, node)

        return node
    endfunction

    // i    （abilId）  技能id
    // count (spellType) 技能类型
    private function onSpellCenter takes integer i, integer count returns nothing
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

    //准备施放技能
    private function onSpellChannel takes nothing returns nothing
        call onSpellCenter(GetSpellAbilityId(), SPELL_TYPE_CHANNEL)
    endfunction
    
    //开始施放技能
    private function onSpellCast takes nothing returns nothing
        call onSpellCenter(GetSpellAbilityId(), SPELL_TYPE_CAST)
    endfunction
    
    //停止施放技能
    private function onSpellEndCast takes nothing returns nothing
        call onSpellCenter(GetSpellAbilityId(), SPELL_TYPE_ENDCAST)
    endfunction

    //施放技能效果
    private function onSpellEffect takes nothing returns nothing
        call onSpellCenter(GetSpellAbilityId(), SPELL_TYPE_EFFECT)
    endfunction
    
    //施放技能结束
    private function onSpellFinish takes nothing returns nothing
        call onSpellCenter(GetSpellAbilityId(), SPELL_TYPE_FINISH)
    endfunction


    function XG_OptimizeEvent_Register_AbilitySpell takes trigger trig, integer abilId, integer spellType returns nothing
        local integer node = getNode(abilId, spellType)
        local integer count =  LoadInteger(map, node, 0) + 1
        
        call SaveInteger(map, node, 0, count)

        call SaveTriggerHandle(map, node, count,  trig)
        
        if LoadBoolean(map, spellType, 0) == false then
            call SaveBoolean(map, spellType, 0, true)
            set node = 0
            if spellType == SPELL_TYPE_CHANNEL then
                set TRIGGER_SPELL_CHANNEL = CreateTrigger()
                loop
                    call TriggerRegisterPlayerUnitEvent(    \
                        TRIGGER_SPELL_CHANNEL,              \
                        Player(node),                       \
                        EVENT_PLAYER_UNIT_SPELL_CHANNEL,    \
                        null                                \
                    )
                    set node = node + 1
                    exitwhen node > 15
                endloop
                call TriggerAddAction( TRIGGER_SPELL_CHANNEL,  function onSpellChannel )
            elseif spellType == SPELL_TYPE_CAST then
                set TRIGGER_SPELL_CAST  = CreateTrigger()
                loop
                    call TriggerRegisterPlayerUnitEvent(    \
                        TRIGGER_SPELL_CAST,               \
                        Player(node),                       \
                        EVENT_PLAYER_UNIT_SPELL_CAST,     \
                        null                                \
                    )
                    set node = node + 1
                    exitwhen node > 15
                endloop
                call TriggerAddAction( TRIGGER_SPELL_CAST ,  function onSpellCast  )
            elseif spellType == SPELL_TYPE_ENDCAST then
                set TRIGGER_SPELL_ENDCAST  = CreateTrigger()
                loop
                    call TriggerRegisterPlayerUnitEvent(    \
                        TRIGGER_SPELL_ENDCAST,               \
                        Player(node),                       \
                        EVENT_PLAYER_UNIT_SPELL_ENDCAST,     \
                        null                                \
                    )
                    set node = node + 1
                    exitwhen node > 15
                endloop
                call TriggerAddAction( TRIGGER_SPELL_ENDCAST ,  function onSpellEndCast  )
            elseif spellType == SPELL_TYPE_EFFECT then
                set TRIGGER_SPELL_EFFECT  = CreateTrigger()
                loop
                    call TriggerRegisterPlayerUnitEvent(    \
                        TRIGGER_SPELL_EFFECT,               \
                        Player(node),                       \
                        EVENT_PLAYER_UNIT_SPELL_EFFECT,     \
                        null                                \
                    )
                    set node = node + 1
                    exitwhen node > 15
                endloop
                call TriggerAddAction( TRIGGER_SPELL_EFFECT ,  function onSpellEffect  )
            elseif spellType == SPELL_TYPE_FINISH then
                set TRIGGER_SPELL_FINISH  = CreateTrigger()
                loop
                    call TriggerRegisterPlayerUnitEvent(    \
                        TRIGGER_SPELL_FINISH,               \
                        Player(node),                       \
                        EVENT_PLAYER_UNIT_SPELL_FINISH,     \
                        null                                \
                    )
                    set node = node + 1
                    exitwhen node > 15
                endloop
                call TriggerAddAction( TRIGGER_SPELL_FINISH ,  function onSpellFinish  )
            
            endif

        endif
    endfunction

    #undef SPELL_TYPE_CHANNEL
    #undef SPELL_TYPE_CAST
    #undef SPELL_TYPE_ENDCAST
    #undef SPELL_TYPE_EFFECT
    #undef SPELL_TYPE_FINISH

    #undef TRIGGER_SPELL_CHANNEL
    #undef TRIGGER_SPELL_CAST
    #undef TRIGGER_SPELL_ENDCAST
    #undef TRIGGER_SPELL_EFFECT
    #undef TRIGGER_SPELL_FINISH

endlibrary

#endif

