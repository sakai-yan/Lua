//=========================================================================== 
// Trigger: nianhuoshi5
//=========================================================================== 
function InitTrig_nianhuoshi5 takes nothing returns nothing
set gg_trg_nianhuoshi5=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_nianhuoshi5,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_nianhuoshi5,Condition(function Trig_nianhuoshi5_Conditions))
call TriggerAddAction(gg_trg_nianhuoshi5,function Trig_nianhuoshi5_Actions)
endfunction

function Trig_nianhuoshi5_Actions takes nothing returns nothing
if(Trig_nianhuoshi5_Func001C())then
if(Trig_nianhuoshi5_Func001Func001C())then
if(Trig_nianhuoshi5_Func001Func001Func002C())then
set udg_MP_nianhuoshi_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_nianhuoshi_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC获|r|cFFCCFFDD得|r|cFFCCFFEE树|r|cFFCCFFFF灵|r"+(" |cFFFFFF00"+(I2S(udg_MP_nianhuoshi_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
if(Trig_nianhuoshi5_Func001Func001Func002Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_MP_nianhuoshi_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_nianhuoshi_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC获|r|cFFCCFFDD得|r|cFFCCFFEE树|r|cFFCCFFFF灵|r"+(" |cFFFFFF00"+(I2S(udg_MP_nianhuoshi_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：树灵已经收集够了，回去法魂门找胡絮吧！|r")
set udg_SP=GetUnitLoc(gg_unit_nsce_0324)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,10.00)
if(Trig_nianhuoshi5_Func001Func001Func002Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
else
endif
endfunction

function Trig_nianhuoshi5_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nowe'))then
return false
endif
return true
endfunction