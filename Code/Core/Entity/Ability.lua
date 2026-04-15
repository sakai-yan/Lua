local Jass = require "Lib.API.Jass"
local Tool = require "Lib.API.Tool"
local Constant = require "Lib.API.Constant"
local Class = require "Lib.Base.Class"
local DataType = require "Lib.Base.DataType"
local Set = require "Lib.Base.Set"
local CastType = require "FrameWork.GameSetting.CastType"

-- 本地化
local MHAbility_SetAbilityCustomDataInt = Jass.MHAbility_SetAbilityCustomDataInt
local type = type

--最大技能数
local MAX_ABILITY_COUNT = 8

--技能栏
local AbilBar
--[[
    技能按钮位置索引表
    将技能栏序号(1-12)映射到游戏界面的 XY 坐标
    
    游戏界面技能按钮布局：
        {0,0} {1,0} {2,0} {3,0}
        {0,1} {1,1} {2,1} {3,1}
        {0,2} {1,2} {2,2} {3,2}
    
    对应序号(按列从下到上)：
        1,  2,  3,  4
        5,  6,  7,  8
        9,  10,  11,  12
]]
local BUTTON_POS = {
    { 0, 1 }, { 1, 1 }, { 2, 1 }, { 3, 1 },
    { 0, 2 }, { 1, 2 }, { 2, 2 }, { 3, 2 }
}

AbilBar = {
    --实例以键值弱引用的方式存储数据
    __mode = "kv",
}

--Ability类
local Ability
Ability = Class("Ability", {

    --存放所有单位实例，强引用，用于保证ability不被回收
    __abilitys = Set.new(),

    --实例以键值弱引用的方式存储数据
    __mode = "kv",

    --隐藏技能ID（即不插入技能栏的技能）
    __HIDDEN_ABILITY_ID = Tool.S2Id("MFHS"),

    --物品技能ID（即物品附带的技能）
    __ITEM_ABILITY_ID = Tool.S2Id("MFIt"),

    --物品栏技能ID列表
    __abil_list = {},

    --技能句柄索引（用于根据句柄获取技能）
    __ability_by_handle = table.setmode({}, "kv"),

    --实例构造器
    ---@param class table Ability类
    ---@param skill table 技能类型
    ---@return table 技能实例
    ---@usage local ability = Ability.new(skill)，可创建无handle的ability
    __constructor__ = function (class, skill)
        if __DEBUG__ then
            assert(DataType.get(skill) == "skill", "Ability.__constructor__:技能类型错误")
        end

        local ability = DataType.set({
            handle = false,
            owner = false,
            type = skill
        }, "ability")

        class.__abilitys:add(ability)

        return ability
    end,

    --实例销毁器
    ---@param class table Ability类
    ---@usage Ability.destroy(ability)
    __del__ = function (class, ability)
        if __DEBUG__ then
            assert(DataType.get(ability) == "ability", "Ability.__del__:参数必须为技能实例")
        end

        class.__abilitys:discard(ability)

        local ability_handle = ability.handle
        if ability_handle then
            class.__ability_by_handle[ability_handle] = nil
            Jass.MHAbility_Remove(ability.handle)
        end

        setmetatable(ability, nil)
    end,

    --实例索引回退，如果技能没有该属性，则回退到技能类型，如果技能类型也没有，则回退到Ability基类
    __index__ = function (ability, key)
        return ability.type[key]
    end,

    --将handle注册到技能实例
    handleRegister = function (ability, ability_handle)
        if __DEBUG__ then
            assert(DataType.get(ability) == "ability", "Ability.handleRegister:参数必须为技能实例")
        end
        if not ability_handle or ability.handle then return end
        ability.handle = ability_handle
        Ability.__ability_by_handle[ability_handle] = ability

        --有handle后，更改技能实例的相关属性
        local skill = ability.type
        ability.cast_type = skill.cast_type
    end,

    --注册技能类型
    --如果创建技能类型时没填的信息，则使用模板信息
    ---@param skill_name string 技能名
    ---@param template table 技能模板
    ---@return table 技能类型
    skill = function (skill_name, template)
        if __DEBUG__ then
            assert(type(template) == "table" and type(template.name) == "string", "技能类型设置必须是一个表，且必须有名字")
        end
        local skill = DataType.set({
            name = skill_name,                          --技能名
            describe = template.describe or false,               --说明
            text = template.text or false,                       --文本
            target_type = template.target_type or Ability.TarMode_ground_air_enemy, --目标允许，默认对地对空对敌
            cast_type = template.cast_type or false,              --释放类型，默认为被动
            distance = template.distance or 0.00,       --施法距离
            cost = template.cost or 0.00,               --法力消耗,默认为0
            range = template.range or 0.00,             --技能范围,默认为0
            cooldown = template.cooldown or 0.00,       --冷却时间,默认为0
            act_time = template.act_time or 0.00,       --动作持续时间，即施法前摇，施法时做动作的时间，时间太短会无动作,默认为0
            cast_time = template.cast_time or 0.00,     --施法时间，施法后暂停的时间，一般是引导技能才需要,默认为0
            back_swing = template.back_swing or 0.00,    --施法后摇,
            add_rule = template.add_rule or false,          --技能添加回调
            remove_rule = template.remove_rule or false,     --技能删除回调
            prepare_rule = template.prepare_rule or false,   --技能准备施放回调
            start_rule = template.start_rule or false,       --技能开始施放回调
            execute_rule = template.execute_rule or false,   --技能发动效果回调
            finish_rule = template.finish_rule or false,     --技能施法结束回调
            stop_rule = template.stop_rule or false          --技能停止施放回调
        }, "skill")
        return skill
    end,

    --学习技能，从skill创建ability实例，并添加到单位上
    --具体实现见Logic.Process.Ability.add
    ---@usage Ability.learn(skill, unit, is_insert, index)，从技能类型创建技能实例，并添加到单位上
    learn = false,

    --根据名称获取技能类型
    getSkillByName = function (skill_name)
        if __DEBUG__ then
            assert(type(skill_name) == "string", "Ability.getSkillByName:技能名必须为字符串")
        end
        return Ability.__skill_by_name[skill_name]
    end,

    --根据句柄获取技能实例
    getByHandle = function (ability_handle)
        return ability_handle and Ability.__ability_by_handle[ability_handle]
    end,

    __attributes__ = {

        ---@施法前摇 number 前摇+施放时间＝按下技能到技能发动的时间
        {
            name = "cast_point",
            get = function (ability, key)
                if ability.handle then
                    return Jass.MHAbility_GetAbilityCastpoint(ability.handle)
                end
                return nil
            end,
            set = function (ability, key, cast_point)
                if __DEBUG__ then
                    assert(type(cast_point) == "number", "Ability.cast_point:必须为实数")
                end
                Jass.MHAbility_SetAbilityCastpoint(ability.handle, cast_point)
            end
        },

        ---@施放时间 number 前摇+施放时间＝按下技能到技能发动的时间
        {
            name = "cast_time",
            get = function (ability, key)
                if ability.handle then
                    return Jass.MHAbility_GetAbilityCustomLevelDataReal(ability.handle, 1, Constant.ABILITY_LEVEL_DEF_DATA_CAST_TIME)
                end
                return nil
            end,
            set = function (ability, key, cast_time)
                if __DEBUG__ then
                    assert(type(cast_time) == "number", "Ability.cast_time:必须为实数")
                end
                Jass.MHAbility_SetAbilityCustomLevelDataReal(ability.handle, 1, Constant.ABILITY_LEVEL_DEF_DATA_CAST_TIME, cast_time)
            end
        },

        ---@施法前摇 number 前摇+释放时间＝按下技能到技能发动的时间
        ---@按下技能→前摇结束→触发准备释放技能事件→释放时间结束→触发发动技能事件,然后技能结束后→触发技能结束事件→后摇→单位恢复通常命令
        {
            name = "act_time",
            get = function (ability, key)
                if ability.handle then
                    return Jass.MHAbility_GetAbilityCastpoint(ability.handle)
                end
                return nil
            end,
            set = function (ability, key, act_time)
                if __DEBUG__ then
                    assert(type(act_time) == "number", "Ability.act_time:必须为实数")
                end
                Jass.MHAbility_SetAbilityCastpoint(ability.handle, act_time)
            end
        },
        
        ---@施法后摇 number 技能结束后恢复通常命令的时间，可以通过s打断
        {
            name = "back_swing",
            get = function (ability, key)
                if ability.handle then
                    return Jass.MHAbility_GetAbilityBackswing(ability.handle)
                end
                return nil
            end,
            set = function (ability, key, back_swing)
                if __DEBUG__ then
                    assert(type(back_swing) == "number", "Ability.back_swing:必须为实数")
                end
                Jass.MHAbility_SetAbilityBackswing(ability.handle, back_swing)
            end
        },

        ---@冷却时间 number
        {
            name = "cooldown",
            get = function (ability, key)
                if ability.handle then
                    return Jass.MHAbility_GetAbilityCooldown(ability.handle)
                end
                return nil
            end,
            set = function (ability, key, cooldown)
                if __DEBUG__ then
                    assert(type(cooldown) == "number", "Ability.cooldown:必须为实数")
                end
                Jass.MHAbility_SetAbilityCooldown(ability.handle, cooldown)
            end
        },

        ---@施法间隔 number
        {
            name = "cast_gap",
            get = function (ability, key)
                if ability.handle then
                    return Jass.MHAbility_GetAbilityCustomLevelDataReal(ability.handle, 1, Constant.ABILITY_LEVEL_DEF_DATA_CAST_TIME)
                end
                return nil
            end,
            set = function (ability, key, cast_gap)
                if __DEBUG__ then
                    assert(type(cast_gap) == "number", "Ability.cast_gap:必须为实数")
                end
                Jass.MHAbility_SetAbilityCustomLevelDataReal( ability.handle, 1, Constant.ABILITY_LEVEL_DEF_DATA_CAST_TIME, cast_gap)
            end
        },
        
        ---@施法距离 number
        {
            name = "distance",
            get = function (ability, key)
                if ability.handle then
                    return Jass.MHAbility_GetAbilityCustomLevelDataReal(ability.handle, 1, Constant.ABILITY_LEVEL_DEF_DATA_RANGE)
                end
                return nil
            end,
            set = function (ability, key, distance)
                if __DEBUG__ then
                    assert(type(distance) == "number", "Ability.distance:必须为实数")
                end
                Jass.MHAbility_SetAbilityCustomLevelDataReal( ability.handle, 1, Constant.ABILITY_LEVEL_DEF_DATA_RANGE, distance)
            end
        },

        ---@技能范围 number
        {
            name = "range",
            get = function (ability, key)
                if ability.handle then
                    return Jass.MHAbility_GetAbilityCustomLevelDataReal(ability.handle, 1, Constant.ABILITY_LEVEL_DEF_DATA_AREA)
                end
                return nil
            end,
            set = function (ability, key, range)
                if __DEBUG__ then
                    assert(type(range) == "number", "Ability.range:必须为实数")
                end
                Jass.MHAbility_SetAbilityCustomLevelDataReal( ability.handle, 1, Constant.ABILITY_LEVEL_DEF_DATA_AREA, range)
            end
        },

        ---@法力消耗 number
        {
            name = "cost",
            get = function (ability, key)
                if ability.handle then
                    return Jass.MHAbility_GetAbilityCustomLevelDataInt(ability.handle, 1, Constant.ABILITY_LEVEL_DEF_DATA_MANA_COST)
                end
                return nil
            end,
            set = function (ability, key, cost)
                if __DEBUG__ then
                    assert(type(cost) == "number", "Ability.cost:必须为实数")
                end
                Jass.MHAbility_SetAbilityCustomLevelDataInt( ability.handle, 1, Constant.ABILITY_LEVEL_DEF_DATA_MANA_COST, math.floor(cost))
            end
        },

        ---@释放类型 casttype
        {

            name = "cast_type",
            get = function (ability, key)
                if ability.handle then
                    return CastType.fromValue(Jass.MHAbility_GetAbilityCastType(ability.handle))
                end
                return nil
            end,
            set = function (ability, key, cast_type)
                if __DEBUG__ then
                    assert(DataType.get(cast_type) == "casttype", "Ability.cast_type:释放类型必须为释放类型实例")
                end
                Jass.MHAbility_SetAbilityCastType(ability.handle, CastType.toValue(cast_type))
            end
        },
        
        ---@目标允许 target_typeinteger
        {
            name = "target_type",
            get = function (ability, key)
                if ability.handle then
                    return Jass.MHAbility_GetAbilityTargetAllow(ability.handle)
                end
                return nil
            end,
            set = function (ability, key, target_type)
                if __DEBUG__ then
                    assert(math.type(target_type) == "integer", "Ability.target_type:目标类型必须为整数")
                end
                Jass.MHAbility_SetAbilityTargetAllow(ability.handle, target_type)
            end
        }
    },


    --技能栏API
    --新建技能栏
    newBar = function (object)
        if __DEBUG__ then
            assert(type(object) == "table", "AbilBar.__constructor__:参数必须为对象实例")
        end
        local abilbar = DataType.set({
            --自行计数，因为有时候删除技能会让技能栏存在空位，#获取到的数量会不准确
            _count = 0,
            _owner = object
        }, "abilbar")

        object._abilbar = abilbar

        return setmetatable(abilbar, AbilBar)
    end,

    --删除技能栏
    destroyBar = function (abilbar)
        local object = abilbar._owner
        object._abilbar = nil
    end,

    --- 插入技能到技能栏
    ---@param abilbar table 技能栏实例
    ---@param ability table 技能实例
    ---@param index number|nil 指定位置（可选，默认自动找空位）
    ---@return boolean 是否成功插入
    insertToBar = function (abilbar, ability, index)
        if __DEBUG__ then
            assert(DataType.get(abilbar) == "abilbar" and DataType.get(ability) == "ability", "AbilBar.insert:尝试对非技能栏或非技能进行插入")
        end
        
        -- 检查技能是否已在技能栏中
        if ability.__index_of_bar ~= nil then
            return false
        end

        -- 确定插入位置
        if index then
            -- 指定位置：检查有效性
            if index < 1 or index > AbilBar._MAX_ABILITY_COUNT or abilbar[index] then
                return false
            end
        else
            -- 自动查找空位
            for i = 1, AbilBar._MAX_ABILITY_COUNT do
                if not abilbar[i] then
                    index = i
                    break
                end
            end
            -- 技能栏已满
            if not index then
                return false
            end
        end
        
        -- 插入技能
        abilbar[index] = ability
        abilbar._count = abilbar._count + 1
        ability.__index_of_bar = index
        
        -- 设置按钮位置
        local pos = AbilBar.BUTTON_POS[index]
        MHAbility_SetAbilityCustomDataInt(ability.handle, Constant.ABILITY_DEF_DATA_BUTTON_X, pos[1])
        MHAbility_SetAbilityCustomDataInt(ability.handle, Constant.ABILITY_DEF_DATA_BUTTON_Y, pos[2])
        
        return true
    end,

    --- 从技能栏移除技能（不压缩空位）
    ---@param abilbar table 技能栏实例
    ---@param ability table 技能实例
    ---@return boolean 是否成功移除
    removeFromBar = function (abilbar, ability)
        if __DEBUG__ then
            assert(DataType.get(abilbar) == "abilbar" and DataType.get(ability) == "ability", "AbilBar.remove:尝试对非技能栏或非技能进行移除")
        end

        if not abilbar or ability._owner ~= abilbar._owner then return false end
        
        -- 快速定位
        local index = ability.__index_of_bar
        if not index then return false end
        
        abilbar[index] = nil
        abilbar._count = abilbar._count - 1
        ability.__index_of_bar = nil
        
        return true
    end,

    --- 遍历技能栏中的所有技能
    ---@param object table 对象实例
    ---@param callback function 回调函数 function(ability, index): boolean|nil，返回false停止遍历
    ---@return number 遍历的技能数量
    forEachInBar = function(object, callback)
        if not object or type(callback) ~= "function" then return 0 end
        
        local abilbar = object._abilbar
        if not abilbar then return 0 end

        local count = 0
        for i = 1, MAX_ABILITY_COUNT do
            local ability = abilbar[i]
            if ability then
                count = count + 1
                if callback(ability, i) == false then
                    break
                end
            end
        end
        return count
    end,

    --- 获取指定位置的技能
    ---@param index number 位置
    ---@return table|nil 技能实例
    getByIndexInBar = function(object, index)
        local abilbar = object._abilbar
        if not abilbar then return nil end
        return abilbar[index]
    end,

    --- 获取对象的技能栏实例
    ---@param object table 对象实例
    ---@return table|nil 技能栏实例
    getBar = function(object)
        if __DEBUG__ then
            assert(type(object) == "table", "AbilBar.getBar:参数必须为对象实例")
        end
        return object._abilbar
    end,

    --- 获取最大技能数
    ---@return number
    getMaxCount = function()
        return MAX_ABILITY_COUNT
    end,

    --- 判断技能栏是否已满
    ---@param object table 技能栏实例
    ---@return boolean 是否已满
    isFullInBar = function(object)
        local abilbar = AbilBar.getBar(object)
        if not abilbar then return false end
        return abilbar._count == AbilBar._MAX_ABILITY_COUNT
    end
})


