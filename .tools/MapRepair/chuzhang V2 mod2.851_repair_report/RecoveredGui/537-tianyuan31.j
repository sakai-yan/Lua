//=========================================================================== 
// Trigger: tianyuan31
//=========================================================================== 
function InitTrig_tianyuan31 takes nothing returns nothing
set gg_trg_tianyuan31=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_tianyuan31,356.00,gg_unit_ners_0599)
call TriggerAddCondition(gg_trg_tianyuan31,Condition(function Trig_tianyuan31_Conditions))
call TriggerAddAction(gg_trg_tianyuan31,function Trig_tianyuan31_Actions)
endfunction

function Trig_tianyuan31_Actions takes nothing returns nothing
set udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=3
set udg_SP=GetUnitLoc(GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00张真人：|r|cFFCCFFCC那是你大师兄，哎~~~天意！尹儿是太虚门里资质最好的弟子，我更是有意以后传他掌门之位！无奈如今的他已经堕入魔道，执迷不悟！这一切都是那妖女造成的！妖女引诱尹儿入魔，修炼邪术。妖女死后，尹儿自暴自弃，更在幽州一役杀死了下仙，成为了武林公敌~~~这事情你处理不了的，还是交给其他师兄处理吧。\n|r|cFFFFCC00你：|r|cFFCCFFCC（还是找文莱村村长问下.....）\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00找文莱村村长谈谈|r")
if(Trig_tianyuan31_Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_tianyuan31_Func005001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ngz1_0002)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_tianyuan31_Conditions takes nothing returns boolean
if(not(udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==2))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(GetUnitAbilityLevelSwapped('AEer',GetTriggerUnit())!=0))then
return false
endif
return true
endfunction