local Tool    = require "Lib.API.Tool"
local Jass         = require "Lib.API.Jass"
local Class = require "Lib.Base.Class"
local Set = require "Lib.Base.Set"
local Csv   = require "Lib.Base.Csv"
local DataType= require "Lib.Base.DataType"
local Attr       = require "FrameWork.GameSetting.Attribute"
local CastType   = require "FrameWork.GameSetting.CastType"
local Event      = require "FrameWork.Manager.Event"
--模拟物品

local DataType_set = DataType.set
local DataType_get = DataType.get
local Event_execute = Event.execute
local model_modify = Class.modify_field("model")
local color_modify = Class.modify_field("color")
local scale_modify = Class.modify_field("scale")
local portrait_modify = Class.modify_field("portrait")

local _attr_verify
if __DEBUG__ then
    _attr_verify = function (itemtype)
        assert(not itemtype.name or type(itemtype.name) == "string", "Item.itemType:itemtype.name应为字符串")
        assert(not itemtype.level or type(itemtype.level) == "integer", "Item.itemType:itemtype.level应为整数")
        assert(not itemtype.gold or type(itemtype.gold) == "integer", "Item.itemType:itemtype.gold应为整数")
        assert(not itemtype.lumber or type(itemtype.lumber) == "integer", "Item.itemType:itemtype.lumber应为整数")
        assert(not itemtype.cate or type(itemtype.cate) == "string", "Item.itemType:itemtype.cate应为字符串")
        assert(not itemtype.level_path or type(itemtype.level_path) == "string", "Item.itemType:itemtype.level_path应为字符串")
        assert(not itemtype.name or type(itemtype.name) == "string", "Item.itemType:itemtype.name应为字符串")
        assert(not itemtype.icon or type(itemtype.icon) == "string", "Item.itemType:itemtype.icon应为字符串")
        assert(not itemtype.description or type(itemtype.description) == "string", "Item.itemType:itemtype.description应为字符串")
        assert(not itemtype.bg_description or type(itemtype.bg_description) == "string", "Item.itemType:itemtype.bg_description应为字符串")
        assert(not itemtype.skills or type(itemtype.skills) == "table", "Item.itemType:itemtype.skills应为表")
        assert(not itemtype.attr_description or type(itemtype.attr_description) == "string", "Item.itemType:itemtype.attr_description应为字符串")
        assert(not itemtype.model or type(itemtype.model) == "string", "Item.itemType:itemtype.model应为字符串")
        assert(not itemtype.model_scale or type(itemtype.model_scale) == "float", "Item.itemtype:itemtype.model_scale应为浮点数")
        assert(not itemtype.color or type(itemtype.color) == "integer", "Item.itemType:itemtype.color应为整数")
        --Refine material 炼器材料
        assert(not itemtype.is_material or type(itemtype.is_material) == "boolean", "Item.itemtype:itemtype.is_material应为布尔值")
        assert(not itemtype.refine_add_abil or type(itemtype.refine_add_abil) == "skill", "Item.itemtype:itemtype.refine_add_abil应为技能类型")
        assert(not itemtype.on_material or type(itemtype.on_material) == "function", "Item.itemtype:itemtype.on_material应为函数")
        assert(not itemtype.off_material or type(itemtype.off_material) == "function", "Item.itemtype:itemtype.off_material应为函数")
        assert(not itemtype.refine_add_text or type(itemtype.refine_add_text) == "string", "Item.itemtype:itemtype.refine_add_text应为字符串")
        --RefineAble 可炼器物品
        assert(not itemtype.refine_able or type(itemtype.refine_able) == "boolean", "Item.itemtype:itemtype.refine_able应为布尔值")
        assert(not itemtype.refine_material or type(itemtype.refine_material) == "table", "Item.itemtype:itemtype.refine_material应为表")
        assert(not itemtype.on_refine or type(itemtype.on_refine) == "function", "Item.itemType:itemtype.on_refine应为函数")
        assert(not itemtype.off_refine or type(itemtype.off_refine) == "function", "Item.itemType:itemtype.off_refine应为函数")

        if itemtype.skills then
            for _, skill in pairs(itemtype.skills) do
                assert(DataType.get(skill) == "skill", "Item.itemType:itemtype.skills表中元素应为技能类型")
            end
        end
    end
end

--物品创建事件，具体定义在Logic.Process.Item.Create里
local Item_New_Event = Event.eventType("物品创建", {
    fields = {"item"},
    roles = {"item"}
})

