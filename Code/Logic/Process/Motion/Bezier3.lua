local DataType = require "Lib.Base.DataType"
local Motion = require "Logic.Process.Motion.Entry"

local type = type
local DataType_get = DataType.get
local math_clamp = math.clamp

local TICK_DELTA = Motion.DEFAULT_TICK
local move_func = Motion.move_func

--[[
    三阶贝塞尔运动库。

    这一版继续向 Charge / Surround 靠拢：
    1. 配置字段尽量扁平，不再额外创建坐标 table；
    2. 运行态字段直接挂在 motion(config) 上；
    3. 热路径只保留 t 推进、数值求值、落位与可选转向。
]]


--[[
    Horner 形式求值。
    默认路径只负责 setPosition；
    只有 `need_face = true` 时才额外计算切线方向。
]]
local function moveBezier(actor, motion, ax, ay, az, t)
    local x = ((ax * t + motion._bezier_bx) * t + motion._bezier_cx) * t + motion._bezier_dx
    local y = ((ay * t + motion._bezier_by) * t + motion._bezier_cy) * t + motion._bezier_dy
    local z = ((az * t + motion._bezier_bz) * t + motion._bezier_cz) * t + motion._bezier_dz
    local method = motion._bezier_method

    method.setPosition(actor, x, y, z)

    if motion.need_face then
        local tangent_x = (3.0 * ax * t + 2.0 * motion._bezier_bx) * t + motion._bezier_cx
        local tangent_y = (3.0 * ay * t + 2.0 * motion._bezier_by) * t + motion._bezier_cy
        local tangent_z = (3.0 * az * t + 2.0 * motion._bezier_bz) * t + motion._bezier_cz

        if tangent_x ~= 0.0 or tangent_y ~= 0.0 or tangent_z ~= 0.0 then
            method.setFace(actor, x + tangent_x, y + tangent_y, z + tangent_z)
        end
    end
end

local function updateBezier3(fsm)
    local motion = fsm.motion
    local t = motion.control_t + motion._bezier_t_step

    if t >= 1.0 then
        t = 1.0
    end

    motion.control_t = t
    moveBezier(fsm.actor, motion, motion._bezier_ax, motion._bezier_ay, motion._bezier_az, t)

    local need_to_end = t >= 1.0
    return need_to_end
end

--[[
    锁定目标版：
    起点和两个控制点只在创建时确定；
    终点每帧直接读取 target.x / target.y / target.z。
]]
local function updateLockOnBezier3(fsm)
    local motion = fsm.motion
    local target = motion.target
    local need_to_end = false

    if target then
        local end_x = target.x
        local end_y = target.y
        local end_z = target.z

        local t = motion.control_t + motion._bezier_t_step
        if t >= 1.0 then
            t = 1.0
        end

        motion.control_t = t
        moveBezier(
            fsm.actor,
            motion,
            motion._bezier_base_ax + end_x,
            motion._bezier_base_ay + end_y,
            motion._bezier_base_az + end_z,
            t
        )
    else
        need_to_end = true
    end

    return need_to_end
end

--[[
    初始化 Bezier3 公共运行态。
    自动控制点默认规则：
    - control_one 在起点到终点的 1/3 处；
    - control_two 在起点到终点的 2/3 处；
    - `control_high` / `control_one_high` / `control_two_high`
      只作用于自动生成控制点的 z 偏移。
]]
local function prepareBezierConfig(actor, config, end_x, end_y, end_z)
    local method = move_func[DataType_get(actor)]
    if not method then
        return
    end

    local dur = config.dur or config.time or 1.0
    if type(dur) ~= "number" or dur <= 0.0 then
        return
    end

    local start_x = config.start_x or actor.x
    local start_y = config.start_y or actor.y
    local start_z = config.start_z or actor.z
    local delta_x = end_x - start_x
    local delta_y = end_y - start_y
    local delta_z = end_z - start_z

    local control_high = config.control_high or 0.0
    local control_one_high = config.control_one_high or control_high
    local control_two_high = config.control_two_high or control_high

    local control_one_x = config.control_one_x or start_x + delta_x / 3.0
    local control_one_y = config.control_one_y or start_y + delta_y / 3.0
    local control_one_z = config.control_one_z or start_z + delta_z / 3.0 + control_one_high

    local control_two_x = config.control_two_x or start_x + delta_x * 2.0 / 3.0
    local control_two_y = config.control_two_y or start_y + delta_y * 2.0 / 3.0
    local control_two_z = config.control_two_z or start_z + delta_z * 2.0 / 3.0 + control_two_high

    config.dur = dur
    config.need_face = config.need_face == true
    config.control_t = math_clamp(config.control_t, 0.0, 1.0)
    config._bezier_method = method
    config._bezier_t_step = TICK_DELTA / dur

    return start_x, start_y, start_z, control_one_x, control_one_y, control_one_z, control_two_x, control_two_y, control_two_z
end

