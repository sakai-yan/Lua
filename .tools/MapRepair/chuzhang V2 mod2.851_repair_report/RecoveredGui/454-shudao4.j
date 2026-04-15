//=========================================================================== 
// Trigger: shudao4
//=========================================================================== 
function InitTrig_shudao4 takes nothing returns nothing
set gg_trg_shudao4=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_shudao4,356.00,gg_unit_ners_0599)
call TriggerAddCondition(gg_trg_shudao4,Condition(function Trig_shudao4_Conditions))
call TriggerAddAction(gg_trg_shudao4,function Trig_shudao4_Actions)
endfunction

function Trig_shudao4_Actions takes nothing returns nothing
set udg_MP_shudao3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ners_0599)
if(Trig_shudao4_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00张真人：|r|cFFCCFFCC真不愧是我太虚观弟子，我感到很欣慰。现在有更重要的任务交给你，前几天寻仙村的几个渔夫中了海妖的腥毒，危在旦夕。必须要有|r|cFF00FF00雀红散|r|cFFCCFFCC才能医治，你速度去|r|cFF00FF00清心阁|r|cFFCCFFCC找|r|cFF00FF00陆容大夫|r|cFFCCFFCC要吧。\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示：|r|cFF00FF00到清心阁找陆容大夫|r")
if(Trig_shudao4_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_shudao4_Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ngza_0168)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_shudao4_Conditions takes nothing returns boolean
if(not(udg_MP_shudao2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_shudao3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(udg_MP_shudao_num1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=10))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction