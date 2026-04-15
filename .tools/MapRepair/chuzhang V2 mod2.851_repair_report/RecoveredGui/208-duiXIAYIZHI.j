//=========================================================================== 
// Trigger: duiXIAYIZHI
//=========================================================================== 
function InitTrig_duiXIAYIZHI takes nothing returns nothing
set gg_trg_duiXIAYIZHI=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_duiXIAYIZHI,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_duiXIAYIZHI,Condition(function Trig_duiXIAYIZHI_Conditions))
call TriggerAddAction(gg_trg_duiXIAYIZHI,function Trig_duiXIAYIZHI_Actions)
endfunction

function Trig_duiXIAYIZHI_Actions takes nothing returns nothing
if(Trig_duiXIAYIZHI_Func001C())then
if(Trig_duiXIAYIZHI_Func001Func001C())then
call UnitAddItemByIdSwapped('rspl',GetTriggerUnit())
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-1)
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000侠义值不足|r")
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+4000)
call SetPlayerStateBJ(GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD,udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endif
else
endif
if(Trig_duiXIAYIZHI_Func002C())then
if(Trig_duiXIAYIZHI_Func002Func001C())then
call UnitAddItemByIdSwapped('wneu',GetTriggerUnit())
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-3)
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000侠义值不足|r")
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+10000)
call SetPlayerStateBJ(GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD,udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endif
else
endif
if(Trig_duiXIAYIZHI_Func003C())then
if(Trig_duiXIAYIZHI_Func003Func001C())then
call UnitAddItemByIdSwapped('tin2',GetTriggerUnit())
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-8)
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000侠义值不足|r")
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+30000)
call SetPlayerStateBJ(GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD,udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endif
else
endif
endfunction

function Trig_duiXIAYIZHI_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction