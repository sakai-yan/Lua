
library XGS2ID requires XGJAPI
    
    function XG_S2ID takes string sid returns integer
        set XGJAPI_string[1] = sid
        call UnitId( "XG_S2ID" )
        return XGJAPI_integer[0]
    endfunction

    function XG_ID2S takes integer iid returns string
        set XGJAPI_integer[1] = iid
        call UnitId( "XG_ID2S" )
        return XGJAPI_string[0]
    endfunction

endlibrary

