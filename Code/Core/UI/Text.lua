--[[
================================================================================
                            Text 文本组件（CTEXT）

    标准文本组件，适合显示标题、说明、数值等内容。

    当前设计说明：
    1. 单参数 JASS API 仍然保留为 attribute，例如 value / color / limit
    2. 多参数 JASS API 改为实例方法，例如 setFont / setAlign
       这样比把 table 塞进 attribute 更直接，也更容易让新手理解
    3. direct constructor 现在支持在 template 中直接传入文本专属字段，
       因此可以在创建时一次性完成常用初始化

    direct constructor 示例：
      local text = Text({
          parent = panel,
          level = 2,
          x = 0.2, y = 0.3,
          width = 0.2, height = 0.03,
          is_show = true,
          alpha = 255,
          value = "标题",
          font = { "Fonts\\FZXS14.ttf", 0.018 },
          align = { Constant.TEXT_VERTEX_ALIGN_CENTER, Constant.TEXT_HORIZON_ALIGN_CENTER },
      })

    运行时方法示例：
      text:setFont("Fonts\\FZXS14.ttf", 0.018)
      text:setAlign(Constant.TEXT_VERTEX_ALIGN_CENTER, Constant.TEXT_HORIZON_ALIGN_CENTER)
================================================================================
--]]

local Jass = require "Lib.API.Jass"
local Constant = require "Lib.API.Constant"
local Class = require "Lib.Base.Class"
local Point = require "FrameWork.Manager.Point"
local Frame = require "Core.UI.Frame"

local unpack = table.unpack

local shadow_off_modify = Class.modify_field("shadow_off")
local color_modify = Class.modify_field("color")

local Text = Class("Text", {
    -- 基类
    __baseclass__ = Frame,

    __type = "TEXT",

    __constructor__ = Frame.__common_constructor,

    --[[
        子类初始化
        设计：
          - Frame.__init__ 先负责通用字段
          - 这里再负责 Text 自己的专属字段
    --]]
    __init__ = function(_, text, template)
        if not template then
            return
        end

        if template.value ~= nil then
            text.value = template.value
        end

        if template.font ~= nil then
            text:setFont(unpack(template.font))
        end

        if template.font_height ~= nil then
            text.font_height = template.font_height
        end

        if template.align ~= nil then
            text:setAlign(unpack(template.align))
        end

        if template.limit ~= nil then
            text.limit = template.limit
        end

        if template.flag ~= nil then
            text.flag = template.flag
        end

        if template.style ~= nil then
            text.style = template.style
        end

        if template.shadow_off ~= nil then
            text.shadow_off = template.shadow_off
        end

        if template.color ~= nil then
            text.color = template.color
        end

        if template.normal_color ~= nil then
            text.normal_color = template.normal_color
        end

        if template.disable_color ~= nil then
            text.disable_color = template.disable_color
        end

        if template.highlight_color ~= nil then
            text.highlight_color = template.highlight_color
        end

        if template.shadow_color ~= nil then
            text.shadow_color = template.shadow_color
        end
    end,

    __attributes__ = {
        -- 字体高度：单参数 setter，保留为 attribute
        {
            name = "font_height",
            set = function(text, _, value)
                Jass.MHFrame_SetFontHeight(text.handle, value)
            end,
        },

        -- 文本内容
        {
            name = "value",
            get = function(text, _)
                return Jass.MHFrame_GetText(text.handle)
            end,
            set = function(text, _, value)
                Jass.MHFrame_SetText(text.handle, value)
            end,
        },

        -- 文本长度限制
        {
            name = "limit",
            get = function(text, _)
                return Jass.MHFrame_GetTextLimit(text.handle)
            end,
            set = function(text, _, value)
                Jass.MHFrame_SetTextLimit(text.handle, value)
            end,
        },

        -- 文本 flag bitset
        {
            name = "flag",
            get = function(text, _)
                return Jass.MHFrame_GetTextFlag(text.handle)
            end,
            set = function(text, _, value)
                Jass.MHFrame_SetTextFlag(text.handle, value)
            end,
        },

        -- 文本 style bitset
        {
            name = "style",
            get = function(text, _)
                return Jass.MHFrame_GetTextStyle(text.handle)
            end,
            set = function(text, _, value)
                Jass.MHFrame_SetTextStyle(text.handle, value)
            end,
        },

        -- 阴影偏移
        {
            name = "shadow_off",
            get = function(text, _)
                return text[shadow_off_modify]
            end,
            set = function(text, _, point)
                local x, y = Point.get(point)
                Jass.MHFrame_SetTextShadowOff(text.handle, x, y)
                text[shadow_off_modify] = point
            end,
        },

        -- 叠加颜色
        {
            name = "color",
            get = function(text, _)
                return text[color_modify]
            end,
            set = function(text, _, color_value)
                Jass.MHFrame_SetColor(text.handle, color_value)
                text[color_modify] = color_value
            end,
        },

        -- 正常文本颜色
        {
            name = "normal_color",
            get = function(text, _)
                return Jass.MHFrame_GetTextColor(text.handle, Constant.TEXT_COLOR_NORMAL)
            end,
            set = function(text, _, value)
                Jass.MHFrame_SetTextColor(text.handle, Constant.TEXT_COLOR_NORMAL, value)
            end,
        },

        -- 禁用文本颜色
        {
            name = "disable_color",
            get = function(text, _)
                return Jass.MHFrame_GetTextColor(text.handle, Constant.TEXT_COLOR_DISABLED)
            end,
            set = function(text, _, value)
                Jass.MHFrame_SetTextColor(text.handle, Constant.TEXT_COLOR_DISABLED, value)
            end,
        },

        -- 高亮文本颜色
        {
            name = "highlight_color",
            get = function(text, _)
                return Jass.MHFrame_GetTextColor(text.handle, Constant.TEXT_COLOR_HIGHLIGHT)
            end,
            set = function(text, _, value)
                Jass.MHFrame_SetTextColor(text.handle, Constant.TEXT_COLOR_HIGHLIGHT, value)
            end,
        },

        -- 阴影颜色
        {
            name = "shadow_color",
            get = function(text, _)
                return Jass.MHFrame_GetTextColor(text.handle, Constant.TEXT_COLOR_SHADOW)
            end,
            set = function(text, _, value)
                Jass.MHFrame_SetTextColor(text.handle, Constant.TEXT_COLOR_SHADOW, value)
            end,
        },
    },
})

--[[
    设置字体
    为什么做成方法：
      - 底层 JASS API 本身就是多参数
      - 用方法表达比 `text.font = { ... }` 更直观
    使用方法：
      text:setFont("Fonts\\FZXS14.ttf", 0.02)
      text:setFont("Fonts\\FZXS14.ttf", 0.02, Constant.TEXT_TYPE_NORMAL)
--]]
function Text.setFont(text, path, size, text_type)
    Jass.MHFrame_SetFont(text.handle, path, size, text_type or 0)
end

--[[
    设置文本对齐
    使用方法：
      text:setAlign(Constant.TEXT_VERTEX_ALIGN_CENTER, Constant.TEXT_HORIZON_ALIGN_CENTER)
--]]
function Text.setAlign(text, vertical_align, horizontal_align)
    Jass.MHFrame_SetTextAlign(text.handle, vertical_align, horizontal_align)
end

return Text
