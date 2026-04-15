//=========================================================================== 
// Trigger: shudao2
//=========================================================================== 
function InitTrig_shudao2 takes nothing returns nothing
set gg_trg_shudao2=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_shudao2,356.00,gg_unit_ners_0599)
call TriggerAddCondition(gg_trg_shudao2,Condition(function Trig_shudao2_Conditions))
call TriggerAddAction(gg_trg_shudao2,function Trig_shudao2_Actions)
endfunction

function Trig_shudao2_Actions takes nothing returns nothing
set udg_MP_shudao2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ners_0599)
if(Trig_shudao2_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00张真人：|r|cFFCCFFCC魔物横行的今天，依靠朝廷的力量是多么地无助。咕噜龙是一种灵力很强的妖兽，一直威胁着西南一带百姓的生命。代表我们太虚出行吧，|r|cFF00FF00消灭20只咕噜龙|r|cFFCCFFCC，也好增进自己的灵力。\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示：|r|cFF00FF00杀死10只咕噜龙|r")
if(Trig_shudao2_Func007001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_shudao2_Func008001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct______________090)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_shudao2_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(udg_MP_shudao1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_shudao2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
return true
endfunction