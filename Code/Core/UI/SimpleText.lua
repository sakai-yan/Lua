--[[
================================================================================
                        SimpleText 简单文本组件（CSimpleFontString）

    轻量级文本组件，用于显示静态文本。
    与 Text 相比，SimpleText 不支持子级 frame，但更轻量。

    设计说明：
    - 单参数 API 保留为 attribute
    - 多参数 API（如 SetFont / SetTextAlign）改成实例方法
    - 专用创建 API 的子类自己显式完成 __init__
================================================================================
--]]

local Jass = require "Lib.API.Jass"
local Class = require "Lib.Base.Class"
local Frame = require "Core.UI.Frame"
local Point = require "FrameWork.Manager.Point"

local unpack = table.unpack

local color_modify = Class.modify_field("color")

local SimpleText = Class("SimpleText", {
    __baseclass__ = Frame,

    __constructor__ = function(_, template)
        if type(template) ~= "table" then return end

        local parent_handle
        if type(template.parent) == "table" then
            parent_handle = template.parent.handle
        else
            parent_handle = Jass.MHUI_GetGameUI()
        end

        return {
            handle = Jass.MHFrame_CreateSimpleFontString(parent_handle),
        }
    end,

    __init__ = function(_, text, template)
        if template.value ~= nil then
            text.value = template.value
        end

        if template.font ~= nil then
            text:setFont(template.font[1], template.font[2], template.font[3])
        end

        if template.font_height ~= nil then
            text.font_height = template.font_height
        end

        if template.align ~= nil then
            text:setAlign(template.align[1], template.align[2])
        end

        if template.limit ~= nil then
            text.limit = template.limit
        end

        if template.color ~= nil then
            text.color = template.color
        end
    end,

    __attributes__ = {
        {
            name = "value",
            get = function(text, _)
                return Jass.MHFrame_GetText(text.handle)
            end,
            set = function(text, _, value)
                Jass.MHFrame_SetText(text.handle, value)
            end,
        },

        {
            name = "font_height",
            set = function(text, _, value)
                Jass.MHFrame_SetFontHeight(text.handle, value)
            end,
        },

        {
            name = "limit",
            get = function(text, _)
                return Jass.MHFrame_GetTextLimit(text.handle)
            end,
            set = function(text, _, value)
                Jass.MHFrame_SetTextLimit(text.handle, value)
            end,
        },

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
    },
})

function SimpleText.setFont(text, path, size, text_type)
    Jass.MHFrame_SetFont(text.handle, path, size, text_type or 0)
end

function SimpleText.setAlign(text, vertical_align, horizontal_align)
    Jass.MHFrame_SetTextAlign(text.handle, vertical_align, horizontal_align)
end

return SimpleText
