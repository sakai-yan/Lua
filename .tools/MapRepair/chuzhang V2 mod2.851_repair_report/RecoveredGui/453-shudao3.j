//=========================================================================== 
// Trigger: shudao3
//=========================================================================== 
function InitTrig_shudao3 takes nothing returns nothing
set gg_trg_shudao3=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_shudao3,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_shudao3,Condition(function Trig_shudao3_Conditions))
call TriggerAddAction(gg_trg_shudao3,function Trig_shudao3_Actions)
endfunction

function Trig_shudao3_Actions takes nothing returns nothing
if(Trig_shudao3_Func001C())then
if(Trig_shudao3_Func001Func001C())then
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
set udg_MP_shudao_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_shudao_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC咕|r|cFFCCFFE6噜|r|cFFCCFFFF龙|r"+(" |cFFFFFF00"+(I2S(udg_MP_shudao_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
if(Trig_shudao3_Func001Func001Func014001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
if(Trig_shudao3_Func001Func001Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_MP_shudao_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_shudao_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC咕|r|cFFCCFFE6噜|r|cFFCCFFFF龙|r"+(" |cFFFFFF00"+(I2S(udg_MP_shudao_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：咕噜龙已经消灭干净，回去找张真人复命吧！|r")
set udg_SP=GetUnitLoc(gg_unit_ners_0599)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,30.00)
if(Trig_shudao3_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_shudao3_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='efdr'))then
return false
endif
return true
endfunction