local DataType = require "Lib.Base.DataType"
local Motion = require "Logic.Process.Motion.Entry"

local math_abs = math.abs
local math_pi = math.pi
local math_sin = math.sin
local type = type
local DataType_get = DataType.get

local TICK_DELTA = Motion.DEFAULT_TICK
local DEGREE_TO_RADIAN = math_pi / 180.0
local TWO_PI = math_pi * 2.0

local move_func = Motion.move_func

--[[
    垂直运动库。

    这个库只处理 actor 的 z 轴变化，不修改 x/y。
    目前提供 5 类常用垂直运动：
    1. `Motion.vertical`：基础单向升降/下落
    2. `Motion.up`：向上位移的薄包装
    3. `Motion.down`：向下位移的薄包装
    4. `Motion.jump`：定时跳跃/击飞/落地弧线
    5. `Motion.hover`：正弦悬浮/上下浮动

    设计取向：
    - 配置字段尽量扁平化，优先使用标量字段；
    - 运行态直接挂在 `config` / `motion` 上；
    - 初始化阶段尽量多做准备，tick 热路径只保留纯数值推进；
    - 当前项目已支持 `actor.z = value` 直接走实体 setter，
      因此本库直接写 z 属性，不再额外封装一层 z-only setter；
    - 不依赖其他运动库做共享逻辑，也不修改 `Motion.Entry`。

    模块文件名：
    - `Code/Logic/Process/Motion/Vertical.lua`
    - 典型引用方式：`require "Logic.Process.Motion.Vertical"`
]]

--[[
    准备所有垂直运动共享的基础输入：
    1. 校验 actor 是否属于当前 Motion 框架支持的类型；
    2. 解析起点高度 `start_z`，未传时默认取 actor 当前 z。

    返回值：
    - `start_z`：本次垂直运动的起点高度
]]
local function prepareVerticalBase(actor, config)
    if not move_func[DataType_get(actor)] then
        return
    end

    local start_z = config.start_z
    if type(start_z) ~= "number" then
        start_z = actor.z
    end

    return start_z
end

--[[
    解析终点高度。

    规则：
    1. 如果传了 `end_z`，优先使用绝对终点高度；
    2. 否则读取 `delta_z`，把它换算成 `end_z = start_z + delta_z`；
    3. 某些调用（如 jump）允许“不传终点时默认回到起点”，
       此时 `keep_start_by_default = true` 会返回 `start_z, 0.0`。

    返回值：
    - `end_z`：绝对终点高度
    - `delta_z`：相对起点的高度偏移
]]
local function resolveEndZ(config, start_z, keep_start_by_default)
    local end_z = config.end_z
    if type(end_z) == "number" then
        return end_z, end_z - start_z
    end

    local delta_z = config.delta_z
    if type(delta_z) == "number" then
        end_z = start_z + delta_z
        return end_z, delta_z
    end

    if keep_start_by_default then
        return start_z, 0.0
    end
end

--[[
    基础升降/下落的逐帧推进。

    运行模型：
    1. 速度按 `acceleration` 推进；
    2. 用本帧位移量累加“已移动距离”；
    3. 若即将越过终点，则直接钳到最终 `end_z`；
    4. 否则把 actor 当前 z 推进一个 `delta_z`。

    终止条件：
    - 累计移动距离达到 `_vertical_distance`
]]
local function updateVertical(fsm)
    local actor = fsm.actor
    local motion = fsm.motion

    motion.speed = motion.speed + motion.acceleration * TICK_DELTA
    local delta_z = motion.speed * TICK_DELTA
    local tick_distance = math_abs(delta_z)
    local moved = motion._vertical_moved + tick_distance
    if moved >= motion._vertical_distance then
        motion._vertical_moved = motion._vertical_distance
        actor.z = motion._vertical_end_z
        return true
    end

    motion._vertical_moved = moved
    actor.z = actor.z + delta_z
    return false
end

