local Jass = require "Lib.API.Jass"
local Class = require "Lib.Base.Class"
local DataType = require "Lib.Base.DataType"
local Event = require "FrameWork.Manager.Event"
local Effect = require "Core.Entity.Effect"

local Event_new = Event.new

--伤害系数
local DAMAGE_FACTOR = 0.005

--投射物创建事件
local Missile_Create_Event = Event.eventType("Missile_Create_Event", {
    fields = {"missile"},
    roles = {"missile"}
})

--单位删除事件
local Missile_Delete_Event = Event.eventType("Missile_Delete_Event", {
    fields = {"missile"},
    roles = {"missile"}
})

local Missile
Missile = Class("Missile", {

    --基类为特效
    __baseclass__ = Effect,

    --元类
    __metaclass__ = Effect,

    --存放所有missile
    __missiles = {},

    --以handle为索引获取missile
    __missiles_by_handle = table.setmode({}, "kv"),

    __init__ = function (class, missile)
        if __DEBUG__ then
            assert(type(missile.hp) == "number", "Missile.__init__:hp应为number")
            assert(type(missile.resist) == "number", "Missile.__init__:resist应为number")
        end

        missile.hp = missile.hp or 1.0
        missile.resist = missile.resist or 0.0
        
        class.__missiles_by_handle[missile.handle] = DataType.set(missile, "missile")
        class.__missiles:add(missile)

        --触发创建事件
        local missile_create_event = Event_new(Missile_Create_Event, missile)
        missile_create_event:emit(missile_create_event)

        return missile
    end,

    __del__ = function (class, missile)
        
        --触发删除事件
        local missile_delete_event = Event_new(Missile_Delete_Event, missile)
        missile_delete_event:emit(missile_delete_event)
        
        class.__missiles_by_handle[missile.handle] = nil
        class.__missiles:discard(missile)
        --effect handle在Effect类中处理
    end,

    getEnumMissile = function ()
        local missile_handle = Jass.MHEffect_GetEnumEffect()
        if missile_handle then
            return Effect.__missiles_by_handle[missile_handle]
        end
        return nil
    end,

    __attributes__ = {
        {
            name = "alive",
            get = function (missile, key)
                return missile.hp > 0.0
            end,
            set = function (missile, key, value)
                if __DEBUG__ then
                    print("missile.alive是只读属性")
                end
            end
        }
    }


})

function Missile.hit(missile, target)
    local missile_hp = missile.hp
    local target_hp = target.hp

    --计算伤害
    target.hp = target_hp - (missile_hp / (1 + DAMAGE_FACTOR * missile.resist))
    missile.hp = missile_hp - (target_hp / (1 + DAMAGE_FACTOR * target.resist))
end


return Missile