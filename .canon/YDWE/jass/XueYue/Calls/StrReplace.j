#ifndef XGStrReplaceIncluded
#define XGStrReplaceIncluded
$ifdef XG_JAPI
    #include "XueYue\\Japi\\Lua\\String\\StrReplace.j"
    call XG_ImportFile("XueYue\\Japi\\Lua\\String\\StrReplace.lua","XG_JAPI\\Lua\\String\\StrReplace.lua")
$else
library XGStrReplace

//字符串替换 单个
function XG_StrReplace_Single takes string str,integer i,string s returns string
	local integer len = StringLength(str)
	return SubString(str,0,i-1) + s + SubString(str,i,len)
endfunction
//字符串替换 多个
function XG_StrReplace_Multiple takes string str,integer i,integer j,string s returns string
	local integer len = StringLength(str)
	return SubString(str,0,i-1) + s + SubString(str,j,len)
endfunction
//字符串替换 指定字符串 完整字符串 作用字符串 欲替换字符串 次数
function XG_StringReplace takes string text,string os,string ns,integer num returns string
		local integer n = 0
		local integer i = 1
		local integer ALen = StringLength(text)
		local integer oLen = StringLength(os)
        local integer a = StringLength(ns) - oLen //字符偏移修正
		loop
			exitwhen i > ALen
				if SubString( text, i - 1, i - 1 + oLen ) == os then
                    set text = SubString(text, 0, i-1) + ns + SubString(text, i-1+oLen, ALen)
                    set ALen = ALen + a
                    set n = n + 1
                    exitwhen n == num
				endif
			set i = i + 1
		endloop
		return text
	endfunction
endlibrary
$endif
#endif

