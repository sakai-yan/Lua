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

local UnitItemInSlot = cj.UnitItemInSlot
local GetItemName = cj.GetItemName
local GetItemTypeId = cj.GetItemTypeId
local GetUnitAbilityLevel = cj.GetUnitAbilityLevel

local EXGetItemDataString = japi.EXGetItemDataString

local slk_item = slk.item
local slk_ability = slk.ability
--物品抵押率
local PawnItemRate = slk.misc.Misc.PawnItemRate

local ui = {}
local map_frameToSoltId = {}
local gameui = DzGetGameUI()
local vanillaToolTip = japi.DzFrameGetTooltip()

local getSelectionUnit = msg.selection
local string_gmatch = string.gmatch
local sid = base.sid
local iid = base.iid

local multiBoard = {}

local items = {}

---@param f frame
local function code_update_ui( f, it )
    --local f = DzGetTriggerUIEventFrame()
	--local p = DzGetTriggerUIEventPlayer()
    local u = getSelectionUnit()
	if not it then
		local id = map_frameToSoltId[f]
		if not u or not id then
			return
		end
		it = UnitItemInSlot( u , id )
		if not it or it == 0 then
			return
		end
	end
    local itid = GetItemTypeId( it )
    DzFrameShow( ui.bg, true)

    DzFrameClearAllPoints( vanillaToolTip )
    DzFrameSetPoint( vanillaToolTip, 7, gameui, 7, 0, -0.60)

	local tItem = items[it]
	--DzFrameSetText( ui.commit, "这里显示的是作者设置的物品描述")
	local desc
	local name
	if tItem then
		desc = tItem.desc or EXGetItemDataString( itid, 3)
		name = tItem.name or GetItemName( it )
	else
		desc = EXGetItemDataString( itid, 3)
		name = GetItemName( it )
	end
    DzFrameSetText( ui.desc, desc)
    DzFrameSetText( ui.name, name )
    DzFrameSetTexture( ui.icon, EXGetItemDataString( itid, 1), 0)

	local itemObj = slk_item[sid(itid)]

	local itemAbilityList = itemObj.abilList -- "abi1,abi2,abi3"
	local isItemPawnable = itemObj.pawnable

	local cost = 0
	local n = 0
	local lv = 0
	local abilObj = nil
	if itemAbilityList then
		for abil in string_gmatch(itemAbilityList, "%w+") do
			--print('物品技能', abil)
			if not abil then
				print('物品技能错误', abil)
				goto next_abil
			end
			abilObj = slk_ability[abil]
			if not abilObj then
				print('物品技能不存在', abil)
				goto next_abil
			end
			lv = GetUnitAbilityLevel( u, iid(abil) )
			n = (abilObj['Cost' .. lv] or 0) // 1 | 0 --abilObj['Cost' .. lv]: string
			--print('物品技能消耗', abil, '等级', lv, '耗蓝', n)
			if n > 0 then
				cost = cost + n
			end

			::next_abil::
		end
	end

	local lastFrame = ui.name
	local lastAnchor = 6 -- 绑定在物品名字的左下
	local offsetX = 0.000
	local offsetY = -(8 / 1080 * 0.6)

	DzFrameClearAllPoints( ui.manaIcon )
	DzFrameClearAllPoints( ui.goldIcon )
	DzFrameClearAllPoints( ui.lumberIcon )

	if cost > 0 then
		DzFrameSetPoint( ui.manaIcon, 0, ui.name, lastAnchor, offsetX, offsetY ) --法术消耗图标 左上 绑定 物品名字 左下
		DzFrameShow( ui.manaIcon, true)
		DzFrameSetText( ui.manaText, '|cffffcc00' .. cost .. '|r' )
		--下一个控件的锚点绑定在文本右上
		lastFrame = ui.manaText
		lastAnchor = 2
		offsetX = 0.005
		offsetY = -0.002
	else
		DzFrameShow( ui.manaIcon, false)
	end

	cost = ( (itemObj.goldcost or 0) * PawnItemRate ) // 1 | 0
	if isItemPawnable and cost > 0 then
		DzFrameSetPoint( ui.goldIcon, 0, lastFrame, lastAnchor, offsetX, offsetY ) --金币价值图标 左上 绑定 上一个控件 右下
		DzFrameShow( ui.goldIcon, true)
		DzFrameSetText( ui.goldText, '|cffffcc00' .. cost .. '|r' )
		--下一个控件的锚点绑定在文本右上
		lastFrame = ui.goldText
		lastAnchor = 2
		offsetX = 0.005
		offsetY = -0.001
	else
		DzFrameShow( ui.goldIcon, false)
	end

	cost = ( (itemObj.lumbercost or 0) * PawnItemRate ) // 1 | 0
	if isItemPawnable and cost > 0 then
		DzFrameSetPoint( ui.lumberIcon, 0, lastFrame, lastAnchor, offsetX, offsetY ) --木材价值图标 左上 绑定 上一个控件 右下
		DzFrameShow( ui.lumberIcon, true)
		DzFrameSetText( ui.lumberText, '|cffffcc00' .. cost .. '|r' )
		--下一个控件的锚点绑定在文本右上
		lastFrame = ui.lumberText
		lastAnchor = 2
		offsetX = 0.005
		offsetY = -0.002
	else
		DzFrameShow( ui.lumberIcon, false)
	end


