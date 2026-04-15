local DataType = require "Lib.Base.DataType"

--[[
Set.lua - 有序集合（Ordered Set）实现

数据结构与特性
--------------------------------
1. 元素唯一（数学意义上的集合）
   - 同一个值只会出现一次。
   - 构造（Set.new）和插入（set:add）都会自动去重。

2. 有序 + O(1) 删除（顺序不严格稳定）
   - 内部使用数组部分保持元素连续：set[1..n] = 元素。
   - 删除采用“交换删除”（swap-with-last）：
       * 删除位置用最后一个元素填补，然后删掉最后一个元素。
       * 优点：remove/discard 为 O(1)。
       * 代价：删除后部分元素的相对顺序可能改变，不是严格的“插入顺序容器”。

3. 内部结构
   - 数组部分：set[1..n] 存储所有元素，保证无洞。
   - 反向索引：set.__index__[value] = index，加速 has/remove 等操作。
   - 禁止给实例新增任意字段（__newindex 抛错），避免破坏内部结构。

4. 复杂度（n 为集合大小）
   - add / has / remove / discard：平均 O(1)。
   - clear / copy / 遍历：O(n)。
   - union / intersection / difference / symmetric_difference：O(|a| + |b|)。
   - is_subset / is_superset / is_disjoint / __eq：O(n)。

5. 元素约束
   - nil 不会被加入集合：
       * Set.new(...) 遇到 nil 参数会忽略。
       * set:add(nil) 返回 false，不修改集合。
   - 其它值按 Lua 的键语义（==）区分。

6. 迭代和运算符
   - pairs(set) / ipairs(set) 按数组顺序遍历元素（通过 __pairs = ipairs）。
   - tostring(set) 返回形如："set{1, 2, 3}" 的字符串。
   - a + b  等价于 Set.union(a, b)         -- 并集
   - a * b  等价于 Set.intersection(a, b)   -- 交集
   - a - b  等价于 Set.difference(a, b)     -- 差集
   - a == b 比较集合意义上的相等（元素相同即可，顺序可以不同）。

   --]]

-- 顺序数组部分存元素：set[1..n] = 元素
-- 反向索引表： set.__index__[元素] = 下标
local Set = {}

----------------------------------------------------------------------
-- 构造 / 基础操作
----------------------------------------------------------------------
--- 创建新集合。
--  用法：
--    Set.new()              -- 空集合
--    Set.new(1, 2, 3, 2)    -- set{1, 2, 3}
--  特点：
--    - 自动去重：只保留第一次出现的元素。
--    - 忽略 nil 参数（不会加入集合）。
function Set.new(...)
    local set = DataType.set({...}, "set")

    -- 反向索引：value -> index
    set.__index__ = {}

    -- 通过 add 来插入，保证行为与后续调用一致
    local n = select("#", ...)
    if n > 0 then
        local Set_add = Set.add
        for i = 1, n do
            local value = set[i]
            if value ~= nil then
                set[i] = nil
                Set_add(set, value)
            end
        end
    end

    return setmetatable(set, Set)
end

--- 向集合中添加一个元素。
--  用法：
--    set:add(value)         -- 推荐面向对象写法
--    Set.add(set, value)
--  返回：
--    - 新元素   -> 插入到末尾，返回下标（1..n）
--    - 已存在   -> 返回 false，不修改集合
--    - value=nil -> 返回 false，不修改集合
--  复杂度：平均 O(1)。
function Set.add(set, value)
    if value == nil then
        return false
    end
    local index_map = set.__index__
    if index_map[value] ~= nil then
        -- 已存在
        return false
    end
    local index = #set + 1
    rawset(set, index, value)
    index_map[value] = index
    return true
end

--- 向集合中批量添加元素
---@param list table
function Set.addBatch(set, list)
    if type(list) == "table" then
        local index_map = set.__index__
        local index = #set

        for i = 1, #list do
            local value = list[i]
            if index_map[value] == nil then
                local index = index + 1
                rawset(set, index, value)
                index_map[value] = index
            end
        end
    end
end

