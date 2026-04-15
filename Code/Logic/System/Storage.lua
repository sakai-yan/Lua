local DataType = require "Lib.Base.DataType"

local DataType_get = DataType.get
local DataType_set = DataType.set

local math_type = math.type
local setmetatable = setmetatable
local type = type

local Storage = {}
Storage.__index = Storage

local storage_by_item = table.setmode({}, "k")

local function normalize_slot(storage, slot, prefix)
    if type(slot) ~= "number" or math_type(slot) ~= "integer" or slot < 1 or slot > storage.capacity then
        if __DEBUG__ then
            error(prefix .. ": slot out of range")
        end
        return false, "invalid_slot"
    end
    return slot
end

local function refresh_first_free(storage, start_slot)
    local slots = storage._slots
    local slot = start_slot or storage.first_free

    if slot < 1 then
        slot = 1
    end

    for index = slot, storage.capacity do
        if slots[index] == nil then
            storage.first_free = index
            return index
        end
    end

    storage.first_free = storage.capacity + 1
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
        capacity = capacity,
        size = 0,
        first_free = 1,
        name = config.name or false,
        owner = config.owner or false,
        _slots = {},
        _slot_by_item = table.setmode({}, "k"),
    }

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
    return storage.size == 0
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
    return storage.size >= storage.capacity
end

--[[
    获取剩余空位数量。

    返回：
    - 剩余可用槽位数。

    复杂度：
    - O(1)
]]
function Storage.space(storage)
    return storage.capacity - storage.size
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

    return storage._slot_by_item[item] ~= nil
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
    local resolved_slot = normalize_slot(storage, slot, "Storage.get")
    if not resolved_slot then
        return nil
    end

    return storage._slots[resolved_slot]
end

--[[
    获取某个 item 在当前 Storage 中所在的槽位。

    参数：
    - `item`

    返回：
    - 槽位编号
    - 如果 item 不在当前 Storage 中，返回 `false`

    复杂度：
    - O(1)
]]
function Storage.slotOf(storage, item)
    if DataType_get(item) ~= "item" then
        if __DEBUG__ then
            error("Storage.slotOf: item error")
        end
        return false
    end

    return storage._slot_by_item[item] or false
end

--[[
    存入一个 item。

    参数：
    - `item`：要存入的物品。
    - `slot`：可选，目标槽位。

    返回：
    - 成功时返回目标槽位。
    - 失败时返回 `false, err`。

    可能的错误：
    - `invalid_item`
    - `item_already_stored`
    - `storage_full`
    - `invalid_slot`
    - `slot_occupied`

    复杂度：
    - 指定槽位时 O(1)
    - 不指定槽位时仍然是 O(1)，因为直接使用 `first_free`

    示例：
    ```lua
    local slot = bag:store(item)
    local ok_slot = bag:store(item2, 6)
    ```
]]
function Storage.store(storage, item, slot)
    if DataType_get(item) ~= "item" then
        if __DEBUG__ then
            error("Storage.store: item error")
        end
        return false, "invalid_item"
    end

    if storage_by_item[item] ~= nil then
        return false, "item_already_stored"
    end

    local target_slot = slot
    local err

    if target_slot == nil or target_slot == false then
        target_slot = storage.first_free
        if target_slot > storage.capacity then
            return false, "storage_full"
        end
    else
        target_slot, err = normalize_slot(storage, target_slot, "Storage.store")
        if not target_slot then
            return false, err
        end
    end

    if storage._slots[target_slot] ~= nil then
        return false, "slot_occupied"
    end

    storage._slots[target_slot] = item
    storage._slot_by_item[item] = target_slot
    storage_by_item[item] = storage
    storage.size = storage.size + 1

    if target_slot == storage.first_free then
        refresh_first_free(storage, target_slot + 1)
    end

    return target_slot
end