--物品删除事件，具体定义在Logic.Process.Item.Delete里
local Item_Del_Event = Event.eventType("物品删除", {
    fields = {"item"},
    roles = {"item"}
})

--物品类
local Item
Item = Class("Item", {

    --存放创建的所有物品类型，物品类型是一个配置表
    __item_types = Set.new(),

    --以handle为索引获取封装物品
    __items_by_handle = table.setmode({}, "kv"),

    --以名字为索引获取物品类型
    __itemtypes_by_name = table.setmode({}, "kv"),
    
    --实例以键值弱引用的方式存储数据
    __mode = "kv",
    
    --物品类型ID
    __TYPE_ID = Tool.S2Id("MFIt"),

    --物品技能ID
    __SKILL_ID = Tool.S2Id("MFIS"),

    --实例索引回退
    --@param key string 属性名
    __index__ = function (item, key)
        return item.type[key]
    end,

    --实例初始化
    --@param item_handle handle|nil 物品句柄（可选）
    --允许使用Item.new(item_type)创建一个不带handle的物品实例
    __init__ = function (class, item, item_type, item_handle)
        if __DEBUG__ then
            assert(DataType_get(item_type) == "itemtype", "Item.__init__:参数必须为物品类型")
        end

        item.handle = false
        item.type = item_type
        item.owner = false
        DataType_set(item, "item")

        class.transform(item, item_handle)

        --物品创建事件
        local event_instance = Event.new(Item_New_Event, item)
        Event.emit(event_instance)
        
        return item
    end,

    --实例销毁器
    --使用Item.destroy(item)销毁物品实例
    __del__ = function (class, item)
        if __DEBUG__ then
            assert(DataType_get(item) == "item", "Item.__del__:物品实例错误")
        end

        --物品删除事件
        local event_instance = Event.new(Item_Del_Event, item)
        Event.emit(event_instance)

        local item_handle = item.handle
        if item_handle then
            Item.__items_by_handle[item_handle] = nil
            Jass.RemoveItem(item_handle)
        end
        setmetatable(item, nil)
    end,

--]]

    --定义物品类型
    --[[
        level integer 等级
        gold integer 黄金
        stone integer 木材
        cate string 类别
        level_path string 等级光圈路径
        name string 名字
        art string 贴图
        description string 总描述
        bg_description string 背景描述
        skills table 技能表:skill1, skill2, ...应为被动，放在这些位置的主动技能无法通过使用物品施放
        {
            skill1,
            skill2,
            ...,
            active = active_skill,    --主动技能
        }
        
        attr_description 属性描述
        model 模型路径
        model_scale 模型缩放
        color 颜色

        is_material 是否为炼器材料
        refine_add_abil 用作炼器材料后附加的技能
        on_material 用作炼器材料时事件回调
        refine_add_text 炼器新增文本（加在背景描述下面）

        refine_able 可炼器
        refine_material 已用炼器材料记录
        on_refine 炼器事件回调
    --]]
    itemType = function (item_type_name, item_type_config)
        if __DEBUG__ then
            assert(type(item_type_name) == "string", "Item.itemType:item_type_name应为字符串")
            assert(type(item_type_config) == "table", "Item.itemType:item_type_config应为表")
        end

        local item_type = item_type_config or {
            name = false
        }

        item_type.name = item_type_name

        if __DEBUG__ then
            _attr_verify(item_type)
        end

        Item.__itemtypes_by_name[item_type_name] = item_type
        
        return DataType_set(item_type, "itemtype")
    end,

    transform = function (item, item_handle)
        if item_handle and Tool.isHandleType(item_handle, "item") then
            item.handle = item_handle
            Item.__items_by_handle[item_handle] = item

            --若本身没有覆写name和icon，则使用物品类型
            item.name = item.name
            item.icon = item.icon
        end
    end,

    --创建一个物品实例
    --@param x number 物品X坐标
    --@param y number 物品Y坐标
    --创建的物品实例是带handle的
    create = function (ItemType, x, y)
        if __DEBUG__ then
            assert(DataType_get(ItemType) == "itemtype", "Item.create:物品类型错误")
            assert(type(x) == "number" and type(y) == "number", "Item.create:参数类型错误")
        end

        return Item.new(ItemType, Jass.CreateItem(Item.__TYPE_ID, x, y))
    end,

    

    getByHandle = function (item_handle)
        return Item.__items_by_handle[item_handle]
    end,

    getTypeByName = function (item_name)
        return Item.__itemtypes_by_name[item_name]
    end,

    --事件，在Process中实现具体逻辑
    --物品创建事件
    _item_new_event = false,

    --物品删除事件
    _item_del_event = false,

    --物品使用事件
    _item_used_event = false,

    --物品获得事件
    _item_get_event = false,

    --物品失去事件
    _item_lose_event = false,

    --物品抵押事件
    _item_mortgaged_event = false,

    --物品售出事件
    _item_sale_event = false,

    __attributes__ = {
        
        ---@图标 string
        {
            name = "icon",
            get = function (item, key)
                return Jass.MHItem_GetHookIcon(item.handle)
            end,
            set = function (item, key, icon)
                Jass.MHItem_SetHookIcon(item.handle, icon)
            end
        },

        ---@名字 string
        {
            name = "name",
            get = function (item, key)
                return Jass.MHItem_GetHookName(item.handle)
            end,
            set = function (item, key, name)
                Jass.MHItem_SetHookName(item.handle, name)
            end
        },

        ---@模型 string
        {
            name = "model",
            get = function (item, key)
                return rawget(item, model_modify)
            end,
            set = function (item, key, model)
                Jass.MHItem_SetModel(item.handle, model)
                rawset(item, model_modify, model)
            end
        },

        ---@颜色 integer 可用Tool库里的Rgba2Color转换
        ---@usage item.color = Tool.Rgba2Color(255, 255, 255, 255)
        ---@usage item.color = Tool.Color2Rgba(0xFFFFFFFF)
        {
            name = "color",
            get = function (item, key)
                return rawget(item, color_modify)
            end,
            set = function (item, key, color)
                Jass.MHItem_SetColor(item.handle, color)
                rawset(item, color_modify, color)
            end
        },

        ---@缩放 number
        {
            name = "scale",
            get = function (item, key)
                return rawget(item, scale_modify)
            end,
            set = function (item, key, scale)
                Jass.MHItem_SetScale(item.handle, scale)
                rawset(item, scale_modify, scale)
            end
        },

        ---@肖像模型 string
        {
            name = "portrait",
            get = function (item, key)
                return rawget(item, portrait_modify)
            end,
            set = function (item, key, path)
                Jass.MHItem_SetPortrait(item.handle, path)
                rawset(item, portrait_modify, path)
            end
        },

        {
            name = "owner",
            get = function (item, key)
                Jass.MHItem_GetOwner(item.handle)
            end,
        }
    }
})

