#ifndef LibHcEffectSwitch
#define LibHcEffectSwitch

library HcEffectSwitch initializer Init requires XGJAPI
	function XG_EffectSwitch_TurnOff takes player p, boolean b returns boolean
        //报错:需要开启Japi优化
        set XGJAPI_integer[1] = GetPlayerId( p )
		set XGJAPI_bool[2] = b
		return UnitId("XG_EffectSwitch_TurnOff") != 0
	endfunction

	
	
	private function Init takes nothing returns nothing
		call XG_ImportFile("XueYue\\Japi\\Lua\\Effect\\EffectSwitch\\init.lua","XG_JAPI\\Lua\\Effect\\EffectSwitch\\init.lua")
        set XGJAPI_string[1] = "XG_JAPI.Lua.Effect.EffectSwitch"
		//报错:需要开启Japi优化
		call UnitId( "require" )

	endfunction
endlibrary

#endif
