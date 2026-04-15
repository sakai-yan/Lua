--滑块类
local Jass = require "Lib.API.Jass"
local Class = require "Lib.Base.Class"
local Frame = require "Core.UI.Frame"

local max_limit_modify = Class.modify_field("max_limit")
local min_limit_modify = Class.modify_field("min_limit")

local DEFAULT_MIN_LIMIT = 0
local DEFAULT_MAX_LIMIT = 100

local Slider

Slider = Class("Slider", {

    --基类
    __baseclass__ = Frame,

    __type = "SLIDER",

    __constructor__ = Frame.__common_constructor,

    __init__ = function (_, slider, template)
        if not template then
            return
        end

        if template.min_limit ~= nil then
            slider.min_limit = template.min_limit
        end

        if template.max_limit ~= nil then
            slider.max_limit = template.max_limit
        end

        if template.value ~= nil then
            slider.value = template.value
        end
    end,

    __attributes__ = {

        ---@数值 number 类似进度条的进度
        {
            name = "value",
            get = function (slider, key)
                return Jass.MHFrame_GetValue(slider.handle)
            end,
            set = function (slider, key, value)
                Jass.MHFrame_SetValue(slider.handle, value)
            end
        },

        ---@最大数值限制 boolean
        {
            name = "max_limit",
            get = function (slider, key)
                local value = slider[max_limit_modify]
                if value ~= nil then
                    return value
                end
                return DEFAULT_MAX_LIMIT
            end,
            set = function (slider, key, max_limit)
                local min_limit = slider[min_limit_modify]
                if min_limit == nil then
                    min_limit = DEFAULT_MIN_LIMIT
                    slider[min_limit_modify] = min_limit
                end
                Jass.MHFrame_SetLimit(slider.handle, max_limit, min_limit)
                slider[max_limit_modify] = max_limit
            end
        },

        ---@最小数值限制 boolean
        {
            name = "min_limit",
            get = function (slider, key)
                local value = slider[min_limit_modify]
                if value ~= nil then
                    return value
                end
                return DEFAULT_MIN_LIMIT
            end,
            set = function (slider, key, min_limit)
                local max_limit = slider[max_limit_modify]
                if max_limit == nil then
                    max_limit = DEFAULT_MAX_LIMIT
                    slider[max_limit_modify] = max_limit
                end
                Jass.MHFrame_SetLimit(slider.handle, max_limit, min_limit)
                slider[min_limit_modify] = min_limit
            end
        }
        
    }
})

--[[
    为滑块添加边框和背景（类似CSS的border + background）
    用途：给Slider添加可视化的边框和背景贴图
    实现：封装MHFrame_AddBorder，传递边框贴图、背景贴图及相关参数
    使用场景：进度条需要边框装饰、滑块需要背景底图等

    用法：
      slider:addBorder("border.blp", "bg.blp", 0, 0.01, 0.005, false)
--]]
---@param slider table slider实例
---@param border_file string 边框贴图路径
---@param bg_file string 背景贴图路径
---@param flag integer 边框标志
---@param border_size number 边框尺寸
---@param padding number 填充尺寸
---@param is_tile boolean 是否平铺
function Slider.addBorder(slider, border_file, bg_file, flag, border_size, padding, is_tile)
    Jass.MHFrame_AddBorder(slider.handle, border_file, bg_file, flag, border_size, padding, is_tile)
end

return Slider
