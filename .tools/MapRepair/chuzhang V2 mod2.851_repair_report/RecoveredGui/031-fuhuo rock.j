//=========================================================================== 
// Trigger: fuhuo rock
//=========================================================================== 
function InitTrig_fuhuo_rock takes nothing returns nothing
set gg_trg_fuhuo_rock=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_fuhuo_rock,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_fuhuo_rock,Condition(function Trig_fuhuo_rock_Conditions))
call TriggerAddAction(gg_trg_fuhuo_rock,function Trig_fuhuo_rock_Actions)
endfunction

function Trig_fuhuo_rock_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetTriggerUnit())
set udg_SP2=GetUnitLoc(gg_unit_nbsw_0362)
if(Trig_fuhuo_rock_Func003C())then
set udg_hero_SP[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetRectCenter(gg_rct______________081________3)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000系统信息：|r|cFF00FFFF你把复活点设置在了|r|cFFFFFF00文莱村|r|cFF00FFFF。|r")
call AddItemToStockBJ('drph',gg_unit_nbsw_0362,1,1)
set udg_hero_SP_N[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
else
set udg_SP2=GetUnitLoc(gg_unit_nbsw_0359)
if(Trig_fuhuo_rock_Func003Func002C())then
set udg_hero_SP[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetRectCenter(gg_rct______________081_______u)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000系统信息：|r|cFF00FFFF你把复活点设置在了|r|cFFFFFF00塔木村|r|cFF00FFFF。|r")
call AddItemToStockBJ('drph',gg_unit_nbsw_0359,1,1)
set udg_hero_SP_N[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=2
else
set udg_SP2=GetUnitLoc(gg_unit_nbsw_0361)
if(Trig_fuhuo_rock_Func003Func002Func002C())then
set udg_hero_SP[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetRectCenter(gg_rct______________081)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000系统信息：|r|cFF00FFFF你把复活点设置在了|r|cFFFFFF00魂山|r|cFF00FFFF。|r")
call AddItemToStockBJ('drph',gg_unit_nbsw_0361,1,1)
set udg_hero_SP_N[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=3
else
set udg_SP2=GetUnitLoc(gg_unit_nbsw_0360)
if(Trig_fuhuo_rock_Func003Func002Func002Func002C())then
set udg_hero_SP[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetRectCenter(gg_rct______________081________2)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000系统信息：|r|cFF00FFFF你把复活点设置在了|r|cFFFFFF00龙泉镇|r|cFF00FFFF。|r")
call AddItemToStockBJ('drph',gg_unit_nbsw_0360,1,1)
set udg_hero_SP_N[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=4
else
set udg_SP2=GetUnitLoc(gg_unit_nbsw_0476)
if(Trig_fuhuo_rock_Func003Func002Func002Func002Func002C())then
set udg_hero_SP[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetRectCenter(gg_rct______________100)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000系统信息：|r|cFF00FFFF你把复活点设置在了|r|cFFFFFF00龙泉镇|r|cFF00FFFF。|r")
call AddItemToStockBJ('drph',gg_unit_nbsw_0476,1,1)
set udg_hero_SP_N[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=5
else
set udg_SP2=GetUnitLoc(gg_unit_nbsw_0713)
if(Trig_fuhuo_rock_Func003Func002Func002Func002Func002Func002C())then
set udg_hero_SP[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetRectCenter(gg_rct______________135)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000系统信息：|r|cFF00FFFF你把复活点设置在了|r|cFFFFFF00长丰村|r|cFF00FFFF。|r")
call AddItemToStockBJ('drph',gg_unit_nbsw_0713,1,1)
set udg_hero_SP_N[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=6
else
endif
endif
endif
endif
endif
endif
call RemoveLocation(udg_SP)
call RemoveLocation(udg_SP2)
endfunction

function Trig_fuhuo_rock_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(GetItemTypeId(GetManipulatedItem())=='drph'))then
return false
endif
return true
endfunction