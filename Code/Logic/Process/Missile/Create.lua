local Event = require "FrameWork.Manager.Event"
local Motion = require "Logic.Process.Motion"
local Missile = require "Core.Entity.Missile"
local Player = require "Core.Entity.Player"
local State   = require "FrameWork.Manager.State"
local Collision = require "Logic.Process.Collision"

local DEFAULT_TICK = 0.02

local Event_execute = Event.execute

local function onTickForMissile(fsm)
    local missile = fsm.actor
    if not missile.alive then
        missile:destroy()
    end
    --移动
    Motion.execute(fsm)
    --碰撞
    Collision.execute(fsm)
end

local function collideMissileMethod(fsm, collide_target)
    local missile = fsm.actor
    if Player.isEnemy(missile.player, collide_target.player) then
        Missile.hit(missile, collide_target)

        if not collide_target.alive then
            if type(collide_target.onDeath) == "function" then
                collide_target.onDeath(State.getByActor(collide_target), missile)
            end
        end

        if not missile.alive then
            if type(missile.onDeath) == "function" then
                missile.onDeath(fsm, collide_target)
            end
            missile:destroy()
        end

        --为了不丢失凶手
        if not collide_target.alive then
            collide_target:destroy()
        end
    end
end

local Missile_Create_Event = Event.getTypeByName("Missile_Create_Event")

function Missile_Create_Event.emit(missile_create_event)
    local is_sucess = true
    local missile = missile_create_event.missile
    local fsm
    fsm = State.new({
        actor = missile,
        onTick = onTickForMissile,
        tick = DEFAULT_TICK,
        collision = {
            range = missile.collision_range,
            gap = missile.collision_gap,
            onCollideMissile = collideMissileMethod
        }
    })
    local collision = Collision.new(fsm)

    --任意投射物创建事件
    is_sucess = Event_execute(missile_create_event)

    missile_create_event:recycle()
    return is_sucess
end

