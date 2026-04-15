local CreateTimer = cj.CreateTimer
local TimerStart = cj.TimerStart
local mt = {
    type = 'class',
    __id = 0,
    count = 0,
    --队列
    __queue = {},
    --计时器默认值
            -- 周期数 用来记录当前计时器时间 一个周期 等于 中心计时器 的基本时间
            cycle = 0, 
            maxcycle = 0,
            
           --回调函数
           callback = nil,
           
           --间歇 循环型计时器
           interval = false,
           
          --暂停
          pause = false,
          
          --销毁 再下个周期时才会被销毁
          destroy = false,
          
          --在队列中
          inqueue = false
}
timer = setmetatable({},
    {
        __index = mt,
    }
)
--self: class
--新建计时器
-- -@return timer
function mt:new()
    mt.__id = mt.__id + 1
    mt.count = mt.count + 1
    local t = {
        type = 'timer',
        --ID
        id = mt.__id,
    }
    return setmetatable(t, 
        {
            __index = timer
        }
    )
end
--self: timer|class
--启动计时器[如果没新建计时器系统会自动新建一个并返回]
--@param interval boolean 是否周期执行
--@param time number 时间 秒计算
--@param callback function 计时器回调函数
--@return timer
function mt:timer( interval, time, callback )
    if type(time) ~='number' or type(callback) ~= 'function' then
        return nil
    end
    local cycle = time * 100
    if self.type ~= 'timer' then
        self = self:new()
    end
    self.cycle = 0
    self.maxcycle = cycle
    self.interval = interval
    self.pause = false
    self.destroy = false
    self.callback = callback
    if not self.inqueue then
        self.inqueue = true
        table.insert(mt.__queue, self)
    end
    return self
end

--self:timer|class
--启动计时器[一次][如果没新建计时器系统会自动新建一个并返回]
--@param time number 时间 按秒计算
--@param callback function 计时器回调函数
--@return timer
function mt:once(time,callback)
    self = self:timer(false, time, callback)
    return self
end
--self:timer|class
--启动计时器[循环][如果没新建计时器系统会自动新建一个并返回]
--@param time number 时间 按秒计算
--@param callback function 计时器回调函数
--@return timer
function mt:loop(time,callback)
    self = self:timer(true, time, callback)
    return self
end
--self: timer
--销毁计时器
function timer:del()
    self.destroy = true
end
--self:timer
--计时器剩余时间
function timer:remain()
    local cycle = self.maxcycle - self.cycle
    return math.max( 0, cycle / 100 )
end
--self:timer
--计时器已流逝时间
function timer:elapsed()
    local cycle = self.cycle
    return math.max( 0, cycle / 100 )
end
--self:timer
--计时器到期时间
function timer:timeout()
    local cycle = self.maxcycle
    return math.max( 0, cycle / 100 )
end

--@private
--中心计时器
local function timer_callback()
    local i,max_i = 1,#mt.__queue
    local t
    while i <= max_i do
        t = mt.__queue[i]
        if t.destroy then --标记销毁
            table.remove(mt.__queue, i)
            setmetatable(t,nil)
            mt.count = mt.count - 1
            i=i-1
            max_i = max_i - 1
        elseif t.pause then --暂停
            table.remove(mt.__queue, i)
            i=i-1
            max_i = max_i - 1
        else
                t.cycle = t.cycle + 1
                if t.cycle >= t.maxcycle then
                        local status, sErr =xpcall(t.callback, debug.traceback, t)
                        if status then
                                if not t.interval then
                                        table.remove(mt.__queue, i)
                                        i=i-1
                                        max_i = max_i - 1
                                end
                        else
                                print(sErr)
                        end
                end
        end
        i = i + 1
    end
    
end
TimerStart(CreateTimer(), 0.01, true, timer_callback)
return mt