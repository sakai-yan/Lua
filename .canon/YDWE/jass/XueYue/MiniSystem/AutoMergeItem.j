#ifndef Hc_AutoMergeItem_Used
#define Hc_AutoMergeItem_Used

#include "XueYue\Base.j"
$include "XueYue\\SystemLibs\\GarbageCollect\\init.j"
library HcAutoMergeItem requires XGbase, userdataGC
#define ItemAutoMerge 1134596174 /*Hash: 物品自动叠加*/
	globals
		private itemtype ItemType
		private trigger trg=null
	endglobals
	private function MergeItem_Act takes nothing returns nothing
		local item it = GetManipulatedItem()
		local unit u
		local item soltIt
		local itemtype itp 

		local integer i = 0
		local integer a = GetItemCharges(it)
		local integer j = 0
		local integer max
		local integer num

		//使用次数为0的物品无法叠加
		if a <= 0 then
			set it = null
			return
		endif

		set u = GetManipulatingUnit()
		set itp = GetItemType(it)
		//自定义的指定叠加上限 无视类型
		set max = LoadInteger(Xg_htb, ItemAutoMerge, GetItemTypeId(it))

		//非指定的物品类型无法叠加
		//非特指叠加上限的物品无法叠加
		if itp != ItemType and itp != ITEM_TYPE_ANY and max <= 0 then
			set itp = null
			set it = null
			set u = null
			return
		endif

		loop
			set soltIt = UnitItemInSlot(u,i)
			//同类型 但非 同一物品
			if GetItemTypeId(it) == GetItemTypeId(soltIt) and it != soltIt then
				set num = GetItemCharges(soltIt)
				//针对未指定上限的物品，有多少叠多少
				if max == 0 then
					call SetItemCharges( soltIt, num + a )
					call gc_item( it )
					call RemoveItem( it )
					exitwhen true
				else
					///针对指定了上限的物品，还有多少叠加空间
					set j = max - num
					if j > 0 then
						//减去叠加空间后 还有剩余使用次数
						if a > j then
							call SetItemCharges( soltIt, num + j )
							call SetItemCharges( it, a-j ) //叠加且有剩余
						else
							call SetItemCharges( soltIt, num + a )
							call gc_item( it )
							call RemoveItem( it ) //拾取物品无使用次数已分配完
							exitwhen true
						endif
					endif
				endif
			endif
			set i = i + 1
			exitwhen i > 5
		endloop

		set itp = null
		set it = null
		set soltIt = null
		set u = null
	endfunction

	function HC_SetMergeMaxVal takes integer itemcode,integer max returns nothing
		call SaveInteger(Xg_htb, ItemAutoMerge, itemcode, max)
	endfunction

	function HC_AutoMergeItem takes itemtype itp returns nothing
		local integer i = 0
		set ItemType = itp
		if trg != null then
			return
		endif

		set trg = CreateTrigger()
		call TriggerAddAction(trg, function MergeItem_Act)
		loop
			call TriggerRegisterPlayerUnitEvent(trg, Player(i), EVENT_PLAYER_UNIT_PICKUP_ITEM, null)
			set i = i + 1
			exitwhen i >= 15
		endloop
		
		
	endfunction
endlibrary
#endif
