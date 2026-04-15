//=========================================================================== 
// Trigger: shengming2
//=========================================================================== 
function InitTrig_shengming2 takes nothing returns nothing
set gg_trg_shengming2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_shengming2,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_shengming2,Condition(function Trig_shengming2_Conditions))
call TriggerAddAction(gg_trg_shengming2,function Trig_shengming2_Actions)
endfunction

function Trig_shengming2_Actions takes nothing returns nothing
if(Trig_shengming2_Func001C())then
if(Trig_shengming2_Func001Func001C())then
set udg_MP_shengming_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_MP_shengming_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC亥|r|cFFCCFFE6什|r|cFFCCFFFF草|r"+(" |cFFFFFF00"+(I2S(udg_MP_shengming_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FF00/20|r"))))
if(Trig_shengming2_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_MP_shengming_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_MP_shengming_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC亥|r|cFFCCFFE6什|r|cFFCCFFFF草|r"+(" |cFFFFFF00"+(I2S(udg_MP_shengming_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FF00/20|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99亥什草收集完成，回去找白鹿先生吧|r")
set udg_SP=GetUnitLoc(gg_unit_nfh1_0124)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,4.00)
if(Trig_shengming2_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
call TriggerSleepAction(23.00)
call CreateItemLoc('blba',udg_MP_shengming_p1[GetRandomInt(1,8)])
endfunction

function Trig_shengming2_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='blba'))then
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