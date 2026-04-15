--[[
    窗口类

]]
local DzGetWindowX = japi.DzGetWindowX
local DzGetWindowY = japi.DzGetWindowY

local trg = trigger:new()
local eWindow = eventpool:new( '窗口事件' )

local eventNmae_resize = '窗口-尺寸变化'

local mWindow = {
    type = 'module',
    module = 'window',

    eWindow = eWindow,

    width = 0,      --窗口宽度
    height = 0,     --窗口高度

    offsetX = 0,    --窗口x偏移
    offsetY = 0,    --窗口y偏移
}

--- 获取窗口X坐标
---@param reference bool --参照系 T:窗口区域 F:用户区域
---@return real
function mWindow:getX( reference )
    local ret = DzGetWindowX()
    if reference then
        return ret
    end
    return ret + self.offsetX
end

--- 获取窗口Y坐标
---@param reference bool --参考 T:窗口区域 F:用户区域
---@return real
function mWindow:getY( reference )
    local ret = DzGetWindowY()
    if reference then
        return ret
    end
    return ret  + self.offsetY
end

--- 获取窗口X坐标偏移 也就是边框大小
---@return real
function mWindow:getOffsetX( )
    return self.offsetX
end

--- 获取窗口Y坐标偏移 也就是边框大小
---@return real
function mWindow:getOffsetY( )
    return self.offsetY
end

--- 获取窗口宽度
---@param reference bool --参考 T:窗口区域 F:用户区域
---@return real
function mWindow:getWidth( reference )
    local ret = self.width
    if reference then
        ret = ret  + self.offsetX
    end
    return ret
end

--- 获取窗口高度
---@param reference bool --参考 T:窗口区域 F:用户区域
---@return real
function mWindow:getHeight( reference )
    local ret = self.height
    if reference then
        ret = ret  + self.offsetX
    end
    return ret
end

local DzIsWindowActive = japi.DzIsWindowActive

--- 判断窗口是否激活状态
---@return bool
function mWindow:isActive()
    return DzIsWindowActive()
end

--用户区域
local DzGetClientWidth = japi.DzGetClientWidth
local DzGetClientHeight = japi.DzGetClientHeight

local DzGetMouseX = japi.DzGetMouseX
local DzGetMouseY = japi.DzGetMouseY
local DzGetMouseXRelative = japi.DzGetMouseXRelative
local DzGetMouseYRelative = japi.DzGetMouseYRelative


local windResize = function ()
    local w = DzGetClientWidth()
    local h = DzGetClientHeight()
    mWindow.width = w
    mWindow.height = h
    if mWindow:isActive() then
        mWindow.offsetX = DzGetMouseX() - DzGetMouseXRelative() - DzGetWindowX()
        mWindow.offsetY = DzGetMouseY() - DzGetMouseYRelative() - DzGetWindowY()
    end
    eWindow:update( eventNmae_resize, { width = w, height = h  } )
end

-- 注册事件
---@param event_name string 事件名: 窗口-尺寸变化
---@param func fun( event:event, params:table ) 回调函数 框架自带事件通常只有两个参数 1个event 一个table用于传参
---@return event|nil 如果事件不存在返回nil
function mWindow:event( event_name, func )
    local params = {
        type = 'window',
    }
    --注册单位类型事件
    eWindow:update('注册事件', params)
    --指定对象事件 通过params获取返回的事件
    local event = params.ret
    if event then
        event.on_update = func
    end
    return event
end

local DzTriggerRegisterWindowResizeEventByCode = japi.DzTriggerRegisterWindowResizeEventByCode

DzTriggerRegisterWindowResizeEventByCode( trg.handle, false, windResize )

--初始化一次
windResize()

return mWindow