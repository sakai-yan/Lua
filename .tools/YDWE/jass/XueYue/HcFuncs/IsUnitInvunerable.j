#ifndef HC_IsUnitInvunerable_Used
#define HC_IsUnitInvunerable_Used

library HcIsUnitInvunerable
	<?
	local process = {}
	local ids = {
		--['Avul'] = true,
		--['BHds'] = true,
		--['Bvul'] = true,
	}
	process['AHds'] = function( objId, obj )
		local lv = obj.levels // 1 | 0
		for i = 1, lv do
			local id = obj['BuffID' .. i]
			if id and id ~= '' then
				ids[id] = true
			end
		end
	end
	process['AIvu'] = process['AHds']
	process['AIvl'] = process['AHds']

	local slk = require 'slk'
	for objId, obj in pairs(slk.ability) do
		local proc = process[obj.code]
		if proc then
			proc(objId, obj)
		end
	end
	ids['Avul'] = nil
	ids['BHds'] = nil
	ids['Bvul'] = nil
	local code = {}
	local i = 0

	for id, _ in pairs(ids) do
		i = i + 1
		code[i] = ("GetUnitAbilityLevel(u, '%s') > 0"):format(id)
	end
	local sCode = table.concat(code, ' or ')
	if sCode == '' then
		sCode = 'false'
	end
	process = nil
	ids = nil
	code = nil
	?>

	function XG_IsUnitInvunerable takes unit u returns boolean
		if GetUnitAbilityLevel(u, 'AIvu') > 0 then // 无敌的
			return true
		endif
		if GetUnitAbilityLevel(u, 'BHds') > 0 then // 神圣护甲BUFF
			return true
		endif
		if GetUnitAbilityLevel(u, 'Bvul') > 0 then // 无敌药水BUFF
			return true
		endif
		// 其他经修改的无敌BUFF
		return <?= sCode ?>
	endfunction
endlibrary
#endif
