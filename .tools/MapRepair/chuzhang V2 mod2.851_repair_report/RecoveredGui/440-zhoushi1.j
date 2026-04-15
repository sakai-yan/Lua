//=========================================================================== 
// Trigger: zhoushi1
//=========================================================================== 
function InitTrig_zhoushi1 takes nothing returns nothing
set gg_trg_zhoushi1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_zhoushi1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_zhoushi1,Condition(function Trig_zhoushi1_Conditions))
call TriggerAddAction(gg_trg_zhoushi1,function Trig_zhoushi1_Actions)
endfunction

function Trig_zhoushi1_Actions takes nothing returns nothing
if(Trig_zhoushi1_Func001C())then
if(Trig_zhoushi1_Func001Func002C())then
if(Trig_zhoushi1_Func001Func002Func003C())then
set udg_MP_zhoushi1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nfh1_0124)
if(Trig_zhoushi1_Func001Func002Func003Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF咒的练就\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00寻找苑樱师\n|r|cFFFFCC00白鹿先生：|r|cFFCCFFCC虽然我不喜欢别人打打杀杀，但我又没办法阻止别人。一定的武力是保护自己和他人的必要手段，有时比医术更实在。|r|cFF00FF00苑樱师|r|cFFCCFFCC，清心阁的咒术师，你去找他吧，他会告诉你什么是杀人医者。|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_nshw_0366)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
if(Trig_zhoushi1_Func001Func002Func003Func001C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00白鹿先生：|r|cFFCCFFCC伏樱师好像在万剑山附近出现过，你去找他吧~|r")
set udg_SP=GetUnitLoc(gg_unit_nshw_0366)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
endif
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00白鹿先生：|r|cFFCCFFCC你的历练还不够，20级后再来找我吧·|r")
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00白鹿先生：|r|cFFCCFFCC欢迎来到清心阁，请问你哪里不舒服吗？|r")
endif
endfunction

function Trig_zhoushi1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='I006'))then
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