//=========================================================================== 
// Trigger: qijian1
//=========================================================================== 
function InitTrig_qijian1 takes nothing returns nothing
set gg_trg_qijian1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_qijian1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_qijian1,Condition(function Trig_qijian1_Conditions))
call TriggerAddAction(gg_trg_qijian1,function Trig_qijian1_Actions)
endfunction

function Trig_qijian1_Actions takes nothing returns nothing
if(Trig_qijian1_Func001C())then
if(Trig_qijian1_Func001Func002C())then
if(Trig_qijian1_Func001Func002Func003C())then
set udg_MP_qijian1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ndh1_0368)
if(Trig_qijian1_Func001Func002Func003Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF弃剑之道\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00寻找卓小云\n|r|cFFFFCC00卓腾云：|r|cFFCCFFCC想要修练气剑其实并不难，我对你们的要求也不很高。但在这之前我必须要处理一件事情，你们拿淘气的小师妹，也就是我那傻妹妹|r|cFF00FF00卓小云|r|cFFCCFFCC，外出许久不归，我想麻烦你帮我把她找回来，她应该是去了|r|cFF00FF00寻仙村|r|cFFCCFFCC了。|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ngir_0369)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
if(Trig_qijian1_Func001Func002Func003Func001C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00卓腾云：|r|cFFCCFFCC你找到我妹妹卓小云了没？|r")
set udg_SP=GetUnitLoc(gg_unit_ngir_0369)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
endif
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00卓腾云：|r|cFFCCFFCC你的历练还不够，20级后再来找我吧·|r")
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00卓腾云：|r|cFFCCFFCC御剑门是不会外传武学的，你尽快离开吧！|r")
endif
endfunction

function Trig_qijian1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='arsc'))then
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