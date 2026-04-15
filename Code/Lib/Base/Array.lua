--[[
================================================================================
    数组库 (Array) - Lua 5.3
================================================================================

设计原则：
    能用原生操作的就用原生操作，只提供高级功能

--------------------------------------------------------------------------------
原生操作（直接使用，无需方法）：
--------------------------------------------------------------------------------
    arr[i] = value      -- 赋值
    arr[i]              -- 读取
    #arr                -- 长度
    arr[#arr + 1] = v   -- 追加元素
    table.insert(arr, v)       -- 插入
    table.insert(arr, i, v)    -- 指定位置插入
    table.remove(arr)          -- 移除末尾
    table.remove(arr, i)       -- 移除指定位置
    ipairs(arr)         -- 遍历

--------------------------------------------------------------------------------
创建方法：
--------------------------------------------------------------------------------
    Array.new(...)              -- 创建数组
    Array.alloc(capacity)       -- 预分配容量（只初始化数组部分）
    Array.from(table)           -- 从表创建
    Array.fill(value, count)    -- 填充数组
    Array.range(start, stop, step)  -- 范围数组
    Array.typed(typename, ...)  -- 强类型数组
    Array.isArray(arr)          -- 检查是否为数组

--------------------------------------------------------------------------------
高级方法：
--------------------------------------------------------------------------------
查找：
    arr:indexOf(value, from)    -- 查找索引
    arr:lastIndexOf(value)      -- 反向查找
    arr:contains(value)         -- 是否包含
    arr:find(predicate)         -- 条件查找元素
    arr:findIndex(predicate)    -- 条件查找索引
    arr:count(value)            -- 统计值出现次数
    arr:countIf(predicate)      -- 条件统计

遍历：
    arr:forEach(callback)       -- 遍历
    arr:map(mapper)             -- 映射为新数组
    arr:filter(predicate)       -- 过滤为新数组
    arr:reduce(reducer, init)   -- 归约
    arr:every(predicate)        -- 是否全部满足
    arr:some(predicate)         -- 是否存在满足

批量删除：
    arr:removeAll(value)        -- 删除所有匹配
    arr:removeIf(predicate)     -- 条件删除
    arr:swapRemove(index)       -- O(1)快速删除（不保持顺序）
    arr:clear()                 -- 清空

变换：
    arr:sort(comparator)        -- 排序
    arr:reverse()               -- 反转
    arr:shuffle()               -- 随机打乱
    arr:random()                -- 随机取一个
    arr:unique()                -- 去重

切片与合并：
    arr:slice(start, stop)      -- 切片
    arr:concat(...)             -- 连接
    arr:join(separator)         -- 拼接为字符串
    arr:flatten()               -- 展平
    arr:clone()                 -- 浅拷贝
    arr:toTable()               -- 转为普通表

聚合：
    arr:sum()                   -- 求和
    arr:max()                   -- 最大值
    arr:min()                   -- 最小值
    arr:average()               -- 平均值

游戏专用：
    arr:update(updater, dt)     -- 批量更新（返回false自动移除）
    arr:partition(predicate)    -- 分区为两个数组
    arr:groupBy(keySelector)    -- 按键分组
    arr:nearest(distanceFunc)   -- 查找最近
    arr:inRange(distanceFunc, maxDist)  -- 筛选范围内

--------------------------------------------------------------------------------
使用示例：
--------------------------------------------------------------------------------
基础用法：
    local arr = Array.new(1, 2, 3)
    arr[4] = 4                  -- 直接赋值
    arr[#arr + 1] = 5           -- 追加
    print(#arr)                 -- 5
    
    for i, v in ipairs(arr) do
        print(v)
    end

高级用法：
    local doubled = arr:map(function(v) return v * 2 end)
    local evens = arr:filter(function(v) return v % 2 == 0 end)
    local sum = arr:reduce(function(a, b) return a + b end, 0)

强类型数组：
    local nums = Array.typed("number", 1, 2, 3)
    nums[4] = 4         -- OK
    nums[5] = "x"       -- 报错：类型错误

游戏场景：
    -- 每帧更新，自动移除死亡实体
    entities:update(function(e, i, dt)
        e:tick(dt)
        return e:isAlive()  -- 返回false自动移除
    end, deltaTime)
    
    -- 查找最近敌人
    local target = enemies:nearest(function(e)
        return math.distance(player.x, player.y, e.x, e.y)
    end)
================================================================================
]]

local DataType = require "Lib.Base.DataType"

-- 缓存全局函数（性能优化）
local select = select
local setmetatable = setmetatable
local rawset = rawset
local type = type
local tostring = tostring
local table_sort = table.sort
local table_concat = table.concat
local table_move = table.move
local math_min = math.min
local math_max = math.max
local math_random = math.random

--------------------------------------------------------------------------------
-- Array 基类
--------------------------------------------------------------------------------

local Array = {}
Array.__index = Array

-- 类型约束存储（强类型数组用，弱引用避免内存泄漏）
local _constraint = setmetatable({}, {__mode = "k"})

--------------------------------------------------------------------------------
-- 创建方法
--------------------------------------------------------------------------------

---创建数组
---@param ... any 初始元素
---@return table Array
---@usage local arr = Array.new(1, 2, 3)
function Array.new(...)
    local count = select('#', ...)
    local arr = count > 0 and {...} or {}
    DataType.set(arr, "array")
    return setmetatable(arr, Array)
end

---预分配容量（只触发数组部分扩容，不初始化哈希部分）
---@param capacity number 容量
---@return table Array
---@usage local arr = Array.alloc(1000)  -- 预分配1000个槽位
function Array.alloc(capacity)
    if __DEBUG__ then
        assert(type(capacity) == "number" and capacity > 0, 
            "Array.alloc: capacity 必须为正数")
    end
    local arr = {}
    arr[capacity] = false  -- 触发数组部分扩容
    arr[capacity] = nil    -- 清除
    DataType.set(arr, "array")
    return setmetatable(arr, Array)
end

---从表创建数组（浅拷贝）
---@param t table 源表
---@return table Array
---@usage local arr = Array.from({1, 2, 3})
function Array.from(t)
    if type(t) ~= "table" then
        return Array.new()
    end
    local arr = {}
    local len = #t
    if len > 0 then
        table_move(t, 1, len, 1, arr)
    end
    DataType.set(arr, "array")
    return setmetatable(arr, Array)
end

---创建填充数组
---@param value any 填充值
---@param count number 数量
---@return table Array
---@usage local zeros = Array.fill(0, 10)  -- 10个0
function Array.fill(value, count)
    if __DEBUG__ then
        assert(type(count) == "number" and count >= 0, 
            "Array.fill: count 必须为非负数")
    end
    local arr = {}
    for i = 1, count do
        arr[i] = value
    end
    DataType.set(arr, "array")
    return setmetatable(arr, Array)
end

---创建范围数组
---@param start number 起始值
---@param stop number 结束值
---@param step? number 步长（默认1）
---@return table Array
---@usage local r = Array.range(1, 10)      -- {1,2,3,...,10}
---@usage local r = Array.range(0, 10, 2)   -- {0,2,4,6,8,10}
function Array.range(start, stop, step)
    step = step or 1
    if __DEBUG__ then
        assert(step ~= 0, "Array.range: step 不能为 0")
    end
    local arr = {}
    local i = 0
    for v = start, stop, step do
        i = i + 1
        arr[i] = v
    end
    DataType.set(arr, "array")
    return setmetatable(arr, Array)
end

---检查是否为数组
---@param arr any
---@return boolean
function Array.isArray(arr)
    local t = DataType.get(arr)
    return t == "array" or t == "typedarray"
end

-- 防止意外添加字符串键
function Array:__newindex(key, value)
    if type(key) ~= "number" then
        if __DEBUG__ then
            error("Array: 禁止使用非数值键 " .. tostring(key))
        end
        return  -- 静默忽略
    end
    rawset(self, key, value)
end

--------------------------------------------------------------------------------
-- 强类型数组
--------------------------------------------------------------------------------

local Typed = setmetatable({}, {__index = Array})
Typed.__index = Typed

---创建强类型数组（赋值时始终检查类型）
---@param typename string 类型名（"number", "string", "table", 或自定义类型）
---@param ... any 初始元素
---@return table Typed
---@usage local nums = Array.typed("number", 1, 2, 3)
function Array.typed(typename, ...)
    if __DEBUG__ then
        assert(type(typename) == "string", "Array.typed: typename 必须为字符串")
    end
    
    local count = select('#', ...)
    local arr = count > 0 and {...} or {}
    
    -- 验证初始值类型
    if __DEBUG__ then
        for i = 1, count do
            local v = arr[i]
            ---@type string
            local vtype = type(v)
            if vtype == "table" then
                ---@diagnostic disable-next-line: cast-local-type
                vtype = DataType.get(v)
            end
            assert(vtype == typename, 
                ("Array.typed: 第 %d 个元素类型错误，期望 %s"):format(i, typename))
        end
    end
    
    _constraint[arr] = typename
    DataType.set(arr, "typedarray")
    return setmetatable(arr, Typed)
end

---获取类型约束
---@return string 类型名
function Typed:getType()
    return _constraint[self]
end

---拦截赋值进行类型检查
---@param key any 键
---@param value any 值
function Typed:__newindex(key, value)
    if value ~= nil and type(key) == "number" then
        local constraint = _constraint[self]
        ---@type string
        local vtype = type(value)
        if vtype == "table" then
            ---@diagnostic disable-next-line: cast-local-type
            vtype = DataType.get(value)
        end
        assert(vtype == constraint,
            ("Array 类型错误，期望 %s"):format(constraint))
		rawset(self, key, value)
    end
end

--------------------------------------------------------------------------------
-- 查找方法
--------------------------------------------------------------------------------

---查找元素索引
---@param value any 要查找的值
---@param from? number 起始索引（默认1）
---@return number|nil 索引，未找到返回nil
function Array:indexOf(value, from)
    from = from or 1
    for i = from, #self do
        if self[i] == value then return i end
    end
    return nil
end

---反向查找元素索引
---@param value any 要查找的值
---@return number|nil 索引，未找到返回nil
function Array:lastIndexOf(value)
    for i = #self, 1, -1 do
        if self[i] == value then return i end
    end
    return nil
end

---检查是否包含元素
---@param value any 要查找的值
---@return boolean
function Array:contains(value)
    return self:indexOf(value) ~= nil
end

---条件查找元素
---@param predicate fun(value: any, index: number): boolean 条件函数
---@return any|nil 找到的元素，未找到返回nil
function Array:find(predicate)
    for i = 1, #self do
        local v = self[i]
        if predicate(v, i) then return v end
    end
    return nil
end

---条件查找索引
---@param predicate fun(value: any, index: number): boolean 条件函数
---@return number|nil 索引，未找到返回nil
function Array:findIndex(predicate)
    for i = 1, #self do
        if predicate(self[i], i) then return i end
    end
    return nil
end

---统计元素出现次数
---@param value any 要统计的值
---@return number 出现次数
function Array:count(value)
    local c = 0
    for i = 1, #self do
        if self[i] == value then c = c + 1 end
    end
    return c
end

---条件统计
---@param predicate fun(value: any, index: number): boolean 条件函数
---@return number 满足条件的数量
function Array:countIf(predicate)
    local c = 0
    for i = 1, #self do
        if predicate(self[i], i) then c = c + 1 end
    end
    return c
end

--------------------------------------------------------------------------------
-- 遍历方法
--------------------------------------------------------------------------------

---遍历数组
---@param callback fun(value: any, index: number, array: table) 回调函数
---@return table self 支持链式调用
function Array:forEach(callback)
    for i = 1, #self do
        callback(self[i], i, self)
    end
    return self
end

---映射为新数组
---@param mapper fun(value: any, index: number): any 映射函数
---@return table Array 新数组
function Array:map(mapper)
    local len = #self
    local result = {}
    for i = 1, len do
        result[i] = mapper(self[i], i)
    end
    DataType.set(result, "array")
    return setmetatable(result, Array)
end

---过滤为新数组
---@param predicate fun(value: any, index: number): boolean 条件函数
---@return table Array 新数组
function Array:filter(predicate)
    local result = {}
    local j = 0
    for i = 1, #self do
        local v = self[i]
        if predicate(v, i) then
            j = j + 1
            result[j] = v
        end
    end
    DataType.set(result, "array")
    return setmetatable(result, Array)
end

---归约操作
---@param reducer fun(accumulator: any, value: any, index: number): any 归约函数
---@param initial? any 初始值（可选，为空时使用第一个元素）
---@return any 归约结果
function Array:reduce(reducer, initial)
    local len = #self
    local acc = initial
    local start = 1
    if acc == nil then
        if __DEBUG__ then
            assert(len > 0, "Array:reduce 空数组需要初始值")
        end
        if len == 0 then return nil end
        acc = self[1]
        start = 2
    end
    for i = start, len do
        acc = reducer(acc, self[i], i)
    end
    return acc
end

---检查是否所有元素满足条件
---@param predicate fun(value: any, index: number): boolean 条件函数
---@return boolean
function Array:every(predicate)
    for i = 1, #self do
        if not predicate(self[i], i) then return false end
    end
    return true
end

---检查是否存在元素满足条件
---@param predicate fun(value: any, index: number): boolean 条件函数
---@return boolean
function Array:some(predicate)
    for i = 1, #self do
        if predicate(self[i], i) then return true end
    end
    return false
end

--------------------------------------------------------------------------------
-- 批量删除方法
--------------------------------------------------------------------------------

---删除所有匹配的元素
---@param value any 要删除的值
---@return number 删除的数量
function Array:removeAll(value)
    local len = #self
    local w = 1
    local removed = 0
    for r = 1, len do
        local v = self[r]
        if v ~= value then
            if w ~= r then self[w] = v end
            w = w + 1
        else
            removed = removed + 1
        end
    end
    for i = w, len do self[i] = nil end
    return removed
end

---按条件删除元素
---@param predicate fun(value: any, index: number): boolean 返回true则删除
---@return number 删除的数量
function Array:removeIf(predicate)
    local len = #self
    local w = 1
    local removed = 0
    for r = 1, len do
        local v = self[r]
        if not predicate(v, r) then
            if w ~= r then self[w] = v end
            w = w + 1
        else
            removed = removed + 1
        end
    end
    for i = w, len do self[i] = nil end
    return removed
end

---O(1)快速删除（用末尾元素填充，不保持顺序）
---@param index number 索引
---@return any|nil 被删除的元素
---@usage 适用于实体列表等不关心顺序的场景
function Array:swapRemove(index)
    local len = #self
    if index < 1 or index > len then return nil end
    local value = self[index]
    if index ~= len then
        self[index] = self[len]
    end
    self[len] = nil
    return value
end

---清空数组
---@return table self 支持链式调用
function Array:clear()
    for i = #self, 1, -1 do
        self[i] = nil
    end
    return self
end

--------------------------------------------------------------------------------
-- 变换方法
--------------------------------------------------------------------------------

---原地排序
---@param comparator? fun(a: any, b: any): boolean 比较函数
---@return table self 支持链式调用
function Array:sort(comparator)
    table_sort(self, comparator)
    return self
end

---原地反转
---@return table self 支持链式调用
function Array:reverse()
    local len = #self
    local mid = len // 2
    for i = 1, mid do
        local j = len - i + 1
        self[i], self[j] = self[j], self[i]
    end
    return self
end

---原地随机打乱（Fisher-Yates算法）
---@return table self 支持链式调用
function Array:shuffle()
    for i = #self, 2, -1 do
        local j = math_random(1, i)
        self[i], self[j] = self[j], self[i]
    end
    return self
end

---随机获取一个元素
---@return any|nil 随机元素
function Array:random()
    local len = #self
    if len == 0 then return nil end
    return self[math_random(1, len)]
end

---去重（保持顺序）
---@return table Array 新数组
function Array:unique()
    local seen = {}
    local result = {}
    local j = 0
    for i = 1, #self do
        local v = self[i]
        if not seen[v] then
            seen[v] = true
            j = j + 1
            result[j] = v
        end
    end
    DataType.set(result, "array")
    return setmetatable(result, Array)
end

--------------------------------------------------------------------------------
-- 切片与合并方法
--------------------------------------------------------------------------------

---切片（支持负索引）
---@param startIdx number 起始索引（负数从末尾计算）
---@param endIdx? number 结束索引（默认末尾，负数从末尾计算）
---@return table Array 新数组
---@usage arr:slice(2, 4)    -- 第2到第4个
---@usage arr:slice(-3)      -- 最后3个
function Array:slice(startIdx, endIdx)
    local len = #self
    if startIdx < 0 then startIdx = len + startIdx + 1 end
    endIdx = endIdx or len
    if endIdx < 0 then endIdx = len + endIdx + 1 end
    startIdx = math_max(1, startIdx)
    endIdx = math_min(len, endIdx)
    
    local result = {}
    local resultLen = math_max(0, endIdx - startIdx + 1)
    if resultLen > 0 then
        table_move(self, startIdx, endIdx, 1, result)
    end
    DataType.set(result, "array")
    return setmetatable(result, Array)
end

---连接多个数组
---@param ... table 要连接的数组
---@return table Array 新数组
function Array:concat(...)
    local result = self:clone()
    for i = 1, select('#', ...) do
        local other = select(i, ...)
        if type(other) == "table" then
            local len = #result
            table_move(other, 1, #other, len + 1, result)
        end
    end
    return result
end

---拼接为字符串
---@param sep? string 分隔符（默认","）
---@return string
function Array:join(sep)
    sep = sep or ","
    local parts = {}
    for i = 1, #self do
        parts[i] = tostring(self[i])
    end
    return table_concat(parts, sep)
end

---展平嵌套数组（一层）
---@return table Array 新数组
function Array:flatten()
    local result = {}
    local j = 0
    for i = 1, #self do
        local v = self[i]
        if type(v) == "table" then
            for k = 1, #v do
                j = j + 1
                result[j] = v[k]
            end
        else
            j = j + 1
            result[j] = v
        end
    end
    DataType.set(result, "array")
    return setmetatable(result, Array)
end

--------------------------------------------------------------------------------
-- 复制方法
--------------------------------------------------------------------------------

---浅拷贝
---@return table Array 新数组
function Array:clone()
    local result = {}
    local len = #self
    if len > 0 then
        table_move(self, 1, len, 1, result)
    end
    DataType.set(result, "array")
    return setmetatable(result, Array)
end

---转为普通Lua表
---@return table 普通表（无元表）
function Array:toTable()
    local result = {}
    local len = #self
    if len > 0 then
        table_move(self, 1, len, 1, result)
    end
    return result
end

---转为字符串（调试用）
---@return string
function Array:__tostring()
    return "Array[" .. self:join(", ") .. "]"
end

--------------------------------------------------------------------------------
-- 聚合方法
--------------------------------------------------------------------------------

---求和（忽略非数字）
---@return number
function Array:sum()
    local s = 0
    for i = 1, #self do
        local v = self[i]
        if type(v) == "number" then s = s + v end
    end
    return s
end

---求最大值
---@return any|nil 最大值
---@return number|nil 最大值索引
function Array:max()
    local len = #self
    if len == 0 then return nil end
    local maxVal, maxIdx = self[1], 1
    for i = 2, len do
        if self[i] > maxVal then
            maxVal, maxIdx = self[i], i
        end
    end
    return maxVal, maxIdx
end

---求最小值
---@return any|nil 最小值
---@return number|nil 最小值索引
function Array:min()
    local len = #self
    if len == 0 then return nil end
    local minVal, minIdx = self[1], 1
    for i = 2, len do
        if self[i] < minVal then
            minVal, minIdx = self[i], i
        end
    end
    return minVal, minIdx
end

---求平均值
---@return number 平均值，空数组返回0
function Array:average()
    local len = #self
    if len == 0 then return 0 end
    return self:sum() / len
end

--------------------------------------------------------------------------------
-- 游戏专用方法
--------------------------------------------------------------------------------

---批量更新（返回false的元素自动移除）
---@param updater fun(value: any, index: number, dt: number): boolean|nil 更新函数
---@param dt number 时间增量
---@return table self 支持链式调用
---@usage
---  entities:update(function(e, i, dt)
---      e:tick(dt)
---      return e:isAlive()  -- 返回false自动移除
---  end, deltaTime)
function Array:update(updater, dt)
    local len = #self
    local w = 1
    for r = 1, len do
        local v = self[r]
        if updater(v, r, dt) ~= false then
            if w ~= r then self[w] = v end
            w = w + 1
        end
    end
    for i = w, len do self[i] = nil end
    return self
end

---分区为两个数组
---@param predicate fun(value: any, index: number): boolean 条件函数
---@return table Array 满足条件的数组
---@return table Array 不满足条件的数组
---@usage local alive, dead = units:partition(function(u) return u:isAlive() end)
function Array:partition(predicate)
    local t, f = {}, {}
    local tLen, fLen = 0, 0
    for i = 1, #self do
        local v = self[i]
        if predicate(v, i) then
            tLen = tLen + 1
            t[tLen] = v
        else
            fLen = fLen + 1
            f[fLen] = v
        end
    end
    DataType.set(t, "array")
    DataType.set(f, "array")
    return setmetatable(t, Array), setmetatable(f, Array)
end

---按键分组
---@param keySelector fun(value: any): any 键选择函数
---@return table<any, table> 分组结果
---@usage local byType = units:groupBy(function(u) return u.type end)
function Array:groupBy(keySelector)
    local groups = {}
    for i = 1, #self do
        local v = self[i]
        local key = keySelector(v)
        if not groups[key] then
            local arr = {}
            DataType.set(arr, "array")
            groups[key] = setmetatable(arr, Array)
        end
        local g = groups[key]
        g[#g + 1] = v
    end
    return groups
end

---查找最近的元素
---@param distanceFunc fun(value: any): number 距离计算函数
---@return any|nil 最近元素
---@return number|nil 最近距离
---@usage
---  local target, dist = enemies:nearest(function(e)
---      return math.distance(player.x, player.y, e.x, e.y)
---  end)
function Array:nearest(distanceFunc)
    local len = #self
    if len == 0 then return nil, nil end
    local nearestVal = self[1]
    local nearestDist = distanceFunc(nearestVal)
    for i = 2, len do
        local v = self[i]
        local d = distanceFunc(v)
        if d < nearestDist then
            nearestVal, nearestDist = v, d
        end
    end
    return nearestVal, nearestDist
end

---筛选范围内的元素
---@param distanceFunc fun(value: any): number 距离计算函数
---@param maxDist number 最大距离
---@return table Array 范围内的元素
---@usage
---  local targets = enemies:inRange(function(e)
---      return math.distance(skill.x, skill.y, e.x, e.y)
---  end, skill.radius)
function Array:inRange(distanceFunc, maxDist)
    return self:filter(function(v)
        return distanceFunc(v) <= maxDist
    end)
end

return Array
