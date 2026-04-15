#ifndef HC_String_zd_Used
#define HC_String_zd_Used
$ifdef XG_JAPI
    #include "XueYue\\Japi\\Lua\\String\\String_zd.j"
    XG_ImportFile("XueYue\\Japi\\Lua\\String\\String_zd.lua","XG_JAPI\\Lua\\String\\String_zd.lua")
$else
library HcStringzd
	function Xg_String_zd takes string text,string left,string right returns string
		local integer a = -1
		local integer i = 0
		local string realStr
		local integer LLen = StringLength(left)
		local integer RLen = StringLength(right)
		local integer ALen = StringLength(text) - RLen + 1
		// 123截取45截取 只需要读到 第二个截取的截 缩减循环长度

		loop
			exitwhen i >= ALen
			if a == -1 then
				//支持从左边文本为空 从开头开始取
				set realStr = SubString( text, i , i  + LLen ) //直接判断会出错,返回的null 和 jass的null还有空文本都无法对等，必须经过变量的强制转换
				if realStr == left then
					set a = i + LLen
				endif
			elseif SubString( text, i , i + RLen ) == right then
					return SubString( text, a, i )
			endif
			set i = i + 1
		endloop

		return ""
	endfunction

	function Xg_StringReplace_zd takes string text,string left,string right,string str returns string
		local integer a = -1
		local integer i = 0
		local string realStr
		local integer LLen = StringLength(left)
		local integer RLen = StringLength(right)
		local integer ALen = StringLength(text) - RLen + 1
		loop
			exitwhen i >= ALen
			if a == -1 then
				set realStr = SubString( text, i , i  + LLen ) //直接判断会出错,返回的null 和 jass的null还有空文本都无法对等，必须经过变量的强制转换
				if realStr == left then
					set a = i + LLen
				endif
			elseif SubString( text, i , i + RLen ) == right then
					return SubString( text, 0, a ) +str+ SubString( text, i, ALen + RLen - 1 )
			endif
			set i = i + 1
		endloop

		return ""
	endfunction
	
endlibrary
$endif
#endif
