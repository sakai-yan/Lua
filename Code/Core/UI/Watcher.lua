--[[
================================================================================
                            Watcher 属性变化监听系统

    Watcher 用来监听 frame 某个属性通过 setter 发生变化的时机。
    它的定位更像一个“属性级事件系统”。

    设计目标：
    1. 不侵入业务代码
    2. 只在第一次 watch 某个属性时包装对应 setter
    3. 没有可监听 setter 的属性，watch() 直接失败

    使用场景：
    - 某个 UI 属性变化后联动更新另一个 UI
    - 让数值显示、颜色变化、透明度变化自动同步
================================================================================
--]]

local LinkedList = require "Lib.Base.LinkedList"

local LinkedList_new = LinkedList.new
local LinkedList_add = LinkedList.add
local LinkedList_remove = LinkedList.remove
local LinkedList_forEachExecute = LinkedList.forEachExecute

local Watcher = {}

local _watchers = setmetatable({}, { __mode = "k" })
local _wrapped = setmetatable({}, { __mode = "k" })

--[[
    包装指定 class 的某个 setter
    用途：把“原 setter 调用”升级为“原 setter + watcher 分发”

    为什么这样设计：
    - 包装发生在 class 级别，而不是每个实例都包一层
    - 包装一次后，该 class 的所有实例都能被监听

    返回值：
    - true: 成功包装或已经包装过
    - false: 该属性没有可监听的 setter

    @param class table 目标类
    @param prop_name string 属性名
    @return boolean 是否成功包装
    @usage local ok = wrapSetter(getmetatable(frame), "alpha")
--]]
local function wrapSetter(class, prop_name)
    local class_wrapped = _wrapped[class]
    if class_wrapped and class_wrapped[prop_name] then
        return true
    end

    local setattr_table = class.__setattr__
    if not setattr_table then
        return false
    end

    local original_setter = setattr_table[prop_name]
    if not original_setter then
        return false
    end

    local getattr_table = class.__getattr__
    local getter = getattr_table and getattr_table[prop_name] or nil

    local function wrapped_setter(instance, key, value)
        local instance_watchers = _watchers[instance]
        if instance_watchers then
            local prop_list = instance_watchers[prop_name]
            if prop_list then
                local old_value = getter and getter(instance, key) or nil
                original_setter(instance, key, value)
                LinkedList_forEachExecute(prop_list, instance, value, old_value, prop_name)
                return
            end
        end
        original_setter(instance, key, value)
    end

    setattr_table[prop_name] = wrapped_setter

    if not class_wrapped then
        class_wrapped = {}
        _wrapped[class] = class_wrapped
    end
    class_wrapped[prop_name] = true
    return true
end

--[[
    监听某个属性
    @param frame table 目标 frame
    @param prop_name string 属性名
    @param callback function 回调 function(frame, new_value, old_value, prop_name)
    @return boolean 是否注册成功
    @usage
      Watcher.watch(hp_bar, "alpha", function(frame, new_value, old_value)
          print(old_value, "->", new_value)
      end)
--]]
function Watcher.watch(frame, prop_name, callback)
    if __DEBUG__ then
        assert(type(frame) == "table", "Watcher.watch: frame must be a table")
        assert(type(prop_name) == "string", "Watcher.watch: prop_name must be a string")
        assert(type(callback) == "function", "Watcher.watch: callback must be a function")
    end

    local class = getmetatable(frame)
    if not class then
        return false
    end

    if not wrapSetter(class, prop_name) then
        return false
    end

    local instance_watchers = _watchers[frame]
    if not instance_watchers then
        instance_watchers = {}
        _watchers[frame] = instance_watchers
    end

    local prop_list = instance_watchers[prop_name]
    if not prop_list then
        prop_list = LinkedList_new()
        instance_watchers[prop_name] = prop_list
    end

    return LinkedList_add(prop_list, callback, callback)
end

--[[
    取消一个监听
    @param frame table 目标 frame
    @param prop_name string 属性名
    @param callback function 要移除的回调
    @return boolean 是否移除成功
    @usage Watcher.unwatch(hp_bar, "alpha", my_callback)
--]]
function Watcher.unwatch(frame, prop_name, callback)
    local instance_watchers = _watchers[frame]
    if not instance_watchers then
        return false
    end

    local prop_list = instance_watchers[prop_name]
    if not prop_list then
        return false
    end

    return LinkedList_remove(prop_list, callback)
end

--[[
    清除某个属性的全部监听
    @param frame table 目标 frame
    @param prop_name string 属性名
    @usage Watcher.unwatchAll(hp_bar, "alpha")
--]]
function Watcher.unwatchAll(frame, prop_name)
    local instance_watchers = _watchers[frame]
    if not instance_watchers then
        return
    end
    instance_watchers[prop_name] = nil
end

--[[
    清空某个 frame 的全部监听
    @param frame table 目标 frame
    @usage Watcher.clear(my_frame)
--]]
function Watcher.clear(frame)
    _watchers[frame] = nil
end

return Watcher
