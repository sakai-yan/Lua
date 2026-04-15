local root = arg and arg[1] or "."
root = root:gsub("\\", "/")

package.path = table.concat({
    root .. "/Code/?.lua",
    root .. "/Code/?/init.lua",
    package.path,
}, ";")

_G.__DEBUG__ = false

package.preload["Game"] = function()
    return {
        hookInit = function()
        end,
    }
end

package.preload["Lib.API.Jass"] = function()
    return {
        CreateTimer = function()
            return {}
        end,
        TimerStart = function()
        end,
    }
end

package.preload["Lib.Base.BitSet"] = function()
    return {}
end

package.preload["Core.Entity.Unit"] = function()
    return {
        EnumUnitInRange = function()
        end,
        GetEunmUnit = function()
        end,
        GetEnumUnit = function()
        end,
    }
end

package.preload["Core.Entity.Effect"] = function()
    return {}
end

package.preload["Lib.Base.Vector3"] = function()
    return {
        set = function()
        end,
        get = function()
        end,
    }
end

package.preload["Logic.Package.Group"] = function()
    local Group = {}

    function Group.new(...)
        local group = table.setmode({}, "kv")
        local count = select("#", ...)
        for index = 1, count do
            local value = select(index, ...)
            if value ~= nil then
                group[index] = value
                group[value] = index
            end
        end
        group.__count = count
        return group
    end

    function Group.has(group, object)
        return object ~= nil and group[object] ~= nil
    end

    function Group.remove(group, object)
        if object ~= nil then
            group[object] = nil
        end
        return group
    end

    return Group
end

package.preload["FrameWork.Manager.Timer"] = function()
    local Timer = {
        _initialized = false,
        _timers = {},
        _pool = {},
        _pool_size = 0,
        _initial_pool = 64,
        _max_pool_size = 1024,
        _next_id = 1,
        _free_head = 0,
        _free_next = {},
    }

    local function acquire_node()
        local n = Timer._pool_size
        if n > 0 then
            local node = Timer._pool[n]
            Timer._pool[n] = nil
            Timer._pool_size = n - 1
            return node
        end
        return {}
    end

    local function release_node(node)
        node.valid = false
        node.id = nil
        node.callback = nil
        node.interval = nil
        node.argc = 0
        node[1] = nil

        local n = Timer._pool_size
        if n < Timer._max_pool_size then
            Timer._pool_size = n + 1
            Timer._pool[n + 1] = node
        end
    end

    local function alloc_id()
        local free = Timer._free_head
        if free ~= 0 then
            Timer._free_head = Timer._free_next[free] or 0
            Timer._free_next[free] = nil
            return free
        end

        local id = Timer._next_id
        Timer._next_id = id + 1
        return id
    end

    local function free_id(id)
        Timer._free_next[id] = Timer._free_head
        Timer._free_head = id
    end

    function Timer.init()
        if Timer._initialized then
            return Timer
        end

        for i = 1, Timer._initial_pool do
            Timer._pool[i] = {}
        end
        Timer._pool_size = Timer._initial_pool
        Timer._initialized = true
        return Timer
    end

    function Timer.schedule(_, interval_seconds, callback, ...)
        if type(callback) ~= "function" then
            error("Timer.schedule: callback must be function", 2)
        end

        local id = alloc_id()
        local node = acquire_node()
        node.valid = true
        node.id = id
        node.callback = callback
        node.interval = interval_seconds
        node.argc = select("#", ...)
        if node.argc > 0 then
            node[1] = ...
        end
        Timer._timers[id] = node
        return id
    end

    Timer.loop = Timer.schedule

    function Timer.cancel(id)
        local node = Timer._timers[id]
        if not node or not node.valid then
            return false
        end

        Timer._timers[id] = nil
        free_id(id)
        release_node(node)
        return true
    end

    return Timer
end

math.distance = math.distance or function()
    return 0
end

math.distance3D = math.distance3D or function(ax, ay, az, bx, by, bz)
    local dx = ax - bx
    local dy = ay - by
    local dz = az - bz
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

dofile(root .. "/Code/Lib/Base/table.lua")

local Timer = require("FrameWork.Manager.Timer")
Timer.init()

local EffectMotion = dofile(root .. "/Code/Logic/Motion/Effect/Entry.lua")

local BURST = 100
local TIMING_SAMPLES = 25
local TIMING_INNER_LOOPS = 200

local shared_actor = {}
local shared_origin = {}
local shared_target = {}

local function noop()
end

local function force_gc()
    collectgarbage("collect")
    collectgarbage("collect")
    return collectgarbage("count")
end

local function kb_to_bytes(kb)
    return kb * 1024.0
end