--- 从集合中移除一个元素（严格版本）。
--  用法：
--    set:remove(value)
--  行为：
--    - 元素存在  -> O(1) 删除（交换删除），返回 true。
--    - 元素不存在 -> 抛错（error），用于暴露逻辑错误。
--    - value=nil  -> 返回 false。
--  注意：
--    - 删除采用“与最后一个元素交换再删除”的策略，删除后集合内部分元素顺序可能改变。
function Set.remove(set, value)
    if value == nil then
        return false
    end
    local index_map = set.__index__
    local index = index_map[value]
    if not index then
        error("Set.remove: 尝试移除未添加的数据", 2)
    end
    local top = #set
    if index ~= top then
        -- 用最后一个元素填补空洞，保持数组连续
        local top_value = rawget(set, top)
        rawset(set, index, top_value)
        index_map[top_value] = index
    end

    -- 删除最后一个元素
    rawset(set, top, nil)
    index_map[value] = nil
    return true
end

--- 从集合中丢弃一个元素（宽松版本）。
--  用法：
--    set:discard(value)
--  行为：
--    - 元素存在   -> O(1) 删除（交换删除），返回 true。
--    - 元素不存在 -> 返回 false，不抛错。
--    - value=nil   -> 返回 false。
--  适用场景：
--    - 不确定元素是否存在，但“不存在也无所谓”的情况。
function Set.discard(set, value)
    if value == nil then
        return false
    end

    local index_map = set.__index__
    local index = index_map[value]
    if not index then
        return false
    end

    local top = #set
    if index ~= top then
        local top_value = rawget(set, top)
        rawset(set, index, top_value)
        index_map[top_value] = index
    end

    rawset(set, top, nil)
    index_map[value] = nil
    return true
end

--- 返回集合当前元素个数。
--  等价于 #set。
--  存在这个方法主要是为了提高可读性和方便面向对象风格调用。
function Set.len(set)
    return #set
end

--- 判断集合中是否包含某个元素。
--  用法：
--    set:has(value)
--  返回：
--    - value 为 nil -> false
--    - 否则         -> 存在返回 true，不存在返回 false
--  复杂度：平均 O(1)。
function Set.has(set, value)
    if value == nil then
        return false
    end
    return set.__index__[value] ~= nil
end

--- 清空集合中的所有元素。
--  用法：
--    set:clear()
--  行为：
--    - 清空数组部分 set[1..n]。
--    - 清空反向索引表 set.__index__。
--    - 保留集合实例和其元表本身。
function Set.clear(set)
    local index_map = set.__index__
    local rawset_   = rawset
    for i = #set, 1, -1 do
        index_map[set[i]] = nil
        rawset_(set, i, nil)
    end
end

--- 创建集合的浅拷贝。
--  用法：
--    local new_set = set:copy()
--  行为：
--    - 返回一个新的集合实例，元素和顺序与原集合相同。
--    - 元素本身不复制（仍为同一引用），仅集合结构复制。
function Set.copy(set)
    local new_set   = Set.new()
    local rawset_   = rawset
    local index_map = new_set.__index__
    local n = #set
    for i = 1, n do
        local v = set[i]
        rawset_(new_set, i, v)
        index_map[v] = i
    end
    return new_set
end

--- 集合的字符串表示。
--  用法：
--    tostring(set) 或 print(set)
--  示例输出：
--    set{1, 2, 3}
--  行为：
--    - 按当前数组顺序输出所有元素的 tostring 结果。
function Set.__tostring(set)
    local n         = #set
    local parts     = {}
    local tostring_ = tostring
    for i = 1, n do
        parts[i] = tostring_(set[i])
    end
    return "set{" .. table.concat(parts, ", ") .. "}"
end

----------------------------------------------------------------------
-- 集合关系 / 运算
----------------------------------------------------------------------

--- 并集：a ∪ b。
--  用法：
--    local c = Set.union(a, b)
--    local c = a + b          -- 运算符形式
--  顺序规则：
--    - 先插入 a 中的所有元素（按 a 的顺序）。
--    - 再插入 b 中还未出现的元素（按 b 的顺序）。
function Set.union(a, b)
    local res     = Set.new()
    local Set_add = Set.add
    local na, nb  = #a, #b
    for i = 1, na do
        Set_add(res, a[i])
    end
    for i = 1, nb do
        Set_add(res, b[i])
    end
    return res
end

