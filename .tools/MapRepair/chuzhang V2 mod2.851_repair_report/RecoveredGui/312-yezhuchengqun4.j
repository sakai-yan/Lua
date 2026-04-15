//=========================================================================== 
// Trigger: yezhuchengqun4
//=========================================================================== 
function InitTrig_yezhuchengqun4 takes nothing returns nothing
set gg_trg_yezhuchengqun4=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_yezhuchengqun4,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_yezhuchengqun4,Condition(function Trig_yezhuchengqun4_Conditions))
call TriggerAddAction(gg_trg_yezhuchengqun4,function Trig_yezhuchengqun4_Actions)
endfunction

function Trig_yezhuchengqun4_Actions takes nothing returns nothing
if(Trig_yezhuchengqun4_Func001C())then
if(Trig_yezhuchengqun4_Func001Func001C())then
set udg_R_LX_yezhuchengqun_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_R_LX_yezhuchengqun_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC坚|r|cFFCCFFDD毛|r|cFFCCFFEE野|r|cFFCCFFFF猪|r"+(" |cFFFFFF00"+(I2S(udg_R_LX_yezhuchengqun_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
if(Trig_yezhuchengqun4_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_R_LX_yezhuchengqun_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_R_LX_yezhuchengqun_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC坚|r|cFFCCFFDD毛|r|cFFCCFFEE野|r|cFFCCFFFF猪|r"+(" |cFFFFFF00"+(I2S(udg_R_LX_yezhuchengqun_num2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99猎杀|r|cFFFFFF00坚毛野猪|r|cFFFFFF99已达成，回去找铁匠铺的老周吧|r")
set udg_SP=GetUnitLoc(gg_unit_nmh0_0012)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,4.00)
if(Trig_yezhuchengqun4_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_yezhuchengqun4_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nwlg'))then
return false
endif
return true
endfunction