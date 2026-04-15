//=========================================================================== 
// Trigger: great
//=========================================================================== 
function InitTrig_great takes nothing returns nothing
set gg_trg_great=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_great,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_great,Condition(function Trig_great_Conditions))
call TriggerAddAction(gg_trg_great,function Trig_great_Actions)
endfunction

function Trig_great_Actions takes nothing returns nothing
if(Trig_great_Func001C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFFF0000系统信息：|r"+("|cffffff00"+"在城里无法组队")))
if(Trig_great_Func001Func002001())then
call PlaySoundBJ(gg_snd_QuestLog)
else
call DoNothing()
endif
else
if(Trig_great_Func001Func003C())then
set udg_PLAY_GROUP_NO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))
set udg_PLAY_GROUP_leader[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))]=GetTriggerUnit()
call DialogClear(udg_PLAY_GROUP[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))])
call DialogSetMessage(udg_PLAY_GROUP[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))],(GetPlayerName(GetOwningPlayer(GetTriggerUnit()))+"邀请你加入队伍"))
call DialogAddButtonBJ(udg_PLAY_GROUP[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))],"同意")
set udg_PLAY_GROUP_set1[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_PLAY_GROUP[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))],"拒绝")
set udg_PLAY_GROUP_set2[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))]=GetLastCreatedButtonBJ()
call DialogDisplayBJ(true,udg_PLAY_GROUP[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))],GetOwningPlayer(GetSpellTargetUnit()))
else
endif
endif
endfunction

function Trig_great_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A00Y'))then
return false
endif
if(not(IsUnitType(GetSpellTargetUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction