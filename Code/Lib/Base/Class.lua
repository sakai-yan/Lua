--类
local DataType = require "Lib.Base.DataType"
local Set = require "Lib.Base.Set"

local type = type
local rawget = rawget
local rawset = rawset
local setmetatable = setmetatable
local getmetatable = getmetatable

--对外接口
local Class = {}

--类名索引
local _class_by_name = {}
local _modify_field_cache = {}

--[[
================================================================================
                                设计概要（必读）

本库的目标：在 Lua 中提供“类/继承/属性访问器/元类”等能力，同时尽量走快速路径，避免运行时遍历继承链。

核心对象关系：
    1) class（类表）
        - 作为“实例的 metatable”（instance 的 metatable 直接就是 class）。
        - 保存类的元信息：name / __baseclass__ / __subclasses__ / __getattr__/__setattr__ 等。

    2) proxy（类数据代理表，class.__data__）
        - 存储实例可访问的成员与方法（可理解为“原型表”）。
        - class 自身的 __newindex/__index 会把大多数对 class 的读写重定向到 proxy，
          因此写 class.xxx = func 默认是在给“实例方法表(proxy)”加方法。

    3) class_meta（类表的 metatable）
        - 控制“访问 class.xxx 时读/写到哪里”。
        - 当使用 Class.property 声明类属性访问器时，会把 class_meta.__index/__newindex
          切换到 _class_index/_class_newindex 以走 getter/setter。

静态成员与实例成员的区别（维护时最容易踩坑）：
    - 实例成员/方法：写到 proxy（即 class.__data__）里，实例可访问。
    - 静态成员：必须 rawset(class, k, v) 或使用 Class.static(...) 写到 class 本体；实例默认不可访问。
    - 重要细节：Lua 的 __newindex 仅在“key 不存在于表本体”时触发。
      因此 template 里预先写死的字段会永久留在 class 本体（静态/钩子），后续同名赋值也不会进入 proxy。

命名约定（双下划线前后缀 = 用户钩子；单侧/无后缀 = 内部编译结果）：
    - __index / __newindex        : “实例最终使用”的 metamethod（内部生成/重编译）
    - __index__ / __newindex__    : 实例读写回退钩子（用户可选提供）
    - __getattr__/__setattr__   : 实例属性访问器表（name -> getter/setter），由 __attributes__ 或 Class.attribute 生成
    - __getter__/__setter__     : 类属性访问器表（name -> getter/setter），由 Class.property 生成
    - __mode                    : 实例弱引用模式（因为 class 是实例 metatable）
    - __mode__                  : class 表自身弱引用模式（极少用；只影响 class 本体，不影响实例）

destroy 调用约定：
    - 必须支持 instance:destroy()，同时保留 class.destroy(instance) 的可用性。
    - 实现方式：destroy 存放在 proxy 中（见 Class.define 中的 destroy 处理）。
================================================================================
--]]

--- 递归初始化实例（从基类到子类）
--- @param class table 当前类
--- @param instance table 实例对象
--- @param ... any 构造参数
local function _instance_create(class, instance, ...)
    local base = class.__baseclass__
    --如果有基类，且基类有实例初始化函数，先执行基类的实例初始化函数
    if base then
        _instance_create(base, instance, ...)
    end
    --执行类原本的实例初始化函数
    if class.__init__ then
        class.__init__(class, instance, ...)
    end
end

--类构造函数
---@param meta table 类元表
---@param class table 类
local function _class_constructor(meta, class)
    --元类构造链：
    --  - 若 meta 定义了 __newclass__，则由它负责“最终 class 表”的构建/改写；允许返回 nil 阻止创建。
    --  - 否则沿着基类的元类链向上查找，保证父类元类也能影响子类的构建。
    if meta and meta.__newclass__ then
        class = meta.__newclass__(meta, class)
    else
        local baseclass = class.__baseclass__
        if baseclass then
            local base_metaclass = baseclass.__metaclass__
            if base_metaclass then
                class = _class_constructor(base_metaclass, class)
            end
        end
    end
    return class
end

--允许类以函数的形式调用，相当于调用new
---@param class table 类
---@param ... any 构造参数
---@return table 实例
local function _class_call(class, ...)
    return class.new(...)
end

--类的getter访问器
---@param class table 类
---@param key string 属性名
---@return any 属性值
local function _class_index(class, key)
    --仅当 class 开启 Class.property（即 class.__getter__ 存在）时才会被 class_meta.__index 调用。
    --getter 命中则走 getter；否则回退到 proxy（保证 class.xxx 仍可读到实例方法/成员）。
    local getter = class.__getter__[key]
    if getter then
        return getter(class, key)
    end
    return class.__data__[key]
end

--类的setter访问器
---@param class table 类
---@param key string 属性名
---@param value any 属性值
local function _class_newindex(class, key, value)
    --仅当 class 开启 Class.property（即 class.__setter__ 存在）时才会被 class_meta.__newindex 调用。
    --setter 命中则走 setter；否则写入 proxy（等价于添加/修改实例可访问的成员）。
    local setter = class.__setter__[key]
    if setter then
        setter(class, key, value)
    else
        class.__data__[key] = value
    end
