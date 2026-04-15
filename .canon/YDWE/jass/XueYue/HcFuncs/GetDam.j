#ifndef Hc_GetDamUsed
#define Hc_GetDamUsed
library HcGetDam
<?local Misc_DefenseArmor = tonumber(require('slk').misc.Misc.DefenseArmor)?>
	function XG_GetDam takes real dam,real armor returns real
		local real ret = dam //返回值
		local real b = 0. //护甲减伤百分比
		local real defarm = <?= Misc_DefenseArmor?> //抗性因子 一般为0.06

		if armor >= 0 then
			set b = armor * defarm / ( armor * defarm + 1 ) //正护甲
			set ret = ret / ( 1 - b ) //修正伤害值

			// 1 + 0.06 * 单位护甲
			// damage / (1-b)     73 *0.06=  4.38 -> 68.62
		else
			set b = Pow( 1 - defarm, -armor)
			set ret = ret / ( 2 - b )   //修正伤害值

			// 73*-0.71=-51.83 ->  124.83
			//2 - 0.94 ^ (-单位护甲)
		endif
		return ret //原始伤害
	endfunction
endlibrary
#endif
