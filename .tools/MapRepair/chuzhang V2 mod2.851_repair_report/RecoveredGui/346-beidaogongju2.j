//=========================================================================== 
// Trigger: beidaogongju2
//=========================================================================== 
function InitTrig_beidaogongju2 takes nothing returns nothing
set gg_trg_beidaogongju2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_beidaogongju2,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_beidaogongju2,Condition(function Trig_beidaogongju2_Conditions))
call TriggerAddAction(gg_trg_beidaogongju2,function Trig_beidaogongju2_Actions)
endfunction

function Trig_beidaogongju2_Actions takes nothing returns nothing
if(Trig_beidaogongju2_Func001C())then
if(Trig_beidaogongju2_Func001Func001C())then
set udg_R_CJ_gongju_T[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99工具已经到手，快快回去找鲁右佻吧！|r")
set udg_SP=GetUnitLoc(gg_unit_npnw_0364)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,20.00)
if(Trig_beidaogongju2_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99工具已经到手，快快回去找鲁右佻吧！|r")
set udg_SP=GetUnitLoc(gg_unit_npnw_0364)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,20.00)
if(Trig_beidaogongju2_Func001Func001Func005001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
call TriggerSleepAction(30.00)
call CreateItemLoc('ckng',GetRectCenter(gg_rct______________088))
endfunction

function Trig_beidaogongju2_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='ckng'))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction