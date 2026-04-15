local Jass = require "Lib.API.Jass"
local Tool = require "Lib.API.Tool"
local Constant = require "Lib.API.Constant"
local Class = require "Lib.Base.Class"
local DataType = require "Lib.Base.DataType"
local Set = require "Lib.Base.Set"
local Terrain = require "FrameWork.GameSetting.terrain"
local Event = require "FrameWork.Manager.Event"

local CreateUnit = Jass.CreateUnit
local MHUnit_GetEnumUnit = Jass.MHUnit_GetEnumUnit
local MFLua_EnumUnitInRange = Jass.MFLua_EnumUnitInRange
local MFLua_CodePack = Tool.MFLua_CodePack
local RemoveUnit = Jass.RemoveUnit
local MHUnit_CheckPosition = Jass.MHUnit_CheckPosition
local MHUnit_ModifyPositionX = Jass.MHUnit_ModifyPositionX
local MHUnit_ModifyPositionY = Jass.MHUnit_ModifyPositionY
local SetUnitX = Jass.SetUnitX
local SetUnitY = Jass.SetUnitY
local GetUnitX = Jass.GetUnitX
local GetUnitY = Jass.GetUnitY
local GetUnitFlyHeight = Jass.GetUnitFlyHeight
local SetUnitFlyHeight = Jass.SetUnitFlyHeight
local GetTerrainZ = Terrain.getZ
local SetUnitPosition = Jass.SetUnitPosition

local Event_new = Event.new

local owner_modify = Class.modify_field("owner")

--封装单位

local DataType_get = DataType.get
local DataType_set = DataType.set
local Class_get = Class.get
local type = type

--单位创建事件
local Unit_Create_Event = Event.eventType("Unit_Create_Event", {
    fields = {"unit"},
    roles = {"unit"}
})

--单位删除事件
local Unit_Delete_Event = Event.eventType("Unit_Delete_Event", {
    fields = {"unit"},
    roles = {"unit"}
})

--单位类
local Unit
Unit = Class("Unit", {

    --存放所有单位实例，强引用，用于保证unit不被回收
    __units = Set.new(),

    --可以以handle为索引获取封装单位
    __units_by_handle = table.setmode({}, "kv"),

    --数组，存放创建的所有单位类型，单位类型是一个配置表
    __unit_types = {},

    --用于以名字为索引获取单位类型
    __unittypes_by_name = table.setmode({}, "kv"),

    --单位实例以键值弱引用的方式存储数据
    __mode = "kv",

    __setattr__ = {},

    __getattr__ = {},

    --需初始化赋值的属性
    __need_init_attr = {},

    --实例索引回退
    __index__ = function (unit, key)
        return unit.type[key]
    end,

    --实例初始化
    ---@param class table Unit类
    ---@param unit table 单位实例
    ---@param unit_type table 单位类型
    ---@param unit_handle userdata|nil 单位句柄（可选）
    ---@return table|nil 单位实例
    __init__ = function(class, unit, unit_type, unit_handle)
        if __DEBUG__ then
            assert(DataType.get(unit_type) == "unittype", "Unit.__init__:参数类型错误")
        else
            if not unit_type then return end
        end

        if unit_handle and Tool.isHandleType(unit_handle, "unit") then
            unit.handle = unit_handle
            class.__units_by_handle[unit.handle] = unit
        end
 
        unit.type = unit_type
        class.__units:add(unit)
        DataType_set(unit, "unit")
        
        --触发单位创建事件
        local unit_create_event = Event_new(Unit_Create_Event, unit)
        unit_create_event:emit(unit_create_event)

        return unit
    end,

    --单位销毁
    ---@param class table Unit类
    ---@param unit table 单位实例
    ---@usage Unit.destroy(unit) / unit:destroy()
    __del__ = function (class, unit)
        if __DEBUG__ then
            assert(DataType.get(unit) == "unit", "Unit.__del__:参数必须为单位实例")
        end

        --触发单位删除事件
        local unit_delete_event = Event_new(Unit_Delete_Event, unit)
        unit_delete_event:emit(unit_delete_event)

        if unit.handle then
            class.__units_by_handle[unit.handle] = nil
            RemoveUnit(unit.handle)
            unit.handle = nil
        end
        class.__units:discard(unit)
    end,

    --注册单位类型
    ---@param unit_type_name string 单位类型名
    ---@param unit_config table 单位类型配置
    ---@return table|nil 单位类型
    ---@skills字段如果是table，里面存储的技能类型会在单位初始化时添加技能到技能栏
    unitType = function (unit_type_name, unit_config)
        if __DEBUG__ then
            assert(type(unit_type_name) == "string", "Unit.unitType:unit_type_name应为字符串" .. " " .. tostring(unit_type_name))
            assert(type(unit_config) == "table", "Unit.unitType:unit_config应为表")
            if unit_config.__unit_type_id then
                assert(math.type(unit_config.__unit_type_id) == "integer", "Unit.unitType:__unit_type_id应为整数")
            end
        end
        print("Unit.unitType:", "unit_type_name", unit_type_name)

        if not unit_type_name or Unit.__unittypes_by_name[unit_type_name] then return end

        local unit_type = unit_config or {
            __unit_type_id = false,
            name = false
        }

        unit_type.name = unit_type_name
        table.insert(Unit.__unit_types, unit_type)    --插入存放单位类型的表，方便遍历
        Unit.__unittypes_by_name[unit_type_name] = unit_type
        return DataType.set(unit_type, "unittype")
    end,

    --根据类型名获取单位类型unittype
    ---@param unit_type_name string 单位类型名
    ---@return table|nil 单位类型
    getTypeByName = function (unit_type_name)
        if __DEBUG__ then
            assert(type(unit_type_name) == "string", "Unit.getTypeByName:unit_type_name应为字符串")
        end
        return Unit.__unittypes_by_name[unit_type_name]
    end,

    --根据handle获取单位
    ---@param unit_handle userdata|nil 单位句柄
    ---@return table|nil 单位实例
    getByHandle = function (unit_handle)
        return Unit.__units_by_handle[unit_handle]
    end,

    --新建单位
    ---@param unit_type table 单位类型
    ---@param player table 玩家
    ---@param x number|nil 单位X坐标
    ---@param y number|nil 单位Y坐标
    ---@param face number|nil 单位朝向
    ---@return table|nil 单位实例
    create = function (unit_type, player, x, y, face)
        if __DEBUG__ then
            assert(DataType.get(unit_type) == "unittype", "Unit.create:新建单位时使用非单位类型作为模板")
            assert(DataType.get(player) == "player", "Unit.create:新建单位时使用非玩家作为模板")
            assert(type(x) == "number" and type(y) == "number" and type(face) == "number", "Unit.create:参数类型错误")
        end
        return Unit.new(unit_type, CreateUnit(player.handle, unit_type.__unit_type_id, x or 0.00, y or 0.00, face or 0.00))
    end,

    --批量创建单位
    ---@param unit_type table 单位类型
    ---@param player table 玩家
    ---@param number number 创建数量
    ---@param position_func function 位置函数
    ---@param ... any 位置函数参数
    creates = function (unit_type, player, number, position_func, ...)
        if __DEBUG__ then
            assert(DataType_get(unit_type) == "unittype", "Unit.create:新建单位时使用非单位类型作为模板")
            assert(DataType_get(player) == "player", "Unit.create:新建单位时使用非玩家作为模板")
            assert(type(number) == "number" and math.type(number) == "integer", "Unit.create:参数类型错误")
            assert(type(position_func) == "function", "Unit.create:位置函数类型错误")
        end
        local group = {}
        local unitid = unit_type.__unit_type_id
        local Unit_new = Unit.new
        for index = 1, number do
            local x, y, face = position_func(...)
            group[index] = Unit_new(unit_type, CreateUnit(player.handle, unitid, x or 0.00, y or 0.00, face or 0.00))
        end
        return group
    end,

    --选取范围内单位
    --@param x number 单位X坐标
    --@param y number 单位Y坐标
    --@param radius number 范围半径
    --@param action function 回调函数
    --@param ... any 回调函数参数
    enumInRange = function(x, y, radius, action)
        if __DEBUG__ then
            assert(type(x) == "number" and type(y) == "number" and type(radius) == "number", "Unit.EnumUnitInRange:参数类型错误")
            assert(type(action) == "function", "Unit.EnumUnitInRange:action应为函数")
        end
        MHUnit_EnumInRangeEx(x, y, radius, action)
    end,

    --获取选取单位
    --@return table|nil 单位实例
    getEnumUnit = function()
        local unit_handle = MHUnit_GetEnumUnit()
        if unit_handle then
            return Unit.__units_by_handle[unit_handle]
        end
        return nil
    end,

    __attributes__ = {
    
        ---@当前生命值 number
        ---@usage unit.hp = 100
        ---@usage local hp = unit.hp
        {
            name = "hp",
            get = function (unit, key)
                return Jass.GetUnitState( unit.handle, Constant.UNIT_STATE_LIFE)
            end,
            set = function (unit, key, hp_value)
                Jass.SetUnitState( unit.handle, Constant.UNIT_STATE_LIFE, hp_value)
            end
        },
    
        ---@当前法力值 number
        ---@usage unit.mp = 100
        ---@usage local mp = unit.mp
        {
            name = "mp",
            get = function (unit, key)
                return Jass.GetUnitState( unit.handle, Constant.UNIT_STATE_MANA)
            end,
            set = function (unit, key, mp_value)
                Jass.SetUnitState( unit.handle, Constant.UNIT_STATE_MANA, mp_value)
            end
        },
    
        ---@当前移动速度 number
        ---@usage unit.speed = 100
        ---@usage local speed = unit.speed
        {
            name = "speed",
            get = function (unit, key)
                Jass.GetUnitMoveSpeed(unit.handle)
            end,
            set = function (unit, key, speed_value)
                Jass.SetUnitMoveSpeed(unit.handle, speed_value)
            end
        },
        
        ---@X坐标 number
        ---@usage unit.x = 100
        ---@usage local x = unit.x
        {
            name = "x",
            get = function (unit, key)
                return GetUnitX(unit.handle)
            end,
            set = function (unit, key, x_value)
                SetUnitX(unit.handle, x_value)
            end
        },
    
        ---@Y坐标 number
        ---@usage unit.y = 100
        ---@usage local y = unit.y
        {
            name = "y",
            get = function (unit, key)
                return GetUnitY(unit.handle)
            end,
            set = function (unit, key, y_value)
                SetUnitY(unit.handle, y_value)
            end
        },

        {
            name = "z",
            get = function (unit, key)
                local unit_handle = unit.handle
                return GetUnitFlyHeight(unit_handle) + Terrain.getZ(GetUnitX(unit_handle), GetUnitY(unit_handle))
            end,
            set = function (unit, key, z_value)
                local unit_handle = unit.handle
                local terrain_z = Terrain.getZ(GetUnitX(unit_handle), GetUnitY(unit_handle))
                SetUnitFlyHeight(unit.handle, z_value - terrain_z, 0) --设置飞行高度，第二个参数为变高速度，0表示瞬间变高
            end
        },

        {
            name = "high",
            get = function (unit, key)
                return Jass.GetUnitFlyHeight(unit.handle)
            end,
            set = function (unit, key, high_value)
                Jass.SetUnitFlyHeight(unit.handle, high_value, 0) --设置飞行高度，第二个参数为变高速度，0表示瞬间变高
            end
        },
    
        ---@名字 string
        ---@usage unit.name = "unit"
        ---@usage local name = unit.name
        {
            name = "name",
            get = function (unit, key)
                return Jass.MHUnit_GetInfoName(unit.handle)
            end,
            set = function (unit, key, value)
                Jass.MHUnit_SetInfoName(unit.handle, value)
            end
        },
    
        ---@称号 string
        ---@usage unit.title = "unit"
        ---@usage local title = unit.title
        {
            name = "title",
            get = function (unit, key)
                return Jass.MHUnit_GetInfoClass(unit.handle)
            end,
            set = function (unit, key, value)
                Jass.MHUnit_SetInfoClass(unit.handle, value)
            end
        },
    
        ---@模型 string
        ---@usage unit.model = "unit"
        ---@usage local model = unit.model
        {
            name = "model",
            get = function (unit, key)
                return rawget(unit, Class.modify_field("model")) or Jass.MHUnit_GetDefDataStr( Jass.GetUnitTypeId(unit.handle), Constant.UNIT_DEF_DATA_MODEL)
            end,
            set = function (unit, key, value)
                Jass.MHUnit_SetModel( unit.handle, value, false)
                rawset(unit, Class.modify_field("model"), value)
            end
        },

        ---@owner table 单位拥有者
        ---@usage unit.owner = player
        ---@usage local owner = unit.owner
        {
            name = "owner",
            get = function (unit, key)
                return rawget(unit, owner_modify) or Jass.GetOwningPlayer(unit.handle)
            end,
            set = function (unit, key, player)
                Jass.SetUnitOwner(unit.handle, player.handle, true)
                rawset(unit, owner_modify, player)
            end
        },

        ---@单位是否存活
        {
            name = "alive",
            get = function (unit, key)
                return Jass.UnitAlive(unit.handle)
            end,
            set = function (unit, key, value)
                if __DEBUG__ then
                    print("Unit.alive是只读属性")
                end
            end
        }
    }

})

