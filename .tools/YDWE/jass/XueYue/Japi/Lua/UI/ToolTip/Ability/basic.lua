---@diagnostic disable: param-type-mismatch
local XGJAPI = XGJAPI
local japi = require 'jass.japi'
local cj = require 'jass.common'
local msg = require 'jass.message'
local slk = require 'jass.slk'

local DzCreateFrameByTagName = japi.DzCreateFrameByTagName
local DzFrameSetSize = japi.DzFrameSetSize
local DzFrameSetTexture = japi.DzFrameSetTexture
local DzFrameSetText = japi.DzFrameSetText
local DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameShow = japi.DzFrameShow
local DzFrameGetItemBarButton = japi.DzFrameGetItemBarButton
local DzFrameGetCommandBarButton = japi.DzFrameGetCommandBarButton
local DzFrameSetScriptByCode = japi.DzFrameSetScriptByCode
local DzGetGameUI = japi.DzGetGameUI
local DzFrameClearAllPoints = japi.DzFrameClearAllPoints
local DzGetTriggerUIEventFrame = japi.DzGetTriggerUIEventFrame
local DzGetTriggerUIEventPlayer = japi.DzGetTriggerUIEventPlayer
local DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment

local UnitItemInSlot = cj.UnitItemInSlot
local GetItemName = cj.GetItemName
local GetItemTypeId = cj.GetItemTypeId
local GetUnitAbilityLevel = cj.GetUnitAbilityLevel

local EXGetAbilityDataString = japi.EXGetAbilityDataString
local EXGetAbilityDataInteger = japi.EXGetAbilityDataInteger
local EXGetUnitAbility = japi.EXGetUnitAbility
local GetPlayerTechCount = cj.GetPlayerTechCount
local GetObjectName = cj.GetObjectName
local GetOwningPlayer = cj.GetOwningPlayer
local GetLocalPlayer = cj.GetLocalPlayer
local GetUnitLevel = cj.GetUnitLevel
local GetHeroStr = cj.GetHeroStr
local GetHeroAgi = cj.GetHeroAgi
local GetHeroInt = cj.GetHeroInt
local GetUnitTypeId = cj.GetUnitTypeId
local TriggerEvaluate = cj.TriggerEvaluate


local slk_item = slk.item
local slk_ability = slk.ability
local slk_unit = slk.unit
local slk_upgrade = slk.upgrade

local type = type
local string_gsub = string.gsub
local string_split = string.split
local string_sub = string.sub
local table_concat = table.concat
local string_match = string.match
local string_gmatch = string.gmatch
local string_char = string.char
local string_format = string.format
local string_find = string.find
local math_type = math.type

local getSelectionUnit = msg.selection
local msg_button = msg.button
local sid = base.sid
local iid = base.iid
local print = print

local gameui = DzGetGameUI()
local vanillaToolTip = japi.DzFrameGetTooltip()

local ui = {}
local map_frameToSoltId = {}
local map_abilcodeToUpdateFunc = {}

local trigger_Show
local trigger_Hide
local htb

local isFormulaSupported = false	--是否支持公式
local isFormulaDisplaySupported = true	--是否可以按shift显示公式
local isUseUnitAttributeLib = false	--是否使用单位属性库
local isShowUpgradeEquivalent = false	--是否显示科技等价物[单位]
local isShowIcon = false	--是否显示技能图标

local isReplaceItemTooltip = false	--是否替换出售物品tooltip
local isReplaceUpgradeTooltip = false	--是否替换科技tooltip
local isReplaceTrainTooltip = false	--是否替换训练单位tooltip
local isReplaceBuildTooltip = false	--是否替换建造列表
local isReplaceBldUpgTooltip = false	--是否替换建筑升级tooltip
local isReplaceSellUnitTooltip = false	--是否替换出售单位tooltip
local isShowTimeUpgrade = false	--是否显示科研/训练时间 [起这个名字因为以后可能拆分为两个]

local isShowHotkeyUI = false	--是否显示技能快捷键

local isShiftPressed = false	--是否按住shift
local isTooltipVisible = false	--是否已显示tooltip

local frameFocus = 0

local lib_attribute = nil -- 第三方库: 单位属性库

local abils = {
	--[[
	[unit][abilcode] =
	{
		name = '技能名称',
		desc = '技能描述',
		nameFormat = '技能名称格式',
	}
	]]
}
local math_floor = math.floor
local math_ceil = math.ceil
local __env__ = {
	tonumber = function ( str )
		if not str or str == '' then
			return 0
		end
		--向上取整
		if str > 0 then
			return math_ceil(str) // 1 << 0
		else
			return math_floor(str) // 1 << 0
		end
		--if v == str+0 then
		--	return v
		--end
		--return string_format('%.2f', str) + 0
	end
}

--[[
		name = 1
		lv>1 = 2
		hotkey = 4
	]]
local tNameFormat = {
	--@name@ = 技能名称
	--@lv@ = 技能等级
	--@lvmax@ = 技能最大等级
	--@hotkey = 技能快捷键


	[1 + 2 + 4] = '@name@ (|cffffcc00@hotkey@|r) - [|cffffcc00等级 @lv@|r]',
	[1 + 4] = '@name@ (|cffffcc00@hotkey@|r)',
	[1 + 2] = '@name@ - [|cffffcc00等级 @lv@|r]',
	[1] = '@name@',
}


--[[ 公式格式说明规范
***************************************
技能:粉碎

对目标造成[H]点伤害，并使目标减速[D]秒。


H=攻击力+等级*[10 / 12 / 15 / 20 / 30]
D=等级*0.5

**************************************
功能接口:
	设置技能描述/名称
	设置公式关联属性 (法强、暴击率) 依赖单位属性系统

]]

---@return string,table
local function _descToTextAndFormula( desc )
	local text = {}
	local tFormula = {}
	local lineCount = 0

	local formulaCount = 0
	desc = desc:gsub('\r', ''):gsub('|n', '\n')

	--保留text中的换行符
	local line
	while true do
		local pos = desc:find('\n',nil,true)
		if pos then
			line = string_sub(desc, 1, pos-1)
			desc = string_sub(desc, pos + 1)
		else
			line = desc
		end

		if line:find('^%s*.-=') then
			local name, formula = string_match(line, '(.-)%s*=%s*(.+)')
			formulaCount = formulaCount + 1
			tFormula[formulaCount] = name
			tFormula[name] = formula
        else
            lineCount = lineCount + 1
            text[lineCount] = line
		end

		if not pos then
			break
		end
	end

	tFormula[0] = formulaCount

	return table_concat(text, '\n'), tFormula
end

local japi_GetUnitState = japi.GetUnitState
local kState_maxAttack = cj.ConvertUnitState(0x15)
local kState_Armor = cj.ConvertUnitState(0x20)
local kState_Life = cj.UNIT_STATE_LIFE
local kState_maxLife = cj.UNIT_STATE_MAX_LIFE
local kState_Mana = cj.UNIT_STATE_MANA
local kState_maxMana = cj.UNIT_STATE_MAX_MANA

local formulaNameToValue = {
	['攻击'] = function ( params )
		local v = japi_GetUnitState(params.u, kState_maxAttack)
		return string_format('%.2f', v ) + 0.00
	end,
	['护甲'] = function ( params )
		local v = japi_GetUnitState(params.u, kState_Armor)
		return string_format('%.2f', v ) + 0.00
	end,
	['生命值'] = function ( params )
		local v = japi_GetUnitState(params.u, kState_Life)
		return string_format('%.2f', v ) + 0.00
	end,
	['魔法值'] = function ( params )
		local v = japi_GetUnitState(params.u, kState_Mana)
		return string_format('%.2f', v ) + 0.00
	end,
	['最大生命值'] = function ( params )
		local v = japi_GetUnitState(params.u, kState_maxLife)
		return string_format('%.2f', v ) + 0.00
	end,
	['最大魔法值'] = function ( params )
		local v = japi_GetUnitState(params.u, kState_maxMana)
		return string_format('%.2f', v ) + 0.00
	end,
	['技能等级'] = function ( params )
		return params.lv
	end,
	['等级'] = function ( params )
		return GetUnitLevel(params.u)
	end,
	['力量'] = function ( params )
		if not params.isHero then
			return 0
		end
		return GetHeroStr(params.u, true)
	end,
	['敏捷'] = function ( params )
		if not params.isHero then
			return 0
		end
		return GetHeroAgi(params.u, true)
	end,
	['智力'] = function ( params )
		if not params.isHero then
			return 0
		end
		return GetHeroInt(params.u, true)
	end,

}

---@param desc string
---@param u any
---@param abilcode any
---@param lv int
---@return string,boolean --返回描述/是否是公式
local function _DescFormula( desc, u, abilcode, lv )
	local unitTypeId = GetUnitTypeId(u)
	local c = sid(unitTypeId):byte(1,1)
	local params = {
		u = u,
		abilcode = abilcode,
		lv = lv,
		unitTypeId = unitTypeId,
		isHero =  c >= 0x41 and c <= 0x5A, --判断byte是否为大写字母，大写则为英雄
	}

	local text, tFormula  = _descToTextAndFormula(desc)
	if tFormula[0] == 0 then
		return text, false
	end

    local bIsFirstError = true
	for _, code in ipairs(tFormula) do
		local start1, end1 = string_find(text, '['..code..']', 1, true)

		if not start1 then
			goto next_formula
		end
       local formula = tFormula[code]
        --攻击 + 10
        local start2, end2
        while true do
            start2, end2 = string_find(formula, '[^%s%+%-%*/%d%.%[%]]+', end2 and end2+1 or 1)
            if not start2 then
                break
            end
            local name = string_sub(formula, start2, end2)
			--print(formula, name)
            if formulaNameToValue[name] then
                local v = formulaNameToValue[name](params, name)
                formula = string_sub(formula, 1, start2-1) .. v .. string_sub(formula, end2+1)
				end2 = end2 - #name + 1
				-- 属性XX + 属性YY 替换为 1.0 + 属性YY 后需要重新计算end2
            end

        end
        local fn = load( "return tonumber("  .. formula .. ")" ,nil,nil, __env__ )
        if  not fn then
            end2 = nil
            -- 根据等级从列表[ 1 / 1 / 2 ]中选择一个值
            while true do
                start2, end2 = string_find(formula, '%[.-%]', end2 and end2+1 or 1)
                if not start2 then
                    break
                end
                local list = string_sub(formula, start2+1, end2-1)
                local v = string_split(list, '/')[lv>0 and lv or 1]
                if not v then
                    break
                end
                formula = string_sub(formula, 1, start2-1) .. v:match('[^%s]+') .. string_sub(formula, end2+1)
            end
            fn = load( "return tonumber("  .. formula .. ")" ,nil,nil, __env__ )
        end

        if fn then
            local v = fn(params)
            text = text:sub(1, start1-1) .. v .. text:sub(end1+1)
        else
            --if bIsFirstError then
            --    bIsFirstError = false
            --    text = text .. '\n'
            --end
            text = text .. '\n' .. code .. '=' .. formula
        end

		::next_formula::
	end
	--print(text)

	return text, true
end

local function getValueFromFormula( desc, u, abilcode, lv , returnCode )
	local formula = desc:gsub('|n','\n'):gsub('|[cC]%w%w%w%w%w%w%w%w',''):gsub('|[rR]', ''):match(returnCode .. '%s*=%s*([^\n]+)')
	if not formula then
		return 0
	end
	local unitTypeId = GetUnitTypeId(u)
	local c = sid(unitTypeId):byte(1,1)
	local params = {
		u = u,
		abilcode = abilcode,
		lv = lv,
		unitTypeId = unitTypeId,
		isHero =  c >= 0x41 and c <= 0x5A, --判断byte是否为大写字母，大写则为英雄
	}
	--print(formula)
	local start2, end2
	while true do
		start2, end2 = string_find(formula, '[^%s%+%-%*/%d%.%[%]]+', end2 and end2+1 or 1)
		if not start2 then
			break
		end
		local name = string_sub(formula, start2, end2)
		--print(formula, '['..name..']')
		if formulaNameToValue[name] then
			local v = formulaNameToValue[name](params, name)
			formula = string_sub(formula, 1, start2-1) .. v .. string_sub(formula, end2+1)
			end2 = end2 - #name + 1
		end

	end
	local fn = load( 'return ' .. formula )
	--print('--')
	if  not fn then
		end2 = nil
		-- 根据等级从列表[ 1 / 1 / 2 ]中选择一个值
		while true do
			start2, end2 = string_find(formula, '%[.-%]', end2 and end2+1 or 1)
			if not start2 then
				break
			end
			local list = string_sub(formula, start2+1, end2-1)
			local v = string_split(list, '/')[lv>0 and lv or 1]
			if not v then
				break
			end
			formula = string_sub(formula, 1, start2-1) .. v:match('[^%s]+') .. string_sub(formula, end2+1)
		end
		fn = load( 'return ' .. formula )
	end

	if not fn then
		return 0
	end

	local v = fn(params)
	return v or 0.00
end

local params = {}
local function _nameFormat( name, format, u, abilcode, lv, hotkey, abilObj )
	-- @name@ = 技能名称
	-- @lv@ = 技能等级
	-- @lvmax@ = 技能最大等级
	-- @hotkey@ = 技能快捷键
	params.name = name
	params.lv = lv
	params.lvmax = abilObj.levels // 1 | 0
	if hotkey < 0 then
		hotkey = 0
	elseif hotkey > 255 then
		hotkey = 255
	end
	params.hotkey = hotkey == 0 and '' or string_char( hotkey )

	if not format or format == '' or format == ' ' then
		if abils[u] and abils[u][abilcode] then
			format = abils[u][abilcode].nameFormat
		end
	end
	local idx
	if not format or format == '' or format == ' ' then
		idx = (params.name and 1 or 0)
			+ (params.lvmax>1 and 2 or 0)
			+ (params.hotkey~='' and 4 or 0)

		format = tNameFormat[idx] or tNameFormat[1]
	end

	name = string_gsub(
		format,
		"@(.-)@",
		function (k)
			return params[k] or k
		end
	)
	--print( 'format', '['..(format or '')..']', name, idx )
	return name
end

-- 科技等价物翻译
local _equivalent
---@param strList string "unit1,unit2,unit3" 确保是单位
_equivalent = function ( strList )
	if not strList then return '' end
	--unitTech.DependencyOr
	--使用队列，因为要保证顺序
	local str = ''
	while true do
		local start1, end1 = string_find(strList, '[^,]+')
		if not start1 then
			break
		end
		local unit = string_sub(strList, start1, end1)
		strList = string_sub(strList, end1+2)
		local unitObj = slk_unit[unit]
		if unitObj then
			local dependencyOr = unitObj.DependencyOr or ''
			if dependencyOr ~= '' then
				strList = dependencyOr .. ',' .. strList
			end
			str = str .. '/' .. unitObj.Name
		end
	end

	return  str
end

local equivalentAbilcode = {
	[1415007793] = true, --TWN1


	[1413565524] = true, --TALT
}

if false then
	local obj
	local default = {
		'htow,ogre,etol,unpl',
		'hkee,ostr,etoa,unp1',
		'hcas,ofrt,etoe,unp2',
		'',
		'',
		'',
		'',
		'',
		'',
	}
	--9级基地
	for i = 1, 9 do
		obj = slk.misc['TWN'..i]
		if obj then
			if obj.DependencyOr then
				equivalentAbilcode['TWN'..i] = obj.DependencyOr or default[i]
			end
		end
	end

	--英雄
	obj = slk.misc['HERO']
	if obj then
		if obj.DependencyOr then
			equivalentAbilcode['HERO'] = obj.DependencyOr or 'Hamg,Hblm,Hmkg,Hpal,Obla,Ofar,Oshd,Otch,Edem,Ekee,Emoo,Ewar,Ucrl,Udea,Udre,Ulic,Npbm,Nbrn,Nngs,Nplh,Nbst'
		end
	end

	--祭坛
	obj = slk.misc['TALT']
	if obj then
		if obj.DependencyOr then
			equivalentAbilcode['TALT'] = obj.DependencyOr or 'halt,oalt,eate,uaod'
		end
	end
end
local SaveInteger = cj.SaveInteger
local FlushChildHashtable = cj.FlushChildHashtable
local TriggerParam = {
	ID = 1,
	IdType = 2,
}
local TriggerValue = {
	TYPE_ABILITY = 1,
	TYPE_ITEM = 2,
	TYPE_UNIT = 3,
	TYPE_UPGRADE = 4,

}
local function setTriggerParam(trig, IdType, abilcode)
	SaveInteger( htb, trig, TriggerParam.ID, abilcode )
	SaveInteger( htb, trig, TriggerParam.IdType, IdType )
	TriggerEvaluate( trigger_Show )
	FlushChildHashtable( htb, trig )
end

local function _upgradeDetail( u, abilcode, lv, slkObj, sId )
	local upgrades = slkObj.Requires
	local amounts = slkObj.Requiresamount or ''
	local requirescount = (slkObj.Requirescount or '0') // 1 | 0

	local c = sId:byte(1,1)
	local isHero = c >= 0x41 and c <= 0x5A

	local locPlayer = GetLocalPlayer()
	local ownner = GetOwningPlayer(u)
	--print( sId, isHero, requirescount )

	if isHero and requirescount > 1 then
		local numOfHeroHad = GetPlayerTechCount(locPlayer, slk_unit[sId] and 1212502607 or abilcode, false) -- 'HERO'
		if numOfHeroHad > 0 then
			upgrades = slkObj['Requires' .. (numOfHeroHad)]
		end
	end

	if not upgrades or upgrades == '' then
		return ''
	end


	if ownner ~= locPlayer and isHero == false then
		return ''
	end

	local i = 0
	local numOfTechNotOwned = 0
	local tStr = {}
	while true do
		local tech = string_match(upgrades, '([^,]+)')
		if not tech then
			break
		end

		upgrades = string_sub(upgrades, #tech + 2)

		local amount = string_match(amounts, '([^,]+)')
		if amount then
			amounts = string_sub(amounts, #amount + 2)
			if amount == '' then
				amount = 1
			else
				amount = amount // 1 << 0
			end
		else
			amount = 1
		end
		local equivalent = ''
		-- 单位科技等价物
		if isShowUpgradeEquivalent then
			local techUnitObj = slk_unit[tech]
			if techUnitObj then
				equivalent =  _equivalent(techUnitObj.DependencyOr or '')
			end
		end
		--==      HERO    ==
		--DependencyOr    Hamg,Hblm,Hmkg,Hpal,Obla,Ofar,Oshd,Otch,Edem,Ekee,Emoo,Ewar,Ucrl,Udea,Udre,Ulic,Npbm,Nbrn,Nngs,Nplh,Nbst,hmtt
		--==      TWN1    == 1级主城
		--DependencyOr    htow,ogre,etol,unpl,halt
		--==      TALT    == 祭坛
		--DependencyOr    hbla,halt,oalt,eate,uaod

		--[[for k,v in pairs(slk.misc) do
			print('==',k,'==')
			for k2,v2 in pairs(v) do
				print(k2,v2)
			end
		end]]

		tech = iid(tech)

		local count = GetPlayerTechCount(ownner, tech, false)

		i = i + 1
		if i == 1 then
			tStr[i] = '|cffffff00需要:|r'
			i = i + 1
		end

		local techName = GetObjectName(tech) .. equivalent -- U1 / U2 / U3
		--print( count, amount, tech, techName, equivalent )
		if count < amount then

			numOfTechNotOwned = numOfTechNotOwned + 1
			tStr[i] = string_format(' - |cffffff00%s  ( %d / %d )|r', techName, count, amount)

		else

			tStr[i] = string_format(' - |cff00ff00%s  ( %d / %d )|r', techName, count, amount)

		end

	end

	local str = ''
	if numOfTechNotOwned > 0 then
		str = table_concat(tStr, '\n')
	end

	return str
end

local function kit_getBuildName_build( u, id, tAbil, slkObj )
	local name
	if tAbil then
		name = tAbil['name'] or ''
	end
	if not name or name == '' then
		name = slkObj['Tip'] or ''
	end
	return name
end

local function kit_getBuildDesc_build( u, id, tAbil, slkObj )
	local desc
	if tAbil then
		desc = tAbil['desc'] or ''
	end
	if not desc or desc == '' then
		desc = (slkObj.Ubertip or '') or ''
	end
	return desc
end

---@param f frame
local function code_update_ui( f )
    --local f = DzGetTriggerUIEventFrame()
	--local p = DzGetTriggerUIEventPlayer()
    local u = getSelectionUnit()
	local id = map_frameToSoltId[f]
	local x, y =  (id % 10), (id // 10)
	--print( 'x', x, 'y', y )
	if not u or not id then
		return
	end

	-- message.button，根据格子找到技能id，命令id，目标类型
    local abilcode, ordid, targetType = msg_button(x, y)
	print('abilcode', abilcode, ordid, targetType)

	-- Aupg 1098215527 建筑升级
	-- Aque 1097954661 
	--print ('abilcode', abilcode, sid(abilcode))
	if  not abilcode
		or abilcode == 0
		or abilcode == 1095263602	-- 1095263602(AHer)英雄 判断英雄单位的技能
		or abilcode == 1098081641	-- 1098081641(Asei)不存在的技能 当鼠标悬停在出售的物品上时
		or abilcode == 1098081644	-- 1098081644(Asel)不存在的技能 当鼠标悬停在出售的单位上时

		or abilcode == 1098082660	-- 1098082660(Asid)出售物品 当鼠标悬停在由触发添加的市场物品上时
		or abilcode == 1098085732	-- 1098082661(Asud)出售单位 当鼠标悬停在由触发添加的市场单位上时

		or abilcode == 1095262837	-- 1095262837(AHbu)人族建造
		or abilcode == 1095721589	-- 1095721589(AObu)兽族建造
		or abilcode == 1096114805	-- 1095262838(AUbu)不死族建造
		or abilcode == 1095066229	-- 1096114806(AEbu)精灵建造
		or abilcode == 1095197301	-- 1095197301(AGbu)娜迦 建造
		or abilcode == 1095656053	-- 1095656053(ANbu)中立 建造
	then
		return
	end

	local tAbil = abils[ u ]
	if tAbil then
		tAbil = tAbil[abilcode]
	end

	local desc
	local name
	local nameFormat
	local lv = GetUnitAbilityLevel( u, abilcode )
	if lv == 0 then
		--可能框选单位导致的
		return
	end

	local abilObj = slk_ability[sid(abilcode)]

	if not abilObj then
		--print('技能不存在', sid(abilcode))
		return
	end

	local ability = EXGetUnitAbility(u, abilcode)
	local icon
	local hotkey

	if tAbil then
		desc = tAbil['desc'..lv] or tAbil['desc']
		name = tAbil['name'..lv] or tAbil['name']
		nameFormat = tAbil['nameFormat'..lv] or tAbil['nameFormat']
		icon = tAbil['icon'..lv] or tAbil['icon']
	end

	if not desc then
		desc = EXGetAbilityDataString( ability, lv, 218 )
		if not desc or desc == '' then
			desc = EXGetAbilityDataString( ability, 1, 218 )
		end
	end

	if not name then
		name = EXGetAbilityDataString( ability, lv, 203 )
		if not name or name == '' then
			name = EXGetAbilityDataString( ability, 1, 203 )
		end
	end

	if not nameFormat then
		nameFormat = EXGetAbilityDataString( ability, lv, 215 )
		--print( 'nameFormat', '['..(nameFormat or '')..']' )
		if not nameFormat or nameFormat == '' or nameFormat == ' ' then
			nameFormat = EXGetAbilityDataString( ability, 1, 215 )
		end
	end

	hotkey = EXGetAbilityDataInteger( ability, 1, 200 )

	name = _nameFormat(name, nameFormat , u, abilcode, lv, hotkey, abilObj)
	--print(name)
	--print(desc)
	--print '-----'

	if isFormulaSupported then
		local isFormula
		if not(isShiftPressed) or not(isFormulaDisplaySupported) then
			desc, isFormula = _DescFormula( desc, u, abilcode, lv )
		end
		if isFormula and isFormulaDisplaySupported then
			DzFrameSetText( ui.comment, '|cff9cdcfe按住Shift查看公式|r' )
		else
			DzFrameSetText( ui.comment, '')
		end
	--else
	--	DzFrameSetText( ui.comment, '')
	end
	--printf('x=%d,y=%d,abilcode=%d(%s),lv=%d,name=%s,desc=%s', x,y ,abilcode,sid(abilcode),lv ,name, desc)

	local upgrade = _upgradeDetail( u, abilcode, lv, abilObj )
	DzFrameSetText(ui.upgrade, upgrade)
    DzFrameSetText( ui.desc, desc)
    DzFrameSetText( ui.name, name )

	if isShowIcon then
		if not icon or icon == '' then
			icon = EXGetAbilityDataString( ability, lv, 204 ) or ''
		end
		DzFrameSetTexture( ui.icon, icon, 0)
	else
		DzFrameSetTexture( ui.icon, '', 0)
	end

	DzFrameShow( ui.bg, true)
	TriggerEvaluate( trigger_Show )
	isTooltipVisible = true
	frameFocus = f

	--print(vanillaToolTip)
	DzFrameShow( vanillaToolTip, false)
    DzFrameClearAllPoints( vanillaToolTip )
    DzFrameSetPoint( vanillaToolTip, 8, gameui, 8, 0.8, 0.60)
	--DzFrameShow( vanillaToolTip, false)
	--DzFrameSetSize( vanillaToolTip, 0.0001, 0.0001 )

	local cost = EXGetAbilityDataInteger(ability, lv, 104)
	--print('物品技能消耗', abil, '等级', lv, '耗蓝', cost)

	if cost > 0 then
		DzFrameShow( ui.manaIcon, true)
		DzFrameSetText( ui.manaText, '|cffffcc00' .. cost .. '|r' )
	else
		DzFrameShow( ui.manaIcon, false)
	end
	--japi.DzClearJassStringNotReference()
end

local function update_ui_build( triggerFrame, u, soltId, x, y, abilcode, ordid, targetType )
	local id = ordid
	--abilcode        1095262837      1752659063      8
	--abilcode        0       851975  32
	local sId = sid(id)
	local slkObj = slk_unit[sId]
	--print('slkObj', slkObj)
	if not slkObj then
		return
	end

	local tAbil = abils[u]
	if tAbil then
		tAbil = tAbil[id]
	end

	local name = kit_getBuildName_build(u, id, tAbil, slkObj)
	DzFrameSetText( ui.name, name )

	local upgrade = _upgradeDetail( u, id, lv, slkObj, sId )
	DzFrameSetText(ui.upgrade, upgrade)

	local desc = kit_getBuildDesc_build(u, id, tAbil, slkObj)
	if isFormulaSupported then
		DzFrameSetText( ui.comment, '')
	end
	DzFrameSetText( ui.desc, desc)

	if isShowIcon then
		local icon = slkObj.Art or ''
		DzFrameSetTexture( ui.icon, icon, 0)
	end

	DzFrameShow( ui.bg, true)
	
	isTooltipVisible = true
	frameFocus = triggerFrame

	DzFrameShow( vanillaToolTip, false)
    DzFrameClearAllPoints( vanillaToolTip )
    DzFrameSetPoint( vanillaToolTip, 8, gameui, 8, 0.8, 0.60)

	local goldcost = (slkObj.goldcost or 0) // 1 | 0
	local lumbercost = (slkObj.lumbercost or 0) // 1 | 0
	local foodused = (slkObj.fused or 0) // 1 | 0
	local buildtime = (slkObj.bldtm or 0) // 1 | 0

	local list = {}
	local icons = {
		ui.manaIcon,
		ui.lumberIcon,
		ui.foodIcon,
		ui.timeIcon,

		ui.manaText,
		ui.lumberText,
		ui.foodText,
		ui.timeText,
	}
	local nList = 0
	local textOffset = 4
	if goldcost > 0 then
		nList = nList + 1
		list[nList] = {
			tex = [[UI\Widgets\ToolTips\Human\ToolTipGoldIcon.blp]],
			num = '|cffffcc00' .. goldcost .. '|r ' ,
			icon = icons[nList],
			text = icons[nList + textOffset],
		}
	end
	if lumbercost > 0 then
		nList = nList + 1
		list[nList] = {
			tex = [[UI\Widgets\ToolTips\Human\ToolTipLumberIcon.blp]],
			num = '|cffffcc00' .. lumbercost .. '|r ' ,
			icon = icons[nList],
			text = icons[nList + textOffset],
		}
	end
	if foodused > 0 then
		nList = nList + 1
		list[nList] = {
			tex = [[UI\Widgets\ToolTips\Human\ToolTipSupplyIcon.blp]],
			num = '|cffffcc00' .. foodused .. '|r ' ,
			icon = icons[nList],
			text = icons[nList + textOffset],
		}
	end
	local noNeedTimeAbil = {
		[1098081644] = true,
		[1098085732] = true,
	}
	if isShowTimeUpgrade and not noNeedTimeAbil[abilcode] and buildtime > 0 then
		nList = nList + 1
		list[nList] = {
			tex = [[ReplaceableTextures\WorldEditUI\Events-Time.blp]],
			num = '|cffffcc00' .. buildtime .. '|r ' ,
			icon = icons[nList],
			text = icons[nList + textOffset],
		}
	end


	for i = 1, 4 do
		local item = list[i]
		if not item then
			DzFrameShow( icons[i], false)
		else
			DzFrameSetTexture( item.icon, item.tex, 0 )
			DzFrameSetText( item.text, item.num .. '' )
			DzFrameShow( item.icon, true )
		end

	end

	setTriggerParam( trigger_Show, TriggerValue.TYPE_UNIT, id )

end


local function update_ui_item( triggerFrame, u, soltId, x, y, abilcode, ordid, targetType )
	local id = ordid
	--abilcode        1095262837      1752659063      8
	--abilcode        0       851975  32
	local sId = sid(id)
	local slkObj = slk_item[sId]
	--print('slkObj', slkObj)
	if not slkObj then
		return
	end

	local tAbil = abils[u]
	if tAbil then
		tAbil = tAbil[id]
	end

	local name = kit_getBuildName_build(u, id, tAbil, slkObj)
	DzFrameSetText( ui.name, name )

	local upgrade = _upgradeDetail( u, abilcode, lv, slkObj, sId )
	DzFrameSetText(ui.upgrade, upgrade)

	local desc = kit_getBuildDesc_build(u, id, tAbil, slkObj)
	if not desc or desc == '' then
		desc = (slkObj.Ubertip or '') or ''
	end
	if isFormulaSupported then
		DzFrameSetText( ui.comment, '')
	end
	--print( name, desc, slkObj.Ubertip, slkObj.Ubertip1, slkObj.Ubertip_1 )
	--desc = "增加食尸鬼<Rugf,base1,%>%6的攻击速度并加快其移动速度。"
	-- 替换<>中3个值
	desc = string_gsub(desc, '<([^>]-)>',
		function(w)
			local ts = string_split(w, ',')
			local countParam = #ts
			if countParam >= 3 then
				return (slk_ability[ ts[1] ] and slk_ability[ ts[1] ][ ts[2] ] or slk_item[ ts[1] ][ ts[2] ]) * 100 // 1 | 0
			elseif countParam == 2 then
				local num = (slk_ability[ ts[1] ] and slk_ability[ ts[1] ][ ts[2] ] or slk_item[ ts[1] ][ ts[2] ]) + 0 
				local i = num // 1 | 0
				return  (i == num ) and i or ('%0.2f'):format(num)
			end

			return '0'
		end
	)
	DzFrameSetText( ui.desc, desc)

	if isShowIcon then
		local icon = slkObj.Art or ''
		DzFrameSetTexture( ui.icon, icon, 0)
	end

	DzFrameShow( ui.bg, true)

	isTooltipVisible = true
	frameFocus = triggerFrame

	DzFrameShow( vanillaToolTip, false)
    DzFrameClearAllPoints( vanillaToolTip )
    DzFrameSetPoint( vanillaToolTip, 8, gameui, 8, 0.8, 0.60)

	local goldcost = (slkObj.goldcost or 0) // 1 | 0
	local lumbercost = (slkObj.lumbercost or 0) // 1 | 0


	local list = {}
	local icons = {
		ui.manaIcon,
		ui.lumberIcon,
		ui.foodIcon,
		ui.timeIcon,

		ui.manaText,
		ui.lumberText,
		ui.foodText,
		ui.timeText,
	}
	local nList = 0
	local textOffset = 4
	if goldcost > 0 then
		nList = nList + 1
		list[nList] = {
			tex = [[UI\Widgets\ToolTips\Human\ToolTipGoldIcon.blp]],
			num = '|cffffcc00' .. goldcost .. '|r ' ,
			icon = icons[nList],
			text = icons[nList + textOffset],
		}
	end
	if lumbercost > 0 then
		nList = nList + 1
		list[nList] = {
			tex = [[UI\Widgets\ToolTips\Human\ToolTipLumberIcon.blp]],
			num = '|cffffcc00' .. lumbercost .. '|r ' ,
			icon = icons[nList],
			text = icons[nList + textOffset],
		}
	end


	for i = 1, 4 do
		local item = list[i]
		if not item then
			DzFrameShow( icons[i], false)
		else
			DzFrameSetTexture( item.icon, item.tex, 0 )
			DzFrameSetText( item.text, item.num .. '' )
			DzFrameShow( item.icon, true )
		end

	end

	setTriggerParam( trigger_Show, TriggerValue.TYPE_ITEM, id )

end

local disAbilcode = {
	[1098081644] = true, -- 1098081644(Asel)不存在的技能 当鼠标悬停在出售的单位上时
	[1098085732] = true, -- 1098082661(Asud)出售单位 当鼠标悬停在由触发添加的市场单位上时

	[1098215527] = true,	-- 1098215527(Aupg)建筑升级

	[1098081641] = true,	-- 1098081641(Asei)不存在的技能 当鼠标悬停在出售的物品上时
	[1098082660] = true,	-- 1098082660(Asel)不存在的技能 当鼠标悬停在由触发添加的市场物品上时

	[1095262837] = true,	-- 1095262837(AHbu)人族建造
	[1095721589] = true,	-- 1095721589(AObu)兽族建造
	[1096114805] = true,	-- 1096114805(AUbu)不死族建造
	[1095066229] = true,	-- 1095066229(AEbu)精灵建造
	[1095197301] = true,	-- 1095197301(AGbu)娜迦 建造
	[1095656053] = true,	-- 1095656053(ANbu)中立 建造

	[1097954661] = true,	-- 1097954661 Aque 科技研究/训练单位

	[1095263602] = true,	-- 1095263602(AHer)英雄 升级技能

	[1097689443] = true,	-- 战斗召回
	[1097689452] = true,	-- 战斗召回
	[1095917932] = true,	-- 集结 技能
}

local function update_ui_ability( triggerFrame, u, soltId, x, y, abilcode, ordid, targetType )
    local id = abilcode
	local sId = sid(id)
	local slkObj = slk_ability[sId]

	if not slkObj then
		return
	end
	--print('update_ui_ability', triggerFrame, u, soltId, x, y, abilcode, ordid, targetType)
	local tAbil = abils[u]
	if tAbil then
		tAbil = tAbil[id]
	end
	-- Aupg 1098215527 建筑升级
	--print ('abilcode', abilcode, sid(abilcode))
	if  not abilcode or abilcode == 0 or disAbilcode[abilcode] then
		return
	end

	local desc
	local name
	local nameFormat
	local lv = GetUnitAbilityLevel( u, abilcode )
	if lv == 0 then
		--可能框选单位导致的
		return
	end

	local abilObj = slk_ability[sid(abilcode)]

	if not abilObj then
		--print('技能不存在', sid(abilcode))
		return
	end

	local ability = EXGetUnitAbility(u, abilcode)
	local icon
	local hotkey

	if tAbil then
		desc = tAbil['desc'..lv] or tAbil['desc']
		name = tAbil['name'..lv] or tAbil['name']
		nameFormat = tAbil['nameFormat'..lv] or tAbil['nameFormat']
		icon = tAbil['icon'..lv] or tAbil['icon']
	end

	if not desc then
		desc = EXGetAbilityDataString( ability, lv, 218 )
		if not desc or desc == '' then
			desc = EXGetAbilityDataString( ability, 1, 218 )
		end
	end

	if not name then
		name = EXGetAbilityDataString( ability, lv, 203 )
		if not name or name == '' then
			name = EXGetAbilityDataString( ability, 1, 203 )
		end
	end

	if not nameFormat then
		nameFormat = EXGetAbilityDataString( ability, lv, 215 )
		--print( 'nameFormat', '['..(nameFormat or '')..']' )
		if not nameFormat or nameFormat == '' or nameFormat == ' ' then
			nameFormat = EXGetAbilityDataString( ability, 1, 215 )
		end
	end

	hotkey = EXGetAbilityDataInteger( ability, 1, 200 )

	name = _nameFormat(name, nameFormat , u, abilcode, lv, hotkey, abilObj)
	--print(name)
	--print(desc)
	--print '-----'

	if isFormulaSupported then
		local isFormula
		if not(isShiftPressed) or not(isFormulaDisplaySupported) then
			desc, isFormula = _DescFormula( desc, u, abilcode, lv )
		end
		if isFormula and isFormulaDisplaySupported then
			DzFrameSetText( ui.comment, '|cff9cdcfe按住Shift查看公式|r' )
		else
			DzFrameSetText( ui.comment, '')
		end
	--else
	--	DzFrameSetText( ui.comment, '')
	end
	--printf('x=%d,y=%d,abilcode=%d(%s),lv=%d,name=%s,desc=%s', x,y ,abilcode,sid(abilcode),lv ,name, desc)

	local upgrade = _upgradeDetail( u, abilcode, lv, abilObj, sId )
	DzFrameSetText(ui.upgrade, upgrade)
    DzFrameSetText( ui.desc, desc)
    DzFrameSetText( ui.name, name )

	if isShowIcon then
		if not icon or icon == '' then
			icon = EXGetAbilityDataString( ability, 1, 204 ) or ''
			--print('icon', sid(abilcode), ability, lv, icon, EXGetAbilityDataString( ability, 1, 204 ))
		end
		DzFrameSetTexture( ui.icon, icon, 0)
	else
		--DzFrameSetTexture( ui.icon, '', 0)
	end

	DzFrameShow( ui.bg, true)
	
	isTooltipVisible = true
	frameFocus = triggerFrame

	--print(vanillaToolTip)
	DzFrameShow( vanillaToolTip, false)
    DzFrameClearAllPoints( vanillaToolTip )
    DzFrameSetPoint( vanillaToolTip, 8, gameui, 8, 0.8, 0.60)
	--DzFrameShow( vanillaToolTip, false)
	--DzFrameSetSize( vanillaToolTip, 0.0001, 0.0001 )

	local cost = EXGetAbilityDataInteger(ability, lv, 104)
	--print('物品技能消耗', abil, '等级', lv, '耗蓝', cost)

	if cost > 0 then
		DzFrameShow( ui.manaIcon, true)
		DzFrameSetTexture( ui.manaIcon, [[UI\Widgets\ToolTips\Human\ToolTipManaIcon.blp]], 0 )
		DzFrameSetText( ui.manaText, '|cffffcc00' .. cost .. '|r' )
	else
		DzFrameShow( ui.manaIcon, false)
	end
	DzFrameShow( ui.lumberIcon, false)
	DzFrameShow( ui.foodIcon, false)
	DzFrameShow( ui.timeIcon, false)
	--japi.DzClearJassStringNotReference()

	setTriggerParam( trigger_Show, TriggerValue.TYPE_ABILITY, id )

end

local function update_ui_upgrade( triggerFrame, u, soltId, x, y, abilcode, ordid, targetType )
	local id = ordid
	local sId = sid(id)
	local slkObj = slk_upgrade[sId]
	--print('slkObj', slkObj)
	if not slkObj then
		return
	end

	local tAbil = abils[u]
	if tAbil then
		tAbil = tAbil[id]
	end

	local lv = GetPlayerTechCount(GetOwningPlayer(u), id, false)

	local name
	if tAbil then
		name = tAbil['name'] or ''
	end
	if not name or name == '' then
		name = slkObj['Tip'] or ''
	end

	local names = string_split(name, ',')
	if #names >= lv+1 then
		name = names[lv+1]
	end

	DzFrameSetText( ui.name, name )

	local upgrade = _upgradeDetail( u, id, lv, slkObj, sId )
	DzFrameSetText(ui.upgrade, upgrade)

	local desc
	if tAbil then
		desc = tAbil['desc'] or ''
	end
	if not desc or desc == '' then
		desc = (slkObj.Ubertip or '') or ''

		local descs = string_split(desc, ',')
		if #descs >= lv+1 then
			desc = descs[lv+1]
		end
	end

	if isFormulaSupported then

		DzFrameSetText( ui.comment, '')

	end

	-- 升级迫击炮炮弹，增加迫击炮小队对无护甲和中型护甲单位的伤害。 
	-- "升级迫击炮炮弹，增加迫击炮小队对无护甲和中型护甲单位的伤害。",11
	-- 升级迫击炮炮弹, 增加迫击炮小队对无护甲和中型护甲单位的伤害。","111,22

	--print( name, desc, slkObj.Ubertip )
	--desc = "增加食尸鬼<Rugf,base1,%>%的攻击速度并加快其移动速度。"
	-- 替换<>中3个值
	desc = string_gsub(desc, '<([^>]-)>',
		function(w)
			local ts = string_split(w, ',')
			local countParam = #ts
			if countParam >= 3 then
				return (slk_upgrade[ ts[1] ][ ts[2] ]) * 100 // 1 | 0
			elseif countParam == 2 then
				local num = slk_upgrade[ ts[1] ][ ts[2] ] + 0
				local i = num // 1 | 0
				return (i == num ) and i or ('%0.2f'):format(num)
			end
			return '0'
		end
	)
	
	DzFrameSetText( ui.desc, desc)

	if isShowIcon then
		local icon = slkObj.Art or ''
		local icons = string_split(icon, ',')
		if #icons >= lv+1 then
			icon = icons[lv+1]
		end
		DzFrameSetTexture( ui.icon, icon, 0)
	end

	DzFrameShow( ui.bg, true)
	
	isTooltipVisible = true
	frameFocus = triggerFrame

	DzFrameShow( vanillaToolTip, false)
    DzFrameClearAllPoints( vanillaToolTip )
    DzFrameSetPoint( vanillaToolTip, 8, gameui, 8, 0.8, 0.60)

	local goldcost = ((slkObj.goldbase or 0) + (slkObj.goldmod or 0) * lv) // 1 | 0
	local lumbercost = ((slkObj.lumberbase or 0) + (slkObj.lumbermod or 0) * lv) // 1 | 0
	local time = ((slkObj.timebase or 0) + (slkObj.timemod or 0) * lv) // 1 | 0
	--print(slkObj.goldbase , slkObj.goldmod, lv)
	local list = {}
	local icons = {
		ui.manaIcon,
		ui.lumberIcon,
		ui.foodIcon,
		ui.timeIcon,

		ui.manaText,
		ui.lumberText,
		ui.foodText,
		ui.timeText,
	}
	local nList = 0
	local textOffset = 4
	if goldcost > 0 then
		nList = nList + 1
		list[nList] = {
			tex = [[UI\Widgets\ToolTips\Human\ToolTipGoldIcon.blp]],
			num = '|cffffcc00' .. goldcost .. '|r ' ,
			icon = icons[nList],
			text = icons[nList + textOffset],
		}
	end
	if lumbercost > 0 then
		nList = nList + 1
		list[nList] = {
			tex = [[UI\Widgets\ToolTips\Human\ToolTipLumberIcon.blp]],
			num = '|cffffcc00' .. lumbercost .. '|r ' ,
			icon = icons[nList],
			text = icons[nList + textOffset],
		}
	end
	if isShowTimeUpgrade and time > 0 then
		nList = nList + 1
		list[nList] = {
			tex = [[ReplaceableTextures\WorldEditUI\Events-Time.blp]],
			num = '|cffffcc00' .. time .. '|r ' ,
			icon = icons[nList],
			text = icons[nList + textOffset],
		}
	end

	for i = 1, 4 do
		local item = list[i]
		if not item then
			DzFrameShow( icons[i], false)
		else
			DzFrameSetTexture( item.icon, item.tex, 0 )
			DzFrameSetText( item.text, item.num .. '' )
			DzFrameShow( item.icon, true )
		end

	end

	setTriggerParam( trigger_Show, TriggerValue.TYPE_UPGRADE, id )

end


local function update_ui_auto( f )
	local u = getSelectionUnit()
	local id = map_frameToSoltId[f]
	local x, y =  (id % 10), (id // 10)

	if not u or not id then
		return
	end
	-- message.button，根据格子找到技能id，命令id，目标类型
    local abilcode, ordid, targetType = msg_button(x, y)
	--print('abilcode', abilcode, ordid, targetType)
	-- Aupg 1098215527 建筑升级
	-- Aque 1097954661 科技研究
	--abilcode        1098215527 建筑升级     1751868773      1
	--abilcode        1097954661 科技研究/训练单位     1382576237      1
	if abilcode == 0 then
		return -- ordid == 851975建造列表 取消按钮
	end
	if abilcode == 1097689443 then

		--if ordid == 852083 then -- 回到工作(W)
			
		--end
		return
	end

	local func_update
	if abilcode == 1097954661 then -- 科技研究/训练单位
		local s = sid(ordid)
		if isReplaceTrainTooltip and slk_unit[s] then
			func_update = update_ui_build
		elseif isReplaceUpgradeTooltip and slk_upgrade[s] then
			func_update = update_ui_upgrade
		elseif ordid == 852027 then
			-- 复活英雄Aque [祭坛]
			-- abilcode        1097954661      852027  512
			-- abilcode        1097954661      852028  512
			-- abilcode        1097954661      852029  512
			-- abilcode        1097954661      852030  512
			return
		end
	elseif abilcode == 1096906593 then
		-- 复活英雄Aawa [酒馆]
		-- abilcode        1096906593      852462  512
		-- abilcode        1096906593      852463  512
		-- abilcode        1096906593      852464  512
		-- abilcode        1096906593      852465  512
		--func_update = update_ui_ability
		return
	else
		func_update = map_abilcodeToUpdateFunc[abilcode]
	end

	if not func_update then
		func_update = update_ui_ability
	end
	func_update( f, u, id, x, y, abilcode, ordid, targetType )

end


map_abilcodeToUpdateFunc = {

	--[1097954661] = update_ui_upgrade,	-- 1097954661(Aque)科技研究/训练单位
	--1095263602	-- 1095263602(AHer)英雄 判断英雄单位的技能(选择英雄技能时)
}

local function code_mouse_enter()
    update_ui_auto( DzGetTriggerUIEventFrame() )
end

local function code_mouse_leave()
    DzFrameShow( ui.bg, false)
	TriggerEvaluate( trigger_Hide )

	DzFrameShow( vanillaToolTip, true)
	DzFrameClearAllPoints( vanillaToolTip )
	DzFrameSetPoint( vanillaToolTip, 8, gameui, 8, 0, 0.16)
	isTooltipVisible = false
	frameFocus = 0
end


local kWidth = 520 / 1920 * 0.8
local kHeight = 520 / 1080 * 0.6

local kWidthText = (520 - 8) / 1920 * 0.8
local kWidthName = (520 - 48) / 1920 * 0.8
local kWidth48 = 48 / 1920 * 0.8
local kHeight48 = 48 / 1080 * 0.6

local kWidth16 = 16 / 1920 * 0.8
local kHeight16 = 16 / 1080 * 0.6

local kWidth24 = 24 / 1920 * 0.8
local kHeight24 = 24 / 1080 * 0.6

local enableIcon = function ()
	isShowIcon = true
	DzFrameSetSize( ui.icon, kWidth48, kHeight48 )
	DzFrameClearAllPoints( ui.icon )
	DzFrameClearAllPoints( ui.name )
	DzFrameClearAllPoints( ui.manaIcon )
	DzFrameSetPoint( ui.icon, 6, ui.upgrade, 0, 0.000, 0.005 )
	DzFrameSetPoint( ui.name, 0, ui.icon, 2, 0.002, 0.000 )

	DzFrameSetPoint( ui.manaIcon, 0, ui.name, 6, 0.00, -0.005 )
	DzFrameSetPoint( ui.lumberIcon, 0, ui.manaText, 2, 0.002, 0.000 )
	DzFrameSetPoint( ui.foodIcon, 0, ui.lumberText, 2, 0.002, 0.000 )
	DzFrameSetPoint( ui.timeIcon, 0, ui.foodText, 2, 0.002, 0.000 )

end

local disableIcon = function ()
	isShowIcon = false
	DzFrameSetSize( ui.icon, 0, 0 )
	DzFrameClearAllPoints( ui.icon )
	DzFrameClearAllPoints( ui.name )
	DzFrameClearAllPoints( ui.manaIcon )
	DzFrameSetPoint( ui.manaIcon, 6, ui.upgrade, 0, 0.00, 0.005 )

	DzFrameSetPoint( ui.name, 6, ui.manaIcon, 0, 0.00, 0.005 )
	DzFrameSetPoint( ui.lumberIcon, 0, ui.manaText, 2, 0.002, 0.000 )
	DzFrameSetPoint( ui.foodIcon, 0, ui.lumberText, 2, 0.002, 0.000 )
	DzFrameSetPoint( ui.timeIcon, 0, ui.foodText, 2, 0.002, 0.000 )
end

local function init()
	japi.DzLoadToc( "XG_JAPI\\Lua\\UI\\ToolTip\\Ability\\toc.toc")
	ui.bg = DzCreateFrameByTagName( "BACKDROP", "_ability_背景", gameui, "XG_Border_Hunman", 0)
	ui.comment = DzCreateFrameByTagName( "TEXT", "_ability_描述", ui.bg, "template", 0)
	ui.desc = DzCreateFrameByTagName( "TEXT", "_ability_属性", ui.bg, "template", 0)
	ui.upgrade = DzCreateFrameByTagName( "TEXT", "_ability_科技", ui.bg, "template", 0)
	ui.name = DzCreateFrameByTagName( "TEXT", "_ability_名字", ui.bg, "template", 0)
	ui.icon = DzCreateFrameByTagName( "BACKDROP", "_ability_贴图", ui.bg, "template", 0)

	ui.manaIcon = DzCreateFrameByTagName( "BACKDROP", "_ability_法力消耗图标", ui.bg, "template", 0)
	ui.manaText = DzCreateFrameByTagName( "TEXT", "_ability_法力消耗", ui.manaIcon, "template", 0)

	ui.lumberIcon = DzCreateFrameByTagName( "BACKDROP", "_ability_木材消耗图标", ui.bg, "template", 0)
	ui.lumberText = DzCreateFrameByTagName( "TEXT", "_ability_木材消耗", ui.lumberIcon, "template", 0)

	ui.foodIcon = DzCreateFrameByTagName( "BACKDROP", "_ability_食物消耗图标", ui.bg, "template", 0)
	ui.foodText = DzCreateFrameByTagName( "TEXT", "_ability_食物消耗", ui.foodIcon, "template", 0)

	ui.timeIcon = DzCreateFrameByTagName( "BACKDROP", "_ability_建造时间图标", ui.bg, "template", 0)
	ui.timeText = DzCreateFrameByTagName( "TEXT", "_ability_建造时间", ui.timeIcon, "template", 0)

	ui.cooldowns = {}
	for idx = 1, 12, 1 do
		ui.cooldowns[idx] = DzCreateFrameByTagName( "BACKDROP", "_ability_冷却时间图标_"..idx, gameui, "template", 0)
		ui.cooldowns[idx+12] = DzCreateFrameByTagName( "TEXT", "_ability_冷却时间图标_"..(idx+12), ui.cooldowns[idx], "template", 0)
		DzFrameSetPoint( ui.cooldowns[idx+12], 0, ui.cooldowns[idx], 0, 0.000, 0.000 )
		DzFrameSetPoint( ui.cooldowns[idx+12], 8, ui.cooldowns[idx], 8, 0.000, 0.000 )
		DzFrameSetTexture( ui.cooldowns[idx], [[ReplaceableTextures\CameraMasks\Black_mask.blp]], 0 )
		japi.DzFrameSetAlpha( ui.cooldowns[idx], 100 )
		japi.DzFrameSetAlpha( ui.cooldowns[idx+12], 255 )

		DzFrameSetSize( ui.cooldowns[ idx], kWidth16*2, kHeight24 )
		japi.DzFrameSetFont( ui.cooldowns[ idx+12 ], 'Fonts\\dfst-m3u.ttf', 0.012, 2 )
		japi.DzFrameSetTextAlignment( ui.cooldowns[idx+12], 50 )
	end

	DzFrameSetSize( ui.bg, kWidth, 0.20 )
    --自适应高度
	DzFrameSetSize( ui.comment, kWidthText, 0.00 )
	DzFrameSetSize( ui.desc, kWidthText, 0.00 )
	DzFrameSetSize( ui.name, kWidthName, 0.00 )
	DzFrameSetSize( ui.upgrade, kWidthName, 0.00 )

	DzFrameSetSize( ui.manaIcon, kWidth16, kHeight16 )
	DzFrameSetSize( ui.manaText, 0.00, kHeight16 )

	DzFrameSetSize( ui.lumberIcon, kWidth16, kHeight16 )
	DzFrameSetSize( ui.lumberText, 0.00, kHeight16 )

	DzFrameSetSize( ui.foodIcon, kWidth16, kHeight16 )
	DzFrameSetSize( ui.foodText, 0.00, kHeight16 )

	DzFrameSetSize( ui.timeIcon, kWidth16, kHeight16 )
	DzFrameSetSize( ui.timeText, 0.00, kHeight16 )

	DzFrameSetTextAlignment(ui.name, 10 )

	DzFrameSetTextAlignment(ui.manaText, 10 )
	DzFrameSetTextAlignment(ui.lumberText, 10 )
	DzFrameSetTextAlignment(ui.foodText, 10 )
	DzFrameSetTextAlignment(ui.timeText, 10 )


	--japi.DzFrameSetAlpha( ui.bg, 100 )

	DzFrameSetTexture( ui.manaIcon, [[UI\Widgets\ToolTips\Human\ToolTipManaIcon.blp]], 0 )
--[[
slk     ability table: 1B480208
slk     unit    table: 1B480010
slk     upgrade table: 1B4802B0
slk     destructable    table: 1B480C18
slk     misc    table: 1B480AC8
slk     doodad  table: 1B480080
slk     buff    table: 1B4801D0
slk     item    table: 1B480518
[misc]
slk     Ping    table: 1B282C68
slk     Misc    table: 1B282A00
slk     Ques    table: 1B2833D8
slk     Came    table: 1B2833A0
slk     Unpa    table: 1B2830C8
slk     Defa    table: 1B283138
slk     Arth    table: 1B283A30 Cinematic
slk     Terr    table: 1B2839C0
slk     Menu    table: 1B283BF0
slk     Info    table: 1B283918
slk     Flye    table: 1B2836B0
slk     Soun    table: 1B283DE8
slk     Targ    table: 1B284168
slk     Ligh    table: 1B283F38
slk     Sele    table: 1B284050
slk     Blig    table: 1B2848A0
slk     Wate    table: 1B2849B8
slk     Team    table: 1B284788
slk     FogO    table: 1B284558
slk     Mini    table: 1B2843D0
slk     Glue    table: 1B284EC0
slk     Batt    table: 1B284D38
slk     Occl    table: 1B284CC8
slk     Plac    table: 1B284DE0]]

    --[[ 锚点
        0 1 2
        3 4 5
        6 7 8  ]]
	--DzFrameClearAllPoints( ui.manaIcon )

	-- FixPoint
	DzFrameSetPoint( ui.manaText, 0, ui.manaIcon, 2, 0.002, 0.00 ) --法术消耗文本 左上 绑定 法术消耗图标 右上
	DzFrameSetPoint( ui.lumberText, 0, ui.lumberIcon, 2, 0.002, 0.00 ) --木材消耗文本 左上 绑定 木材消耗图标 右上
	DzFrameSetPoint( ui.foodText, 0, ui.foodIcon, 2, 0.002, 0.00 ) --食物消耗文本 左上 绑定 食物消耗图标 右上
	DzFrameSetPoint( ui.timeText, 0, ui.timeIcon, 2, 0.002, 0.00 ) --建造时间文本 左上 绑定 建造时间图标 右上

	japi.DzFrameSetFont( ui.manaText, 'Fonts\\dfst-m3u.ttf', 0.0105, 2 )
	japi.DzFrameSetFont( ui.lumberText, 'Fonts\\dfst-m3u.ttf', 0.0105, 2 )
	japi.DzFrameSetFont( ui.foodText, 'Fonts\\dfst-m3u.ttf', 0.0105, 2 )
	japi.DzFrameSetFont( ui.timeText, 'Fonts\\dfst-m3u.ttf', 0.01, 2 )

	-- RelativePoint
	DzFrameSetPoint( ui.comment, 7, DzFrameGetCommandBarButton( 0, 1 ), 1, 0.01, 0.04 )
	DzFrameSetPoint( ui.desc, 6, ui.comment, 0, 0, 0.01 )
	DzFrameSetPoint( ui.upgrade, 6, ui.desc, 0, 0, 0.005 )

	disableIcon()

	DzFrameSetPoint( ui.bg, 1, ui.name, 1, 0, 0.005 ) -- top
	DzFrameSetPoint( ui.bg, 3, ui.desc, 3, -0.005, 0 ) -- left
	DzFrameSetPoint( ui.bg, 5, ui.desc, 5, 0.01, 0 ) -- right

	DzFrameSetPoint( ui.bg, 7, ui.comment, 7, 0, -0.005 )

	DzFrameShow( ui.bg, false)

	for y = 0, 3, 1 do
		for x = 0, 2, 1 do
			local f = DzFrameGetCommandBarButton( x, y )
			-- 将 x 和 y 合并到一个整数，方便直接拆分使用
			map_frameToSoltId[ f ] =  x * 10 + y
			--mouse enter 2, mouse leave 3
			DzFrameSetScriptByCode (f, 2, code_mouse_enter, false)
			DzFrameSetScriptByCode (f, 3, code_mouse_leave, false)

			-- 冷却时间图标 绑定左上
			--[[ 1 2 3 4
				 5 6 7 8
			]]
			local idx = x*4 + y + 1
			--print(x, y, idx)
			DzFrameSetPoint( ui.cooldowns[ idx ], 0, f, 0, 0.001, -0.002 )
			DzFrameSetText( ui.cooldowns[ idx+12 ], idx..'')
			DzFrameShow( ui.cooldowns[ idx ], false)
		end
	end
	

	--GetPlayerTechCount(cj.Player(0), iid('Rhpm'), true)
	--GetObjectName( iid('Rhpm') )
	--预载SLK表，防止第一次显示时卡顿
	local s = slk_unit['hpea']
	s = slk_item['afac']
	s = slk_ability['Aloc']
	s = slk_upgrade['Rhlh']
	print '--雪月技能提示UI 加载完成--'
end

init()

local function _ifnot_init_unitAbilityTable( u, abilcode )
	if not abils[u] then
		abils[u] = {}
	end
	if not abils[u][abilcode] then
		abils[u][abilcode] = {}
	end
end

local features_setString = {
	Name = function ( u, abilcode, lv, name )
		_ifnot_init_unitAbilityTable(u, abilcode)
		local key = 'name'
		if lv ~= 0 then
			key = key..lv
		end
		if name then
			if name == 'CLEAR' then
				abils[u][abilcode][key] = nil
			else
				abils[u][abilcode][key] = name
			end
		else
			abils[u][abilcode][key] = ''
		end
	end,
	Desc = function ( u, abilcode, lv, desc )
		_ifnot_init_unitAbilityTable(u, abilcode)
		local key = 'desc'
		if lv ~= 0 then
			key = key..lv
		end
		if desc then
			if desc == 'CLEAR' then
				abils[u][abilcode][key] = nil
			else
				abils[u][abilcode][key] = desc
			end
		else
			abils[u][abilcode][key] = ''
		end
	end,
	NameFormat = function ( u, abilcode, lv, str )
		_ifnot_init_unitAbilityTable(u, abilcode)

		if str then
			if str == 'CLEAR' then
				abils[u][abilcode].nameFormat = nil
			else
				abils[u][abilcode].nameFormat = str
			end
		else
			abils[u][abilcode].nameFormat = ''
		end
	end,
	Icon = function ( u, abilcode, lv, str )
		_ifnot_init_unitAbilityTable(u, abilcode)
		local key = 'icon'
		if lv ~= 0 then
			key = key..lv
		end
		if str then
			if desc == 'CLEAR' then
				abils[u][abilcode][key] = nil
			else
				abils[u][abilcode][key] = str
			end
		else
			abils[u][abilcode][key] = ''
		end
	end,

}

Xfunc['XG_UI_ToolTip_Ability_SetString'] = function ()
	local u = XGJAPI.unit[1] or 0
	local abilcode = XGJAPI.integer[2] or 0
	local lv = XGJAPI.integer[3] or 0
	local param = XGJAPI.string[4] or 0
	local str = XGJAPI.string[5] or ''
	local func = features_setString[param]
	--print( it, param, str )
	if func then
		func( u, abilcode, lv, str )
	end
end
local features_getString = {
	Name = function ( u, abilcode, lv, name )
		if not(abils[u]) or not( abils[u][abilcode]) then
			return
				lv == 0 and
				EXGetAbilityDataString( EXGetUnitAbility(u, abilcode), GetUnitAbilityLevel(u,abilcode), 203 ) or
				EXGetAbilityDataString( EXGetUnitAbility(u, abilcode), lv, 203 )
		end
		local key = 'name'
		if lv ~= 0 then
			key = key..lv
		end
		return abils[u][abilcode][key] or ''
	end,
	Desc = function ( u, abilcode, lv, desc )
		if not(abils[u]) or not( abils[u][abilcode]) then
			return
				lv == 0 and
				EXGetAbilityDataString( EXGetUnitAbility(u, abilcode), GetUnitAbilityLevel(u,abilcode), 218 ) or
				EXGetAbilityDataString( EXGetUnitAbility(u, abilcode), lv, 218 )
		end
		local key = 'desc'
		if lv ~= 0 then
			key = key..lv
		end
		return abils[u][abilcode][key] or ''
	end,
	NameFormat = function ( u, abilcode, lv, str )
		if not(abils[u]) or not( abils[u][abilcode]) then
			return
				lv == 0 and
				EXGetAbilityDataString( EXGetUnitAbility(u, abilcode), GetUnitAbilityLevel(u,abilcode), 215 ) or
				EXGetAbilityDataString( EXGetUnitAbility(u, abilcode), lv, 215 )
		end
		return abils[u][abilcode].nameFormat or ''
	end,
	Icon = function ( u, abilcode, lv, str )
		if not(abils[u]) or not( abils[u][abilcode]) then
			return
				lv == 0 and
				EXGetAbilityDataString( EXGetUnitAbility(u, abilcode), 1, 204 )
		end
		local key = 'icon'
		if lv ~= 0 then
			key = key..lv
		end
		return abils[u][abilcode][key] or ''
	end,
}

Xfunc['XG_UI_ToolTip_Ability_GetString'] = function ()
	local u = XGJAPI.unit[1] or 0
	local abilcode = XGJAPI.integer[2] or 0
	local lv = XGJAPI.integer[3] or 0
	local param = XGJAPI.string[4] or ''

	local func = features_getString[param]
	if func then
		XGJAPI.string[0] = func( u, abilcode, lv, param )
	else
		XGJAPI.string[0] = ''
	end
end

Xfunc['XG_UI_ToolTip_Ability_gc'] = function ()
	local u = XGJAPI.unit[1] or 0
	local abilcode = XGJAPI.integer[2] or 0
	local lv = XGJAPI.integer[3] or 0
	if u == 0 then
		return
	end
	if not abils[u] then
		return
	end
	if abilcode == 0 then
		abils[u] = nil
	else
		if lv == 0 then
			abils[u][abilcode] = nil
		else
			abils[u][abilcode]['desc'..lv] = nil
			abils[u][abilcode]['name'..lv] = nil
		end
	end
end

local function code_shift_press()
	if isShiftPressed then
		return
	else
		isShiftPressed = true
	end
	if isTooltipVisible and isFormulaDisplaySupported then
		update_ui_auto( frameFocus )
	end
end
local function code_shift_release()
	isShiftPressed = false
	if isTooltipVisible and isFormulaDisplaySupported then
		update_ui_auto( frameFocus )
	end
end

local function code_getHotkey_item(abilcode, ordid)
	abilcode = ordid
	local slkObj = slk_item[sid(abilcode)]
	local hotkey = slkObj and (slkObj.Hotkey or '') or ''
	return hotkey
end
local function code_getHotkey_ability(abilcode, ordid)
	local slkObj = slk_ability[sid(abilcode)]
	local hotkey = slkObj and (slkObj.Hotkey or '') or ''
	return hotkey
end
local function code_getHotkey_buildAbilcode(abilcode, ordid)
	if ordid == 851995 then
		return 'B'
	end
	abilcode = ordid
	local slkObj = slk_unit[sid(abilcode)]
	return slkObj and (slkObj.Hotkey or '') or ''
end
local  function code_getHotkey_AHer(abilcode, ordid)
	if ordid == 852000 then
		return 'O'
	end
	local slkObj = slk_ability[sid(ordid)]
	local hotkey = slkObj and (slkObj.Researchhotkey or '') or ''
	return hotkey
end
local function code_getHotkey_build(abilcode, ordid)
	abilcode = ordid
	local slkObj = slk_unit[sid(abilcode)]
	local hotkey = slkObj and (slkObj.Hotkey or '') or ''
	return hotkey
end
local function code_getHotkey_Aque(abilcode, ordid)
	abilcode = ordid
	local slkObj
	local hotkey
	slkObj = slk_unit[sid(abilcode)]
	if slkObj then
		hotkey = slkObj and (slkObj.Hotkey or '') or ''
		return hotkey
	end
	slkObj = slk_upgrade[sid(abilcode)]
	if slkObj then
		hotkey = slkObj and (slkObj.Hotkey or ''):sub(1,1) or ''
	end
	return hotkey
end
local function code_getHotkey_0(abilcode, ordid)
	if ordid == 851983 then
		return 'A'
	elseif ordid == 851990 then
		return 'P'
	elseif ordid == 851972 then
		return 'S'
	elseif ordid == 851986 then
		return 'M'
	elseif ordid == 851993 then
		return 'H'
	elseif ordid == 851975 or ordid == 851979 or ordid == 851976 then --851975取消升级技能  851979取消选择目标 851976取消升级建筑
		return 'ESC'
	end
	return ''
end

local map_abilcodeToHotkeyFunc = {
	[1098081641] = code_getHotkey_item,	-- 1098081641(Asei)不存在的技能 当鼠标悬停在出售的物品上时
	[1098082660] = code_getHotkey_item,	-- 1098082660(Asel)不存在的技能 当鼠标悬停在由触发添加的市场物品上时

	[1095262837] = code_getHotkey_buildAbilcode,	-- 1095262837(AHbu)人族建造
	[1095721589] = code_getHotkey_buildAbilcode,	-- 1095721589(AObu)兽族建造
	[1096114805] = code_getHotkey_buildAbilcode,	-- 1096114805(AUbu)不死族建造
	[1095066229] = code_getHotkey_buildAbilcode,	-- 1095066229(AEbu)精灵建造
	[1095197301] = code_getHotkey_buildAbilcode,	-- 1095197301(AGbu)娜迦 建造
	[1095656053] = code_getHotkey_buildAbilcode,	-- 1095656053(ANbu)中立 建造

	[1095263602] = code_getHotkey_AHer,	-- 1095263602(AHhe) 英雄选择按钮
	[1098215527] = code_getHotkey_build,	-- 1098215527(Aupg)建筑升级

	[1098081644] = code_getHotkey_build, -- 1098081644(Asel)不存在的技能 当鼠标悬停在出售的单位上时
	[1098085732] = code_getHotkey_build, -- 1098082661(Asud)出售单位 当鼠标悬停在由触发添加的市场单位上时
	[1097954661] = code_getHotkey_Aque, -- 1097954661(Aque)科技研究/训练单位
	[0] = code_getHotkey_0,

	[1097687401] = code_getHotkey_item, -- 1097687401 Amai 制造物品
}

local timerHotkeyUI = nil
local lastSelectedUnit = nil
local kit_showhotkey = function ()
	local curUnit = getSelectionUnit()
	local show = false
	--if curUnit == lastSelectedUnit then
	--	return
	--end
	if not curUnit or curUnit == 0 then
		show = false
	else
		show = true
	end

	for x = 0, 3, 1 do
		for y = 0, 2, 1 do
			local idx = y*4 + x + 1
			if show == false then
				DzFrameShow( ui.cooldowns[ idx ], false)
			else

				local abilcode, ordid, targetType = msg_button(x, y)
				--print( x,y, idx, abilcode, abilcode~=0 and sid(abilcode) or '', ordid,sid(ordid), targetType )

				local func
				func = map_abilcodeToHotkeyFunc[abilcode]
				if not func then
					func = code_getHotkey_ability
				end
				local hotkey = func(abilcode, ordid)
				local showHotkey = hotkey ~= ''
				if showHotkey then
					DzFrameSetText( ui.cooldowns[ idx+12 ], hotkey )
				end

				DzFrameShow( ui.cooldowns[ idx ], showHotkey)

			end

		end
	end
	--lastSelectedUnit = curUnit
end

local showHotkeyUI = function ( )
	if not isShowHotkeyUI then
		return
	end
	if isShowHotkeyUI then
		if not timerHotkeyUI then
			timerHotkeyUI = cj.CreateTimer()
		end
		cj.TimerStart( timerHotkeyUI, 0.16, true, kit_showhotkey )
	end

end

local hideHotkeyUI = function ( )
	if isShowHotkeyUI then
		if not timerHotkeyUI then
			cj.DestroyTimer( timerHotkeyUI )
			timerHotkeyUI = nil
			for idx = 1, 12 do
				DzFrameShow( ui.cooldowns[ idx ], false)
			end
		end
	end
end


--启用公式支持,需要开启进阶
Xfunc['XG_UI_ToolTip_Ability_EnableFormulaSupport'] = function ()
	if isFormulaSupported then
		return
	end
	isFormulaSupported = true
	--DzTriggerRegisterKeyEventByCode takes trigger trig, integer key, integer status, boolean sync, code xfuncHandle returns nothing
	--shift 16      1 press   0 release
	japi.DzTriggerRegisterKeyEventByCode (nil, 16, 1, false, code_shift_press)
	japi.DzTriggerRegisterKeyEventByCode (nil, 16, 0, false, code_shift_release)

end

Xfunc['XG_UI_ToolTip_Ability_SetBoolConstant'] = function ()
	local param = XGJAPI.string[1] or ''
	local value = XGJAPI.bool[2] == true

	if param == 'isFormulaDisplaySupported' then
		if not isFormulaSupported then
			return
		end
		isFormulaDisplaySupported = value
	elseif param == 'isShowUpgradeEquivalent' then
		isShowUpgradeEquivalent = value
	elseif param == 'isUseUnitAttributeLib' then
		if not(value) or isUseUnitAttributeLib then
			return
		end
		isUseUnitAttributeLib = value
		lib_attribute = require 'XG_JAPI.Lua.Unit.Attribute'
		-- XG_GetUnitAttribute(unit, attrName)
		local f = function ( params, key )
			return lib_attribute.XG_GetUnitAttribute( params.u, key )
		end
		setmetatable
		(
			formulaNameToValue,
			{
				__index =
				function (t, k)
					return f
				end
			}
		)
	elseif param == 'isShowIcon' then
		if value then
			enableIcon()
		else
			disableIcon()
		end
	elseif param == 'isReplaceItemTooltip' then
		isReplaceItemTooltip = value
		if value then
			map_abilcodeToUpdateFunc[1098081641] = update_ui_item	-- 1098081641(Asei)不存在的技能 当鼠标悬停在出售的物品上时
			map_abilcodeToUpdateFunc[1098082660] = update_ui_item	-- 1098082660(Asel)不存在的技能 当鼠标悬停在由触发添加的市场物品上时
			map_abilcodeToUpdateFunc[1097687401] = update_ui_item	-- 1097687401 Amai 制造物品
		else
			map_abilcodeToUpdateFunc[1098081641] = nil	-- 1098081641(Asei)不存在的技能 当鼠标悬停在出售的物品上时
			map_abilcodeToUpdateFunc[1098082660] = nil	-- 1098082660(Asel)不存在的技能 当鼠标悬停在由触发添加的市场物品上时
			map_abilcodeToUpdateFunc[1097687401] = nil	-- 1097687401 Amai 制造物品
		end
	elseif param == 'isReplaceUpgradeTooltip' then
		isReplaceUpgradeTooltip = value
	elseif param == 'isReplaceTrainTooltip' then
		isReplaceTrainTooltip = value
	elseif param == 'isReplaceBuildTooltip' then
		isReplaceBuildTooltip = value
		if value then
			map_abilcodeToUpdateFunc[1095262837] = update_ui_build	-- 1095262837(AHbu)人族建造
			map_abilcodeToUpdateFunc[1095721589] = update_ui_build	-- 1095721589(AObu)兽族建造
			map_abilcodeToUpdateFunc[1096114805] = update_ui_build	-- 1096114805(AUbu)不死族建造
			map_abilcodeToUpdateFunc[1095066229] = update_ui_build	-- 1095066229(AEbu)精灵建造
			map_abilcodeToUpdateFunc[1095197301] = update_ui_build	-- 1095197301(AGbu)娜迦 建造
			map_abilcodeToUpdateFunc[1095656053] = update_ui_build	-- 1095656053(ANbu)中立 建造
		else
			map_abilcodeToUpdateFunc[1095262837] = nil	-- 1095262837(AHbu)人族建造
			map_abilcodeToUpdateFunc[1095721589] = nil	-- 1095721589(AObu)兽族建造
			map_abilcodeToUpdateFunc[1096114805] = nil	-- 1096114805(AUbu)不死族建造
			map_abilcodeToUpdateFunc[1095066229] = nil	-- 1095066229(AEbu)精灵建造
			map_abilcodeToUpdateFunc[1095197301] = nil	-- 1095197301(AGbu)娜迦 建造
			map_abilcodeToUpdateFunc[1095656053] = nil	-- 1095656053(ANbu)中立 建造
		end
	elseif param == 'isReplaceBldUpgTooltip' then
		isReplaceBldUpgTooltip = value
		if value then
			map_abilcodeToUpdateFunc[1098215527] = update_ui_build	-- 1098215527(Aupg)建筑升级
		else
			map_abilcodeToUpdateFunc[1098215527] = nil	-- 1098215527(Aupg)建筑升级
		end
	elseif param == 'isReplaceSellUnitTooltip' then
		isReplaceSellUnitTooltip = value
		if value then
			map_abilcodeToUpdateFunc[1098081644] = update_ui_build -- 1098081644(Asel)不存在的技能 当鼠标悬停在出售的单位上时
			map_abilcodeToUpdateFunc[1098085732] = update_ui_build -- 1098082661(Asud)出售单位 当鼠标悬停在由触发添加的市场单位上时
		else
			map_abilcodeToUpdateFunc[1098081644] = nil -- 1098081644(Asel)不存在的技能 当鼠标悬停在出售的单位上时
			map_abilcodeToUpdateFunc[1098085732] = nil -- 1098082661(Asud)出售单位 当鼠标悬停在由触发添加的市场单位上时
		end
	elseif param == 'isShowTimeUpgrade' then
			isShowTimeUpgrade = value
	elseif param == 'isShowHotkeyUI' then
		isShowHotkeyUI = value
		if value then
			showHotkeyUI()
		else
			hideHotkeyUI()
		end
	end

end

Xfunc['XG_UI_ToolTip_Ability_GetFormulaValue'] = function ()
	if not isFormulaSupported then
		return
	end
	local u = XGJAPI.unit[1] or 0
	local abilcode = XGJAPI.integer[2] or 0
	local lv = XGJAPI.integer[3] or 0
	local code = XGJAPI.string[4] or ''
	if u == 0 then
		XGJAPI.real[0] = 0.00
		return
	end

	if abils[u] and abils[u][abilcode] then
		local tAbil = abils[u][abilcode]
		if tAbil then
			desc = tAbil['desc'..lv] or tAbil['desc']
		end
	end

	local ability = EXGetUnitAbility(u, abilcode)

	if not desc then
		desc = EXGetAbilityDataString( ability, lv, 218 )
		if not desc or desc == '' then
			desc = EXGetAbilityDataString( ability, 1, 218 )
		end
	end

	if not desc then
		XGJAPI.real[0] = 0.00
		return
	end
	if lv == 0 then
		lv = GetUnitAbilityLevel(u, abilcode)
	end
	XGJAPI.real[0] = getValueFromFormula( desc, u, abilcode, lv, code )
end

--XG_UI_ToolTip_Ability_GetFrame(frameName)
Xfunc['XG_UI_ToolTip_Ability_GetFrame'] = function ()
	local suc
	local frameName = XGJAPI.string[1]
	while true do
		if not frameName then
			break
		end

		suc = true
		break
	end
	if not suc then
		XGJAPI.integer[0] = 0
		return
	end
	--[[
		ui.bg
		ui.comment
		ui.desc
		ui.upgrade
		ui.name
		ui.icon
		ui.manaIcon
		ui.manaText
	]]
	local ret = ui[ frameName ]
	if type(ret) ~= "number" then
		ret = 0
	end
	XGJAPI.integer[0] = ret or 0
end

--XG_UI_ToolTip_Ability_SetFrame(frameName, frame)
Xfunc['XG_UI_ToolTip_Ability_SetFrame'] = function ()
	local suc
	local frameName = XGJAPI.string[1]
	local frame = XGJAPI.integer[2]
	local targetFrame
	while true do
		if not frameName then
			break
		end
		if not frame or frame <= 0 then
			break
		end
		targetFrame = ui[ frameName ]
		if not targetFrame then
			break
		end
		if type(targetFrame) ~= "number" then
			ret = 0
		end
		suc = true
		break
	end
	if not suc then
		return
	end
	ui[ frameName ] = frame
end

trigger_Show = XGJAPI.trigger[1]
trigger_Hide = XGJAPI.trigger[2]
htb = XGJAPI.integer[3]