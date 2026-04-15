#ifndef Hc_PauseUnit_Used
#define Hc_PauseUnit_Used
	#include "XueYue\Define\PauseUnit.Cons" /* 载入常量 */
	#include "XueYue\Base.j"
library HcPauseUnit requires XGbase

	private function timer_callback takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local integer key = GetHandleId(t)
		local unit u = LoadUnitHandle(Xg_htb, key, PauseUnit_Unit)
		local integer ukey = GetHandleId(u)
		local integer timeout = LoadInteger(Xg_htb, ukey, PauseUnit_Time) - 1

		call SaveInteger(Xg_htb, ukey, PauseUnit_Time, timeout)

		if timeout <= 0 or IsUnitPaused(u) == false then
			call RemoveSavedInteger( Xg_htb, ukey, PauseUnit_Time )
			call PauseUnit(u, false)
			call FlushChildHashtable(Xg_htb, key)
			call PauseTimer(t)
			call DestroyTimer(t)
		endif
		set u = null
		set t = null
	endfunction

	function Xg_PauseUnitWithTimer takes unit u, real time returns nothing
		local timer t
		local integer uid = GetHandleId(u)
		if time > LoadInteger(Xg_htb, uid, PauseUnit_Time) then
			call SaveInteger(Xg_htb, uid, PauseUnit_Time, R2I(time * 100) )
		endif
		if LoadTimerHandle(Xg_htb, uid, PauseUnit_Time) == null then
			call PauseUnit(u, true)
			set t = CreateTimer()
			call SaveTimerHandle(Xg_htb, uid, PauseUnit_Timer,t)
			call SaveUnitHandle(Xg_htb, GetHandleId(t), PauseUnit_Unit,u)
			call TimerStart( t, 0.01, true, function timer_callback)
			set t = null
		endif
	endfunction

	function XG_PauseUnitWithTimer_New takes unit u, real time, boolean b returns nothing
		local timer t
		local integer OldTime = 0
		local integer uid = GetHandleId(u)
		if b then/*叠加*/
			set OldTime = LoadInteger(Xg_htb, uid, PauseUnit_Time)
		endif
		call SaveInteger(Xg_htb, uid, PauseUnit_Time, OldTime + R2I(time * 100) )
		if LoadTimerHandle(Xg_htb, uid, PauseUnit_Time)==null then
			call PauseUnit(u,true)
			set t=CreateTimer()
			call SaveTimerHandle(Xg_htb, uid, PauseUnit_Timer, t)
			call SaveUnitHandle(Xg_htb, GetHandleId(t), PauseUnit_Unit, u)
			call TimerStart(t,0.01,true,function timer_callback)
			set t=null
		endif
	endfunction
endlibrary
#endif
