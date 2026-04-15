//=========================================================================== 
// Trigger: qijian5
//=========================================================================== 
function InitTrig_qijian5 takes nothing returns nothing
set gg_trg_qijian5=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_qijian5,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_qijian5,Condition(function Trig_qijian5_Conditions))
call TriggerAddAction(gg_trg_qijian5,function Trig_qijian5_Actions)
endfunction

function Trig_qijian5_Actions takes nothing returns nothing
if(Trig_qijian5_Func001C())then
if(Trig_qijian5_Func001Func001C())then
if(Trig_qijian5_Func001Func001Func002C())then
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
set udg_MP_qijian_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_qijian_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC鸟|r|cFFCCFFE6龙|r|cFFCCFFFF鳞|r"+(" |cFFFFFF00"+(I2S(udg_MP_qijian_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/20|r"))))
if(Trig_qijian5_Func001Func001Func002Func014001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
if(Trig_qijian5_Func001Func001Func002Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_MP_qijian_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_qijian_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC鸟|r|cFFCCFFE6龙|r|cFFCCFFFF鳞|r"+(" |cFFFFFF00"+(I2S(udg_MP_qijian_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/20|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：鸟龙鳞已经收集够了，回御剑门找腾云飞吧！|r")
set udg_SP=GetUnitLoc(gg_unit_ndh1_0368)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,30.00)
if(Trig_qijian5_Func001Func001Func002Func010001())then
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

function Trig_qijian5_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='efdr'))then
return false
endif
return true
endfunction