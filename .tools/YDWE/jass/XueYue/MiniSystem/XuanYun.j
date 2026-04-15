#ifndef Hc_XuanYun_Used
#define Hc_XuanYun_Used


#include "XueYue\Base.j"
#include "XueYue\Define\XuanYun.Cons" /* 载入常量 */

library HcXuanYun requires XGbase

	function Xg_XuanYun_Init takes integer u,integer sk,integer buffcode returns nothing
		call SaveInteger(Xg_htb,XuanYun_System,XuanYun_Vest,u)
		call SaveInteger( Xg_htb, XuanYun_System, XuanYun_Skill, sk)
		call SaveInteger( Xg_htb, XuanYun_System, XuanYun_BUFF, buffcode )
	endfunction
	
	private function lpCallBack_XuanYun_timer takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local integer key = GetHandleId(t)
		local unit u = LoadUnitHandle(Xg_htb, key, XuanYun_Unit)
		local integer ukey = GetHandleId(u)

		local integer timeout = LoadInteger(Xg_htb, ukey, XuanYun_Time) - 1
		local integer buffcode = LoadInteger(Xg_htb, XuanYun_System, XuanYun_BUFF)

		if timeout > 0 then
			call SaveInteger(Xg_htb, ukey, XuanYun_Time, timeout)

			set t = null
			set u = null
			return
		endif

		if GetUnitAbilityLevel(u, buffcode) > 0 then
			call UnitRemoveAbility(u, buffcode)
		endif

		call RemoveSavedInteger(Xg_htb, ukey, XuanYun_Time)

		call FlushChildHashtable(Xg_htb, key)
		call PauseTimer(t)
		call DestroyTimer(t)

		set u = null
		set t = null
	endfunction

	private function lpCallBack_del_unit_timer takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local integer key = GetHandleId(t)
		local unit u = LoadUnitHandle( Xg_htb, key, 0 )

		call FlushChildHashtable( Xg_htb, key )
		call DestroyTimer(t)

		call RemoveSavedHandle(Xg_htb, XuanYun_System, LoadInteger(Xg_htb, key, 1) )
		call RemoveUnit( u )

		set t = null
		set u = null
	endfunction

	private function del_unit_timer takes unit u returns nothing
		local timer t = CreateTimer()
		
		call SaveUnitHandle( Xg_htb, GetHandleId(t), 0, u )
		call SaveInteger( Xg_htb, GetHandleId(t), 1, GetPlayerId(GetOwningPlayer(u))  )
		call TimerStart( t, 0.5, false, function lpCallBack_del_unit_timer )
		
		set t = null
	endfunction

	function XG_XuanYunUnit_New takes unit u, real time, boolean bOverlay returns nothing
		local unit us
		local integer lasttime = 0
		local timer t
		local integer ukey = GetHandleId(u)

		if bOverlay then /*叠加*/
			set lasttime = LoadInteger(Xg_htb, ukey, XuanYun_Time)
		endif

		//设置眩晕时间
		call SaveInteger(Xg_htb, ukey, XuanYun_Time, lasttime + R2I(time*100) )

		set t = LoadTimerHandle( Xg_htb, ukey, XuanYun_Timer )

		//检测未结束的眩晕计时器
		if t != null then
			//检查BUFF是否仍存在
			if GetUnitAbilityLevel( u, LoadInteger( Xg_htb, XuanYun_System, XuanYun_BUFF ) ) > 0 then
				set t = null
				return
			endif
		endif

		set us = LoadUnitHandle( Xg_htb, XuanYun_System, GetPlayerId(GetOwningPlayer(u)) )

		if us == null then
			set  us = CreateUnit( \
				GetOwningPlayer(u), \
				LoadInteger( Xg_htb, XuanYun_System, XuanYun_Vest ), \
				GetUnitX(u), \
				GetUnitY(u), \
				0. \
			)
			call ShowUnit( us , false )
			call UnitAddAbility( us, LoadInteger( Xg_htb, XuanYun_System, XuanYun_Skill ) )

			call SaveUnitHandle( Xg_htb, XuanYun_System, GetPlayerId(GetOwningPlayer(u)), us )
			call del_unit_timer( us )

		endif

		call IssueTargetOrder( us, "thunderbolt", u )

		if t == null then
			set  t = CreateTimer()
			call SaveTimerHandle(Xg_htb, ukey, XuanYun_Timer, t)
		endif

		call SaveUnitHandle( Xg_htb, GetHandleId(t), XuanYun_Unit, u )

		call TimerStart( t, 0.01, true, function lpCallBack_XuanYun_timer )

		set  us = null
		set  t = null

	endfunction
endlibrary
#endif
