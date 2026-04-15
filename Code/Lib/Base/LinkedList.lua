-- LinkedList.lua
--
-- 一个基于「共享 NodePool + 轻量 View」的双向链表实现
--
-- 设计目标：
-- 1. 避免频繁 table 创建 / GC，所有节点统一由 NodePool 管理
-- 2. LinkedList 只是“视图”，不真正持有节点对象
-- 3. 通过 key -> nodeId 的映射，实现 O(1) 定位 / 删除 / 移动
--
-- ⚠️ 重要约定：
-- - 所有以 "__" 开头的字段均为【内部字段】，外部严禁访问或修改
-- - NodePool 为全局共享资源，不同 LinkedList 实例会共用节点池
-- - 任何绕过 LinkedList 接口、直接操作 NodePool 的行为，都会导致未定义行为
--
-- 适用场景：
-- - 高频增删节点
-- - LRU / 调度队列 / 有序集合
-- - 对 GC 和内存抖动敏感的系统
---------------------------------------------------------------------------

local LinkedList = {}
LinkedList.__index = LinkedList

---------------------------------------------------------------------------
-- NodePool（内部节点池，严禁外部直接使用）
--
-- NodePool 是整个实现的核心：
-- - 所有链表节点都以「nodeId」的形式存在
-- - prev / next / value 使用平行数组存储
-- - free 链表用于节点复用，避免频繁分配
--
-- ⚠️ 注意：
-- - NodePool 是全局共享的，而不是某个 LinkedList 私有的
-- - 任何 nodeId 只应被某一个 LinkedList 持有
-- - 外部绝不应该直接访问或修改 NodePool 的任何字段
---------------------------------------------------------------------------

local NodePool = {
    free  = 0,   -- 空闲节点链表的头（单向，用 next 串联）
    size  = 0,   -- 当前分配过的最大 nodeId（并不等于存活节点数）

    prev  = {},  -- prev[nodeId] = 前驱节点 id（0 表示无）
    next  = {},  -- next[nodeId] = 后继节点 id（0 表示无）
    value = {},  -- value[nodeId] = 用户数据

    DEBUG = __DEBUG__, -- 调试开关
    alive = {},    -- 仅 DEBUG 下使用，用于检测非法复用 / double free
}

-- 调试模式下会额外检查：
-- - 是否重复分配尚未回收的节点
-- - 是否回收不存在或已回收的节点

-- 分配一个新节点
--
-- 分配策略：
-- 1. 优先从 free 链表中复用旧节点
-- 2. 若无空闲节点，则扩展 size，创建新 nodeId
--
-- ⚠️ 注意：
-- - 返回的是 nodeId，而不是一个 table
-- - 节点的 prev / next 会被重置为 0
--
-- @param data any 节点存储的数据
-- @return number nodeId
function NodePool.alloc(data)
    local id = NodePool.free
    if id ~= 0 then
        -- 从空闲链表中取一个
        NodePool.free = NodePool.next[id]
    else
        -- 创建新节点
        NodePool.size = NodePool.size + 1
        id = NodePool.size
    end

    if NodePool.DEBUG then
        if NodePool.alive[id] then
            error("NodePool.alloc: allocate alive node id = " .. id)
        end
        NodePool.alive[id] = true
    end

    NodePool.value[id] = data
    NodePool.prev[id]  = 0
    NodePool.next[id]  = 0

    return id
end

-- 回收节点（放回 free 链表）
--
-- ⚠️ 重要：
-- - 回收后，该 nodeId 可能会被重新分配
-- - 回收后的 nodeId 不得再被任何 LinkedList 使用
-- - 严禁重复回收同一个 nodeId
--
-- @param id number 要回收的节点 id
function NodePool.recycle(id)
    if NodePool.DEBUG then
        if not NodePool.alive[id] then
            error("NodePool.recycle: double free or invalid id = " .. tostring(id))
        end
        NodePool.alive[id] = nil
    end

    NodePool.value[id] = nil
    NodePool.prev[id]  = 0

    -- 注意：
    -- 这里的 next 用作「空闲链表」指针
    -- 与 LinkedList 中的 next 语义完全不同
    NodePool.next[id] = NodePool.free
    NodePool.free = id
end

---------------------------------------------------------------------------
-- LinkedList（链表视图）
--
-- LinkedList 本身不持有节点数据
-- 它只保存：
-- - 头 / 尾 nodeId
-- - key -> nodeId 的索引表
--
-- ⚠️ 重要约定：
-- - __head / __tail / __indexMap 均为内部字段
-- - 外部禁止直接访问或修改
-- - 所有结构性操作必须通过提供的接口完成
---------------------------------------------------------------------------

-- 创建一个新的链表实例
--
-- ⚠️ 注意：
-- - 该实例会与其他 LinkedList 共享 NodePool
-- - 但 nodeId 不会在不同链表之间共享
--
-- @return table LinkedList 实例
function LinkedList.new()
    return setmetatable({
        __head = 0,        -- 链表头节点 id（0 表示空）
        __tail = 0,        -- 链表尾节点 id（0 表示空）
        __indexMap = {},   -- key -> nodeId 的映射
                            -- 用于 O(1) 定位节点
                            -- ⚠️ 外部禁止直接操作
    }, LinkedList)
end

-- 添加节点（尾插）
--
-- @param key any 唯一 key，用于索引节点
-- @param data any 存储的数据
-- @return boolean 是否成功（key 已存在则失败）
function LinkedList:add(key, data)
    if self.__indexMap[key] then
        return false
    end

    local id = NodePool.alloc(data)

    if self.__tail == 0 then
        -- 空链表
        self.__head = id
    else
        NodePool.next[self.__tail] = id
        NodePool.prev[id] = self.__tail
    end

    self.__tail = id
    self.__indexMap[key] = id
    return true
