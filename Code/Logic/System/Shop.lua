local Array = require "Lib.Base.Array"
local Class = require "Lib.Base.Class"
local DataType = require "Lib.Base.DataType"
local Event = require "FrameWork.Manager.Event"
local Jass = require "Lib.API.Jass"
local Item = require "Core.Entity.Item"
local Player = require "Core.Entity.Player"
local Unit = require "Core.Entity.Unit"
require "Logic.Process.Item.Get"

local DataType_get = DataType.get
local DataType_set = DataType.set
local Event_execute = Event.execute
local Event_new = Event.new
local Jass_GetOwningPlayer = Jass.GetOwningPlayer
local Jass_UnitAddItem = Jass.UnitAddItem
local math_type = math.type
local rawget = rawget
local rawset = rawset
local type = type

local slots_modify = Class.modify_field("slots")
local slot_by_goods_modify = Class.modify_field("slot_by_goods")

local ACTION_ADD = "add"
local ACTION_REMOVE = "remove"
local ACTION_RESTOCK = "restock"
local ACTION_SELL = "sell"

local KIND_ITEM = "item"
local KIND_UNIT = "unit"

local Shop_Change_Event

--[[
    Shop
    - A pure upper-layer shop runtime for listing goods, validating costs, and
      recording sales.
    - Supports `item`, `itemtype`, `unit`, and `unittype`. Selling a `unit`
      is treated as hiring.
    - `sell(...)` is the scripted active-sale path.
    - `recordSale(...)` / `Shop.recordSaleBySeller(...)` are the future bridge
      points for `Trade.lua` to sync native sales back into this library.

    Cost model:
    - `contains/slotOf/get/getEntry/costOf/stockOf/match/getBySeller` are O(1)
    - `add/remove/restock/sell/recordSale` keep the hot path O(1)
    - `findEmpty/iterator/forEach/toTable/clear` may scan or copy by capacity

    Usage:
    ```lua
    local Shop = require "Logic.System.Shop"

    local shop = Shop.new(shopkeeper, 6, { name = "Mercenary Camp" })
    shop:add(SwordType, 1, { stock = false })
    shop:add(MercenaryType, 2, { stock = 3, gold = 250 })

    local goods = shop:sell(2, hero, "script_buy")

    -- Later, when Trade.lua knows seller/buyer/sold_goods:
    -- Shop.recordSaleBySeller(shopkeeper, sold_goods, hero, "native_trade")
    ```

    Entry config:
    - `gold` / `lumber`: integer resource cost, default from `goods.gold/lumber`
    - `stock`: integer >= 0, or `false` for infinite stock on type-backed goods
    - `spawn_x` / `spawn_y` / `spawn_face`: spawn position for created goods
    - `spawn_player`: optional player used when creating template-backed units
    - `allow(entry, shop, buyer, seller, slot)`: optional sale gate
    - `create(shop, entry, buyer, seller, slot, buyer_player)`: custom factory
    - `on_sell(goods, shop, entry, buyer, seller, slot)`: post-sale callback
]]

local function is_integer(value)
    return type(value) == "number" and math_type(value) == "integer"
end

local function get_slots(shop)
    return rawget(shop, slots_modify)
end

local function get_slot_by_goods(shop)
    return rawget(shop, slot_by_goods_modify)
end

local function get_goods_kind(goods)
    local datatype = DataType_get(goods)
    if datatype == "item" then
        return KIND_ITEM, true
    end
    if datatype == "itemtype" then
        return KIND_ITEM, false
    end
    if datatype == "unit" then
        return KIND_UNIT, true
    end
    if datatype == "unittype" then
        return KIND_UNIT, false
    end
    return false, false
end

local function is_supported_goods(goods)
    return get_goods_kind(goods) ~= false
end

local function assert_unit(unit, prefix)
    if __DEBUG__ then
        assert(DataType_get(unit) == "unit", prefix .. ": unit error")
    end
end

local function assert_goods(goods, prefix)
    if __DEBUG__ then
        assert(is_supported_goods(goods), prefix .. ": unsupported goods")
    end
end

local function normalize_slot(shop, slot, prefix)
    if not is_integer(slot) or slot < 1 or slot > shop.capacity then
        if __DEBUG__ then
            error(prefix .. ": slot out of range")
        end
        return false, "invalid_slot"
    end
    return slot
end

local function normalize_cost(value, prefix, field_name)
    if value == nil or value == false then
        return 0
    end

    if not is_integer(value) or value < 0 then
        if __DEBUG__ then
            error(prefix .. ": " .. field_name .. " must be a non-negative integer")
        end
        return false
    end
    return value
end

local function normalize_stock(is_instance, stock, prefix)
    if is_instance then
        if stock ~= nil and stock ~= false and stock ~= 1 then
            if __DEBUG__ then
                error(prefix .. ": instance-backed goods cannot use stock other than 1")
            end
            return false
        end
        return 1
    end

    if stock == nil or stock == false then
        return false
    end

    if not is_integer(stock) or stock < 0 then
        if __DEBUG__ then
            error(prefix .. ": stock must be a non-negative integer or false")
        end
        return false
    end

    return stock
end

local function resolve_unit_owner(unit)
    local owner = unit.owner
    if DataType_get(owner) == "player" then
        return owner
    end

    if unit.handle then
        return Player.getPlayerByHandle(Jass_GetOwningPlayer(unit.handle))
    end

    return false
end

local function refresh_first_free(shop, start_slot)
    local slots = get_slots(shop)
    local capacity = shop.capacity
    local index = start_slot or shop.first_free
    if index < 1 then
        index = 1
    end

    for slot = index, capacity do
        if slots[slot] == nil then
            shop.first_free = slot
            return slot
        end
    end

    shop.first_free = capacity + 1
    return false
end

local function resolve_target_slot(shop, slot, prefix)
    if slot == nil or slot == false then
        local free_slot = shop:findEmpty()
        if not free_slot then
            return false, "shop_full"
        end
        return free_slot
    end

    return normalize_slot(shop, slot, prefix)
end

local function resolve_entry(shop, slot_or_goods, prefix)
    if is_integer(slot_or_goods) then
        local slot, err = normalize_slot(shop, slot_or_goods, prefix)
        if not slot then
            return false, err
        end

        local entry = get_slots(shop)[slot]
        if not entry then
            return false, "slot_empty"
        end

        return slot, entry
    end

    if not is_supported_goods(slot_or_goods) then
        if __DEBUG__ then
            error(prefix .. ": slot or listed goods expected")
        end
        return false, "invalid_goods"
    end

    local slot = get_slot_by_goods(shop)[slot_or_goods]
    if not slot then
        return false, "goods_not_found"
    end

    local entry = get_slots(shop)[slot]
    if not entry then
        return false, "goods_not_found"
    end

    return slot, entry
end

local function match_entry(shop, goods, prefix)
    if not is_supported_goods(goods) then
        if __DEBUG__ then
            error(prefix .. ": sold goods expected")
        end
        return false, "invalid_goods"
    end

    local slot_by_goods = get_slot_by_goods(shop)
    local slot = slot_by_goods[goods]
    local slots = get_slots(shop)

    if slot then
        local entry = slots[slot]
        if entry then
            return slot, entry
        end
    end

    local datatype = DataType_get(goods)
    if datatype == "item" or datatype == "unit" then
        local goods_type = goods.type
        if goods_type then
            slot = slot_by_goods[goods_type]
            if slot then
                local entry = slots[slot]
                if entry then
                    return slot, entry
                end
            end
        end
    end

    return false, "goods_not_found"
end

