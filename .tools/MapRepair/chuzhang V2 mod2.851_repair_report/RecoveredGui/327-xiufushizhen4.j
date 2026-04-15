//=========================================================================== 
// Trigger: xiufushizhen4
//=========================================================================== 
function InitTrig_xiufushizhen4 takes nothing returns nothing
set gg_trg_xiufushizhen4=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_xiufushizhen4,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_xiufushizhen4,Condition(function Trig_xiufushizhen4_Conditions))
call TriggerAddAction(gg_trg_xiufushizhen4,function Trig_xiufushizhen4_Actions)
endfunction

function Trig_xiufushizhen4_Actions takes nothing returns nothing
if(Trig_xiufushizhen4_Func001C())then
if(Trig_xiufushizhen4_Func001Func001C())then
if(Trig_xiufushizhen4_Func001Func001Func001C())then
set udg_R_xiufushizhen_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_R_xiufushizhen_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC燃|r|cFFCCFFDD火|r|cFFCCFFEE精|r|cFFCCFFFF髓|r"+(" |cFFFFFF00"+(I2S(udg_R_xiufushizhen_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
if(Trig_xiufushizhen4_Func001Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_R_xiufushizhen_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_R_xiufushizhen_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC燃|r|cFFCCFFDD火|r|cFFCCFFEE精|r|cFFCCFFFF髓|r"+(" |cFFFFFF00"+(I2S(udg_R_xiufushizhen_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
if(Trig_xiufushizhen4_Func001Func001Func001Func003C())then
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：|r|cFFFFFF00燃火精髓|r|cFFFFFF99和|r|cFFFFFF00石料|r|cFFFFFF99已经全部到手，回去找阿亥吧。|r")
set udg_SP=GetUnitLoc(gg_unit_ngzc_0094)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,10.00)
if(Trig_xiufushizhen4_Func001Func001Func001Func003Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：|r|cFFFFFF00燃火精髓|r|cFFFFFF99已经全部到手，尽快把|r|cFFFFFF00石料|r|cFFFFFF99也收集完吧。|r")
if(Trig_xiufushizhen4_Func001Func001Func001Func003Func002001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
endif
endif
else
endif
else
endif
endfunction

function Trig_xiufushizhen4_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nkog'))then
return false
endif
return true
endfunction