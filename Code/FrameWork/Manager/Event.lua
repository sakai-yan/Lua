local DataType = require "Lib.Base.DataType"
local Class = require "Lib.Base.Class"
local Queue = require "Lib.Base.Queue"
local LinkedList = require "Lib.Base.LinkedList"

local table_insert = table.insert
local table_remove = table.remove

local LinkedList_add = LinkedList.add
local LinkedList_remove = LinkedList.remove
local LinkedList_forEachExecute = LinkedList.forEachExecute

--流程，即简易事件
--添加回调函数的构造器
---@param callbacks_set table 流程回调表
---@return function 添加回调到流程回调表的函数
local function onProcessBuilder(callbacks_set)
    if __DEBUG__ then
        assert(type(callbacks_set) == "table", "Damage.onProcess: callbacks_set must be a table")
    end
    return function (func, role, object)
        if __DEBUG__ then
            assert(type(func) == "function", "Damage.onProcess: func must be a function")
            assert(type(role) == "string", "Damage.onProcess: role must be a string")
            assert(type(object) == "table", "Damage.onProcess: object must be a table")
        end
        local object_callback_list = callbacks_set[role][object]
        if object_callback_list then
            return object_callback_list:add(func, func)
        else
            error("Damage.onProcess: object_callback_list not found")
        end
        return false
    end
end

--移除回调函数的构造器
---@param callbacks_set table 流程回调表
local function offProcessBuilder(callbacks_set)
    if __DEBUG__ then
        assert(type(callbacks_set) == "table", "Damage.offProcess: callbacks_set must be a table")
    end
    return function (func, role, object)
        if __DEBUG__ then
            assert(type(func) == "function", "Damage.offProcess: func must be a function")
            assert(type(role) == "string", "Damage.offProcess: role must be a string")
            assert(type(object) == "table", "Damage.offProcess: object must be a table")
        end
        local object_callback_list = callbacks_set[role][object]
        if object_callback_list then
            return object_callback_list:remove(func)
        else
            error("Damage.offProcess: object_callback_list not found")
        end
        return false
    end
end



