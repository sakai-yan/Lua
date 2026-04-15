//=========================================================================== 
// Trigger: jianxuan11
//=========================================================================== 
function InitTrig_jianxuan11 takes nothing returns nothing
set gg_trg_jianxuan11=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_jianxuan11,356.00,gg_unit_nfor_0612)
call TriggerAddCondition(gg_trg_jianxuan11,Condition(function Trig_jianxuan11_Conditions))
call TriggerAddAction(gg_trg_jianxuan11,function Trig_jianxuan11_Actions)
endfunction

function Trig_jianxuan11_Actions takes nothing returns nothing
call PauseUnitBJ(false,gg_unit_ndqn_0615)
set udg_MP_jianxuan10[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nfor_0612)
if(Trig_jianxuan11_Func010001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00尹月行：|r|cFFCCFFCC不捉我？师门追究下来你该如何？既然如此~~~我看你为人还不错，我便传授你剑玄绝技。放心吧！我传你的是正宗的太虚绝技，就算你想修炼禁术，我也不会教你的！\n|r|cFFFFCC00你：|r|cFFCCFFCC多谢前辈！\n\n|r|cFF00FF00成|r|cFF00FF40功|r|cFF00FF80转|r|cFF00FFBF职|r|cFF00FFFF：|r|cFFFFFF00剑玄师|r")
if(Trig_jianxuan11_Func012001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_jianxuan11_Func013001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call UnitAddAbilityBJ('ANso',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('Ambd',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+5)]='AUin'
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+6)]='Ambd'

                                                                              //88

call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A02S'
set udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
endfunction

function Trig_jianxuan11_Conditions takes nothing returns boolean
if(not(udg_MP_jianxuan9[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_jianxuan10[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(udg_MP_jianxuan_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=10))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==0))then
return false
endif
return true
endfunction