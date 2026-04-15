//=========================================================================== 
// Trigger: yabiao1
//=========================================================================== 
function InitTrig_yabiao1 takes nothing returns nothing
set gg_trg_yabiao1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_yabiao1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_yabiao1,Condition(function Trig_yabiao1_Conditions))
call TriggerAddAction(gg_trg_yabiao1,function Trig_yabiao1_Actions)
endfunction

function Trig_yabiao1_Actions takes nothing returns nothing
if(Trig_yabiao1_Func001C())then
if(Trig_yabiao1_Func001Func005C())then
set udg_yabiao1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nqb4_0244)
call CreateNUnitsAtLoc(1,'hhdl',GetOwningPlayer(GetTriggerUnit()),udg_SP,bj_UNIT_FACING)
call UnitAddAbilityBJ('Sca5',GetLastCreatedUnit())
if(Trig_yabiao1_Func001Func005Func008001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF押镖—魂山\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00把镖安全送到魂山       \n|r|cFFFFCC00李淮山：|r|cFFCCFFCC这镖可是很值钱的哦，你可要把它安全送到|r|cFF00FF00魂山|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ndr1_0260)
call IssuePointOrderLoc(GetLastCreatedUnit(),"move",udg_SP)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
call AdjustPlayerStateBJ(400,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+400)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
call AdjustPlayerStateBJ(400,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+400)
endif
endfunction

function Trig_yabiao1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='rej3'))then
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