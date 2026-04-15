#ifndef XGS2ID_INCLUDED
#define XGS2ID_INCLUDED

$ifdef XG_JAPI
    #include "XueYue\\Japi\\SIDconv.j"
$else

    $include "XueYue\\MiniSystem\\ascii.j"
library XGS2ID requires XGASCII
    globals
        hashtable XG_SID_HT = InitHashtable()
    endglobals
    
    function XG_S2ID takes string sid returns integer
        local integer i = 1
        local integer len = StringLength(sid)
        local integer id = 0
        local string chr
        loop
            exitwhen i > len
            set chr = SubString(sid, i-1, i )
            set id = id * 256 + XG_Char2Ascii( chr )
            set i = i + 1
        endloop
        
        return id
    endfunction

    function XG_ID2S takes integer iid returns string
        local integer x = iid
        local string str = ""
        loop
            exitwhen x == 0
            set x = ModuloInteger(iid, 256)
            set iid = ( iid - x ) / 256
            set str = XG_Ascii2Char( x ) + str
        endloop

        return str
    endfunction

    
endlibrary


$endif


#endif