end

-- 删除指定 key 对应的节点
--
-- ⚠️ 注意：
-- - 删除会立刻回收 nodeId
-- - 删除后的节点不可再访问
--
-- @param key any
-- @return boolean 是否成功
function LinkedList:remove(key)
    local id = self.__indexMap[key]
    if not id then
        return false
    end

    local prev = NodePool.prev[id]
    local next = NodePool.next[id]

    if prev ~= 0 then
        NodePool.next[prev] = next
    else
        -- 删除头节点
        self.__head = next
    end

    if next ~= 0 then
        NodePool.prev[next] = prev
    else
        -- 删除尾节点
        self.__tail = prev
    end

    self.__indexMap[key] = nil
    NodePool.recycle(id)
    return true
end

-- 在 targetKey 对应节点之前插入新节点
--
-- @param key any 新节点 key
-- @param data any 数据
-- @param targetKey any 目标节点 key
-- @return boolean 是否成功
function LinkedList:insertBefore(key, data, targetKey)
    if self.__indexMap[key] then
        return false
    end

    local targetId = self.__indexMap[targetKey]
    if not targetId then
        return false
    end

    local id = NodePool.alloc(data)
    local prev = NodePool.prev[targetId]

    NodePool.next[id] = targetId
    NodePool.prev[id] = prev
    NodePool.prev[targetId] = id

    if prev ~= 0 then
        NodePool.next[prev] = id
    else
        -- 插入到头部
        self.__head = id
    end

    self.__indexMap[key] = id
    return true
end

-- 在 targetKey 对应节点之后插入新节点
--
-- @param key any 新节点 key
-- @param data any 数据
-- @param targetKey any 目标节点 key
-- @return boolean 是否成功
function LinkedList:insertAfter(key, data, targetKey)
    if self.__indexMap[key] then
        return false
    end

    local targetId = self.__indexMap[targetKey]
    if not targetId then
        return false
    end

    local id = NodePool.alloc(data)
    local next = NodePool.next[targetId]

    NodePool.prev[id] = targetId
    NodePool.next[id] = next
    NodePool.next[targetId] = id

    if next ~= 0 then
        NodePool.prev[next] = id
    else
        -- 插入到尾部
        self.__tail = id
    end

    self.__indexMap[key] = id
    return true
end

-- 将指定节点移动到链表头部
--
-- 常用于 LRU 场景
--
-- @param key any
-- @return boolean 是否发生移动
function LinkedList:moveToFront(key)
    local id = self.__indexMap[key]
    if not id or id == self.__head then
        return false
    end

    local prev = NodePool.prev[id]
    local next = NodePool.next[id]

    if prev ~= 0 then
        NodePool.next[prev] = next
    end
    if next ~= 0 then
        NodePool.prev[next] = prev
    else
        self.__tail = prev
    end

    NodePool.prev[id] = 0
    NodePool.next[id] = self.__head
    NodePool.prev[self.__head] = id
    self.__head = id

    return true
end

-- 将指定节点移动到链表尾部
--
-- @param key any
-- @return boolean 是否发生移动
function LinkedList:moveToBack(key)
    local id = self.__indexMap[key]
    if not id or id == self.__tail then
        return false
    end

    local prev = NodePool.prev[id]
    local next = NodePool.next[id]

    if prev ~= 0 then
        NodePool.next[prev] = next
    else
        self.__head = next
    end
    if next ~= 0 then
        NodePool.prev[next] = prev
    end

    NodePool.prev[id] = self.__tail
    NodePool.next[id] = 0
    NodePool.next[self.__tail] = id
    self.__tail = id

    return true
end

-- 遍历链表（支持遍历过程中删除当前节点）
--
-- ⚠️ 注意：
-- - callback 中可以安全调用 remove
-- - 但不建议在回调中做复杂结构修改
--
-- @param callback function(value)
function LinkedList:forEach(callback)
    local cur = self.__head
    while cur ~= 0 do
        local nextNode = NodePool.next[cur]
        callback(NodePool.value[cur])
        cur = nextNode
    end
end

-- 遍历并执行（节点 value 必须是 function）
--
-- 若回调返回 false（显式反回，返回nil仍继续执行），则提前中止遍历
--
-- @param ... any 透传给节点函数的参数
function LinkedList:forEachExecute(...)
    local cur = self.__head
    while cur ~= 0 do
        local nextNode = NodePool.next[cur]
        if NodePool.value[cur](...) == false then
            return false
        end
        cur = nextNode
    end
    return true
end

-- 迭代器（用于 for-in）
-- ⚠️ 注意：
-- - 迭代过程中不建议修改链表结构（例如调用 remove 或 add），以免导致未定义行为
-- - key 的获取依赖于 __indexMap，因此如果修改该结构，记得同步修改该迭代器
-- - 该实现假设 __indexMap 结构不会变，若未来修改，需调整此函数的实现
--
-- @return function iterator 返回 key 和 value
function LinkedList:iterator()
    local cur = self.__head
    return function()
        if cur == 0 then
            return nil  -- 迭代结束
        end
        local v = NodePool.value[cur]  -- 获取当前节点的 value
        local k = self.__indexMap[cur] -- 获取对应的 key
        cur = NodePool.next[cur]       -- 移动到下一个节点
        return k, v
    end
end

return LinkedList