local function prepare_entry(goods, config)
    local kind, is_instance = get_goods_kind(goods)
    if not kind then
        return false
    end

    local entry = config or {}
    local gold = entry.gold
    if gold == nil then
        gold = goods.gold
    end
    gold = normalize_cost(gold, "Shop.add", "gold")
    if gold == false then
        return false
    end

    local lumber = entry.lumber
    if lumber == nil then
        lumber = goods.lumber
    end
    lumber = normalize_cost(lumber, "Shop.add", "lumber")
    if lumber == false then
        return false
    end

    local stock = normalize_stock(is_instance, entry.stock, "Shop.add")
    if stock == false and is_instance then
        return false
    end

    if __DEBUG__ then
        assert(entry.spawn_player == nil or entry.spawn_player == false or DataType_get(entry.spawn_player) == "player", "Shop.add: spawn_player error")
        assert(entry.allow == nil or entry.allow == false or type(entry.allow) == "function", "Shop.add: allow must be a function")
        assert(entry.create == nil or entry.create == false or type(entry.create) == "function", "Shop.add: create must be a function")
        assert(entry.on_sell == nil or entry.on_sell == false or type(entry.on_sell) == "function", "Shop.add: on_sell must be a function")
        assert(entry.spawn_x == nil or type(entry.spawn_x) == "number", "Shop.add: spawn_x must be a number")
        assert(entry.spawn_y == nil or type(entry.spawn_y) == "number", "Shop.add: spawn_y must be a number")
        assert(entry.spawn_face == nil or type(entry.spawn_face) == "number", "Shop.add: spawn_face must be a number")
    end

    entry.goods = goods
    entry.kind = kind
    entry.is_instance = is_instance
    entry.gold = gold
    entry.lumber = lumber
    entry.stock = stock
    entry.allow = entry.allow or false
    entry.create = entry.create or false
    entry.on_sell = entry.on_sell or false
    entry.spawn_x = entry.spawn_x
    entry.spawn_y = entry.spawn_y
    entry.spawn_face = entry.spawn_face or 0.0
    entry.spawn_player = entry.spawn_player or false

    return entry
end

local function emit_change(action, shop, slot, entry, buyer, instance, stock, prev_stock, reason)
    local event_instance = Event_new(
        Shop_Change_Event,
        action,
        shop,
        shop.seller,
        slot,
        entry and entry.goods or false,
        buyer or false,
        instance or false,
        entry and entry.gold or 0,
        entry and entry.lumber or 0,
        stock,
        prev_stock,
        reason
    )
    return event_instance:emit()
end

local function add_entry(shop, entry, slot)
    local slots = get_slots(shop)
    local slot_by_goods = get_slot_by_goods(shop)
    slots[slot] = entry
    shop.size = shop.size + 1
    slot_by_goods[entry.goods] = slot

    if slot == shop.first_free then
        refresh_first_free(shop, slot + 1)
    end
end

local function remove_entry(shop, slot, entry)
    local slots = get_slots(shop)
    local slot_by_goods = get_slot_by_goods(shop)
    slots[slot] = nil
    shop.size = shop.size - 1
    slot_by_goods[entry.goods] = nil

    if slot < shop.first_free then
        shop.first_free = slot
    end
end

local function can_pay(buyer_player, gold, lumber)
    if buyer_player.gold < gold then
        return false, "not_enough_gold"
    end
    if buyer_player.lumber < lumber then
        return false, "not_enough_lumber"
    end
    return true
end

local function pay(buyer_player, gold, lumber)
    if gold ~= 0 then
        buyer_player.gold = buyer_player.gold - gold
    end
    if lumber ~= 0 then
        buyer_player.lumber = buyer_player.lumber - lumber
    end
end

local function run_allow_rules(shop, entry, buyer, seller, slot)
    local allow_rule = shop.allow_rule
    if allow_rule then
        local ok, err = allow_rule(shop, entry, buyer, seller, slot)
        if ok == false then
            return false, err or "shop_rule_rejected"
        end
    end

    local allow = entry.allow
    if allow then
        local ok, err = allow(entry, shop, buyer, seller, slot)
        if ok == false then
            return false, err or "entry_rule_rejected"
        end
    end

    return true
end

local function create_goods(shop, entry, buyer, seller, slot, buyer_player)
    local create = entry.create
    if create then
        return create(shop, entry, buyer, seller, slot, buyer_player)
    end

    if entry.is_instance then
        return entry.goods
    end

    local spawn_x = entry.spawn_x or seller.x
    local spawn_y = entry.spawn_y or seller.y

    if entry.kind == KIND_ITEM then
        return Item.create(entry.goods, spawn_x, spawn_y)
    end

    local spawn_face = entry.spawn_face
    local spawn_player = entry.spawn_player or resolve_unit_owner(seller) or buyer_player
    if not spawn_player then
        return false
    end

    return Unit.create(entry.goods, spawn_player, spawn_x, spawn_y, spawn_face)
