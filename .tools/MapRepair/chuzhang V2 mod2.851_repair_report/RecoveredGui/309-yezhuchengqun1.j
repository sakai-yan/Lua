//=========================================================================== 
// Trigger: yezhuchengqun1
//=========================================================================== 
function InitTrig_yezhuchengqun1 takes nothing returns nothing
set gg_trg_yezhuchengqun1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_yezhuchengqun1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_yezhuchengqun1,Condition(function Trig_yezhuchengqun1_Conditions))
call TriggerAddAction(gg_trg_yezhuchengqun1,function Trig_yezhuchengqun1_Actions)
endfunction

function Trig_yezhuchengqun1_Actions takes nothing returns nothing
if(Trig_yezhuchengqun1_Func001C())then
if(Trig_yezhuchengqun1_Func001Func001C())then
set udg_R_LX_yezhuchengqun1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nmh0_0012)
if(Trig_yezhuchengqun1_Func001Func001Func008001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF野猪成群（1）\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00猎杀10头野猪\n|r|cFFFFCC00老周：|r|cFFCCFFCC山上的|r|cFF00FF00野猪|r|cFFCCFFCC糟蹋了村子的农田。你如果愿意帮我去驱赶这些野猪，我会重重报答你的，至少也少|r|cFF00FF0010头|r|cFFCCFFCC吧|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_shenggancao5)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00老周：|r|cFFCCFFCC农田就在村子的南边|r")
set udg_SP=GetRectCenter(gg_rct_shenggancao5)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_yezhuchengqun1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='phea'))then
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