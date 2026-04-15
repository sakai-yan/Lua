--[[
================================================================================
                            Frame 基类（UI 框架核心）

    所有 UI 元素的抽象基类，提供以下核心能力：
    1. 属性系统：通过赋值语法直接操作 UI 属性（position, size, alpha 等）
    2. 事件系统：类比 HTML5 的 addEventListener，支持 frame:on("click", callback)
    3. 定位系统：支持绝对定位和相对定位（类比 CSS 的 position: absolute/relative）
    4. 生命周期：统一管理 frame 的创建、查找、销毁与运行时清理
    5. 子树关系：parent 统一为封装后的 frame，子列表统一为 childs
    6. 根节点访问：提供 GameUI / ConsoleUI 的封装入口，避免业务层直接裸用 handle

    设计原则：
    - destroy() 是统一的运行时清理入口，负责事件、Watcher、Tween 等清理

    使用场景：不直接实例化，由子类（Panel, Texture, Text, Button 等）继承使用
================================================================================
--]]

local Jass = require "Lib.API.Jass"
local Constant = require "Lib.API.Constant"
local Class = require "Lib.Base.Class"
local BitSet = require "Lib.Base.BitSet"
local DataType = require "Lib.Base.DataType"
local Point = require "FrameWork.Manager.Point"
local LinkedList = require "Lib.Base.LinkedList"

-- 缓存 modify_field 键，避免运行时字符串拼接
local position_modify = Class.modify_field("position")
local alpha_modify = Class.modify_field("alpha")
local level_modify = Class.modify_field("level")
local scale_modify = Class.modify_field("scale")
local is_track_modify = Class.modify_field("is_track")
local view_port_modify = Class.modify_field("view_port")
local disable_modify = Class.modify_field("disable")
local size_modify = Class.modify_field("size")

-- 事件名到 JASS 事件 ID 的映射
local FRAME_EVENT_NAMES = {
    "mouse_enter", "mouse_leave", "mouse_down", "mouse_up",
    "click", "double_click", "scroll", "tick",
}
local FRAME_EVENT_IDS = {
    Constant.EVENT_ID_FRAME_MOUSE_ENTER,
    Constant.EVENT_ID_FRAME_MOUSE_LEAVE,
    Constant.EVENT_ID_FRAME_MOUSE_DOWN,
    Constant.EVENT_ID_FRAME_MOUSE_UP,
    Constant.EVENT_ID_FRAME_MOUSE_CLICK,
    Constant.EVENT_ID_FRAME_MOUSE_DOUBLE_CLICK,
    Constant.EVENT_ID_FRAME_MOUSE_SCROLL,
    Constant.EVENT_ID_FRAME_TICK,
}
local FRAME_EVENT_MAP = {}
for index = 1, #FRAME_EVENT_NAMES do
    FRAME_EVENT_MAP[FRAME_EVENT_NAMES[index]] = FRAME_EVENT_IDS[index]
end

-- 缓存 LinkedList 的静态方法引用，减少查表开销
local LinkedList_add = LinkedList.add
local LinkedList_remove = LinkedList.remove
local LinkedList_forEachExecute = LinkedList.forEachExecute

local Tween_cancelAll
local Watcher_clear

local Frame

--[[
    childs 的保护元表
    用途：禁止外部直接改写 childs，只允许框架内部通过 childsUpdate 同步
--]]
local childsMetaTable = {
    __newindex = function(childs, key, value)
        if __DEBUG__ then
            print("Frame.childs is read-only", childs, key, value)
        end
    end,

    __index = function(childs, key)
        return childs.__data__[key]
    end,

    __len = function(childs)
        return #childs.__data__
    end,
}

-- 确保 frame 拥有 childs 列表
local function ensureChildsList(frame)
    local childs = rawget(frame, "childs")
    if not childs then
        -- 创建一个受保护的 childs 列表
        childs = setmetatable({
            __data__ = {},
        }, childsMetaTable)
        rawset(frame, "childs", childs)
    end
    return childs
end

--[[
    将外部 handle 封装为 frame
    用途：给系统根节点等“不是框架创建，但需要进入框架语义”的 handle 提供封装对象
    注意：
      1. 封装对象标记为 __is_external__
      2. destroy() 时不会调用 JASS destroy，只移除 Lua 侧映射
--]]
local function wrapHandle(handle, name)
    if type(handle) ~= "number" or handle == 0 then
        return nil
    end

    local frame = Frame.__frames_by_handle[handle]
    if frame then
        if name and not frame.name then
            frame.name = name
            Frame.__frames_by_name[name] = frame
        end
        return frame
    end

    frame = setmetatable({
        handle = handle,
        name = name,
        __is_external__ = true,
    }, Frame)

    Frame.__frames_by_handle[handle] = frame
    if name then
        Frame.__frames_by_name[name] = frame
    end
    ensureChildsList(frame)
    return frame
