//=========================================================================== 
// Trigger: jewel effect1
//=========================================================================== 
function InitTrig_jewel_effect1 takes nothing returns nothing
set gg_trg_jewel_effect1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_jewel_effect1,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_jewel_effect1,Condition(function Trig_jewel_effect1_Conditions))
call TriggerAddAction(gg_trg_jewel_effect1,function Trig_jewel_effect1_Actions)
endfunction

function Trig_jewel_effect1_Actions takes nothing returns nothing
if(Trig_jewel_effect1_Func003C())then
call SetUnitLifeBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],(GetUnitStateSwap(UNIT_STATE_LIFE,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+20.00))
else
endif
if(Trig_jewel_effect1_Func004C())then
call SetUnitLifeBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],(GetUnitStateSwap(UNIT_STATE_LIFE,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+120.00))
else
endif
if(Trig_jewel_effect1_Func005C())then
call SetUnitLifeBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],(GetUnitStateSwap(UNIT_STATE_LIFE,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+50.00))
else
endif
if(Trig_jewel_effect1_Func006C())then
call SetUnitLifeBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],(GetUnitStateSwap(UNIT_STATE_LIFE,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+150.00))
else
endif
if(Trig_jewel_effect1_Func007C())then
call SetUnitLifeBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],(GetUnitStateSwap(UNIT_STATE_LIFE,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+100.00))
else
endif
if(Trig_jewel_effect1_Func008C())then
call SetUnitLifeBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],(GetUnitStateSwap(UNIT_STATE_LIFE,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+80.00))
else
endif
if(Trig_jewel_effect1_Func009C())then
call SetUnitLifeBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],(GetUnitStateSwap(UNIT_STATE_LIFE,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+200.00))
else
endif
if(Trig_jewel_effect1_Func010C())then
call SetUnitManaBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],(GetUnitStateSwap(UNIT_STATE_MANA,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+20.00))
else
endif
if(Trig_jewel_effect1_Func011C())then
call SetUnitLifeBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],(GetUnitStateSwap(UNIT_STATE_LIFE,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+120.00))
else
endif
if(Trig_jewel_effect1_Func012C())then
call SetUnitLifeBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],(GetUnitStateSwap(UNIT_STATE_LIFE,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+120.00))
else
endif
if(Trig_jewel_effect1_Func013C())then
call SetUnitLifeBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],(GetUnitStateSwap(UNIT_STATE_LIFE,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+260.00))
else
endif
if(Trig_jewel_effect1_Func014C())then
call SetUnitLifeBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],(GetUnitStateSwap(UNIT_STATE_LIFE,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+350.00))
else
endif
endfunction

function Trig_jewel_effect1_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(IsUnitType(GetKillingUnitBJ(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction