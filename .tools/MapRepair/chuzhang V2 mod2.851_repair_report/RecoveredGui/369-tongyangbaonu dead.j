//=========================================================================== 
// Trigger: tongyangbaonu dead
//=========================================================================== 
function InitTrig_tongyangbaonu_dead takes nothing returns nothing
set gg_trg_tongyangbaonu_dead=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_tongyangbaonu_dead,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_tongyangbaonu_dead,Condition(function Trig_tongyangbaonu_dead_Conditions))
call TriggerAddAction(gg_trg_tongyangbaonu_dead,function Trig_tongyangbaonu_dead_Actions)
endfunction

function Trig_tongyangbaonu_dead_Actions takes nothing returns nothing
if(Trig_tongyangbaonu_dead_Func001C())then
if(Trig_tongyangbaonu_dead_Func001Func001C())then
set udg_tongyangbaonu_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_tongyangbaonu_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC暴|r|cFFCCFFDD怒|r|cFFCCFFEE鹿|r|cFFCCFFFF妖|r"+(" |cFFFFFF00"+(I2S(udg_tongyangbaonu_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
if(Trig_tongyangbaonu_dead_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_tongyangbaonu_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_tongyangbaonu_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,("|cFFCCFFCC暴|r|cFFCCFFDD怒|r|cFFCCFFEE鹿|r|cFFCCFFFF妖|r"+(" |cFFFFFF00"+(I2S(udg_tongyangbaonu_num[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：暴怒鹿妖已经杀够了，回去找李达吧|r")
set udg_SP=GetUnitLoc(gg_unit_nlv3_0350)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,20.00)
if(Trig_tongyangbaonu_dead_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_tongyangbaonu_dead_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nowe'))then
return false
endif
return true
endfunction