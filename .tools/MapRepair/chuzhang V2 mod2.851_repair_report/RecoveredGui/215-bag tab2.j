//=========================================================================== 
// Trigger: bag tab2
//=========================================================================== 
function InitTrig_bag_tab2 takes nothing returns nothing
set gg_trg_bag_tab2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_bag_tab2,EVENT_PLAYER_UNIT_SPELL_CAST)
call TriggerAddAction(gg_trg_bag_tab2,function Trig_bag_tab2_Actions)
endfunction

function Trig_bag_tab2_Actions takes nothing returns nothing
if(Trig_bag_tab2_Func001C())then
call IssueImmediateOrder(GetTriggerUnit(),"stop")
set udg_Nhong=1
loop
exitwhen udg_Nhong>6
set udg_itemA[udg_Nhong]=UnitItemInSlotBJ(udg_ITEM_BAG_A[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_Nhong)
set udg_itemB[udg_Nhong]=UnitItemInSlotBJ(udg_ITEM_BAG_B[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_Nhong)
set udg_itemC[udg_Nhong]=UnitItemInSlotBJ(udg_ITEM_BAG_C[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_Nhong)
set udg_itemD[udg_Nhong]=UnitItemInSlotBJ(udg_ITEM_BAG_D[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_Nhong)
set udg_itemE[udg_Nhong]=UnitItemInSlotBJ(GetTriggerUnit(),udg_Nhong)
call UnitAddItem(udg_ITEM_BAG_E[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_itemA[udg_Nhong])
call UnitAddItem(udg_ITEM_BAG_A[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_itemB[udg_Nhong])
call UnitAddItem(udg_ITEM_BAG_B[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_itemC[udg_Nhong])
call UnitAddItem(udg_ITEM_BAG_C[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_itemD[udg_Nhong])
call UnitAddItem(udg_ITEM_BAG_D[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_itemE[udg_Nhong])
set udg_Nhong=udg_Nhong+1
endloop
set udg_Nhong=1
loop
exitwhen udg_Nhong>6
set udg_itemE[udg_Nhong]=UnitItemInSlotBJ(udg_ITEM_BAG_E[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_Nhong)
call UnitAddItem(GetTriggerUnit(),udg_itemE[udg_Nhong])
set udg_Nhong=udg_Nhong+1
endloop
else
endif
endfunction