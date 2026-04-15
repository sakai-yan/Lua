//=========================================================================== 
// Trigger: qingchushuiguai2
//=========================================================================== 
function InitTrig_qingchushuiguai2 takes nothing returns nothing
set gg_trg_qingchushuiguai2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_qingchushuiguai2,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_qingchushuiguai2,Condition(function Trig_qingchushuiguai2_Conditions))
call TriggerAddAction(gg_trg_qingchushuiguai2,function Trig_qingchushuiguai2_Actions)
endfunction

function Trig_qingchushuiguai2_Actions takes nothing returns nothing
if(Trig_qingchushuiguai2_Func001C())then
if(Trig_qingchushuiguai2_Func001Func001C())then
set udg_R_qingchushuiguai_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_R_qingchushuiguai_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC巨|r|cFFCCFFE6钳|r|cFFCCFFFF蟹|r"+(" |cFFFFFF00"+(I2S(udg_R_qingchushuiguai_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/30|r"))))
if(Trig_qingchushuiguai2_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_R_qingchushuiguai_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_R_qingchushuiguai_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC巨|r|cFFCCFFE6钳|r|cFFCCFFFF蟹|r"+(" |cFFFFFF00"+(I2S(udg_R_qingchushuiguai_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/30|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：清除水怪已经完成，回去找秦奋吧|r")
set udg_SP=GetUnitLoc(gg_unit_ngzd_0001)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,10.00)
if(Trig_qingchushuiguai2_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_qingchushuiguai2_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nsc2'))then
return false
endif
return true
endfunction