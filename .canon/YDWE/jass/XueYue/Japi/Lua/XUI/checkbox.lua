local MOUSE_LEFT = xconst.mouse.MOUSE_LEFT
local mouse = require 'XG_JAPI.Lua.Mouse'
---@class xui.checkbox : XUI
local class = {
    xui = 'checkbox',
    type = 'class',
    image_normal = 'ui\\CheckBoxNormal.blp',
    image_active = 'ui\\CheckBoxActive.blp',
    image_checked = 'ui\\CheckBoxChecked.blp',
    checked = false,

    on_sys_enter =  function (self, frame, x, y)
        local stat = self.state
        if stat == 'disable' then
            return
        end

        self.state = self.checked and 'checked' or 'active'

        local on = self.on_enter
        if type(on) == "function" then
            on(self, x, y)
        end
    end,

    on_sys_leave = function (self, frame, x, y)
        local stat = self.state
        if stat == 'disable' then
            return
        end

        self.state = self.checked and 'checked' or 'normal'

        local on = self.on_leave
        if type(on) == "function" then
            on(self, x, y)
        end
    end,

    on_sys_press = function (self, frame, key)
        if self.state == 'disable' then
            return
        end

        if key == MOUSE_LEFT then
            self.state = 'checked'
        end

        local on = self.on_press
        if type(on) == "function" then
            on(self, key)
        end
    end,

    on_sys_release = function (self, frame, key)
        if self.state == 'disable' then
            return
        end

        if key == MOUSE_LEFT then
            self.state = 'active'
        end

        local on = self.on_release
        if type(on) == "function" then
            on(self, key)
        end
    end,

    on_sys_wheel = function (self, frame, key)
        if self.state == 'disable' then
            return
        end

        local on = self.on_wheel
        if type(on) == "function" then
            on(self, key)
        end
        if self.parent.xui == 'panel' then
            self.parent:on_sys_wheel(frame,key)
        end
    end,

    on_sys_click = function (self, frame, key)
        if self.state == 'disable' then
            return
        end

        if key == MOUSE_LEFT then
            self.checked = not self.checked
            self.state = self.checked and 'checked' or 'active'
        end

        local on = self.on_click
        if type(on) == "function" then
            on(self, key)
        end

    end,
}
---@class xui.checkbox
xui.checkbox = class
xui:extends(xui.base)( class )
local constFrame = xconst.frame
---@return xui.checkbox
function xui.checkbox:new( params, textTemplate )
    ---@class xui.checkbox
    local shell = self:shell()
    --背景
    shell.frame_background = xui.img:new{
        parent = params.parent,
        template = 'xui_img_alpha',
    }

    shell.frame_icon = xui.img:new{
        parent = shell.frame_background,
    }
    shell.frame_text = xui.text:new{
        parent = shell.frame_background,
        --align = constFrame.ALIGN_L,
        template = textTemplate,
        disable = true,
    }
    --触发器
    shell.frame_trigger = xui.text:new{
        parent = shell.frame_background,
    }
    japi.DzFrameSetPoint( shell.frame_trigger.frame, constFrame.POINT_LT, shell.frame_background.frame, constFrame.POINT_LT, 0, 0  )
    japi.DzFrameSetPoint( shell.frame_trigger.frame, constFrame.POINT_RB, shell.frame_background.frame, constFrame.POINT_RB, 0, 0  )

    shell:init()
    xui:save(
        shell.frame_trigger.frame,
        shell
    )

    return shell + params
end


function class:init( )
    self.state = 'normal'
    self.evts = {}

end

local map_evt_tp = {
    ['按下'] = 'press',
    ['press'] = 'press',

    ['松开'] = 'release',
    ['release'] = 'release',

    ['进入'] = 'enter',
    ['enter'] = 'enter',

    ['离开'] = 'leave',
    ['leave'] = 'leave',

    ['点击'] = 'click',
    ['click'] = 'click',

    ['滚轮'] = 'wheel',
    ['wheel'] = 'wheel',
}


---为按钮注册事件
---@param eventName string 事件名中文英文皆可,英文注意小写 按下 press 松开 release 进入 enter 离开 leave 点击 click
---@param callback fun(...)
function class:event( eventName, callback )
    assert(type(callback)=='function', 'checkbox(xui):event callback类型错误')
    eventName = map_evt_tp[eventName]
    assert(eventName, 'checkbox(xui):event eventName==nil' )
    self [ 'on_' .. eventName ] = callback
end

--对象使用类方法
function class:del()
    xui:save(
        self.frame_trigger.frame,
        nil
    )
    self.frame_trigger:del()
    self.frame_background:del()
end

-------------------------
--    值转发给底层控件
-------------------------

class:set_property( 'state', 'set', function (class, this, key, value)
    this.data[key] = value
    local stat = this.state
    this.frame_icon.image = this[ 'image_' .. stat ]
end )

class:set_property( 'value', 'set', function (class, this, key, value)
    this.data[key] = value
    this.frame_text.value = this[key]
end )


local hook_prop = {
    h = class:get_property('h', 'set'),
    w = class:get_property('w', 'set'),
    y = class:get_property('y', 'set'),
    x = class:get_property('x', 'set'),
}
local prop_wh = function (class, this, key, value)
    hook_prop[key](class, this, key, value)
    this.frame_icon.x = 0
    this.frame_icon.y = 0.05

    this.frame_icon.h = this:a2rV(24)
    this.frame_icon.w = this:a2rH(24)

    this.frame_text.x = this.frame_icon.x + this.frame_icon.w + 0.01
    this.frame_text.y = 0

    this.frame_text.w = 1 - this.frame_icon.x - this.frame_icon.w
    this.frame_text.h = 1

end
class:set_property( 'w', 'set', prop_wh)
class:set_property( 'h', 'set', prop_wh)
class:set_property( 'x', 'set', prop_wh)
class:set_property( 'y', 'set', prop_wh)

class:set_property( 'enable', 'set', function (class, this, key, value)
    this.data[key] = value
    this.frame_trigger[key] = value
end )
