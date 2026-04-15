//=========================================================================== 
// Trigger: tianyuan35
//=========================================================================== 
function InitTrig_tianyuan35 takes nothing returns nothing
set gg_trg_tianyuan35=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_tianyuan35,356.00,gg_unit_nsce_0324)
call TriggerAddCondition(gg_trg_tianyuan35,Condition(function Trig_tianyuan35_Conditions))
call TriggerAddAction(gg_trg_tianyuan35,function Trig_tianyuan35_Actions)
endfunction

function Trig_tianyuan35_Actions takes nothing returns nothing
set udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=3
set udg_SP=GetUnitLoc(GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00胡絮：|r|cFFCCFFCC这个天杀的逆徒么？枉我与太虚观掌门原本还想促成两门的联婚，让你大师姐嫁于他，想不到此人弃道从魔，杀仙潜逃，让你大师姐好不难过。要想消灭尹小儿，看来需要寻求克制魔者人方法才行。这个可能要从拥有窃天眼的文莱族人着手，你去|r|cFF00FF00文莱村|r|cFFCCFFCC打听打听吧。\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00到文莱村找其村长聊聊|r")
if(Trig_tianyuan35_Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_tianyuan35_Func005001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ngz1_0002)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_tianyuan35_Conditions takes nothing returns boolean
if(not(udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==2))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(GetUnitAbilityLevelSwapped('AIm1',GetTriggerUnit())!=0))then
return false
endif
return true
endfunction