local DataType = require "Lib.Base.DataType"

local DataType_get = DataType.get
local DataType_set = DataType.set

local math_type = math.type
local setmetatable = setmetatable
local type = type

local Storage = {}
Storage.__index = Storage

local storage_by_item = table.setmode({}, "k")

local function refresh_next(storage, start_slot)
    for index = start_slot, storage._capacity do
        if start_slot[index] == nil then
            storage._next = index
            return index
        end
    end

    storage._next = storage._capacity + 1
    return false
end

--[[
    Storage
    用途：
    - 一个只负责“存储数据关系”的物品容器。
    - 适合拿来做背包、仓库、临时容器等上层系统的数据层。

    设计特点：
    - 固定容量，槽位从 1 开始。
    - 只处理 item 的存入、取出、交换位置。
    - 核心状态只有槽位数组、item 到 slot 的反查表、item 到 storage 的归属表。
    - `store / take / swap` 的核心改动都是 O(1)。

    不负责：
    - 不处理 UI。
    - 不处理物品叠加。
    - 不处理物品销毁后的自动同步。
    - 不处理原生背包栏或仓库栏同步。

    基本用法：
    ```lua
    local Storage = require "Logic.System.Storage"

    local bag = Storage.new(6, { name = "英雄背包" })
    local warehouse = Storage.new(24, { name = "仓库" })

    local slot = bag:store(item)
    local item2 = bag:take(slot)

    -- 同一个 Storage 内交换位置
    bag:swap(1, 4)

    -- 不同 Storage 之间交换位置
    bag:swap(2, warehouse, 5)
    ```
]]

--[[
    创建一个新的 Storage。

    参数：
    - `capacity`：容量，必须是正整数。
    - `config.name`：可选，Storage 名称。
    - `config.owner`：可选，Storage 的拥有者。

    返回：
    - `storage`

    说明：
    - `first_free` 表示当前已知的最小空槽位。
    - `_slots[slot] = item`
    - `_slot_by_item[item] = slot`
]]
function Storage.new(capacity, config)
    if __DEBUG__ then
        assert(type(capacity) == "number" and math_type(capacity) == "integer" and capacity > 0, "Storage.new: capacity must be a positive integer")
        assert(config == nil or type(config) == "table", "Storage.new: config must be a table")
    end

    config = config or {}

    local storage = {
        _capacity = capacity,
        _size = 0,
        _next = 1,
        name = config.name or false,
        owner = config.owner or false
    }
    table.setmode(storage, "k")
    DataType_set(storage, "storage")
    return setmetatable(storage, Storage)
end

--[[
    判断 Storage 是否为空。

    返回：
    - `true`：没有任何物品。
    - `false`：至少有一个物品。

    复杂度：
    - O(1)
]]
function Storage.isEmpty(storage)
    return storage._size == 0
end

--[[
    判断 Storage 是否已满。

    返回：
    - `true`：没有空槽位。
    - `false`：至少还有一个空槽位。

    复杂度：
    - O(1)
]]
function Storage.isFull(storage)
    return storage._size >= storage._capacity
end

--[[
    获取剩余空位数量。

    返回：
    - 剩余可用槽位数。

    复杂度：
    - O(1)
]]
function Storage.space(storage)
    return storage._capacity - storage._size
end

--[[
    判断某个 item 是否在当前 Storage 中。

    参数：
    - `item`：要查询的物品。

    返回：
    - `true`：该 item 当前就在这个 Storage 中。
    - `false`：不在，或者参数不是 item。

    复杂度：
    - O(1)
]]
function Storage.contains(storage, item)
    if DataType_get(item) ~= "item" then
        if __DEBUG__ then
            error("Storage.contains: item error")
        end
        return false
    end

    return storage[item] ~= nil
end

--[[
    获取指定槽位上的 item。

    参数：
    - `slot`：槽位编号。

    返回：
    - 槽位上的 `item`
    - 如果槽位非法或为空，则返回 `nil`

    复杂度：
    - O(1)
]]
function Storage.get(storage, slot)
    if slot > storage._capacity or math_type(slot) ~= "integer" then
        return nil
    end

    return storage[slot]
