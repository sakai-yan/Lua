local MOUSE_LEFT = xconst.mouse.MOUSE_LEFT
local mouse = require ( xconst.module.MOUSE )

---@class xui.vScrollBar : XUI
local class = {
    xui = 'vScrollBar',
    image_active = 'ui\\VerticalScrollBar.blp',
    image_normal = 'ui\\VerticalScrollBar.blp',
    image_down = 'ui\\VerticalScrollBar.blp',
    value = 0.0, --滚动值 0.0~1.0
    page = 0.15, --每页占比(按钮长度) 0.0~1.0
    max = 1,    --滚动最大值
    pressY = 0,

    on_sys_enter =  function (self, frame, x, y)
        local stat = self.state
        if not self.enable then
            return
        end
        if frame ~= self.frame_trigger.frame then
            return
        end
        self.state = 'active'
    end,

    on_sys_leave = function (self, frame, x, y)
        local stat = self.state
        if not self.enable then
            return
        end
        if frame ~= self.frame_trigger.frame then
            return
        end
        self.state = 'normal'

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

        --鼠标在滚动条上位置的占比
        local loc = ( mouse.y  - self.real_y)
        --将占比转化为控件占比
        local fix_y = loc  / (self.real_h)

        if frame == self.frame_trigger_BG.frame then
            self.value = fix_y * self.max
        end

        self.pressV = self.value
        self.pressY = mouse.y

    end,

    on_sys_release = function (self, frame, key)
        if not self.enable then
            return
        end
        if frame ~= self.frame_trigger.frame then
            return
        end

        if key == MOUSE_LEFT then
            self.state = 'active'
        end

    end,

    on_sys_wheel = function (self, frame, delta)
        if not self.enable then
            return
        end

        local on = self.on_wheel
        if type(on) == "function" then
            on(self, delta)
        end

        self.value = self.value + delta*-0.01 * self.page

    end,

    on_sys_click = function (self, frame, key)
        if not self.enable then
            return
        end
        if frame ~= self.frame_trigger.frame then
            return
        end

        if key == MOUSE_LEFT then
            self.state = 'active'
        end

    end,

    on_sys_drag = function (self, frame, key, x, y)
        if not self.enable then
            return
        end
        if key ~= MOUSE_LEFT then
            return
        end

        --鼠标移动的百分比
        local loc = ( mouse.y - self.pressY )
        --将占比转化为控件占比
        local fix_y = loc  / (self.real_h)
        self.value = (self.pressV + fix_y * self.max)

    end,
}
---@class xui.vScrollBar
xui.verticalscrollbar = class
xui:extends(xui.base)( class )
local constFrame = xconst.frame
---@return xui.vScrollBar
function xui.verticalscrollbar:new( params )
    ---@class xui.vScrollBar
    local shell = self:shell()
    shell.xui = 'verticalscrollbar'
    --滚动条背景
    shell.frame_background = xui.img:new  {
        parent = params.parent,
        image = 'ui\\blank.blp',
    }
    --滚动背景触发器
    shell.frame_trigger_BG = xui.text:new {
        parent = shell.frame_background,
    }

    --滚动条按钮背景
    shell.frame_btnbg = xui.img:new {
        parent = shell.frame_background,
    }
    --滚动按钮触发器
    shell.frame_trigger = xui.text:new {
        parent = shell.frame_btnbg,
    }

    japi.DzFrameSetPoint( shell.frame_trigger_BG.frame, constFrame.POINT_LT, shell.frame_background.frame, constFrame.POINT_LT, 0, 0  )
    japi.DzFrameSetPoint( shell.frame_trigger_BG.frame, constFrame.POINT_RB, shell.frame_background.frame, constFrame.POINT_RB, 0, 0  )

    japi.DzFrameSetPoint( shell.frame_trigger.frame, constFrame.POINT_LT, shell.frame_btnbg.frame, constFrame.POINT_LT, 0, 0  )
    japi.DzFrameSetPoint( shell.frame_trigger.frame, constFrame.POINT_RB, shell.frame_btnbg.frame, constFrame.POINT_RB, 0, 0  )
    shell:init()
    xui:save(
        shell.frame_trigger.frame,
        shell
    )
    xui:save(
        shell.frame_trigger_BG.frame,
        shell
    )

    return shell + params
end


function class:init( )
    self.state = 'normal'
    self.evts = {}

end

local map_evt_tp = {
    ['值改变'] = 'value_change',
    ['value_change'] = 'value_change', --携带新的值，旧的值暂未变化，请返回一个新的值
}


---注册事件
---@param eventName string 事件名中文英文皆可,英文注意小写 值改变 value_change
---@param callback fun(...)
function class:event( eventName, callback )
    assert(type(callback)=='function', 'vScrollBar(xui):event callback类型错误')
    eventName = map_evt_tp[eventName]
    assert(eventName, 'vScrollBar(xui):event eventName==nil' )
    self [ 'on_' .. eventName ] = callback
end

--对象使用类方法
function class:del()
    xui:save(
        self.frame_trigger.frame,
        nil
    )
    xui:save(
        self.frame_trigger_BG.frame,
        nil
    )

    for index, child in ipairs(self.childs) do
        child:del()
    end
end

-------------------------
--    值转发给底层控件
-------------------------

class:set_property( 'state', 'set', function (class, this, key, value)
    this.data[key] = value
    local stat = this.state

    this.frame_btnbg.image = this[ 'image_' .. stat ]

    this.enable = stat ~= 'disable'
end )

local resetBtnPos = function (this)
    local btn = this.frame_btnbg

    btn.x = 0
    btn.w = 1.0

    btn.y = this.value / this.max

    btn.h = this.page
end

class:set_property( 'w', 'set', function (class, this, key, value)
    this.data[key] = value
    this.frame_background[key] = value
    resetBtnPos(this)
end )

class:set_property( 'h', 'set', function (class, this, key, value)
    this.data[key] = value
    this.frame_background[key] = value
    resetBtnPos(this)
end )

--每页百分比 也就是按钮的高度
class:set_property( 'page', 'set', function (class, this, key, value)
    if value < 0.1 then
        value = 0.1
    end
    this.data[key] = value or 0.1
    resetBtnPos(this)
end )

class:set_property( 'value', 'set', function (class, this, key, value)

    local newH = this.page

    if newH < 0.1 then
        newH = 0.1
    end
    newH = newH * this.max
    if value + newH > this.max then
        value = this.max - newH
    elseif value < 0 then
        value = 0
    end

    if value == this.value then
        return
    end

    local on = this['on_value_change']
    if type(on) == 'function' then
        value = on(this, value) or value
        if value + newH > this.max then
            value = this.max - newH
        elseif value < 0 then
            value = 0
        end
    end
    this.data[key] = value or 0

    resetBtnPos(this)
end )

local list

list = {'visible'}

local img_prop = function (class, this, key, value)
    this.data[key] = value
    this.frame_background[key] = value
end

for i, v in ipairs(list) do
    class:set_property( v, 'set', img_prop )
end

class:set_property( 'enable', 'set', function (class, this, key, value)
    this.data[key] = value
    this.frame_background[key] = value
end )

