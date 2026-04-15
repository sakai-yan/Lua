local Jass = require "Lib.API.Jass"
local Constant = require "Lib.API.Constant"
local Queue = require "Lib.Base.Queue"
local DataType = require "Lib.Base.DataType"
local Event = require "FrameWork.Manager.Event"
local Unit = require "Core.Entity.Unit"

local floor = math.floor

local MHUnit_RestoreLife = Jass.MHUnit_RestoreLife
local MHDamage_DamageUnit = Jass.MHDamage_DamageUnit
local MHDamagingEvent_IsPhysical = Jass.MHDamagingEvent_IsPhysical
local MHDamagingEvent_GetSource = Jass.MHDamagingEvent_GetSource
local MHEvent_GetUnit = Jass.MHEvent_GetUnit
local MHDamagingEvent_GetDamage = Jass.MHDamagingEvent_GetDamage
local GetRandomInt = Jass.GetRandomInt

local Unit_getFromHandle = Unit.getFromHandle
local Event_execute = Event.execute

--伤害模块
local Damage


--默认使用cj的混乱攻击
local CJ_ATTACK_TYPE_CHAOS = Constant.ATTACK_TYPE_CHAOS
--默认使用cj的通用伤害
local CJ_DAMAGE_TYPE_UNIVERSAL = Constant.DAMAGE_TYPE_UNIVERSAL

--属性字段常量
local ATTR_SHIELD = "护体真元"
local ATTR_PHYSICAL_ARMOR = "护甲"
local ATTR_MAGIC_RESISTANCE = "法术抗性"
local ATTR_PHYSICAL_IGNORE_PERCENT = "无视护甲"
local ATTR_MAGIC_IGNORE_PERCENT = "无视法抗"
local ATTR_PHYSICAL_PENETRATE = "物理穿透"
local ATTR_MAGIC_PENETRATE = "法术穿透"
local ATTR_PHYSICAL_IMMUNE_PERCENT = "物理免伤"
local ATTR_MAGIC_IMMUNE_PERCENT = "法术免伤"
local ATTR_PHYSICAL_REDUCTION = "物理减伤"
local ATTR_MAGIC_REDUCTION = "法术减伤"
local ATTR_PHYSICAL_VAMP = "物理吸血"
local ATTR_MAGIC_VAMP = "法术吸血"
local ATTR_PHYSICAL_CRITICAL_RATE = "物理暴击率"
local ATTR_MAGIC_CRITICAL_RATE = "法术暴击率"
local ATTR_PHYSICAL_CRITICAL_DAMAGE = "物理暴击伤害"
local ATTR_MAGIC_CRITICAL_DAMAGE = "法术暴击伤害"

--伤害流程回调角色
local PROCESS_ROLE_SOURCE = "source"
local PROCESS_ROLE_TARGET = "target"

--执行伤害流程回调
local function processExecute(callbacks_set, damage_event_instance)
    local obj, list, ok
    obj = damage_event_instance[PROCESS_ROLE_SOURCE]
    --先对象后类型
    list = callbacks_set[PROCESS_ROLE_SOURCE][obj]
    if list then
        ok = list:forEachExecute(damage_event_instance)
    end

    if ok then
        list = callbacks_set[PROCESS_ROLE_SOURCE][obj.type]
        if list then
            ok = list:forEachExecute(damage_event_instance)
        end
    end

    if ok then
        obj = damage_event_instance[PROCESS_ROLE_TARGET]
        list = callbacks_set[PROCESS_ROLE_TARGET][obj]
        if list then
            ok = list:forEachExecute(damage_event_instance)
        end

        if ok then
            list = callbacks_set[PROCESS_ROLE_TARGET][obj.type]
            if list then
                ok = list:forEachExecute(damage_event_instance)
            end
        end
    end

    return ok
end



--获取物理相关属性
---@return number 护甲
---@return number 无视护甲百分比
---@return number 物理穿透
---@return number 物理免伤百分比
---@return number 物理减伤
local function getPhysicalAttrForDamageCalculate(source, target)
    local armor = target[ATTR_PHYSICAL_ARMOR]
    local phys_ignore_percent = source[ATTR_PHYSICAL_IGNORE_PERCENT]
    local phys_penetrate = source[ATTR_PHYSICAL_PENETRATE]
    local phys_immune_percent = source[ATTR_PHYSICAL_IMMUNE_PERCENT]
    local phys_reduction = source[ATTR_PHYSICAL_REDUCTION]
    
    return armor, phys_ignore_percent, phys_penetrate, phys_immune_percent, phys_reduction
end

--获取法术相关属性
---@return number 法术抗性
---@return number 无视法抗百分比
---@return number 法术穿透
---@return number 法术免伤百分比
---@return number 法术减伤
local function getMagicAttrForDamageCalculate(source, target)
    local magic_resistance = target[ATTR_MAGIC_RESISTANCE]
    local magic_ignore_percent = source[ATTR_MAGIC_IGNORE_PERCENT]
    local magic_penetrate = source[ATTR_MAGIC_PENETRATE]
    local magic_immune_percent = source[ATTR_MAGIC_IMMUNE_PERCENT]
    local magic_reduction = source[ATTR_MAGIC_REDUCTION]
    return magic_resistance, magic_ignore_percent, magic_penetrate, magic_immune_percent, magic_reduction
end

--根据伤害双方的遁法速度计算闪避率
local function dodgedApply(atk_df, def_df)
    return 1 / (1 + 22 / (def_df - atk_df)) * 100
end

--伤害计算
---@param damage_value number 具体伤害值
---@param resistance number 抗性：护甲|法术抗性
---@param ignore_percent number 无视抗性百分比
---@param penetrate number 穿透
---@param immune_percent number 免伤百分比
---@param reduction number 减伤
---@return number 修正后的伤害值，不小于0
local function damageCalculate(damage_value, resistance, ignore_percent, penetrate, immune_percent, reduction)
    --无视抗性
    resistance = resistance * (1.00 - ignore_percent / 100.00)
    --穿透
    resistance = resistance - penetrate
    --伤害重算
    damage_value = damage_value / (1.00 + (Damage.REDUCE_FACTOR * resistance))
    --免伤
    damage_value = damage_value * (1.00 - immune_percent / 100.00)
    --减伤
    damage_value = damage_value - reduction

    return damage_value
end

--伤害事件类型
local damage_event_type = Event.eventType("伤害", {
    fields = {
        "source",   --伤害来源
        "target",   --伤害目标
        "value",    --伤害值
        "is_critical", --是否暴击
        "is_dodged" --是否闪避
    },

    roles = {
        PROCESS_ROLE_SOURCE,
        PROCESS_ROLE_TARGET
    },

    emit = function (damage_event_instance)
        local source = damage_event_instance.source
        local target = damage_event_instance.target
        local damage_value_struct = damage_event_instance.value
        local is_sucess = true
        
        --伤害前阶段：1.伤害来源即将造成伤害 2.伤害目标即将受到伤害
        
        is_sucess = Damage.__predamage_callbacks:execute(damage_event_instance)
        if not is_sucess then goto recycle end
        
        --是否闪避
        if damage_event_instance.is_dodged == nil then
            local dodged_value = dodgedApply(source.evasion_speed, target.evasion_speed)
            damage_event_instance.is_dodged = GetRandomInt(1, 100) <= floor(dodged_value)
        end

        --闪避回调
        if damage_event_instance.is_dodged then
            --闪避成功
            Damage.__dadged_callbacks:execute(damage_event_instance)
            goto recycle
        end

        --伤害计算前，所有的伤害装饰器应在本次阶段或伤害计算前阶段生效，仅能在此阶段及其之前判定本次伤害无效
        Damage.__precalculate_callbacks:execute(damage_event_instance)
        if not is_sucess then goto recycle end
        --此后的阶段的回调返回false，仅能不执行本阶段内的后续回调，但无法判定伤害无效

        --是否暴击
        local normal_value = damage_value_struct.ATTACK_TYPE_NORMAL
        local skill_value = damage_value_struct.ATTACK_TYPE_SKILL

        if normal_value.DAMAGE_TYPE_PHYSICAL > 0.0 or skill_value.DAMAGE_TYPE_PHYSICAL > 0.0 then
            if damage_event_instance.is_physical_critical == nil then
                damage_event_instance.is_physical_critical = GetRandomInt(1, 100) <= floor(source[ATTR_PHYSICAL_CRITICAL_RATE])
            end
            --计算物理暴击
            if damage_event_instance.is_physical_critical then
                local physical_critical_multiplier = source[ATTR_PHYSICAL_CRITICAL_DAMAGE] / 100.0
                normal_value.DAMAGE_TYPE_PHYSICAL = normal_value.DAMAGE_TYPE_PHYSICAL * physical_critical_multiplier
                skill_value.DAMAGE_TYPE_PHYSICAL = skill_value.DAMAGE_TYPE_PHYSICAL * physical_critical_multiplier
            end
        end

        if normal_value.DAMAGE_TYPE_MAGIC > 0.0 or skill_value.DAMAGE_TYPE_MAGIC > 0.0 then
            if damage_event_instance.is_magic_critical == nil then
                damage_event_instance.is_magic_critical = GetRandomInt(1, 100) <= floor(source[ATTR_MAGIC_CRITICAL_RATE])
            end
            --计算法术暴击
            if damage_event_instance.is_magic_critical then
                local magic_critical_multiplier = source[ATTR_MAGIC_CRITICAL_DAMAGE] / 100.0
                normal_value.DAMAGE_TYPE_MAGIC = normal_value.DAMAGE_TYPE_MAGIC * magic_critical_multiplier
                skill_value.DAMAGE_TYPE_MAGIC = skill_value.DAMAGE_TYPE_MAGIC * magic_critical_multiplier
            end
        end

        --暴击回调
        if damage_event_instance.is_physical_critical or damage_event_instance.is_magic_critical then
            Damage.__critical_callbacks:execute(damage_event_instance)
        end

        --伤害计算阶段，此时无法再通过回调修改伤害值
        local damage_value
        local physical_damage, magic_damage = 0.0, 0.0  --最终应用的伤害值
        local armor, phys_ignore_percent, phys_penetrate, phys_immune_percent, phys_reduction
        local magic_resistance, magic_ignore_percent, magic_penetrate, magic_immune_percent, magic_reduction

        --物理伤害修正
        damage_value = normal_value.DAMAGE_TYPE_PHYSICAL
        if damage_value > 0.0 then
            armor, phys_ignore_percent, phys_penetrate, phys_immune_percent, phys_reduction = getPhysicalAttrForDamageCalculate(source, target)
            damage_value = damageCalculate(damage_value, armor, phys_ignore_percent, phys_penetrate, phys_immune_percent, phys_reduction)
            physical_damage = physical_damage + damage_value
            normal_value.DAMAGE_TYPE_PHYSICAL = damage_value
        end
        damage_value = skill_value.DAMAGE_TYPE_PHYSICAL
        if damage_value > 0.0 then
            if physical_damage <= 0.0 then
                armor, phys_ignore_percent, phys_penetrate, phys_immune_percent, phys_reduction = getPhysicalAttrForDamageCalculate(source, target)
            end
            damage_value = damageCalculate(damage_value, armor, phys_ignore_percent, phys_penetrate, phys_immune_percent, phys_reduction)
            physical_damage = physical_damage + damage_value
            skill_value.DAMAGE_TYPE_PHYSICAL = damage_value
        end

        --法术伤害修正
        damage_value = normal_value.DAMAGE_TYPE_MAGIC
        if damage_value > 0.0 then
            magic_resistance, magic_ignore_percent, magic_penetrate, magic_immune_percent, magic_reduction = getMagicAttrForDamageCalculate(source, target)
            damage_value = damageCalculate(damage_value, magic_resistance, magic_ignore_percent, magic_penetrate, magic_immune_percent, magic_reduction)
            magic_damage = magic_damage + damage_value
            normal_value.DAMAGE_TYPE_MAGIC = damage_value
        end
        damage_value = skill_value.DAMAGE_TYPE_MAGIC
        if damage_value > 0.0 then
            if magic_damage <= 0.0 then
                magic_resistance, magic_ignore_percent, magic_penetrate, magic_immune_percent, magic_reduction = getMagicAttrForDamageCalculate(source, target)
            end
            damage_value = damageCalculate(damage_value, magic_resistance, magic_ignore_percent, magic_penetrate, magic_immune_percent, magic_reduction)
            magic_damage = magic_damage + damage_value
            skill_value.DAMAGE_TYPE_MAGIC = damage_value
        end
        
        --普通攻击回调
        if normal_value.DAMAGE_TYPE_PHYSICAL > 0.0 or normal_value.DAMAGE_TYPE_MAGIC > 0.0 then
            Damage.__normal_attack_callbacks:execute(damage_event_instance)
        end
        --技能攻击回调
        if skill_value.DAMAGE_TYPE_PHYSICAL > 0.0 or skill_value.DAMAGE_TYPE_MAGIC > 0.0 then
            Damage.__skill_attack_callbacks:execute(damage_event_instance)
        end

        --护盾计算
        local shield_value = target[ATTR_SHIELD]
        if shield_value > 0.0 then
            local total_damage = physical_damage + magic_damage
            --护盾抵挡的物理、法术伤害按比例分配
            local physical_shield_reduce = shield_value * physical_damage / total_damage
            local magic_shield_reduce = shield_value - physical_shield_reduce

            if physical_shield_reduce >= physical_damage then
                shield_value = shield_value - physical_damage
                physical_damage = 0.0
            else
                physical_damage = physical_damage - physical_shield_reduce
                shield_value = shield_value - physical_shield_reduce
            end

            if magic_shield_reduce >= magic_damage then
                shield_value = shield_value - magic_damage
                magic_damage = 0.0
            else
                magic_damage = magic_damage - magic_shield_reduce
                shield_value = shield_value - magic_shield_reduce
            end

            target[ATTR_SHIELD] = shield_value
        end

        --伤害结算阶段，默认不是普攻伤害，用来识别Jass伤害事件中是否为普通攻击
        local life_steal_value = 0.0

        if physical_damage > 0.0 then
            --施加伤害
            MHDamage_DamageUnit(source.handle, target.handle, physical_damage, CJ_ATTACK_TYPE_CHAOS, CJ_DAMAGE_TYPE_UNIVERSAL, false, 0)
            --计算吸血
            life_steal_value = physical_damage * source[ATTR_PHYSICAL_VAMP] / 100.0

        end
        if magic_damage > 0.0 then
            --施加伤害
            MHDamage_DamageUnit(source.handle, target.handle, magic_damage, CJ_ATTACK_TYPE_CHAOS, CJ_DAMAGE_TYPE_UNIVERSAL, false, 0)
            --计算吸血
            life_steal_value = life_steal_value + magic_damage * source[ATTR_MAGIC_VAMP] / 100.0
        end

        --施加吸血
        if life_steal_value ~= 0.0 then
            MHUnit_RestoreLife(source.handle, life_steal_value)
        end

        --伤害事件通知，此时已确定造成了伤害，伤害特效可以在此阶段生效，按照对象-类型-任意的流程执行
        Event_execute(damage_event_instance, PROCESS_ROLE_SOURCE, source)
       
        Event_execute(damage_event_instance, PROCESS_ROLE_SOURCE, source.type)

        Event_execute(damage_event_instance, PROCESS_ROLE_TARGET, target)
        Event_execute(damage_event_instance, PROCESS_ROLE_TARGET, target.type)

        --任意事件回调
        Event_execute(damage_event_instance)

        ::recycle::
        damage_event_instance:recycle()
        return is_sucess
    end
})


