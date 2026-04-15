--[[
================================================================================
                        TextArea 文本区域组件（CTextArea）

    多行文本显示组件，适合聊天框、日志框、说明区域等场景。

    设计说明：
    - value 仍然是 attribute
    - SetFont 是多参数 API，因此改为实例方法 setFont
    - 现在 direct constructor 也支持 value / font
================================================================================
--]]

local Jass = require "Lib.API.Jass"
local Class = require "Lib.Base.Class"
local Frame = require "Core.UI.Frame"

local unpack = table.unpack

local TextArea = Class("TextArea", {
    __baseclass__ = Frame,

    __type = "TEXTAREA",

    __constructor__ = Frame.__common_constructor,

    __init__ = function(_, area, template)
        if not template then
            return
        end

        if template.value ~= nil then
            area.value = template.value
        end

        if template.font ~= nil then
            area:setFont(unpack(template.font))
        end
    end,

    __attributes__ = {
        {
            name = "value",
            get = function(area, _)
                return Jass.MHFrame_GetText(area.handle)
            end,
            set = function(area, _, value)
                Jass.MHFrame_SetText(area.handle, value)
            end,
        },
    },
})

function TextArea.setFont(area, path, size, text_type)
    Jass.MHFrame_SetFont(area.handle, path, size, text_type or 0)
end

function TextArea.addText(area, text)
    Jass.MHFrame_AddTextAreaText(area.handle, text)
end

return TextArea
