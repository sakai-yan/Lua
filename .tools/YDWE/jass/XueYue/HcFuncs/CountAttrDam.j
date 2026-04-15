#ifndef HC_CountAttrDam_Used
#define HC_CountAttrDam_Used
library HCCountAttrDam
	function Xg_CountAttrDam takes unit u, boolean s, real rStr, boolean a, real rAgi, boolean i, real rInt returns real
		return GetHeroStr(u,s)*rStr + GetHeroAgi(u,a)*rAgi + GetHeroInt(u,i)*rInt
	endfunction
endlibrary
#endif
