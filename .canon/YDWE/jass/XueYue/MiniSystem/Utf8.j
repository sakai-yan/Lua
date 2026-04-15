#ifndef XGsubUtf8_INCLUDED
#define XGsubUtf8_INCLUDED

$ifdef XG_JAPI
    $include "XueYue\\Japi\\Lua\\String\\UTF8.j"
$else

$include "XueYue\\MiniSystem\\ascii.j"
library XGUTF8 requires XGASCII
    
    function XG_SubUTF8 takes string str, integer pos_start, integer pos_end returns string
        local integer cur = 1
        local integer l = StringLength(str)
        //已取出字符数
        local integer taken = pos_end - pos_start + 1
        //当前字符ascii
        local integer curByte
        //当前字符位置
        local integer curPos = 0
        //返回值
        local string ret = ""
        //字符占位
        local integer byteCount = 0

        loop
            exitwhen taken < 1 or cur > l

            set curByte = XG_Char2Ascii( SubString( str, cur-1, cur ) )

            if curByte > 0 and curByte <= 127 then
                set byteCount = 1
            elseif curByte >= 192 and curByte < 223 then
                set byteCount = 2
            elseif curByte >= 224 and curByte < 239 then
                set byteCount = 3
            elseif curByte >= 240 and curByte <= 247 then
                set byteCount = 4
            endif

            set curPos = curPos + 1

            if  curPos >= pos_start  then
                set taken = taken - 1
                set ret = ret + SubString(str, cur-1, cur+byteCount-1)
            endif

            set cur = cur + byteCount
        endloop

        return ret
    endfunction

    function XG_LenUTF8 takes string str returns integer
        local integer cur = 1
        local integer l = StringLength(str)

        //当前字符ascii
        local integer curByte
        //字符占位
        local integer byteCount = 0

        //返回值
        local integer ret = 0

        loop
            exitwhen cur > l

            set curByte = XG_Char2Ascii( SubString( str, cur-1, cur ) )

            if curByte > 0 and curByte <= 127 then
                set byteCount = 1
            elseif curByte >= 192 and curByte < 223 then
                set byteCount = 2
            elseif curByte >= 224 and curByte < 239 then
                set byteCount = 3
            elseif curByte >= 240 and curByte <= 247 then
                set byteCount = 4
            endif

            set ret = ret + 1

            set cur = cur + byteCount
        endloop

        return ret
    endfunction


endlibrary


$endif


#endif