end


--[[
    对外统一的 childs 同步入口
    从 JASS 底层同步 parent_frame 的 childs 列表
    用途：保证 Lua 侧子树视图与底层 parent/child 关系一致
--]]
local function childsUpdate(parent_frame)
    if not parent_frame then
        return nil
    end

    local childs = ensureChildsList(parent_frame)
    local childs_data = childs.__data__
    for index = 1, #childs_data do
        childs_data[index] = nil
    end

    local child_count = Jass.MHFrame_GetChildCount(parent_frame.handle)
    for index = 1, child_count do
        local child_handle = Jass.MHFrame_GetChild(parent_frame.handle, index)
        local child = Frame.getByHandle(child_handle)
        if child then
            childs_data[index] = child
        end
    end

    return childs
end


--[[
    清理相对定位缓存
    用途：
      - 使用 setRelativePoint / centerIn / above 等相对定位后，position 不再代表权威真值
      - 使用 setAllPoints 后，size 也不再代表权威真值
--]]
local function clearRelativeCaches(frame, clear_size)
    frame[position_modify] = nil
    if clear_size then
        frame[size_modify] = nil
    end
end

-- 只读属性的 setter 拦截
local function disable_set(frame, key, value)
    if __DEBUG__ then
        print("Frame.disable_set", frame.name, key, value)
    end
end

--子集树结构UI支持
--创建的UI位置统一使用绝对锚点
local function TreeCreate(frame, tree)
    for index = 1, #tree do
        local child_config = tree[index]
        --child_config.class是一个UI类
        if type(child_config) == "table" and child_config.class then
            child_config.parent = frame
            --当子UI的level为nil时，使用父UI的level+1
            child_config.level = child_config.level or (frame.level + 1)
            --当子UI的x或y为nil时，使用父UI的x或y
            child_config.x = child_config.x or frame.x
            child_config.y = child_config.y or frame.y
            --当子UI的width或height为nil时，使用父UI的width或height
            child_config.width = child_config.width or frame.width
            child_config.height = child_config.height or frame.height
            
            --创建子UI
            local child_frame = child_config.class(child_config)
            
            --递归创建子 UI
            if child_config.children then
                TreeCreate(child_frame, child_config.children)
            end
        elseif __DEBUG__ then
            print("Frame.childsCreate: child_config must be a table and have a class")
        end
    end

    --全部树状创建完成后，更新父级 childs 列表
    childsUpdate(frame)

    return frame
end

Frame = Class("Frame", {
    -- 抽象类，不应直接实例化
    __abstract__ = true,

    -- name -> frame
    __frames_by_name = {},

    -- handle -> frame
    __frames_by_handle = {},

    --[[
        通用构造器
        用途：大部分标准 Frame 子类共享的 JASS frame 创建逻辑
    --]]
    __common_constructor = function(class, config)
        if type(config) ~= "table" then
            if __DEBUG__ then
                print("Frame.__common_constructor: config must be a table")
            end
            return nil
        end

        local parent_handle
        if type(config.parent) == "table" then
            parent_handle = config.parent.handle
        else
            parent_handle = Jass.MHUI_GetGameUI()
        end

        --若config.data中的数据可保留在frame中
        local frame = type(config.data) == "table" and config.data or {handle = false}
        frame.handle = Jass.MHFrame_CreateEx(class.__type, nil, nil, parent_handle, config.level, 0)
        
        return frame
    end,

    --[[
        基类初始化逻辑
    --]]
    __init__ = function(class, frame, config)

        if __DEBUG__ then
            assert(type(config.x) == "number", "Frame.__init__: config.x must be a number")
            assert(type(config.y) == "number", "Frame.__init__: config.y must be a number")
            assert(type(config.width) == "number", "Frame.__init__: config.width must be a number")
            assert(type(config.height) == "number", "Frame.__init__: config.height must be a number")
            assert(not config.level or type(config.level) == "number", "Frame.__init__: config.level must be a number")
            assert(not config.alpha or type(config.alpha) == "number", "Frame.__init__: config.alpha must be a number")
            assert(not config.is_show or type(config.is_show) == "boolean", "Frame.__init__: config.is_show must be a boolean")
            assert(not config.tree or type(config.tree) == "table", "Frame.__init__: config.tree must be a table")
        end

        Frame.__frames_by_handle[frame.handle] = frame

        if class.__type then
            ensureChildsList(frame)
        end

        if config.name then
            frame.name = config.name
            Frame.__frames_by_name[config.name] = frame
        end

        frame.level = config.level or 0

        if config.size then
            frame.size = config.size
        else
            frame.size = Point(config.width, config.height)
        end

        --x\y是屏幕坐标
        if config.x ~= nil and config.y ~= nil then
            frame.position = Point(config.x, config.y)
        end

        if config.is_show ~= nil then
            frame.is_show = config.is_show
        end

        if config.alpha ~= nil then
            frame.alpha = config.alpha
        end

        if config.parent then
            childsUpdate(config.parent)
        end

        --树状创建子UI
        if config.tree then
            TreeCreate(frame, config.tree)
        end

        DataType.set(frame, "frame")
    end,

    --@function hook_destroy 销毁前钩子
    hook_destroy = function (func)
        if type(func) == "function" then
            Frame.hook_destroy_func = func
        end
    end,

    --[[
        统一销毁逻辑
        规则：
          1. destroy() 是统一清理入口
          2. 先清理高层运行时状态，再递归销毁子节点，再销毁底层 handle
          3. 对外部封装 handle（__is_external__）只移除 Lua 侧映射，不销毁底层对象
    --]]
    __del__ = function(class, frame)
        if frame.__is_external__ then
            class.__frames_by_handle[frame.handle] = nil
            if frame.name then
                class.__frames_by_name[frame.name] = nil
            end
            rawset(frame, "childs", nil)
            return
        end

        --销毁前钩子
        if class.hook_destroy_func then
            class.hook_destroy_func(frame)
        end

        --递归销毁子节点
        local childs = childsUpdate(frame)
        if childs then
            local child_count = #childs
            for index = child_count, 1, -1 do
                local child = childs[index]
                if child then
                    child:destroy()
                end
            end
        end

        class.__frames_by_handle[frame.handle] = nil
        if frame.name then
            class.__frames_by_name[frame.name] = nil
        end

        rawset(frame, "childs", nil)
        Jass.MHFrame_Destroy(frame.handle)

        --更新父级 childs 列表
        if frame.parent then
            childsUpdate(frame.parent)
        end
    end,

    __attributes__ = {
        --[[
            parent
            语义：一律返回或接收封装后的 frame，而不是 handle
        --]]
        {
            name = "parent",
            get = function(frame, _)
                local parent_handle = Jass.MHFrame_GetParent(frame.handle)
                if type(parent_handle) ~= "number" or parent_handle == 0 then
                    return nil
                end
                return Frame.__frames_by_handle[parent_handle] or wrapHandle(parent_handle)
            end,
            set = function(frame, _, parent_frame)
                local old_parent = frame.parent
                Jass.MHFrame_SetParent(frame.handle, parent_frame.handle)
                if old_parent then
                    childsUpdate(old_parent)
                end
                childsUpdate(parent_frame)
            end,
        },

        ---@高度 number 屏幕坐标
        ---@usage frame.height
        {
            name = "height",
            get = function(frame, _)
                return Jass.MHFrame_GetHeight(frame.handle)
            end,
            set = function(frame, _, height)
                Jass.MHFrame_SetHeight(frame.handle, height)
                frame[size_modify] = Point(frame.width, height)
            end,
        },

        ---@宽度 number 屏幕坐标
        ---@usage frame.width
        {
            name = "width",
            get = function(frame, _)
                return Jass.MHFrame_GetWidth(frame.handle)
            end,
            set = function(frame, _, width)
                Jass.MHFrame_SetWidth(frame.handle, width)
                frame[size_modify] = Point(width, frame.height)
            end,
        },

        ---@绝对锚点位置 Point 屏幕坐标，左下角为原点，x:0~0.8，y:0~0.6
        ---@usage frame.position = Point(0.1, 0.2)
        {
            name = "position",
            get = function(frame, _)
                return frame[position_modify]
            end,
            set = function(frame, _, point)
                local x, y = Point.get(point)
                Jass.MHFrame_SetAbsolutePoint(frame.handle, Constant.ANCHOR_TOP_LEFT, x, y)
                frame[position_modify] = point
            end,
        },

        ---@显示状态 boolean true=显示 false=隐藏
        ---@usage frame.is_show = true
        {
            name = "is_show",
            get = function(frame, _)
                return not Jass.MHFrame_IsHidden(frame.handle)
            end,
            set = function(frame, _, is_show)
                Jass.MHFrame_Hide(frame.handle, not is_show)
            end,
        },

        {
            name = "alpha",
            get = function(frame, _)
                return frame[alpha_modify]
            end,
            set = function(frame, _, alpha)
                Jass.MHFrame_SetAlpha(frame.handle, alpha)
                frame[alpha_modify] = alpha
            end,
        },

        {
            name = "level",
            get = function(frame, _)
                return frame[level_modify]
            end,
            set = function(frame, _, level)
                Jass.MHFrame_SetPriority(frame.handle, level)
                frame[level_modify] = level
            end,
        },

        {
            name = "scale",
            get = function(frame, _)
                return frame[scale_modify]
            end,
            set = function(frame, _, scale)
                Jass.MHFrame_SetScale(frame.handle, scale)
                frame[scale_modify] = scale
            end,
        },

        {
            name = "is_track",
            get = function(frame, _)
                return frame[is_track_modify]
            end,
            set = function(frame, _, is_track)
                local layer_style = Jass.MHFrame_GetLayerStyle(frame.handle)
                if is_track then
                    layer_style = BitSet.add(layer_style, Constant.LAYER_STYLE_IGNORE_TRACK_EVENT)
                else
                    layer_style = BitSet.del(layer_style, Constant.LAYER_STYLE_IGNORE_TRACK_EVENT)
                end
                Jass.MHFrame_SetLayerStyle(frame.handle, layer_style)
                frame[is_track_modify] = is_track
            end,
        },

        {
            name = "view_port",
            get = function(frame, _)
                return frame[view_port_modify]
            end,
            set = function(frame, _, view_port)
                local layer_style = Jass.MHFrame_GetLayerStyle(frame.handle)
                if view_port then
                    layer_style = BitSet.add(layer_style, Constant.LAYER_STYLE_VIEW_PORT)
                else
                    layer_style = BitSet.del(layer_style, Constant.LAYER_STYLE_VIEW_PORT)
                end
                Jass.MHFrame_SetLayerStyle(frame.handle, layer_style)
                frame[view_port_modify] = view_port
            end,
        },

        {
            name = "disable",
            get = function(frame, _)
                return frame[disable_modify]
            end,
            set = function(frame, _, is_disable)
                Jass.MHFrame_Disable(frame.handle, is_disable)
                frame[disable_modify] = is_disable
            end,
        },

        {
            name = "border_bottom",
            get = function(frame, _)
                return Jass.MHFrame_GetBorderBottom(frame.handle)
            end,
            set = disable_set,
        },

        {
            name = "border_left",
            get = function(frame, _)
                return Jass.MHFrame_GetBorderLeft(frame.handle)
            end,
            set = disable_set,
        },

        {
            name = "border_right",
            get = function(frame, _)
                return Jass.MHFrame_GetBorderRight(frame.handle)
            end,
            set = disable_set,
        },

        {
            name = "border_top",
            get = function(frame, _)
                return Jass.MHFrame_GetBorderTop(frame.handle)
            end,
            set = disable_set,
        },

        --[[
            size
            注意：
              1. 该 getter 返回“显式 size 缓存”
              2. setAllPoints 后会清空 size 缓存，因为此时 size 不再由本对象直接决定
        --]]
        {
            name = "size",
            get = function(frame, _)
                return frame[size_modify]
            end,
            set = function(frame, _, size)
                local width, height = Point.get(size)
                Jass.MHFrame_SetSize(frame.handle, width, height)
                frame[size_modify] = size
            end,
        },
    },

    --[[
    ================================================================================
                                静态方法
    ================================================================================
    --]]

    --[[
        加载 TOC 文件
        用途：让自定义 FDF / TOC 中定义的模板可被 JASS UI 系统识别
        为什么这样设计：这是全局资源装载行为，放成静态方法更直观

        @param toc_path string TOC 文件路径
        @usage Frame.loadToc("UI\\MyTemplate.toc")
    --]]
    loadToc = function(toc_path)
        Jass.MHFrame_LoadTOC(toc_path)
    end,

    --[[
        通过 JASS handle 查找对应的 Lua frame 实例

        @param handle integer JASS frame handle
        @return table|nil 封装后的 frame，未找到返回 nil
        @usage local frame = Frame.getByHandle(handle)
    --]]
    getByHandle = function(handle)
        return Frame.__frames_by_handle[handle]
    end,

    --[[
        通过名字查找 frame

        @param name string frame 名称
        @return table|nil 对应的 frame，未找到返回 nil
        @usage local panel = Frame.getByName("main_panel")
    --]]
    getByName = function(name)
        return Frame.__frames_by_name[name]
    end,

    --[[
        获取 GameUI 根节点（封装后的 frame）

        @return table GameUI 对应的 frame 包装对象
        @usage local game_ui = Frame.getGameUI()
    --]]
    getGameUI = function()
        return wrapHandle(Jass.MHUI_GetGameUI(), "__game_ui__")
    end,

    --[[
        获取 ConsoleUI 根节点（封装后的 frame）
        @return table ConsoleUI 对应的 frame 包装对象
        @usage local console_ui = Frame.getConsoleUI()
    --]]
    getConsoleUI = function()
        return wrapHandle(Jass.MHUI_GetConsoleUI(), "__console_ui__")
    end,

    --[[
        设置是否限制 frame 保持在屏幕内

        @param is_limit boolean 是否启用限制
        @usage Frame.setScreenLimit(true)
    --]]
    setScreenLimit = function(is_limit)
        Jass.MHFrame_SetScreenLimit(is_limit)
    end
})

--[[
    同步某个父节点的 childs 列表
    用途：当父子关系在框架外部或专用初始化中变化后，主动刷新 Lua 侧子树视图

    @param parent_frame table 父级 frame
    @return table 刷新后的 childs 列表
    @usage local childs = Frame.syncChilds(panel)
--]]
Frame.syncChilds = childsUpdate

--[[
    强制刷新 frame

    @param frame table 目标 frame
    @usage Frame.update(frame)
--]]
function Frame.update(frame)
    Jass.MHFrame_Update(frame.handle)
end

--[[
    判断某个屏幕点是否位于 frame 范围内

    @param frame table 目标 frame
    @param x number 屏幕 x 坐标
    @param y number 屏幕 y 坐标
    @return boolean 是否位于 frame 内
    @usage if Frame.includePoint(frame, x, y) then ... end
--]]
function Frame.includePoint(frame, x, y)
    return Jass.MHFrame_InFrame(x, y, frame.handle)
end

--[[
================================================================================
                            定位系统
================================================================================
--]]

--[[
    清除 frame 上的全部锚点
    关键步骤：
    1. 调用 JASS 清空锚点
    2. 清空相对定位失效后的缓存

    @param frame table 目标 frame
    @usage frame:clearAllPoints()
--]]
function Frame.clearAllPoints(frame)
    Jass.MHFrame_ClearAllPoints(frame.handle)
    clearRelativeCaches(frame, false)
