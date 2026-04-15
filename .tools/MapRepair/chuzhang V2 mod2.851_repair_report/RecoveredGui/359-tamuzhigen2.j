//=========================================================================== 
// Trigger: tamuzhigen2
//=========================================================================== 
function InitTrig_tamuzhigen2 takes nothing returns nothing
set gg_trg_tamuzhigen2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_tamuzhigen2,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_tamuzhigen2,Condition(function Trig_tamuzhigen2_Conditions))
call TriggerAddAction(gg_trg_tamuzhigen2,function Trig_tamuzhigen2_Actions)
endfunction

function Trig_tamuzhigen2_Actions takes nothing returns nothing
if(Trig_tamuzhigen2_Func001C())then
if(Trig_tamuzhigen2_Func001Func001C())then
set udg_R_tamuzhigen_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_R_tamuzhigen_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC塔|r|cFFCCFFDD木|r|cFFCCFFEE幼|r|cFFCCFFFF苗|r"+(" |cFFFFFF00"+(I2S(udg_R_tamuzhigen_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FF00/20|r"))))
if(Trig_tamuzhigen2_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_R_tamuzhigen_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_R_tamuzhigen_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC塔|r|cFFCCFFDD木|r|cFFCCFFEE幼|r|cFFCCFFFF苗|r"+(" |cFFFFFF00"+(I2S(udg_R_tamuzhigen_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FF00/20|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99塔木幼苗收集完成，回去找童无欺吧|r")
set udg_SP=GetUnitLoc(gg_unit_nlv1_0180)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
if(Trig_tamuzhigen2_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
call TriggerSleepAction(14.00)
call CreateItemLoc('totw',udg_R_tamuzhigen_p1[GetRandomInt(1,6)])
endfunction

function Trig_tamuzhigen2_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='totw'))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction