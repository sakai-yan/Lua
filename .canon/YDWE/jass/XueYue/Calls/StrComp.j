#ifndef XGStrCompIncluded
#define XGStrompIncluded

library HCStrComp

	//字符串补全 对str进行补充到长度为tarLen 使用s从前面补充 是否严格限制长度
	function XG_StrComp takes string str, integer tarLen, string s, boolean begin, boolean strict  returns string
		local integer lenStr = StringLength(str)
		local integer lenS = StringLength(s)

		if begin then
			loop
				exitwhen lenStr >= tarLen
				set str = s + str
				set lenStr = lenStr + lenS
			endloop
			if strict then

				if lenStr > tarLen then
					set str = SubString( str, 1, tarLen+1 )
				endif
	
			endif

		else
			loop
				exitwhen lenStr >= tarLen
				set str = str + s
				set lenStr = lenStr + lenS
			endloop
			if strict then

				if lenStr > tarLen then
					set str = SubString( str, 0, tarLen )
				endif
	
			endif

		endif

		
		
		return str

	endfunction

endlibrary

#endif
