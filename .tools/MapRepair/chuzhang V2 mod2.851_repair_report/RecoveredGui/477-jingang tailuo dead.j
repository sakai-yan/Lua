//=========================================================================== 
// Trigger: jingang tailuo dead
//=========================================================================== 
function InitTrig_jingang_tailuo_dead takes nothing returns nothing
set gg_trg_jingang_tailuo_dead=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_jingang_tailuo_dead,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_jingang_tailuo_dead,Condition(function Trig_jingang_tailuo_dead_Conditions))
call TriggerAddAction(gg_trg_jingang_tailuo_dead,function Trig_jingang_tailuo_dead_Actions)
endfunction

function Trig_jingang_tailuo_dead_Actions takes nothing returns nothing
set udg_SP=GetRectCenter(gg_rct______________124)
call SetUnitPositionLoc(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP)
if(Trig_jingang_tailuo_dead_Func003001())then
call PlaySoundAtPointBJ(gg_snd_CreepAggroWhat1,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000提示：挑战失败，下次再来吧！|r")
set udg_MP_jingang_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
set udg_MP_jingang1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_MP_tailuo1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
call RemoveLocation(udg_SP)
endfunction

function Trig_jingang_tailuo_dead_Conditions takes nothing returns boolean
if(not(RectContainsUnit(gg_rct______________123,GetTriggerUnit())==true))then
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