--为单位实例赋予句柄
---@param unit table 单位对象
---@param unit_handle userdata 单位句柄
function Unit.transform(unit, unit_handle)
    if __DEBUG__ then
        assert(DataType.get(unit) == "unit", "Unit.transform: 单位错误")
        assert(Tool.isHandleType(unit_handle, "unit"), "Unit.transform: 句柄错误")
    end
    if not unit_handle then
        return
    end
    unit.handle = unit_handle
    Unit.__units_by_handle[unit.handle] = unit

    --添加属性技能
    unit:attributeInit()

    local attr_list = Unit.__need_init_attr
    local unit_type = unit.type
    if not unit_type then return end
    for index = 1, #attr_list do
        local attr_config = attr_list[index]
        local value = unit[attr_config.base_name] or 0.00
        unit[attr_config.base_name] = nil
        unit[attr_config.base_name] = value
    end
end

--将单位类型技能表中的技能添加到单位上
---@param unit table 单位对象
---@usage Unit.abilityFromType(unit)
---@usage unit:abilityFromType()
function Unit.abilityFromType(unit)
    if __DEBUG__ then
        assert(DataType_get(unit) == "unit", "Unit.transform: 单位错误")
    end
    local skills = unit.type.skills
    if not skills then return end
    Class_get("Ability").abilityFromArray(skills, unit)