--[[
    初始化基础垂直位移。

    配置契约：
    - 必须能解析出终点：`end_z` 或 `delta_z`
    - `speed` / `acceleration` 用“幅值”输入，方向在这里统一折算

    这里会缓存：
    - `_vertical_end_z`：最终终点
    - `_vertical_distance`：总位移距离
    - `_vertical_moved`：当前累计位移

    同时会把 `speed` / `acceleration` 改写成带方向的运行态值，
    这样 tick 阶段不需要再判断“向上还是向下”。
]]
local function prepareVerticalConfig(actor, config)
    local start_z = prepareVerticalBase(actor, config)
    if not start_z then
        return
    end

    local end_z, delta_z = resolveEndZ(config, start_z, false)
    if not end_z then
        return
    end

    local direction = delta_z >= 0.0 and 1.0 or -1.0
    local speed = config.speed or 0.0
    local acceleration = config.acceleration or 0.0

    if type(speed) ~= "number" or type(acceleration) ~= "number" then
        return
    end

    speed = math_abs(speed)
    acceleration = math_abs(acceleration)

    -- 没有位移且没有速度/加速度时，不创建一个永远不会结束的运动。
    if delta_z ~= 0.0 and speed == 0.0 and acceleration == 0.0 then
        return
    end

    config.start_z = start_z
    config.end_z = end_z
    config.delta_z = delta_z
    config.speed = speed * direction
    config.acceleration = acceleration * direction
    config._vertical_end_z = end_z
    config._vertical_distance = math_abs(delta_z)
    config._vertical_moved = 0.0

    actor.z = start_z
    return true
end

--[[
    跳跃/击飞的逐帧推进。

    运行模型：
    - 用 `control_t` 表示 0~1 的归一化进度；
    - 线性项 `start_z + delta_z * t` 表示起点到终点的基础过渡；
    - 弧线项 `jump_high * 4t(1-t)` 表示额外抬高的跳跃高度。

    这样既可以做：
    - 原地跳起后落回原地
    - 从低处跳到高处
    - 从高处落到低处但中间带一个抛起高度
]]
local function updateJump(fsm)
    local actor = fsm.actor
    local motion = fsm.motion
    local t = motion.control_t + motion._jump_t_step

    if t >= 1.0 then
        t = 1.0
    end

    motion.control_t = t

    local curve = 4.0 * t * (1.0 - t)
    local z = motion.start_z + motion._jump_delta_z * t + motion._jump_high * curve
    actor.z = z

    return t >= 1.0
end

--[[
    初始化跳跃/击飞运动。

    必填约束：
    - `dur` 或 `time` 必须大于 0

    可选契约：
    - `end_z` / `delta_z`：不传时默认回到 `start_z`
    - `jump_high`：额外抬高量，按绝对值处理
    - `control_t`：起始进度，常用于中途接管或恢复

    缓存字段：
    - `_jump_t_step`：每帧推进多少进度
    - `_jump_delta_z`：起点到终点的基础位移
    - `_jump_high`：抛物线额外高度
]]
local function prepareJumpConfig(actor, config)
    local start_z = prepareVerticalBase(actor, config)
    if not start_z then
        return
    end

    local dur = config.dur or config.time
    if type(dur) ~= "number" or dur <= 0.0 then
        return
    end

    local end_z, delta_z = resolveEndZ(config, start_z, true)
    local jump_high = config.jump_high or 0.0
    local control_t = config.control_t or 0.0

    if type(jump_high) ~= "number" or type(control_t) ~= "number" then
        return
    end

    jump_high = math_abs(jump_high)

    if control_t < 0.0 then
        control_t = 0.0
    elseif control_t > 1.0 then
        control_t = 1.0
    end

    if delta_z == 0.0 and jump_high == 0.0 then
        return
    end

    config.start_z = start_z
    config.end_z = end_z
    config.delta_z = delta_z
    config.dur = dur
    config.jump_high = jump_high
    config.control_t = control_t
    config._jump_delta_z = delta_z
    config._jump_high = jump_high
    config._jump_t_step = TICK_DELTA / dur

    local curve = 4.0 * control_t * (1.0 - control_t)
    local z = start_z + delta_z * control_t + jump_high * curve
    actor.z = z
    return true
end

