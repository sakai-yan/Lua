local Class = require "Lib.Base.Class"
local Event = require "FrameWork.Manager.Event"

local Event_execute = Event.execute

local Attr

--[[
属性变化事件

用于表达“某个 real_attr_name 的值即将发生变化”这一事件类型。

事件实例字段：
    - real_attr_name string   真实属性名（基础或附加）
    - oldVal    number   变化前的值
    - newVal    number   变化后的值
    - object    table    发生变化的对象（通常是 Unit 实例或物品实例）
    - delta     number   变化量（newVal - oldVal）
    - able      boolean  可通过将其设为 false 阻止属性变化（由上层逻辑解读）
--]]
local Attr_Change_Event
Attr_Change_Event = Event.eventType("属性变化", {
    fields = {
        "real_attr_name",  --- 真实属性名
        "oldVal",     --- 旧值
        "newVal",     --- 新值
        "object",     --- 变化对象
        "delta",      --- 变化量
    },
    roles = {
        "attr_name",
        "real_attr_name",
        "object"
    },
    emit = function (attr_change_event_instance)
        local real_attr_name = attr_change_event_instance.real_attr_name
        
        local is_sucess = Event_execute(Attr_Change_Event, "real_attr_name", real_attr_name)
        if not is_sucess then
            goto recycle
        end

        local config = Attr._attr_by_config[real_attr_name]
        local attr_name = config.name

        is_sucess = Event_execute(Attr_Change_Event, "attr_name", attr_name)
        if not is_sucess then
            goto recycle
        end

        is_sucess = Event_execute(Attr_Change_Event, "object", attr_change_event_instance.object)
        if not is_sucess then
            goto recycle
        end

        is_sucess = Event_execute(Attr_Change_Event, "object", attr_change_event_instance.object.type)
        if not is_sucess then
            goto recycle
        end

        --任意事件
        is_sucess = Event_execute(Attr_Change_Event)

        ::recycle::
        attr_change_event_instance:recycle()
        return is_sucess
    end
})

