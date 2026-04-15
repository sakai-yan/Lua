//=========================================================================== 
// Trigger: xuedao2
//=========================================================================== 
function InitTrig_xuedao2 takes nothing returns nothing
set gg_trg_xuedao2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_xuedao2,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_xuedao2,Condition(function Trig_xuedao2_Conditions))
call TriggerAddAction(gg_trg_xuedao2,function Trig_xuedao2_Actions)
endfunction

function Trig_xuedao2_Actions takes nothing returns nothing
if(Trig_xuedao2_Func001C())then
if(Trig_xuedao2_Func001Func001C())then
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
set udg_MP_xuedao_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_xuedao_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC纯|r|cFFCCFFDD阴|r|cFFCCFFEE之|r|cFFCCFFFF气|r"+(" |cFFFFFF00"+(I2S(udg_MP_xuedao_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/15|r"))))
if(Trig_xuedao2_Func001Func001Func014001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
if(Trig_xuedao2_Func001Func001Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_MP_xuedao_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_xuedao_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC纯|r|cFFCCFFDD阴|r|cFFCCFFEE之|r|cFFCCFFFF气|r"+(" |cFFFFFF00"+(I2S(udg_MP_xuedao_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/15|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：纯阴之气已经足够，速速回去月刀岛找丁宁吧！|r")
set udg_SP=GetUnitLoc(gg_unit_nwwg_0719)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,30.00)
if(Trig_xuedao2_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_xuedao2_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='efdr'))then
return false
endif
return true
endfunction