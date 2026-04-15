--[[
    雪月框架    Mouse 库  v1.1
    捕捉鼠标用的库

    取消鼠标对象。直接注册事件
]]
local DzTriggerRegisterMouseMoveEventByCode  = japi.DzTriggerRegisterMouseMoveEventByCode
local DzGetMouseXRelative                    = japi.DzGetMouseXRelative
local DzGetMouseYRelative                    = japi.DzGetMouseYRelative
local DzTriggerRegisterMouseEventByCode      = japi.DzTriggerRegisterMouseEventByCode
local DzGetWheelDelta                        = japi.DzGetWheelDelta
local DzTriggerRegisterMouseWheelEventByCode = japi.DzTriggerRegisterMouseWheelEventByCode

local eMouse = eventpool:new( '鼠标事件' )

local eventNmae_press = '鼠标-按下'

local eventNmae_release = '鼠标-松开'

local eventNmae_click = '鼠标-点击'

local eventNmae_doubleClick = '鼠标-双击'

local eventNmae_move = '鼠标-移动'

local eventNmae_wheel = '鼠标-滚轮'

local eventNmae_reset = '鼠标-复位'


local timer = require 'XG_JAPI.Lua.Time.Timer'
local window = require "XG_JAPI.Lua.Window"

--按键

local MOUSE_LEFT = xconst.mouse.MOUSE_LEFT
local MOUSE_RIGHT = xconst.mouse.MOUSE_RIGHT

--事件

local MOUSE_PRESS = xconst.mouse.MOUSE_PRESS
local MOUSE_RELEASE = xconst.mouse.MOUSE_RELEASE

local EVENT_MOUSE_PRESS = xconst.mouse.EVENT_MOUSE_PRESS
local EVENT_MOUSE_RELEASE = xconst.mouse.EVENT_MOUSE_RELEASE

--[[

local EVENT_MOUSE_WHEEL = xconst.mouse.EVENT_MOUSE_WHEEL

local EVENT_MOUSE_MOVE = xconst.mouse.EVENT_MOUSE_MOVE

local EVENT_MOUSE_CLICK = xconst.mouse.EVENT_MOUSE_CLICK
local EVENT_MOUSE_DOUBLECLICK = xconst.mouse.EVENT_MOUSE_DOUBLECLICK

]]

---@class mouse
local mMouse = {
    type = 'module',
    module = 'mouse',

    eMouse = eMouse,
    is_key_down = false,
    key = 0,
    --鼠标当前坐标%
    x = 0,
    y = 0,

}
mMouse.__index = mMouse

-------------------------------------------

---@param eventName string 事件名:  鼠标-按下|松开|点击|双击|移动|滚轮  详情查看module\mouse
---@param callback fun( event:event, ...:any) 回调函数 框架自带事件通常只有两个参数 1个event ...根据事件为 key delta x y
---@return event|nil 如果事件不存在返回nil
function mMouse:event( eventName, callback )
    ---@type event 指定对象事件 通过params获取返回的事件
    local event = eMouse:new( eventName )
    if event then
        event.on_update = callback
    end
    return event
end

------------------------------------------

local __key   = 0   --当前按下的按键
local __click = 0   --os.clock() 用来判断与上一次点击间隔
local os_clock = os.clock
--@private 鼠标回调
local function Event_Mouse_Key_Callback(key, evt)

    if evt == EVENT_MOUSE_PRESS then
        
        if __key == key then
            --同一个鼠标按键按两次？
        elseif __key == 0 then
            --之前还未按下 现在按下
            __key = key
            mMouse.is_key_down = true
            mMouse.key = key

            eMouse:update( eventNmae_press, key )
        else
            --按键不同 例如 按下左键后 发现按错了 可以按下右键 来取消按键事件 反之亦可
            __key = 0
            mMouse.is_key_down = false
            mMouse.key = 0
            --鼠标复位
            eMouse:update( eventNmae_reset, key )
        end
    else --鼠标释放
        mMouse.is_key_down = false
        mMouse.key = 0
        if __key == key then --按下和放开的是同一个按键
            eMouse:update( eventNmae_release, key )
            __key = 0 -- 复位
            local t = os_clock()
            if t - __click < 0.3 then
                __click = t
                eMouse:update( eventNmae_doubleClick, key )
            else
                __click = 0
                eMouse:update( eventNmae_click, key )
            end
            
        else
            __key = 0
        end
    end

end

local function Event_Mouse_Left_Press()      Event_Mouse_Key_Callback( MOUSE_LEFT, EVENT_MOUSE_PRESS )      end
local function Event_Mouse_Left_Release()    Event_Mouse_Key_Callback( MOUSE_LEFT, EVENT_MOUSE_RELEASE )    end
local function Event_Mouse_Right_Press()      Event_Mouse_Key_Callback( MOUSE_RIGHT, EVENT_MOUSE_PRESS )      end
local function Event_Mouse_Right_Release()    Event_Mouse_Key_Callback( MOUSE_RIGHT, EVENT_MOUSE_RELEASE )    end


local function Event_Mouse_Move()
    local x = DzGetMouseXRelative()/window:getWidth() --相对游戏窗口x
    local y = DzGetMouseYRelative()/window:getHeight()

    mMouse.x = x
    mMouse.y = y
    eMouse:update( eventNmae_move, x, y )
end

local function Event_Mouse_Wheel()
    local delta = DzGetWheelDelta()

    eMouse:update( eventNmae_wheel, delta )
end



timer:once(0.01,function ()
    DzTriggerRegisterMouseEventByCode( nil, MOUSE_LEFT, MOUSE_PRESS, false, Event_Mouse_Left_Press)
    DzTriggerRegisterMouseEventByCode( nil, MOUSE_LEFT, MOUSE_RELEASE, false, Event_Mouse_Left_Release)

    DzTriggerRegisterMouseEventByCode( nil, MOUSE_RIGHT, MOUSE_PRESS, false, Event_Mouse_Right_Press)
    DzTriggerRegisterMouseEventByCode( nil, MOUSE_RIGHT, MOUSE_RELEASE, false, Event_Mouse_Right_Release)

    DzTriggerRegisterMouseMoveEventByCode(nil, false, Event_Mouse_Move)


    DzTriggerRegisterMouseWheelEventByCode(nil, false, Event_Mouse_Wheel)
end)

return mMouse