--[[
Attr 属性系统核心模块

设计目标：
    - 属性定义期：声明式、宽松、对使用者友好
    - 编译期：顺序确定、结果一致、无隐式依赖
    - 运行期：零遍历、零分支、事件驱动

重要约束：
    - 使用层接口与原始 Attr 库完全一致
    - reward 表允许任意顺序、混合 key 类型
    - pairs 只用于“语义采集”，不参与最终执行顺序
--]]
Attr = {

    ---============================================================
    --- 核心数据结构
    ---============================================================

    --- 属性配置表：
    ---  * 数组部分：按 define 调用顺序存属性名
    _list = {},

    --支持三种 key 访问 attr_config
    ---      Attr._attr_by_config["生命"]
    ---      Attr._attr_by_config["__base_生命"]
    ---      Attr._attr_by_config["__bonus_生命"]
    _attr_by_config = {},

    --- 奖励处理器表：
    ---  key   : real_attr_name
    ---  value : function(event)
    __reward = {},

    --- 属性变化事件名表：
    ---  key   : real_attr_name
    ---  value : event_type_name
    _attr_change_event_name_list = {},

    ---============================================================
    --- 通用 total getattr（默认 base + bonus）
    ---============================================================

    --[[
    通用总属性获取函数

    当属性未提供 total_getattr 时使用：
        total = base + bonus
    --]]
    ---@param unit table
    ---@param Attr_name string
    ---@return number
    __common_total_getattr = function(unit, Attr_name)
        local config = Attr._list[Attr_name]
        if not config then
            return 0.0
        end
        return (unit[config.base_name] or 0.0)
             + (unit[config.bonus_name] or 0.0)
    end,

    ---============================================================
    --- reward 代码生成器（顺序确定）
    ---============================================================

    --[[
    根据 reward 描述生成处理函数

    说明：
        - reward_list 为“中间描述数组”，已经脱离原 reward 表
        - 本函数只处理“展开 + 排序 + 生成代码”
        - 生成顺序仅由 target_real_name 决定，跨客户端稳定
    
    
        {
            {
                target_real_name = "__base_生命",
                coefficient = 25,
            },
            ...
        }
    --]]
    ---@param real_attr_name string
    ---@param reward_list table
    ---@param custom_func function|nil
    ---@return function|nil
    __generate_reward_handler = function(real_attr_name, reward_list, custom_func)
        if #reward_list == 0 and type(custom_func) ~= "function" then
            return nil
        end

        --- 关键点：排序，消灭 pairs 带来的非确定性
        table.sort(reward_list, function(a, b)
            return a.target_real_name < b.target_real_name
        end)

        local code = {}

        code[#code + 1] = "local Class = require('Base.Class')"
        code[#code + 1] = "local Unit = Class.get('Unit')"
        code[#code + 1] = "local setAttr = Unit.setAttr"

        if custom_func then
            code[#code + 1] = "local custom = ..."
        end

        code[#code + 1] = "return function(event)"
        code[#code + 1] = "    local unit  = event.object"
        code[#code + 1] = "    local delta = event.delta"

        --- 完全展开 reward（无循环、无判断）
        for i = 1, #reward_list do
            local r = reward_list[i]
            code[#code + 1] = string.format(
                '    setAttr(unit, "%s", delta * %g, "add")',
                r.target_real_name,
                r.coefficient
            )
        end

        if custom_func then
            code[#code + 1] = "    custom(event)"
        end

        code[#code + 1] = "end"

        local factory, err = load(
            table.concat(code, "\n"),
            string.format("=[reward:%s]", real_attr_name)
        )

        if not factory then
            if __DEBUG__ then
                print(err)
            end
            return nil
        end

        return custom_func and factory(custom_func) or factory()
    end,

    ---============================================================
    --- reward 构建
    ---============================================================

     --[[
    根据 reward 表生成 base / bonus 的 reward 处理器

    reward 表规则：
        - key   : string 属性名 或 attr_config
        - value : number（系数）
        - 可额外包含：
            * base_reward  : function(event)
            * bonus_reward : function(event)

    重要说明：
        - pairs 仅用于“语义采集”
        - 最终执行顺序完全由生成期排序决定
    --]]
    ---@param Attr_name string 属性名
    ---@param reward table    reward 描述表
    _create_reward_handlers = function(Attr_name, reward)
        if type(reward) ~= "table" then
            return
        end

        local config = Attr._list[Attr_name]
        if not config then
            return
        end

        local base_rewards  = {}
        local bonus_rewards = {}

        --- pairs 仅用于“语义采集”
        for key, value in pairs(reward) do
            if type(value) == "number" then
                local target_config

                if type(key) == "string" then
                    target_config = Attr._list[key]
                elseif type(key) == "table" and key.base_name then
                    target_config = key
                end

                if target_config then
                    base_rewards[#base_rewards + 1] = {
                        target_real_name = target_config.base_name,
                        coefficient = value
                    }
                    bonus_rewards[#bonus_rewards + 1] = {
                        target_real_name = target_config.bonus_name,
                        coefficient = value
                    }
                end
            end
        end

        local base_handler = Attr.__generate_reward_handler(
            config.base_name,
            base_rewards,
            reward.base_reward
        )
        if base_handler then
            Attr.__reward[config.base_name] = base_handler
        end

        local bonus_handler = Attr.__generate_reward_handler(
            config.bonus_name,
            bonus_rewards,
            reward.bonus_reward
        )
        if bonus_handler then
            Attr.__reward[config.bonus_name] = bonus_handler
        end
    end,

    ---============================================================
    --- 属性定义
    ---============================================================
     --[[
    定义一个属性

    define 的职责仅限于：
        - 声明属性结构
        - 绑定 Unit 的 __getattr__ / __setattr__
        - 创建事件类型
        - （可选）直接绑定 reward

    不应在此阶段：
        - 引入跨属性逻辑
        - 依赖其他属性是否已定义
    --]]
    ---@param Attr_name string   属性名
    ---@param template table    属性模板
    ---@return table            attr_config
    define = function(Attr_name, template)
        local config = {
            name = Attr_name,
            base_name  = "__base_"  .. Attr_name,
            bonus_name = "__bonus_" .. Attr_name,
        }

        --- 注册到属性表
        table.insert(Attr._list, config)
        Attr._attr_by_config[Attr_name] = config
        Attr._attr_by_config[config.base_name]  = config
        Attr._attr_by_config[config.bonus_name] = config

        --- 注册 Unit 属性访问器
        local Unit = Class.get("Unit") or error("Attribute.Attr:获取Unit类失败")
        Class.attribute(Unit, {
            
            {
                name = config.base_name,
                get = template.base_getattr,
                set = template.base_setattr
            },
            
            {
                name = config.bonus_name,
                get = template.bonus_getattr,
                set = template.bonus_setattr
            },
            
            {
                name = Attr_name,
                get = template.total_getattr or Attr.__common_total_getattr,
                set = template.total_setattr
            }        
        })

        --- 创建 reward
        if template.reward then
            Attr._create_reward_handlers(Attr_name, template.reward)
        end

        return config
    end,

    ---============================================================
    --- 后置 reward（避免定义顺序依赖）
    ---============================================================
    --[[
    推荐用法：
        --- 第一阶段：定义所有属性
        local str  = Attr.define("体魄", {...})
        local life = Attr.define("生命", {...})

        --- 第二阶段：配置 reward（使用 attr_config 作为 key，避免硬编码字符串）
        Attr.reward(str, {
            [life]       = 25.00,          --- 每点体魄增加 25 生命
            base_reward  = function(event) ... end,
            bonus_reward = function(event) ... end,
        })
    --]]
    ---@param attr_config table  属性配置对象（Attr.define 的返回值）
    ---@param reward_table table reward 配置表，同 define.template.reward
    reward = function(attr_config, reward_table)
        Attr._create_reward_handlers(attr_config.name, reward_table)
    end,

    ---============================================================
    --- 查询 API
    ---============================================================

    ---- 获取属性配置（通过任意名称：属性名 / 基础名 / 附加名）
    ---- @param str string 任意属性名
    ---- @return table|nil 属性配置对象
    getAttrConfig = function(str)
        return Attr._attr_by_config[str]
    end,

    ---获取属性名称（从任意名称获取）
    ---@param str string 属性名
    ---@return string|nil 属性名称
    getName = function(str)
        local config = Attr._attr_by_config[str]
        return config and config.name
    end,

    ---获取基础属性名（从属性名或任意名称获取）
    ---@param str string 属性名
    ---@return string|nil 基础属性名
    getBaseName = function(str)
        local config = Attr._attr_by_config[str]
        return config and config.base_name
    end,

    ---获取附加属性名（从属性名或任意名称获取）
    ---@param str string 属性名
    ---@return string|nil 附加属性名
    getBonusName = function(str)
        local config = Attr._attr_by_config[str]
        return config and config.bonus_name
    end,

    ---检查是否为已注册的属性（任意名称）
    ---@param str string 属性名
    ---@return boolean
    isAttr = function(str)
        return Attr._attr_by_config[str] ~= nil
    end,

    ---检查是否为基础属性名
    ---@param str string 属性名
    ---@return boolean
    isBaseAttr = function(str)
        local config = Attr._attr_by_config[str]
        return config and config.base_name == str or false
    end,

    ---检查是否为附加属性名
    ---@param str string 属性名
    ---@return boolean
    isBonusAttr = function(str)
        local config = Attr._attr_by_config[str]
        return config and config.bonus_name == str or false
    end,

    ---获取属性变化事件
    change_event = Attr_Change_Event,

    --注册属性变化事件
    ---@usage Attr.onChange(function(event_instance), "object", unit)
    ---@usage Attr.onChange(function(event_instance), "attr_name", "生命")
    ---@usage Attr.onChange(function(event_instance), "real_attr_name", Attr.getBaseName("生命"))
    ---高性能用法：缓存事件类型，然后用Event.off进行注销
    onChangeEvent = function(callback, role, object)
        if __DEBUG__ then
            assert(type(callback) == "function", "Attr.attrChangeEventOn: callback must be a function")
            assert(type(role) == "string", "Attr.attrChangeEventOn: role must be a string")
        end

        Event.on(Attr_Change_Event, callback, role, object)
    end,

    ---注销属性变化事件
    ---@usage Attr.offChange(function(event_instance), "object", unit)
    ---@usage Attr.offChange(function(event_instance), "attr_name", "生命")
    ---@usage Attr.offChange(function(event_instance), "real_attr_name", Attr.getBaseName("生命"))
    ---高性能用法：缓存事件类型，然后用Event.off进行注销
    offChangeEvent = function(callback, role, object)
         if __DEBUG__ then
            assert(type(callback) == "function", "Attr.attrChangeEventOff: callback must be a function")
            assert(type(role) == "string", "Attr.attrChangeEventOff: role must be a string")
        end
        Event.off(Attr_Change_Event, callback, role, object)
    end,
}



return Attr
