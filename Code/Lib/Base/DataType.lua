--数据类型管理

local type = type
local DataType = {}

local typeTab = {}
table.setmode(typeTab, "kv")

--设置数据类型
function DataType.set(data, typename)
    if type(data) == "table" and type(typename) == "string" and not typeTab[data] then
        typeTab[data] = typename
    end
    return data
end

--获取数据类型
function DataType.get(data)
    if data ~= nil then
        return typeTab[data] or type(data)
    end
    return nil
end

return DataType
