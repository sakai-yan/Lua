//=========================================================================== 
// Trigger: daokuang4
//=========================================================================== 
function InitTrig_daokuang4 takes nothing returns nothing
set gg_trg_daokuang4=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_daokuang4,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_daokuang4,Condition(function Trig_daokuang4_Conditions))
call TriggerAddAction(gg_trg_daokuang4,function Trig_daokuang4_Actions)
endfunction

function Trig_daokuang4_Actions takes nothing returns nothing
if(Trig_daokuang4_Func001C())then
if(Trig_daokuang4_Func001Func001C())then
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
set udg_MP_daokuang_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_daokuang_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC草|r|cFFCCFFE6齿|r|cFFCCFFFF兽|r"+(" |cFFFFFF00"+(I2S(udg_MP_daokuang_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/15|r"))))
if(Trig_daokuang4_Func001Func001Func014001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
if(Trig_daokuang4_Func001Func001Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_MP_daokuang_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_daokuang_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC草|r|cFFCCFFE6齿|r|cFFCCFFFF兽|r"+(" |cFFFFFF00"+(I2S(udg_MP_daokuang_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/15|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：你已经杀够了，速速回去月刀岛找卯人敌吧！|r")
set udg_SP=GetUnitLoc(gg_unit_zcso_0720)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,30.00)
if(Trig_daokuang4_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_daokuang4_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='njg1'))then
return false
endif
return true
endfunction