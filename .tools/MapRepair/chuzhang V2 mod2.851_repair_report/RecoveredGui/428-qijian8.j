//=========================================================================== 
// Trigger: qijian8
//=========================================================================== 
function InitTrig_qijian8 takes nothing returns nothing
set gg_trg_qijian8=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_qijian8,356.00,gg_unit_ndh1_0368)
call TriggerAddCondition(gg_trg_qijian8,Condition(function Trig_qijian8_Conditions))
call TriggerAddAction(gg_trg_qijian8,function Trig_qijian8_Actions)
endfunction

function Trig_qijian8_Actions takes nothing returns nothing
set udg_MP_qijian5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ndh1_0368)
if(Trig_qijian8_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00卓腾云：|r|cFFCCFFCC你为我们御剑门争了光，好样的。恭喜你已经通过了考验。日后要勤加练习，气剑是非常讲究内力的哦！\n\n|r|cFF00FF00成|r|cFF00FF40功|r|cFF00FF80转|r|cFF00FFBF职|r|cFF00FFFF：|r|cFFFFFF00弃剑|r")
call RemoveLocation(udg_SP)
call UnitAddAbilityBJ('AHbn',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('AOhw',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+5)]='AHbn'
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+6)]='AOhw'
                                                                              //4


call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A02S'
set udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
endfunction

function Trig_qijian8_Conditions takes nothing returns boolean
if(not(udg_MP_qijian4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_qijian5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_MP_jianhao_NUM3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=5))then
return false
endif
if(not(udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==0))then
return false
endif
return true
endfunction