end

local function destroy_created_goods(entry, goods)
    if not entry.is_instance and goods then
        goods:destroy()
    end
end

local function transfer_goods(entry, goods, buyer, buyer_player)
    local goods_datatype = DataType_get(goods)
    if entry.kind == KIND_ITEM then
        if goods_datatype ~= "item" or not goods.handle then
            return false, "invalid_item"
        end

        local ok = Jass_UnitAddItem(buyer.handle, goods.handle)
        if ok == false then
            return false, "buyer_inventory_full"
        end
        return true
    end

    if goods_datatype ~= "unit" then
        return false, "invalid_unit"
    end

    goods.owner = buyer_player
    return true
end

Shop_Change_Event = Event.eventType("Shop_Change", {
    fields = {
        "action",
        "shop",
        "seller",
        "slot",
        "goods",
        "buyer",
        "instance",
        "gold",
        "lumber",
        "stock",
        "prev_stock",
        "reason",
    },
    roles = {"shop", "seller", "goods", "buyer", "instance"},
    emit = function (shop_event)
        local is_success = true
        local shop = shop_event.shop
        local seller = shop_event.seller
        local goods = shop_event.goods
        local buyer = shop_event.buyer
        local instance = shop_event.instance

        if shop then
            is_success = Event_execute(shop_event, "shop", shop)
            if not is_success then
                goto recycle
            end
        end

        if seller then
            is_success = Event_execute(shop_event, "seller", seller)
            if not is_success then
                goto recycle
            end
        end

        if goods then
            is_success = Event_execute(shop_event, "goods", goods)
            if not is_success then
                goto recycle
            end
        end

        if buyer then
            is_success = Event_execute(shop_event, "buyer", buyer)
            if not is_success then
                goto recycle
            end
        end

        if instance and instance ~= goods then
            is_success = Event_execute(shop_event, "instance", instance)
            if not is_success then
                goto recycle
            end
        end

        is_success = Event_execute(shop_event)

        ::recycle::
        shop_event:recycle()
        return is_success
    end
})

