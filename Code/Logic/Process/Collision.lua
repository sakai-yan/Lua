local Unit = require "Core.Entity.Unit"
local Effect = require "Core.Entity.Effect"
local Group = require "Logic.Package.Group"
local State = require "FrameWork.Manager.State"
local Missile = require "Core.Entity.Missile"
local DataType= require "Lib.Base.DataType"

local Unit_enumInRange = Unit.enumInRange
local Unit_getEnumUnit = Unit.GetEnumUnit
local Missile_getEnumMissile = Missile.GetEnumMissile
local Missile_getPosition = Missile.GetPosition
local Effect_enumInRange = Effect.enumInRange
local Effect_getEnumEffect = Effect.getEnumEffect
local Group_new = Group.new
local Group_has = Group.has
local Group_remove = Group.remove
local type = type

local State_getCurrent = State.getCurrent
local State_push = State.push
local State_pop = State.pop

--默认碰撞范围
local DEFAULT_COLLIDE_RANGE = 96.0
--默认碰撞间隔
local DEFAULT_COLLIDE_GAP = 0.5


--碰撞单位回调
local function collideUnit()
    local fsm = State_getCurrent()
    if not fsm then return end

    local collide_target = Unit_getEnumUnit()
    if collide_target == fsm.actor then return end

    local collision = fsm.collision
    local group = collision.reknock_unit_group
    if collide_target and collide_target.alive and not Group_has(group, collide_target) then
        if type(collision.onCollideUnit) == "function" then
            collision.onCollideUnit(fsm, collide_target)
        end
        Group_remove(group, collide_target)
    end
end

--碰撞特效回调
local function collideEffect()
    local fsm = State_getCurrent()
    if not fsm then return end

    local collide_target = Effect_getEnumEffect()
    if collide_target == fsm.actor then return end

    local collision = fsm.collision
    local group = collision.reknock_effect_group
    if collide_target and not Group_has(group, collide_target) then
        if type(collision.onCollideEffect) == "function" then
            collision.onCollideEffect(fsm, collide_target)
        end
        Group_remove(group, collide_target)
    end
end

--碰撞投射物回调
local function collideMissile()
    local fsm = State_getCurrent()
    if not fsm then return end

    local collide_target = Missile_getEnumMissile()
    if collide_target == fsm.actor then return end

    local collision = fsm.collision
    local group = collision.reknock_missile_group
    if collide_target and collide_target.alive and not Group_has(group, collide_target) then
        if type(collision.onCollideMissile) == "function" then
            collision.onCollideMissile(fsm, collide_target)
        end
        Group_remove(group, collide_target)
    end
end

local Collision
Collision = {

    execute = function (fsm)
        local actor = fsm.actor
        local collision = fsm.collision
        if not actor or not collision then return fsm end

        if collision.is_pause then return fsm end

        local x, y, z = Missile_getPosition(actor)
        local range = collision.range
        State_push(fsm)

        --碰撞特效
        if collision.can_collide_effect then
            Effect_enumInRange(x, y, range, collideEffect)
        end

        --碰撞投射物
        if collision.can_collide_missile then
            Effect_enumInRange(x, y, range, collideMissile)
        end

        --碰撞单位
        if collision.can_collide_unit then
            Unit_enumInRange(x, y, range, collideUnit)
        end

        State_pop()
        return fsm
    end,

    --[[
        --是否暂停碰撞
        "is_pause",
        --碰撞检测半径
        "range",
        --碰撞检测间隔
        "gap",
        --是否碰撞单位
        "can_collide_unit",
        --碰撞单位事件，参数为fsm（状态机）、被碰撞的单位
        "onCollideUnit",
        --是否碰撞投射物
        "can_collide_missile",
        --碰撞特效事件，参数为fsm（状态机）、被碰撞的投射物
        "onCollideMissile",
        --是否碰撞特效
        "can_collide_effect",
        --碰撞特效回调，参数为fsm（状态机）、被碰撞的特效
        "onCollideEffect",

        --无需显式声明的属性，防止重复碰撞的组
        reknock_effect_group,
        reknock_missile_group,
        reknock_unit_group
        --碰撞冷却时间
        "cooldown",  
    ]]
    set = function (actor, config)
        if type(config) ~= "table" then
            if __DEBUG__ then
                error("Collision set config is error")
            end
            return
        end
        local fsm = State.getByActor(actor)
        if not fsm then return end

        local collision = fsm.collision
        --说明原来已有碰撞器
        if collision then
            collision.range = config.range or collision.range
            collision.gap = config.gap or collision.gap
            collision.cooldown = config.cooldown or collision.cooldown
            collision.is_pause = config.is_pause or collision.is_pause
            collision.can_collide_unit = config.can_collide_unit or collision.can_collide_unit
            collision.can_collide_missile = config.can_collide_missile or collision.can_collide_missile
            collision.can_collide_effect = config.can_collide_effect or collision.can_collide_effect
        else
            collision = config
            collision.range = collision.range or DEFAULT_COLLIDE_RANGE
            collision.gap = collision.gap or DEFAULT_COLLIDE_GAP
            collision.cooldown = 0.0
            DataType.set(config, "collision")
        end

        if type(collision.onCollideUnit) == "function" then
            collision.reknock_unit_group = collision.reknock_unit_group or Group_new()
        end

        if type(collision.onCollideMissile) == "function" then
            collision.reknock_missile_group = collision.reknock_missile_group or Group_new()
        end

        if type(collision.onCollideEffect) == "function" then
            collision.reknock_effect_group = collision.reknock_effect_group or Group_new()
        end

        return collision
    end,


    new = function (fsm)
        if type(fsm) ~= "table" then return end
        local collision = fsm.collision

        if type(collision) == "table" then
            if type(collision.onCollideEffect) == "function" then
                collision.reknock_effect_group = Group_new()
            end

            if type(collision.onCollideMissile) == "function" then
                collision.reknock_missile_group = Group_new()
            end

            if type(collision.onCollideUnit) == "function" then
                collision.reknock_unit_group = Group_new()
            end

            collision.range = collision.range or DEFAULT_COLLIDE_RANGE
            collision.gap = collision.gap or DEFAULT_COLLIDE_GAP
            collision.cooldown = 0.0

            DataType.set(collision, "collision")
        else
            if __DEBUG__ then
                error("Collision new config is error")
            end
            return
        end
        return collision
    end,

    cancel = function (fsm)
        fsm.collision = nil
        return fsm
    end
}

return Collision
