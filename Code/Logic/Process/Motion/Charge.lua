local DataType = require "Lib.Base.DataType"
local Motion = require "Logic.Process.Motion.Entry"

local math_sqrt = math.sqrt
local math_cos = math.cos
local math_sin = math.sin
local math_pi = math.pi
local type = type
local DataType_get = DataType.get

local CONTACT_LIMIT = Motion.CONTACT_LIMIT
local CONTACT_LIMIT_SQUARED = CONTACT_LIMIT * CONTACT_LIMIT
local TICK_DELTA = Motion.DEFAULT_TICK
local DEGREE_TO_RADIAN = math_pi / 180.0

local move_func = Motion.move_func

--为冲锋补齐运行时字段
local function prepareChargeConfig(config)
    config.speed = config.speed or 0.0
    config.acceleration = config.acceleration or 0.0
    config._distance_moved = 0.0
end

--[[
    根据 motion 内保存的三维方向向量推进一帧位置
]]
local function calculatePos(motion, actor)
    local actor_x, actor_y, actor_z = actor.x, actor.y, actor.z
    motion.speed = motion.speed + motion.acceleration * TICK_DELTA
    local tick_speed = motion.speed * TICK_DELTA

    actor_x = actor_x + tick_speed * motion._charge_direction_x
    actor_y = actor_y + tick_speed * motion._charge_direction_y
    actor_z = actor_z + tick_speed * motion._charge_direction_z
    motion._distance_moved = motion._distance_moved + tick_speed

    return actor_x, actor_y, actor_z
end

--[[
    锁定目标冲锋的逐帧更新
]]
local function updateLockOnCharge(fsm)
    local actor = fsm.actor
    local motion = fsm.motion
    local target = motion.target
    if not target then return true end

    local target_x, target_y, target_z = target.x, target.y, target.z
    local offset_x = target_x - actor.x
    local offset_y = target_y - actor.y
    local offset_z = target_z - actor.z
    local length_squared = offset_x * offset_x + offset_y * offset_y + offset_z * offset_z

    if length_squared > 0.0 then
        local inverse_length = 1.0 / math_sqrt(length_squared)
        motion._charge_direction_x = offset_x * inverse_length
        motion._charge_direction_y = offset_y * inverse_length
        motion._charge_direction_z = offset_z * inverse_length
    else
        motion._charge_direction_x = 0.0
        motion._charge_direction_y = 0.0
        motion._charge_direction_z = 0.0
    end

    local actor_x, actor_y, actor_z = calculatePos(motion, actor)
    local method = move_func[DataType_get(actor)]
    method.setPosition(actor, actor_x, actor_y, actor_z)
    method.setFace(actor, target_x, target_y, target_z)

    offset_x = target_x - actor_x
    offset_y = target_y - actor_y
    offset_z = target_z - actor_z

    local need_to_end = offset_x * offset_x + offset_y * offset_y + offset_z * offset_z < CONTACT_LIMIT_SQUARED
    return need_to_end
end

--[[
    固定距离冲锋的逐帧更新
    这个冲锋在创建时就会把方向写死到 `_charge_direction_x/y/z`，
    update 期间不再刷新方向，只负责：
    1. 按当前方向前进；
    2. 用累计移动距离判断是否结束。
]]
local function updateBoundedCharge(fsm)
    local actor = fsm.actor
    local motion = fsm.motion

    local actor_x, actor_y, actor_z = calculatePos(motion, actor)
    local method = move_func[DataType_get(actor)]
    method.setPosition(actor, actor_x, actor_y, actor_z)

    local need_to_end = motion._distance_moved >= motion.max_distance
    return need_to_end
end

--[[
    锁定目标的冲锋。
    config = {
        target：必须，目标对象，要求可读 `x/y/z`
        speed：可选，初速度，按每秒输入
        acceleration：可选，加速度，按每秒输入
        onEnd：可选，结束回调
    }
    初始化时会先算一次初始方向，后续每帧再由 `updateLockOnCharge` 继续刷新。
]]
function Motion.lockOnCharge(actor, config)
    if not config or not config.target then return end

    prepareChargeConfig(config)

    local target = config.target
    local target_x, target_y, target_z = target.x, target.y, target.z
    local offset_x = target_x - actor.x
    local offset_y = target_y - actor.y
    local offset_z = target_z - actor.z
    local length_squared = offset_x * offset_x + offset_y * offset_y + offset_z * offset_z

    if length_squared > 0.0 then
        local inverse_length = 1.0 / math_sqrt(length_squared)
        config._charge_direction_x = offset_x * inverse_length
        config._charge_direction_y = offset_y * inverse_length
        config._charge_direction_z = offset_z * inverse_length
    else
        config._charge_direction_x = 0.0
        config._charge_direction_y = 0.0
        config._charge_direction_z = 0.0
    end

    config.move_method = updateLockOnCharge
    Motion.set(actor, config)
end

--[[
    固定距离的冲锋。
    config = {
        max_distance：必须，最大冲锋距离
        angle：可选，水平角，按角度制输入
        pitch：可选，俯仰角，按角度制输入
        speed：可选，初速度，按每秒输入
        acceleration：可选，加速度，按每秒输入
        onEnd：可选，结束回调

        --私有变量，不应外部修改
        _charge_direction_x：单位方向向量x分量
        _charge_direction_y：单位方向向量y分量
        _charge_direction_z：单位方向向量z分量
        _distance_moved：累计移动距离
    }
    初始化时直接把单位方向向量写入 `_charge_direction_x/y/z`。
    之后整个冲锋过程不再更新方向，只以累计位移是否达到上限来结束。
]]
function Motion.BoundedCharge(actor, config)
    if type(config) ~= "table" then return end

    local max_distance = config.max_distance
    if type(max_distance) ~= "number" then return end

    local angle = (config.angle or 0.0) * DEGREE_TO_RADIAN
    local pitch = (config.pitch or 0.0) * DEGREE_TO_RADIAN
    local cos_pitch = math_cos(pitch)
    local method = move_func[DataType_get(actor)]

    prepareChargeConfig(config)
    config._charge_direction_x = cos_pitch * math_cos(angle)
    config._charge_direction_y = cos_pitch * math_sin(angle)
    config._charge_direction_z = math_sin(pitch)
    config.max_distance = max_distance
    config.move_method = updateBoundedCharge

    method.setFace(
        actor,
        actor.x + config._charge_direction_x,
        actor.y + config._charge_direction_y,
        actor.z + config._charge_direction_z
    )

    Motion.set(actor, config)
end

function Motion.BoundedChargeByPoint(actor, config)
    if type(config) ~= "table" then return end


end

return Motion
