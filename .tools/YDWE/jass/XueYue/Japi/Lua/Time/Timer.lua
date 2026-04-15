--[[
    中心计时器模块 v1.3
        采用ac timer的思路
        修复    del循环计时器导致错误
        修复    非当前队列 未及时删除问题
        更新    原timer.count 改为 timer:count() 获取
]]
---@alias int integer
local  queue = require 'XG_JAPI.Lua.Queue'

---@type table<int,Queue>
local queues = {}

--------------------------------
local xpcall = xpcall
local traceback = debug.traceback
local assert = assert
local type = type
local max = math.max
local min = math.min
local ipairs = ipairs
local pairs = pairs
local print = print
--------------------------------

-- 正在执行计时器队列
local isExecutingQueue = 0

--计时器计数表，该表将不会持有引用，仅用做计算数量
--调用del删除的计时器会及时的清除，反之则等待gc回收后才会减少count数量
local timer_count = setmetatable({},
    {
        __mode = 'kv',
    }
)


local flags = {
    FLAG_UNKNOWN = 1 << 0,  --占位
    FLAG_PAUSE = 1 << 1,    --暂停
    FLAG_DESTROY = 1 << 2, --销毁
}

---@class mTimer  Timer类
local mTimer = {
    type = 'class',

    __id = 0,

    -- 当前循环时次数 无限增加数 每过0.01秒 增加1
    cur = 0,

    flags = flags

}
---@class cTimer
local cTimer = {
    type = 'timer',

    -- 周期数 用来记录当前计时器时间 一个周期 等于 中心计时器 的基本时间
    cycle = 0,

    -- 回调函数
    callback = nil,

    -- 间歇 循环型计时器
    interval = false,

    -- 标识
    flags = 0
}

---@return number 类似于os.clock 精度0.01
function mTimer:clock()
    return self.cur * 0.01
end

function mTimer:count()
    local i = 0
    for _, _ in pairs(timer_count) do
        i = i + 1
    end
    return i
end

-- 新建计时器
---@return timer
function mTimer:new()
    mTimer.__id = mTimer.__id + 1

    ---@class timer : cTimer 计时器对象
    local t = setmetatable({
        -- ID
        id = mTimer.__id
    }, {
        __index = cTimer
    })

    timer_count[t] = true

    return t
end

---请提前设置expires值
---@param self timer
local addToQueue = function(self)
    if not queues[self.expires] then
        queues[self.expires] = queue:new()
    end
    queues[self.expires]:put(self)
end

---启动计时器[如果没新建计时器系统会自动新建一个并返回]
---@param interval boolean 是否周期执行
---@param time number 时间 秒计算
---@param callback fun(t:timer) 计时器回调函数
---@return timer
function mTimer:timer(interval, time, callback)
    assert(type(time) == 'number', traceback('中计时器参数 time 应为 number 类型'))
    assert(type(callback) == 'function', traceback('中心计时器参数 callback 应为 function 类型'))
    local cycle = time * 100
    ---@class timer
    local t = self:new()

    -- 一周期时间
    t.cycle = cycle
    -- 起始时间  启动计时器的时间
    t.startingTime = mTimer.cur
    -- 有效时间(只有达到这个"循环时",才记作有效计时器事件,这样暂停销毁时就不必去费时将计时器移出原队列)
    t.expires = mTimer.cur + cycle
    -- 循环计时器
    t.interval = interval and true or false

    -- t.flags = 0
    t.callback = callback

    t:delFlag(flags.FLAG_PAUSE)

    addToQueue(t)

    return t
end

--- 启动计时器[一次][如果没新建计时器系统会自动新建一个并返回]
---@param timeout number 时间 按秒计算
---@param callback fun(t:timer) 计时器回调函数
---@return timer
function mTimer:once(timeout, callback)
    ---@type timer
    local t = self:timer(false, timeout, callback)
    return t
end

--- 启动计时器[循环][如果没新建计时器系统会自动新建一个并返回]
---@param timeout number 时间 按秒计算
---@param callback fun(t:timer) 计时器回调函数
---@return timer
function mTimer:loop(timeout, callback)
    ---@type timer
    local t = self:timer(true, timeout, callback)
    return t
end

--- 启动计时器[循环指定次数][如果没新建计时器系统会自动新建一个并返回]
---@param timeout number 时间 按秒计算
---@param times int 循环的次数
---@param callback fun(t:timer,i:int) 计时器回调函数
---@return timer
function mTimer:times(timeout, times, callback)
    assert(type(callback) == 'function', traceback('中心计时器参数 callback 应为 function 类型'))
    local i = 0
    ---@type timer
    local t = self:timer(true, timeout, function(t)
        i = i + 1
        if i <= times then
            callback(t, i)
        else
            t:addFlag(flags.FLAG_DESTROY)
        end
    end)
    return t
