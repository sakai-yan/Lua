#ifndef XGTimerPauseExIncluded
#define XGTimerPauseExIncluded


library XGTimerPauseEx
globals
		hashtable htb = InitHashtable()
endglobals
	private function Timer_Action takes nothing returns nothing
		local integer h = GetHandleId(GetExpiredTimer())
		local real r = LoadReal(htb, h, 1)
			call ResumeTimer(LoadTimerHandle(htb,h,0))
			call FlushChildHashtable(htb,h)
			call DestroyTimer(GetExpiredTimer())
	endfunction
	function XG_TimerPause takes timer ts,real a returns nothing
		local timer t = LoadTimerHandle(htb, GetHandleId(ts),0)
		local integer h = GetHandleId(t)
		if ts != null then
			if t == null then
				set t = CreateTimer()
				set h = GetHandleId(t)
			elseif LoadReal(htb,h,1) <= 0.0 then
				call ResumeTimer(ts)
				call FlushChildHashtable(htb,h)
				call DestroyTimer(t)
				set t = null
				return
			endif
			call SaveReal(htb, h, 1, a)
			call SaveTimerHandle(htb,GetHandleId(ts),0, t)
			call SaveTimerHandle(htb,h,0, ts)
			call PauseTimer(ts)
			call TimerStart( t, a, false, function Timer_Action )
		endif
		set t = null
	endfunction
endlibrary

#endif