end

--[[
================================================================================
                    实例属性访问器生成器（编译时特化 + 子类传播）
    
    设计理念：
    1. 编译时特化：运行时直接查当前类的 __getattr__/__setattr__，无继承链遍历
    2. 子类传播：基类动态添加访问器时，同步传播到所有子类
    3. 子类可覆写：子类定义的访问器优先，不影响基类
    4. 查表法编译：减少条件判断
================================================================================
--]]

--__index 编译器查找表（按 __index__ 类型索引）
--注意：__getattr__ 通过闭包捕获，保证编译时特化
local _index_compilers = {
    --无 __getattr__，无 __index__
    [false] = {
        ["none"] = function(class, proxy)
            return proxy
        end,
        ["function"] = function(class, proxy)
            local __index__ = class.__index__
            return function(instance, key)
                local value = __index__(instance, key)
                if value ~= nil then
                    return value
                end
                return proxy[key]
            end
        end,
        ["table"] = function(class, proxy)
            local __index__ = class.__index__
            return function(instance, key)
                local value = __index__[key]
                if value ~= nil then
                    return value
                end
                return proxy[key]
            end
        end,
    },
    --有 __getattr__
    [true] = {
        ["none"] = function(class, proxy)
            local __getattr__ = class.__getattr__
            return function(instance, key)
                local getter = __getattr__[key]
                if getter then
                    return getter(instance, key)
                end
                return proxy[key]
            end
        end,
        ["function"] = function(class, proxy)
            local __getattr__ = class.__getattr__
            local __index__ = class.__index__
            return function(instance, key)
                local getter = __getattr__[key]
                if getter then
                    return getter(instance, key)
                end
                local value = __index__(instance, key)
                if value ~= nil then
                    return value
                end
                return proxy[key]
            end
        end,
        ["table"] = function(class, proxy)
            local __getattr__ = class.__getattr__
            local __index__ = class.__index__
            return function(instance, key)
                local getter = __getattr__[key]
                if getter then
                    return getter(instance, key)
                end
                local value = __index__[key]
                if value ~= nil then
                    return value
                end
                return proxy[key]
            end
        end,
    },
}

--为类生成特化的__index处理
---@param class table 类
---@param proxy table 类数据代理表
---@return function|table 特化的__index
local function _compile_instance_index(class, proxy)
    --__index__（尾随双下划线）是“实例索引回退钩子”（可选）：function 或 table。
    --本函数生成的是 class.__index（实例最终使用的 metamethod），尽量在“编译期”做分派，运行期少判断。
    --如果后续通过 Class.attribute 动态修改了 __getattr__/__setattr__，会触发重编译该 metamethod。
    local __index__ = class.__index__
    local index_type = type(__index__)
    --空表等价于“没有 getattr”，避免无意义的 getter 分派开销
    local getattr = class.__getattr__
    local has_getattr = type(getattr) == "table" and next(getattr) ~= nil
    --确定编译器类型
    local type_key = (index_type == "function" or index_type == "table") and index_type or "none"
    return _index_compilers[has_getattr][type_key](class, proxy)
end

--__newindex 编译器查找表
local _newindex_compilers = {
    --无 __setattr__
    [false] = {
        ["none"] = function(class)
            return nil  --使用默认 rawset
        end,
        ["function"] = function(class)
            return class.__newindex__
        end,
    },
    --有 __setattr__
    [true] = {
        ["none"] = function(class)
            local __setattr__ = class.__setattr__
            return function(instance, key, value)
                local setter = __setattr__[key]
                if setter then
                    setter(instance, key, value)
                else
                    rawset(instance, key, value)
                end
            end
        end,
        ["function"] = function(class)
            local __setattr__ = class.__setattr__
            local __newindex__ = class.__newindex__
            return function(instance, key, value)
                local setter = __setattr__[key]
                if setter then
                    setter(instance, key, value)
                else
                    __newindex__(instance, key, value)
                end
            end
        end,
    },
}

--为类生成特化的__newindex处理
---@param class table 类
---@return function|nil 特化的__newindex
local function _compile_instance_newindex(class)
    --__newindex__（尾随双下划线）是“实例赋值回退钩子”（可选）：function。
    --本函数生成的是 class.__newindex（实例最终使用的 metamethod），用于把 setter 分派与回退逻辑固定下来。
    local __newindex__ = class.__newindex__
    local newindex_type = type(__newindex__)
    --空表等价于“没有 setattr”，避免无意义的 setter 分派开销
    local setattr = class.__setattr__
    local has_setattr = type(setattr) == "table" and next(setattr) ~= nil
    --确定编译器类型
    local type_key = (newindex_type == "function") and "function" or "none"
    return _newindex_compilers[has_setattr][type_key](class)
end


