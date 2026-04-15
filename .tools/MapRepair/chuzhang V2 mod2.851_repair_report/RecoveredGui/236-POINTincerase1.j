//=========================================================================== 
// Trigger: POINTincerase1
//=========================================================================== 
function InitTrig_POINTincerase1 takes nothing returns nothing
set gg_trg_POINTincerase1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_POINTincerase1,EVENT_PLAYER_HERO_LEVEL)
call TriggerAddCondition(gg_trg_POINTincerase1,Condition(function Trig_POINTincerase1_Conditions))
call TriggerAddAction(gg_trg_POINTincerase1,function Trig_POINTincerase1_Actions)
endfunction

function Trig_POINTincerase1_Actions takes nothing returns nothing
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF00恭喜你等级提升\n|r请按键盘|cFFFF0000↑|r增加|cFFFF6600筋骨\n|r请按键盘|cFFFF0000←|r增加|cFFFFFF00身法\n|r请按键盘|cFFFF0000→|r增加|cFF00FFFF内力\n|r请按键盘|cFFFF0000↓|r增加|cFF00FF00体魄|r")
set udg_hero_point[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_hero_point[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
if(Trig_POINTincerase1_Func003C())then
call UnitAddItemByIdSwapped('manh',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_POINTincerase1_Func003Func002C())then
call UnitAddItemByIdSwapped('gomn',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_POINTincerase1_Func003Func002Func002C())then
call UnitAddItemByIdSwapped('tst2',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
endif
endif
endfunction

function Trig_POINTincerase1_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(GetPlayerController(GetOwningPlayer(GetTriggerUnit()))==MAP_CONTROL_USER))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_Save[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
return true
endfunction