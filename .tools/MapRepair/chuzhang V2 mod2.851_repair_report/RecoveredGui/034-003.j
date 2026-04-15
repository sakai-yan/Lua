//=========================================================================== 
// Trigger: 003
//=========================================================================== 
function InitTrig____________________003 takes nothing returns nothing
set gg_trg____________________003=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg____________________003,EVENT_PLAYER_HERO_LEVEL)
call TriggerAddCondition(gg_trg____________________003,Condition(function Trig____________________003_Conditions))
call TriggerAddAction(gg_trg____________________003,function Trig____________________003_Actions)
endfunction

function Trig____________________003_Actions takes nothing returns nothing
if(Trig____________________003_Func001C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000系统提示：|r|cFF00FFFF你的等级已经达到20，可以进行第一次转职任务。请到本门派寻找转职NPC吧。|r")
if(Trig____________________003_Func001Func002C())then
set udg_SP=GetRectCenter(gg_rct______________081________2)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
if(Trig____________________003_Func001Func002Func001C())then
set udg_SP=GetUnitLoc(gg_unit_ners_0599)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
if(Trig____________________003_Func001Func002Func001Func001C())then
set udg_SP=GetRectCenter(gg_rct______________081)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
if(Trig____________________003_Func001Func002Func001Func001Func001C())then
set udg_SP=GetRectCenter(gg_rct______________124)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
if(Trig____________________003_Func001Func002Func001Func001Func001Func001C())then
set udg_SP=GetUnitLoc(gg_unit_nfh1_0124)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
if(Trig____________________003_Func001Func002Func001Func001Func001Func001Func001C())then
set udg_SP=GetUnitLoc(gg_unit_ndh0_0717)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
if(Trig____________________003_Func001Func002Func001Func001Func001Func001Func001Func001C())then
set udg_SP=GetUnitLoc(gg_unit_ncgb_0629)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
endif
endif
endif
endif
endif
endif
else
endif
if(Trig____________________003_Func002C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000系统提示：|r|cFF00FFFF你的等级已经达到35，可以去地图|r|cFFFFCC00《风原》|r|cFF00FFFF展开新的旅程。|r")
else
endif
endfunction

function Trig____________________003_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(GetPlayerController(GetOwningPlayer(GetTriggerUnit()))==MAP_CONTROL_USER))then
return false
endif
return true
endfunction