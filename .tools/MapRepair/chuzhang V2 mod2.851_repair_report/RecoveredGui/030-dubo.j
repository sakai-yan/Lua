//=========================================================================== 
// Trigger: dubo
//=========================================================================== 
function InitTrig_dubo takes nothing returns nothing
set gg_trg_dubo=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_dubo,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_dubo,Condition(function Trig_dubo_Conditions))
call TriggerAddAction(gg_trg_dubo,function Trig_dubo_Actions)
endfunction

function Trig_dubo_Actions takes nothing returns nothing
if(Trig_dubo_Func003C())then
call AdjustPlayerStateBJ(1000,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1000)
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,5.00,"恭喜你赢得了1000铜钱")
set udg_SP=GetUnitLoc(GetTriggerUnit())
if(Trig_dubo_Func003Func009001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,5.00,"你输掉了500铜钱...")
set udg_SP=GetUnitLoc(GetTriggerUnit())
if(Trig_dubo_Func003Func003001())then
call PlaySoundAtPointBJ(gg_snd_CreepAggroWhat1,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
endfunction

function Trig_dubo_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='rreb'))then
return false
endif
return true
endfunction