--- 交集：a ∩ b。
--  用法：
--    local c = Set.intersection(a, b)
--    local c = a * b          -- 运算符形式
--  顺序规则：
--    - 按 a 中的顺序保留所有同时在 b 中存在的元素。
function Set.intersection(a, b)
    local res     = Set.new()
    local Set_add = Set.add
    local index_b = b.__index__
    local na      = #a

    for i = 1, na do
        local v = a[i]
        if index_b[v] ~= nil then
            Set_add(res, v)
        end
    end

    return res
end

--- 差集：a - b。
--  用法：
--    local c = Set.difference(a, b)
--    local c = a - b          -- 运算符形式
--  含义：
--    - 保留在 a 中但不在 b 中的所有元素。
--  顺序规则：
--    - 按 a 中的顺序保留。
function Set.difference(a, b)
    local res     = Set.new()
    local Set_add = Set.add
    local index_b = b.__index__
    local na      = #a

    for i = 1, na do
        local v = a[i]
        if index_b[v] == nil then
            Set_add(res, v)
        end
    end
    return res
end

--- 对称差：(a - b) ∪ (b - a)。
--  用法：
--    local c = Set.symmetric_difference(a, b)
--  含义：
--    - 保留只出现在其中一个集合中的元素。
--  顺序规则：
--    - 先按 a 的顺序加入 a - b。
--    - 再按 b 的顺序加入 b - a。
function Set.symmetric_difference(a, b)
    local res = Set.new()
    local Set_add = Set.add
    local index_a = a.__index__
    local index_b = b.__index__
    local na, nb  = #a, #b

    for i = 1, na do
        local v = a[i]
        if index_b[v] == nil then
            Set_add(res, v)
        end
    end

    for i = 1, nb do
        local v = b[i]
        if index_a[v] == nil then
            Set_add(res, v)
        end
    end

    return res
end

--- 判断 a 是否是 b 的子集。
--  用法：
--    Set.is_subset(a, b)
--  返回：
--    - true  -> a 中所有元素都在 b 中。
--    - false -> 否则。
function Set.is_subset(a, b)
    local na, nb = #a, #b
    if na > nb then
        return false
    end
    local index_b = b.__index__
    for i = 1, na do
        if index_b[a[i]] == nil then
            return false
        end
    end
    return true
end

--- 判断 a 是否是 b 的超集。
--  用法：
--    Set.is_superset(a, b)
--  实现：
--    - 等价于 is_subset(b, a)。
function Set.is_superset(a, b)
    return Set.is_subset(b, a)
end

--- 判断两个集合是否无交集（没有任何公共元素）。
--  用法：
--    Set.is_disjoint(a, b)
--  返回：
--    - true  -> a 和 b 不共享任何元素。
--    - false -> 至少存在一个公共元素。
--  实现细节：
--    - 遍历较小的集合以降低时间成本。
function Set.is_disjoint(a, b)
    local na, nb = #a, #b

    -- 遍历较小的集合以提高效率
    local small, large = a, b
    local n_small = na
    if na > nb then
        small, large = b, a
        n_small = nb
    end

    local index_large = large.__index__
    for i = 1, n_small do
        if index_large[small[i]] ~= nil then
            return false
        end
    end
    return true
end

--- 集合相等（集合意义上的 ==）。
--  用法：
--    a == b
--  行为：
--    - 只比较“元素集合”是否相同，顺序可以不同。
--    - 先比较元素个数，再检查 a 中每个元素都存在于 b 中。
function Set.__eq(a, b)
    local na, nb = #a, #b
    if na ~= nb then
        return false
    end
    local index_b = b.__index__
    for i = 1, na do
        if index_b[a[i]] == nil then
            return false
        end
    end
    return true
end


-------------------------------------------------------------------------
-- 元表与内部约束
----------------------------------------------------------------------
-- 禁止通过 getmetatable(set) 获取真实元表
Set.__metatable = "protected"

-- 禁止给集合实例随意加字段，防止破坏内部结构
function Set.__newindex(set, key, value)
    error("Set: 禁止直接赋值 Set", 2)
end

-- 让 pairs(set) 与 ipairs(set) 行为一致：按数组部分顺序遍历
Set.__pairs = ipairs
----------------------------------------------------------------------
-- 运算符和方法绑定
----------------------------------------------------------------------

-- 运算符重载： + 并集，* 交集，- 差集
Set.__add   = Set.union
Set.__mul   = Set.intersection
Set.__sub   = Set.difference

-- 实例方法查找：set:xxx(...) 会在 Set 上查找
Set.__index = Set

return Set
