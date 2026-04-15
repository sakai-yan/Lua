//=========================================================================== 
// Trigger: hantmdweiacunzhuang1
//=========================================================================== 
function InitTrig_hantmdweiacunzhuang1 takes nothing returns nothing
set gg_trg_hantmdweiacunzhuang1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_hantmdweiacunzhuang1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_hantmdweiacunzhuang1,Condition(function Trig_hantmdweiacunzhuang1_Conditions))
call TriggerAddAction(gg_trg_hantmdweiacunzhuang1,function Trig_hantmdweiacunzhuang1_Actions)
endfunction

function Trig_hantmdweiacunzhuang1_Actions takes nothing returns nothing
if(Trig_hantmdweiacunzhuang1_Func001C())then
if(Trig_hantmdweiacunzhuang1_Func001Func002C())then
set udg_R_FS_hantmdweia=true
set udg_SP=GetUnitLoc(gg_unit_ngz2_0015)
if(Trig_hantmdweiacunzhuang1_Func001Func002Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
set udg_SP=GetRectCenter(gg_rct______________016)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
call EnableTrigger(gg_trg_tmdjingong1)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_hantmdweiacunzhuang1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='tmd9'))then
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