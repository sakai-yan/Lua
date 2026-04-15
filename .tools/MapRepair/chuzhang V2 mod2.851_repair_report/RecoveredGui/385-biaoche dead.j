//=========================================================================== 
// Trigger: biaoche dead
//=========================================================================== 
function InitTrig_biaoche_dead takes nothing returns nothing
set gg_trg_biaoche_dead=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_biaoche_dead,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddAction(gg_trg_biaoche_dead,function Trig_biaoche_dead_Actions)
endfunction

function Trig_biaoche_dead_Actions takes nothing returns nothing
if(Trig_biaoche_dead_Func001C())then
set udg_SP=GetUnitLoc(GetTriggerUnit())
if(Trig_biaoche_dead_Func001Func002001())then
call PlaySoundAtPointBJ(gg_snd_CreepAggroWhat1,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99提示：押镖失败！！什么东西都没了！|r")
set udg_yabiao1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_yabiaoA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_yabiaoa[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_yabiaoc[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
call RemoveLocation(udg_SP)
else
endif
if(Trig_biaoche_dead_Func002C())then
call ForGroupBJ(GetUnitsInRectMatching(GetPlayableMapRect(),Condition(function Trig_biaoche_dead_Func002Func001001002)),function Trig_biaoche_dead_Func002Func001A)
set udg_SP=GetUnitLoc(GetTriggerUnit())
if(Trig_biaoche_dead_Func002Func003001())then
call PlaySoundAtPointBJ(gg_snd_CreepAggroWhat1,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99提示：押镖失败！！什么东西都没了！|r")
set udg_yabiao1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_yabiaoA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_yabiaoa[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_yabiaoc[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
call RemoveLocation(udg_SP)
else
endif
endfunction

function Trig_biaoche_dead_Func002Func001001002 takes nothing returns boolean
return GetBooleanAnd(Trig_biaoche_dead_Func002Func001001002001(),Trig_biaoche_dead_Func002Func001001002002())
endfunction