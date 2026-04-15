--[[
================================================================================
                            Tween 补间动画系统

    提供类似 CSS Transitions / Web Animation API 的属性补间能力。
    通过 Async 异步引擎驱动，对 frame 的属性进行平滑过渡。

    设计原则：
    1. 不使用同步 Timer 系统，避免污染同步逻辑
    2. 使用单一 Async tick loop 推进全部活跃动画
    3. 热路径采用 flat 数组 + 写指针紧缩，减少内存分配

    支持的可动画属性：
    - alpha:    透明度（0-255）
    - scale:    缩放
    - position: 位置，目标值格式 {x, y}
    - size:     尺寸，目标值格式 {w, h}
    - color:    颜色（ARGB 整数）

    用法：
      frame:animate({alpha = 0}, 0.3, "easeOut")
      frame:animate({position = {0.4, 0.3}}, 0.5, "easeInOut")
      frame:stopAnimate()
================================================================================
--]]

local Async = require "FrameWork.Manager.Async"
local Point = require "FrameWork.Manager.Point"
local Tool = require "Lib.API.Tool"

local math_floor = math.floor

local Tween = {}

-- ============================================================================
--  缓动函数
-- ============================================================================

--[[
    线性缓动
    @param t number 0~1 的进度值
    @return number 映射后的进度
    @usage local eased = ease_linear(0.5)
--]]
local function ease_linear(t) return t end

--[[
    二次 ease-in
    @param t number 0~1 的进度值
    @return number 映射后的进度
    @usage local eased = ease_in(0.5)
--]]
local function ease_in(t) return t * t end

--[[
    二次 ease-out
    @param t number 0~1 的进度值
    @return number 映射后的进度
    @usage local eased = ease_out(0.5)
--]]
local function ease_out(t) return t * (2 - t) end

--[[
    二次 ease-in-out
    @param t number 0~1 的进度值
    @return number 映射后的进度
    @usage local eased = ease_in_out(0.5)
--]]
local function ease_in_out(t)
    if t < 0.5 then
        return 2 * t * t
    end
    return -1 + (4 - 2 * t) * t
end
-- 三次 ease-in
local function ease_in_cubic(t) return t * t * t end

-- 三次 ease-out
local function ease_out_cubic(t)
    local u = t - 1
    return u * u * u + 1
end
-- 三次 ease-in-out
local function ease_in_out_cubic(t)
    if t < 0.5 then
        return 4 * t * t * t
    end
    local u = t - 1
    return 1 + 4 * u * u * u
end

local EASING_NAMES = {
    "linear", "easeIn", "easeOut", "easeInOut",
    "easeInCubic", "easeOutCubic", "easeInOutCubic",
}
local EASING_FUNCS = {
    ease_linear, ease_in, ease_out, ease_in_out,
    ease_in_cubic, ease_out_cubic, ease_in_out_cubic,
}
local EASING_MAP = {}
for index = 1, #EASING_NAMES do
    EASING_MAP[EASING_NAMES[index]] = EASING_FUNCS[index]
end

-- ============================================================================
--  属性处理器
-- ============================================================================

local PROP_HANDLERS = {}

PROP_HANDLERS["alpha"] = {
    get = function(frame)
        return frame.alpha or 255
    end,
    lerp = function(from, to, t)
        return math_floor(from + (to - from) * t + 0.5)
    end,
    set = function(frame, value)
        frame.alpha = value
    end,
}

PROP_HANDLERS["scale"] = {
    get = function(frame)
        return frame.scale or 1
    end,
    lerp = function(from, to, t)
        return from + (to - from) * t
    end,
    set = function(frame, value)
        frame.scale = value
    end,
}

PROP_HANDLERS["position"] = {
    get = function(frame)
        local point = frame.position
        if not point then
            return { 0, 0 }
        end
        local x, y = Point.get(point)
        return { x, y }
    end,
    lerp = function(from, to, t)
        return {
            from[1] + (to[1] - from[1]) * t,
            from[2] + (to[2] - from[2]) * t,
        }
    end,
    set = function(frame, value)
        frame.position = Point(value[1], value[2])
    end,
}

PROP_HANDLERS["size"] = {
    get = function(frame)
        local point = frame.size
        if not point then
            return { 0, 0 }
        end
        local width, height = Point.get(point)
        return { width, height }
    end,
    lerp = function(from, to, t)
        return {
            from[1] + (to[1] - from[1]) * t,
            from[2] + (to[2] - from[2]) * t,
        }
    end,
    set = function(frame, value)
        frame.size = Point(value[1], value[2])
    end,
}

PROP_HANDLERS["color"] = {
    get = function(frame)
        return frame.color or 0xFFFFFFFF
    end,
    lerp = function(from, to, t)
        local a1, r1, g1, b1 = Tool.Color2Rgba(from)
        local a2, r2, g2, b2 = Tool.Color2Rgba(to)
        return Tool.Rgba2Color(
            math_floor(r1 + (r2 - r1) * t + 0.5),
            math_floor(g1 + (g2 - g1) * t + 0.5),
            math_floor(b1 + (b2 - b1) * t + 0.5),
            math_floor(a1 + (a2 - a1) * t + 0.5)
        )
    end,
    set = function(frame, value)
        frame.color = value
    end,
}

-- ============================================================================
--  动画引擎
-- ============================================================================

local active_tweens = {}
local active_count = 0
local next_tween_id = 1
local tick_loop_id = nil

local ANIMATABLE_PROP_NAMES = { "alpha", "scale", "position", "size", "color" }
local ANIMATABLE_PROP_COUNT = #ANIMATABLE_PROP_NAMES