end

local function code_mouse_enter()
    code_update_ui( DzGetTriggerUIEventFrame() )
end

local function code_mouse_leave()
    DzFrameShow( ui.bg, false)
	DzFrameClearAllPoints( vanillaToolTip )
	DzFrameSetPoint( vanillaToolTip, 8, gameui, 8, 0, 0.16)
end

local GetIssuedOrderId = cj.GetIssuedOrderId
local GetOrderTargetItem = cj.GetOrderTargetItem
local GetTriggerPlayer = cj.GetTriggerPlayer
local GetLocalPlayer = cj.GetLocalPlayer
--local DzGetMouseFocus = japi.DzGetMouseFocus
local function code_moveItem()
	local orderId = GetIssuedOrderId()
	-- local targetSoltIndex = (orderId-852002)  -- 0 - 5
	if orderId >= 852002 and orderId <= 852007 then
		--print ('刷新！', cj.GetPlayerName(GetTriggerPlayer()) )
		if GetTriggerPlayer() == GetLocalPlayer() then
			code_update_ui( 0, GetOrderTargetItem() )
		end
		-- message.button，根据格子找到技能id，命令id，目标类型
		--local ability, order, target_type = msg.button(3, 0)
		--print (ability, order, target_type)
	end
end

local kWidth = 520 / 1920 * 0.8
local kHeight = 520 / 1080 * 0.6

local kWidthText = (520 - 8) / 1920 * 0.8
local kWidthName = (520 - 48) / 1920 * 0.8
local kWidth48 = 48 / 1920 * 0.8
local kHeight48 = 48 / 1080 * 0.6

local kWidth16 = 16 / 1920 * 0.8
local kHeight16 = 16 / 1080 * 0.6


local function init()
	japi.DzLoadToc( "XG_JAPI\\Lua\\UI\\ToolTip\\Item\\toc.toc")

    --[[
        锚点
        0 1 2
        3 4 5
        6 7 8
    ]]

end

init()

local _uuid_ = 0
local function genUUID()
	_uuid_ = _uuid_ + 1
	return 'XG_UI_MultiBoard_' .. _uuid_
end

--构造单元格
local _build_cell = function ( )
	local t = {
		title = '',

	}
	return t
end

local type = type
local mt = {
	__index = function (t, k)
		if type(k) == 'number' then
			local o = {}
			t[k] = o
			return o
		end
	end
}

--[[
mb = 
｛
	row = 0,
	col = 0,
	font = 'Fonts\\dfst-m3u.ttf',
	ui = {
	    bg = bg,
	    title = title,
	    panel = panel,
	},
	
	[row] = 
	{
		[col] =
		{
			width = 0.1,
			height = 0.1,
			title = 'title',
			ui = {},
		}
	}
｝
]]