end

--获取某个 item 在当前 Storage 中所在的槽位。
function Storage.slotOf(storage, item)
    if DataType_get(item) ~= "item" then
        if __DEBUG__ then
            error("Storage.slotOf: item error")
        end
        return false
    end

    return storage[item]
end


--存入一个 item
--@param slot integer 可选，目标槽位。
function Storage.store(storage, item, slot)
    if __DEBUG__ then
        if DataType_get(item) ~= "item" then error("Storage.store: item error") end
        if storage[item] ~= nil then error("Storage.store: item_already_stored") end
        if slot then
            if storage[slot] then error("Storage.store: slot_occupied") end
            if slot > storage.capacity then error("Storage.store: storage_full") end
        end
    end

    slot = slot or storage._next
    if slot > storage.capacity then return end

    storage[slot] = item
    storage[item] = slot
    storage_by_item[item] = storage
    storage._size = storage._size + 1

    if slot == storage._next then
        refresh_next(storage, slot)
    end

    return slot
end

--从指定槽位取出 item。
--@param slot 要取出的槽位
function Storage.take(storage, slot)
    if slot and storage[slot] then
        local item = storage[slot]
        storage[item] = nil
        storage[slot] = nil
        storage_by_item[item] = nil
        storage._size = storage._size - 1
        if slot < storage._next then
            storage._next = slot
        end
        return item
    end

    return nil
end

--交换两个槽位的位置。
--@param take_slot 当前 Storage 中的源槽位，必须已有 item
--@param target_slot 目标槽位，可以为空，也可以已有 item
--@return boolean 成功时返回 `true` 失败时返回 `false`
function Storage.swap(storage, take_slot, target_slot)
    if __DEBUG__ then
        if DataType_get(storage) ~= "storage" then print("Storage.swap:storage is not a storage") end
        if math_type(take_slot) ~= "integer" then print("Storage.swap:take_slot is not a integer") end
        if math_type(target_slot) ~= "integer" then print("Storage.swap:target_slot is not a integer") end
    end
    if target_slot > storage._capacity then return false end

    local take_item = storage[take_slot]
    local target_item = storage[target_slot]

    if not take_item then return false end
    --不管目标槽位有没有item都会执行
    storage[target_slot] = take_item
    storage[take_item] = target_slot

    if not target_item then
        storage[take_slot] = nil

        local old_next_slot = storage._next
        if take_slot < old_next_slot then
            storage._next = take_slot
        elseif target_slot == old_next_slot then
            refresh_next(storage, target_slot)
        end
    else
        storage[take_slot] = target_item
        storage[target_item] = take_slot
    end

    return true
end

--跨storage移动item
function Storage.transport(storage, take_slot, target_storage, target_slot)
    if __DEBUG__ then
        if DataType_get(storage) ~= "storage" then print("Storage.transport:storage is not a storage") end
        if DataType_get(target_storage) ~= "storage" then print("Storage.transport:target_storage is not a storage") end
        if math_type(take_slot) ~= "integer" then print("Storage.transport:take_slot is not a integer") end
        if math_type(target_slot) ~= "integer" then print("Storage.transport:target_slot is not a integer") end
    end

    local take_item = storage[take_slot]
    if not take_item then return end

    local target_item = target_storage[target_slot]

    target_storage[target_slot] = take_item
    target_storage[take_item] = target_slot
    storage_by_item[take_item] = target_storage
    if target_item then
        --仅仅只是交换位置，不影响next
        storage[take_slot] = target_item
        storage[target_item] = take_slot
        storage_by_item[target_item] = storage
    else
        --影响两边next
        --storage
        if take_slot < storage._next then
            storage._next = take_slot
        end

        --target_storage
        if target_slot == target_storage._next then
            refresh_next(target_storage, target_slot)
        end
    end
end

return Storage
