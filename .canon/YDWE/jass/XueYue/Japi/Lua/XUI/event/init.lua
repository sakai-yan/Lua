--[[
    雪月框架    UI事件库    v1.0
    
]]
local DzGetMouseFocus         = japi.DzGetMouseFocus
local EVENT_MOUSE_PRESS       = xconst.frame.EVENT_MOUSE_PRESS
local EVENT_MOUSE_RELEASE     = xconst.frame.EVENT_MOUSE_RELEASE

local EVENT_MOUSE_WHEEL       = xconst.frame.EVENT_MOUSE_WHEEL

local EVENT_MOUSE_MOVE        = xconst.frame.EVENT_MOUSE_MOVE

local EVENT_MOUSE_CLICK       = xconst.frame.EVENT_MOUSE_CLICK
local EVENT_MOUSE_DOUBLECLICK = xconst.frame.EVENT_MOUSE_DOUBLECLICK

--Frame专用
local EVENT_MOUSE_ENTER       = xconst.frame.EVENT_MOUSE_ENTER
local EVENT_MOUSE_LEAVE       = xconst.frame.EVENT_MOUSE_LEAVE
local EVENT_MOUSE_DRAG        = xconst.frame.EVENT_MOUSE_DRAG
local EVENT_MOUSE_DROP        = xconst.frame.EVENT_MOUSE_DROP
local abs = math.abs

local mouse = require ( xconst.module.MOUSE )

---@class cFrameEvent
local class = {
    on_drag = function (obj, frame, x, y)
        
    end,
    on_drop = function (obj, frame, x, y)
        
    end,
}
class.__index = class

xui_event = {}
xui.event = xui_event
local xui = xui

--设置拖放全局回调
---@param callback fun( obj:XUI, frame:int, x:real, y:real )
function xui_event:setDropCallback( callback )
    class.on_drop = callback
end

--设置拖拽全局回调,返回true则表示进入拖拽状态
---@param callback fun( obj:XUI, frame:int, x:real, y:real ):bool
function xui_event:setDragCallback( callback )
    class.on_drag = callback
end

---为frame注册一个事件
---@param frame int 原生frame的hadnleId
---@param eventType int 事件类型 xconst.frame.EVENT_MOUSE_PRESS
---@param callback fun(event, ...)
function class:event( frame, eventType, callback )
    ---@type EventPool
    local pool = self[eventType]
    assert(pool, '为Frame注册事件时事件类型似乎传错了' )
    local evt = pool:new( frame )
    evt.on_update = callback
    return evt
end


local evt_map = {
    [EVENT_MOUSE_RELEASE] = 'release',
    [EVENT_MOUSE_PRESS] = 'press',
    [EVENT_MOUSE_WHEEL] = 'wheel',
    [EVENT_MOUSE_MOVE] = 'move',
    [EVENT_MOUSE_DOUBLECLICK] = 'doubleclick',
    [EVENT_MOUSE_CLICK] = 'click',
    [EVENT_MOUSE_LEAVE] = 'leave',
    [EVENT_MOUSE_ENTER] = 'enter',
    [EVENT_MOUSE_DRAG] = 'drag',
    [EVENT_MOUSE_DROP] = 'drop',
}
---触发事件
---@param frame int 触发事件的frame
---@param eventType int 事件类型 xconst.frame.EVENT_MOUSE_PRESS
---@param ... any 按键 滚动值 x y
function class:exec(frame, eventType, ...)
    local obj = xui:h2o( frame )
    if not obj then
        return
    end

    local evtName = evt_map[eventType]
    assert(evtName, 'xui.event:exec( evtName == nil )')

    local on = obj[ 'on_sys_' .. evt_map[eventType] ]
    if not on then
        return
    end

    on( obj, frame, ... )
end

local frame_click = 0     --当前按下的frame
local __lastclick = 0 --最后点击的frame
local __lastFocus = 0
local state_drag = false
---重置
function class:reset()
        self:del()
        ---@type EventPool 事件类
        self[EVENT_MOUSE_RELEASE]     = eventpool:new( 'EVENT_MOUSE_RELEASE' )
        self[EVENT_MOUSE_PRESS]       = eventpool:new( 'EVENT_MOUSE_PRESS' )
        self[EVENT_MOUSE_WHEEL]       = eventpool:new( 'EVENT_MOUSE_WHEEL' )
        self[EVENT_MOUSE_MOVE]        = eventpool:new( 'EVENT_MOUSE_MOVE' )
        self[EVENT_MOUSE_DOUBLECLICK] = eventpool:new( 'EVENT_MOUSE_DOUBLECLICK' )
        self[EVENT_MOUSE_CLICK]       = eventpool:new( 'EVENT_MOUSE_CLICK' )
        self[EVENT_MOUSE_LEAVE]       = eventpool:new( 'EVENT_MOUSE_LEAVE' )
        self[EVENT_MOUSE_ENTER]       = eventpool:new( 'EVENT_MOUSE_ENTER' )
        self[EVENT_MOUSE_DRAG]        = eventpool:new( 'EVENT_MOUSE_DRAG' )
        self[EVENT_MOUSE_DROP]        = eventpool:new( 'EVENT_MOUSE_DROP' )
        frame_click = 0
        __lastclick = 0
        __lastFocus = 0
end

