//=========================================================================== 
// Trigger: tianyuan34
//=========================================================================== 
function InitTrig_tianyuan34 takes nothing returns nothing
set gg_trg_tianyuan34=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_tianyuan34,356.00,gg_unit_nlv2_0262)
call TriggerAddCondition(gg_trg_tianyuan34,Condition(function Trig_tianyuan34_Conditions))
call TriggerAddAction(gg_trg_tianyuan34,function Trig_tianyuan34_Actions)
endfunction

function Trig_tianyuan34_Actions takes nothing returns nothing
set udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=3
set udg_SP=GetUnitLoc(GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00蔡景阳：|r|cFFCCFFCC尹月行这个白发魔头恐怕不是你能应付的，为师曾经于他多次交手都被他逃脱了，连我也不能估计我两人之间到底谁的实力会更胜一筹。武林传言，要消灭魔者，灭魔圣器必不可少。要打造此等圣器，只有|r|cFF00FF00天下第一坊的巧木坊|r|cFFCCFFCC才能做到了。为师写一封信于你，你去巧木坊找下|r|cFF00FF00鲁叔祖|r|cFFCCFFCC问下吧！\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00到巧木坊找鲁叔祖|r")
if(Trig_tianyuan34_Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_tianyuan34_Func005001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_npn5_0261)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_tianyuan34_Conditions takes nothing returns boolean
if(not(udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==2))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(GetUnitAbilityLevelSwapped('A00W',GetTriggerUnit())!=0))then
return false
endif
return true
endfunction