local _instance_gc
if __DEBUG__ then
    --实例未调用destroy时，gc警告，调试用
    --注意：标准 Lua 中 __gc 主要用于 userdata；若宿主不支持 table finalizer，本检查可能不会触发。
    ---@param instance table 实例
    _instance_gc = function(instance)
        if instance.__destroyed ~= true then
            local class = getmetatable(instance)
            error("Instance not destroyed: " .. class.name)
        end
    end
end

--删除实例通用办法
---@param instance table 实例
local function _instance_destroy(instance)
    --统一销毁入口：
    --  - 通过 instance.__destroyed 防重入
    --  - 按“子类 -> 基类”的顺序调用各层 __del__（便于子类先释放资源）
    --  - 最后清空 metatable，避免被继续当作合法实例使用
    local class = getmetatable(instance)
    if instance.__destroyed == true then return end
    instance.__destroyed = true
    --遍历实例的基类链，调用__del__方法，先子类后基类
    while class do
        local destroy_func = class.__del__
        if destroy_func then
            destroy_func(class, instance)
        end
        class = class.__baseclass__
    end
    setmetatable(instance, nil)
end

--[[
================================================================================
                    实例属性访问器传播（健壮性补丁）

问题背景：
    基类可能在“子类已经创建完成之后”，才通过 Class.attribute 动态追加访问器。
    这时某些子类可能尚未拥有 __setattr__/__getattr__/__attributes__，原实现会直接索引 nil 报错，
    且不维护 __attributes__ 会导致后续“孙类创建时的继承拷贝”遗漏访问器。

策略：
    1) 按需初始化子类的 __setattr__/__getattr__/__attributes__
    2) 仅当确实发生变更时才触发重编译与递归传播（保持低消耗）
================================================================================
--]]

--将实例属性访问器传播到某个子类
---@param subclass table 子类
---@param propagate_table table 实例属性访问器表数组
---@param is_replace boolean|nil 是否覆盖旧的实例属性访问器
---@return boolean need_recompile 是否进行了重新编译
local function _attrToSubClassFromBase(subclass, propagate_table, is_replace)
    --propagate_table 结构（由 _attrFromTableArray 生成，仅包含“本次确实发生变更”的属性）：
    --  {
    --      {
    --          name = "hp",
    --          old_setattr = <function|nil>,  --变更前：基类对此属性的 setter（用于判断子类是否覆写）
    --          old_getattr = <function|nil>,  --变更前：基类对此属性的 getter（用于判断子类是否覆写）
    --          new_setattr = <function|nil>,  --变更后：基类的新 setter
    --          new_getattr = <function|nil>,  --变更后：基类的新 getter
    --      },
    --      ...
    --  }
    --覆写/继承判定规则（关键）：
    --  - 子类当前 accessor == old_accessor：认为“仍在继承基类旧实现”，应更新为 new_accessor
    --  - 子类当前 accessor == nil：认为“子类未定义该 accessor”，应继承基类新实现
    --  - 否则：认为子类已覆写，默认不覆盖（除非 is_replace=true）
    --这样可以保证：基类动态变更能下发到未覆写的分支，同时不破坏子类自定义逻辑。
    local need_recompile = false

    local sub_setattr = type(subclass.__setattr__) == "table" and subclass.__setattr__ or nil
    local sub_getattr = type(subclass.__getattr__) == "table" and subclass.__getattr__ or nil
    local sub_attributes = subclass.__attributes__

    local attr_count = #propagate_table
    for index = 1, attr_count do
        local attribute_config = propagate_table[index]
        local attribute_name = attribute_config.name
        local old_setter = attribute_config.old_setattr
        local old_getter = attribute_config.old_getattr
        local new_setter = attribute_config.new_setattr
        local new_getter = attribute_config.new_getattr
        local changed = false

        --setter：仅当子类未覆写（nil 或仍等于 old）时更新到 new
        local cur_setter = sub_setattr and sub_setattr[attribute_name] or nil
        if new_setter and (cur_setter == old_setter or cur_setter == nil or is_replace) then
            if not sub_setattr then
                --延迟创建：只有确实需要写入 accessor 时才创建表，减少内存占用
                sub_setattr = {}
                subclass.__setattr__ = sub_setattr
            end
            sub_setattr[attribute_name] = new_setter
            need_recompile = true
            changed = true
        end

        --getter：规则同 setter
        local cur_getter = sub_getattr and sub_getattr[attribute_name] or nil
        if new_getter and (cur_getter == old_getter or cur_getter == nil or is_replace) then
            if not sub_getattr then
                --延迟创建：只有确实需要写入 accessor 时才创建表，减少内存占用
                sub_getattr = {}
                subclass.__getattr__ = sub_getattr
            end
            sub_getattr[attribute_name] = new_getter
            need_recompile = true
            changed = true
        end

        --维护 attributes 列表，保证后续继承拷贝（_attrFromClass）不丢访问器
        if changed then
            if not sub_attributes then
                --__attributes__ 在“类创建阶段”可为声明数组；创建完成后会被转成 Set（属性名列表）。
                --这里动态追加时，直接确保它是 Set，以便：
                --  1) 未来新建孙类时能从该子类正确继承（_attrFromClass 依赖它）
                --  2) Set.has 可 O(1) 判重
                sub_attributes = Set.new()
                subclass.__attributes__ = sub_attributes
            end
            Set.add(sub_attributes, attribute_name)
        end
    end

    --重编译子类访问器
    if need_recompile then
        --重要：实例 __index/__newindex 是“编译产物”，会根据是否存在 __getattr__/__setattr__ 选择不同快速路径。
        --当我们在传播过程中“首次创建了 __getattr__/__setattr__ 表”或修改了回退钩子类型时，必须重编译。
        --（即使仅更新了表内函数引用，重编译也能保持实现一致性，代价可接受且传播频率通常不高。）
        rawset(subclass, "__index", _compile_instance_index(subclass, subclass.__data__))
        rawset(subclass, "__newindex", _compile_instance_newindex(subclass))
    end

    return need_recompile
