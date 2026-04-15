//=========================================================================== 
// Trigger: xunzhao1
//=========================================================================== 
function InitTrig_xunzhao1 takes nothing returns nothing
set gg_trg_xunzhao1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_xunzhao1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_xunzhao1,Condition(function Trig_xunzhao1_Conditions))
call TriggerAddAction(gg_trg_xunzhao1,function Trig_xunzhao1_Actions)
endfunction

function Trig_xunzhao1_Actions takes nothing returns nothing
if(Trig_xunzhao1_Func001C())then
if(Trig_xunzhao1_Func001Func002C())then
set udg_R_xunzhaotongmen1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_npn6_0144)
if(Trig_xunzhao1_Func001Func002Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,15.00,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF寻找同门师兄\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00在附近找到周适\n|r|cFFFFCC00雷风：|r|cFFCCFFCC我师兄|r|cFF00FF00周适|r|cFFCCFFCC在和燃火狗妖战斗中失踪了，我找了好久都没踪迹。大侠如果碰到一个穿红色衣服的小胡子，告诉他我在这里等着他吧，小熊在这先谢过了！|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ngsp_0145)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_xunzhao1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='pman'))then
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