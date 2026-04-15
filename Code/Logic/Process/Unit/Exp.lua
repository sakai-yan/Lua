local Jass = require "Lib.API.Jass"
local Class = require "Lib.Base.Class"

--经验值系统

local Exp = {}

local Exp_Map = {}

--境界
local realm = {"筑基", "开窍", "外景", "法身", "传说", "造化"}
local exp_base = 400        --1级满经验为exp_base + exp_up
local exp_up = 100          --每级递增
for index = 1, #realm do
    local realm_index = (index - 1) * 100
    for i = 1, 100 do
        local level = realm_index + i
        Exp_Map[level] = exp_base + (level - 1) * exp_up + Exp_Map[level - 1]
    end
end

local Event_Unit_Exp = Class("Event_Unit_Exp", Class.get("Event"), Class.get("Event"))








local trig = Jass.CreateTrigger()
Jass.MHHeroGetExpEvent_Register(trig)
Jass.TriggerAddCondition(trig, Jass.Condition(function ()
    
end))

--获取等级对应的境界名称
function Exp.GetRealm(level)
    if type(level) ~= "number" or level < 1 or level > 600 then
        return "未知境界"
    end
    -- 计算境界索引 (1-6)
    local realm_index = math.ceil(level / 100)
    -- 返回对应的境界名称
    return realm[realm_index]
end