end

--将实例属性访问器传播到所有子类及其孙类，以此类推
---@param subclasses table[] 子类列表
---@param propagate_table table 实例属性访问器表数组
local function propagateToSubClasses(subclasses, propagate_table)
    if type(subclasses) ~= "table" then return end

    --这里使用 pairs 而非 #subclasses 的数组遍历：
    --  - __subclasses__ 使用弱表存储，理论上可能产生空洞；Lua 对带空洞数组的 # 运算结果是不确定的。
    --  - 传播发生频率通常较低（多为初始化/热更新阶段），因此优先保证正确性与健壮性。
    for _, subclass in pairs(subclasses) do
        if subclass then
            local need_recompile = _attrToSubClassFromBase(subclass, propagate_table)
            if need_recompile then
                --传播剪枝（性能关键）：
                --  - 若当前 subclass 没有被更新，通常意味着“它已覆写该属性”或“本次变更与它无关”。
                --  - 在这种情况下，它的子树也不应继承基类的新实现，因此无需继续递归。
                --这能显著减少大量类层级时的传播开销。
                local sub_subclasses = subclass.__subclasses__
                if type(sub_subclasses) == "table" and next(sub_subclasses) ~= nil then
                    propagateToSubClasses(sub_subclasses, propagate_table)
                end
            end
        end
    end
end

---@从符合Class.attribute规范的表数组中提取实例属性访问器（可覆盖）
---@param class table 类
---@param attr_table_array table 符合Class.attribute规范的表数组
---@return table propagate_table 成功替换了的实例属性访问器表数组
local function _attrFromTableArray(class, attr_table_array, is_replace) 
    --用途：把“声明式 attributes 配置”编译进 class：
    --  - 生成/更新 class.__setattr__/class.__getattr__（name -> setter/getter）
    --  - 维护 class.__attributes__（Set：属性名列表，用于快速判重 + 继承拷贝 + 动态传播）
    --返回 propagate_table：记录本次确实发生变更的属性及其 old/new，用于向子类传播并触发最小化重编译。
    local getattr_table = type(class.__getattr__) == "table" and class.__getattr__ or {}
    local setattr_table = type(class.__setattr__) == "table" and class.__setattr__ or {}
    local attributes = class.__attributes__ or Set.new()
    local is_add_attr = false

    local propagate_table = {}

    for index = 1, #attr_table_array do
        local attr = attr_table_array[index]
        local attribute_name = attr.name
        --如果属性不存在，或者允许覆写
        if not Set.has(attributes, attribute_name) or is_replace then
            local old_setattr = setattr_table[attribute_name]
            local old_getattr = getattr_table[attribute_name]
            local new_setattr, new_getattr = nil, nil
            
            if type(attr.set) == "function" then
                setattr_table[attribute_name] = attr.set
                is_add_attr = true
                new_setattr = setattr_table[attribute_name]
            end
    
            if type(attr.get) == "function" then
                getattr_table[attribute_name] = attr.get
                is_add_attr = true
                new_getattr = getattr_table[attribute_name]
            end
    
            if is_add_attr then
                Set.add(attributes, attribute_name)
                is_add_attr = false
                propagate_table[#propagate_table + 1] = {
                    name = attribute_name,
                    old_setattr = old_setattr,    --旧setter
                    old_getattr = old_getattr,    --旧getter
                    new_setattr = new_setattr,    --新setter
                    new_getattr = new_getattr     --新getter
                }
            end
        end
    end

    --只需要防止0属性的class创建空__attribute__
    if Set.len(attributes) > 0 then
        class.__attributes__ = attributes
        class.__setattr__ = setattr_table
        class.__getattr__ = getattr_table
    end

    return propagate_table
end

