local Jass = require "Lib.API.Jass"

--用于判断Handle的类型
local handle_type = {
    unit = 729232245,
    item = 1769235821,
    effect = 725961040,
    trigger = 729051751,
    timer = 729050482,
    rect = 728916852,
    region = 727803762,
    ability = 1095267426,
    player = 728788089
}

for key, value in pairs(handle_type) do
    handle_type[value] = key
end

--工具库
local Tool = {

    --将字符串转换为id
    S2Id = function (str)
        local a, b, c, d = string.byte(str, 1, 4)
        return ((a or 0) << 24) | ((b or 0) << 16) | ((c or 0) << 8) | (d or 0)
    end,

    --将id转换为字符串
    Id2S = function (id)
        return string.char(
            (id >> 24) & 0xFF,
            (id >> 16) & 0xFF,
            (id >> 8) & 0xFF,
            id & 0xFF
        )
    end,

    ---将rgba转换为颜色
    ---@param r integer 红色
    ---@param g integer 绿色
    ---@param b integer 蓝色
    ---@param a integer 透明度
    ---@return integer 颜色
    Rgba2Color = function(r, g, b, a)
        return (a or 255) << 24 | (r or 0) << 16 | (g or 0) << 8 | (b or 0)
    end,

    ---将颜色转换为rgba
    Color2Rgba = function(color)
        return (color >> 24) & 0xFF,
        (color >> 16) & 0xFF,
        (color >> 8) & 0xFF,
        color & 0xFF
    end,

    isHandleType = function(handle, type_name)
        return Jass.MHTool_GetHandleType(handle) == handle_type[type_name]
    end,

    getHandleType = function (handle)
        return handle_type[Jass.MHTool_GetHandleType(handle)]
    end,

    --注册cj事件
    cjAnyEventRegister = function (trig, constant, callback)
        for index = 0, 15 do
            Jass.TriggerRegisterPlayerUnitEvent(trig, Jass.Player(index), constant, nil)
        end
        Jass.TriggerAddCondition(trig, Jass.Condition(callback))
        return trig
    end,
}

return Tool
