#ifndef XGDamageAOEIncluded
#define XGDamageAOEIncluded


library XGDamageAOE
globals
		private hashtable htb = InitHashtable()
		private integer Id = 0
		private attacktype array Atp
		private damagetype array Dtp
		private weapontype array Wtp
endglobals
	private function AOE_Filter takes nothing returns boolean
		local unit u = GetFilterUnit()
		if IsUnitType(u, UNIT_TYPE_STRUCTURE) == LoadBoolean(htb,Id,5) /*建筑*/ \
		and IsUnitType(u, UNIT_TYPE_ANCIENT) == LoadBoolean(htb,Id,6)/*古树*/ \
		and IsUnitType(u, UNIT_TYPE_UNDEAD) == LoadBoolean(htb,Id,7)/*不死族*/ \
		and IsUnitType(u, UNIT_TYPE_HERO) == LoadBoolean(htb,Id,8)/*英雄*/ \
		//and IsUnitType(u, UNIT_TYPE_HERO) != LoadBoolean(htb,Id,9)/*单位*/ \
		and IsUnitEnemy(u, Player(LoadInteger(htb,Id,-1))) \
		then
			call UnitDamageTarget(LoadUnitHandle(htb,Id,1), u, LoadReal(htb,Id,2), LoadBoolean(htb,Id,3), LoadBoolean(htb,Id,4),Atp[Id],Dtp[Id],Wtp[Id])
		endif
		set u = null
        return false
	endfunction
	function XG_UnitDamage_AOE takes unit us,location p,real radius,real dam,boolean atk,boolean range,attacktype atp,damagetype dtp,weapontype wtp,boolean build,boolean ancient,boolean undead,boolean hero,boolean unt returns nothing
		local group g = CreateGroup()
		set Id = Id + 1
		call SaveInteger(htb,Id,-1,GetPlayerId(GetOwningPlayer(us)))
		call SaveUnitHandle(htb, Id, 1, us)
		call SaveReal(htb, Id, 2, dam)
		call SaveBoolean(htb, Id, 3, atk)
		call SaveBoolean(htb, Id, 4, range)
		set Atp[Id] = atp
		set Dtp[Id] = dtp
		set Wtp[Id] = wtp
		call SaveBoolean(htb, Id, 5, build)
		call SaveBoolean(htb, Id, 6, ancient)
		call SaveBoolean(htb, Id, 7, undead)
		call SaveBoolean(htb, Id, 8, hero)
		//call SaveBoolean(htb, Id, 9, unt)
		call GroupEnumUnitsInRange( g, GetLocationX(p), GetLocationY(p), radius, function AOE_Filter )
		call DestroyGroup(g)
		set g = null
		set Atp[Id] = null
		set Dtp[Id] = null
		set Wtp[Id] = null
		set Id = Id - 1
	endfunction
endlibrary

#endif