---@从class中复制实例属性访问器（可覆盖）
---@param class table 类
---@param target_class table 目标类
---@return table class 类
local function _attrFromClass(class, target_class, is_replace) 
    --用途：把基类已存在的实例属性访问器（__setattr__/__getattr__）拷贝到子类，
    --并同步维护子类的 __attributes__，使“子类创建时”就拥有完整访问器（且可在子类覆写）。
    --注意：继承判定与“动态传播”一致——子类未提供某个 accessor（nil）才会继承基类实现；
    --若想“禁用/只读”某个可写属性，请显式提供一个 setter（例如报错或空实现），而非省略。
    local target_attributes = target_class.__attributes__
    if not target_attributes then return class end
    if __DEBUG__ then
        assert(type(target_attributes) == "table", "Class._attrFromClass: target_attributes must be a table")
    end

    local target_setter_table = type(target_class.__setattr__) == "table" and target_class.__setattr__ or nil
    local target_getter_table = type(target_class.__getattr__) == "table" and target_class.__getattr__ or nil
    local getter_table = type(class.__getattr__) == "table" and class.__getattr__ or nil
    local setter_table = type(class.__setattr__) == "table" and class.__setattr__ or nil
    local attributes = type(class.__attributes__) == "table" and class.__attributes__ or nil
    local modified = false

    for index = 1, Set.len(target_attributes) do
        local attribute_name = target_attributes[index]
        local changed = false

        --setter：仅当子类未定义该 setter（nil）时才继承；允许 is_replace 强制覆盖
        local target_setter = target_setter_table and target_setter_table[attribute_name] or nil
        if type(target_setter) == "function" then
            local cur_setter = setter_table and setter_table[attribute_name] or nil
            if cur_setter == nil or is_replace then
                if not setter_table then
                    setter_table = {}
                end
                setter_table[attribute_name] = target_setter
                changed = true
            end
        end

        --getter：规则同 setter，避免基类 getter 覆盖子类 getter（继承应是“补全缺失”，而非“无条件覆盖”）
        local target_getter = target_getter_table and target_getter_table[attribute_name] or nil
        if type(target_getter) == "function" then
            local cur_getter = getter_table and getter_table[attribute_name] or nil
            if cur_getter == nil or is_replace then
                if not getter_table then
                    getter_table = {}
                end
                getter_table[attribute_name] = target_getter
                changed = true
            end
        end

        if changed then
            if not attributes then
                attributes = Set.new()
            end
            Set.add(attributes, attribute_name)
            modified = true
        end
    end

    if modified then
        class.__attributes__ = attributes
        if setter_table then
            class.__setattr__ = setter_table
        end
        if getter_table then
            class.__getattr__ = getter_table
        end
    end
    
    return class
end

--[[
================================================================================
                                template 配置说明
================================================================================
说明：
    - template 是“类的静态区 + 钩子配置区”，用于声明 __init__/__del__/__attributes__/__index__ 等行为。
    - 真正让实例可访问的成员/方法默认存放在 proxy（class.__data__）中；可在类创建后用 `ClassName.xxx = ...`
      的方式添加（当 xxx 在 class 本体不存在时，会通过 __newindex 写入 proxy）。
    - __index/__newindex（不带尾随双下划线）为库生成的实例 metamethod，请勿在 template 中手动设置。
class = {
    name              --类名（自动设置，无需手动指定）
    new               --新建实例函数（自动生成，可自定义覆盖）
    destroy           --显式销毁实例,以instance为参数调用（自动生成，可自定义覆盖）
    
    __constructor__   --在不设置metaclass的情况下的实例构造器，以(class, ...)为参数调用
    __init__          --实例初始化函数，以(class, instance, ...)为参数调用，此时已具有实例的所有特性，比如attribute
    __newclass__      --作为元类时的类构造函数，以(meta, class)为参数调用
    __newinstance__   --实例构造函数，以(meta, class, ...)为参数调用，返回instance表
    __index__         --实例索引回退（function或table）
    __newindex__      --实例赋值回退（function）
    __attributes__    --类的实例属性访问器字段列表，定义时{{name = string, set = function, get = function}, ...}，类创建后变为属性名列表（Set）
    __setter__        --类属性setter修饰器表
    __getter__        --类属性getter修饰器表
    __setattr__       --实例属性setter修饰器表（混合表：[name]=func, [1..n]=name列表）
    __getattr__       --实例属性getter修饰器表（混合表：[name]=func, [1..n]=name列表）
    __metaclass__     --元类
    __baseclass__     --基类
    __subclasses__    --子类数组（自动维护，用于动态访问器传播）
    __abstract__      --是否为抽象类（抽象类不能直接实例化）
    __mode__          --class 自身弱引用模式："k"、"v"、"kv"（仅影响 class 本体，不影响实例）
    __del__           --实例销毁函数，以(class, instance)为参数调用
    __data__          --类数据代理表（自动生成，存储类成员和方法）

    __mode            --实例弱引用模式："k"、"v"、"kv"（因为 class 是实例 metatable）
}
--]]

--[[
================================================================================
                                Class.define
                                  定义类
================================================================================
--]]

