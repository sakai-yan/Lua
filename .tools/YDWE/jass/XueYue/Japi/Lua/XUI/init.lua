--[[
    UI模块
]]
if xui then
    japi.DzLoadToc("XG_JAPI\\Lua\\XUI\\ui\\xui.toc")
    return
end
require "XG_JAPI.Lua.XUI.base"
require "XG_JAPI.Lua.XUI.img"
require "XG_JAPI.Lua.XUI.text"
require "XG_JAPI.Lua.XUI.edit"

require "XG_JAPI.Lua.XUI.icon"
require "XG_JAPI.Lua.XUI.slot"
require "XG_JAPI.Lua.XUI.button"
require "XG_JAPI.Lua.XUI.radiobox"
require "XG_JAPI.Lua.XUI.checkbox"
require "XG_JAPI.Lua.XUI.verticalscrollbar"
require "XG_JAPI.Lua.XUI.tile"

require 'XG_JAPI.Lua.XUI.event'

require "XG_JAPI.Lua.XUI.panel"
require "XG_JAPI.Lua.XUI.listview"

require 'XG_JAPI.Lua.XUI.Window'
require 'XG_JAPI.Lua.XUI.tooltip'


require 'XG_JAPI.Lua.XUI.game'
--[=[
require 'XG_JAPI.Lua.timer'

local DzFrameEditBlackBorders    = japi.DzFrameEditBlackBorders
local DzLoadToc                  = japi.DzLoadToc
local DzFrameShow                = japi.DzFrameShow
local DzFrameGetMinimapButton    = japi.DzFrameGetMinimapButton
local DzFrameGetMinimap          = japi.DzFrameGetMinimap
local DzFrameClearAllPoints      = japi.DzFrameClearAllPoints
local DzFrameSetPoint            = japi.DzFrameSetPoint
local DzFrameSetSize             = japi.DzFrameSetSize
local DzFrameGetTooltip          = japi.DzFrameGetTooltip
local DzFrameGetChatMessage      = japi.DzFrameGetChatMessage
local DzFrameGetUnitMessage      = japi.DzFrameGetUnitMessage
local DzFrameGetCommandBarButton = japi.DzFrameGetCommandBarButton
local DzFrameGetItemBarButton    = japi.DzFrameGetItemBarButton

--DzFrameHideInterface()
--DzFrameEditBlackBorders( 0, 0 )
DzLoadToc( "UI\\xglist.toc" )
]=]
