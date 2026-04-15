library MUYE
    //字符串附加|n
    function MUYE_string_HH takes string q returns string
        return q+"\n"
    endfunction
    //连接字符串Lv3 智能|n
    function MUYE_stringLv3_ZNHH takes string q,string w,string e returns string
        local string ZFC
        if q != "" then
            set ZFC = q + "\n"
        endif
        if w != "" then
            set ZFC = ZFC + w + "\n"
        endif
        if e != "" then
            set ZFC = ZFC + e + "\n"
        endif
        return ZFC
    endfunction
    //立即移动X坐标偏移
    function MUYE_GetUnitX takes real q,real w,real e returns real
        return( q + w * CosBJ(e) )
    endfunction
    //立即移动Y坐标偏移
    function MUYE_GetUnitY takes real q,real w,real e returns real
        return( q + w * SinBJ(e) )
    endfunction
endlibrary