---定义一个新类
---@param class_name string 类名
---@param template? table 类模板配置（静态区/钩子区）；实例可访问成员通常在定义后写入 proxy(class.__data__)
---@return table|nil class 创建的类，如果创建失败返回nil
function Class.define(class_name, template)
    --调试模式下的参数检查
    if __DEBUG__ then
        assert(type(class_name) == "string", "Class.define: class_name must be a string")
        if template then
            assert(type(template) == "table", "Class.define: template must be a table")
            assert(not template.name, "Class.define: template.name must not be set")
            assert(not template.__baseclass__ or DataType.get(template.__baseclass__) == "class", 
                   "Class.define: __baseclass__ must be a class")
            assert(not template.__metaclass__ or DataType.get(template.__metaclass__) == "class", 
                   "Class.define: __metaclass__ must be a class")
            --调试用：为实例设置 finalizer（若宿主支持 table.__gc），用于提示未 destroy 的实例
            template.__gc = _instance_gc
        end
    end

    if _class_by_name[class_name] then error("Class.define: class_name '" .. class_name .. "' already exists") end

    --存储类实际数据的代理表
    local proxy = {}
    
    --初始化类表
    local class = template or {name = false}

    local meta, __newinstance_method

    --如果有元类，则使用元类的构造函数构建类
    meta = class.__metaclass__
    if meta then
        class = _class_constructor(meta, class)
        --可在__newclass__返回nil阻止class创建
        if not class then return nil end
        
        --如果元类定义了__newinstance__，则使用它创建实例
        __newinstance_method = meta.__newinstance__
    end

    class.name = class_name
    class.__data__ = proxy

    --设置类的数据类型标记
    DataType.set(class, "class")

    --注册类名索引
    _class_by_name[class_name] = class

    --如果是抽象类，则跳过创建、销毁实例的方法生成
    if class.__abstract__ == true then 
        class.new = nil
        class.destroy = nil
        goto construct_method_end
    end

    --destroy 约定：必须可被实例调用（instance:destroy()）
    --实现方式：将 destroy 存放在 proxy（实例访问的成员表）上，同时通过 class_meta.__index 让 class.destroy(instance) 依然可用
    if type(class.destroy) ~= "function" then
        proxy.destroy = _instance_destroy
    else
        proxy.destroy = class.destroy
    end
    class.destroy = nil

    if type(class.new) == "function" then goto construct_method_end end

    if type(__newinstance_method) == "function" then
        class.new = function(...)
            local instance = __newinstance_method(meta, class, ...) or {}
            setmetatable(instance, class)
            _instance_create(class, instance, ...)
            return instance
        end
    elseif type(class.__constructor__) == "function" then
        __newinstance_method = class.__constructor__
        class.new = function(...)
            local instance = __newinstance_method(class, ...) or {}
            setmetatable(instance, class)
            _instance_create(class, instance, ...)
            return instance
        end
    else
        --如果无实例构造函数，则创建默认的new方法
        class.new = function(...)
            local instance = {}
            setmetatable(instance, class)
            _instance_create(class, instance, ...)
            return instance
        end
    end

    --仅跳过创建new方法和destroy方法，保留setattr、getattr，因为有的抽象类作为基类需要将实例属性传递到子类
    ::construct_method_end::

    --建立__setattr__和__getattr__
    if class.__attributes__ then
        local attr_table_array = class.__attributes__
        class.__attributes__ = nil
        _attrFromTableArray(class, attr_table_array)
    end

    --处理继承关系 
    local base = class.__baseclass__
    if base then     
        --proxy 原型链继承：
        --  - 让 proxy 缺失字段时回退到 base.__data__，从而实现“实例方法/成员”的继承
        --  - 使用 setmetatable(proxy, proxy) 是一种省表写法：metatable 就是 proxy 自身，__index 域指向父 proxy
        --  - 注意：proxy.__index 为内部保留字段，请勿用作业务成员名
        proxy.__index = base.__data__
        setmetatable(proxy, proxy)
        --注册到基类的子类列表（用于动态访问器传播）
        local base_subclasses = base.__subclasses__
        if not base_subclasses then
            base_subclasses = table.setmode({}, "kv")
            base.__subclasses__ = base_subclasses
        end
        base_subclasses[#base_subclasses + 1] = class
        
        --从基类继承实例属性访问器
        _attrFromClass(class, base)
    end

    --编译时生成特化的实例访问器（在继承处理之后，只编译一次）
    rawset(class, "__index", _compile_instance_index(class, proxy))
    rawset(class, "__newindex", _compile_instance_newindex(class))

    
    --设置类的元表，将数据存储重定向至proxy
    --class_meta 的职责：把“对 class 的读/写”重定向到 proxy（默认）或 getter/setter（当启用 Class.property 时）。
    --这样可以实现：ClassName.foo = function(...) end 直接变成实例可访问的方法（写入 proxy），减少样板代码。
    local class_meta = {
        __newindex = type(class.__setter__) == "table" and _class_newindex or proxy,
        __index = type(class.__getter__) == "table" and _class_index or proxy,
        __call = class.new and _class_call or nil,        --抽象类不允许新建实例
        __mode = class.__mode__
    }
    setmetatable(class, class_meta)
    
    return class
end

--[[
================================================================================
                                Class 辅助方法
================================================================================
--]]

---从类名获取类
---@param class_name string 类名
---@return table|nil class 找到的类，否则返回nil
function Class.get(class_name)
    if class_name then
        return _class_by_name[class_name]
    end
    return nil
end

---获取基类
---@param class table|string 类或类名
---@return table|nil baseclass 基类，否则返回nil
function Class.base(class)
    if type(class) == "string" then
        class = _class_by_name[class]
    end
    if DataType.get(class) ~= "class" then
        return nil
    end
    return class.__baseclass__
end

---获取元类
---@param class table|string 类或类名
---@return table|nil metaclass 元类，否则返回nil
function Class.meta(class)
    if type(class) == "string" then
        class = _class_by_name[class]
    end
    if DataType.get(class) ~= "class" then
        return nil
    end
    return class.__metaclass__
end

---检查实例是否属于某个类（或其子类）
---@param instance table 实例
---@param class table|string 类或类名
---@return boolean 是否为该类的实例
function Class.instanceof(instance, class)
    if type(instance) ~= "table" then
        return false
    end
    if type(class) == "string" then
        class = _class_by_name[class]
    end
    if not class then
        return false
    end
    
    local mt = getmetatable(instance)
    while mt do
        if mt == class then
            return true
        end
        mt = mt.__baseclass__
    end
    return false
end

---检查一个类是否是另一个类的子类
---@param subclass table|string 子类或类名
---@param superclass table|string 父类或类名
---@return boolean 是否为子类
function Class.issubclass(subclass, superclass)
    if type(subclass) == "string" then
        subclass = _class_by_name[subclass]
    end
    if type(superclass) == "string" then
        superclass = _class_by_name[superclass]
    end
    if not subclass or not superclass then
        return false
    end
    if DataType.get(subclass) ~= "class" or DataType.get(superclass) ~= "class" then
        return false
    end
    
    local current = subclass
    while current do
        if current == superclass then
            return true
        end
        current = current.__baseclass__
    end
    return false
end

---获取类的继承链（方法解析顺序）
---@param class table|string 类或类名
---@return table mro 继承链数组，从当前类到最顶层基类
function Class.mro(class)
    if type(class) == "string" then
        class = _class_by_name[class]
    end
    if DataType.get(class) ~= "class" then
        return {}
    end
    
    local result = {}
    local current = class
    while current do
        result[#result + 1] = current
        current = current.__baseclass__
    end
    return result
end

--[[
================================================================================
                                Class.property
                              动态添加类属性访问器
================================================================================
--]]

---为类添加属性访问器（类级别）
---@param class table 类
---@param property_name string 属性名
---@param template table 属性配置 {__setter__ = function, __getter__ = function}
---@return table class 类本身，用于链式调用
function Class.property(class, property_name, template)
    if __DEBUG__ then
        assert(DataType.get(class) == "class", "Class.property: class必须为类")
        assert(type(property_name) == "string", "Class.property: property_name必须为字符串")
        assert(type(template) == "table", "Class.property: template必须为表")
        assert(not class.__setter__ or not class.__setter__[property_name], "Class.property: 该property_name已被设置过" .. property_name)
        assert(not class.__getter__ or not class.__getter__[property_name], "Class.property: 该property_name已被设置过" .. property_name)
    end
   

    local modified = false
    local class_meta = getmetatable(class)

    if type(template.__setter__) == "function" then
        if type(class.__setter__) ~= "table" then
            class.__setter__ = {}
            class_meta.__newindex = _class_newindex
        end
        class.__setter__[property_name] = template.__setter__
        modified = true
    end

    if type(template.__getter__) == "function" then
        if type(class.__getter__) ~= "table" then
            class.__getter__ = {}
            class_meta.__index = _class_index
        end
        class.__getter__[property_name] = template.__getter__
        modified = true
    end

    --清除可能存在的旧值
    if modified and rawget(class, property_name) ~= nil then
        rawset(class, property_name, nil)
    end

    return class
end

--[[
================================================================================
                                Class.attribute
                              动态添加实例属性访问器
================================================================================
--]]
---为类的实例动态添加属性访问器
---@param class table 类
---@param templates table 属性配置表数组 {{name = string, set = function, get = function}, {...}, ...}
---@return table class 类本身，用于链式调用
function Class.attribute(class, templates)
    if __DEBUG__ then
        assert(DataType.get(class) == "class", "Class.attribute: class必须为类")
        assert(type(templates) == "table", "Class.attribute: templates必须为表")
    end

    --注意：这里对当前 class 采用“允许覆写”(is_replace=true) 的策略，方便热更新/重定义 getter/setter。
    --对子类传播时会通过 old_* 对比来保护子类覆写，不会无条件覆盖子类自定义实现。
    local propagate_table = _attrFromTableArray(class, templates, true)

    if #propagate_table > 0 then
        --propagate_table 非空表示当前 class 的访问器确实发生了变化：
        --  1) 需要重编译本类实例的 __index/__newindex（快速路径选择依赖 __getattr__/__setattr__ 是否存在）
        --  2) 需要把变化向子类传播（只更新“未覆写”的分支）
        rawset(class, "__index", _compile_instance_index(class, class.__data__))
        rawset(class, "__newindex", _compile_instance_newindex(class))

        --传播到子类及其孙类……
        local subclasses = class.__subclasses__
        --__subclasses__ 使用弱表，可能产生空洞；不要依赖 #subclasses
        if type(subclasses) == "table" and next(subclasses) ~= nil then
            propagateToSubClasses(subclasses, propagate_table)
        end
    end

    return class