Damage = {

    --攻击类型: 1.普通攻击 2.技能
    attack_type = {
        ["普通攻击"] = "ATTACK_TYPE_NORMAL",
        ["技能"] = "ATTACK_TYPE_SKILL"
    },

    --伤害类型: 1.物理伤害 2.法术伤害 3.真实伤害
    damage_type = {
        ["物理伤害"] = "DAMAGE_TYPE_PHYSICAL",
        ["法术伤害"] = "DAMAGE_TYPE_MAGIC",
        ["真实伤害"] = "DAMAGE_TYPE_TRUE"
    },

    __value_pool = Queue.new(),

    valueConstructor = function()
        local instance = Damage.__value_pool:popleft()
        if instance then
            local normal = instance.ATTACK_TYPE_NORMAL
            local skill = instance.ATTACK_TYPE_SKILL
            normal.DAMAGE_TYPE_PHYSICAL = 0
            normal.DAMAGE_TYPE_MAGIC = 0
            normal.DAMAGE_TYPE_TRUE = 0
            skill.DAMAGE_TYPE_PHYSICAL = 0
            skill.DAMAGE_TYPE_MAGIC = 0
            skill.DAMAGE_TYPE_TRUE = 0
            instance.total_value = 0
        else
            instance = {
                ATTACK_TYPE_NORMAL = {
                    DAMAGE_TYPE_PHYSICAL = 0,
                    DAMAGE_TYPE_MAGIC = 0,
                    DAMAGE_TYPE_TRUE = 0
                },
                ATTACK_TYPE_SKILL = {
                    DAMAGE_TYPE_PHYSICAL = 0,
                    DAMAGE_TYPE_MAGIC = 0,
                    DAMAGE_TYPE_TRUE = 0
                },
                total_value = 0
            }
        end
        return instance
    end,

    --减伤因子
    REDUCE_FACTOR = 0.005,

    --伤害事件类型
    _event_type = damage_event_type,

    --伤害前阶段回调
    __predamage_callbacks = Event.newProcessCallbackSets(damage_event_type.roles, processExecute),

    --闪避回调
    __dadged_callbacks = Event.newProcessCallbackSets(damage_event_type.roles, processExecute),

    --伤害计算前回调
    __precalculate_callbacks = Event.newProcessCallbackSets(damage_event_type.roles, processExecute),

    --暴击回调
    __critical_callbacks = Event.newProcessCallbackSets(damage_event_type.roles, processExecute),

    --普通攻击回调
    __normal_attack_callbacks = Event.newProcessCallbackSets(damage_event_type.roles, processExecute),

    --技能攻击回调
    __skill_attack_callbacks = Event.newProcessCallbackSets(damage_event_type.roles, processExecute),

    --伤害计算函数
    damageCalculate = damageCalculate,

    --处理伤害
    --@param source table 伤害来源
    --@param target table 伤害目标
    --@param damage_value_struct table 伤害值结构体
    ---@return boolean 是否成功处理
    deal = function (source, target, damage_value_struct)
        if __DEBUG__ then
            assert(DataType.get(source) == "unit", "Damage.deal: source must be a unit, got " .. DataType.get(source))
            assert(DataType.get(target) == "unit", "Damage.deal: target must be a unit, got " .. DataType.get(target))
            assert(type(damage_value_struct) == "table", "Damage.deal: damage_value_struct must be table")
        end
        
        local damage_event_instance = Event.new(damage_event_type, source, target, damage_value_struct, false, false)

        --伤害事件，可用此方法重新触发一遍流程
        local ok = damage_event_instance:emit()

        --回收事件实例
        Event.recycle(damage_event_instance)

        --回收伤害值实例
        Damage.__value_pool:append(damage_value_struct)

        return ok
    end,

    --伤害目标（物理）
    --@param source table 伤害来源
    --@param target table 伤害目标
    --@param is_normal boolean 是否普通攻击
    --@param value number 伤害值
    hitByPhysical = function (source, target, is_normal, value)
        local damage_value_struct = Damage.valueConstructor()
        if is_normal then
            damage_value_struct.ATTACK_TYPE_NORMAL.DAMAGE_TYPE_PHYSICAL = value
        else
            damage_value_struct.ATTACK_TYPE_SKILL.DAMAGE_TYPE_PHYSICAL = value
        end
        Damage.deal(source, target, damage_value_struct)
    end,

    --伤害目标（法术）
    hitByMagic = function (source, target, is_normal, value)
        local damage_value_struct = Damage.valueConstructor()
        if is_normal then
            damage_value_struct.ATTACK_TYPE_NORMAL.DAMAGE_TYPE_MAGIC = value
        else
            damage_value_struct.ATTACK_TYPE_SKILL.DAMAGE_TYPE_MAGIC = value
        end
        Damage.deal(source, target, damage_value_struct)
    end,
    
    --伤害目标（真实）
    hitByTrue = function (source, target, is_normal, value)
        local damage_value_struct = Damage.valueConstructor()
        if is_normal then
            damage_value_struct.ATTACK_TYPE_NORMAL.DAMAGE_TYPE_TRUE = value
        else
            damage_value_struct.ATTACK_TYPE_SKILL.DAMAGE_TYPE_TRUE = value
        end
        Damage.deal(source, target, damage_value_struct)
    end,

    ---@回调重复注册无效

    --注册伤害前回调
    --@param func function 回调函数
    --@param role string 事件角色
    --@param object table 对象实例|对象类型
    ---@return boolean 是否成功添加
    ---@usage Damage.onPredamage(func, "source", unit)
    onPredamage = Damage.__predamage_callbacks.onProcess,

    --移除伤害前回调
    --@param func function 回调函数
    --@param role string 事件角色
    --@param object table 对象实例|对象类型
    ---@return boolean 是否成功移除
    offPredamage = Damage.__predamage_callbacks.offProcess,

    --注册闪避回调
    ---@usage Damage.onDadged(func, "source", unit)
    onDadged = Damage.__dadged_callbacks.onProcess,

    --移除闪避回调
    ---@usage Damage.offDadged(func, "source", unit)
    offDadged = Damage.__dadged_callbacks.offProcess,

    --注册伤害计算前回调
    ---@usage Damage.onPrecalculate(func, "source", unit)
    onPrecalculate = Damage.__precalculate_callbacks.onProcess,

    --移除伤害计算前回调
    ---@usage Damage.offPrecalculate(func, "source", unit)
    offPrecalculate = Damage.__precalculate_callbacks.offProcess,

    --注册暴击回调
    ---@usage Damage.onCritical(func, "source", unit)
    onCritical = Damage.__critical_callbacks.onProcess,

    --移除暴击回调
    ---@usage Damage.offCritical(func, "source", unit)
    offCritical = Damage.__critical_callbacks.offProcess,
    
    --注册普通攻击回调
    ---@usage Damage.onNormalAttack(func, "source", unit)
    onNormalAttack = Damage.__normal_attack_callbacks.onProcess,

    --移除普通攻击回调
    ---@usage Damage.offNormalAttack(func, "source", unit)
    offNormalAttack = Damage.__normal_attack_callbacks.offProcess,

    --注册技能攻击回调
    ---@usage Damage.onSkillAttack(func, "source", unit)
    onSkillAttack = Damage.__skill_attack_callbacks.onProcess,

    --移除技能攻击回调
    ---@usage Damage.offSkillAttack(func, "source", unit)
    offSkillAttack = Damage.__skill_attack_callbacks.offProcess,

    --注册伤害事件回调
    ---@usage Damage.onDamage(func, "source", unit)
    onDamage = function (func, role, object)
        if __DEBUG__ then
            assert(type(func) == "function", "Damage.onDamage: func must be a function")
            assert(type(role) == "string", "Damage.onDamage: role must be a string")
            assert(type(object) == "table", "Damage.onDamage: object must be a table")
        end
        Event.on(damage_event_type, func, role, object)
    end,

    --移除伤害事件回调
    offDamage = function (func, role, object)
        if __DEBUG__ then
            assert(type(func) == "function", "Damage.offDamage: func must be a function")
            assert(type(role) == "string", "Damage.offDamage: role must be a string")
            assert(type(object) == "table", "Damage.offDamage: object must be a table")
        end
        Event.off(damage_event_type, func, role, object)
    end
}

