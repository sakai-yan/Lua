local DataType = require "Lib.Base.DataType"
local Struct = {}

local function new_func_factory(fields, defaults, struct)
    local n = #fields
    local env = { _s = struct }
    local params = {}
    local lines = {}

    lines[#lines+1] = "local pool = _s.pool"
    lines[#lines+1] = "local pool_count = pool.count"
    lines[#lines+1] = "local id"
    lines[#lines+1] = "if pool_count > 0 then id = pool[pool_count]; pool[pool_count] = nil; pool.count = pool_count - 1"
    lines[#lines+1] = "else id = _s.next_id + 1; _s.next_id = id end"

    for i = 1, n do
        params[i] = "a" .. i
        local fname = fields[i]
        local kname = "_k" .. i
        env[kname] = fname
        if defaults and defaults[fname] ~= nil then
            local dname = "_d" .. i
            env[dname] = defaults[fname]
            lines[#lines+1] = string.format(
                "_s[%s][id] = a%d ~= nil and a%d or %s", kname, i, i, dname)
        else
            lines[#lines+1] = string.format("_s[%s][id] = a%d", kname, i)
        end
    end

    lines[#lines+1] = "return id"

    local src = "return function(" .. table.concat(params, ", ") .. ")\n"
        .. table.concat(lines, "\n") .. "\nend"

    local fn, err = load(src, "struct_new", "t", env)
    if not fn then
        if __DEBUG__ then print("Struct new_func_factory error:", err) end
        return nil
    end
    return fn()
end

local function set_all_func_factory(fields, struct)
    local n = #fields
    local env = {}
    local params = { "id" }
    local lines = {}

    for i = 1, n do
        params[i + 1] = "a" .. i
        local data_name = "_d" .. i
        env[data_name] = struct[fields[i]]
        lines[#lines + 1] = string.format("%s[id] = a%d", data_name, i)
    end

    local src = "return function(" .. table.concat(params, ", ") .. ")\n"
        .. table.concat(lines, "\n") .. "\nend"

    local fn, err = load(src, "struct_set_all", "t", env)
    if not fn then
        if __DEBUG__ then print("Struct set_all_func_factory error:", err) end
        return nil
    end
    return fn()
end

local function get_all_func_factory(fields, struct)
    local n = #fields
    local env = {}
    local values = {}

    for i = 1, n do
        local data_name = "_d" .. i
        env[data_name] = struct[fields[i]]
        values[i] = string.format("%s[id]", data_name)
    end

    local line
    if n > 0 then
        line = "return " .. table.concat(values, ", ")
    else
        line = "return"
    end

    local src = "return function(id)\n" .. line .. "\nend"

    local fn, err = load(src, "struct_get_all", "t", env)
    if not fn then
        if __DEBUG__ then print("Struct get_all_func_factory error:", err) end
        return nil
    end
    return fn()
end

---定义一个结构体
---@param config table  必须包含 fields（字符串数组）和可选的 defaults（默认值表）
---@return table|nil struct
function Struct.define(config)
    if type(config) ~= "table" then
        if __DEBUG__ then print("Struct.define error: config must be a table") end
        return nil
    end

    local fields = config.fields
    if type(fields) ~= "table" then
        if __DEBUG__ then print("Struct.define error: fields must be a table") end
        return nil
    end

    local struct = config

    --保证字段列表的正确性
    struct.fields = {}

    -- 为每个字段创建独立的数据表
    for i = 1, #fields do
        local name = fields[i]
        if type(name) == "string" then
            struct[name] = {}
            struct.fields[#struct.fields + 1] = name
        elseif __DEBUG__ then
            print("Struct.define error: field name must be string")
        end
    end

    --id池
    struct.pool = { count = 0 }
    struct.next_id = 0

    struct.new = new_func_factory(struct.fields, config.defaults, struct)
    struct.setAll = set_all_func_factory(struct.fields, struct)
    struct.getAll = get_all_func_factory(struct.fields, struct)

    struct.get = function (struct_instance, key)
        local data_set = struct[key]
        if not data_set then 
            if __DEBUG__ then print("Struct get error: invalid field name", key) end
            return nil
        end
        return data_set[struct_instance]
    end

    struct.set = function (struct_instance, key, value)
        local data_set = struct[key]
        if not data_set then
            if __DEBUG__ then print("Struct set error: invalid field name", key) end
            return
        end
        data_set[struct_instance] = value
    end

    struct.recycle = function (struct_instance)
        local pool = struct.pool
        local count = pool.count + 1
        pool.count = count
        pool[count] = struct_instance

        --先清空数据
        local fields = struct.fields
        for i = 1, #fields do
            local data_set = struct[fields[i]]
            data_set[struct_instance] = nil
        end


    end

    DataType.set(struct, "struct")

    return struct
end

return Struct
