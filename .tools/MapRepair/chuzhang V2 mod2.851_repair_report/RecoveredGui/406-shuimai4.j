//=========================================================================== 
// Trigger: shuimai4
//=========================================================================== 
function InitTrig_shuimai4 takes nothing returns nothing
set gg_trg_shuimai4=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_shuimai4,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_shuimai4,Condition(function Trig_shuimai4_Conditions))
call TriggerAddAction(gg_trg_shuimai4,function Trig_shuimai4_Actions)
endfunction

function Trig_shuimai4_Actions takes nothing returns nothing
if(Trig_shuimai4_Func001C())then
if(Trig_shuimai4_Func001Func001C())then
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
set udg_MP_shuimai_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_shuimai_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC咕|r|cFFCCFFDD噜|r|cFFCCFFEE龙|r|cFFCCFFFF：|r"+(" |cFFFFFF00"+(I2S(udg_MP_shuimai_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
if(Trig_shuimai4_Func001Func001Func014001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
if(Trig_shuimai4_Func001Func001Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_MP_shuimai_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_shuimai_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC咕|r|cFFCCFFDD噜|r|cFFCCFFEE龙|r|cFFCCFFFF：|r"+(" |cFFFFFF00"+(I2S(udg_MP_shuimai_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：咕噜龙已经杀够，去找水无名吧！|r")
set udg_SP=GetUnitLoc(gg_unit_nsha_0367)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,10.00)
if(Trig_shuimai4_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_shuimai4_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='efdr'))then
return false
endif
return true
endfunction