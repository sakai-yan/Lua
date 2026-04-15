---@type mouse
local mouse = require ( xconst.module.MOUSE )
local MOUSE_LEFT = xconst.mouse.MOUSE_LEFT
---@class xui.edit : XUI
local class =
{
    xui = 'edit',
    value = '', --文本内容
    font = 'Fonts\\dfst-m3u.ttf', --魔兽默认字体
    fontsize = 0.00,
    align = 0,
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
xui.edit = class
xui:extends(xui.base)( xui.edit )
---@return xui.edit
function class:new( params )
    if not params then params = {} end
    ---@class xui.edit
    local text = self:create( 'EDITBOX', params.name, params.parent, params.template, params.id )
    xui:save( text.frame, text )
    return text + params
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

local DzFrameSetText = japi.DzFrameSetText
class:set_property('value','set',function (class, this, key, value)
    --this.data[key] = value
    DzFrameSetText( this.frame , value )
end)

local DzFrameGetText = japi.DzFrameGetText
class:set_property('value', 'get', function (class, this, key, value)
    local s = DzFrameGetText( this.frame )
    return s
end)

local DzFrameSetFont = japi.DzFrameSetFont
class:set_property('font','set',function (class, this, key, value)
    if value == '' or value == nil then
        this.data[key] = 'Fonts\\dfst-m3u.ttf'
    else
        this.data[key] = value
    end
    DzFrameSetFont( this.frame, this.font, this.fontsize, 0) --[[flag]]
end)

class:set_property('fontsize','set',function (class, this, key, value)
    this.data[key] = value
    DzFrameSetFont( this.frame, this.font, this.fontsize, 0)
end)

local DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment
class:set_property('align','set',function (class, this, key, value)
    this.data[key] = value
    DzFrameSetTextAlignment(this.frame, 100)
    DzFrameSetTextAlignment(this.frame, this.align)
end)



