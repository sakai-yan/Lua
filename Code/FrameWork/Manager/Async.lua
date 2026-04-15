--[[
================================================================================
                        Async 本地异步引擎（UI Tick 驱动）

    基于 MHUITickEvent_RegisterByCode 的本地异步调度器。

    设计目标：
    1. 不污染同步 Timer 系统
    2. 适合 UI 侧的显示、隐藏、动画、文本更新等异步行为
    3. 也可服务于其他“本地帧驱动”的轻量异步逻辑

    重要约束：
    - MHUITickEvent_RegisterByCode 只能注册无参数回调
    - 因此本模块只把 onTick() 作为底层入口
    - delta 和任务参数由 Async 自己转发给上层 callback

    公开能力：
    - Async.defer(callback, ...)
    - Async.after(delay, callback, ...)
    - Async.every(interval, callback, ...)
    - Async.onTick(callback, ...)
    - Async.cancel(task_id)
    - Async.clear()
================================================================================
--]]

local Jass = require "Lib.API.Jass"

local Async = {
    VERSION = "1.0.0",
}

local math_max = math.max
local math_min = math.min
local print = print
local select = select
local type = type
local unpack = table.unpack

local DEFAULT_DELTA = 1 / 60
local MIN_DELTA = 1 / 240
local MAX_DELTA = 1 / 15
local MAX_ARGS = 8

local started = false
local active_tasks = {}
local active_count = 0
local next_task_id = 1
local last_delta = DEFAULT_DELTA
local error_count = 0

--[[
    将数值裁剪到指定范围
    @param value number 原始值
    @param min_value number 最小值
    @param max_value number 最大值
    @return number 裁剪后的值
    @usage local safe = clamp(fps, 15, 240)
--]]
local function clamp(value, min_value, max_value)
    return math_max(min_value, math_min(max_value, value))
end

--[[
    估算当前 UI tick 的 delta
    说明：
    - UI tick 事件本身不提供 delta 参数
    - 这里使用当前 FPS 估算，并做上下限裁剪

    @return number 本帧估算时长
    @usage local delta = resolveDelta()
--]]
local function resolveDelta()
    local fps = Jass.MHUI_GetFps()
    if type(fps) ~= "number" or fps <= 0 then
        return DEFAULT_DELTA
    end
    return clamp(1 / fps, MIN_DELTA, MAX_DELTA)
end

--[[
    执行一个异步任务回调
    @param task table 任务对象
    @param delta number 当前帧的 delta
    @return boolean 是否继续保留任务
    @usage local keep = invoke(task, delta)
--]]
local function invoke(task, delta)
    if __DEBUG__ then
        local ok, keep_running = pcall(task.callback, delta, unpack(task, 1, task.argc))
        if not ok then
            error_count = error_count + 1
            print("[Async callback error]:", keep_running)
            return false
        end
        return keep_running ~= false
    end
    return task.callback(delta, unpack(task, 1, task.argc)) ~= false
end

--[[
    UI tick 事件入口
    注意：
    - 必须是无参数 function，才能注册给 MHUITickEvent_RegisterByCode
    - 上层 callback 所需参数由 Async 自己分发

    @usage 内部由 MHUITickEvent_RegisterByCode(onTick) 调用
--]]
local function onTick()
    if active_count == 0 then
        return
    end

    local delta = resolveDelta()
    last_delta = delta

    local write_index = 1
    for read_index = 1, active_count do
        local task = active_tasks[read_index]
        if task and not task.cancelled then
            task.remaining = task.remaining - delta

            if task.remaining <= 0 then
                local keep_running = invoke(task, delta)
                if task.cancelled or not task.repeatable or not keep_running then
                    task.cancelled = true
                else
                    if task.interval > 0 then
                        task.remaining = task.interval + task.remaining
                        if task.remaining < 0 then
                            task.remaining = 0
                        end
                    else
                        task.remaining = 0
                    end
                end
            end

            if not task.cancelled then
                if write_index ~= read_index then
                    active_tasks[write_index] = task
                end
                write_index = write_index + 1
            end
        end
    end

    for index = write_index, active_count do
        active_tasks[index] = nil
    end
    active_count = write_index - 1
end

--[[
    确保底层 UI tick 事件已注册
    @return boolean 是否启动成功
    @usage local ok = ensureStarted()
--]]
local function ensureStarted()
    if started then
        return true
    end
    started = Jass.MHUITickEvent_RegisterByCode(onTick) == true
    return started
end

--[[
    创建并登记一个异步任务
    @param delay number 延迟秒数
    @param interval number 重复间隔秒数
    @param repeatable boolean 是否重复
    @param callback function 回调函数
    @param argc integer 参数个数
    @return number task_id
    @usage local id = createTask(0.5, 0, false, cb, 0)
--]]
local function createTask(delay, interval, repeatable, callback, argc, ...)
    if type(callback) ~= "function" then
        return 0
    end

    if not ensureStarted() then
        return 0
    end

    local safe_argc = argc
    if safe_argc > MAX_ARGS then
        safe_argc = MAX_ARGS
    elseif safe_argc < 0 then
        safe_argc = 0
    end

    local task = {
        id = next_task_id,
        callback = callback,
        remaining = delay > 0 and delay or 0,
        interval = interval > 0 and interval or 0,
        repeatable = repeatable == true,
        cancelled = false,
        argc = safe_argc,
    }
    next_task_id = next_task_id + 1

    for index = 1, safe_argc do
        task[index] = select(index, ...)
    end

    active_count = active_count + 1
    active_tasks[active_count] = task
    return task.id
end

--[[
    下一帧尽快执行一次
    @param callback function 回调函数，签名 function(delta, ...)
    @return number task_id
    @usage Async.defer(function(delta) print(delta) end)
--]]
function Async.defer(callback, ...)
    return createTask(0, 0, false, callback, select("#", ...), ...)
end

--[[
    延迟执行一次
    @param delay number 延迟秒数
    @param callback function 回调函数，签名 function(delta, ...)
    @return number task_id
    @usage Async.after(0.5, function(delta) print(delta) end)
--]]
function Async.after(delay, callback, ...)
    local safe_delay = type(delay) == "number" and delay or 0
    return createTask(safe_delay, 0, false, callback, select("#", ...), ...)
end

--[[
    固定间隔重复执行
    @param interval number 间隔秒数
    @param callback function 回调函数，签名 function(delta, ...)
    @return number task_id
    @usage local id = Async.every(0.2, function(delta) print(delta) end)
--]]
function Async.every(interval, callback, ...)
    local safe_interval = type(interval) == "number" and interval or 0
    return createTask(safe_interval, safe_interval, true, callback, select("#", ...), ...)
end

--[[
    每个 UI tick 执行一次
    @param callback function 回调函数，返回 false 时停止
    @return number task_id
    @usage Async.onTick(function(delta) return true end)
--]]
function Async.onTick(callback, ...)
    return createTask(0, 0, true, callback, select("#", ...), ...)
end

--[[
    取消一个任务
    @param task_id number 任务 ID
    @return boolean 是否取消成功
    @usage Async.cancel(id)
--]]
function Async.cancel(task_id)
    for index = 1, active_count do
        local task = active_tasks[index]
        if task and task.id == task_id then
            task.cancelled = true
            return true
        end
    end
    return false
end

--[[
    清空全部异步任务
    @usage Async.clear()
--]]
function Async.clear()
    for index = 1, active_count do
        active_tasks[index] = nil
    end
    active_count = 0
end

--[[
    获取最近一次 tick 的 delta
    @return number 最近一次 tick 的 delta
    @usage local delta = Async.getDelta()
--]]
function Async.getDelta()
    return last_delta
end

--[[
    获取调试模式下累计的回调异常次数
    @return integer 异常次数
    @usage local errors = Async.getErrorCount()
--]]
function Async.getErrorCount()
    return error_count
end

return Async
