//=========================================================================== 
// Trigger: jingang2
//=========================================================================== 
function InitTrig_jingang2 takes nothing returns nothing
set gg_trg_jingang2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_jingang2,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_jingang2,Condition(function Trig_jingang2_Conditions))
call TriggerAddAction(gg_trg_jingang2,function Trig_jingang2_Actions)
endfunction

function Trig_jingang2_Actions takes nothing returns nothing
if(Trig_jingang2_Func001C())then
if(Trig_jingang2_Func001Func001C())then
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
set udg_MP_jingang_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_jingang_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC打|r|cFFCCFFD9败|r|cFFCCFFE6铜|r|cFFCCFFF2人|r|cFFCCFFFF数|r:"+(" |cFFFFFF00"+(I2S(udg_MP_jingang_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/18|r"))))
if(Trig_jingang2_Func001Func001Func018001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
if(Trig_jingang2_Func001Func001Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_MP_jingang_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_jingang_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC打|r|cFFCCFFD9败|r|cFFCCFFE6铜|r|cFFCCFFF2人|r|cFFCCFFFF数|r:"+(" |cFFFFFF00"+(I2S(udg_MP_jingang_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/18|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：回去见智慈大师吧！|r")
set udg_SP=GetUnitLoc(gg_unit_nwnr_0520)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,30.00)
if(Trig_jingang2_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct______________124)
call SetUnitPositionLoc(GetKillingUnitBJ(),udg_SP)
call PanCameraToTimedLocForPlayer(GetOwningPlayer(GetKillingUnitBJ()),udg_SP,0)
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_jingang2_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nfrl'))then
return false
endif
if(not(IsUnitType(GetKillingUnitBJ(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction