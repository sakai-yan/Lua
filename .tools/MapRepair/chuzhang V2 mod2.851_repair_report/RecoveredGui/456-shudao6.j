//=========================================================================== 
// Trigger: shudao6
//=========================================================================== 
function InitTrig_shudao6 takes nothing returns nothing
set gg_trg_shudao6=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_shudao6,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_shudao6,Condition(function Trig_shudao6_Conditions))
call TriggerAddAction(gg_trg_shudao6,function Trig_shudao6_Actions)
endfunction

function Trig_shudao6_Actions takes nothing returns nothing
if(Trig_shudao6_Func001C())then
if(Trig_shudao6_Func001Func001C())then
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
call UnitAddItemByIdSwapped('rdis',GetKillingUnitBJ())
if(Trig_shudao6_Func001Func001Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：找到了雀素丹！回去找陆容大夫吧|r")
set udg_SP=GetUnitLoc(gg_unit_ngza_0168)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,30.00)
if(Trig_shudao6_Func001Func001Func008001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
endif
else
endif
endfunction

function Trig_shudao6_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nplg'))then
return false
endif
return true
endfunction