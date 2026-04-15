//=========================================================================== 
// Trigger: yabiaoc
//=========================================================================== 
function InitTrig_yabiaoc takes nothing returns nothing
set gg_trg_yabiaoc=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_yabiaoc,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_yabiaoc,Condition(function Trig_yabiaoc_Conditions))
call TriggerAddAction(gg_trg_yabiaoc,function Trig_yabiaoc_Actions)
endfunction

function Trig_yabiaoc_Actions takes nothing returns nothing
if(Trig_yabiaoc_Func001C())then
if(Trig_yabiaoc_Func001Func005C())then
set udg_yabiaoc[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ndr2_0259)
set udg_SP2=GetUnitLoc(gg_unit_ndr3_0263)
if(Trig_yabiaoc_Func001Func005Func007001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF押镖—文莱村\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00把镖安全送到文莱村       \n|r|cFFFFCC00伍百：|r|cFFCCFFCC这镖可是超值钱的哦，你可要小心把它送到|r|cFF00FF00文莱村|r")
call CreateNUnitsAtLoc(1,'hhdl',GetOwningPlayer(GetTriggerUnit()),udg_SP,bj_UNIT_FACING)
call UnitAddAbilityBJ('Sca1',GetLastCreatedUnit())
call IssuePointOrderLoc(GetLastCreatedUnit(),"move",udg_SP2)
call CreateNUnitsAtLoc(1,'hhdl',GetOwningPlayer(GetTriggerUnit()),udg_SP,bj_UNIT_FACING)
call UnitAddAbilityBJ('Sca1',GetLastCreatedUnit())
call IssuePointOrderLoc(GetLastCreatedUnit(),"move",udg_SP2)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP2,10.00)
call RemoveLocation(udg_SP)
call RemoveLocation(udg_SP2)
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
call AdjustPlayerStateBJ(800,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+800)
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
call AdjustPlayerStateBJ(800,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+800)
endif
endfunction

function Trig_yabiaoc_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='whwd'))then
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