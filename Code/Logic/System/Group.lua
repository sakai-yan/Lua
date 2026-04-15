local Set = require "Lib.Base.BitSet"
local DataType = require "Lib.Base.DataType"
local Unit = require "Core.Entity.Unit"
--组，使用缓存作为数据类型，键值全为弱引用
local math_distance = math.distance
local Unit_enumInRange = Unit.enumInRange
local getEnumUnit = Unit.getEnumUnit

--对外接口
local Group = {}
Group.__index = Group

function Group.new(...)
    local group = {...}
    table.setmode(group, "kv")
    local count = select("#", ...)
    for index = 1, count do
        local param = group[index]
        if param ~= nil then
            group[param] = index
        end
    end

    --__count代表最大索引，因为是弱键值表，有些键可能被垃圾回收了，所以不能用#group来获取数量
    group["__count"] = count

    return setmetatable(group, Group)
end

function Group.add(group, object)
    if object ~= nil then
        group["__count"] = group["__count"] + 1
        local count = group["__count"]

        group[count] = object
        group[object] = count
    end
    return group
end

function Group.remove(group, object)
    if not object then return group end

    local index = group[object]
    if not index then return group end
    
    if index == group["__count"] then
        group["__count"] = group["__count"] - 1
    end

    group[index] = nil
    group[object] = nil
    
    return group
end

function Group.count(group)
    return group["__count"]
end

function Group.has(group, object)
    if object then
        return group[object] ~= nil
    end
    return false
end

----拓展方法
---数组部分放变量，键值部分放filter
---filter是一个函数，参数为对象，返回值为布尔值，表示该对象是否满足条件
local param_pack = {
    filter = false,
    group = false,
}

local groupAdd = Group.add

--添加单位到单位组的回调函数，配合EnumUnitInRange使用
local addUnitToGroup = function ()
    local unit = getEnumUnit()
    if not unit then return end
    local filter = param_pack.filter
    local group = param_pack.group
    if filter and filter(unit) then
        groupAdd(group, unit)
    end
end

--选取范围内单位加入单位组
function Group.addUnitInRange(group, x, y, radius, filter)
    if not group then return end
    param_pack.group = group
    param_pack.filter = filter
    Unit_enumInRange(x, y, radius, addUnitToGroup)
    return group
end

--tips:操作单位组时效率比原生单位组高

return Group
