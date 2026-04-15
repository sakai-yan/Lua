//=========================================================================== 
// Trigger: xiezichongsheng2
//=========================================================================== 
function InitTrig_xiezichongsheng2 takes nothing returns nothing
set gg_trg_xiezichongsheng2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_xiezichongsheng2,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_xiezichongsheng2,Condition(function Trig_xiezichongsheng2_Conditions))
call TriggerAddAction(gg_trg_xiezichongsheng2,function Trig_xiezichongsheng2_Actions)
endfunction

function Trig_xiezichongsheng2_Actions takes nothing returns nothing
if(Trig_xiezichongsheng2_Func001C())then
if(Trig_xiezichongsheng2_Func001Func001C())then
set udg_R_xiezicongsheng_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_R_xiezicongsheng_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC毒|r|cFFCCFFFF蝎|r"+(" |cFFFFFF00"+(I2S(udg_R_xiezicongsheng_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/20|r"))))
if(Trig_xiezichongsheng2_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_R_xiezicongsheng_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_R_xiezicongsheng_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC毒|r|cFFCCFFFF蝎|r"+(" |cFFFFFF00"+(I2S(udg_R_xiezicongsheng_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/20|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：毒蝎已经清除够了，回去找葛一风吧|r")
set udg_SP=GetUnitLoc(gg_unit_nshf_0235)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,10.00)
if(Trig_xiezichongsheng2_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_xiezichongsheng2_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nanc'))then
return false
endif
return true
endfunction