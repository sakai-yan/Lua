//=========================================================================== 
// Trigger: xiufushizhen
//=========================================================================== 
function InitTrig_xiufushizhen takes nothing returns nothing
set gg_trg_xiufushizhen=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_xiufushizhen,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_xiufushizhen,Condition(function Trig_xiufushizhen_Conditions))
call TriggerAddAction(gg_trg_xiufushizhen,function Trig_xiufushizhen_Actions)
endfunction

function Trig_xiufushizhen_Actions takes nothing returns nothing
if(Trig_xiufushizhen_Func001C())then
if(Trig_xiufushizhen_Func001Func001C())then
set udg_R_xiufushizhen1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ngzc_0094)
if(Trig_xiufushizhen_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF修复石阵（1）\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00夺回20个灵气\n|r|cFFFFCC00阿亥：|r|cFFCCFFCC石阵的修复需要至少|r|cFF00FF0020份灵气，|r|cFFCCFFCC这些灵气我好不容易才收集到了，但却被那些|r|cFF00FF00燃火小妖|r|cFFCCFFCC抢走了。大侠务必帮我抢回来啊！否则石阵无法使用了。|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ncnt_0117)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
if(Trig_xiufushizhen_Func001Func001Func001C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00阿亥：|r|cFF00FF00燃火小妖|r|cFFCCFFCC就在石阵西南边，从它们那|r|cFF00FF00抢回20份灵气|r|cFFCCFFCC吧！|r")
set udg_SP=GetUnitLoc(gg_unit_ncnt_0117)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,4.00)
call RemoveLocation(udg_SP)
else
if(Trig_xiufushizhen_Func001Func001Func001Func001C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00阿亥：|r|cFF00FF00燃火精髓|r|cFFCCFFCC只能从燃火狗妖身上获得，而|r|cFF00FF00石料|r|cFFCCFFCC在狗妖附近也有很多|r")
set udg_SP=GetUnitLoc(gg_unit_ncnt_0088)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,4.00)
call RemoveLocation(udg_SP)
else
endif
endif
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_xiufushizhen_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='pinv'))then
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