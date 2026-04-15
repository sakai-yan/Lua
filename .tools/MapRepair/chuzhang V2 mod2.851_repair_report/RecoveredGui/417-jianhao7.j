//=========================================================================== 
// Trigger: jianhao7
//=========================================================================== 
function InitTrig_jianhao7 takes nothing returns nothing
set gg_trg_jianhao7=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_jianhao7,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddAction(gg_trg_jianhao7,function Trig_jianhao7_Actions)
endfunction

function Trig_jianhao7_Actions takes nothing returns nothing
if(Trig_jianhao7_Func001C())then
if(Trig_jianhao7_Func001Func001C())then
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
set udg_MP_jianhao_NUM3[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_jianhao_NUM3[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC山|r|cFFCCFFDD贼|r|cFFCCFFEE队|r|cFFCCFFFF长|r"+(" |cFFFFFF00"+(I2S(udg_MP_jianhao_NUM3[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/5|r"))))
if(Trig_jianhao7_Func001Func001Func014001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
if(Trig_jianhao7_Func001Func001Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
set udg_MP_jianhao_NUM3[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_jianhao_NUM3[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC山|r|cFFCCFFDD贼|r|cFFCCFFEE队|r|cFFCCFFFF长|r"+(" |cFFFFFF00"+(I2S(udg_MP_jianhao_NUM3[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/5|r"))))
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：山贼已经剿灭，回御剑门找蔡掌门吧！|r")
set udg_SP=GetUnitLoc(gg_unit_nlv2_0262)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,10.00)
if(Trig_jianhao7_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction