----------------------------------------------------
-- 高性能中心定时器（改进版）
----------------------------------------------------
local Game = require "Game"
local Jass      = require "Lib.API.Jass"
local HandleId = require "Lib.Base.HandleId"

----------------------------------------------------
-- 本地化
----------------------------------------------------
local ceil   = math.ceil
local max    = math.max
local select = select
local type   = type
local pcall  = pcall
local error  = error
local print  = print
local unpack = table.unpack

----------------------------------------------------
-- 配置
----------------------------------------------------
local Config = {
    TICK_PERIOD   = 0.01,
    TVR_BITS      = 8,
    TVN_BITS      = 6,
    WHEEL_COUNT   = 4,

    MAX_ARGS      = 8,
    INITIAL_POOL  = 64,
    MAX_POOL_SIZE = 1024,
    -- 句柄槽位容量（同一时刻最多可同时存在的 Timer 数量上限）
    -- DEBUG 压测会创建 100000 规模一次性 Timer，因此默认给到 100000
    ID_CAPACITY   = 100000,

    DEBUG         = rawget(_G, "__DEBUG__") or false,
}

-- HandleId
----------------------------------------------------
local idPool          = HandleId.new("timer", Config.ID_CAPACITY)
local id_alloc        = idPool.alloc
local id_free         = idPool.free
local id_safeDecode   = idPool.safeDecode
----------------------------------------------------
-- Timer 主体
----------------------------------------------------
local Timer = {
    VERSION = "4.1.0",

    _wheels      = nil,
    _timers      = {},   -- id -> node
    _currentTick = 0,

    _pool        = {},
    _poolSize    = 0,

    _wheelCount  = 0,    -- 当前在时间轮中的节点数量（inWheel=true）

    _masterTimer = nil,
    _initialized = false,

    _stats = {
        created   = 0,
        active    = 0,
        executed  = 0,
        cancelled = 0,
        poolHits  = 0,
        poolMisses= 0,
        maxActive = 0,
        errors    = 0,
    },
}

----------------------------------------------------
-- 状态常量
----------------------------------------------------
local WAITING = 1
local FIRING  = 2
local PAUSED  = 3
local FREE    = 4

----------------------------------------------------
-- 时间轮常量
----------------------------------------------------
local TICK_PERIOD
local TVR_BITS, TVN_BITS
local TVR_SIZE, TVN_SIZE
local TVR_MASK, TVN_MASK
local MAX_TICKS
local WHEEL_COUNT = Config.WHEEL_COUNT
----------------------------------------------------
-- 工具
----------------------------------------------------
local function secondsToTicks(sec)
    if sec <= 0 then return 1 end
    return ceil(sec / TICK_PERIOD)
end

local function recomputeWheelConstants()
    if WHEEL_COUNT ~= 4 then
        error("Timer 当前实现仅支持 WHEEL_COUNT = 4", 2)
    end

    TVR_BITS = Config.TVR_BITS
    TVN_BITS = Config.TVN_BITS

    TVR_SIZE = 1 << TVR_BITS
    TVN_SIZE = 1 << TVN_BITS

    TVR_MASK = TVR_SIZE - 1
    TVN_MASK = TVN_SIZE - 1

    MAX_TICKS = TVR_SIZE
    for _ = 2, WHEEL_COUNT do
        MAX_TICKS = MAX_TICKS * TVN_SIZE
    end
end

----------------------------------------------------
-- 对象池
----------------------------------------------------
local function acquireNode()
    local n = Timer._poolSize
    if n > 0 then
        local node = Timer._pool[n]
        Timer._pool[n] = nil
        Timer._poolSize = n - 1
        Timer._stats.poolHits = Timer._stats.poolHits + 1
        return node
    end
    Timer._stats.poolMisses = Timer._stats.poolMisses + 1
    return {}
end

local function releaseNode(node)
    if node.state == FREE then
        return
    end

    -- 必须已无效
    node.valid = false
    node.state = FREE

    for i = 1, node.argc or 0 do
        node[i] = nil
    end

    node.id        = nil
    node.encodedId = nil
    node.callback  = nil
    node.interval  = nil
    node.expires   = nil
    node.remaining = nil
    node.argc      = 0

    node.prev      = nil
    node.next      = nil
    node.wheel     = nil
    node.slot      = nil
    node.inWheel   = false

    local n = Timer._poolSize
    if n < Config.MAX_POOL_SIZE then
        Timer._poolSize = n + 1
        Timer._pool[n + 1] = node
    end
end

----------------------------------------------------
-- ID
----------------------------------------------------
----------------------------------------------------
-- Wheel 构建
----------------------------------------------------
local function buildWheels()
    local wheels = {}
    for i = 1, WHEEL_COUNT do
        local size = (i == 1) and TVR_SIZE or TVN_SIZE
        local w = { head = {}, tail = {} }
        for j = 1, size do
            w.head[j] = 0
            w.tail[j] = 0
        end
        wheels[i] = w
    end
    Timer._wheels = wheels
end

----------------------------------------------------
-- 安全取 node
----------------------------------------------------
local function getNode(encodedId)
    local id = id_safeDecode(encodedId)
    local node = id and Timer._timers[id]
    if node and node.valid and node.encodedId == encodedId then
        return node
    end
end

----------------------------------------------------
-- 参数
----------------------------------------------------
local function setNodeArgsBuilder()
    local code_str = {"return function(node, ...)\n"}
    for i = 1, Config.MAX_ARGS do
        code_str[#code_str + 1] = "node[" .. i .. "],"
    end
    code_str[#code_str + 1] = "...\n"
    code_str[#code_str + 1] = "node.argc = argc\n"
    code_str[#code_str + 1] = "end\n"
    return load(table.concat(code_str))()
end

local setNodeArgs = setNodeArgsBuilder()

----------------------------------------------------
-- Slot 操作
----------------------------------------------------
local function appendToSlot(wi, si, id, node)
    local wheel = Timer._wheels[wi]
    local last  = wheel.tail[si]

    if last == 0 then
        wheel.head[si] = id
        node.prev = 0
    else
        Timer._timers[last].next = id
        node.prev = last
    end

    wheel.tail[si] = id
    node.next = 0
    node.wheel   = wi
    node.slot    = si
    node.state   = WAITING
    node.inWheel = true
    Timer._wheelCount = Timer._wheelCount + 1
end

local function removeFromWheel(node)
    if not node.inWheel then
        return false
    end

    local wi, si = node.wheel, node.slot
    local id = node.id
    local wheel = Timer._wheels[wi]

    local prev, next = node.prev, node.next

    if prev == 0 then
        wheel.head[si] = next
    else
        Timer._timers[prev].next = next
    end

    if next == 0 then
        wheel.tail[si] = prev
    else
        Timer._timers[next].prev = prev
    end

    node.prev = nil
    node.next = nil
    node.wheel = nil
    node.slot = nil
    node.inWheel = false
    Timer._wheelCount = Timer._wheelCount - 1
    return true
end

----------------------------------------------------
-- callback 调用策略
----------------------------------------------------
local invoke

if Config.DEBUG then
    invoke = function(cb, ...)
        local ok, err = pcall(cb, ...)
        if not ok then
            Timer._stats.errors = Timer._stats.errors + 1
            print("[Timer callback error]:", err)
        end
    end
else
    invoke = function(cb, ...)
        cb(...)
    end
end

-- 将 timer 插入时间轮（WAITING）
----------------------------------------------------
local function internalSchedule(id, node)
    local diff = node.expires - Timer._currentTick
    if diff < 0 then diff = 0 end

    local wi, si
    if diff < TVR_SIZE then
        wi = 1
        si = (node.expires & TVR_MASK) + 1

    elseif diff < (TVR_SIZE << TVN_BITS) then
        wi = 2
        si = ((node.expires >> TVR_BITS) & TVN_MASK) + 1

    elseif diff < (TVR_SIZE << (2 * TVN_BITS)) then
        wi = 3
        si = ((node.expires >> (TVR_BITS + TVN_BITS)) & TVN_MASK) + 1

    else
        if diff >= MAX_TICKS then
            node.expires = Timer._currentTick + MAX_TICKS - 1
            if Config.DEBUG then
                error("[Timer] delay exceeds MAX_TICKS", 2)
            end
        end
        wi = 4
        si = ((node.expires >> (TVR_BITS + 2 * TVN_BITS)) & TVN_MASK) + 1
    end

    appendToSlot(wi, si, id, node)
end

----------------------------------------------------
-- cascade：从高层 wheel 下沉到更低层
----------------------------------------------------
local function cascade(wi)
    local wheel = Timer._wheels[wi]
    local idx

    if wi == 2 then
        idx = ((Timer._currentTick >> TVR_BITS) & TVN_MASK) + 1
    else
        idx = ((Timer._currentTick >> (TVR_BITS + (wi - 2) * TVN_BITS)) & TVN_MASK) + 1
    end

    local id = wheel.head[idx]
    wheel.head[idx], wheel.tail[idx] = 0, 0

    while id ~= 0 do
        local node = Timer._timers[id]
        local nextId = node.next

        node.next    = nil
        node.prev    = nil
        if node.inWheel then
            Timer._wheelCount = Timer._wheelCount - 1
            node.inWheel = false
        end
        node.wheel   = nil
        node.slot    = nil

        if node.valid and node.state == WAITING then
            -- 仍然有效，重新调度到更低层
            internalSchedule(id, node)
        else
            -- 已 cancel 或非法，回收
            Timer._timers[id] = nil
            id_free(idPool, node.encodedId)
            releaseNode(node)
            Timer._stats.active = Timer._stats.active - 1
        end

        id = nextId
    end
end

----------------------------------------------------
-- 执行当前 tick 对应的 slot
----------------------------------------------------
local function executeCurrentSlot()
    local idx = (Timer._currentTick & TVR_MASK) + 1
    local wheel = Timer._wheels[1]
    
    while true do
        local id = wheel.head[idx]
        if id == 0 then
            break
        end

        local node = Timer._timers[id]
        removeFromWheel(node)

        if node.valid and node.state == WAITING and node.expires <= Timer._currentTick then
            -- FIRING
            node.state = FIRING

            invoke(
                node.callback,
                unpack(node, 1, node.argc)
            )

            Timer._stats.executed = Timer._stats.executed + 1

            if node.valid and node.interval then
                -- RESCHEDULE（逻辑时间）
                node.expires = node.expires + node.interval
                node.state = WAITING
                internalSchedule(id, node)
            else
                -- 一次性或已 cancel
                Timer._timers[id] = nil
                id_free(idPool, node.encodedId)
                releaseNode(node)
                Timer._stats.active = Timer._stats.active - 1
            end
        else
            if node.valid and node.state == WAITING then
                -- 被外部 reSchedule 到未来：重新入轮
                internalSchedule(id, node)

            elseif node.valid and node.state == PAUSED then
                -- 被外部 pause：保持暂停态（不入轮）

            else
                -- 非法 / 已 cancel / 状态异常
                Timer._timers[id] = nil
                id_free(idPool, node.encodedId)
                releaseNode(node)
                Timer._stats.active = Timer._stats.active - 1
            end
        end
    end
end

----------------------------------------------------
-- 每个 tick 的入口（hot path）
----------------------------------------------------
local function onTick()
    Timer._currentTick = Timer._currentTick + 1

    if Timer._wheelCount == 0 then
        return
    end

    -- cascade
    if (Timer._currentTick & TVR_MASK) == 0 then
        cascade(2)

        if ((Timer._currentTick >> TVR_BITS) & TVN_MASK) == 0 then
            cascade(3)

            if ((Timer._currentTick >> (TVR_BITS + TVN_BITS)) & TVN_MASK) == 0 then
                cascade(4)
            end
        end
    end

    executeCurrentSlot()
end

----------------------------------------------------
-- 初始化
----------------------------------------------------
function Timer.init()
    if Timer._initialized then
        return Timer
    end

    TICK_PERIOD = Config.TICK_PERIOD
    recomputeWheelConstants()
    buildWheels()

    local initialPool = Config.INITIAL_POOL or 0
    if initialPool > 0 then
        local maxPool = Config.MAX_POOL_SIZE or 0
        if maxPool > 0 and initialPool > maxPool then
            initialPool = maxPool
        end
        for i = 1, initialPool do
            Timer._pool[i] = { state = FREE }
        end
        Timer._poolSize = initialPool
    end

    Timer._initialized = true
    if Timer._masterTimer == nil then
        Timer._masterTimer = Jass.CreateTimer()
        Jass.TimerStart(Timer._masterTimer, TICK_PERIOD, true, onTick)
    end
    return Timer
end

--待全部库加载完成后初始化
Game.hookInit(Timer.init)

---@param delaySeconds number 延迟时间，秒
---@param intervalSeconds number|nil 循环间隔时间，秒，可选，为nil时为一次性任务
---@param callback function 回调函数
---@param ... any 回调函数参数
---@return number 定时器ID
function Timer.schedule(delaySeconds, intervalSeconds, callback, ...)
    if type(callback) ~= "function" then
        error("Timer.schedule: callback must be function", 2)
    end

    local delayTicks = secondsToTicks(delaySeconds)
    local intervalTicks = intervalSeconds and intervalSeconds > 0
        and secondsToTicks(intervalSeconds)
        or nil

    local encodedId, id = id_alloc(idPool)
    local node = acquireNode()

    node.id        = id
    node.valid     = true
    node.encodedId = encodedId
    node.callback  = callback
    node.interval  = intervalTicks
    node.expires   = Timer._currentTick + delayTicks

    setNodeArgs(node, ...)

    Timer._timers[id] = node
    internalSchedule(id, node)

    local s = Timer._stats
    s.created   = s.created + 1
    s.active    = s.active + 1
    s.maxActive = max(s.maxActive, s.active)

    return node.encodedId
end

--延迟任务，delay(0)不是立即执行，而是下一帧执行
function Timer.delay(delaySeconds, callback, ...)
    return Timer.schedule(delaySeconds, nil, callback, ...)
end

--循环任务，interval为nil时，为一次性任务
Timer.loop = Timer.schedule


----------------------------------------------------
-- 取消一个定时器
----------------------------------------------------
function Timer.cancel(encodedId)
    local node = getNode(encodedId)
    if not node then
        return false
    end

    if not node.valid then
        return false
    end

    node.valid = false
    Timer._stats.cancelled = Timer._stats.cancelled + 1

    local st = node.state

    -- pause 状态不在时间轮里：立即回收，避免长期占用 ID 槽位
    if st == PAUSED then
        Timer._timers[node.id] = nil
        id_free(idPool, node.encodedId)
        releaseNode(node)
        Timer._stats.active = Timer._stats.active - 1
        return true
    end

    -- WAITING 且在轮里：尽量即时移除并回收
    if st == WAITING and node.inWheel then
        removeFromWheel(node)
        Timer._timers[node.id] = nil
        id_free(idPool, node.encodedId)
        releaseNode(node)
        Timer._stats.active = Timer._stats.active - 1
        return true
    end

    return true
end


----------------------------------------------------
-- 暂停一个尚未触发的定时器
----------------------------------------------------
function Timer.pause(encodedId)
    local node = getNode(encodedId)
    if not node then
        return false
    end

    -- 只能暂停正在等待的 timer
    if node.state ~= WAITING or not node.inWheel then
        return false
    end

    local remaining = node.expires - Timer._currentTick
    if remaining <= 0 then
        remaining = 1
    end

    node.state     = PAUSED
    node.remaining = remaining

    -- 从时间轮中立刻移除
    removeFromWheel(node)
    return true
end

----------------------------------------------------
-- 恢复一个被 pause 的定时器
----------------------------------------------------
function Timer.resume(encodedId)
    local node = getNode(encodedId)
    if not node then
        return false
    end

    if node.state ~= PAUSED then
        return false
    end

    node.state     = WAITING
    node.expires   = Timer._currentTick + node.remaining
    node.remaining = nil

    -- 像 NEW 一样重新插入时间轮
    internalSchedule(node.id, node)
    return true
end

----------------------------------------------------
-- 修改 timer 的下一次执行时间
----------------------------------------------------
function Timer.reSchedule(encodedId, delaySeconds)
    local node = getNode(encodedId)
    -- FREE / invalid timer 不允许
    if not node or not node.valid then
        return false
    end

    local node_state = node.state
    local delayTicks = secondsToTicks(delaySeconds)

    -- 正在 pause 的 timer：直接改 remaining
    if node_state == PAUSED then
        node.remaining = delayTicks
        return true
    end

    -- 正在执行中的 timer：拒绝
    if node_state == FIRING then
        return false
    end

    -- 正在等待的 timer：需要移出旧 slot
    if node_state == WAITING and node.inWheel == true then
        if Config.DEBUG then
            assert(node.inWheel, "[Timer] WAITING node not in wheel")
        end

        removeFromWheel(node)
    end

    node.expires = Timer._currentTick + delayTicks

    -- 重新插入时间轮
    internalSchedule(node.id, node)
    return true
end

----------------------------------------------------
-- 修改循环 timer 的 interval
----------------------------------------------------
function Timer.setInterval(encodedId, intervalSeconds)
    local node = getNode(encodedId)
    if not node then
        return false
    end

    if not node.valid then
        return false
    end

    if intervalSeconds and intervalSeconds > 0 then
        node.interval = secondsToTicks(intervalSeconds)
    else
        -- nil / <=0：变成一次性 timer
        node.interval = nil
    end

    return true
end

--获取剩余时间
function Timer.getRemaining(encodedId)
    local node = getNode(encodedId)
    if not node or not node.valid then
        return nil
    end

    local remainingTicks

    if node.state == PAUSED then
        remainingTicks = node.remaining

    elseif node.state == WAITING then
        remainingTicks = node.expires - Timer._currentTick

    else
        -- FIRING / FREE
        return 0
    end

    if not remainingTicks or remainingTicks < 0 then
        return 0
    end

    return remainingTicks * TICK_PERIOD
end

--更改timer任务的回调函数和参数
function Timer.reSet(encodedId, func, ...)
    local node = getNode(encodedId)
    if not node or not node.valid then return false end

    if func and type(func) == "function" then
        node.callback = func
    end

    setNodeArgs(node, ...)
    return true
end


----------------------------------------------------
-- 测试用接口：手动推进 tick
----------------------------------------------------
function Timer._tickForTest(n)
    for _ = 1, n do
        onTick()
    end
end

if __DEBUG__ then
    ------------------------------------------------------------
    -- Timer 自动化基准 / 压力 / 行为测试（DEBUG 模式）
    -- 说明：
    -- 1. 代码与变量名保持英文（工程规范）
    -- 2. 所有打印与报告信息为中文
    ------------------------------------------------------------
    ----------------------------------------------------
    -- DEBUG ONLY: hard reset for tests
    ----------------------------------------------------

    local function _resetForTest()


        -- 释放所有仍占用的 ID 槽位，避免下一轮测试溢出
        for _, node in pairs(Timer._timers) do
            if node and node.encodedId then
                id_free(idPool, node.encodedId)
            end
        end

        -- 停止并销毁 masterTimer（避免重复 init 导致多重 tick）
        if Timer._masterTimer then
            Jass.DestroyTimer(Timer._masterTimer)
            Timer._masterTimer = nil
        end

        -- 清空核心状态
        Timer._wheels      = nil
        Timer._timers      = {}
        Timer._currentTick = 0

        Timer._pool        = {}
        Timer._poolSize    = 0

        Timer._wheelCount  = 0

        Timer._initialized = false

        -- 重置统计
        Timer._stats = {
            created   = 0,
            active    = 0,
            executed  = 0,
            cancelled = 0,
            poolHits  = 0,
            poolMisses= 0,
            maxActive = 0,
            errors    = 0,
        }

        -- 重新初始化
        Timer.init()
    end

    ------------------------------------------------------------
    -- Assertion helpers (英文名，工程规范)
    ------------------------------------------------------------
    local function assertTrue(cond, msg)
        if not cond then
            error("【断言失败】" .. (msg or "未知错误"), 2)
        end
    end

    local function assertEquals(a, b, msg)
        if a ~= b then
            error(string.format(
                "【断言失败】%s | 期望=%s 实际=%s",
                msg or "", tostring(b), tostring(a)
            ), 2)
        end
    end

    ------------------------------------------------------------
    -- Snapshot of internal state
    ------------------------------------------------------------
    local function snapshot()
        local s = Timer._stats
        return {
            tick       = Timer._currentTick,
            active     = s.active,
            created    = s.created,
            executed   = s.executed,
            cancelled  = s.cancelled,
            poolSize   = Timer._poolSize,
            poolHits   = s.poolHits,
            poolMisses = s.poolMisses,
            errors     = s.errors,
            luaMemory  = collectgarbage("count"),
        }
    end

    ------------------------------------------------------------
    -- Print diff report (中文输出)
    ------------------------------------------------------------
    local function printDiff(before, after, title)
        print("\n==============================")
        print("【测试报告】" .. title)
        print("------------------------------")
        for k, v in pairs(after) do
            local d = v - (before[k] or 0)
            print(string.format(
                "%-12s : %+8.3g   （当前=%.3g）",
                k, d, v
            ))
        end
        print("==============================")
    end
    ------------------------------------------------------------
    -- Tick helper
    ------------------------------------------------------------
    local function tick(n)
        Timer._tickForTest(n)
    end

    ------------------------------------------------------------
    -- Test begin
    ------------------------------------------------------------
    print("\n==============================")
    print("Timer 自动化压力测试开始（DEBUG 模式）")
    print("==============================\n")
    _resetForTest()
    ------------------------------------------------------------
    -- Test 1: Massive one-shot timers
    ------------------------------------------------------------
    do
        print("▶ 测试 1：海量一次性 Timer（规模压力）")

        local before = snapshot()
        local N = 100000

        for i = 1, N do
            Timer.delay(0.1, function() end)
        end

        tick(20)

        local after = snapshot()
        printDiff(before, after, "海量一次性 Timer")

        assertEquals(after.active, 0, "一次性 Timer 未完全回收")
        assertTrue(after.executed >= N, "一次性 Timer 执行次数不足")
    end
    _resetForTest()
    ------------------------------------------------------------
    -- Test 2: Loop timers stability
    ------------------------------------------------------------
    do
        print("\n▶ 测试 2：循环 Timer 稳定性（长期运行）")

        local before = snapshot()
        local ids = {}

        for i = 1, 20000 do
            ids[i] = Timer.loop(0.05, 0.05, function() end)
        end

        tick(200)
        local mid = snapshot()

        for i = 1, 10000 do
            Timer.cancel(ids[i])
        end

        tick(200)
        local after = snapshot()

        printDiff(before, after, "循环 Timer 稳定性")

        assertTrue(mid.active >= 20000, "循环 Timer 数量异常")
        assertTrue(after.active < mid.active, "取消循环 Timer 未生效")
    end
    _resetForTest()
    ------------------------------------------------------------
    -- Test 3: Pause / Resume storm
    ------------------------------------------------------------
    do
        print("\n▶ 测试 3：Pause / Resume 高频风暴")
        local id = Timer.loop(1, 1, function() end)

        for i = 1, 10000 do
            assertTrue(Timer.pause(id), "Pause 失败")
            assertTrue(Timer.resume(id), "Resume 失败")
        end

        tick(5)
        local s = snapshot()

        assertEquals(s.active, 1, "Pause / Resume 后 Timer 状态异常")
    end
    _resetForTest()
    ------------------------------------------------------------
    -- Test 4: Re-entrant callback behavior
    ------------------------------------------------------------
    do
        print("\n▶ 测试 4：Callback 内部重入操作")

        local id
        id = Timer.loop(0.1, 0.1, function()
            Timer.cancel(id)
            Timer.resume(id)
            Timer.reSchedule(id, 0.2)
        end)

        tick(50)
        local s = snapshot()

        assertTrue(s.executed > 0, "Callback 未执行")
        assertTrue(
            s.active == 0 or s.active == 1,
            "重入操作导致 Timer 数量异常"
        )
    end
    _resetForTest()
    ------------------------------------------------------------
    -- Test 5: Mutate later timers in processing slot
    ------------------------------------------------------------
    do
        print("\n▶ 测试 5：处理 slot 时修改后继 Timer")

        local fired = {}
        local ids = {}

        ids[1] = Timer.delay(0.01, function()
            fired[#fired + 1] = "A"
            assertTrue(Timer.cancel(ids[2]), "处理 slot 时取消后继 Timer 失败")
            assertTrue(Timer.pause(ids[3]), "处理 slot 时暂停已到期后继 Timer 失败")
            assertTrue(Timer.reSchedule(ids[4], 0.2), "处理 slot 时重排后继 Timer 失败")
        end)
        ids[2] = Timer.delay(0.01, function()
            fired[#fired + 1] = "B"
        end)
        ids[3] = Timer.delay(0.01, function()
            fired[#fired + 1] = "C"
        end)
        ids[4] = Timer.delay(0.01, function()
            fired[#fired + 1] = "D"
        end)

        tick(1)

        assertEquals(table.concat(fired, ","), "A", "处理 slot 时移除失败或后继误执行")
        assertTrue(Timer.getRemaining(ids[3]) > 0, "已到期 pause 的 Timer 未保留")
        assertTrue(Timer.getRemaining(ids[4]) > 0, "重排后的 Timer 未保留")
        assertTrue(Timer.resume(ids[3]), "恢复已到期 pause 的 Timer 失败")

        tick(1)

        assertEquals(table.concat(fired, ","), "A,C", "恢复后的 Timer 未按预期在下一 tick 执行")
    end
    _resetForTest()
    ------------------------------------------------------------
    -- Test 6: Lazy cancel cleanup
    ------------------------------------------------------------
    do
        print("\n▶ 测试 6：惰性 Cancel 大规模堆积")

        local ids = {}
        for i = 1, 50000 do
            ids[i] = Timer.delay(10, function() end)
        end

        for i = 1, 50000 do
            Timer.cancel(ids[i])
        end

        local before = snapshot()
        tick(1000)
        local after = snapshot()

        printDiff(before, after, "惰性 Cancel 清理")

        assertEquals(after.active, 0, "被取消的 Timer 未完全清理")
    end
    _resetForTest()
    ------------------------------------------------------------
    -- Test 7: Tick jump / time skew
    ------------------------------------------------------------
    do
        print("\n▶ 测试 7：Tick 大步进（模拟卡顿）")

        local fired = 0
        Timer.delay(1, function()
            fired = fired + 1
        end)

        tick(200)

        assertEquals(fired, 1, "Tick 跳跃导致 Timer 行为异常")
    end
    _resetForTest()
    ------------------------------------------------------------
    -- Final report
    ------------------------------------------------------------
    local final = snapshot()

    print("\n==============================")
    print("Timer 自动化测试全部完成")
    print("------------------------------")
    print("回调错误次数 :", final.errors)
    print("当前活跃Timer:", final.active)
    print("对象池大小   :", final.poolSize)
    print("Lua 内存(KB) :", math.floor(final.luaMemory))
    print("==============================\n")

    assertTrue(final.errors == 0, "存在回调错误")

    print("✅ 结论：在当前测试强度与模型下，Timer 表现稳定，可作为系统级组件使用")

end

return Timer
