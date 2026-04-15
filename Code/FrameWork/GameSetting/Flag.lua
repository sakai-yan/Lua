--====================================================
-- Flag.lua
--====================================================

local Flag = {}
Flag.__index = Flag

--====================================================
-- 常量
--====================================================

--- 每个 word 使用的 bit 数（Lua 5.3 整数支持 64 位）
local WORD_BITS = 64

--====================================================
-- 静态区（所有 Flag 实例共享）
--====================================================

--- 已定义的标志列表（index + 1 -> StateId）
Flag._defs = {}

--- 标志名 -> StateId
Flag._nameMap = {}

--- Mask 规范缓存（canonical cache）
--- key(string) -> mask table
Flag._maskCache = {}

--====================================================
-- 内部工具函数
--====================================================

--- 根据标志索引计算所在 word 和 bit mask
--- @param index integer 0-based
--- @return integer wordIndex (1-based)
--- @return integer bitMask
local function calcWord(index)
    local word = (index // WORD_BITS) + 1
    local offset = index % WORD_BITS
    return word, (1 << offset)
end

--====================================================
-- StateId（不可变标志值对象）
--====================================================

--- 创建一个标志值对象（仅在 define 阶段调用）
--- @param index integer
--- @param name string
--- @param config table?
--- @return table(StateId)
local function newStateId(index, name, config)
    local word, mask = calcWord(index)
    return {
        index   = index,     -- 0-based 索引
        name    = name,      -- 标志名
        word    = word,      -- word 下标
        mask    = mask,      -- 位掩码
        onSet   = config and config.onSet,
        onClear = config and config.onClear,
    }
end

--====================================================
-- 标志定义（初始化阶段）
--====================================================

--- 定义一个全局标志
--- @param name string 标志名称（必须唯一）
--- @param config table? 可选配置：
---        {
---          onSet   = function(stateInstance) end,
---          onClear = function(stateInstance) end
---        }
--- @return table(StateId) 不可变标志对象
---
--- 说明：
--- - 所有标志应在系统初始化阶段定义
--- - 返回的 StateId 应作为常量保存
--- - StateId 可直接比较（==）
function Flag.define(name, config)
    assert(not Flag._nameMap[name], "标志已定义: " .. name)

    local index = #Flag._defs
    local sid = newStateId(index, name, config)

    Flag._defs[index + 1] = sid
    Flag._nameMap[name] = sid

    return sid
end

--- 通过名称获取已定义标志
--- @param name string
--- @return table(StateId)|nil
function Flag.getStateByName(name)
    return Flag._nameMap[name]
end

--====================================================
-- Flag 实例
--====================================================

--- 创建一个 Flag 实例
--- @return table(state_instance)
---
--- 说明：
--- - 每个实例拥有独立的标志集合
--- - 内部使用位集 + 引用计数
function Flag.new()
    return setmetatable({
        bits   = {},   -- wordIndex -> integer bits
        counts = {},   -- stateIndex+1 -> ref count
    }, Flag)
end

--====================================================
-- 核心标志操作（2 参数 API）
--====================================================

--- 增加一个标志引用
--- @param sid table(StateId（不可变标志值对象）)
---
--- 行为：
--- - 引用计数 +1
--- - 当 0 -> 1：
---   - 设置 bit
---   - 触发 onSet 回调（如果存在）
function Flag.add(state_instance, sid)
    local idx = sid.index + 1
    local c = (state_instance.counts[idx] or 0) + 1
    state_instance.counts[idx] = c

    if c == 1 then
        local w = sid.word
        state_instance.bits[w] = (state_instance.bits[w] or 0) | sid.mask
        if sid.onSet then
            sid.onSet(state_instance)
        end
    end
end

--- 移除一个标志引用
--- @param sid table(StateId)
---
--- 行为：
--- - 引用计数 -1
--- - 当 1 -> 0：
---   - 清除 bit
---   - 触发 onClear 回调（如果存在）
function Flag.remove(state_instance, sid)
    local idx = sid.index + 1
    local c = state_instance.counts[idx]
    if not c then return end

    c = c - 1
    if c == 0 then
        state_instance.counts[idx] = nil
        local w = sid.word
        local b = state_instance.bits[w]
        if b then
            state_instance.bits[w] = b & ~sid.mask
        end
        if sid.onClear then
            sid.onClear(state_instance)
        end
    else
        state_instance.counts[idx] = c
    end
end

--- 判断某个标志是否处于激活标志
--- @param sid table(StateId)
--- @return boolean
function Flag.has(state_instance, sid)
    local b = state_instance.bits[sid.word]
    return b and ((b & sid.mask) ~= 0) or false
end

--====================================================
-- Mask（标志组合，规范值对象）
--====================================================

--- 构建 mask 缓存 key（基于 state index）
local function buildMaskKey(states)
    local key = {}
    for i = 1, #states do
        key[i] = states[i].index
    end
    return table.concat(key, ",")
end

--- 创建或获取一个标志组合 Mask
--- @param ... table(StateId)
--- @return table mask
---
--- 特性：
--- - 顺序无关
--- - 相同组合返回同一实例
--- - Mask 为只读结构
function Flag.mask(...)
    local n = select("#", ...)
    assert(n > 0, "Flag.mask 至少需要一个标志")

    -- 收集并按 index 排序（保证规范顺序）
    local states = {}
    for i = 1, n do
        states[i] = select(i, ...)
    end
    table.sort(states, function(a, b)
        return a.index < b.index
    end)

    local key = buildMaskKey(states)
    local cached = Flag._maskCache[key]
    if cached then
        return cached
    end

    local words = {}
    local masks = {}
    local count = 0

    for i = 1, n do
        local sid = states[i]
        local w = sid.word
        local found = false
        for j = 1, count do
            if words[j] == w then
                masks[j] = masks[j] | sid.mask
                found = true
                break
            end
        end
        if not found then
            count = count + 1
            words[count] = w
            masks[count] = sid.mask
        end
    end

    local mask = {
        words = words,
        masks = masks,
        count = count,
    }

    Flag._maskCache[key] = mask
    return mask
end

--====================================================
-- 并行标志查询（无内存分配）
--====================================================

--- 任意命中（OR）
--- @param state_instance table
--- @param mask table
--- @return boolean
function Flag.any(state_instance, mask)
    local bits = state_instance.bits
    for i = 1, mask.count do
        local b = bits[mask.words[i]]
        if b and (b & mask.masks[i]) ~= 0 then
            return true
        end
    end
    return false
end

--- 全部满足（AND）
--- @param state_instance table
--- @param mask table
--- @return boolean
function Flag.all(state_instance, mask)
    local bits = state_instance.bits
    for i = 1, mask.count do
        local b = bits[mask.words[i]]
        if not b or (b & mask.masks[i]) ~= mask.masks[i] then
            return false
        end
    end
    return true
end

--- 全部未命中（NONE）
--- @param state_instance table
--- @param mask table
--- @return boolean
function Flag.none(state_instance, mask)
    local bits = state_instance.bits
    for i = 1, mask.count do
        local b = bits[mask.words[i]]
        if b and (b & mask.masks[i]) ~= 0 then
            return false
        end
    end
    return true
end

return Flag
