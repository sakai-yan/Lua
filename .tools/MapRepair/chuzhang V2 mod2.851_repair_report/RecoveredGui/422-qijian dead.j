//=========================================================================== 
// Trigger: qijian dead
//=========================================================================== 
function InitTrig_qijian_dead takes nothing returns nothing
set gg_trg_qijian_dead=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_qijian_dead,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_qijian_dead,Condition(function Trig_qijian_dead_Conditions))
call TriggerAddAction(gg_trg_qijian_dead,function Trig_qijian_dead_Actions)
endfunction

function Trig_qijian_dead_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetTriggerUnit())
if(Trig_qijian_dead_Func002001())then
call PlaySoundAtPointBJ(gg_snd_CreepAggroWhat1,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99提示：小云又走丢了，回寻仙村再找找吧！|r")
set udg_MP_qijian_true[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
endfunction

function Trig_qijian_dead_Conditions takes nothing returns boolean
if(not(GetUnitTypeId(GetTriggerUnit())=='nwe2'))then
return false
endif
return true
endfunction