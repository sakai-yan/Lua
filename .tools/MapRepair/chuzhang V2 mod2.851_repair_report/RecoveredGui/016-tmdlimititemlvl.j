//=========================================================================== 
// Trigger: tmdlimititemlvl
//=========================================================================== 
function InitTrig_tmdlimititemlvl takes nothing returns nothing
set gg_trg_tmdlimititemlvl=CreateTrigger()
 call TriggerRegisterAnyUnitEventBJ(gg_trg_tmdlimititemlvl, EVENT_PLAYER_UNIT_PICKUP_ITEM)
 call TriggerAddCondition(gg_trg_tmdlimititemlvl, Condition(function Trig_tmdlimititemlvl_Conditions))
 call TriggerAddAction(gg_trg_tmdlimititemlvl, function Trig_tmdlimititemlvl_Actions)
endfunction

function Trig_tmdlimititemlvl_Actions takes nothing returns nothing
   if ( Trig_tmdlimititemlvl_Func001C() ) then
       call UnitRemoveItemSwapped(GetManipulatedItem(), GetTriggerUnit())
      call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0, "|cFFFF0000系统信息：|r|cFF00FFFF物品等级限制|r|cFFFFFF00要求等级 "  +I2S(GetItemLevel(GetManipulatedItem() )  )      )
  else
      call DoNothing()
    endif
endfunction

function Trig_tmdlimititemlvl_Conditions takes nothing returns boolean
  if ( not ( IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO) == true ) ) then
      return false
    endif
   return true
endfunction