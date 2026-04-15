--[[
================================================================================
                        Texture 简单贴图组件（CSimpleTexture）

    轻量级贴图组件，用于显示静态图片。
    与 Panel（BACKDROP）相比，Texture 不支持子级 frame，但更轻量。

    使用场景：
      - 纯装饰性图片（图标、分隔线、背景花纹等）
      - 需要混合模式效果的贴图
      - 不需要子级的轻量贴图
================================================================================
--]]

local Jass = require "Lib.API.Jass"
local Class = require "Lib.Base.Class"
local Panel = require "Core.UI.Panel"

local color_modify = Class.modify_field("color")

local Texture = Class("Texture", {
    __baseclass__ = Panel,

    __constructor__ = function(_, template)
        if type(template) ~= "table" then return end

        local parent_handle
        if type(template.parent) == "table" then
            parent_handle = template.parent.handle
        else
            parent_handle = Jass.MHUI_GetGameUI()
        end

        return {
            handle = Jass.MHFrame_CreateSimpleTexture(parent_handle),
        }
    end,

    __init__ = function(_, texture, template)
        if template.color ~= nil then
            texture.color = template.color
        end

        if template.blend_mode ~= nil then
            texture.blend_mode = template.blend_mode
        end
    end,

    __attributes__ = {
        {
            name = "color",
            get = function(texture, _)
                return texture[color_modify]
            end,
            set = function(texture, _, color_value)
                Jass.MHFrame_SetColor(texture.handle, color_value)
                texture[color_modify] = color_value
            end,
        },

        {
            name = "blend_mode",
            get = function(texture, _)
                return Jass.MHFrame_GetSimpleTextureBlendMode(texture.handle)
            end,
            set = function(texture, _, blend_mode)
                Jass.MHFrame_SetSimpleTextureBlendMode(texture.handle, blend_mode)
            end,
        },
    },
})

return Texture
