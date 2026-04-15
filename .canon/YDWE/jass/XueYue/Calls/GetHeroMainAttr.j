#ifndef XGGetHeroMainAttrtIncluded
#define XGGetHeroMainAttrtIncluded

library XGGetHeroMainAttr initializer Init
<? local slk = require "slk"
	local function GetMainAttr(s)
		local i = 0
		if s == "AGI" then
			i=1
		elseif s == "INT" then
			i=2
		end
		return i 
	end

	local result = ''
	for id, obj in pairs(slk.unit) do
		local firstByte = id:byte()
		if  firstByte >= 65 and firstByte <= 90  then
			result = result.."call SaveInteger(htb,'"..id.."',0,"..GetMainAttr(obj.Primary)..")\r\n"
		end
	end
?>
	globals
		private hashtable htb = InitHashtable()
	endglobals
	function XG_GetHeroMainAttr takes unit u returns integer
		return LoadInteger(htb,GetUnitTypeId(u),0)
	endfunction
	function XG_GetHeroMainAttrById takes integer id returns integer
  	return LoadInteger(htb,id,0)
	endfunction
	function Init takes nothing returns nothing
		<?=result?>
	endfunction
endlibrary

#endif