local Shop
Shop = Class("Shop", {
    __mode = "kv",

    __shop_by_seller = table.setmode({}, "kv"),

    __init__ = function (class, shop, seller, capacity, config)
        if __DEBUG__ then
            assert(DataType_get(seller) == "unit", "Shop.__init__: seller must be a unit")
            assert(is_integer(capacity) and capacity > 0, "Shop.__init__: capacity must be a positive integer")
            assert(config == nil or type(config) == "table", "Shop.__init__: config must be a table")
        end

        config = config or {}

        local old_shop = class.__shop_by_seller[seller]
        if old_shop and old_shop ~= shop then
            class.__shop_by_seller[seller] = nil
        end

        shop.seller = seller
        shop.capacity = capacity
        shop.size = 0
        shop.first_free = 1
        shop.name = config.name or false
        shop.allow_rule = config.allow_rule or config.allow or false

        rawset(shop, slots_modify, Array.alloc(capacity))
        rawset(shop, slot_by_goods_modify, table.setmode({}, "k"))

        class.__shop_by_seller[seller] = shop
        DataType_set(shop, "shop")

        return shop
    end,

    __del__ = function (class, shop)
        local seller = shop.seller
        if seller and class.__shop_by_seller[seller] == shop then
            class.__shop_by_seller[seller] = nil
        end

        rawset(shop, slots_modify, nil)
        rawset(shop, slot_by_goods_modify, nil)
    end,

    isEmpty = function (shop)
        return shop.size == 0
    end,

    isFull = function (shop)
        return shop.size >= shop.capacity
    end,

    space = function (shop)
        return shop.capacity - shop.size
    end,

    contains = function (shop, goods)
        assert_goods(goods, "Shop.contains")
        return get_slot_by_goods(shop)[goods] ~= nil
    end,

    get = function (shop, slot)
        local resolved_slot = normalize_slot(shop, slot, "Shop.get")
        if not resolved_slot then
            return nil
        end

        local entry = get_slots(shop)[resolved_slot]
        return entry and entry.goods or nil
    end,

    getEntry = function (shop, slot)
        local resolved_slot = normalize_slot(shop, slot, "Shop.getEntry")
        if not resolved_slot then
            return nil
        end
        return get_slots(shop)[resolved_slot]
    end,

    slotOf = function (shop, goods)
        assert_goods(goods, "Shop.slotOf")
        return get_slot_by_goods(shop)[goods] or false
    end,

    match = function (shop, goods)
        return match_entry(shop, goods, "Shop.match")
    end,

    stockOf = function (shop, slot_or_goods)
        local slot, entry = resolve_entry(shop, slot_or_goods, "Shop.stockOf")
        if not slot then
            return false, entry
        end
        return entry.stock
    end,

    costOf = function (shop, slot_or_goods)
        local slot, entry = resolve_entry(shop, slot_or_goods, "Shop.costOf")
        if not slot then
            return false, entry
        end
        return entry.gold, entry.lumber
    end,

    findEmpty = function (shop, start_slot)
        local slots = get_slots(shop)
        local capacity = shop.capacity
        local slot = start_slot or shop.first_free

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

    add = function (shop, goods, slot, config, reason)
        assert_goods(goods, "Shop.add")
        if __DEBUG__ then
            assert(config == nil or type(config) == "table", "Shop.add: config must be a table")
        end

        local slot_by_goods = get_slot_by_goods(shop)
        if slot_by_goods[goods] then
            return false, "goods_already_listed"
        end

        local target_slot, err = resolve_target_slot(shop, slot, "Shop.add")
        if not target_slot then
            return false, err
        end

        local slots = get_slots(shop)
        if slots[target_slot] ~= nil then
            return false, "slot_occupied"
        end

        local entry = prepare_entry(goods, config)
        if not entry then
            return false, "invalid_goods"
        end

        add_entry(shop, entry, target_slot)
        emit_change(ACTION_ADD, shop, target_slot, entry, false, false, entry.stock, false, reason)
        return target_slot
    end,

    remove = function (shop, slot_or_goods, reason)
        local slot, entry = resolve_entry(shop, slot_or_goods, "Shop.remove")
        if not slot then
            return false, entry
        end

        local prev_stock = entry.stock
        remove_entry(shop, slot, entry)
        emit_change(ACTION_REMOVE, shop, slot, entry, false, false, false, prev_stock, reason)
        return entry, slot
    end,

    restock = function (shop, slot_or_goods, stock, reason)
        local slot, entry = resolve_entry(shop, slot_or_goods, "Shop.restock")
        if not slot then
            return false, entry
        end

        if entry.is_instance then
            return false, "instance_goods_no_stock"
        end

        local resolved_stock
        if stock == false then
            resolved_stock = false
        else
            resolved_stock = normalize_stock(false, stock, "Shop.restock")
            if resolved_stock == false then
                return false, "invalid_stock"
            end
        end

        local prev_stock = entry.stock
        entry.stock = resolved_stock
        emit_change(ACTION_RESTOCK, shop, slot, entry, false, false, resolved_stock, prev_stock, reason)
        return resolved_stock
    end,

    clear = function (shop, reason)
        local removed = Array.new()
        local slots = get_slots(shop)

        for slot = 1, shop.capacity do
            local entry = slots[slot]
            if entry ~= nil then
                removed[#removed + 1] = entry
                local prev_stock = entry.stock
                remove_entry(shop, slot, entry)
                emit_change(ACTION_REMOVE, shop, slot, entry, false, false, false, prev_stock, reason)
            end
        end

        shop.first_free = 1
        return removed
    end,

    canSell = function (shop, slot_or_goods, buyer)
        assert_unit(buyer, "Shop.canSell")

        local slot, entry = resolve_entry(shop, slot_or_goods, "Shop.canSell")
        if not slot then
            return false, entry
        end

        if entry.stock == 0 then
            return false, "out_of_stock"
        end

        local buyer_player = resolve_unit_owner(buyer)
        if not buyer_player then
            return false, "invalid_buyer_owner"
        end

        local ok, err = can_pay(buyer_player, entry.gold, entry.lumber)
        if not ok then
            return false, err
        end

        ok, err = run_allow_rules(shop, entry, buyer, shop.seller, slot)
        if not ok then
            return false, err
        end

        return true, entry, slot, buyer_player
    end,

    recordSale = function (shop, sold_goods, buyer, reason)
        assert_goods(sold_goods, "Shop.recordSale")
        assert_unit(buyer, "Shop.recordSale")

        local sold_datatype = DataType_get(sold_goods)
        if sold_datatype ~= "item" and sold_datatype ~= "unit" then
            if __DEBUG__ then
                error("Shop.recordSale: sold_goods must be an item or unit instance")
            end
            return false, "invalid_sold_goods"
        end

        local slot, entry = match_entry(shop, sold_goods, "Shop.recordSale")
        if not slot then
            return false, entry
        end

        local prev_stock = entry.stock
        local next_stock = prev_stock

        if entry.is_instance then
            remove_entry(shop, slot, entry)
            next_stock = 0
        elseif prev_stock ~= false then
            if prev_stock <= 0 then
                return false, "out_of_stock"
            end
            next_stock = prev_stock - 1
            entry.stock = next_stock
        end

        emit_change(ACTION_SELL, shop, slot, entry, buyer, sold_goods, next_stock, prev_stock, reason)

        local on_sell = entry.on_sell
        if on_sell then
            on_sell(sold_goods, shop, entry, buyer, shop.seller, slot)
        end

        return sold_goods, slot, entry
    end,

    sell = function (shop, slot_or_goods, buyer, reason)
        assert_unit(buyer, "Shop.sell")

        local ok, entry, slot, buyer_player = shop:canSell(slot_or_goods, buyer)
        if not ok then
            return false, entry
        end

        local seller = shop.seller
        local sold_goods = create_goods(shop, entry, buyer, seller, slot, buyer_player)
        if not sold_goods then
            return false, "create_failed"
        end

        local err
        ok, err = transfer_goods(entry, sold_goods, buyer, buyer_player)
        if not ok then
            destroy_created_goods(entry, sold_goods)
            return false, err
        end

        pay(buyer_player, entry.gold, entry.lumber)

        ok, err = shop:recordSale(sold_goods, buyer, reason)
        if not ok then
            return false, err
        end

        return sold_goods
    end,

    iterator = function (shop)
        local slots = get_slots(shop)
        local index = 0
        local capacity = shop.capacity

        return function ()
            for slot = index + 1, capacity do
                local entry = slots[slot]
                if entry ~= nil then
                    index = slot
                    return slot, entry.goods, entry
                end
            end
            return nil
        end
    end,

    forEach = function (shop, callback)
        if __DEBUG__ then
            assert(type(callback) == "function", "Shop.forEach: callback must be a function")
        end

        for slot, goods, entry in shop:iterator() do
            if callback(goods, slot, entry, shop) == false then
                return false
            end
        end

        return true
    end,

    toTable = function (shop)
        local result = Array.alloc(shop.capacity)
        local slots = get_slots(shop)
        for slot = 1, shop.capacity do
            result[slot] = slots[slot]
        end
        return result
    end,
})

Class.static(Shop, {
    ACTION_ADD = ACTION_ADD,
    ACTION_REMOVE = ACTION_REMOVE,
    ACTION_RESTOCK = ACTION_RESTOCK,
    ACTION_SELL = ACTION_SELL,

    getBySeller = function (seller)
        if __DEBUG__ then
            assert(DataType_get(seller) == "unit", "Shop.getBySeller: seller must be a unit")
        end
        return Shop.__shop_by_seller[seller]
    end,

    recordSaleBySeller = function (seller, sold_goods, buyer, reason)
        if __DEBUG__ then
            assert(DataType_get(seller) == "unit", "Shop.recordSaleBySeller: seller must be a unit")
        end

        local shop = Shop.__shop_by_seller[seller]
        if not shop then
            return false, "shop_not_found"
        end

        return shop:recordSale(sold_goods, buyer, reason)
    end,
})

function Event.onShopChange(callback, role, object)
    Event.on(Shop_Change_Event, callback, role, object)
end

function Event.offShopChange(callback, role, object)
    Event.off(Shop_Change_Event, callback, role, object)
end

return Shop
