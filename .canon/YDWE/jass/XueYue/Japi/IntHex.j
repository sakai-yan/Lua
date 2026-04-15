library XGIntHex initializer Init requires XGJAPI

    function XG_IntHex_Encode takes integer iInt returns string
        set XGJAPI_integer[1] = iInt
		call UnitId("XG_IntHex_Encode")
        return XGJAPI_string[0]
    endfunction
    function XG_IntHex_Decode takes string iStr returns integer
        set XGJAPI_string[1] = iStr
		call UnitId("XG_IntHex_Decode")
        return XGJAPI_integer[0]
    endfunction
	private function Init takes nothing returns nothing
        set XGJAPI_string[1] = "XG_JAPI.IntHex"
		call UnitId( "require" )
    endfunction

    
endlibrary