function Damage.has_physical(damage_instance)
    return damage_instance.ATTACK_TYPE_NORMAL.DAMAGE_TYPE_PHYSICAL > 0 or damage_instance.ATTACK_TYPE_SKILL.DAMAGE_TYPE_PHYSICAL > 0
end
function Damage.has_magic(damage_instance)
    return damage_instance.ATTACK_TYPE_NORMAL.DAMAGE_TYPE_MAGIC > 0 or damage_instance.ATTACK_TYPE_SKILL.DAMAGE_TYPE_MAGIC > 0
end
function Damage.has_true(damage_instance)
    return damage_instance.ATTACK_TYPE_NORMAL.DAMAGE_TYPE_TRUE > 0 or damage_instance.ATTACK_TYPE_SKILL.DAMAGE_TYPE_TRUE > 0
end





--用于捕捉普通攻击

local physical_damage_type = Damage.damage_type["物理伤害"]
local magic_damage_type = Damage.damage_type["法术伤害"]
local true_damage_type = Damage.damage_type["真实伤害"]

Jass.MHDamagingEvent_Register(function()
    --是普通攻击造成的
    if MHDamagingEvent_IsPhysical() then
        local source_handle = MHDamagingEvent_GetSource()
        local target_handle = MHEvent_GetUnit()
        local source = Unit_getFromHandle(source_handle)
        local target = Unit_getFromHandle(target_handle)
        local damage_type = source.damage_type
        local value = MHDamagingEvent_GetDamage()

        if damage_type == physical_damage_type then
            Damage.hitByPhysical(source, target, true, value)
        elseif damage_type == magic_damage_type then
            Damage.hitByMagic(source, target, true, value)
        elseif damage_type == true_damage_type then
            Damage.hitByTrue(source, target, true, value)
        end
        return true
    end
    return false
end)


return Damage