--[[
    悬浮/漂浮的逐帧推进。

    运行模型：
    - 以 `start_z` 为基准高度；
    - 用 `sin(phase)` 做周期性上下波动；
    - `period` 决定完整周期时长；
    - 可选 `dur` 控制总持续时间。

    结束行为：
    - 如果设置了有限持续时间，结束时会回到 `start_z`
]]
local function updateHover(fsm)
    local actor = fsm.actor
    local motion = fsm.motion

    motion._hover_phase = motion._hover_phase + motion._hover_phase_step
    local z = motion.start_z + motion._hover_amplitude * math_sin(motion._hover_phase)
    actor.z = z

    local need_to_end = false
    if type(motion.dur) == "number" then
        motion.dur = motion.dur - TICK_DELTA
        need_to_end = motion.dur <= 0.0
        if need_to_end then
            actor.z = motion.start_z
        end
    end

    return need_to_end
end

--[[
    初始化悬浮运动。

    必填约束：
    - `amplitude`：振幅，必须大于 0
    - `period`：周期，必须大于 0

    可选契约：
    - `phase`：初始相位，角度制输入
    - `dur` / `time`：若省略，则会一直悬浮，直到外部取消
]]
local function prepareHoverConfig(actor, config)
    local start_z = prepareVerticalBase(actor, config)
    if not start_z then
        return
    end

    local amplitude = config.amplitude or 0.0
    local period = config.period
    local phase = config.phase or 0.0
    local dur = config.dur or config.time

    if type(amplitude) ~= "number" or type(period) ~= "number" or period <= 0.0 or type(phase) ~= "number" then
        return
    end

    amplitude = math_abs(amplitude)
    if amplitude == 0.0 then
        return
    end

    if dur ~= nil then
        if type(dur) ~= "number" or dur <= 0.0 then
            return
        end
        config.dur = dur
    else
        config.dur = nil
    end

    config.start_z = start_z
    config.amplitude = amplitude
    config.period = period
    config.phase = phase
    config._hover_amplitude = amplitude
    config._hover_phase = phase * DEGREE_TO_RADIAN
    config._hover_phase_step = TWO_PI * TICK_DELTA / period

    actor.z = start_z + amplitude * math_sin(config._hover_phase)
    return true
end

--[[
    为 `up` / `down` 这类方向包装器准备相对位移。

    规则：
    - 优先读取 `max_distance`
    - 其次读取 `delta_z`
    - 两者都会被标准化为指定方向的绝对值
    - 同时清空 `end_z`，避免与方向包装器语义冲突
]]
local function prepareDirectedDistance(config, direction)
    local max_distance = config.max_distance
    if type(max_distance) == "number" then
        config.end_z = nil
        config.delta_z = math_abs(max_distance) * direction
        return true
    end

    local delta_z = config.delta_z
    if type(delta_z) == "number" then
        config.end_z = nil
        config.delta_z = math_abs(delta_z) * direction
        return true
    end
end

--[[
    基础垂直位移。

    适用场景：
    - 单纯升起或下落
    - 往指定高度推进
    - 不需要弧线、悬浮或周期波动的 z 轴运动

    配置字段：
    - `start_z`：可选，起点高度；默认取 `actor.z`
    - `end_z`：可选，绝对终点高度；若传入，则优先级高于 `delta_z`
    - `delta_z`：可选，相对位移；正数向上，负数向下
    - `speed`：可选，初速度幅值，单位：每秒
    - `acceleration`：可选，加速度幅值，单位：每秒平方
    - `onEnd`：可选，运动结束回调

    使用示例：
    ```lua
    Motion.vertical(actor, {
        delta_z = -600.0,
        speed = 900.0,
        acceleration = 1200.0,
        onEnd = function(fsm)
        end
    })
    ```

    ```lua
    Motion.vertical(actor, {
        start_z = 300.0,
        end_z = 900.0,
        speed = 600.0,
        acceleration = 0.0,
    })
    ```
]]
function Motion.vertical(actor, config)
    if type(config) ~= "table" then
        return
    end

    if not prepareVerticalConfig(actor, config) then
        return
    end

    config.move_method = updateVertical
    Motion.set(actor, config)
end

--[[
    向上位移包装器。

    这是 `Motion.vertical` 的语义化薄包装，
    只负责把输入标准化为“向上”的 `delta_z`。

    配置字段：
    - `max_distance`：可选，向上移动的绝对距离，优先级高于 `delta_z`
    - `delta_z`：可选，相对位移，内部会强制转成正数
    - 其余字段与 `Motion.vertical` 一致

    注意：
    - 这个包装器不使用 `end_z`
    - 传了 `max_distance` / `delta_z` 后，会自动按“向上”语义改写

    使用示例：
    ```lua
    Motion.up(actor, {
        max_distance = 250.0,
        speed = 800.0,
        acceleration = 0.0,
    })
    ```
]]
function Motion.up(actor, config)
    if type(config) ~= "table" then
        return
    end

    if not prepareDirectedDistance(config, 1.0) then
        return
    end

    Motion.vertical(actor, config)
