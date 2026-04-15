//=========================================================================== 
// Trigger: xiongpi4
//=========================================================================== 
function InitTrig_xiongpi4 takes nothing returns nothing
set gg_trg_xiongpi4=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_xiongpi4,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_xiongpi4,Condition(function Trig_xiongpi4_Conditions))
call TriggerAddAction(gg_trg_xiongpi4,function Trig_xiongpi4_Actions)
endfunction

function Trig_xiongpi4_Actions takes nothing returns nothing
if(Trig_xiongpi4_Func001C())then
if(Trig_xiongpi4_Func001Func001C())then
set udg_R_xiongpi_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_R_xiongpi_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC熊|r|cFFCCFFFF骨|r"+(" |cFFFFFF00"+(I2S(udg_R_xiongpi_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
if(Trig_xiongpi4_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_R_xiongpi_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_R_xiongpi_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC熊|r|cFFCCFFFF骨|r"+(" |cFFFFFF00"+(I2S(udg_R_xiongpi_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：熊骨已经足够，回去找张业|r")
set udg_SP=GetUnitLoc(gg_unit_ngz4_0179)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,10.00)
if(Trig_xiongpi4_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_xiongpi4_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nplb'))then
return false
endif
return true
endfunction