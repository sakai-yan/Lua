//=========================================================================== 
// Trigger: guiyan6
//=========================================================================== 
function InitTrig_guiyan6 takes nothing returns nothing
set gg_trg_guiyan6=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_guiyan6,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_guiyan6,Condition(function Trig_guiyan6_Conditions))
call TriggerAddAction(gg_trg_guiyan6,function Trig_guiyan6_Actions)
endfunction

function Trig_guiyan6_Actions takes nothing returns nothing
if(Trig_guiyan6_Func001C())then
set udg_MP_guiyan4[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=true
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
if(Trig_guiyan6_Func001Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：地灵已经觉醒，回去找半蓑人吧！|r")
set udg_SP=GetUnitLoc(gg_unit_ncgb_0629)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,30.00)
if(Trig_guiyan6_Func001Func008001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
endif
endfunction

function Trig_guiyan6_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nbld'))then
return false
endif
return true
endfunction