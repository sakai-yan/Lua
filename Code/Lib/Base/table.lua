local type = type

local table_remove = table.remove

--表是否为空
function table.isEmpty(tab)
    return next(tab) == nil
end


--设置表为安全弱表
local weak_metatables = {{ __mode = "k", __metatable = "protected" }, { __mode = "v", __metatable = "protected" }, { __mode = "kv", __metatable = "protected" }}
--@param    tab table
--@param    mode   "k"  "v" "kv"
--@param    force   boolean 设置为true可设置强制覆盖元表
function table.setmode(tab, mode, force)
    if type(tab) ~= "table" then 
        tab = {}
    end
    local mt = getmetatable(tab)
    --如果有元表，且其mode域不是预设的三种，不强制覆盖元表的情况下，则不做修改
    if mt and not force then
        local mtmode = mt.__mode
        if mtmode ~= "k" and mtmode ~= "v" and mtmode ~= "kv" then
            return tab
        end
    end
    local mt_new
    if mode == "kv" then
        mt_new = weak_metatables[3]
    elseif mode == "k" then
        mt_new = weak_metatables[1]
    elseif mode == "v" then
        mt_new = weak_metatables[2]
    else
        mt_new = nil
    end
    setmetatable(tab, mt_new)
    return tab
end


--存储有序表的键名
local __orderTableKey = table.setmode({}, "kv") or {}
local __ordermeta = {
    __newindex = function (tab, key, value)
        local keylist = __orderTableKey[tab]
        -- 如果值为nil，表示删除操作
        if value == nil then
            -- 从键列表中移除
            for i = #keylist, 1, -1 do
                if keylist[i] == key then
                    table_remove(keylist, i)
                    break
                end
            end
        else
            -- 检查键是否已存在，避免重复
            local exists = false
            for i = 1, #keylist do
                if keylist[i] == key then
                    exists = true
                    break
                end
            end         
            -- 只有新键才添加到列表
            if not exists then
                keylist[#keylist + 1] = key
            end
        end
        rawset(tab, key, value)
    end,
    __pairs = function (tab)
        local keylist = __orderTableKey[tab]
        local index = 0
        return function()
            index = index + 1
            local key = keylist[index]
            if not key then return nil end  -- 真正结束
            if rawget(tab, key) ~= nil then
                return key, tab[key]
            end
            -- 继续循环跳过已删除的键
        end
    end,
    __len = function(tab)
        local count = 0
        local keylist = __orderTableKey[tab]
        for i = 1, #keylist do
            if rawget(tab, keylist[i]) ~= nil then
                count = count + 1
            end
        end
        return count
    end
}
--获取一个有序表或将表转换为有序表
function table.order(tab)
    tab = tab or {}
    -- 初始化键列表
    local keylist = {}
    __orderTableKey[tab] = keylist
    -- 如果有初始数据，记录所有键
    if not table.isEmpty(tab) then
        for k, v in pairs(tab) do
            keylist[#keylist + 1] = k
        end
    end
    return setmetatable(tab, __ordermeta)
end





local type_order = {
        number = 1,
        string = 2,
        boolean = 3,
        table = 4,
        ["function"] = 5,
        userdata = 6,
        thread = 7
    }

local function __comparator(a, b)
     local type_a, type_b = type(a), type(b)
    -- 相同类型的快速比较
    if type_a == type_b then
        if type_a == "number" then
            return a < b
        elseif type_a == "string" then
            return a < b
        else
            -- 对非数字字符串使用稳定比较
            local str_a, str_b = tostring(a), tostring(b)
            if str_a == str_b then
                -- 相同字符串表示时，使用原始值的额外比较确保稳定性
                return tostring({a}) < tostring({b})
            end
            return str_a < str_b
        end
    end
    -- 不同类型：按预定义类型顺序排序
    local order_a = type_order[type_a] or 8
    local order_b = type_order[type_b] or 8
    return order_a < order_b
end

--有序遍历
function table.orderPairs(tab)
   local keys = {}
    
    -- 预分配适当大小，减少重哈希
    local estimated_size = 0
    for _ in pairs(tab) do estimated_size = estimated_size + 1 end
    
    -- 收集键
    for k in pairs(tab) do
        keys[#keys + 1] = k
    end
    
    -- 排序
    table.sort(keys, __comparator)
    
    -- 返回迭代器
    local index = 0
    local total = #keys
    
    return function()
        index = index + 1
        local key = keys[index]
        if key then
            return key, tab[key]
        end
    end, nil, index  -- 返回额外状态用于调试
end