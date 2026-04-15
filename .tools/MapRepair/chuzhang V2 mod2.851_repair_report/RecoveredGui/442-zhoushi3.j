//=========================================================================== 
// Trigger: zhoushi3
//=========================================================================== 
function InitTrig_zhoushi3 takes nothing returns nothing
set gg_trg_zhoushi3=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_zhoushi3,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_zhoushi3,Condition(function Trig_zhoushi3_Conditions))
call TriggerAddAction(gg_trg_zhoushi3,function Trig_zhoushi3_Actions)
endfunction

function Trig_zhoushi3_Actions takes nothing returns nothing
if(Trig_zhoushi3_Func001C())then
if(Trig_zhoushi3_Func001Func001C())then
set udg_MP_zhoushi_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_zhoushi_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC草|r|cFFCCFFD6齿|r|cFFCCFFE0兽|r|cFFCCFFEB的|r|cFFCCFFF5胆|r|cFFCCFFFF囊|r"+(" |cFFFFFF00"+(I2S(udg_MP_zhoushi_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/5|r"))))
if(Trig_zhoushi3_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_MP_zhoushi_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_zhoushi_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC草|r|cFFCCFFD6齿|r|cFFCCFFE0兽|r|cFFCCFFEB的|r|cFFCCFFF5胆|r|cFFCCFFFF囊|r"+(" |cFFFFFF00"+(I2S(udg_MP_zhoushi_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/5|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：胆囊已经收集完成，回去找伏樱师吧|r")
set udg_SP=GetUnitLoc(gg_unit_nshw_0366)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,4.00)
if(Trig_zhoushi3_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_zhoushi3_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='njg1'))then
return false
endif
return true
endfunction