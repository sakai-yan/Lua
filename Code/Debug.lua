local Jass = require 'Lib.API.Jass'
local dbg = require 'jass.debug'


Debug = {}

--设为true时可以启动所有系统的测试并显示信息
__DEBUG__ = true

if __DEBUG__ then
    Debug.__test_callbacks = {}
    function Debug.hookTest(callback)
        if type(callback) == "function" then
            table.insert(Debug.__test_callbacks, callback)
        end
    end
    function Debug.test()
        local test_callbacks = Debug.__test_callbacks
        for index = 1, #test_callbacks do
            pcall(test_callbacks[index])
        end
    end
end

--test
print("main.test:", dbg.gchash, Jass.UnitAlive)
local trig = Jass.CreateTrigger()
Jass.TriggerRegisterPlayerChatEvent(trig, Jass.Player(0), "test", true)
Jass.TriggerAddCondition(trig, Jass.Condition(function()
    local Attr = require 'FrameWork.GameSetting.Attribute'
    local Unit = require 'Core.Entity.Unit'
    local Player = require 'Core.Entity.Player'
    local unit_type = Unit.getTypeByName("张三")

    local time1 = Jass.MHTool_Clock()
    local zs = Unit.create(unit_type, Player.getPlayerById(0), 0.00, 0.00, 0.00)
    local time2 = Jass.MHTool_Clock()
    zs:setAttr(Attr.getBaseName("攻击"), 100)
    zs:setAttr(Attr.getBaseName("体魄"), 100)
    zs:setAttr(Attr.getBaseName("法理"), 100)
    zs:setAttr(Attr.getBaseName("元神"), 100)
    zs:setAttr(Attr.getBaseName("生命"), 100)
    zs:setAttr(Attr.getBaseName("法力"), 100)
    zs:setAttr(Attr.getBaseName("生命恢复"), 100)
    zs:setAttr(Attr.getBaseName("法力恢复"), 100)
    zs:setAttr(Attr.getBaseName("护甲"), 100)
    zs:setAttr(Attr.getBaseName("攻击距离"), 100)
    print("testeumL:", time1, time2, time2 - time1)
    --[[
    local typeidd = Unit.getTypeByName("张三").__unit_type_id
    local time1 = Jass.MHTool_Clock()
    for index = 1, 100 do
        local zs = Jass.CreateUnit(Jass.Player(0), typeidd, 0.00, 0.00, 0.00)
    end
    local time2 = Jass.MHTool_Clock()
    print("testeumL:", time1, time2, time2 - time1)
    --]]
    
    --[[
    local unit_type = Unit.getTypeByName("张三")
    local time1 = Jass.MHTool_Clock()
    for index = 1, 100 do
        local zs = Unit.create(unit_type, Player.getPlayerById(0), 0.00, 0.00, 0.00)
    end
    local time2 = Jass.MHTool_Clock()
    print("testeumL:", time1, time2, time2 - time1)
    zs:setAttr(Attr.getBaseName("攻击"), 100)
    zs:setAttr(Attr.getBaseName("体魄"), 100)
    zs:setAttr(Attr.getBaseName("法理"), 100)
    zs:setAttr(Attr.getBaseName("元神"), 100)
    zs:setAttr(Attr.getBaseName("生命"), 100)
    zs:setAttr(Attr.getBaseName("法力"), 100)
    zs:setAttr(Attr.getBaseName("生命恢复"), 100)
    zs:setAttr(Attr.getBaseName("法力恢复"), 100)
    zs:setAttr(Attr.getBaseName("护甲"), 100)
    zs:setAttr(Attr.getBaseName("攻击距离"), 100)
    --]]
    

    
end))

return Debug
