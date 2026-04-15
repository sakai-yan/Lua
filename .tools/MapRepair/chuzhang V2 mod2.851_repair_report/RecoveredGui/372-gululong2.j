//=========================================================================== 
// Trigger: gululong2
//=========================================================================== 
function InitTrig_gululong2 takes nothing returns nothing
set gg_trg_gululong2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_gululong2,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_gululong2,Condition(function Trig_gululong2_Conditions))
call TriggerAddAction(gg_trg_gululong2,function Trig_gululong2_Actions)
endfunction

function Trig_gululong2_Actions takes nothing returns nothing
if(Trig_gululong2_Func001C())then
if(Trig_gululong2_Func001Func001C())then
set udg_R_gululong_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_R_gululong_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC咕|r|cFFCCFFE6噜|r|cFFCCFFFF龙|r"+(" |cFFFFFF00"+(I2S(udg_R_gululong_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
if(Trig_gululong2_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_R_gululong_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_R_gululong_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC咕|r|cFFCCFFE6噜|r|cFFCCFFFF龙|r"+(" |cFFFFFF00"+(I2S(udg_R_gululong_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：咕噜龙已经杀够了，回去找老头吧|r")
set udg_SP=GetUnitLoc(gg_unit_nftr_0616)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,20.00)
if(Trig_gululong2_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_gululong2_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='efdr'))then
return false
endif
return true
endfunction