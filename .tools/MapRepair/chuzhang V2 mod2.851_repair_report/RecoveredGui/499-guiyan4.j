//=========================================================================== 
// Trigger: guiyan4
//=========================================================================== 
function InitTrig_guiyan4 takes nothing returns nothing
set gg_trg_guiyan4=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_guiyan4,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_guiyan4,Condition(function Trig_guiyan4_Conditions))
call TriggerAddAction(gg_trg_guiyan4,function Trig_guiyan4_Actions)
endfunction

function Trig_guiyan4_Actions takes nothing returns nothing
if(Trig_guiyan4_Func001C())then
if(Trig_guiyan4_Func001Func001C())then
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
set udg_MP_guiyan_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_guiyan_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC获|r|cFFCCFFDD得|r|cFFCCFFEE鲜|r|cFFCCFFFF血|r"+(" |cFFFFFF00"+(I2S(udg_MP_guiyan_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/50|r"))))
if(Trig_guiyan4_Func001Func001Func014001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
if(Trig_guiyan4_Func001Func001Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_MP_guiyan_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_guiyan_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC获|r|cFFCCFFDD得|r|cFFCCFFEE鲜|r|cFFCCFFFF血|r"+(" |cFFFFFF00"+(I2S(udg_MP_guiyan_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/50|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：地灵已经获取足够鲜血，回去找半蓑人吧！|r")
set udg_SP=GetUnitLoc(gg_unit_ncgb_0629)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,30.00)
if(Trig_guiyan4_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_guiyan4_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not Trig_guiyan4_Func003C())then
return false
endif
return true
endfunction