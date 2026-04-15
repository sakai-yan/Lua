#ifndef XGIntHexIncluded
#define XGIntHexIncluded
$ifdef XG_JAPI
    #include "XueYue\\Japi\\IntHex.j"
    XG_ImportFile("XueYue\\Japi\\IntHex.lua","XG_JAPI\\IntHex.lua")
$else
library XGIntHex initializer Init
<?
local s = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ!\"#$%&'()*+,.:;<=>?@[\\]^_`{|}~abcdefghijklmnopqrstuvwxyz"  -- /和 \同哈希值  大小写字母同哈希值  弃用哈希表 改用遍历 /仍不能用
local function zy(str)
    if str=="\"" or str == "\\"  then return "\\"..str end
    return str
end
?>
//负号被舍弃了。保留原意作为符号 空格也因为显示原因舍弃
    globals
       // private hashtable htb = InitHashtable()
        private string  array   encode
        //private string  array   decode
        private integer maxHex = <?=#s?>
    endglobals

    private function s_i takes string s returns integer
        local integer i = 0
        loop
            if s == encode [i] then
                return i
            endif
            set i = i + 1
            exitwhen i > maxHex
        endloop
        return 0
    endfunction

    function XG_IntHex_Encode takes integer iInt returns string
        local string sign = "" //符号
        local string rtn = ""
        local integer res = 0
        local integer mod = 0

        if iInt < 0 then
            set sign = "-"
            set iInt = iInt * -1
        endif

        if iInt == 0 then
            set rtn = encode[mod]
        endif

        loop
            exitwhen iInt == 0
            set res = iInt / maxHex //结果
            set mod = iInt - res * maxHex //余数
            set iInt = res
            set rtn = encode[mod] + rtn
        endloop

        return sign + rtn
    endfunction

    function XG_IntHex_Decode takes string iStr returns integer
        local integer len = StringLength(iStr)
        local string char = ""
        local integer result = 0
        local integer i = 0
        local integer fix = 1

        if SubString(iStr,0,1) == "-" then
            set iStr = SubString(iStr,1,len)
            set len = len - 1
            set fix = -1
        endif

        loop
            exitwhen i > len-1
            set char = SubString(iStr,len-1-i,len-i)
            set result = result + s_i(char) * R2I(  Pow( maxHex, i   ) )
            
            set i = i + 1
        endloop
        return result * fix
    endfunction
	private function Init takes nothing returns nothing
        <? for i=1,#s do ?>
        set encode[<?=i-1?>] = "<?= zy(s:sub(i,i)) ?>"
        <?end?>
       
    endfunction

    
endlibrary

$endif
#endif

