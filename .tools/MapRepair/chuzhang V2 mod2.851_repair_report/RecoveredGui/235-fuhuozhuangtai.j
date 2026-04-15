//=========================================================================== 
// Trigger: fuhuozhuangtai
//=========================================================================== 
function InitTrig_fuhuozhuangtai takes nothing returns nothing
set gg_trg_fuhuozhuangtai=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_fuhuozhuangtai,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddAction(gg_trg_fuhuozhuangtai,function Trig_fuhuozhuangtai_Actions)
endfunction

function Trig_fuhuozhuangtai_Actions takes nothing returns nothing
if(Trig_fuhuozhuangtai_Func001C())then
call PauseTimerBJ(true,udg_hero_time[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitPauseTimedLifeBJ(true,GetTriggerUnit())
call IssueImmediateOrder(GetTriggerUnit(),"stop")
call UnitRemoveAbilityBJ('A083',GetTriggerUnit())
call UnitAddAbilityBJ('A082',GetTriggerUnit())
call TimerDialogSetTitle(udg_hero_window[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],"等待救援")
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"你选择等待救援")
else
if(Trig_fuhuozhuangtai_Func001Func003C())then
call DestroyTimerDialog(udg_hero_window[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call PauseTimerBJ(false,udg_hero_time[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call StartTimerBJ(udg_hero_time[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false,15.00)
call CreateTimerDialogBJ(GetLastCreatedTimerBJ(),(GetPlayerName(GetOwningPlayer(GetTriggerUnit()))+"复活"))
set udg_hero_window[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetLastCreatedTimerDialogBJ()
call UnitApplyTimedLifeBJ(15.00,'BTLF',GetTriggerUnit())
call IssueImmediateOrder(GetTriggerUnit(),"stop")
call UnitRemoveAbilityBJ('A082',GetTriggerUnit())
call UnitAddAbilityBJ('A083',GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"你选择回城复活")
else
endif
endif
endfunction