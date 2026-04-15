local Timer = require "FrameWork.Manager.Timer"
local DataType = require "Lib.Base.DataType"

--Finite State Machine有限状态机
local State = {
    DEFAULT_TICK = 0.02
}

local TIMER_DEFAULT_TICK = State.DEFAULT_TICK

local fsms_by_actor = table.setmode({}, "kv") or setmetatable({}, {__mode = "kv"})

local fsm_context_stack = {}
local fsm_context_top = 0

--设置状态机为正在触发状态，会压入状态机上下文栈
function State.setCurrentFsm(fsm)
    fsm_context_top = fsm_context_top + 1
    fsm_context_stack[fsm_context_top] = fsm
end

--弹出状态机上下文栈
function State.popFsm()
    fsm_context_stack[fsm_context_top] = nil
    fsm_context_top = fsm_context_top - 1
end

--获取正在触发的状态机
function State.getCurrentFsm()
    return fsm_context_stack[fsm_context_top]
end

--新建状态机
function State.new(config)
    local fsm = config or {}
    local actor = fsm.actor
    if actor then
        if fsms_by_actor[actor] then
            return fsms_by_actor[actor]
        else
            fsms_by_actor[actor] = fsm
        end
    end

    if not fsm.timer and type(fsm.onTick) == "function" then
        fsm.timer = Timer.loop(0.0, fsm.tick or TIMER_DEFAULT_TICK, fsm.onTick, fsm)
    end

    DataType.set(fsm, "state")

    return fsm
end

--获取状态机
function State.getByActor(actor)
    if actor then
        return fsms_by_actor[actor]
    end
    return nil
end

return State