--- 获取技能在技能栏中的位置
---@param ability table 技能实例
---@return number|nil index, table|nil owner
function Ability.indexInBar(ability)
    return ability.__index_of_bar, ability._owner
end

--技能栏技能马甲列表初始化
local function abilListInit()
    local abil_list = Ability.__abil_list
    for index = 1, AbilBar._MAX_ABILITY_COUNT do
        local id = tostring(index)
        local activeCode = "MFA" .. id
        table.insert(abil_list, Tool.S2Id(activeCode))
    end
end

abilListInit()

return Ability

--[[
准备施放技能，开始施放，发动效果，施法结束，停止施法
如果发动效果后途中终止，会触发停止施放，但不会触发施法结束（一般启动效果后手动停止的时候，都会触发这一条，除非手速极其快速）
准备施放技能后直接发布停止命令，会触发：准备，停止，结束
开始施法时发布停止，触发：准备，开始，停止，结束
用结构体算法的施法单位，10000次，10ms，跟直接用原生施法单位效率一致，原生的施法单位或触发单位和施放技能也可以做到在中途插入施放技能时的准确判断
准备施法时命令自己发动其他技能，触发：准备，停止，然后走一遍其他技能的流程，最后返回原技能触发施法结束（如果是发动技能时发布命令，则不触发这条）
准备施法时命令其他单位发动其他技能，触发：准备，开始，然后走一遍其他技能的流程：准备，开始，发动，最后返回原技能触发发动，结束，停止
--]]