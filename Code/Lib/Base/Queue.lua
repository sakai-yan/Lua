--==========================================================
-- Queue.lua - 高性能双端队列（Deque）
-- Lua 5.3+
--==========================================================
-- 设计目标：
--   * O(1) 双端入队 / 出队
--   * 避免 table.remove / table.insert 的线性成本
--   * 显式内存管理，降低 GC 压力
--   * API 语义尽量对齐 Python collections.deque
--
-- 典型使用场景：
--   * 任务调度队列
--   * 消息 / 事件缓冲
--   * 游戏 / AI 行为序列
--   * 服务端事件循环
--==========================================================

local Queue = {}
Queue.__index = Queue

------------------------------------------------------------
-- 构造函数
-- 创建一个新的双端队列实例
-- @return Queue 新的队列实例
------------------------------------------------------------
function Queue.new()
    return setmetatable({
        _data = {},
        _head = 1,
        _tail = 0,
    }, Queue)
end

------------------------------------------------------------
-- 状态查询
------------------------------------------------------------

--- 获取队列当前元素数量
-- @return number 元素数量，返回 >= 0
-- @usage
--   if queue:len() > 0 then ...
function Queue:len()
    local n = self._tail - self._head + 1
    return n > 0 and n or 0
end

--- 检查队列是否为空
-- @return boolean true 表示队列为空
-- @usage
--   if queue:isEmpty() then ...
function Queue:isEmpty()
    return self._head > self._tail
end

------------------------------------------------------------
-- 右端操作（Python deque.append / pop）
------------------------------------------------------------

--- 向队列右端追加一个元素
-- @param value 任意 Lua 值
-- @return self 返回自身，支持链式调用
-- @usage
--   queue:append(task)
function Queue:append(value)
    if value then
        local t = self._tail + 1
        self._tail = t
        self._data[t] = value
    end
    return self
end

--- 从队列右端移除并返回一个元素
-- @return value|nil 队列右端元素，队列为空时返回 nil
-- @usage
--   local last = queue:pop()
function Queue:pop()
    local t = self._tail
    if self._head > t then return nil end

    local data = self._data
    local value = data[t]
    data[t] = nil
    self._tail = t - 1
    return value
end

------------------------------------------------------------
-- 左端操作（Python deque.appendleft / popleft）
------------------------------------------------------------

--- 向队列左端追加一个元素
-- @param value 任意 Lua 值
-- @return self 返回自身，支持链式调用
-- @usage
--   queue:appendLeft(highPriorityTask)
function Queue:appendLeft(value)
    if value then
        local h = self._head - 1
        self._head = h
        self._data[h] = value
    end
    return self
end

--- 从队列左端移除并返回一个元素
-- @return value|nil 队列左端元素，队列为空时返回 nil
-- @usage
--   local task = queue:popleft()
function Queue:popleft()
    local h = self._head
    if h > self._tail then return nil end

    local data = self._data
    local value = data[h]
    data[h] = nil
    self._head = h + 1
    return value
end

------------------------------------------------------------
-- 批量操作
------------------------------------------------------------

--- 从右端批量追加元素
-- @param list table 包含待添加元素的数组
-- @return self 返回自身，支持链式调用
-- @usage
--   queue:extend({1,2,3})
function Queue:extend(list)
    local data = self._data
    local t = self._tail
    for i = 1, #list do
        t = t + 1
        data[t] = list[i]
    end
    self._tail = t
    return self
end

--- 从左端批量追加元素
-- @param list table 包含待添加元素的数组
-- @return self 返回自身，支持链式调用
-- @usage
--   queue:extendLeft({1,2,3})  -- 实际顺序为 3,2,1
function Queue:extendLeft(list)
    local data = self._data
    local h = self._head
    for i = 1, #list do
        h = h - 1
        data[h] = list[i]
    end
    self._head = h
    return self
end

------------------------------------------------------------
-- 查看但不移除
------------------------------------------------------------

--- 查看队列左端元素
-- @return value|nil 队列左端元素，队列为空时返回 nil
-- @usage
--   local nextTask = queue:peek()
function Queue:peek()
    if self._head > self._tail then return nil end
    return self._data[self._head]
end

--- 查看队列右端元素
-- @return value|nil 队列右端元素，队列为空时返回 nil
-- @usage
--   local lastTask = queue:peekBack()
function Queue:peekBack()
    if self._head > self._tail then return nil end
    return self._data[self._tail]
end

------------------------------------------------------------
-- rotate（循环旋转队列）
------------------------------------------------------------

--- 循环旋转队列
-- @param n number 旋转步数（正数表示右旋，负数表示左旋）
-- @return self 返回自身，支持链式调用
-- @usage
--   queue:rotate(1)   -- 时间轮 / 调度常用
function Queue:rotate(n)
    local size = self:size()
    if size <= 1 or not n or n == 0 then
        return self
    end

    n = n % size
    if n == 0 then return self end

    if n > 0 then
        for _ = 1, n do
            self:appendLeft(self:pop())
        end
    else
        for _ = 1, -n do
            self:append(self:popleft())
        end
    end
    return self
end

------------------------------------------------------------
-- 内存管理
------------------------------------------------------------

--- 快速清空队列
-- 直接丢弃内部表，依赖 GC 回收
-- @return self 返回自身，支持链式调用
-- @usage
--   queue:clear()
function Queue:clear()
    self._data = {}
    self._head = 1
    self._tail = 0
    return self
end

--- 压缩内部索引，回收因 head 漂移产生的空间
-- @return self 返回自身，支持链式调用
-- @usage
--   if queue:shouldCompact() then queue:compact() end
function Queue:compact()
    local h = self._head
    local t = self._tail
    local size = t - h + 1

    if size <= 0 then
        return self:clear()
    end

    local old = self._data
    local new = {}
    for i = 1, size do
        new[i] = old[h + i - 1]
    end

    self._data = new
    self._head = 1
    self._tail = size
    return self
end

--- 判断是否建议进行 compact
-- @param threshold number 可选，默认 1024
-- @return boolean true 表示需要压缩
-- @usage
--   if queue:shouldCompact() then ...
function Queue:shouldCompact(threshold)
    threshold = threshold or 1024
    return self._head > threshold or self._head < -threshold
end

------------------------------------------------------------
-- 导出与遍历
------------------------------------------------------------

--- 导出当前队列快照为普通数组
-- @return table 包含队列元素的表
-- @usage
--   local arr = queue:toTable()
function Queue:toTable()
    local res = {}
    local idx = 1
    for i = self._head, self._tail do
        res[idx] = self._data[i]
        idx = idx + 1
    end
    return res
end

------------------------------------------------------------
-- 迭代器（只读遍历）
------------------------------------------------------------
-- @return function 迭代器函数
-- 
-- 使用方式：
--   for value in queue:iter() do
--       print(value)
--   end
-- 
-- 注意：
--   1. 这是快照迭代，基于创建迭代器时的队列状态
--   2. 迭代过程中修改队列不会影响当前迭代
--   3. 仅用于读取，不会移除元素
------------------------------------------------------------
function Queue:iter()
    local i = self._head - 1
    local t = self._tail
    local data = self._data

    return function()
        i = i + 1
        if i <= t then
            return data[i]
        end
    end
end

return Queue
