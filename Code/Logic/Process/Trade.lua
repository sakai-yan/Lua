local Jass = require "Lib.API.Jass"
local Tool = require "Lib.API.Tool"
local Constant = require "Lib.API.Constant"
local DataType = require "Lib.Base.DataType"
local Event = require "FrameWork.Manager.Event"
local Item = require "Core.Entity.Item"
local Unit = require "Core.Entity.Unit"

local Event_execute = Event.execute

--交易

---@goods unit|item
---@buyer unit
---@seller unit|nil

local Trade_Event
Trade_Event = Event.eventType("交易", {
    fields = {"goods", "buyer", "seller"},
    roles = {"goods", "buyer", "seller"},
    emit = function (trade_event)
        local goods = trade_event.goods
        local buyer = trade_event.buyer
        local seller = trade_event.seller
        local is_sucess = true

        --触发交易事件
        is_sucess = Event_execute(trade_event, "goods", goods)
        if not is_sucess then goto recycle end


        is_sucess = Event_execute(trade_event, "goods", goods.type)
        if not is_sucess then goto recycle end

        is_sucess = Event_execute(trade_event, "buyer", buyer)
        if not is_sucess then goto recycle end

        is_sucess = Event_execute(trade_event, "buyer", buyer.type)
        if not is_sucess then goto recycle end

        if seller then
            is_sucess = Event_execute(trade_event, "seller", seller)
            if not is_sucess then goto recycle end

            is_sucess = Event_execute(trade_event, "seller", seller.type)
            if not is_sucess then goto recycle end
        end
        
        --任意事件
        is_sucess = Event_execute(trade_event)

        ::recycle::
        trade_event:recycle()
        return is_sucess
    end
})

--卖物品流程
local item_sale_callback = function ()
    local item = Item.getByHandle(Jass.GetSoldItem())
    local seller = Unit.getByHandle(Jass.GetSellingUnit())

    if not item or not seller then return end
    local buyer = Unit.getByHandle(Jass.GetBuyingUnit())
    
    local trade_event = Event.new(Trade_Event, item, buyer, seller)
    trade_event:emit()
end

--出售物品事件触发器
Tool.cjAnyEventRegister(Jass.CreateTrigger(), Constant.EVENT_PLAYER_UNIT_SELL_ITEM, item_sale_callback)
--抵押物品（卖东西给商店）事件触发器
Tool.cjAnyEventRegister(Jass.CreateTrigger(), Constant.EVENT_PLAYER_UNIT_PAWN_ITEM, item_sale_callback)

--出售单位事件触发器
Tool.cjAnyEventRegister(Jass.CreateTrigger(), Constant.EVENT_PLAYER_UNIT_SELL, function ()
    local goods_unit = Item.getByHandle(Jass.GetSoldUnit())
    local seller = Unit.getByHandle(Jass.GetSellingUnit())

    if not goods_unit or not seller then return end
    local buyer = Unit.getByHandle(Jass.GetBuyingUnit())
    
    local trade_event = Event.new(Trade_Event, goods_unit, buyer, seller)
    trade_event:emit()
end)


--出售物品
function Item.sell(item, seller, buyer)
    if __DEBUG__ then
        assert(DataType.get(item) == "item", "Item.sell: 物品错误")
        assert(DataType.get(seller) == "unit", "Item.sell: 出售者错误")
        assert(DataType.get(buyer) == "unit", "Item.sell: 购买者错误")
    elseif not item or not seller or not buyer then return end
    
    Item.give(item, buyer)
    local trade_event = Event.new(Trade_Event, item, buyer, seller)
    trade_event:emit()
    return item
end

--雇佣单位
function Item.hire(unit, seller, buyer)
    if __DEBUG__ then
        assert(DataType.get(unit) == "unit", "Item.hire: 单位错误")
        assert(DataType.get(seller) == "unit", "Item.hire: 出售者错误")
        assert(DataType.get(buyer) == "unit", "Item.hire: 购买者错误")
    elseif not unit or not seller or not buyer then return end
    
    unit.owner = buyer.owner
    
    local trade_event = Event.new(Trade_Event, unit, buyer, seller)
    trade_event:emit()
    return unit
end

--注册交易事件
---@param callback function 回调函数
---@param role string "goods"|"buyer"|"seller"|nil（任意事件）
---@param object table unit|item|unit_type|item_type|nil（任意事件）
---@usage Event.onTrade(callback, "goods", item)
function Event.onTrade(callback, role, object)
    if __DEBUG__ then
        assert(type(callback) == "function", "Event.onTrade: callback must be a function")
        assert(type(role) == "string", "Event.onTrade: role must be a string")
        assert(type(object) == "table", "Event.onTrade: object must be a table")
    end
    
    Event.on(Trade_Event, callback, role, object)
end

--注销交易事件
function Event.offTrade(callback, role, object)
    if __DEBUG__ then
        assert(type(callback) == "function", "Event.offTrade: callback must be a function")
        assert(type(role) == "string", "Event.offTrade: role must be a string")
        assert(type(object) == "table", "Event.offTrade: object must be a table")
    end
    Event.off(Trade_Event, callback, role, object)
end