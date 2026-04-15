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
local DzGetMouseFocus = japi.DzGetMouseFocus
local DzGetTriggerUIEventPlayer = japi.DzGetTriggerUIEventPlayer
local DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment
local DzFrameSetUpdateCallbackByCode = japi.DzFrameSetUpdateCallbackByCode
local DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint
local DzGetMouseX = japi.DzGetMouseX
local DzGetMouseY = japi.DzGetMouseY
local DzGetMouseXRelative = japi.DzGetMouseXRelative
local DzGetMouseYRelative = japi.DzGetMouseYRelative
local DzGetClientWidth = japi.DzGetClientWidth
local DzGetClientHeight = japi.DzGetClientHeight

local UnitItemInSlot = cj.UnitItemInSlot
local GetItemName = cj.GetItemName
local GetItemTypeId = cj.GetItemTypeId
local GetUnitAbilityLevel = cj.GetUnitAbilityLevel

local EXGetItemDataString = japi.EXGetItemDataString

local slk_item = slk.item
local slk_ability = slk.ability
local slk_unit = slk.unit
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

local trig_moveItem = cj.CreateTrigger()

local isShow = false


local items = {}

local function moveUIToMouse()
	DzFrameClearAllPoints( ui.commit )
	local x = DzGetMouseXRelative() / DzGetClientWidth() * 0.8
	local y = 0.6 - DzGetMouseYRelative() / DzGetClientHeight() * 0.6 + 0.01
	DzFrameSetAbsolutePoint( ui.commit, 7, x, y )
end

local function moveUIToTooltip()
	DzFrameClearAllPoints( ui.commit )
	DzFrameSetPoint( ui.commit, 7, DzFrameGetCommandBarButton( 0, 1 ), 1, 0.01, 0.04 )
end

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
	local icon
	if tItem then
		desc = tItem.desc or EXGetItemDataString( itid, 3)
		name = tItem.name or GetItemName( it )
		icon = tItem.icon or EXGetItemDataString( itid, 1)
	else
		desc = EXGetItemDataString( itid, 3)
		name = GetItemName( it )
		icon = EXGetItemDataString( itid, 1)
	end
    DzFrameSetText( ui.desc, desc)
    DzFrameSetText( ui.name, name )
    DzFrameSetTexture( ui.icon, icon, 0)

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
			if lv == 0 then
				lv = 1
			end
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
		offsetY = 0.00
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
		offsetY = 0.00
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
		offsetY = 0.00
	else
		DzFrameShow( ui.lumberIcon, false)
	end


end



local function code_mouse_enter()
	isShow = true
	moveUIToTooltip()
    code_update_ui( DzGetTriggerUIEventFrame() )
end

local function code_mouse_leave()
	isShow = false
    DzFrameShow( ui.bg, false)
	DzFrameClearAllPoints( vanillaToolTip )
	DzFrameSetPoint( vanillaToolTip, 8, gameui, 8, 0, 0.16)
end

local GetIssuedOrderId = cj.GetIssuedOrderId
local GetOrderTargetItem = cj.GetOrderTargetItem
local GetTriggerPlayer = cj.GetTriggerPlayer
local GetLocalPlayer = cj.GetLocalPlayer

local function code_moveItem()
	local orderId = GetIssuedOrderId()
	-- local targetSoltIndex = (orderId-852002)  -- 0 - 5
	if orderId >= 852002 and orderId <= 852007 then
		--print ('刷新！', cj.GetPlayerName(GetTriggerPlayer()) )
		if GetTriggerPlayer() == GetLocalPlayer() then
			moveUIToTooltip()
			code_update_ui( DzGetMouseFocus() )
			--code_update_ui( 0, GetOrderTargetItem() )
		end
		-- message.button，根据格子找到技能id，命令id，目标类型
		--local ability, order, target_type = msg.button(3, 0)
		--print (ability, order, target_type)
	end
end

local DzGetUnitUnderMouse = japi.DzGetUnitUnderMouse
local GetUnitTypeId = cj.GetUnitTypeId

local __PointedItem = 0
local isShowTooltipForItemOnTheGround = nil
local function code_frame_tick()
	if not isShowTooltipForItemOnTheGround then
		return
	end
	local it = DzGetUnitUnderMouse()
	if __PointedItem == it then
		return
	end
	__PointedItem = it
	if not it or it == 0 then
		code_mouse_leave()
		return
	end

	local itemId = GetUnitTypeId(it)
	if itemId and itemId ~= 0 then
		code_mouse_leave()
		-- 单位
		return
	end

	itemId = GetItemTypeId(it)
	if not itemId or itemId == 0 then
		code_mouse_leave()
		-- 不是物品
		return
	end

	isShow = true
	moveUIToMouse()
	code_update_ui( 0, it )

end