end

--[[
================================================================================
                                Class.static
                    添加静态成员（存储在class中，实例不可访问）
================================================================================

设计说明：
    静态成员存储在 class 表本身，而非 proxy 表
    由于实例的 __index 指向 proxy，所以实例无法访问静态成员
    
    特殊属性（__index__, __newindex__）修改后会触发重编译

用法：
    -- 用法1：添加单个静态成员
    Class.static(MyClass, "getInstance", function(class) return class._instance end)
    
    -- 用法2：批量添加静态成员
    Class.static(MyClass, {
        getInstance = function(class) return class._instance end,
        MAX_COUNT = 100,
        __index__ = function(instance, key) ... end,  -- 特殊属性
        __newindex__ = function(instance, key, value) ... end
    })
--]]

local function _is_special_static_hook_name(name)
    return name == "__index__" or name == "__newindex__"
end

---添加静态成员到类（实例不可访问）
---@param class table 类
---@param name_or_template string|table 成员名或批量配置表
---@param value? any 成员值（当第二参数为string时）
---@return table class 类本身，用于链式调用
function Class.static(class, name_or_template, value)
    if __DEBUG__ then
        assert(DataType.get(class) == "class", "Class.static: class必须为类")
        if type(name_or_template) == "string" then
            assert(
                _is_special_static_hook_name(name_or_template) or rawget(class, name_or_template) == nil,
                "Class.static: 该成员已被设置过"
            )
        elseif type(name_or_template) == "table" then
            for name, _ in pairs(name_or_template) do
                assert(
                    _is_special_static_hook_name(name) or rawget(class, name) == nil,
                    "Class.static: 该成员已被设置过"
                )
            end
        end
    end
    
    local need_recompile = false
    
    --用法1：单个成员 Class.static(class, "name", value)
    if type(name_or_template) == "string" then
        local name = name_or_template
        
        --特殊属性需要重编译
        if name == "__index__" then
            local vtype = type(value)
            if vtype == "function" or vtype == "table" then
                class.__index__ = value
                need_recompile = true
            end
        elseif name == "__newindex__" then
            if type(value) == "function" then
                class.__newindex__ = value
                need_recompile = true
            end
        else
            --普通静态成员，直接存储在class表中
            rawset(class, name, value)
        end
        
    --用法2：批量成员 Class.static(class, { name = value, ... })
    elseif type(name_or_template) == "table" then
        local template = name_or_template
        
        for name, val in pairs(template) do
            if name == "__index__" then
                local vtype = type(val)
                if vtype == "function" or vtype == "table" then
                    class.__index__ = val
                    need_recompile = true
                end
            elseif name == "__newindex__" then
                if type(val) == "function" then
                    class.__newindex__ = val
                    need_recompile = true
                end
            else
                --普通静态成员
                rawset(class, name, val)
            end
        end
    end
    
    --如果修改了特殊属性，重新编译访问器
    if need_recompile then
        rawset(class, "__index", _compile_instance_index(class, class.__data__))
        rawset(class, "__newindex", _compile_instance_newindex(class))
    end
    
    return class
end

--创建修饰字段名
---@param field string 字段名
---@return string 修饰字段名
function Class.modify_field(field)
    if __DEBUG__ then
        assert(type(field) == "string", "Class.modify_field: field must be a string")
    end

    local modify_field = _modify_field_cache[field]
    if modify_field == nil then
        modify_field = "__modify" .. field
        _modify_field_cache[field] = modify_field
    end
    return modify_field
end

--获取类的属性名列表
function Class.getAttributeNames(class)
    local class_attributes = class.__attributes__
    if class_attributes then
        local attributes = {}
        for index = 1, #class_attributes do
            attributes[index] = class_attributes[index]
        end
        return attributes
    end
    return nil
end

--[[
================================================================================
                                Module Export
================================================================================
--]]

--允许使用Class(class_name, template)创建类
setmetatable(Class, {
    __call = function(_, class_name, template)
        return Class.define(class_name, template)
    end
})

return Class