local function prepareFixedBezierConfig(actor, config, end_x, end_y, end_z)
    local start_x, start_y, start_z, control_one_x, control_one_y, control_one_z, control_two_x, control_two_y, control_two_z = prepareBezierConfig(actor, config, end_x, end_y, end_z)
    if not start_x then
        return
    end
    --固定终点版直接缓存完整多项式系数：
    --P(t) = a * t^3 + b * t^2 + c * t + d
    config._bezier_ax = -start_x + 3.0 * control_one_x - 3.0 * control_two_x + end_x
    config._bezier_ay = -start_y + 3.0 * control_one_y - 3.0 * control_two_y + end_y
    config._bezier_az = -start_z + 3.0 * control_one_z - 3.0 * control_two_z + end_z

    config._bezier_bx = 3.0 * start_x - 6.0 * control_one_x + 3.0 * control_two_x
    config._bezier_by = 3.0 * start_y - 6.0 * control_one_y + 3.0 * control_two_y
    config._bezier_bz = 3.0 * start_z - 6.0 * control_one_z + 3.0 * control_two_z

    config._bezier_cx = -3.0 * start_x + 3.0 * control_one_x
    config._bezier_cy = -3.0 * start_y + 3.0 * control_one_y
    config._bezier_cz = -3.0 * start_z + 3.0 * control_one_z

    config._bezier_dx = start_x
    config._bezier_dy = start_y
    config._bezier_dz = start_z

    moveBezier(actor, config, config._bezier_ax, config._bezier_ay, config._bezier_az, config.control_t)
    return true
end

local function prepareLockOnBezierConfig(actor, config, end_x, end_y, end_z)
    local start_x, start_y, start_z, control_one_x, control_one_y, control_one_z, control_two_x, control_two_y, control_two_z = prepareBezierConfig(actor, config, end_x, end_y, end_z)
    if not start_x then
        return
    end
    --只缓存与终点无关的部分,之后每帧只需要读 target 当前坐标，再把终点加回 a 系数。
    config._bezier_base_ax = -start_x + 3.0 * control_one_x - 3.0 * control_two_x
    config._bezier_base_ay = -start_y + 3.0 * control_one_y - 3.0 * control_two_y
    config._bezier_base_az = -start_z + 3.0 * control_one_z - 3.0 * control_two_z

    config._bezier_bx = 3.0 * start_x - 6.0 * control_one_x + 3.0 * control_two_x
    config._bezier_by = 3.0 * start_y - 6.0 * control_one_y + 3.0 * control_two_y
    config._bezier_bz = 3.0 * start_z - 6.0 * control_one_z + 3.0 * control_two_z

    config._bezier_cx = -3.0 * start_x + 3.0 * control_one_x
    config._bezier_cy = -3.0 * start_y + 3.0 * control_one_y
    config._bezier_cz = -3.0 * start_z + 3.0 * control_one_z

    config._bezier_dx = start_x
    config._bezier_dy = start_y
    config._bezier_dz = start_z

    moveBezier(
        actor,
        config,
        config._bezier_base_ax + end_x,
        config._bezier_base_ay + end_y,
        config._bezier_base_az + end_z,
        config.control_t
    )

    return true
end

--[[
    固定终点的三阶贝塞尔运动。

    用法示例：
    Motion.bezier3(actor, {
        end_x = 1200.0,
        end_y = 800.0,
        end_z = 160.0,
        dur = 0.60,
        control_high = 350.0,
        need_face = true,
        onEnd = function(fsm)
        end
    })

    config 说明：
    - `end_x` / `end_y`：必填，固定终点坐标
    - `end_z`：可选，终点 z；不传时默认 actor 当前 z
    - `start_x` / `start_y` / `start_z`：可选，起点；不传时默认 actor 当前坐标
    - `control_one_x` / `control_one_y` / `control_one_z`：可选，第一个控制点
    - `control_two_x` / `control_two_y` / `control_two_z`：可选，第二个控制点
    - `dur` / `time`：可选，持续时间，单位秒，必须大于 0
    - `control_high`：可选，自动控制点共用的 z 偏移
    - `control_one_high`：可选，只作用于自动生成的第一个控制点
    - `control_two_high`：可选，只作用于自动生成的第二个控制点
    - `control_t`：可选，初始进度，范围 0 ~ 1
    - `need_face`：可选，是否沿曲线切线自动转向
    - `onEnd`：可选，运动结束回调
]]
function Motion.bezier3(actor, config)
    if type(config) ~= "table" then
        return
    end

    local end_x = config.end_x
    local end_y = config.end_y
    if type(end_x) ~= "number" or type(end_y) ~= "number" then
        return
    end

    local end_z = config.end_z or actor.z
    if not prepareFixedBezierConfig(actor, config, end_x, end_y, end_z) then
        return
    end

    config.move_method = updateBezier3
    Motion.set(actor, config)
end

--[[
    锁定终点的三阶贝塞尔运动。

    和固定终点版的区别：
    - 起点、控制点只在创建时读取一次；
    - 终点每帧直接读取 `target.x / target.y / target.z`；
    - 当 `target == nil` 或 `target.alive == false` 时，运动立即结束。

    用法示例：
    Motion.lockOnBezier3(actor, {
        target = some_target,
        dur = 0.45,
        control_high = 280.0,
        need_face = true,
    })

    config 说明：
    - `target`：必填，要求目标对象能直接提供 `x / y / z`
    - 其余字段与 `Motion.bezier3` 一致，但不再使用 `end_x / end_y / end_z`
]]
function Motion.lockOnBezier3(actor, config)
    if type(config) ~= "table" then
        return
    end

    local target = config.target
    if not target then
        return
    end

    local end_x = target.x
    local end_y = target.y
    local end_z = target.z
    if type(end_x) ~= "number" or type(end_y) ~= "number" or type(end_z) ~= "number" then
        return
    end

    if not prepareLockOnBezierConfig(actor, config, end_x, end_y, end_z) then
        return
    end

    config.move_method = updateLockOnBezier3
    Motion.set(actor, config)
end


return Motion
