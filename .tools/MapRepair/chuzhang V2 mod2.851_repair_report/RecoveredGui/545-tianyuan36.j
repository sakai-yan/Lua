//=========================================================================== 
// Trigger: tianyuan36
//=========================================================================== 
function InitTrig_tianyuan36 takes nothing returns nothing
set gg_trg_tianyuan36=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_tianyuan36,356.00,gg_unit_ncgb_0629)
call TriggerAddCondition(gg_trg_tianyuan36,Condition(function Trig_tianyuan36_Conditions))
call TriggerAddAction(gg_trg_tianyuan36,function Trig_tianyuan36_Actions)
endfunction

function Trig_tianyuan36_Actions takes nothing returns nothing
set udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=3
set udg_SP=GetUnitLoc(GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00半蓑人：|r|cFFCCFFCC杀死了下仙的人么？哈哈哈哈哈！我很欣赏做出惊天动地的事情的人物，我们鬼门要想复兴起来，也必须这样。抢在武林其他门派之前，消灭这个武林公敌吧，虽然对他我并不反感。灭魔圣器是对付魔物的唯一方法。你到龙泉镇去找|r|cFF00FF00山海镖局总镖头任我飞|r|cFFCCFFCC打探下吧，我记得他貌似拥有此类法宝。\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00到龙泉阵找任我飞|r")
if(Trig_tianyuan36_Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_tianyuan36_Func005001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ndtp_0375)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_tianyuan36_Conditions takes nothing returns boolean
if(not(udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==2))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(GetUnitAbilityLevelSwapped('A013',GetTriggerUnit())!=0))then
return false
endif
return true
endfunction