end

--[[
    设置相对定位

    @param frame table 当前 frame
    @param anchor integer 当前 frame 的锚点
    @param target table 目标 frame
    @param target_anchor integer 目标 frame 的锚点
    @param offset_x number x 偏移
    @param offset_y number y 偏移
    @usage frame:setPoint(Constant.ANCHOR_TOP_LEFT, panel, Constant.ANCHOR_TOP_LEFT, 0.01, -0.01)
--]]
function Frame.setRelativePoint(frame, anchor, target, target_anchor, offset_x, offset_y)
    Jass.MHFrame_SetRelativePoint(frame.handle, anchor, target.handle, target_anchor, offset_x or 0, offset_y or 0)
    clearRelativeCaches(frame, false)
end

--[[
    让当前 frame 完全填充目标 frame

    @param frame table 当前 frame
    @param target table 目标 frame
    @usage bg:setAllPoints(panel)
--]]
function Frame.setAllPoints(frame, target)
    Jass.MHFrame_SetAllPoints(frame.handle, target.handle)
    clearRelativeCaches(frame, true)
end

--[[
    将 frame 居中放入目标 frame

    @param frame table 当前 frame
    @param target table 目标 frame
    @usage title:centerIn(panel)
--]]
function Frame.centerIn(frame, target)
    Jass.MHFrame_SetRelativePoint(frame.handle, Constant.ANCHOR_CENTER, target.handle, Constant.ANCHOR_CENTER, 0, 0)
    clearRelativeCaches(frame, false)
end

--[[
    将 frame 放到目标上方

    @param frame table 当前 frame
    @param target table 目标 frame
    @param gap number 间距
    @usage tooltip:above(button, 0.01)
--]]
function Frame.above(frame, target, gap)
    Jass.MHFrame_SetRelativePoint(frame.handle, Constant.ANCHOR_BOTTOM, target.handle, Constant.ANCHOR_TOP, 0, gap or 0)
    clearRelativeCaches(frame, false)
