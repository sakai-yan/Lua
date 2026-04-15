//=========================================================================== 
// Trigger: chuansongshi
//=========================================================================== 
function InitTrig_chuansongshi takes nothing returns nothing
set gg_trg_chuansongshi=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_chuansongshi,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_chuansongshi,Condition(function Trig_chuansongshi_Conditions))
call TriggerAddAction(gg_trg_chuansongshi,function Trig_chuansongshi_Actions)
endfunction

function Trig_chuansongshi_Actions takes nothing returns nothing
if(Trig_chuansongshi_Func001C())then
if(Trig_chuansongshi_Func001Func001C())then
call AddItemToStockBJ('pnvl',gg_unit_npfm_0249,1,1)
else
endif
if(Trig_chuansongshi_Func001Func002C())then
call AddItemToStockBJ('pnvl',gg_unit_npfm_0604,1,1)
else
endif
if(Trig_chuansongshi_Func001Func003C())then
set udg_SP=GetRectCenter(gg_rct______________081_______u)
call SetUnitPositionLoc(GetTriggerUnit(),udg_SP)
call PanCameraToTimedLocForPlayer(GetOwningPlayer(GetTriggerUnit()),udg_SP,0)
call RemoveLocation(udg_SP)
else
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+500)
call SetPlayerStateBJ(GetOwningPlayer(GetBuyingUnit()),PLAYER_STATE_RESOURCE_GOLD,udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetBuyingUnit()))])
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000系统信息：|r|cFFFF0000你等级不够|r")
endif
else
endif
if(Trig_chuansongshi_Func002C())then
if(Trig_chuansongshi_Func002Func001C())then
call AddItemToStockBJ('moon',gg_unit_npfm_0603,1,1)
else
endif
if(Trig_chuansongshi_Func002Func002C())then
call AddItemToStockBJ('moon',gg_unit_npfm_0604,1,1)
else
endif
set udg_SP=GetRectCenter(gg_rct______________081________3)
call SetUnitPositionLoc(GetTriggerUnit(),udg_SP)
call PanCameraToTimedLocForPlayer(GetOwningPlayer(GetTriggerUnit()),udg_SP,0)
call RemoveLocation(udg_SP)
else
endif
if(Trig_chuansongshi_Func003C())then
if(Trig_chuansongshi_Func003Func001C())then
call AddItemToStockBJ('vamp',gg_unit_npfm_0249,1,1)
else
endif
if(Trig_chuansongshi_Func003Func002C())then
call AddItemToStockBJ('vamp',gg_unit_npfm_0603,1,1)
else
endif
if(Trig_chuansongshi_Func003Func003C())then
set udg_SP=GetRectCenter(gg_rct______________100)
call SetUnitPositionLoc(GetTriggerUnit(),udg_SP)
call PanCameraToTimedLocForPlayer(GetOwningPlayer(GetTriggerUnit()),udg_SP,0)
call RemoveLocation(udg_SP)
else
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+2000)
call SetPlayerStateBJ(GetOwningPlayer(GetBuyingUnit()),PLAYER_STATE_RESOURCE_GOLD,udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetBuyingUnit()))])
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000系统信息：|r|cFFFF0000你等级不够|r")
endif
else
endif
if(Trig_chuansongshi_Func004C())then
if(Trig_chuansongshi_Func004Func001C())then
set udg_SP=GetRectCenter(gg_rct______________136)
call SetUnitPositionLoc(GetTriggerUnit(),udg_SP)
call PanCameraToTimedLocForPlayer(GetOwningPlayer(GetTriggerUnit()),udg_SP,0)
call RemoveLocation(udg_SP)
else
endif
else
endif
if(Trig_chuansongshi_Func005C())then
set udg_SP=GetRectCenter(gg_rct______________148)
call SetUnitPositionLoc(GetTriggerUnit(),udg_SP)
call PanCameraToTimedLocForPlayer(GetOwningPlayer(GetTriggerUnit()),udg_SP,0)
call RemoveLocation(udg_SP)
else
if(Trig_chuansongshi_Func005Func001C())then
set udg_SP=GetRectCenter(gg_rct______________138)
call SetUnitPositionLoc(GetTriggerUnit(),udg_SP)
call PanCameraToTimedLocForPlayer(GetOwningPlayer(GetTriggerUnit()),udg_SP,0)
call RemoveLocation(udg_SP)
else
if(Trig_chuansongshi_Func005Func001Func001C())then
set udg_SP=GetRectCenter(gg_rct______________139)
call SetUnitPositionLoc(GetTriggerUnit(),udg_SP)
call PanCameraToTimedLocForPlayer(GetOwningPlayer(GetTriggerUnit()),udg_SP,0)
call RemoveLocation(udg_SP)
else
if(Trig_chuansongshi_Func005Func001Func001Func001C())then
set udg_SP=GetRectCenter(gg_rct______________104)
call SetUnitPositionLoc(GetTriggerUnit(),udg_SP)
call PanCameraToTimedLocForPlayer(GetOwningPlayer(GetTriggerUnit()),udg_SP,0)
call RemoveLocation(udg_SP)
else
endif
endif
endif
endif
endfunction

function Trig_chuansongshi_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction