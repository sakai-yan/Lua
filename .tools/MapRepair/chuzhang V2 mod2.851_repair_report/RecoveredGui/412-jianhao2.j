//=========================================================================== 
// Trigger: jianhao2
//=========================================================================== 
function InitTrig_jianhao2 takes nothing returns nothing
set gg_trg_jianhao2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_jianhao2,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_jianhao2,Condition(function Trig_jianhao2_Conditions))
call TriggerAddAction(gg_trg_jianhao2,function Trig_jianhao2_Actions)
endfunction

function Trig_jianhao2_Actions takes nothing returns nothing
if(Trig_jianhao2_Func001C())then
if(Trig_jianhao2_Func001Func001C())then
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
set udg_MP_jianhao_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_jianhao_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC蔷|r|cFFCCFFE6树|r|cFFCCFFFF精|r"+(" |cFFFFFF00"+(I2S(udg_MP_jianhao_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
if(Trig_jianhao2_Func001Func001Func014001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
set udg_MP_jianhao_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_MP_jianhao_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC蔷|r|cFFCCFFE6树|r|cFFCCFFFF精|r"+(" |cFFFFFF00"+(I2S(udg_MP_jianhao_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
if(Trig_jianhao2_Func001Func001Func005001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：蔷树精已经杀够了，回去找杨清吧！|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ngnh_0123)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,10.00)
if(Trig_jianhao2_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_jianhao2_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nenp'))then
return false
endif
if(not(UnitHasItemOfTypeBJ(GetKillingUnitBJ(),'sehr')==true))then
return false
endif
return true
endfunction