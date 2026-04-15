//=========================================================================== 
// Trigger: jianxuan4
//=========================================================================== 
function InitTrig_jianxuan4 takes nothing returns nothing
set gg_trg_jianxuan4=CreateTrigger()
call TriggerRegisterEnterRectSimple(gg_trg_jianxuan4,gg_rct______________079)
call TriggerAddCondition(gg_trg_jianxuan4,Condition(function Trig_jianxuan4_Conditions))
call TriggerAddAction(gg_trg_jianxuan4,function Trig_jianxuan4_Actions)
endfunction

function Trig_jianxuan4_Actions takes nothing returns nothing
set udg_MP_jianxuan4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetRectCenter(gg_rct______________079)
if(Trig_jianxuan4_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00你：|r|cFFCCFFCC难道那白发的魔头知道我要来抓他？逃走了？问下那边那个红色衣服的大哥看看吧~~~追到天涯海角也要把你抓住！！\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00到张业谈谈|r")
if(Trig_jianxuan4_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_jianxuan4_Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ngz4_0179)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_jianxuan4_Conditions takes nothing returns boolean
if(not(udg_MP_jianxuan3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_jianxuan4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction