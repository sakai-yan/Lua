//=========================================================================== 
// Trigger: xiufushizhen2
//=========================================================================== 
function InitTrig_xiufushizhen2 takes nothing returns nothing
set gg_trg_xiufushizhen2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_xiufushizhen2,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_xiufushizhen2,Condition(function Trig_xiufushizhen2_Conditions))
call TriggerAddAction(gg_trg_xiufushizhen2,function Trig_xiufushizhen2_Actions)
endfunction

function Trig_xiufushizhen2_Actions takes nothing returns nothing
if(Trig_xiufushizhen2_Func001C())then
if(Trig_xiufushizhen2_Func001Func001C())then
set udg_R_xiufushizhen_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_R_xiufushizhen_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC燃|r|cFFCCFFD4火|r|cFFCCFFDD小|r|cFFCCFFE6妖|r|cFFCCFFEE的|r|cFFCCFFF6灵|r|cFFCCFFFF气|r"+(" |cFFFFFF00"+(I2S(udg_R_xiufushizhen_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/20|r"))))
if(Trig_xiufushizhen2_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_R_xiufushizhen_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_R_xiufushizhen_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC燃|r|cFFCCFFD4火|r|cFFCCFFDD小|r|cFFCCFFE6妖|r|cFFCCFFEE的|r|cFFCCFFF6灵|r|cFFCCFFFF气|r"+(" |cFFFFFF00"+(I2S(udg_R_xiufushizhen_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/20|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：灵气已经全部到手，回去找阿亥吧|r")
set udg_SP=GetUnitLoc(gg_unit_ngzc_0094)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,10.00)
if(Trig_xiufushizhen2_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_xiufushizhen2_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nkob'))then
return false
endif
return true
endfunction