--[[
    Async tick 推进函数
    说明：
      - delay 通过 elapsed 初始为负值实现
      - 当 elapsed < 0 时，本帧不更新属性，只保留 tween
      - 使用写指针紧缩移除已完成或已取消的 tween
--]]
--[[
    Async tick 推进函数
    关键步骤：
    1. 推进 elapsed
    2. delay 未结束时直接保留 tween
    3. 计算 eased 进度并写回所有属性
    4. 处理 on_update / on_complete
    5. 通过写指针移除无效 tween

    @param delta number 当前 tick 的估算时间增量
    @usage 内部由 Async.onTick(onTick) 调用
--]]
local function onTick(delta)
    local write_index = 1

    for read_index = 1, active_count do
        local tween = active_tweens[read_index]
        if tween and not tween.cancelled then
            tween.elapsed = tween.elapsed + delta

            if tween.elapsed < 0 then
                if write_index ~= read_index then
                    active_tweens[write_index] = tween
                end
                write_index = write_index + 1
                goto continue
            end

            local t = tween.elapsed / tween.duration
            if t > 1 then
                t = 1
            end

            local eased = tween.easing(t)
            local props = tween.props
            for prop_index = 1, #props do
                local prop = props[prop_index]
                prop[1].set(tween.frame, prop[1].lerp(prop[2], prop[3], eased))
            end

            if tween.on_update then
                tween.on_update(tween.frame, t)
            end

            if t >= 1 then
                if tween.on_complete then
                    tween.on_complete(tween.frame)
                end
            else
                if write_index ~= read_index then
                    active_tweens[write_index] = tween
                end
                write_index = write_index + 1
            end
        end

        ::continue::
    end

    for index = write_index, active_count do
        active_tweens[index] = nil
    end
    active_count = write_index - 1

    if active_count == 0 and tick_loop_id then
        Async.cancel(tick_loop_id)
        tick_loop_id = nil
    end
end

--[[
    确保 Async tick loop 已启动
    @usage ensureTickLoopRunning()
--]]
local function ensureTickLoopRunning()
    if not tick_loop_id then
        tick_loop_id = Async.onTick(onTick)
    end
end

-- ============================================================================
--  公开 API
-- ============================================================================

--[[
    创建一个补间动画
    为什么这样设计：
    - 统一把属性补间入口收敛到 Tween.animate
    - 便于后续通过 Frame.animate 做语法糖注入

    @param frame table 目标 frame
    @param target_props table 目标属性表
    @param duration number 动画时长（秒）
    @param easing string|function 缓动名称或自定义缓动函数
    @param options table|nil 额外配置，支持 on_complete / on_update / delay
    @return number tween_id，可用于取消
    @usage
      Tween.animate(frame, { alpha = 0 }, 0.3, "easeOut")
      Tween.animate(frame, { position = {0.4, 0.3} }, 0.5, "easeInOut", {
          delay = 0.2,
          on_complete = function(f) f:destroy() end,
      })
--]]
function Tween.animate(frame, target_props, duration, easing, options)
    local ease_func
    if type(easing) == "function" then
        ease_func = easing
    elseif type(easing) == "string" then
        ease_func = EASING_MAP[easing] or ease_linear
    else
        ease_func = ease_linear
    end

    local props = {}
    for index = 1, ANIMATABLE_PROP_COUNT do
        local prop_name = ANIMATABLE_PROP_NAMES[index]
        local to_value = target_props[prop_name]
        if to_value ~= nil then
            local handler = PROP_HANDLERS[prop_name]
            if handler then
                props[#props + 1] = { handler, handler.get(frame), to_value }
            end
        end
    end

    if #props == 0 then
        return 0
    end

    local delay = (options and options.delay) or 0
    if delay < 0 then
        delay = 0
    end

    local tween_id = next_tween_id
    next_tween_id = next_tween_id + 1

    local tween = {
        id = tween_id,
        frame = frame,
        props = props,
        duration = (duration and duration > 0) and duration or 0.001,
        elapsed = -delay,
        easing = ease_func,
        on_complete = options and options.on_complete or nil,
        on_update = options and options.on_update or nil,
        cancelled = false,
    }

    active_count = active_count + 1
    active_tweens[active_count] = tween
    ensureTickLoopRunning()

    return tween_id
end

--[[
    取消指定补间动画
    @param tween_id number Tween.animate 返回的 id
    @return boolean 是否找到并成功标记取消
    @usage Tween.cancel(id)
--]]
function Tween.cancel(tween_id)
    for index = 1, active_count do
        local tween = active_tweens[index]
        if tween and tween.id == tween_id then
            tween.cancelled = true
            return true
        end
    end
    return false
end

--[[
    取消某个 frame 上的所有补间动画
    @param frame table 目标 frame
    @usage Tween.cancelAll(frame)
--]]
function Tween.cancelAll(frame)
    for index = 1, active_count do
        local tween = active_tweens[index]
        if tween and tween.frame == frame then
            tween.cancelled = true
        end
    end
end

-- ============================================================================
--  注入 Frame 便捷方法
-- ============================================================================

local Frame = require "Core.UI.Frame"

--[[
    Frame 语法糖：直接从实例上启动动画
    @param frame table 当前 frame
    @param target_props table 目标属性表
    @param duration number 动画时长
    @param easing string|function 缓动
    @param options table|nil 额外选项
    @return number tween_id
    @usage frame:animate({ alpha = 0 }, 0.3, "easeOut")
--]]
function Frame.animate(frame, target_props, duration, easing, options)
    return Tween.animate(frame, target_props, duration, easing, options)
end

--[[
    Frame 语法糖：停止当前 frame 的全部动画
    @param frame table 当前 frame
    @usage frame:stopAnimate()
--]]
function Frame.stopAnimate(frame)
    Tween.cancelAll(frame)
end

return Tween
