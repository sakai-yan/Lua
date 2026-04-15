//=========================================================================== 
// Trigger: shiwusucai2
//=========================================================================== 
function InitTrig_shiwusucai2 takes nothing returns nothing
set gg_trg_shiwusucai2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_shiwusucai2,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_shiwusucai2,Condition(function Trig_shiwusucai2_Conditions))
call TriggerAddAction(gg_trg_shiwusucai2,function Trig_shiwusucai2_Actions)
endfunction

function Trig_shiwusucai2_Actions takes nothing returns nothing
if(Trig_shiwusucai2_Func001C())then
if(Trig_shiwusucai2_Func001Func001C())then
set udg_shiwusucai_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_shiwusucai_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFF00FF00牛|r|cFFCCFFCC肉|r"+(" |cFFFFFF00"+(I2S(udg_shiwusucai_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/20|r"))))
if(Trig_shiwusucai2_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_shiwusucai_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_shiwusucai_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFF00FF00牛|r|cFFCCFFCC肉|r"+(" |cFFFFFF00"+(I2S(udg_shiwusucai_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/20|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：牛肉收集已经完成，回去找陆小丰吧|r")
set udg_SP=GetUnitLoc(gg_unit_ndtt_0383)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,20.00)
if(Trig_shiwusucai2_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_shiwusucai2_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nmrv'))then
return false
endif
return true
endfunction