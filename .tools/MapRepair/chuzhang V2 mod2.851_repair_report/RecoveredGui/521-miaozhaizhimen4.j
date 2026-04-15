//=========================================================================== 
// Trigger: miaozhaizhimen4
//=========================================================================== 
function InitTrig_miaozhaizhimen4 takes nothing returns nothing
set gg_trg_miaozhaizhimen4=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_miaozhaizhimen4,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_miaozhaizhimen4,Condition(function Trig_miaozhaizhimen4_Conditions))
call TriggerAddAction(gg_trg_miaozhaizhimen4,function Trig_miaozhaizhimen4_Actions)
endfunction

function Trig_miaozhaizhimen4_Actions takes nothing returns nothing
if(Trig_miaozhaizhimen4_Func001C())then
if(Trig_miaozhaizhimen4_Func001Func001C())then
if(Trig_miaozhaizhimen4_Func001Func001Func001C())then
set udg_miaozhaizhimen_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_miaozhaizhimen_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC苗|r|cFFCCFFD9寨|r|cFFCCFFE6祭|r|cFFCCFFF2师|r|cFFCCFFFF：|r"+(" |cFFFFFF00"+(I2S(udg_miaozhaizhimen_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC苗|r|cFFCCFFD9寨|r|cFFCCFFE6先|r|cFFCCFFF2锋|r|cFFCCFFFF：|r"+(" |cFFFFFF00"+(I2S(udg_miaozhaizhimen_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC苗|r|cFFCCFFD9寨|r|cFFCCFFE6长|r|cFFCCFFF2老|r|cFFCCFFFF：|r"+(" |cFFFFFF00"+(I2S(udg_miaozhaizhimen_num3[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/5|r"))))
if(Trig_miaozhaizhimen4_Func001Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_miaozhaizhimen_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_miaozhaizhimen_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC苗|r|cFFCCFFD9寨|r|cFFCCFFE6祭|r|cFFCCFFF2师|r|cFFCCFFFF：|r"+(" |cFFFFFF00"+(I2S(udg_miaozhaizhimen_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC苗|r|cFFCCFFD9寨|r|cFFCCFFE6先|r|cFFCCFFF2锋|r|cFFCCFFFF：|r"+(" |cFFFFFF00"+(I2S(udg_miaozhaizhimen_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC苗|r|cFFCCFFD9寨|r|cFFCCFFE6长|r|cFFCCFFF2老|r|cFFCCFFFF：|r"+(" |cFFFFFF00"+(I2S(udg_miaozhaizhimen_num3[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/5|r"))))
if(Trig_miaozhaizhimen4_Func001Func001Func001Func005C())then
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：所杀苗人数量已经足够，回去找石中保吧|r")
set udg_SP=GetUnitLoc(gg_unit_nanm_0508)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,20.00)
if(Trig_miaozhaizhimen4_Func001Func001Func001Func005Func004001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
endif
endif
else
endif
else
endif
if(Trig_miaozhaizhimen4_Func002C())then
if(Trig_miaozhaizhimen4_Func002Func001C())then
if(Trig_miaozhaizhimen4_Func002Func001Func001C())then
set udg_miaozhaizhimen_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_miaozhaizhimen_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC苗|r|cFFCCFFD9寨|r|cFFCCFFE6祭|r|cFFCCFFF2师|r|cFFCCFFFF：|r"+(" |cFFFFFF00"+(I2S(udg_miaozhaizhimen_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC苗|r|cFFCCFFD9寨|r|cFFCCFFE6先|r|cFFCCFFF2锋|r|cFFCCFFFF：|r"+(" |cFFFFFF00"+(I2S(udg_miaozhaizhimen_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC苗|r|cFFCCFFD9寨|r|cFFCCFFE6长|r|cFFCCFFF2老|r|cFFCCFFFF：|r"+(" |cFFFFFF00"+(I2S(udg_miaozhaizhimen_num3[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/5|r"))))
if(Trig_miaozhaizhimen4_Func002Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_miaozhaizhimen_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_miaozhaizhimen_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC苗|r|cFFCCFFD9寨|r|cFFCCFFE6祭|r|cFFCCFFF2师|r|cFFCCFFFF：|r"+(" |cFFFFFF00"+(I2S(udg_miaozhaizhimen_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC苗|r|cFFCCFFD9寨|r|cFFCCFFE6先|r|cFFCCFFF2锋|r|cFFCCFFFF：|r"+(" |cFFFFFF00"+(I2S(udg_miaozhaizhimen_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC苗|r|cFFCCFFD9寨|r|cFFCCFFE6长|r|cFFCCFFF2老|r|cFFCCFFFF：|r"+(" |cFFFFFF00"+(I2S(udg_miaozhaizhimen_num3[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/5|r"))))
if(Trig_miaozhaizhimen4_Func002Func001Func001Func005C())then
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：所杀苗人数量已经足够，回去找石中保吧|r")
set udg_SP=GetUnitLoc(gg_unit_nanm_0508)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,20.00)
if(Trig_miaozhaizhimen4_Func002Func001Func001Func005Func004001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
endif
endif
else
endif
else
endif
if(Trig_miaozhaizhimen4_Func003C())then
if(Trig_miaozhaizhimen4_Func003Func001C())then
if(Trig_miaozhaizhimen4_Func003Func001Func001C())then
set udg_miaozhaizhimen_num3[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_miaozhaizhimen_num3[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC苗|r|cFFCCFFD9寨|r|cFFCCFFE6祭|r|cFFCCFFF2师|r|cFFCCFFFF：|r"+(" |cFFFFFF00"+(I2S(udg_miaozhaizhimen_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC苗|r|cFFCCFFD9寨|r|cFFCCFFE6先|r|cFFCCFFF2锋|r|cFFCCFFFF：|r"+(" |cFFFFFF00"+(I2S(udg_miaozhaizhimen_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC苗|r|cFFCCFFD9寨|r|cFFCCFFE6长|r|cFFCCFFF2老|r|cFFCCFFFF：|r"+(" |cFFFFFF00"+(I2S(udg_miaozhaizhimen_num3[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/5|r"))))
if(Trig_miaozhaizhimen4_Func003Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_miaozhaizhimen_num3[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_miaozhaizhimen_num3[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC苗|r|cFFCCFFD9寨|r|cFFCCFFE6祭|r|cFFCCFFF2师|r|cFFCCFFFF：|r"+(" |cFFFFFF00"+(I2S(udg_miaozhaizhimen_num1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC苗|r|cFFCCFFD9寨|r|cFFCCFFE6先|r|cFFCCFFF2锋|r|cFFCCFFFF：|r"+(" |cFFFFFF00"+(I2S(udg_miaozhaizhimen_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC苗|r|cFFCCFFD9寨|r|cFFCCFFE6长|r|cFFCCFFF2老|r|cFFCCFFFF：|r"+(" |cFFFFFF00"+(I2S(udg_miaozhaizhimen_num3[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/5|r"))))
if(Trig_miaozhaizhimen4_Func003Func001Func001Func005C())then
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：所杀苗人数量已经足够，回去找石中保吧|r")
set udg_SP=GetUnitLoc(gg_unit_nanm_0508)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,20.00)
if(Trig_miaozhaizhimen4_Func003Func001Func001Func005Func004001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
endif
endif
else
endif
else
endif
endfunction

function Trig_miaozhaizhimen4_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
return true
endfunction