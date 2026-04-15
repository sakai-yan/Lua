//=========================================================================== 
// Trigger: shudao8
//=========================================================================== 
function InitTrig_shudao8 takes nothing returns nothing
set gg_trg_shudao8=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_shudao8,356.00,gg_unit_ners_0599)
call TriggerAddCondition(gg_trg_shudao8,Condition(function Trig_shudao8_Conditions))
call TriggerAddAction(gg_trg_shudao8,function Trig_shudao8_Actions)
endfunction

function Trig_shudao8_Actions takes nothing returns nothing
set udg_MP_shudao6[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ners_0599)
if(Trig_shudao8_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00张真人：|r|cFFCCFFCC很好，你再次拯救了许多人的生命，这个也是我们的道。接下来我不会再安排任务给你了，不要离开自己的道，按自己的想法去做吧。你的资质不错，适合成为蜀道师，我现在传授你功力。\n|r|cFF00FF00成|r|cFF00FF40功|r|cFF00FF80转|r|cFF00FFBF职|r|cFF00FFFF：|r|cFFFFFF00蜀道师|r")
if(Trig_shudao8_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_shudao8_Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call UnitAddAbilityBJ('Ahwd',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('Aspl',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+5)]='Ahwd'
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+6)]='Aspl'


                                                      //7


call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A02S'
set udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
endfunction

function Trig_shudao8_Conditions takes nothing returns boolean
if(not(udg_MP_shudao6[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(udg_MP_shudao5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==0))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction