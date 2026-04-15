#ifndef XGGetItemDataIncluded
#define XGGetItemDataIncluded

#include "XueYue\Base.j"

library XGGetItemData initializer Init requires XGbase
globals
	private hashtable		htb		=	InitHashtable()
	private integer	array	Num
endglobals
//获取物体数据 物体,数据名  -->  需要预载数据
function XG_GetItemData takes integer it,string data returns nothing
	return LoadStr(htb, it, StringHash(data))
endfunction
//预载数据
function XG_PreLoadData takes integer i,string data returns string
	
endfunction

private function Init takes nothing returns nothing
	set Num[0] = 0
	set Num[1] = 0
endfunction

endlibrary

#endif