function Item.setCollisionType(item, to_other, from_other)
    Jass.MHItem_SetCollisionType(item.handle, to_other, from_other)
end


--设置物品属性
---@function Item.setAttr(item, real_Attr_name, value, mode) 完整定义见Logic.Define.Attribute

--[[
function  Item.InitAttr()
    local mapper = {
        --虚拟属性名映射物编属性名
        ["名字"] = "Name",
        ["等级"] = "level",
        ["模型"] = "file",
        ["图标"] = "Art",
        ["模型缩放"] = "modelScale"
    }
    local default = {
        ["模型缩放"] = 1.00
    }
    for line_num, headers, row in Csv:rows("Data.csv") do
        if not row or row["名字"] == "" then goto next_row end
        local ItemType = Class.get(row["名字"])
        if not ItemType then goto next_row end
        --读取每一行数据，存入UnitType，不生成物编
        for index = 1, #row do
            local value = row[index]
            local key = headers[index]
            --若表格中不存在值，则读取默认值
            if value == "" then
                value = default[key]   --有可能把""变成nil
            end
            if not value or value == "" then goto next_field end       --空单元格会被解析为空字符串，而不是nil
            if Attr.list:exist(key) then    --若是属性名，则存入附加属性
                local bonus_key = Attr.bonus_list[key]
                rawset(ItemType, bonus_key, value)
            else
                rawset(ItemType, key, value)
            end
            ::next_field::
        end
        ::next_row::
    end
end
--]]

return Item

--[[tips:
1.A杀普通物品可以触发死亡事件和删除事件，但不会删除handle
2.书类物品吃了之后会缩小模型，不会删除handle
3.售卖物品会删除handle，但不触发物品删除事件
4.药类物品吃了之后会触发删除事件，删除hanlde
5.可以在物品删除事件里面添加删除物品动作，这样就可以避免以上情况
--]]


