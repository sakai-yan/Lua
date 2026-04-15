//=========================================================================== 
// Trigger: tianyuan42
//=========================================================================== 
function InitTrig_tianyuan42 takes nothing returns nothing
set gg_trg_tianyuan42=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_tianyuan42,356.00,gg_unit_ndtp_0375)
call TriggerAddCondition(gg_trg_tianyuan42,Condition(function Trig_tianyuan42_Conditions))
call TriggerAddAction(gg_trg_tianyuan42,function Trig_tianyuan42_Actions)
endfunction

function Trig_tianyuan42_Actions takes nothing returns nothing
set udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=4
set udg_SP=GetUnitLoc(GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00任我飞：|r|cFFCCFFCC我行走江湖数十年，确实接触过不少妖魔鬼怪。当年为报妻仇，我一度寻遍大江南北，最后在一位叫|r|cFF00FF00天策乾坤|r|cFFCCFFCC的道士那里得知了灭魔圣器的消息，但同时也发现用此等圣器，非我之辈所能驾驭，最后只好无奈放弃了。那道长现在居住在|r|cFF00FF00东海群岛的琊谷附近|r|cFFCCFFCC，你找他去吧\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00寻找天策乾坤|r")
if(Trig_tianyuan42_Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_tianyuan42_Func005001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_nftk_0733)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_tianyuan42_Conditions takes nothing returns boolean
if(not(udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==3))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not Trig_tianyuan42_Func013C())then
return false
endif
return true
endfunction