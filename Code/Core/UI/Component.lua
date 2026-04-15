local Class = require "Lib.Base.Class"
local Frame = require "Core.UI.Frame"
local Style = require "Core.UI.Style"
local Theme = require "Core.UI.Theme"

local Component = {}

local types = {}

--用于缓存UI类，避免重复获取
local classes_cache = table.setmode({}, "kv") or {}

function Component.define(type_name, config)
    if type(config) ~= "table" or type(config.class) ~= "function" then
        if __DEBUG__ then
            print("Component.define: config must be a table and have a class", type(config), type(config.class))
        end
        return false
    end

    if types[type_name] then
        if __DEBUG__ then
            print("Component.define: type_name already defined", type_name)
        end
        return false
    end

    types[type_name] = config

    return true
end

--[[
树状UI声明式的结构：
local pannel = {
    x = ...,
    y = ...,
    ...
    tree = {
        {
            class = "text",
            x = ...,
            y = ...,
            width = ...,
            height = ...,
            value = "Hello, World!",
            font = { "Fonts\\FZXS14.ttf", 0.018 },
            align = { Constant.TEXT_VERTEX_ALIGN_CENTER, Constant.TEXT_HORIZON_ALIGN_CENTER },
            --style存在时要改写style中的属性到外部UIconfig
            style = {
                ...
            },
            --layout存在时可以忽略x,y等布局相关属性，并改写到外部UIconfig，方便将config传入ui创建函数时处理
            layout = {
                position = "static",
                gap = ...,
                padding = ...,
                align = ...,
            },
            ...
        }
    }

}
--]]

local function copyConfig(config)
    if type(config) ~= "table" then
        return nil
    end

    local new_config = {}
    for k, v in pairs(config) do
        new_config[k] = v
    end
    return new_config
end

local function normalizeConfig(config, class_hint, is_layout)
    if type(config) ~= "table" then
        return config
    end

    Theme.apply(config, class_hint)

    if is_layout then
        Style.applyLayout(config)
    end

    return config
end

--[[
    清理 config 树上 bindRuntimeLayout 写入的运行时字段，防止 frame destroy 后 config 仍持有已销毁 frame 的引用。
    仅清理 __runtime_layout__ 和 __runtime_parent_config__，不碰其他字段。
]]
local function cleanup_runtime_layout(config)
    if type(config) ~= "table" then return end
    config.__runtime_layout__ = nil
    config.__runtime_parent_config__ = nil
    local tree = rawget(config, "tree")
    if type(tree) == "table" then
        for i = 1, #tree do
            cleanup_runtime_layout(tree[i])
        end
    end
end

local function attachRuntimeTheme(frame, config)
    if type(frame) ~= "table" or type(config) ~= "table" then
        return frame
    end

    local attach = Theme.attach
    if type(attach) == "function" then
        attach(frame, config)
    end

    -- 注册 destroy 时清理 config 上的 runtime 布局字段，防止已销毁 frame 的引用残留在 config 上。
    frame:hook_destroy(function()
        cleanup_runtime_layout(config)
    end)

    return frame
end

--[[
    注册frame销毁前钩子，统一清理事件表、Watcher、Tween 等高层运行时状态
--]]
Frame.hook_destroy(function (frame)
    --清理事件表
    frame.__events = nil

    --清理Watcher
    if not Watcher_clear then
        local ok, Watcher = pcall(require, "Core.UI.Watcher")
        if ok and Watcher then
            Watcher_clear = Watcher.clear
        end
    end
    if Watcher_clear then
        Watcher_clear(frame)
    end

    if not Tween_cancelAll then
        local ok, Tween = pcall(require, "Core.UI.Tween")
        if ok and Tween then
            Tween_cancelAll = Tween.cancelAll
        end
    end
    if Tween_cancelAll then
        Tween_cancelAll(frame)
    end
end)


function Component.create(type_name, config)
    if type(config) ~= "table" then
        if __DEBUG__ then
            print("Component.create: config must be a table", type(config))
        end
        return nil
    end

    local type_config = types[type_name]
    if not type_config then
        if __DEBUG__ then
            print("Component.create: unknown type_name", type_name)
        end
        return nil
    end

    --以config作为主Ui的配置，子UI配置根据type_config.tree创建
    local main_config = copyConfig(config)
    normalizeConfig(main_config, type_config.class, false)

    local frame = type_config.class(main_config)
    attachRuntimeTheme(frame, main_config)
    return frame
    
end

--[[@usage Component("text", {
    x = 0,
    y = 0,
    width = 100,
    height = 100,
    value = "Hello, World!"
 })
--]]
function Component.__call(self, config)
    if type(config) ~= "table" then
        if __DEBUG__ then
            print("Component.create: config must be a table", type(config))
        end
        return nil
    end

    --先按照布局改写tree的config，标准化配置
    normalizeConfig(config, config.class, true)

    --再创建frame
    local ui_class = classes_cache[config.class]
    if not ui_class then
        ui_class = Class.get(config.class)
        --如果类不存在，则报错
        if not ui_class then
            if __DEBUG__ then
                print("Component.__call: class not found", config.class)
            end
            return nil
        --如果类不是Component的子类，则报错
        elseif not Class.issubclass(ui_class, Frame) then
            if __DEBUG__ then
                print("Component.__call: class is not a subclass of Component", config.class)
            end
            return nil
        end
        classes_cache[config.class] = ui_class
    end

    --由Frame类创建frame，并自动处理tree的创建
    local frame = ui_class.new(config)
    attachRuntimeTheme(frame, config)
    -- frame 树创建完成后，把 fixed/sticky 升级为运行时锚点。
    -- 业务层无需手动调用 Style.bindRuntimeLayout。
    Style.bindRuntimeLayout(frame, config)
    return frame
end

setmetatable(Component, Component)

return Component
