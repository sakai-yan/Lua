local Array = require "Lib.Base.Array"
local Class = require "Lib.Base.Class"
local DataType = require "Lib.Base.DataType"
local Event = require "FrameWork.Manager.Event"

local Array_alloc = Array.alloc
local Array_new = Array.new
local DataType_get = DataType.get
local DataType_set = DataType.set
local Event_execute = Event.execute
local Event_new = Event.new

local math_type = math.type
local rawget = rawget
local rawset = rawset
local table_move = table.move
local type = type

local slots_modify = Class.modify_field("slots")

--[[
    物品存储库（Storage）

    - 纯数据层 item 容器，可复用到背包、仓库、临时容器等系统。
    - `add/remove/move/swap/transfer/exchange` 以 O(1) 槽位读写为主。
    - `findEmpty/iterator/forEach/toTable/clear` 会扫描或复制容量区间，更适合管理层逻辑。
    - 使用前请显式 `local Storage = require "Logic.Process.Item.Storage"`，然后直接调用 `Storage.new(...)`。

    基本示例：
    ```lua
    local Storage = require "Logic.Process.Item.Storage"

    local bag = Storage.new(24, { name = "英雄背包" })
    local warehouse = Storage.new(60, { name = "仓库" })

    local sword = Item.create(SwordType, hero.x, hero.y)
    local slot = bag:add(sword)
    bag:move(slot, 8)
    bag:transfer(8, warehouse, 1, "deposit")
    ```

    监听示例：
    ```lua
    local Storage = require "Logic.Process.Item.Storage"

    Event.onItemStorageChange(function(evt)
        if evt.action == Storage.ACTION_TRANSFER then
            print(evt.reason, evt.from_slot, evt.to_slot)
        end
    end)
    ```

    事件语义：
    - `物品存储变更` 是“已完成变更后的通知”。
    - 如需旧位置，请优先读取 `evt.from_storage / evt.from_slot / evt.to_storage / evt.to_slot`。
    - 不要依赖 `Storage.getByItem(item)` 回推旧状态，因为事件触发时存储关系已经写入新状态。
]]

local function is_integer(value)
    return type(value) == "number" and math_type(value) == "integer"
end

local Storage_Change_Event
--[[
    存储变更事件类型。

    字段：
    - `action`：见 `Storage.ACTION_*`
    - `item`
    - `from_storage / from_slot`
    - `to_storage / to_slot`
    - `other_item`
    - `reason`

    分发顺序：
    1. 源 storage
    2. 目标 storage（若不同）
    3. item
    4. other_item（若存在且不同于 item）
    5. 全局 any 监听
]]
Storage_Change_Event = Event.eventType("物品存储变更", {
    fields = {
        "action",
        "item",
        "from_storage",
        "from_slot",
        "to_storage",
        "to_slot",
        "other_item",
        "reason",
    },
    roles = {"storage", "item", "other_item"},
    emit = function (storage_change_event)
        local is_success = true
        local from_storage = storage_change_event.from_storage
        local to_storage = storage_change_event.to_storage
        local item = storage_change_event.item
        local other_item = storage_change_event.other_item

        if from_storage then
            is_success = Event_execute(storage_change_event, "storage", from_storage)
            if not is_success then goto recycle end
        end

        if to_storage and to_storage ~= from_storage then
            is_success = Event_execute(storage_change_event, "storage", to_storage)
            if not is_success then goto recycle end
        end

        if item then
            is_success = Event_execute(storage_change_event, "item", item)
            if not is_success then goto recycle end
        end

        if other_item and other_item ~= item then
            is_success = Event_execute(storage_change_event, "other_item", other_item)
            if not is_success then goto recycle end
        end

        is_success = Event_execute(storage_change_event)

        ::recycle::
        storage_change_event:recycle()
        return is_success
    end
})

local Storage
local storage_by_item
local slot_by_item

--[[
    标准化槽位输入。

    - 统一约束为 `1 ~ capacity` 的整数。
    - 非调试环境返回 `false, "invalid_slot"`。
]]
local function normalize_slot(storage, slot, prefix)
    if not is_integer(slot) or slot < 1 or slot > storage.capacity then
        if __DEBUG__ then
            error(prefix .. ": slot out of range")
        end
        return false, "invalid_slot"
    end
    return slot
end

-- 从给定起点重新寻找第一个空槽，并刷新 `storage.first_free`。
local function refresh_first_free(storage, start_slot)
    local slots = rawget(storage, slots_modify)
    local capacity = storage.capacity
    local index = start_slot or storage.first_free
    if index < 1 then
        index = 1
    end

    for slot = index, capacity do
        if slots[slot] == nil then
            storage.first_free = slot
            return slot
        end
    end

    storage.first_free = capacity + 1
    return false
end

-- `accept_rule(storage, item, slot, from_storage, from_slot)` 返回 `false` 时拒绝落位。
local function can_accept(storage, item, slot, from_storage, from_slot)
    local accept_rule = storage.accept_rule
    if not accept_rule then
        return true
    end

    local ok, err = accept_rule(storage, item, slot, from_storage, from_slot)
    if ok == false then
        return false, err or "accept_rule_rejected"
    end

    return true
end

local function attach_item(storage, item, slot)
    local slots = rawget(storage, slots_modify)
    slots[slot] = item
    storage.size = storage.size + 1
    storage_by_item[item] = storage
    slot_by_item[item] = slot

    if slot == storage.first_free then
        refresh_first_free(storage, slot + 1)
    end
end

local function detach_item(storage, item, slot)
    local slots = rawget(storage, slots_modify)
    slots[slot] = nil
    storage.size = storage.size - 1
    storage_by_item[item] = nil
    slot_by_item[item] = nil

    if slot < storage.first_free then
        storage.first_free = slot
    end
end

-- 调用方需保证来源槽已占用、目标槽为空，且 accept_rule 已通过。
local function move_item_inside(storage, item, from_slot, to_slot)
    local slots = rawget(storage, slots_modify)
    local old_first_free = storage.first_free

    slots[from_slot] = nil
    slots[to_slot] = item
    slot_by_item[item] = to_slot

    if from_slot < old_first_free then
        storage.first_free = from_slot
    elseif to_slot == old_first_free then
        refresh_first_free(storage, to_slot + 1)
    end
end

local function emit_change(action, item, from_storage, from_slot, to_storage, to_slot, other_item, reason)
    local event_instance = Event_new(
        Storage_Change_Event,
        action,
        item,
        from_storage,
        from_slot,
        to_storage,
        to_slot,
        other_item,
        reason
    )
    return event_instance:emit()
end

-- 统一解析“槽位或物品”双态入参。
local function resolve_stored_entry(storage, slot_or_item, prefix)
    if is_integer(slot_or_item) then
        local slot, err = normalize_slot(storage, slot_or_item, prefix)
        if not slot then
            return false, err
        end

        local item = rawget(storage, slots_modify)[slot]
        if not item then
            return false, "slot_empty"
        end

        return slot, item
    end

    if DataType_get(slot_or_item) ~= "item" then
        if __DEBUG__ then
            error(prefix .. ": item expected")
        end
        return false, "invalid_item"
    end

    if storage_by_item[slot_or_item] ~= storage then
        return false, "item_not_in_storage"
    end

    return slot_by_item[slot_or_item], slot_or_item
end

-- 统一解析目标槽位。`nil/false` 表示自动使用当前 `first_free`。
local function resolve_target_slot(storage, slot, prefix)
    if slot == nil or slot == false then
        local free_slot = storage.first_free
        if free_slot > storage.capacity then
            return false, "storage_full"
        end
        return free_slot
    end

    return normalize_slot(storage, slot, prefix)
end

