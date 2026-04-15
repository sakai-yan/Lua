//=========================================================================== 
// Trigger: zidongheyao
//=========================================================================== 
function InitTrig_zidongheyao takes nothing returns nothing
set gg_trg_zidongheyao=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_zidongheyao,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddAction(gg_trg_zidongheyao,function Trig_zidongheyao_Actions)
endfunction

function Trig_zidongheyao_Actions takes nothing returns nothing
if(Trig_zidongheyao_Func001C())then
call IssueImmediateOrder(GetTriggerUnit(),"stop")
call UnitRemoveAbilityBJ('A080',GetTriggerUnit())
call UnitAddAbilityBJ('A081',GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"你关闭了自动喝药")
else
if(Trig_zidongheyao_Func001Func001C())then
call IssueImmediateOrder(GetTriggerUnit(),"stop")
call UnitRemoveAbilityBJ('A081',GetTriggerUnit())
call UnitAddAbilityBJ('A080',GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"你开启了自动喝药")
else
endif
endif
endfunction