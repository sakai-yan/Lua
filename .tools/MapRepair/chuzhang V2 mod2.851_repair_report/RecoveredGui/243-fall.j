//=========================================================================== 
// Trigger: fall
//=========================================================================== 
function InitTrig_fall takes nothing returns nothing
set gg_trg_fall=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_fall,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_fall,Condition(function Trig_fall_Conditions))
call TriggerAddAction(gg_trg_fall,function Trig_fall_Actions)
endfunction

function Trig_fall_Actions takes nothing returns nothing
if(Trig_fall_Func001C())then
if(Trig_fall_Func001Func001C())then
set bj_forLoopAIndex=1
set bj_forLoopAIndexEnd=11
loop
exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
if(Trig_fall_Func001Func001Func005Func001C())then
call ForForce(GetPlayersMatching(Condition(function Trig_fall_Func001Func001Func005Func001Func001001001)),function Trig_fall_Func001Func001Func005Func001Func001A)
set udg_PLAY_GROUP_NO[GetForLoopIndexA()]=0
else
endif
set bj_forLoopAIndex=bj_forLoopAIndex+1
endloop
set udg_PLAY_GROUP_NO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
else
call ForForce(GetPlayersMatching(Condition(function Trig_fall_Func001Func001Func001001001)),function Trig_fall_Func001Func001Func001A)
set udg_PLAY_GROUP_leader[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))]=null
set udg_PLAY_GROUP_NO[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))]=0
if(Trig_fall_Func001Func001Func004C())then
set udg_PLAY_GROUP_NO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
else
endif
endif
else
if(Trig_fall_Func001Func002C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFFF0000系统信息：|r"+("|cffffff00"+("你"+"|R离开了队伍"))))
call ForForce(GetPlayersMatching(Condition(function Trig_fall_Func001Func002Func002001001)),function Trig_fall_Func001Func002Func002A)
set udg_PLAY_GROUP_leader[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=null
set udg_PLAY_GROUP_NO[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))]=0
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFFF0000系统信息：|r"+"你无法踢除队员"))
endif
endif
endfunction

function Trig_fall_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A00Z'))then
return false
endif
if(not(IsUnitType(GetSpellTargetUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction

function Trig_fall_Func001Func001Func005Func001Func001001001 takes nothing returns boolean
return(udg_PLAY_GROUP_NO[GetConvertedPlayerId(GetFilterPlayer())]==GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_fall_Func001Func001Func001001001 takes nothing returns boolean
return(udg_PLAY_GROUP_NO[GetConvertedPlayerId(GetFilterPlayer())]==GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit())))
endfunction

function Trig_fall_Func001Func002Func002001001 takes nothing returns boolean
return(udg_PLAY_GROUP_NO[GetConvertedPlayerId(GetFilterPlayer())]==GetConvertedPlayerId(GetOwningPlayer(udg_PLAY_GROUP_leader[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))
endfunction