--[[
    `ItemStorage` 类。

    - 槽位是 1-based 固定容量数组。
    - 一个 item 同时只允许属于一个 storage。
    - `first_free` 缓存“当前已知最小空槽”。
    - 事件是后置通知；如需事务语义，由上层自行编排。
]]
Storage = Class("ItemStorage", {
    __mode = "kv",

    __storage_by_item = table.setmode({}, "k"),
    __slot_by_item = table.setmode({}, "k"),

    --[[
        创建一个新的存储实例。

        参数：
        - `capacity`：固定槽位总数，必须是正整数
        - `config.name`
        - `config.owner`
        - `config.accept_rule` / `config.accept`

        示例：
        ```lua
        local bag = Storage.new(24, {
            name = "英雄背包",
            owner = hero,
            accept_rule = function(storage, item, slot, from_storage, from_slot)
                return true
            end,
        })
        ```
    ]]
    __init__ = function (class, storage, capacity, config)
        if __DEBUG__ then
            assert(is_integer(capacity) and capacity > 0, "ItemStorage.__init__: capacity must be a positive integer")
            assert(config == nil or type(config) == "table", "ItemStorage.__init__: config must be a table")
        end

        config = config or {}

        storage.capacity = capacity
        storage.size = 0
        storage.first_free = 1
        storage.name = config.name or false
        storage.owner = config.owner or false
        storage.accept_rule = config.accept_rule or config.accept or false

        rawset(storage, slots_modify, Array_alloc(capacity))
        DataType_set(storage, "itemstorage")

        return storage
    end,

    isEmpty = function (storage)
        return storage.size == 0
    end,

    isFull = function (storage)
        return storage.size >= storage.capacity
    end,

    space = function (storage)
        return storage.capacity - storage.size
    end,

    contains = function (storage, item)
        if __DEBUG__ then
            assert(DataType_get(item) == "item", "ItemStorage.contains: item error")
        end
        return storage_by_item[item] == storage
    end,

    -- 非法槽位或空槽都返回 `nil`。
    get = function (storage, slot)
        local resolved_slot = normalize_slot(storage, slot, "ItemStorage.get")
        if not resolved_slot then
            return nil
        end
        return rawget(storage, slots_modify)[resolved_slot]
    end,

    -- 不在本 storage 内时返回 `false`。O(1)。
    slotOf = function (storage, item)
        if __DEBUG__ then
            assert(DataType_get(item) == "item", "ItemStorage.slotOf: item error")
        end
        if storage_by_item[item] == storage then
            return slot_by_item[item]
        end
        return false
    end,

    -- 查找从 `start_slot` 开始的第一个空槽；最坏 O(capacity)。
    findEmpty = function (storage, start_slot)
        if start_slot == nil or start_slot == false then
            local free_slot = storage.first_free
            if free_slot <= storage.capacity then
                return free_slot
            end
            return false
        end

        local slots = rawget(storage, slots_modify)
        local capacity = storage.capacity
        local slot = start_slot

        if slot < 1 then
            slot = 1
        end

        for index = slot, capacity do
            if slots[index] == nil then
                return index
            end
        end

        return false
    end,

    -- 成功返回最终槽位；失败返回 `false, err`。
    add = function (storage, item, slot, reason)
        if __DEBUG__ then
            assert(DataType_get(item) == "item", "ItemStorage.add: item error")
        end

        local current_storage = storage_by_item[item]
        if current_storage == storage then
            local current_slot = slot_by_item[item]
            if slot == nil or slot == false or slot == current_slot then
                return current_slot
            end
            return storage:move(current_slot, slot, reason)
        end

        if current_storage then
            return false, "item_already_stored"
        end

        local target_slot, err = resolve_target_slot(storage, slot, "ItemStorage.add")
        if not target_slot then
            return false, err
        end

        local slots = rawget(storage, slots_modify)
        if slots[target_slot] ~= nil then
            return false, "slot_occupied"
        end

        local ok
        ok, err = can_accept(storage, item, target_slot, false, false)
        if not ok then
            return false, err
        end

        attach_item(storage, item, target_slot)
        emit_change(Storage.ACTION_ADD, item, false, false, storage, target_slot, false, reason)
        return target_slot
    end,

    -- 成功返回 `item, slot`；失败返回 `false, err`。
    remove = function (storage, slot_or_item, reason)
        local slot, item = resolve_stored_entry(storage, slot_or_item, "ItemStorage.remove")
        if not slot then
            return false, item
        end

        detach_item(storage, item, slot)
        emit_change(Storage.ACTION_REMOVE, item, storage, slot, false, false, false, reason)
        return item, slot
    end,

    -- 同容器内移动到空槽。成功返回目标槽位。
    move = function (storage, slot_or_item, to_slot, reason)
        local from_slot, item = resolve_stored_entry(storage, slot_or_item, "ItemStorage.move")
        if not from_slot then
            return false, item
        end

        local target_slot, err = normalize_slot(storage, to_slot, "ItemStorage.move")
        if not target_slot then
            return false, err
        end

        if from_slot == target_slot then
            return target_slot
        end

        local slots = rawget(storage, slots_modify)
        if slots[target_slot] ~= nil then
            return false, "slot_occupied"
        end

        local ok
        ok, err = can_accept(storage, item, target_slot, storage, from_slot)
        if not ok then
            return false, err
        end

        move_item_inside(storage, item, from_slot, target_slot)
        emit_change(Storage.ACTION_MOVE, item, storage, from_slot, storage, target_slot, false, reason)
        return target_slot
    end,

    -- 同容器内交换两个已占用槽位。
    swap = function (storage, left, right, reason)
        local left_slot, left_item = resolve_stored_entry(storage, left, "ItemStorage.swap")
        if not left_slot then
            return false, left_item
        end

        local right_slot, right_item = resolve_stored_entry(storage, right, "ItemStorage.swap")
        if not right_slot then
            return false, right_item
        end

        if left_slot == right_slot then
            return true
        end

        local ok, err = can_accept(storage, left_item, right_slot, storage, left_slot)
        if not ok then
            return false, err
        end

        ok, err = can_accept(storage, right_item, left_slot, storage, right_slot)
        if not ok then
            return false, err
        end

        local slots = rawget(storage, slots_modify)
        slots[left_slot] = right_item
        slots[right_slot] = left_item
        slot_by_item[left_item] = right_slot
        slot_by_item[right_item] = left_slot

        emit_change(Storage.ACTION_SWAP, left_item, storage, left_slot, storage, right_slot, right_item, reason)
        return true
    end,

    -- 跨 storage 转移到空槽；成功返回目标槽位。
    transfer = function (storage, slot_or_item, target_storage, target_slot, reason)
        if __DEBUG__ then
            assert(DataType_get(target_storage) == "itemstorage", "ItemStorage.transfer: storage error")
        end

        if target_storage == storage then
            local resolved_target_slot, err = resolve_target_slot(storage, target_slot, "ItemStorage.transfer")
            if not resolved_target_slot then
                return false, err
            end
            return storage:move(slot_or_item, resolved_target_slot, reason)
        end

        local from_slot, item = resolve_stored_entry(storage, slot_or_item, "ItemStorage.transfer")
        if not from_slot then
            return false, item
        end

        local resolved_target_slot, err = resolve_target_slot(target_storage, target_slot, "ItemStorage.transfer")
        if not resolved_target_slot then
            return false, err
        end

        local target_slots = rawget(target_storage, slots_modify)
        if target_slots[resolved_target_slot] ~= nil then
            return false, "slot_occupied"
        end

        local ok
        ok, err = can_accept(target_storage, item, resolved_target_slot, storage, from_slot)
        if not ok then
            return false, err
        end

        detach_item(storage, item, from_slot)
        attach_item(target_storage, item, resolved_target_slot)

        emit_change(
            Storage.ACTION_TRANSFER,
            item,
            storage,
            from_slot,
            target_storage,
            resolved_target_slot,
            false,
            reason
        )

        return resolved_target_slot
    end,

    -- 跨 storage 交换；目标为空时退化成 transfer / move。
    exchange = function (storage, slot_or_item, target_storage, target_slot_or_item, reason)
        if __DEBUG__ then
            assert(DataType_get(target_storage) == "itemstorage", "ItemStorage.exchange: storage error")
        end

        if target_storage == storage then
            if target_slot_or_item == nil then
                local free_slot = storage.first_free
                if free_slot > storage.capacity then
                    return false, "storage_full"
                end
                return storage:move(slot_or_item, free_slot, reason)
            end

            if is_integer(target_slot_or_item) then
                local target_slot, err = normalize_slot(storage, target_slot_or_item, "ItemStorage.exchange")
                if not target_slot then
                    return false, err
                end
                if rawget(storage, slots_modify)[target_slot] == nil then
                    return storage:move(slot_or_item, target_slot, reason)
                end
            end

            return storage:swap(slot_or_item, target_slot_or_item, reason)
        end

        local from_slot, item = resolve_stored_entry(storage, slot_or_item, "ItemStorage.exchange")
        if not from_slot then
            return false, item
        end

        if target_slot_or_item == nil then
            return storage:transfer(from_slot, target_storage, nil, reason)
        end

        local target_slot, target_item = resolve_stored_entry(target_storage, target_slot_or_item, "ItemStorage.exchange")
        if not target_slot then
            if target_item == "slot_empty" and is_integer(target_slot_or_item) then
                return storage:transfer(from_slot, target_storage, target_slot_or_item, reason)
            end
            return false, target_item
        end

        local ok, err = can_accept(target_storage, item, target_slot, storage, from_slot)
        if not ok then
            return false, err
        end

        ok, err = can_accept(storage, target_item, from_slot, target_storage, target_slot)
        if not ok then
            return false, err
        end

        local source_slots = rawget(storage, slots_modify)
        local target_slots = rawget(target_storage, slots_modify)

        source_slots[from_slot] = target_item
        target_slots[target_slot] = item

        storage_by_item[item] = target_storage
        slot_by_item[item] = target_slot
        storage_by_item[target_item] = storage
        slot_by_item[target_item] = from_slot

        emit_change(
            Storage.ACTION_EXCHANGE,
            item,
            storage,
            from_slot,
            target_storage,
            target_slot,
            target_item,
            reason
        )

        return target_slot
    end,

    -- O(capacity) 全量扫描，并逐个发出 `ACTION_REMOVE`。
    clear = function (storage, reason)
        local size = storage.size
        if size == 0 then
            storage.first_free = 1
            return Array_new()
        end

        local removed = Array_alloc(size)
        local removed_count = 0
        local slots = rawget(storage, slots_modify)

        for slot = 1, storage.capacity do
            local item = slots[slot]
            if item ~= nil then
                removed_count = removed_count + 1
                removed[removed_count] = item
                slots[slot] = nil
                storage.size = storage.size - 1
                storage_by_item[item] = nil
                slot_by_item[item] = nil
                if slot < storage.first_free then
                    storage.first_free = slot
                end
                emit_change(Storage.ACTION_REMOVE, item, storage, slot, false, false, false, reason)
            end
        end

        storage.first_free = 1
        return removed
    end,

    -- 返回按槽位顺序遍历已占用槽位的迭代器；最坏 O(capacity)。
    iterator = function (storage)
        local slots = rawget(storage, slots_modify)
        local index = 0
        local capacity = storage.capacity

        return function ()
            for slot = index + 1, capacity do
                local item = slots[slot]
                if item ~= nil then
                    index = slot
                    return slot, item
                end
            end
            return nil
        end
    end,

    -- `callback(item, slot, storage)` 返回 `false` 时提前停止。
    forEach = function (storage, callback)
        if __DEBUG__ then
            assert(type(callback) == "function", "ItemStorage.forEach: callback must be a function")
        end

        local slots = rawget(storage, slots_modify)
        for slot = 1, storage.capacity do
            local item = slots[slot]
            if item ~= nil and callback(item, slot, storage) == false then
                return false
            end
        end
        return true
    end,

    -- 完整快照接口。O(capacity)，且每次都会分配新数组。
    toTable = function (storage)
        local capacity = storage.capacity
        local result = Array_alloc(capacity)
        table_move(rawget(storage, slots_modify), 1, capacity, 1, result)
        return result
    end,
})

