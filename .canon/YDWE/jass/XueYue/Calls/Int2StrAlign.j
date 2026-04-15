#ifndef XGInt2StrAlignIncluded
#define XGInt2StrAlignIncluded

library XGInt2StrAlign
    //整数对齐
    function XG_Int2Str_Align takes integer i,integer n returns string
        local string s = I2S(i)
        local integer l = StringLength(s)
        loop
            set l = l + 1
            exitwhen l > n
            set s =  "0" + s
        endloop
        return s
    endfunction
    
endlibrary

#endif

