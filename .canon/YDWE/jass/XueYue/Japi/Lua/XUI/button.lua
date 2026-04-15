local MOUSE_LEFT = xconst.mouse.MOUSE_LEFT
--local mouse = require 'XG_JAPI.Lua.Mouse'
---@class xui.button : XUI
---@field value string text字符串
---@field image string img路径:当前显示图片
local class = {
    xui = 'button',
    type = 'class',
    image_active = 'ui\\ButtonActive.blp',
    image_normal = 'ui\\ButtonNormal.blp',
    image_down = 'ui\\ButtonDown.blp',

    on_sys_enter =  function (self, frame, x, y)
        local stat = self.state
        if stat == 'disable' then
            return
        end

        self.state = 'active'

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

        self.state = 'normal'
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
            self.state = 'down'
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
            self.state = 'active'
        end

        local on = self.on_click
        if type(on) == "function" then
            on(self, key)
        end

    end,
}
---@class xui.button
xui.button = class
xui:extends(xui.base)( class )
local constFrame = xconst.frame

---@return xui.button
function xui.button:new( params, textTemplate )
    ---@class xui.button
    local shell = self:shell()

    --背景
    shell.frame_background = xui.img:new{
        parent = params.parent,
    }
    --触发器
    shell.frame_trigger = xui.text:new(
        {
            parent = shell.frame_background,
            align = constFrame.ALIGN_C, --文字居中
            template = textTemplate or '',
        }
    )
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
    assert(type(callback)=='function', 'button(xui):event callback类型错误')
    eventName = map_evt_tp[eventName]
    assert(eventName, 'button(xui):event eventName==nil' )
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

    this.frame_background.image = this[ 'image_' .. stat ]
end )

class:set_property( 'value', 'set', function (class, this, key, value)
    this.data[key] = value

    this.frame_trigger.value = this[key]
end )


local list

list = {'image','visible',}

local img_prop = function (class, this, key, value)
    this.data[key] = value
    this.frame_background[key] = value
    
end

for i, v in ipairs(list) do
    class:set_property( v, 'set', img_prop )
end

local xy_prop = function (class, this, key, value)
    this.data[key] = value
    this.frame_background[key] = value
    --if key == 'y' and this.parent.xui == 'panel' then
    --    this.visible = value >= 0 and value + this.h <=1
    --end
end

--class:set_property( 'x', 'set', xy_prop )
--class:set_property( 'y', 'set', xy_prop )

list = {'w','h',}

local general_set_property = function (class, this, key, value)
    this.data[key] = value
    this.frame_background[key] = value
end

for i, v in ipairs(list) do
    class:set_property( v, 'set', general_set_property )
end
class:set_property( 'enable', 'set', function (class, this, key, value)
    this.data[key] = value
    this.frame_trigger[key] = value
end )