local kWidth = 520 / 1920 * 0.8
local kHeight = 520 / 1080 * 0.6

local kWidthText = (520 - 8) / 1920 * 0.8
local kWidthName = (520 - 48) / 1920 * 0.8
local kWidth48 = 48 / 1920 * 0.8
local kHeight48 = 48 / 1080 * 0.6

local kWidth16 = 16 / 1920 * 0.8
local kHeight16 = 16 / 1080 * 0.6

local kHeight24 = 24 / 1080 * 0.6


local function init()
	japi.DzLoadToc( "XG_JAPI\\Lua\\UI\\ToolTip\\Item\\toc.toc")
	ui.bg = DzCreateFrameByTagName( "BACKDROP", "提示背景", gameui, "XG_Border_Hunman", 0)
	ui.commit = DzCreateFrameByTagName( "TEXT", "物品描述", ui.bg, "template", 0)
	ui.desc = DzCreateFrameByTagName( "TEXT", "物品属性", ui.bg, "template", 0)
	ui.name = DzCreateFrameByTagName( "TEXT", "物品名字", ui.bg, "template", 0)
	ui.icon = DzCreateFrameByTagName( "BACKDROP", "物品贴图", ui.bg, "template", 0)

	ui.manaIcon = DzCreateFrameByTagName( "BACKDROP", "法力消耗图标", ui.bg, "template", 0)
	ui.goldIcon = DzCreateFrameByTagName( "BACKDROP", "金币价值图标", ui.bg, "template", 0)
	ui.lumberIcon = DzCreateFrameByTagName( "BACKDROP", "木材价值图标", ui.bg, "template", 0)

	ui.manaText = DzCreateFrameByTagName( "TEXT", "法力消耗", ui.manaIcon, "template", 0)
	ui.goldText = DzCreateFrameByTagName( "TEXT", "金币价值", ui.goldIcon, "template", 0)
	ui.lumberText = DzCreateFrameByTagName( "TEXT", "木材价值", ui.lumberIcon, "template", 0)

	DzFrameSetSize( ui.bg, kWidth, 0.20 )
    --自适应高度
	DzFrameSetSize( ui.commit, kWidthText, 0.00 )
	DzFrameSetSize( ui.desc, kWidthText, 0.00 )

	DzFrameSetSize( ui.name, kWidthName, 0.00 )
	DzFrameSetSize( ui.icon, kWidth48, kHeight48 )

	DzFrameSetSize( ui.manaIcon, kWidth16, kHeight16 )
	DzFrameSetSize( ui.goldIcon, kWidth16, kHeight16 )
	DzFrameSetSize( ui.lumberIcon, kWidth16, kHeight16 )

	DzFrameSetSize( ui.manaText, 0.00, kHeight16 )
	DzFrameSetSize( ui.goldText, 0.00, kHeight16 )
	DzFrameSetSize( ui.lumberText, 0.00, kHeight16 )

	DzFrameSetTextAlignment(ui.manaText, 10 )
    DzFrameSetTextAlignment(ui.goldText, 10 )
	DzFrameSetTextAlignment(ui.lumberText, 10 )

	DzFrameSetTextAlignment(ui.name, 10 )

	DzFrameSetPoint( ui.manaText, 0, ui.manaIcon, 2, 0.001, 0.00 ) --法术消耗文本 左上 绑定 法术消耗图标 右上
	DzFrameSetPoint( ui.goldText, 0, ui.goldIcon, 2, 0.001, 0.00 ) --金币消耗文本 左上 绑定 金币消耗图标 右上
	DzFrameSetPoint( ui.lumberText, 0, ui.lumberIcon, 2, 0.001, 0.00 ) --木材消耗文本 左上 绑定 木材消耗图标 右上

	DzFrameSetTexture( ui.manaIcon, [[UI\Widgets\ToolTips\Human\ToolTipManaIcon.blp]], 0 )
	DzFrameSetTexture( ui.goldIcon, [[UI\Widgets\ToolTips\Human\ToolTipGoldIcon.blp]], 0 )
	DzFrameSetTexture( ui.lumberIcon, [[UI\Widgets\ToolTips\Human\ToolTipLumberIcon.blp]], 0 )

	--DzFrameSetTexture( ui.icon, "UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp", 0 )

    --[[
	DzFrameSetText( ui.commit, "最底层注释说明" )
	DzFrameSetText( ui.desc, "物品说明" )
	DzFrameSetText( ui.name, "物品名字" )
    ]]
    --[[
        锚点
        0 1 2
        3 4 5
        6 7 8
    ]]
	
    --说明左下绑注释左上
	DzFrameSetPoint( ui.desc, 6, ui.commit, 0, 0, 0.01 )

	DzFrameSetPoint( ui.icon, 6, ui.desc, 0, 0, 0.01 )
	DzFrameSetPoint( ui.name, 0, ui.icon, 2, 0.002, 0.00 )

	DzFrameSetPoint( ui.bg, 1, ui.name, 1, 0, 0.005 ) -- top
	DzFrameSetPoint( ui.bg, 3, ui.desc, 3, -0.005, 0 ) -- left
	DzFrameSetPoint( ui.bg, 5, ui.desc, 5, 0.01, 0 ) -- right

	DzFrameSetPoint( ui.bg, 7, ui.commit, 7, 0, -0.005 )

	DzFrameShow( ui.bg, false)
	--udg_Unit.bg = gg_unit_Hpal_0000

	for i = 0, 5, 1 do
        local f = DzFrameGetItemBarButton( i )
        map_frameToSoltId[ f ] = i
        --mouse enter 2, mouse leave 3
        DzFrameSetScriptByCode (f, 2, code_mouse_enter, false)
        DzFrameSetScriptByCode (f, 3, code_mouse_leave, false)
		--释放无法捕捉
		--DzFrameSetScriptByCode (f, 4, code_mouse_release, false)

	end
	local TriggerRegisterPlayerUnitEvent = cj.TriggerRegisterPlayerUnitEvent
	local EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER = cj.EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER
	local Player = cj.Player

	--只管玩家1 - 12就行了，不管电脑。反正他们又不看装备
	for i = 0, 11, 1 do
		TriggerRegisterPlayerUnitEvent( trig_moveItem, Player(i), EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER, nil )
	end
	cj.TriggerAddAction( trig_moveItem, code_moveItem )

	print '--雪月物品提示UI 加载完成--'