--[[
    从指定槽位取出 item。

    参数：
    - `slot`：要取出的槽位。

    返回：
    - 成功时返回 `item, slot`
    - 失败时返回 `false, err`

    可能的错误：
    - `invalid_slot`
    - `slot_empty`

    复杂度：
    - O(1)

    示例：
    ```lua
    local item, slot = bag:take(3)
    ```
]]
function Storage.take(storage, slot)
    local resolved_slot, err = normalize_slot(storage, slot, "Storage.take")
    if not resolved_slot then
        return false, err
    end

    local item = storage._slots[resolved_slot]
    if item == nil then
        return false, "slot_empty"
    end

    storage._slots[resolved_slot] = nil
    storage._slot_by_item[item] = nil
    storage_by_item[item] = nil
    storage.size = storage.size - 1

    if resolved_slot < storage.first_free then
        storage.first_free = resolved_slot
    end

    return item, resolved_slot
end

--[[
    交换两个槽位的位置。

    用法一：同一个 Storage 内交换
    - `storage:swap(left_slot, right_slot)`

    用法二：不同 Storage 之间交换
    - `storage:swap(left_slot, target_storage, right_slot)`

    参数：
    - `left_slot`：当前 Storage 中的源槽位，必须已有 item。
    - `target_storage`：目标 Storage。省略时表示当前 Storage。
    - `right_slot`：目标槽位，可以为空，也可以已有 item。

    返回：
    - 成功时返回 `true`
    - 失败时返回 `false, err`

    说明：
    - 如果目标槽位为空，这个操作会退化成“移动到空位”。
    - 如果目标槽位有物品，这个操作就是标准交换。
    - 跨 Storage 交换时，如果目标槽位为空，会同步维护两个 Storage 的 `size` 和 `first_free`。

    可能的错误：
    - `invalid_storage`
    - `invalid_slot`
    - `slot_empty`

    复杂度：
    - O(1)

    示例：
    ```lua
    bag:swap(1, 4)
    bag:swap(2, warehouse, 5)
    ```
]]
function Storage.swap(storage, left_slot, target_storage, right_slot)
    if right_slot == nil then
        right_slot = target_storage
        target_storage = storage
    end

    if DataType_get(target_storage) ~= "storage" then
        if __DEBUG__ then
            error("Storage.swap: storage error")
        end
        return false, "invalid_storage"
    end

    left_slot = normalize_slot(storage, left_slot, "Storage.swap")
    if not left_slot then
        return false, "invalid_slot"
    end

    right_slot = normalize_slot(target_storage, right_slot, "Storage.swap")
    if not right_slot then
        return false, "invalid_slot"
    end

    local left_item = storage._slots[left_slot]
    if left_item == nil then
        return false, "slot_empty"
    end

    local right_item = target_storage._slots[right_slot]

    if storage == target_storage then
        if left_slot == right_slot then
            return true
        end

        storage._slots[left_slot] = right_item
        storage._slots[right_slot] = left_item
        storage._slot_by_item[left_item] = right_slot

        if right_item ~= nil then
            storage._slot_by_item[right_item] = left_slot
        else
            if left_slot < storage.first_free then
                storage.first_free = left_slot
            elseif right_slot == storage.first_free then
                refresh_first_free(storage, right_slot + 1)
            end
        end

        return true
    end

    storage._slots[left_slot] = right_item
    target_storage._slots[right_slot] = left_item

    storage._slot_by_item[left_item] = nil
    target_storage._slot_by_item[left_item] = right_slot
    storage_by_item[left_item] = target_storage

    if right_item ~= nil then
        target_storage._slot_by_item[right_item] = nil
        storage._slot_by_item[right_item] = left_slot
        storage_by_item[right_item] = storage
        return true
    end

    storage.size = storage.size - 1
    target_storage.size = target_storage.size + 1

    if left_slot < storage.first_free then
        storage.first_free = left_slot
    end

    if right_slot == target_storage.first_free then
        refresh_first_free(target_storage, right_slot + 1)
    end

    return true
end

return Storage
