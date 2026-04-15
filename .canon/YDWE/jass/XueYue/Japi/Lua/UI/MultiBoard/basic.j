#ifndef  XG_UI_MultiBoard_BASIC_INCLUDED
#define  XG_UI_MultiBoard_BASIC_INCLUDED

library XGUIMultiBoardBasic initializer Init requires XGJAPI

	//newMultiBoard( mbName, row, col, template )
	function XG_UI_MultiBoard_New takes string mbName, integer row, integer col returns nothing
		set XGJAPI_string[1] = mbName
        set XGJAPI_integer[2] = row
        set XGJAPI_integer[3] = col
    
		call UnitId("XG_UI_MultiBoard_New")
	endfunction

	private function Init takes nothing returns nothing
		call XG_ImportFile("XueYue\\Japi\\Lua\\UI\\MultiBoard\\basic.lua","XG_JAPI\\Lua\\UI\\MultiBoard\\basic.lua")
		//call XG_ImportFile("XueYue\\Japi\\Lua\\UI\\MultiBoard\\fdf.fdf","XG_JAPI\\Lua\\UI\\MultiBoard\\fdf.fdf")
		//call XG_ImportFile("XueYue\\Japi\\Lua\\UI\\MultiBoard\\toc.toc","XG_JAPI\\Lua\\UI\\MultiBoard\\toc.toc")

        set XGJAPI_string[1] = "XG_JAPI.Lua.UI.MultiBoard.basic"
		//报错:需要开启Japi优化
		call UnitId( "require" )
	endfunction
    
endlibrary
#endif
