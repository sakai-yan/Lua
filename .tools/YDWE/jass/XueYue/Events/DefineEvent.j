#ifndef XGDefineEventIncluded
#define XGDefineEventIncluded

#include "XueYue\Base.j"

library XGDefineEvent requires XGbase
	globals
		private hashtable htb = InitHashtable()
		private hashtable htb2 = InitHashtable()
		private integer ssi = 0

		//自定义事件传参
		private integer queue = 0
		private hashtable params = InitHashtable()
	endglobals

	#define xg_define_param(ftype, htype, type) YDNL \
	function XG_DefineEvent_SetParam_ ## ftype takes integer idx, type p returns nothing YDNL \
		call Save ## htype(params, queue + 1, idx, p)	YDNL \
	endfunction	YDNL \
	function XG_DefineEvent_GetParam_ ## ftype takes integer idx returns type	YDNL \
		return Load ## htype(params, queue, idx)	YDNL \
	endfunction	YDNL

	xg_define_param( INT, Integer, integer )
	xg_define_param( BOOL, Boolean, boolean )
	xg_define_param( REAL, Real, real )
	xg_define_param( STRING, Str, string )

	xg_define_param( UNIT, UnitHandle, unit )
	xg_define_param( ITEM, ItemHandle, item )
	xg_define_param( PLAYER, PlayerHandle, player )
	xg_define_param( LOCATION, LocationHandle, location )

	#undef xg_define_param
	
	private function getNode takes integer e, integer f returns integer
		local integer idx =  R2I( LoadReal( htb2, e, f ) )
		if idx == 0 then
			set ssi = ssi + 1
			call SaveReal( htb2, e, f, I2R(ssi) )
			return ssi
		endif
		return idx
	endfunction

	function Xg_RegDefineEvent takes trigger trg, string s returns boolean
		local integer sha = StringHash(s)
		local integer i = LoadInteger( htb, sha, 0 ) + 1
		call SaveInteger( htb, sha, 0, i )
		call SaveTriggerHandle( htb, sha, i, trg )
		return true
	endfunction
	
	function Xg_RegDefineEvent_Int takes trigger trg, integer e, integer f returns boolean
		local integer node = getNode(e, f)
		local integer idxCount = LoadInteger(htb2, node, 0)  + 1

		call SaveInteger(htb2, node, 0, idxCount)
		call SaveTriggerHandle(htb2, node, idxCount, trg)
		return true
	endfunction

	function Xg_ExecuteTrigger takes string s returns nothing
		local integer sha = StringHash(s)
		local integer all = LoadInteger( htb, sha, 0)
		local integer i = 1
		local trigger trg
		set queue = queue + 1
		loop
			exitwhen i > all
			set trg = LoadTriggerHandle( htb, sha, i)
			if trg != null then
				call ConditionalTriggerExecute(trg)
			endif
			set i = i + 1
		endloop
		call FlushChildHashtable(params, queue)
		set queue = queue - 1
		set trg = null
	endfunction
	
	function Xg_ExecuteTrigger_Int takes integer e, integer f returns nothing
		local integer node = getNode(e, f)
		local integer all = LoadInteger( htb2, node, 0)
		local integer idx = 1
		local trigger trg
		set queue = queue + 1
		loop
			exitwhen idx > all
			set trg = LoadTriggerHandle(htb2, node, idx)
			if trg != null then
				call ConditionalTriggerExecute( trg )
			endif
			set idx = idx + 1
		endloop
		call FlushChildHashtable(params, queue)
		set queue = queue - 1
		set trg = null
	endfunction

endlibrary

#endif