local function median(values)
    local copy = {}
    for i = 1, #values do
        copy[i] = values[i]
    end
    table.sort(copy)
    local n = #copy
    if n % 2 == 1 then
        return copy[(n + 1) // 2]
    end
    local hi = n // 2 + 1
    return (copy[hi - 1] + copy[hi]) * 0.5
end

local function percentile(values, p)
    local copy = {}
    for i = 1, #values do
        copy[i] = values[i]
    end
    table.sort(copy)
    local index = math.max(1, math.ceil(#copy * p))
    return copy[index]
end

local function round(value, digits)
    local scale = 10 ^ (digits or 0)
    if value >= 0 then
        return math.floor(value * scale + 0.5) / scale
    end
    return math.ceil(value * scale - 0.5) / scale
end

local function build_minimal_config()
    return {
        actor = shared_actor,
    }
end

local function build_charge_like_config()
    return {
        actor = shared_actor,
        origin = shared_origin,
        target = shared_target,
        range = 96.0,
        knock_gap = 0.02,
        knock_cool_down = 0.10,
        dur = 1.0,
        high = 0.0,
        angle = 0.0,
        on_knock = noop,
        on_end = noop,
        need_des = true,
        is_pause = false,
        speed = 12.0,
        acceleration = 0.0,
        charge_distance = 600.0,
        charge_distance_now = 0.0,
    }
end

local function create_configs(builder)
    local items = {}
    for i = 1, BURST do
        items[i] = builder()
    end
    return items
end

local function create_motions(builder)
    local items = {}
    for i = 1, BURST do
        items[i] = EffectMotion.init(builder())
    end
    return items
end

local function cancel_motions(items)
    for i = 1, #items do
        EffectMotion.cancel(items[i])
    end
end

local function describe_memory_case(name, create_fn, release_fn)
    local baseline_kb = force_gc()
    local created = create_fn()
    local after_create_kb = collectgarbage("count")
    local retained_live_kb = force_gc()
    if release_fn then
        release_fn(created)
    end
    created = nil
    local after_release_kb = force_gc()

    return {
        name = name,
        live_heap_kb = retained_live_kb - baseline_kb,
        live_heap_peakish_kb = after_create_kb - baseline_kb,
        residual_heap_kb = after_release_kb - baseline_kb,
        reclaimed_heap_kb = retained_live_kb - after_release_kb,
    }
end

local function warm_timer_pool(builder)
    local items = create_motions(builder)
    cancel_motions(items)
    items = nil
    force_gc()
end

local function timing_samples(name, builder)
    local create_samples = {}
    local cancel_samples = {}

    for sample = 1, TIMING_SAMPLES do
        local create_total = 0.0
        local cancel_total = 0.0

        for _ = 1, TIMING_INNER_LOOPS do
            local motions = {}

            local t0 = os.clock()
            for i = 1, BURST do
                motions[i] = EffectMotion.init(builder())
            end
            local t1 = os.clock()
            for i = 1, BURST do
                EffectMotion.cancel(motions[i])
            end
            local t2 = os.clock()

            create_total = create_total + (t1 - t0)
            cancel_total = cancel_total + (t2 - t1)
        end

        create_samples[sample] = create_total * 1000.0 / TIMING_INNER_LOOPS
        cancel_samples[sample] = cancel_total * 1000.0 / TIMING_INNER_LOOPS
        force_gc()
    end

    local create_batch_ms = median(create_samples)
    local cancel_batch_ms = median(cancel_samples)

    return {
        name = name,
        create_batch_ms = create_batch_ms,
        create_per_init_us = create_batch_ms * 1000.0 / BURST,
        create_batch_p95_ms = percentile(create_samples, 0.95),
        cancel_batch_ms = cancel_batch_ms,
        cancel_per_init_us = cancel_batch_ms * 1000.0 / BURST,
        cancel_batch_p95_ms = percentile(cancel_samples, 0.95),
    }
end

local memory_results = {}

memory_results[#memory_results + 1] = describe_memory_case(
    "config_only_minimal",
    function()
        return create_configs(build_minimal_config)
    end
)

memory_results[#memory_results + 1] = describe_memory_case(
    "effectmotion_minimal_cold",
    function()
        return create_motions(build_minimal_config)
    end,
    cancel_motions
)

warm_timer_pool(build_minimal_config)

memory_results[#memory_results + 1] = describe_memory_case(
    "effectmotion_minimal_warm",
    function()
        return create_motions(build_minimal_config)
    end,
    cancel_motions
)

memory_results[#memory_results + 1] = describe_memory_case(
    "config_only_charge_like",
    function()
        return create_configs(build_charge_like_config)
    end
)

warm_timer_pool(build_charge_like_config)

memory_results[#memory_results + 1] = describe_memory_case(
    "effectmotion_charge_like_warm",
    function()
        return create_motions(build_charge_like_config)
    end,
    cancel_motions
)

local timing_results = {
    timing_samples("effectmotion_minimal_warm", build_minimal_config),
    timing_samples("effectmotion_charge_like_warm", build_charge_like_config),
}

print("EffectMotion.init benchmark")
print("burst=" .. BURST)
print("timing_samples=" .. TIMING_SAMPLES .. ", inner_loops=" .. TIMING_INNER_LOOPS)
print("")
print("[memory]")

for _, item in ipairs(memory_results) do
    print(string.format(
        "%s live_kb=%.3f live_bytes_per_call=%.1f peakish_kb=%.3f residual_kb=%.3f reclaimed_kb=%.3f",
        item.name,
        round(item.live_heap_kb, 3),
        round(kb_to_bytes(item.live_heap_kb) / BURST, 1),
        round(item.live_heap_peakish_kb, 3),
        round(item.residual_heap_kb, 3),
        round(item.reclaimed_heap_kb, 3)
    ))
end

print("")
print("[timing]")

for _, item in ipairs(timing_results) do
    print(string.format(
        "%s create_batch_ms=%.6f create_per_init_us=%.3f create_p95_ms=%.6f cancel_batch_ms=%.6f cancel_per_init_us=%.3f cancel_p95_ms=%.6f",
        item.name,
        round(item.create_batch_ms, 6),
        round(item.create_per_init_us, 3),
        round(item.create_batch_p95_ms, 6),
        round(item.cancel_batch_ms, 6),
        round(item.cancel_per_init_us, 3),
        round(item.cancel_batch_p95_ms, 6)
    ))
end

print("")
print("[notes]")
print("memory uses collectgarbage('count') deltas after forced full GC")
print("live_kb is retained heap while 100 objects are still alive")
print("residual_kb is heap delta after cancel/release plus full GC")
print("timing is warm steady-state CPU time per burst of 100 init/cancel operations")