end

---@设置单位属性 （完整流程：监听 → setter → reward）
--@param unit table 单位对象
--@param real_Attr_name string 真实属性名（__base_xxx 或 __bonus_xxx，可用Attr.getBaseName或Attr.getBonusName获取）
--@param value number 属性值
--@param mode string "add"|"set"，默认 "set"
---@function Unit.setAttr(unit, real_Attr_name, value, mode)

---@获取单位属性 unit[Attr.getBaseName(attr_name)] 或 unit[Attr.getBonusName(attr_name)] 或 unit[attr_name]


--获取单位XY坐标
---@param unit table 单位对象
---@return number x
---@return number y
---@return number z
---@usage local x, y, z = Unit.getPosition(unit)
---@usage local x, y, z = unit:getPosition()
function Unit.getPosition(unit)
    if DataType_get(unit) == "unit" and unit.handle then
        local unit_handle = unit.handle
        local x, y = GetUnitX(unit_handle), GetUnitY(unit_handle)
        return x, y, GetUnitFlyHeight(unit_handle) + GetTerrainZ(x, y)
    end
    return 0.00, 0.00, 0.00
end

--设置单位坐标
---@usage Unit.SetPosition(unit, 100, 200, 300)
---@usage unit:SetPosition(100, 200, 300)
function Unit.SetPosition(unit, x, y, z)
    if __DEBUG__ then
        assert(type(x) == "number" and type(y) == "number", "Unit:setXY参数错误")
        assert(DataType_get(unit) == "unit", "Unit:setXY单位错误")
    end
    local handle = unit.handle
    if MHUnit_CheckPosition(handle, x, y) then
        SetUnitX(handle, x)
        SetUnitY(handle, y)
    else
        SetUnitX(handle, MHUnit_ModifyPositionX(handle, x, y))
        SetUnitY(handle, MHUnit_ModifyPositionY(handle, x, y))
    end

    if z then
        SetUnitFlyHeight(handle, z - GetTerrainZ(x, y), 0)
    end
end

--移动单位（中途不触发进入区域事件）
---@param unit table 单位对象
---@param x number x坐标
---@param y number y坐标
---@usage Unit.move(unit, 100, 200)
---@usage unit:move(100, 200)
function Unit.move(unit, x, y)
    if __DEBUG__ then
        assert(type(x) == "number" and type(y) == "number", "Unit:SetPosition参数错误")
        assert(DataType_get(unit) == "unit", "Unit:SetPosition单位错误")
    end
    SetUnitPosition(unit.handle, x, y)
end



return Unit
