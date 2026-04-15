#ifndef XGascii_INCLUDED
#define XGascii_INCLUDED

$ifdef XG_JAPI
    $include "XueYue\\Japi\\Lua\\String\\ascii.j"
$else
    #include "XueYue\\Base.j"
library XGASCII initializer Init requires XGbase
    globals
        hashtable XG_ASCII_HT = InitHashtable()
    endglobals

    function XG_Char2Ascii takes string char returns integer
        if char == "/" then //   / 与 \ 同hash
            return 47
        endif
        return LoadInteger( XG_ASCII_HT, XG_B2I( XG_IsLower_soft(char) ), StringHash( char ) )
    endfunction

    function XG_Ascii2Char takes integer i returns string
        if i == 47 then
            return "/"
        endif

        return LoadStr( XG_ASCII_HT, 0, i )
    endfunction

    private function Init takes nothing returns nothing
        <?
        local function B2I(b)
            return b and 1 or 0
        end

        local xStr = {}
        local count = 0

        local function save_char( s, byte )
            count = count + 1
            local cs = s
            if s == "\"" or s == '\\' then
                cs = "\\" .. cs
            end
            xStr[count] = 
            "call SaveInteger( XG_ASCII_HT,"   .. 
                B2I( s:lower() == s )    ..   ","   ..
                StringHash( s )      ..    ","   ..
                byte     ..   ")" .. 
            '\n' .. 
            "call SaveStr( XG_ASCII_HT, 0," .. 
                byte .. ",\"" .. 
                cs .. "\")"
        end
    
        for i = 128, 247 do
            local s = string.char(i)
            save_char( s, i )
        end
        
        local s
        for i = 1, 126 do
            s = string.char(i)
            if i ~= 26 and i~=24 and i ~= 21 and i ~= 10 and i~=13 then 
                save_char( s, i )
            end

        end

        xStr = table.concat(xStr,'\n')

        ?>
        <?=xStr?>
        //无法表达字符
        call SaveStr( XG_ASCII_HT, 0, 26, "?")
        call SaveStr( XG_ASCII_HT, 0, 24, "?")
        call SaveStr( XG_ASCII_HT, 0, 21, "?")
        //特殊关照字符
        call SaveInteger( XG_ASCII_HT, 0, <?=StringHash("\n")?>, 10)
        call SaveStr( XG_ASCII_HT, 0, 10, "|n")

        call SaveInteger( XG_ASCII_HT, 0, <?=StringHash("\r")?>, 13)
        call SaveStr( XG_ASCII_HT, 0, 13, "|n")
        endfunction

endlibrary


$endif

#endif
