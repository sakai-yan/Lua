//=========================================================================== 
// Trigger: guiyan2
//=========================================================================== 
function InitTrig_guiyan2 takes nothing returns nothing
set gg_trg_guiyan2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_guiyan2,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_guiyan2,Condition(function Trig_guiyan2_Conditions))
call TriggerAddAction(gg_trg_guiyan2,function Trig_guiyan2_Actions)
endfunction

function Trig_guiyan2_Actions takes nothing returns nothing
if(Trig_guiyan2_Func001C())then
if(Trig_guiyan2_Func001Func001C())then
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
set udg_MP_guiyan_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_guiyan_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC草|r|cFFCCFFE6齿|r|cFFCCFFFF兽|r"+(" |cFFFFFF00"+(I2S(udg_MP_guiyan_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/20|r"))))
if(Trig_guiyan2_Func001Func001Func014001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
if(Trig_guiyan2_Func001Func001Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_MP_guiyan_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_guiyan_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC草|r|cFFCCFFE6齿|r|cFFCCFFFF兽|r"+(" |cFFFFFF00"+(I2S(udg_MP_guiyan_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/20|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：热身已经足够，速速回去告诉半蓑人吧！|r")
set udg_SP=GetUnitLoc(gg_unit_ncgb_0629)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,30.00)
if(Trig_guiyan2_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_guiyan2_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='njg1'))then
return false
endif
return true
endfunction