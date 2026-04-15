//=========================================================================== 
// Trigger: qijian6
//=========================================================================== 
function InitTrig_qijian6 takes nothing returns nothing
set gg_trg_qijian6=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_qijian6,356.00,gg_unit_ndh1_0368)
call TriggerAddCondition(gg_trg_qijian6,Condition(function Trig_qijian6_Conditions))
call TriggerAddAction(gg_trg_qijian6,function Trig_qijian6_Actions)
endfunction

function Trig_qijian6_Actions takes nothing returns nothing
set udg_MP_qijian4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ndh1_0368)
if(Trig_qijian6_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00卓腾云：|r|cFFCCFFCC你动作挺麻利的嘛，那就给你最后的挑战吧！|r|cFF00FF00黑岗山寨|r|cFFCCFFCC！黑岗山寨的山贼，无恶不作，祸害百姓！是我们御剑门人站出来为民请命的时候了，去为百姓把这大虫消灭吧！至少|r|cFF00FF00剿灭5个山贼队长！\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00消灭5个山贼队长|r")
if(Trig_qijian6_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_qijian6_Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_shan_1)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_qijian6_Conditions takes nothing returns boolean
if(not(udg_MP_qijian3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_qijian4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_MP_qijian_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=20))then
return false
endif
return true
endfunction