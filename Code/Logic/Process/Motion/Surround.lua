local DataType = require "Lib.Base.DataType"
local Motion = require "Logic.Process.Motion.Entry"


local math_cos = math.cos
local math_sin = math.sin
local math_pi = math.pi
local type = type
local DataType_get = DataType.get

local TICK_DELTA = Motion.DEFAULT_TICK
local DEGREE_TO_RADIAN = math_pi / 180.0

local move_func = Motion.move_func

--[[
    普通环绕的逐帧更新。

    - `motion.angle` 用角度制保存当前角度
    - `motion.angle_spd` 每秒增加的角度
    - `motion.acceleration` 每秒增加的角速度
    - `motion.radius` 表示环绕半径
    - `motion.high` 表示环绕时的相对actor当前坐标的z高度
]]
local function updateSurround(fsm)
    local actor = fsm.actor
    local motion = fsm.motion
    local target = motion.target
    if not target or target.alive == false then
        return true
    end

    motion.angle_spd = motion.angle_spd + motion.acceleration * TICK_DELTA
    motion.angle = motion.angle + motion.angle_spd

    local angle_radian = motion.angle * DEGREE_TO_RADIAN
    local surround_x = target.x + motion.radius * math_cos(angle_radian)
    local surround_y = target.y + motion.radius * math_sin(angle_radian)
    local surround_z = motion.high + actor.z
    local method = move_func[DataType_get(actor)]

    method.setPosition(actor, surround_x, surround_y, surround_z)

    local need_to_end = false

    if type(motion.dur) == "number" then
        motion.dur = motion.dur - TICK_DELTA
        need_to_end = motion.dur <= 0.0
    end

    return need_to_end
end

--[[
    普通环绕运动。

    config = {
        - `target`：必须，环绕目标
        - `radius`：可选，环绕半径
        - `angle`：可选，初始角度，角度制
        - `angle_spd`：可选，角速度，单位是“度/秒”；兼容 `aspd`
        - `acceleration`：可选，角加速度，单位是“度/秒^2”
        - `dur`：可选，持续时间，单位秒；兼容 `time`
        - `high`：可选，环绕时使用的绝对 z 高度；未传时默认取 actor 当前 z
    }
    

    设计取向与当前 Charge.lua 一致：
    - 输入语义偏开发友好
    - 运行时字段直接挂在 motion 上
    - 不额外创建对象
    - 不修改其他文件
]]
function Motion.surround(actor, config)
    if type(config) ~= "table" then return end

    local target = config.target
    if not target then return end

    local method = move_func[DataType_get(actor)]
    if not method then return end

    config.radius = config.radius or 0.0
    config.angle = config.angle or 0.0
    config.angle_spd = config.angle_spd or 0.0
    config.acceleration = config.acceleration or 0.0
    config.dur = config.dur
    config.high = config.high or 0.0
    config.move_method = updateSurround

    local angle_radian = config.angle * DEGREE_TO_RADIAN
    local target_x = target.x + config.radius * math_cos(angle_radian)
    local target_y = target.y + config.radius * math_sin(angle_radian)
    method.setPosition(actor, target_x, target_y, config.high)

    Motion.set(actor, config)
end


return Motion
