//=========================================================================== 
// Trigger: jianhao4
//=========================================================================== 
function InitTrig_jianhao4 takes nothing returns nothing
set gg_trg_jianhao4=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_jianhao4,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_jianhao4,Condition(function Trig_jianhao4_Conditions))
call TriggerAddAction(gg_trg_jianhao4,function Trig_jianhao4_Actions)
endfunction

function Trig_jianhao4_Actions takes nothing returns nothing
if(Trig_jianhao4_Func001C())then
if(Trig_jianhao4_Func001Func001C())then
if(Trig_jianhao4_Func001Func001Func002C())then
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
set udg_MP_jianhao_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_jianhao_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC草|r|cFFCCFFD9齿|r|cFFCCFFE6兽|r|cFFCCFFF2之|r|cFFCCFFFF牙|r"+(" |cFFFFFF00"+(I2S(udg_MP_jianhao_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/16|r"))))
if(Trig_jianhao4_Func001Func001Func002Func014001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
if(Trig_jianhao4_Func001Func001Func002Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_MP_jianhao_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_jianhao_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC草|r|cFFCCFFD9齿|r|cFFCCFFE6兽|r|cFFCCFFF2之|r|cFFCCFFFF牙|r"+(" |cFFFFFF00"+(I2S(udg_MP_jianhao_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/16|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：草齿兽之牙已经收集够了，回御剑门找扬青吧！|r")
set udg_SP=GetUnitLoc(gg_unit_ngnh_0123)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,10.00)
if(Trig_jianhao4_Func001Func001Func002Func010001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
else
endif
endfunction

function Trig_jianhao4_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='njg1'))then
return false
endif
if(not(UnitHasItemOfTypeBJ(GetKillingUnitBJ(),'sehr')==true))then
return false
endif
return true
endfunction