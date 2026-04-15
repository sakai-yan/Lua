//=========================================================================== 
// Trigger: jinghuayeshou4
//=========================================================================== 
function InitTrig_jinghuayeshou4 takes nothing returns nothing
set gg_trg_jinghuayeshou4=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_jinghuayeshou4,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_jinghuayeshou4,Condition(function Trig_jinghuayeshou4_Conditions))
call TriggerAddAction(gg_trg_jinghuayeshou4,function Trig_jinghuayeshou4_Actions)
endfunction

function Trig_jinghuayeshou4_Actions takes nothing returns nothing
if(Trig_jinghuayeshou4_Func001C())then
if(Trig_jinghuayeshou4_Func001Func001C())then
set udg_R_jinghua_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_R_jinghua_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC鹿|r|cFFCCFFFF妖|r"+(" |cFFFFFF00"+(I2S(udg_R_jinghua_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/20|r"))))
if(Trig_jinghuayeshou4_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_R_jinghua_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_R_jinghua_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC鹿|r|cFFCCFFFF妖|r"+(" |cFFFFFF00"+(I2S(udg_R_jinghua_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/20|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：已经杀死足够的鹿妖，回去找塔木村长吧|r")
set udg_SP=GetUnitLoc(gg_unit_ncg3_0189)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,10.00)
if(Trig_jinghuayeshou4_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_jinghuayeshou4_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nowb'))then
return false
endif
return true
endfunction