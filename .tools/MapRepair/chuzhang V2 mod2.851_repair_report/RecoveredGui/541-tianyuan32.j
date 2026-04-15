//=========================================================================== 
// Trigger: tianyuan32
//=========================================================================== 
function InitTrig_tianyuan32 takes nothing returns nothing
set gg_trg_tianyuan32=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_tianyuan32,356.00,gg_unit_nfa2_0514)
call TriggerAddCondition(gg_trg_tianyuan32,Condition(function Trig_tianyuan32_Conditions))
call TriggerAddAction(gg_trg_tianyuan32,function Trig_tianyuan32_Actions)
endfunction

function Trig_tianyuan32_Actions takes nothing returns nothing
set udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=3
set udg_SP=GetUnitLoc(GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00智空大师：|r|cFFCCFFCC你说的应该是太虚门的叛徒尹月行吧。此人魔性显赫，不但维护夜墨余党，更在幽州一役杀死下仙李秦，罪孽深重。作为佛门子弟，灭罪之责义不容辞。但对付尹月行会很棘手，此魔头能力非常，而且向来以逃避为主，要消灭他恐怕不易。从他的内元性质的魔气观察，或许需要|r|cFF00FF00灭魔圣器|r|cFFCCFFCC方能对付。你去天下|r|cFF00FF00第一坊巧木坊|r|cFFCCFFCC打探下圣器的情况吧！\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00到巧木坊询问灭魔圣器的下落|r")
if(Trig_tianyuan32_Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_tianyuan32_Func005001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_npn5_0261)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_tianyuan32_Conditions takes nothing returns boolean
if(not(udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==2))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(GetUnitAbilityLevelSwapped('AOw2',GetTriggerUnit())!=0))then
return false
endif
return true
endfunction