end

-- 销毁计时器
---@param self timer
function cTimer:del()
    timer_count[self] = nil
    getmetatable(self).__mode = 'kv'
    self:addFlag( flags.FLAG_DESTROY )
    if isExecutingQueue == self.expires then
        return
    end

    local q = queues[ self.expires ]
    if not q then
        return
    end

    for index, t in ipairs(q) do
        if t == self then
            q:getFromPosition( index )
            return
        end
    end

end

-- 计时器剩余时间
---@param self timer
function cTimer:remain()
    local cycle = self.cycle - self:elapsed()
    return math.max(0, cycle / 100)
end

-- 计时器已流逝时间
---@param self timer
function cTimer:elapsed()
    if self.elapsedTime then
        if self:hasFlag(flags.FLAG_PAUSE) then
            return self.elapsedTime
        end
        return self.elapsedTime + mTimer.cur - self.startingTime
    end
    local ret = mTimer.cur - self.startingTime
    return min( max(0, ret), self.cycle )
end

---暂停计时器
---@param self timer
function cTimer:pause()
    if self:hasFlag(flags.FLAG_PAUSE) then
        return
    end
    self:addFlag(flags.FLAG_PAUSE)

    self.pauseTime = mTimer.cur
    -- 暂停前已流逝时间
    self.elapsedTime = self.pauseTime - self.startingTime

    if isExecutingQueue == self.expires then
        return
    end

    local q = queues[ self.expires ]
    if not q then
        return
    end

    for index, t in ipairs(q) do
        if t == self then
            q:getFromPosition( index )
            return
        end
    end

end


---继续计时器
---@param self timer
function cTimer:resume()
    if not self:hasFlag(flags.FLAG_PAUSE) then
        return
    end
    self:delFlag(flags.FLAG_PAUSE)
    self.startingTime = mTimer.cur
    self.expires = self:remain()
    addToQueue(self)
end

-- 计时器到期时间
---@param self timer
function cTimer:timeout()
    return max(0, self.cycle / 100)
end

-- 重置计时器
---@param self timer
function cTimer:reset()
    self.elapsedTime = nil
    self.flags = 0
    self.interval = nil
    if self.expires == 0 then
        return
    end
    self:pause()
    addToQueue(self)
end

---是否拥有指定FLAG
---@param flag int 使用timer.flags.FLAG_
function cTimer:hasFlag(flag)
    return self.flags & flag ~= 0
end

---添加指定FLAG
---@param flag int 使用timer.flags.FLAG_
function cTimer:addFlag(flag)
    if self.flags & flag ~= 0 then
        return
    end
    self.flags = self.flags + flag
    return self
end

---移除指定FLAG
---@param flag int 使用timer.flags.FLAG_
function cTimer:delFlag(flag)
    if self.flags & flag == 0 then
        return self
    end
    self.flags = self.flags - flag
    return self
end

-- @private
-- 中心计时器
local function timer_callback()
    local cur = mTimer.cur + 1
    -- 循环次数
    mTimer.cur = cur

    if not queues[cur] then
        return -- 当前循环时 无队列
    end
    isExecutingQueue = cur
    ---@type int,timer
    for _, t in ipairs(queues[cur]) do
        if t:hasFlag(flags.FLAG_DESTROY) or t:hasFlag(flags.FLAG_PAUSE) or t.expires ~= cur then
            goto next_queue
        end

        local status, sErr = xpcall(t.callback, traceback, t)
        if not status then
            print(sErr)
        end

        --将循环计时器加入下一组队列
        if t.interval then
            --如果计时器在回调中被暂停销毁了则跳过
            if t:hasFlag(flags.FLAG_DESTROY) or t:hasFlag(flags.FLAG_PAUSE) then
                goto next_queue
            end

            t.expires = cur + t.cycle
            addToQueue(t)
        else
            t.expires = 0
        end
        ::next_queue::
    end
    isExecutingQueue = 0

    -- 清除当前循环时队列
    queues[cur]:del()
    queues[cur] = nil
end

local cj = require 'jass.common'
local jh_timer = cj.CreateTimer()
cj.TimerStart(jh_timer, 0.01, true, timer_callback)
require 'jass.debug'.handle_ref(jh_timer)

return mTimer
