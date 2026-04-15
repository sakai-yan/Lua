//=========================================================================== 
// Trigger: zhengjiuxiaotong1
//=========================================================================== 
function InitTrig_zhengjiuxiaotong1 takes nothing returns nothing
set gg_trg_zhengjiuxiaotong1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_zhengjiuxiaotong1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_zhengjiuxiaotong1,Condition(function Trig_zhengjiuxiaotong1_Conditions))
call TriggerAddAction(gg_trg_zhengjiuxiaotong1,function Trig_zhengjiuxiaotong1_Actions)
endfunction

function Trig_zhengjiuxiaotong1_Actions takes nothing returns nothing
if(Trig_zhengjiuxiaotong1_Func001C())then
if(Trig_zhengjiuxiaotong1_Func001Func003C())then
set udg_R_ZJ_xiaotong1=true
call SetUnitInvulnerable(gg_unit_nwc1_0216,false)
set udg_SP=GetUnitLoc(gg_unit_ncg1_0205)
if(Trig_zhengjiuxiaotong1_Func001Func003Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF祭品的童子\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00把的童子安全救回营地         \n|r|cFFFFCC00塔木长老：|r|cFFCCFFCC我们很难过地发现，一直相信的森林之神是一个心灵丑陋的猴妖！它欺骗我们提供一个|r|cFF00FF00童子|r|cFFCCFFCC作为祭品，否则将会降祸塔木~~~大侠救救我们的孩子吧，他被关在了|r|cFF00FF00祭品木箱|r|cFFCCFFCC里，把他救回来吧！求求你了大侠！|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_nwc1_0216)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_zhengjiuxiaotong1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='wshs'))then
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