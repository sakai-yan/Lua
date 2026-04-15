//=========================================================================== 
// Trigger: bag into
//=========================================================================== 
function InitTrig_bag_into takes nothing returns nothing
set gg_trg_bag_into=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_bag_into,EVENT_PLAYER_UNIT_SPELL_CAST)
call TriggerAddAction(gg_trg_bag_into,function Trig_bag_into_Actions)
endfunction

function Trig_bag_into_Actions takes nothing returns nothing
if(Trig_bag_into_Func001C())then
call UnitAddItemSwapped(GetSpellTargetItem(),udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_bag_into_Func001Func001C())then
call IssueImmediateOrder(udg_ITEM_bag[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],"stop")
call UnitAddItemSwapped(GetSpellTargetItem(),udg_ITEM_bag[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
endif
endfunction