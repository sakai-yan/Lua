local DataType = require "Lib.Base.DataType"
local Unit = require "Core.Entity.Unit"
local Effect = require "Core.Entity.Effect"
local Timer = require "FrameWork.Manager.Timer"
local Vector3 = require "Lib.Base.Vector3"
local State = require "FrameWork.Manager.State"
local Set     = require "Lib.Base.Set"


local math_sqrt = math.sqrt
local math_atan = math.atan
local math_cos = math.cos
local math_sin = math.sin

local Vector3_set = Vector3.set
local Vector3_get = Vector3.get
local Unit_getEnumUnit = Unit.GetEnumUnit
local Effect_getEnumEffect = Effect.GetEnumEffect

local MOTION_DEFAULT_TICK = State.DEFAULT_TICK

local motion_set = Set.new()

local Motion = {
    --判定到达目的地的最长距离
    CONTACT_LIMIT = 96.0,

    --运动器默认Tick时间
    DEFAULT_TICK = MOTION_DEFAULT_TICK,
    
    move_func = {
        effect = {
            setFace = Effect.setFacing,
            setPosition = Effect.setPosition,
            getPosition = Effect.getPosition
        },

        missile = {
            setFace = Effect.setFacing,
            setPosition = Effect.setPosition,
            getPosition = Effect.getPosition
        },

        unit = {
            setFace = Unit.setFacing,
            setPosition = Unit.setPosition,
            getPosition = Unit.getPosition
        }
    }
}

--[[
    --来源单位
    "origin",
    --目标单位
    "target",
    --持续时间
    "dur",
    --初始高度
    "high",
    --运动函数，以motion为参数
    move_method
    --运动（持续时间/命中目标）结束事件，参数为motion（运动器）
    "onEnd",
    --运动结束是否删除actor，true删除
    "need_to_des",
    --是否暂停运动
    "is_pause",
    --环绕板块
    --环绕目标单位
    "surround",
    --角速度
    "angle_spd",
    --环绕半径
    "surround_radius",
    --冲锋板块
    --起始速度标量，配置项
    "speed",
    --三维速度,vector3
    "speed_vector3",
    --加速度标量
    "acceleration",
    --三维加速度,vector3
    "acceleration_vector3",
    --冲锋距离
    "charge_distance",
    --移动过的距离
    "charge_distance_now",
    --贝塞尔板块
    --起点
    "start_x", "start_y", "start_z",
    --终点
    "end_x", "end_y", "end_z",
    --控制点1
    "control_one_x", "control_one_y", "control_one_z",
    --控制点2
    "control_two_x", "control_two_y", "control_two_z",
    "control_t"
]]

function Motion.execute(fsm)
    local motion = fsm.motion
    if motion then
        if motion.is_pause then return end
        local need_to_end
        if type(motion.move_method) == "function" then
            need_to_end = motion.move_method(fsm)
        end

        --运动是否结束
        if need_to_end then
            if type(motion.onEnd) == "function" then
                motion.onEnd(fsm)
            end

            if motion.need_to_des then
                motion.actor:destroy()
            end
        else
            --有actor且is_end为false才不会执行onDestroy
            return
        end
    end
        
    --执行销毁运动器
    Motion.cancel(fsm)
end

--设置运动，与碰撞不同，具备自动创建状态机的功能
function Motion.set(actor, config)
    local fsm = State.getByActor(actor)
    if not fsm then
        fsm = State.new({
            actor = actor,
            onTick = Motion.execute,
            tick = Motion.DEFAULT_TICK,
            motion = config
        })
    else
        fsm.motion = config
    end

    DataType.set(config, "motion")
end

--从fsm新建运动器
function Motion.new(fsm)
    if type(fsm) ~= "table" or not fsm.actor then return end

    if __DEBUG__ then
        local actor_type = DataType.get(fsm.actor)
        assert(actor_type == "unit" or actor_type == "effect" or actor_type == "missile", "actor_type datatype is error")
    end

    local motion = fsm.motion
    if type(motion) ~= "table" then
        if __DEBUG__ then
            error("Motion new motion config is error")
        end
        return
    end
    --具备自启动计时器的功能
    if type(fsm.onTick) ~= "function" then
        fsm.onTick = MOTION_DEFAULT_TICK
        fsm.timer = Timer.loop(0.0, MOTION_DEFAULT_TICK, Motion.execute, fsm)
    end

    DataType.set(motion, "motion")
    return motion
end

--删除运动器
function Motion.cancel(fsm)
    fsm.motion = nil
    return fsm
end

--强制结束运动
function Motion.toEnd(fsm)
    local motion = fsm.motion
    if not motion then
        return
    end

    if type(motion.onEnd) == "function" then
        motion.onEnd(fsm)
    end

    if motion.need_to_des then
        motion.actor:destroy()
    end

    Motion.cancel(fsm)
    return true
end


return Motion
