---@type mouse
local mouse = require ( xconst.module.MOUSE )
local MOUSE_LEFT = xconst.mouse.MOUSE_LEFT
---@class xui.panel : XUI
local class = {
    xui = 'panel',
    stat = 'normal',
    draggable = false,
    pressX = 0,
    pressY = 0,
    on_sys_wheel = function (self, frame, delta)
        if self.state == 'disable' then
            return
        end

        local on = self.on_wheel
        if type(on) == "function" then
            on(self, delta)
        end

        self.frame_vScroll:on_sys_wheel( frame, delta )

    end,
    on_sys_press = function (self, frame, key)
        if not self.enable then
            return
        end

        if key == MOUSE_LEFT then
            self.state = 'down'
        else
            return
        end

        if not self.draggable then
            return
        end

        --鼠标在滚动条上位置的占比
        local loc_x = ( mouse.x  - self.x)
        local loc_y = ( mouse.y  - self.y)
        --将占比转化为控件占比
        --local fix_x = loc_x  / (self.real_w)
        --local fix_y = loc_y  / (self.real_h)

        self.pressX = loc_x
        self.pressY = loc_y

    end,
    on_sys_drag = function (self, frame, key, x, y)
        if not self.enable then
            return
        end
        if key ~= MOUSE_LEFT then
            return
        end

        if not self.draggable then
            return
        end

        self.x = mouse.x - self.pressX
        self.y = mouse.y - self.pressY
    end,
}
---@class xui.panel
xui.panel = class
xui:extends(xui.base)( class )
local _point = xconst.frame
---@return xui.panel
function xui.panel:new( params )
    ---@class xui.panel
    local shell = self:shell()
    --面板背景
    shell.frame_background = xui.img:new {
        parent = params.parent,
        template = params.template,
    }

    if not params.template then
        shell.frame_background.image = 'XG_JAPI\\Lua\\XUI\\ui\\Panel.blp'
    end

    --触发器
    shell.frame_trigger = xui.text:new {
        parent = shell.frame_background,
    }
    japi.DzFrameSetPoint( shell.frame_trigger.frame, _point.POINT_LT, shell.frame_background.frame, _point.POINT_LT, 0, 0  )
    japi.DzFrameSetPoint( shell.frame_trigger.frame, _point.POINT_RB, shell.frame_background.frame, _point.POINT_RB, 0, 0  )

    --关闭按钮
    shell.frame_closeButton = xui.button:new {
        parent = shell.frame_background,
        visible = params.hasCloseButton and true or false,
        x = 0.92,
        y = 0,
        w = 0.08,
        h = 0.1,
        --value = '×'
    }

    shell.frame_closeButton.image_normal = "XG_JAPI\\Lua\\XUI\\ui\\close_normal.blp"
    shell.frame_closeButton.image_active = "XG_JAPI\\Lua\\XUI\\ui\\close_light.blp"
    shell.frame_closeButton.image_down = "XG_JAPI\\Lua\\XUI\\ui\\close_down.blp"
    shell.frame_closeButton.image = shell.frame_closeButton.image_normal

    --垂直滚动条
    shell.frame_vScroll = xui.verticalscrollbar:new{
        parent = shell.frame_background,
        x = 0.92,
        w = 0.05,
        y = 0.105 - (params.hasCloseButton and 0 or 0.05),
        h = 0.86 + (params.hasCloseButton and 0 or 0.05),
        visible = params.hasScrollBar and true or false,
    }

    --Init
    shell:init()
    return shell + params
end

function xui.panel:del()
    self.frame_background:del()
    self.frame_trigger:del()
    self.frame_vScroll:del()
    self.frame_closeButton:del()
end

function class:init( )
    xui:save( self.frame_trigger.frame, self )
    local vScrollBar = self.frame_vScroll

    vScrollBar:event( 'value_change', function (scroll, value)
        for index, child in ipairs(self.childs) do

            if child ~= vScrollBar then
                child.y = child.y + vScrollBar.value - value
            end

        end
    end )

    self.frame_closeButton:event( 'click',
        function (btn)
            self.visible = false
        end
    )
end

--转发值


local img_prop = function (class, this, key, value)
    this.data[key] = value
    this.frame_background[key] = value
    if key == 'x' or key == 'y' then
        this:refresh()
    end
end

local list
list = {'x','y', 'image'}

for i, v in ipairs(list) do
    xui.panel:set_property( v, 'set', img_prop )
end


list = {'w','h','enable','visible',}

local general_set_property = function (class, this, key, value)
    this.data[key] = value
    this.frame_background[key] = value
    this.frame_trigger[key] = value
    if key == 'w' or key == 'h' then
        this:refresh()
    end
end

for i, v in ipairs(list) do
    xui.panel:set_property( v, 'set', general_set_property )
end

class:set_property( 'frame', 'get', function (class, this, key)
    return this.frame_background.frame
end )