--newMultiBoard( mbName, row, col, template )
Xfunc['XG_UI_MultiBoard_New'] = function ()
	local mbName = XGJAPI.string[1] or ''
	local row = XGJAPI.integer[2] or 0
	local col = XGJAPI.integer[3] or 0

	if multiBoard[mbName] then
		return
	end
	local bg = DzCreateFrameByTagName( 'BACKDROP', genUUID(), gameui, 'template', 0 )
	local mb = setmetatable( {
		row = row,
		col = col,
		font = 'Fonts\\dfst-m3u.ttf',
		ui = {
			bg = bg,
			title = DzCreateFrameByTagName( 'TEXT', genUUID(), bg, 'template', 0 ),
			panel = DzCreateFrameByTagName( 'BACKDROP', genUUID(), bg, 'template', 0 ),
		}
	},
	mt )
	multiBoard[mbName] = mb
	local lastFrame = mb.ui.panel
	local lastAnchor = 0
	local offsetX = 0.000
	local offsetY = 0.000
	for i = 1, row do

		for j = 1, col do
			local bg = DzCreateFrameByTagName( 'BACKDROP', genUUID(), mb.ui.panel, 'template', 0 )
			local title = DzCreateFrameByTagName( 'TEXT', genUUID(), bg, 'template', 0 )
			local icon = DzCreateFrameByTagName( 'BACKDROP', genUUID(), bg, 'template', 0 )

			mb[i][j] = {
				title = '',
				width = kWidth,
				height = kHeight,

				ui = {
					bg = bg,
					title = title,
					icon = icon,
				},
			}
			DzFrameSetPoint( bg, 0, lastFrame, lastAnchor, offsetX, offsetY )
			DzFrameSetSize( bg, kWidth48, kHeight16 )
			DzFrameSetPoint( title, 4, bg, 4, 0, 0.00)
			DzFrameSetPoint( icon, 4, bg, 4, 0, 0.00)

			DzFrameSetTexture( bg, 'UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp', 0 )

			lastFrame = bg
			lastAnchor = 2
			offsetX = 0.005
			offsetY = 0.000
		end

		lastFrame = mb[i][1].ui.bg
		lastAnchor = 6
		offsetX = 0.000
		offsetY = 0.005
		print('ui-multiBoard - ?')
	end

	DzFrameSetPoint( mb.ui.bg, 2, gameui, 2, 0.005, -0.005 )	--RT
	--DzFrameSetPoint( mb.ui.bg, 6, mb.ui.panel, 6, 0.005, -0.005 ) --LB

	DzFrameSetPoint( mb.ui.title, 0, mb.ui.bg, 0, 0.005, -0.005 )

	DzFrameSetPoint( mb.ui.panel, 0, mb.ui.bg, 0, 0.005, -0.005 )
	--DzFrameSetPoint( mb.ui.panel, 8, lastFrame, 8, 0.005, 0.005 )

	DzFrameSetSize( mb.ui.bg, kWidth, kHeight16 * (row+1) )
	DzFrameSetSize( mb.ui.panel, kWidth, kHeight16 * row )
	DzFrameShow( mb.ui.bg, true )
end

--setTitle( mbName, row, col, title )
Xfunc['XG_UI_MultiBoard_SetTitle'] = function ()
	local mbName = XGJAPI.string[1] or ''
	local row = XGJAPI.integer[2] or 0
	local col = XGJAPI.integer[3] or 0
	local title = XGJAPI.string[4] or ''

	local mb = multiBoard[mbName]
	if not mb then
		return	--面板不存在
	end

	if row < 0 or col < 0 then
		DzFrameSetText( mb.ui.title, title )
		return	--用作修改面板主标题
	end

	for i = (row == 0 and 1 or row),
			(row == 0 and mb.row or row)
	do
		for j = (col == 0 and 1 or col),
				(col == 0 and mb.col or col)
		do
			local cell = mb[i][j]
			if not cell then
				return	--没有这个格子
			end
			cell.title = title
			DzFrameSetText( cell.ui.title, title )
		end
	end

end

--setSize( mbName, row, col, width, height )
Xfunc['XG_UI_MultiBoard_SetSize'] = function ()
	local mbName = XGJAPI.string[1] or ''
	local row = XGJAPI.int[2] or 0
	local col = XGJAPI.int[3] or 0
	local width = XGJAPI.real[4] or 0
	local height = XGJAPI.real[5] or 0

	local mb = multiBoard[mbName]
	if not mb then
		return	--面板不存在
	end

	local cell = mb[row][col]
	if not cell then
		return	--没有这个格子
	end

	cell.width = width
	cell.height = height
	DzFrameSetSize( cell.ui.bg, width, height )
end