end

init()

local features_setString = {
	Name = function ( it, name )
		if not items[it] then
			items[it] = {}
		end
		if name then
			if name == 'CLEAR' then
				items[it].name = nil
			else
				items[it].name = name
			end
		else
			items[it].name = ''
		end
	end,
	Desc = function ( it, desc )
		if not items[it] then
			items[it] = {}
		end
		if desc then
			if desc == 'CLEAR' then
				items[it].desc = nil
			else
				items[it].desc = desc
			end
		else
			items[it].desc = ''
		end
	end,
	Icon = function ( it, icon )
		if not items[it] then
			items[it] = {}
		end
		if icon then
			if icon == 'CLEAR' then
				items[it].icon = nil
			else
				items[it].icon = icon
			end
		else
			items[it].icon = ''
		end
	end,
}

Xfunc['XG_UI_ToolTip_Item_SetString'] = function ()
	local it = XGJAPI.item[1] or 0
	local param = XGJAPI.string[2] or ''
	local str = XGJAPI.string[3] or ''
	local func = features_setString[param]
	--print( it, param, str )
	if func then
		func( it, str )
	end
end

local features_getString = {
	Name = function ( it )
		if not items[it] then
			return GetItemName( it )
		end
		return items[it].name or ''
	end,
	Desc = function ( it )
		if not items[it] then
			return EXGetItemDataString( GetItemTypeId( it ), 3)
		end
		return items[it].desc or ''
	end,
	Icon = function ( it )
		if not items[it] then
			return EXGetItemDataString( GetItemTypeId( it ), 1)
		end
		return items[it].icon or ''
	end,
}

Xfunc['XG_UI_ToolTip_Item_GetString'] = function ()
	local it = XGJAPI.item[1] or 0
	local param = XGJAPI.string[2] or ''
	local func = features_getString[param]
	if func then
		XGJAPI.string[0] = func( it )
	else
		XGJAPI.string[0] = ''
	end
end

Xfunc['XG_UI_ToolTip_Item_gc'] = function ()
	local it = XGJAPI.item[1]
	if not it or it == 0 then
		return
	end
	if items[it] then
		items[it] = nil
	end
end


--XG_UI_ToolTip_Item_GetFrame(frameName)
Xfunc['XG_UI_ToolTip_Item_GetFrame'] = function ()
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
		ui.commit
		ui.desc
		ui.name
		ui.icon
		ui.manaIcon
		ui.goldIcon
		ui.lumberIcon
		ui.manaText
		ui.goldText
		ui.lumberText
	]]
	local ret = ui[ frameName ]
	if type(ret) ~= "number" then
		ret = 0
	end
	XGJAPI.integer[0] = ret or 0
end

Xfunc['XG_UI_ToolTip_Item_SetFrame'] = function ()
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

Xfunc['XG_UI_ToolTip_Item_SetBoolConstant'] = function ()
	local param = XGJAPI.string[1] or ''
	local value = XGJAPI.bool[2] == true

	if param == 'isShowTooltipForItemOnTheGround' then
		if isShowTooltipForItemOnTheGround ~= nil then
			return
		end
		isShowTooltipForItemOnTheGround = value
		if value then
			DzFrameSetUpdateCallbackByCode( code_frame_tick )
		end
	end

end
