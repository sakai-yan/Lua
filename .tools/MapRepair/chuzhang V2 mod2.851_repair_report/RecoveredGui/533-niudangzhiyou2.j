//=========================================================================== 
// Trigger: niudangzhiyou2
//=========================================================================== 
function InitTrig_niudangzhiyou2 takes nothing returns nothing
set gg_trg_niudangzhiyou2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_niudangzhiyou2,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_niudangzhiyou2,Condition(function Trig_niudangzhiyou2_Conditions))
call TriggerAddAction(gg_trg_niudangzhiyou2,function Trig_niudangzhiyou2_Actions)
endfunction

function Trig_niudangzhiyou2_Actions takes nothing returns nothing
if(Trig_niudangzhiyou2_Func001C())then
if(Trig_niudangzhiyou2_Func001Func001C())then
set udg_niudangzhiyou_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_niudangzhiyou_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFF00FF00牛|r|cFFCCFFCC妖|r"+(" |cFFFFFF00"+(I2S(udg_niudangzhiyou_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/20|r"))))
if(Trig_niudangzhiyou2_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_niudangzhiyou_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_niudangzhiyou_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFF00FF00牛|r|cFFCCFFCC妖|r"+(" |cFFFFFF00"+(I2S(udg_niudangzhiyou_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/20|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：牛妖已经得到教训，回去找邓功名吧|r")
set udg_SP=GetUnitLoc(gg_unit_narg_0714)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,20.00)
if(Trig_niudangzhiyou2_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_niudangzhiyou2_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nsqt'))then
return false
endif
return true
endfunction