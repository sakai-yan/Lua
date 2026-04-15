//=========================================================================== 
// Trigger: shengming4
//=========================================================================== 
function InitTrig_shengming4 takes nothing returns nothing
set gg_trg_shengming4=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_shengming4,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_shengming4,Condition(function Trig_shengming4_Conditions))
call TriggerAddAction(gg_trg_shengming4,function Trig_shengming4_Actions)
endfunction

function Trig_shengming4_Actions takes nothing returns nothing
if(Trig_shengming4_Func001C())then
if(Trig_shengming4_Func001Func001C())then
set udg_MP_shengming_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_MP_shengming_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC血|r|cFFCCFFE6丝|r|cFFCCFFFF草|r"+(" |cFFFFFF00"+(I2S(udg_MP_shengming_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FF00/20|r"))))
if(Trig_shengming4_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_MP_shengming_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_MP_shengming_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC血|r|cFFCCFFE6丝|r|cFFCCFFFF草|r"+(" |cFFFFFF00"+(I2S(udg_MP_shengming_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FF00/20|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99血丝草收集完成，回去找白鹿先生吧|r")
set udg_SP=GetUnitLoc(gg_unit_nfh1_0124)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,4.00)
if(Trig_shengming4_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
call TriggerSleepAction(23.00)
call CreateItemLoc('spre',udg_MP_shengming_p2[GetRandomInt(1,7)])
endfunction

function Trig_shengming4_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='spre'))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction