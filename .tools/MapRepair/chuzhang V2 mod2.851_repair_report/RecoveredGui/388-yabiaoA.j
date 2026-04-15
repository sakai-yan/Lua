//=========================================================================== 
// Trigger: yabiaoA
//=========================================================================== 
function InitTrig_yabiaoA takes nothing returns nothing
set gg_trg_yabiaoA=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_yabiaoA,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_yabiaoA,Condition(function Trig_yabiaoA_Conditions))
call TriggerAddAction(gg_trg_yabiaoA,function Trig_yabiaoA_Actions)
endfunction

function Trig_yabiaoA_Actions takes nothing returns nothing
if(Trig_yabiaoA_Func001C())then
if(Trig_yabiaoA_Func001Func005C())then
set udg_yabiaoA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ndr1_0260)
call CreateNUnitsAtLoc(1,'hhdl',GetOwningPlayer(GetTriggerUnit()),udg_SP,bj_UNIT_FACING)
call UnitAddAbilityBJ('Sca5',GetLastCreatedUnit())
if(Trig_yabiaoA_Func001Func005Func008001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF押镖—塔木村\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00把镖安全送到塔木村       \n|r|cFFFFCC00龙远：|r|cFFCCFFCC这镖可是很值钱的哦，你可要把它安全送到|r|cFF00FF00塔木村|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_nqb4_0244)
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

function Trig_yabiaoA_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='fgrd'))then
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