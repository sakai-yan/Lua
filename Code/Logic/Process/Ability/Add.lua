local Jass = require "Lib.API.Jass"
local DataType = require "Lib.Base.DataType"
local Event = require "FrameWork.Manager.Event"
local Ability = require "Core.Entity.Ability"
local Unit = require "Core.Entity.Unit"
local Item = require "Core.Entity.Item"

local Event_execute = Event.execute

---@技能添加过程
local Ability_Add_Event
Ability_Add_Event = Event.eventType("技能添加",{
    fields = {"ability", "unit"},
    roles = {"ability", "unit"},
    emit = function (ability_add_event)
        local ability = ability_add_event.ability
        local unit = ability_add_event.unit
        --技能添加规则，一般会读取到skill的add_rule，但如果实例覆写了add_rule，则执行实例的add_rule
        if ability.add_rule then
            ability.add_rule(ability, unit)
        end
        
        --触发添加技能事件
        local is_sucess = Event_execute(ability_add_event, "ability", ability)
        if not is_sucess then
            goto recycle
        end

        is_sucess = Event_execute(ability_add_event, "ability", ability.type)
        if not is_sucess then
            goto recycle
        end

        is_sucess = Event_execute(ability_add_event, "unit", unit)
        if not is_sucess then
            goto recycle
        end

        is_sucess = Event_execute(ability_add_event, "unit", unit.type)
        if not is_sucess then
            goto recycle
        end

        --任意事件
        is_sucess = Event_execute(ability_add_event)

        ::recycle::
        ability_add_event:recycle()
        return is_sucess
    end
})

--添加技能到单位
---@param ability table 技能实例
---@param is_insert boolean 是否插入技能栏
---@param index number|nil 技能栏索引（可选，默认自动找空位）
---@return boolean 是否成功添加
function Ability.add(ability, unit, is_insert, index)
    if __DEBUG__ then
        assert(DataType.get(unit) == "unit", "Ability.add:尝试对非单位进行添加技能")
        assert(DataType.get(ability) == "ability", "Ability.add:尝试添加非技能实例")
        if index then
            assert(math.type(index) == "integer" and index >= 1 and index <= Ability.getMaxCount, "Ability.add:技能栏索引必须是整数,且必须在1到8之间")
        end
    end

    --已在单位身上的技能，不能加到技能栏
    if not ability or ability.handle then
        return false
    end

    --获取或创建技能栏
    local abilbar = Ability.getBar(unit) or Ability.newBar(unit)
    local ability_id
    
    --根据是否插入技能栏决定使用什么id，若不插入技能栏（即不显示按钮），则使用隐藏技能id
    if is_insert and Ability.insertToBar(abilbar, ability, index) then
        ability_id = Ability.__abil_list[ability.__index_of_bar]
    else
        ability_id = Ability.__HIDDEN_ABILITY_ID
    end

    Ability.handleRegister(ability, Jass.MHUnit_AddAbility(unit.handle, ability_id, false))

    --触发添加技能事件
    local event_instance = Event.new(Ability_Add_Event, ability, unit)
    event_instance:emit()

    return true
end

--学习技能
function Ability.learn(skill, unit, is_insert, index)
    local ability = Ability.new(skill)
    return Ability.add(ability, unit, is_insert, index)
end

--注册技能添加事件
---@param callback function 回调函数，参数为事件实例
---@param role string 角色 ability或unit
---@param object table 对象实例或对象类型，若为nil则注册任意事件
---@usage Event.onAbilityAdd(function(event_instance), "ability", "fireball")
function Event.onAbilityAdd(callback, role, object)
    Event.on(Ability_Add_Event, callback, role, object)
end

--注销技能添加事件
function Event.offAbilityAdd(callback, role, object)
    Event.off(Ability_Add_Event, callback, role, object)
end

--用于捕获物品技能的添加
Jass.MHAbilityAddEvent_RegisterByCode(function()
    local unit_handle = Jass.MHEvent_GetUnit()
    local ability_handle = Jass.MHEvent_GetAbilityHandle()
    local unit = Unit.getByHandle(unit_handle)
    local item_handle = Jass.MHAbility_GetAbilitySourceItem(ability_handle)
    --若ability来源于物品
    if item_handle then
        local itemtype = Item.getByHandle(item_handle)
        if itemtype then
            local skills = itemtype.skills
            if skills and skills.active then
                local datatype = DataType.get(skills.active)
                if datatype == "skill" then
                    --封装技能
                    local ability = Ability.new(skills.active)
                    Ability.add(ability, unit, false, nil)
                elseif datatype == "ability" then
                    Ability.add(skills.active, unit, false, nil)
                end
            end
        end
    end
end)