end

--[[
    将 frame 放到目标下方

    @param frame table 当前 frame
    @param target table 目标 frame
    @param gap number 间距
    @usage menu:below(button, 0.01)
--]]
function Frame.below(frame, target, gap)
    Jass.MHFrame_SetRelativePoint(frame.handle, Constant.ANCHOR_TOP, target.handle, Constant.ANCHOR_BOTTOM, 0, -(gap or 0))
    clearRelativeCaches(frame, false)
end

--[[
    将 frame 放到目标左侧

    @param frame table 当前 frame
    @param target table 目标 frame
    @param gap number 间距
    @usage icon:leftOf(label, 0.005)
--]]
function Frame.leftOf(frame, target, gap)
    Jass.MHFrame_SetRelativePoint(frame.handle, Constant.ANCHOR_RIGHT, target.handle, Constant.ANCHOR_LEFT, -(gap or 0), 0)
    clearRelativeCaches(frame, false)
end

--[[
    将 frame 放到目标右侧

    @param frame table 当前 frame
    @param target table 目标 frame
    @param gap number 间距
    @usage value_text:rightOf(icon, 0.005)
--]]
function Frame.rightOf(frame, target, gap)
    Jass.MHFrame_SetRelativePoint(frame.handle, Constant.ANCHOR_LEFT, target.handle, Constant.ANCHOR_RIGHT, gap or 0, 0)
    clearRelativeCaches(frame, false)
end

--[[
================================================================================
                            事件系统
================================================================================
--]]

--[[
    注册 frame 事件

    @param frame table 目标 frame
    @param event_name string 事件名
    @param callback function 回调函数
    @return boolean 是否注册成功
    @usage frame:on("click", function(frame) print("clicked") end)
--]]
function Frame.on(frame, event_name, callback)
    local event_id = FRAME_EVENT_MAP[event_name]
    if not event_id then
        if __DEBUG__ then
            print("Frame.on: unknown event '" .. tostring(event_name) .. "'")
        end
        return false
    end

    if not frame.__events then
        frame.__events = {}
    end

    local event_data = frame.__events[event_name]
    if not event_data then
        event_data = {
            callbacks = LinkedList.new(),
        }
        frame.__events[event_name] = event_data

        if event_name == "scroll" then
            Jass.MHFrameEvent_RegisterByCode( frame.handle, event_id, function()
                if frame.__events then
                    local scroll_data = frame.__events[event_name]
                    if scroll_data then
                        LinkedList_forEachExecute(scroll_data.callbacks, frame, Jass.MHFrameScrollEvent_GetValue())
                    end
                end
            end)
        else
            Jass.MHFrameEvent_RegisterByCode(frame.handle, event_id, function()
                if frame.__events then
                    local evt_data = frame.__events[event_name]
                    if evt_data then
                        LinkedList_forEachExecute(evt_data.callbacks, frame)
                    end
                end
            end)
        end
    end

    return LinkedList_add(event_data.callbacks, callback, callback)
end

--[[
    注销 frame 事件

    @param frame table 目标 frame
    @param event_name string 事件名
    @param callback function 要移除的回调
    @return boolean 是否移除成功
    @usage frame:off("click", onClick)
--]]
function Frame.off(frame, event_name, callback)
    if not frame.__events then
        return false
    end

    local event_data = frame.__events[event_name]
    if not event_data then
        return false
    end

    return LinkedList_remove(event_data.callbacks, callback)
end

--[[
================================================================================
                            工具方法
================================================================================
--]]

--[[
    将 frame 绑定到单位头顶

    @param frame table 目标 frame
    @param unit handle 目标单位
    @usage hp_bar:bindToUnit(unit)
--]]
function Frame.bindToUnit(frame, unit)
    Jass.MHFrame_BindToUnit(frame.handle, unit)
end

--[[
    解除单位绑定

    @param frame table 目标 frame
    @usage hp_bar:unbind()
--]]
function Frame.unbind(frame)
    Jass.MHFrame_UnbindFrame(frame.handle)
end

--[[
    限制鼠标是否被锁在 frame 内

    @param frame table 目标 frame
    @param is_lock boolean 是否锁定
    @usage frame:cageMouse(true)
--]]
function Frame.cageMouse(frame, is_lock)
    Jass.MHFrame_CageMouse(frame.handle, is_lock)
end



return Frame
