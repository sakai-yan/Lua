#ifndef LibGetObjectProperty
#define LibGetObjectProperty

library HcGetObjectProperty initializer Init requires XGJAPI

	function XG_GetObjectStringByIID takes string obj_type, integer obj_code, string obj_property returns string
		set XGJAPI_string[1] = obj_type
		set XGJAPI_integer[2] = obj_code
		set XGJAPI_string[3] = obj_property
		call UnitId("XG_GetObjectStringByIID")
		return XGJAPI_string[0]
	endfunction

	function XG_GetObjectStringBySID takes string obj_type, string obj_code, string obj_property returns string
		set XGJAPI_string[1] = obj_type
		set XGJAPI_string[2] = obj_code
		set XGJAPI_string[3] = obj_property
		call UnitId("XG_GetObjectStringBySID")
		return XGJAPI_string[0]
	endfunction
	
	private function Init takes nothing returns nothing
		call XG_ImportFile("XueYue\\Japi\\Lua\\Object\\GetObjectProperty.lua","XG_JAPI\\Lua\\Object\\GetObjectProperty.lua")
        set XGJAPI_string[1] = "XG_JAPI.Lua.Object.GetObjectProperty"
		//报错:需要开启Japi优化
		call UnitId( "require" )
	endfunction
endlibrary

#endif
