//=========================================================================== 
// Trigger: jianxuan10
//=========================================================================== 
function InitTrig_jianxuan10 takes nothing returns nothing
set gg_trg_jianxuan10=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_jianxuan10,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_jianxuan10,Condition(function Trig_jianxuan10_Conditions))
call TriggerAddAction(gg_trg_jianxuan10,function Trig_jianxuan10_Actions)
endfunction

function Trig_jianxuan10_Actions takes nothing returns nothing
if(Trig_jianxuan10_Func001C())then
if(Trig_jianxuan10_Func001Func001C())then
set udg_MP_jianxuan_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_jianxuan_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC杀|r|cFFCCFFD4死|r|cFFCCFFDD龙|r|cFFCCFFE6骨|r|cFFCCFFEE守|r|cFFCCFFF6护|r|cFFCCFFFF者|r"+(" |cFFFFFF00"+(I2S(udg_MP_jianxuan_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
if(Trig_jianxuan10_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_MP_jianxuan_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_jianxuan_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC杀|r|cFFCCFFD4死|r|cFFCCFFDD龙|r|cFFCCFFE6骨|r|cFFCCFFEE守|r|cFFCCFFF6护|r|cFFCCFFFF者|r"+(" |cFFFFFF00"+(I2S(udg_MP_jianxuan_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：已经杀死了足够的龙骨守护者！回去找尹月行吧|r")
set udg_SP=GetUnitLoc(gg_unit_nfor_0612)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,10.00)
if(Trig_jianxuan10_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_jianxuan10_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nsth'))then
return false
endif
return true
endfunction