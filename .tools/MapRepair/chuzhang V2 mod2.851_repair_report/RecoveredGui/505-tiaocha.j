//=========================================================================== 
// Trigger: tiaocha
//=========================================================================== 
function InitTrig_tiaocha takes nothing returns nothing
set gg_trg_tiaocha=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_tiaocha,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_tiaocha,Condition(function Trig_tiaocha_Conditions))
call TriggerAddAction(gg_trg_tiaocha,function Trig_tiaocha_Actions)
endfunction

function Trig_tiaocha_Actions takes nothing returns nothing
if(Trig_tiaocha_Func001C())then
if(Trig_tiaocha_Func001Func002C())then
set udg_tiaocha1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nanm_0508)
if(Trig_tiaocha_Func001Func002Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,15.00,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF调查苗寨\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00从某个巡逻的苗民身上找线索\n|r|cFFFFCC00石中保：|r|cFFCCFFCC我派出去的探子都无功而返")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct______________094)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_tiaocha_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='ofir'))then
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