local Event
Event = Class("Event", {
    _event_types = {},

    __mode = "kv",
    
    -- ===== 通用构造器（所有无字段事件共享）=====
    __common_constructor = function(event_type)
        return {
            name = event_type.name,
            stage = false,
            type = event_type
        }
    end,
    
    -- ===== 通用初始化器（所有无字段事件共享）=====
    __common_initializer = function(event_type, instance)
        instance.name = event_type.name
        instance.stage = false
        instance.type = event_type
    end,
    
    -- ===== 编译构造器 =====
    __compile_constructor = function(fields)
        -- 无字段：返回共享的通用构造器
        if not fields or #fields == 0 then
            return Event.__common_constructor
        end
        
        -- 有字段：生成特化构造器
        local code = {"return function(event_type"}
        
        for i = 1, #fields do
            code[#code + 1] = ", "
            code[#code + 1] = fields[i]
        end
        
        code[#code + 1] = ") return {name = event_type.name, stage = false, type = event_type"
        
        for i = 1, #fields do
            code[#code + 1] = ", "
            code[#code + 1] = fields[i]
            code[#code + 1] = " = "
            code[#code + 1] = fields[i]
        end
        
        code[#code + 1] = "} end"
        
        local code_str = table.concat(code)
        local func, err = load(code_str, "event_constructor")
        if not func then
            error("Event.__compile_constructor failed: " .. tostring(err))
        end
        
        return func()
    end,
    
    -- ===== 编译初始化器 =====
    __compile_initializer = function(fields)
        -- 无字段：返回共享的通用初始化器
        if not fields or #fields == 0 then
            return Event.__common_initializer
        end
        
        -- 有字段：生成特化初始化器
        local code = {"return function(event_type, instance"}
        
        for i = 1, #fields do
            code[#code + 1] = ", "
            code[#code + 1] = fields[i]
        end
        
        code[#code + 1] = ")\n"
        code[#code + 1] = "  instance.name = event_type.name\n"
        code[#code + 1] = "  instance.type = event_type\n"

        for i = 1, #fields do
            code[#code + 1] = "  instance."
            code[#code + 1] = fields[i]
            code[#code + 1] = " = "
            code[#code + 1] = fields[i]
            code[#code + 1] = "\n"
        end

        code[#code + 1] = "  instance.stage = false\n"
        code[#code + 1] = "end"

        local code_str = table.concat(code)
        local func, err = load(code_str, "event_initializer")
        if not func then
            error("Event.__compile_initializer failed: " .. tostring(err))
        end

        return func()
    end,

    --创建事件实例用法 Event.new(event_type, ...)
    ---@param ... any 事件参数，按照事件定义的fields顺序传入，无则为nil
    __constructor__ = function(class, event_type, ...)
        local event_instance = event_type._pool:popleft()
        
        if event_instance then
            -- 初始化器：(event_type, instance, field1, field2, ...)
            event_type.__initializer(event_type, event_instance, ...)
            return event_instance
        end
        
        -- 构造器：(event_type, field1, field2, ...)
        event_instance = event_type.__constructor(event_type, ...)
        DataType.set(event_instance, "event")
        return event_instance
    end,

    __index__ = function (event_instance, key)
        return event_instance.type[key]
    end,
    
    -- ===== 注册回调 =====
    ---@param event_type table 事件类型
    ---@param callback function 回调函数，参数为事件实例
    ---@param role string|nil 事件角色
    ---@param object table|nil 对象实例|对象类型|nil（任意事件）
    ---@return boolean 是否成功注册
    on = function(event_type, callback, role, object)
        if __DEBUG__ then
            assert(DataType.get(event_type) == "eventtype", "Event.on: event_type must be a eventtype")
            if role then
                assert(type(role) == "string", "Event.on: role must be a string")
                local roles = event_type.roles
                local is_role = false
                for i = 1, #roles do
                    if role == roles[i] then
                        is_role = true
                    end
                end
                assert(is_role == true, "Event.on: role error")
            end
            assert(type(callback) == "function", "Event.on: callback must be a function")
            assert(not object or type(object) == "table", "Event.on: object must be a table")
        end
        
        local object_callback
        --type事件自行实现，这里type也可以为object
        if role and object then
            -- 区分 any 和 type\instance        
            local role_callback_list = event_type[role]
            object_callback = role_callback_list[object]
            if not object_callback then
                object_callback = LinkedList.new()
                role_callback_list[object] = object_callback
            end
        else
            object_callback = event_type._any
        end
        
        return LinkedList_add(object_callback, callback, callback)
    end,
    
    -- ===== 注销回调 =====
    ---@param event_type table 事件类型
    ---@param callback function 回调函数，参数为事件实例
    ---@param role string|nil 事件角色
    ---@param object table|nil 对象实例|对象类型|nil（任意事件）
    ---@return boolean 是否成功注销
    off = function(event_type, callback, role, object)
        if __DEBUG__ then
            assert(DataType.get(event_type) == "eventtype", "Event.on: event_type must be a eventtype")
            if role then
                assert(type(role) == "string", "Event.on: role must be a string")
                local roles = event_type.roles
                local is_role = false
                for i = 1, #roles do
                    if role == roles[i] then
                        is_role = true
                    end
                end
                assert(is_role == true, "Event.on: role error")
            end
            assert(type(callback) == "function", "Event.on: callback must be a function")
            assert(not object or type(object) == "table", "Event.on: object must be a table")
        end

        local object_callback
        --type事件自行实现，这里type也可以为object
        if object and role then
            -- 区分 any 和 type\instance        
            local role_callback_list = event_type[role]
            object_callback = role_callback_list[object]
            if not object_callback then return false end
        else
            object_callback = event_type._any
        end
        
        return LinkedList_remove(object_callback, callback)
    end,
    
    -- 按对象执行回调
    ---@param event_instance table 事件实例
    ---@param role string|nil 事件角色|nil（任意事件）
    ---@param object table|nil 对象实例|对象类型|nil（任意事件）
    ---@return boolean 是否成功触发
    execute = function(event_instance, role, object)
        if __DEBUG__ then
            assert(DataType.get(event_instance) == "event", "Event.emit: event_instance must be a event")
            if role then
                print(role, event_instance.name, type(role))
                assert(type(role) == "string", "Event.emit: role must be a string")
                local roles = Event.getTypeByName(event_instance.name).roles
                if roles then
                    local is_role = false
                    for i = 1, #roles do
                        if role == roles[i] then
                            is_role = true
                        end
                    end
                    assert(is_role == true, "Event.emit: role error")
                end
            end
            assert(not object or type(object) == "table", "Event.emit: object must be a table")
        end

        local event_type = event_instance.type
        if not event_type then
            print("Event.emit: event_type not found")
            return false
        end

        local object_callback
        if object and role and event_type[role] then
            object_callback = event_type[role][object]
        else
            object_callback = event_type._any
        end
        
        return LinkedList_forEachExecute(object_callback, event_instance)
    end,
    
    -- ===== 清除回调 =====
    ---@param event_type table 事件类型
    ---@param object any 清除键
    ---@return boolean 是否成功清除
    clear = function(event_type, role, object)
        if __DEBUG__ then
            assert(DataType.get(event_type) == "eventtype", "Event.clear: event_type must be a eventtype")
        end
        
        local object_callback
        --type事件自行实现，这里type也可以为object
        if role and type(object) == "table" then
            -- 区分 any 和 type\instance        
            local role_callback_list = event_type[role]
            if not role_callback_list then return false end
            role_callback_list[object] = nil
        else
            if __DEBUG__ then
                print("Event.clear: 清除了所有任意事件回调", event_type.name, role, object)
            end
            event_type._any = LinkedList.new()
        end

        return true
    end,
    
    -- ===== 定义事件类型 =====
    ---@param event_config table 事件配置
    --[[
        event_config = {
            fields = {"field1", "field2", "field3"},    --决定事件实例中有哪些字段
            roles = {"role1", "role2", "role3"},        --决定事件中可以按哪些角色进行分发，与field不是强相关
            emit = function(event_instance)
                可选，在这里填写事件的触发完整逻辑，如果不需要，则不填写
            end
        }
    --]]
    eventType = function(event_name, event_config)
        if __DEBUG__ then
            assert(type(event_name) == "string", "Event.eventType: event_name应为字符串")
            assert(type(event_config) == "table", "Event.eventType: event_config应为表")
        end
        
        if not event_name or not event_config then return nil end
        
        local event_type = event_config
        event_type.name = event_name

        local roles = event_type.roles
        --创建事件回调结构

        --任意事件：每次触发事件都会执行
        event_type._any = LinkedList.new()

        --对象事件：针对特定对象类型执行回调
        if roles then
            for index = 1, #roles do
                local role_name = roles[index]
                event_type[role_name] = table.setmode({}, "k")  --role表是按对象存储其回调表，回调表是双向链表，role表是弱键表
                --该结构下，按对象索引，即为：对象作为该角色（字段）时，执行的回调
            end
        end  
        
        local fields = event_type.fields
        event_type.__constructor = Event.__compile_constructor(fields)
        event_type.__initializer = Event.__compile_initializer(fields)
        
        event_type._pool = Queue.new()
        
        Event._event_types[event_name] = event_type
        DataType.set(event_type, "eventtype")
        
        return event_type
    end,
    
    -- ===== 获取事件类型 =====
    ---@param event_name string 事件名
    ---@return table 事件类型
    getTypeByName = function(event_name)
        return Event._event_types[event_name]
    end,

    --创建流程回调表
    newProcessCallbackSets = function(roles, execute_func)
        if __DEBUG__ then
            assert(type(roles) == "table", "Event.newProcessCallbackSets: role must be a string")
            assert(type(execute_func) == "function", "Event.newProcessCallbackSets: execute_func must be a function")
        end
        local callbacks_set = {}
        for index = 1, #roles do
            callbacks_set[roles[index]] = {}
        end
        callbacks_set.execute = execute_func
        callbacks_set.onProcess = onProcessBuilder(callbacks_set)
        callbacks_set.offProcess = offProcessBuilder(callbacks_set)
        return callbacks_set
    end
})

--将事件实例回收到池中
function Event.recycle(event_instance)
    local event_type = Event.getTypeByName(event_instance.name)
    event_type._pool:append(event_instance)
end

return Event