end

--[[
    向下位移包装器。

    这是 `Motion.vertical` 的语义化薄包装，
    只负责把输入标准化为“向下”的 `delta_z`。

    配置字段：
    - `max_distance`：可选，向下移动的绝对距离，优先级高于 `delta_z`
    - `delta_z`：可选，相对位移，内部会强制转成负数
    - 其余字段与 `Motion.vertical` 一致

    注意：
    - 这个包装器不使用 `end_z`
    - 传了 `max_distance` / `delta_z` 后，会自动按“向下”语义改写

    使用示例：
    ```lua
    Motion.down(actor, {
        max_distance = 400.0,
        speed = 0.0,
        acceleration = 1800.0,
    })
    ```
]]
function Motion.down(actor, config)
    if type(config) ~= "table" then
        return
    end

    if not prepareDirectedDistance(config, -1.0) then
        return
    end

    Motion.vertical(actor, config)
end

--[[
    定时跳跃 / 击飞 / 落地弧线。

    这个运动会固定 x/y，只在 z 轴上画一条简单弧线：
    - 线性项负责“从起点过渡到终点”
    - `jump_high` 负责“中途抬高多少”

    因此它适合：
    - 原地小跳
    - 击飞后落回地面
    - 从低台阶跳到高台阶

    配置字段：
    - `start_z`：可选，起点高度；默认取 `actor.z`
    - `end_z`：可选，绝对终点高度；不传时默认等于 `start_z`
    - `delta_z`：可选，相对终点偏移
    - `jump_high`：可选，弧线额外高度；按绝对值处理
    - `dur` / `time`：必填，持续时间，单位：秒
    - `control_t`：可选，初始进度，范围 0~1
    - `onEnd`：可选，运动结束回调

    说明：
    - `jump_high = 0.0` 时，会退化成一个按时间推进的线性 z 位移
    - `end_z = start_z` 且 `jump_high > 0` 时，就是常见的原地跳

    使用示例：
    ```lua
    Motion.jump(actor, {
        jump_high = 350.0,
        dur = 0.50,
    })
    ```

    ```lua
    Motion.jump(actor, {
        end_z = 600.0,
        jump_high = 200.0,
        dur = 0.35,
    })
    ```
]]
function Motion.jump(actor, config)
    if type(config) ~= "table" then
        return
    end

    if not prepareJumpConfig(actor, config) then
        return
    end

    config.move_method = updateJump
    Motion.set(actor, config)
end

--[[
    悬浮 / 漂浮 / 上下波动。

    这是一个正弦型 z 轴周期运动：
    - 以 `start_z` 为基准高度；
    - 以 `amplitude` 控制上下摆幅；
    - 以 `period` 控制完整周期时长；
    - 以 `phase` 控制初始相位。

    适合场景：
    - 待机漂浮特效
    - 光球 / 法阵 / 守卫物的上下浮动
    - 需要“呼吸感”的悬浮 actor

    配置字段：
    - `start_z`：可选，基准高度；默认取 `actor.z`
    - `amplitude`：必填，振幅
    - `period`：必填，周期，单位：秒
    - `phase`：可选，初始相位，角度制输入
    - `dur` / `time`：可选，总持续时间；不传则会一直悬浮直到外部取消
    - `onEnd`：可选，运动结束回调

    结束行为：
    - 如果配置了有限时长，结束时会回到 `start_z`

    使用示例：
    ```lua
    Motion.hover(actor, {
        amplitude = 80.0,
        period = 1.2,
    })
    ```

    ```lua
    Motion.hover(actor, {
        start_z = 450.0,
        amplitude = 60.0,
        period = 0.8,
        phase = 90.0,
        dur = 3.0,
    })
    ```
]]
function Motion.hover(actor, config)
    if type(config) ~= "table" then
        return
    end

    if not prepareHoverConfig(actor, config) then
        return
    end

    config.move_method = updateHover
    Motion.set(actor, config)
end

return Motion