storage_by_item = Storage.__storage_by_item
slot_by_item = Storage.__slot_by_item

Class.static(Storage, {
    ACTION_ADD = "add",
    ACTION_REMOVE = "remove",
    ACTION_MOVE = "move",
    ACTION_SWAP = "swap",
    ACTION_TRANSFER = "transfer",
    ACTION_EXCHANGE = "exchange",
    ACTION_PURGE = "purge",

    getByItem = function (item)
        if __DEBUG__ then
            assert(DataType_get(item) == "item", "ItemStorage.getByItem: item error")
        end
        return storage_by_item[item]
    end,

    getSlotByItem = function (item)
        if __DEBUG__ then
            assert(DataType_get(item) == "item", "ItemStorage.getSlotByItem: item error")
        end
        return slot_by_item[item]
    end,
})

--[[
    监听 Storage 变更事件。

    参数：
    - `callback(evt)`
    - `role`：可选，`"storage"` / `"item"` / `"other_item"`
    - `object`：可选，和 `role` 配套，用于只监听某个具体对象

    说明：
    - 不传 `role/object` 时表示全局监听全部 Storage 变更。
    - 当前事件是后置通知；回调返回 `false` 只会阻断后续监听，不会回滚已发生的变更。
]]
function Event.onItemStorageChange(callback, role, object)
    Event.on(Storage_Change_Event, callback, role, object)
end

-- 取消监听 `Event.onItemStorageChange(...)` 注册的回调。
function Event.offItemStorageChange(callback, role, object)
    Event.off(Storage_Change_Event, callback, role, object)
end

-- 物品被删除时，自动把它从 storage 中剔除，避免留下悬挂引用。
local function purge_deleted_item(item_delete_event)
    local item = item_delete_event.item
    local storage = storage_by_item[item]
    if not storage then
        return
    end

    local slot = slot_by_item[item]
    if not slot then
        return
    end

    detach_item(storage, item, slot)
    emit_change(Storage.ACTION_PURGE, item, storage, slot, false, false, false, "item_destroyed")
end

local item_delete_event_type = Event.getTypeByName("物品删除")
if item_delete_event_type then
    Event.on(item_delete_event_type, purge_deleted_item)
end

return Storage