---自毁类
function class:del()
    if not self[EVENT_MOUSE_RELEASE] then
        return
    end

    self[EVENT_MOUSE_RELEASE]:del()
    self[EVENT_MOUSE_RELEASE] = nil

    self[EVENT_MOUSE_PRESS]:del()

    self[EVENT_MOUSE_PRESS] = nil

    self[EVENT_MOUSE_WHEEL]:del()
    self[EVENT_MOUSE_WHEEL] = nil

    self[EVENT_MOUSE_MOVE]:del()
    self[EVENT_MOUSE_MOVE] = nil

    self[EVENT_MOUSE_DOUBLECLICK]:del()
    self[EVENT_MOUSE_DOUBLECLICK] = nil

    self[EVENT_MOUSE_CLICK]:del()
    self[EVENT_MOUSE_CLICK] = nil

    self[EVENT_MOUSE_LEAVE]:del()
    self[EVENT_MOUSE_LEAVE] = nil

    self[EVENT_MOUSE_ENTER]:del()
    self[EVENT_MOUSE_ENTER] = nil

    self[EVENT_MOUSE_DRAG]:del()
    self[EVENT_MOUSE_DRAG] = nil

    self[EVENT_MOUSE_DROP]:del()
    self[EVENT_MOUSE_DROP] = nil
end


local DzGetMouseXRelative = japi.DzGetMouseXRelative
local DzGetMouseYRelative = japi.DzGetMouseYRelative
local os_clock = os.clock
local xui = xui
local drag_x = -1
local drag_y = -1
mouse:event( '鼠标-按下', function (event, key)
    local frame = DzGetMouseFocus()
    frame_click = frame
    --press
    if frame == 0 then return end
    xui_event:exec( frame, EVENT_MOUSE_PRESS,  key )
    move_x = mouse.x
    move_y = mouse.y

    drag_x = mouse.x
    drag_y = mouse.y
end )

mouse:event( '鼠标-松开', function (event, key)
    local frame = DzGetMouseFocus()
    if frame_click == 0  then
         return
    end

    --先响应离开进入再响应松开
    if frame_click ~= frame then
        xui_event:exec( frame_click, EVENT_MOUSE_LEAVE, frame_click, DzGetMouseXRelative(), DzGetMouseYRelative() )
        --xui_event:exec( frame, EVENT_MOUSE_ENTER, frame, DzGetMouseXRelative(), DzGetMouseYRelative() )
    end

    xui_event:exec( frame, EVENT_MOUSE_RELEASE,   key )

    if frame_click ~= 0  then
        xui_event:exec( frame, EVENT_MOUSE_DROP,   key )
        local h = xui:h2o( frame )
        if state_drag then
            class.on_drop( h, frame, DzGetMouseXRelative(), DzGetMouseYRelative() )
        end
        state_drag = false
        drag_x = -1
        drag_y = -1
    end

    if frame_click == frame then
        --click
        xui_event:exec( frame, EVENT_MOUSE_CLICK,   key )
        --doubleClick
        local newtime = os_clock()
        if newtime - __lastclick < 0.3 then
            __lastclick = 0
            xui_event:exec( frame, EVENT_MOUSE_DOUBLECLICK,   key )
        else
            __lastclick = newtime
        end

    end


    frame_click = 0
end )

mouse:event( '鼠标-复位', function (event, key)
    local frame = DzGetMouseFocus()
    if frame_click == 0  then
         return
    end

    --先响应离开进入再响应松开
    if frame_click ~= 0 then
        xui_event:exec( frame_click, EVENT_MOUSE_LEAVE, frame_click, DzGetMouseXRelative(), DzGetMouseYRelative() )
    end

    if frame ~= 0 then
        xui_event:exec( frame, EVENT_MOUSE_ENTER, frame, DzGetMouseXRelative(), DzGetMouseYRelative() )
    end
    frame_click = 0
end )


mouse:event( '鼠标-滚轮', function (event, delta)
    local frame = DzGetMouseFocus()
    --wheel
    if frame == 0 then return end
    xui_event:exec( frame, EVENT_MOUSE_WHEEL,  delta )
end )

local private_last_drag_time = 0
local private_last_drag_frame

mouse:event( '鼠标-移动', function (event, x, y)
    local frame =  DzGetMouseFocus()
    if frame ~= 0 then
        xui_event:exec( frame, EVENT_MOUSE_MOVE,  x, y )
    end
    if drag_x > -1 and ( abs( drag_x-x ) >5/xui.width or abs( drag_y-y ) >5/xui.height ) then
        
        --xui_event:exec( frame, EVENT_MOUSE_DRAG,  drag_x, drag_y, x, y )
        --全局drag事件回调
        state_drag = class.on_drag( xui:h2o( frame ), frame, DzGetMouseXRelative(), DzGetMouseYRelative() )
        drag_x = -1
        drag_y = -1
    end

    if  __lastFocus ~= frame then

        --leave
        if __lastFocus ~= 0 and frame_click ~= __lastFocus then
            xui_event:exec( __lastFocus, EVENT_MOUSE_LEAVE,  x, y )
        end

        __lastFocus = frame

        --enter
        if frame ~= 0 and frame_click ~= frame  then
            xui_event:exec( frame, EVENT_MOUSE_ENTER,  x, y )
        end

    end

    if frame_click  == 0 then
        return
    end
    if move_x == x and move_y == y then
        return
    end

    local cur_clock = os_clock()
    if private_last_drag_time + 0.03 <= cur_clock then
        private_last_drag_time = cur_clock
        --控件内部drag事件
        xui_event:exec( frame_click, EVENT_MOUSE_DRAG, mouse.key, x, y )
    end

    move_x = x
    move_y = y
end )

setmetatable( xui.event, class )
xui.event:reset()