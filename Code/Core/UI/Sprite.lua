local Jass = require "Lib.API.Jass"
local Class = require "Lib.Base.Class"
local Model = require "Core.UI.Model"
local Frame = require "Core.UI.Frame"

local roll_modify = Class.modify_field("roll")
local pitch_modify = Class.modify_field("pitch")
local yaw_modify = Class.modify_field("yaw")
local scale_modify = Class.modify_field("scale")
local x_scale_modify = Class.modify_field("x_scale")
local y_scale_modify = Class.modify_field("y_scale")
local z_scale_modify = Class.modify_field("z_scale")
local color_modify = Class.modify_field("color")
local animation_modify = Class.modify_field("animation")

local function get_axis_scale(sprite, axis_modify)
    local value = sprite[axis_modify]
    if value ~= nil then
        return value
    end

    value = sprite[scale_modify]
    if value ~= nil then
        return value
    end

    return 1
end

local function sync_uniform_scale(sprite)
    local x_scale = sprite[x_scale_modify]
    local y_scale = sprite[y_scale_modify]
    local z_scale = sprite[z_scale_modify]
    if x_scale ~= nil and x_scale == y_scale and y_scale == z_scale then
        sprite[scale_modify] = x_scale
    else
        sprite[scale_modify] = nil
    end
end

local Sprite

Sprite = Class("Sprite", {

    --基类
    __baseclass__ = Model,

    __type = "SPRITE",

    __constructor__ = Frame.__common_constructor,

    __init__ = function (_, sprite, template)
        if not template then
            return
        end

        if template.roll ~= nil then
            sprite.roll = template.roll
        end

        if template.pitch ~= nil then
            sprite.pitch = template.pitch
        end

        if template.yaw ~= nil then
            sprite.yaw = template.yaw
        end

        if template.scale ~= nil then
            sprite.scale = template.scale
        end

        if template.x_scale ~= nil then
            sprite.x_scale = template.x_scale
        end

        if template.y_scale ~= nil then
            sprite.y_scale = template.y_scale
        end

        if template.z_scale ~= nil then
            sprite.z_scale = template.z_scale
        end

        if template.color ~= nil then
            sprite.color = template.color
        end

        if template.animation ~= nil then
            sprite.animation = template.animation
        end

        if template.animation_progress ~= nil then
            sprite.animation_progress = template.animation_progress
        end
    end,

    __attributes__ = {

        ---@X坐标 number
        {
            name = "x",
            get = function (sprite, key)
                return Jass.MHFrame_GetSpriteX(sprite.handle)
            end,
            set = function (sprite, key, x)
                Jass.MHFrame_SetSpriteX(sprite.handle, x)
            end
        },

        ---@Y坐标 number
        {
            name = "y",
            get = function (sprite, key)
                return Jass.MHFrame_GetSpriteY(sprite.handle)
            end,
            set = function (sprite, key, y)
                Jass.MHFrame_SetSpriteY(sprite.handle, y)
            end
        },

        ---@Z坐标 number
        {
            name = "z",
            get = function (sprite, key)
                return Jass.MHFrame_GetSpriteZ(sprite.handle)
            end,
            set = function (sprite, key, z)
                Jass.MHFrame_SetSpriteZ(sprite.handle, z)
            end
        },

        ---@横滚角 number 绕X转角, 角度制
        {
            name = "roll",
            get = function (sprite, key)
                return sprite[roll_modify]
            end,
            set = function (sprite, key, roll)
                Jass.MHFrame_SetSpriteRoll(sprite.handle, roll)
                sprite[roll_modify] = roll
            end
        },

        ---@俯仰角 number 绕X转角, 角度制
        {
            name = "pitch",
            get = function (sprite, key)
                return sprite[pitch_modify]
            end,
            set = function (sprite, key, pitch)
                Jass.MHFrame_SetSpritePitch(sprite.handle, pitch)
                sprite[pitch_modify] = pitch
            end
        },

        ---@偏航角 number 绕X转角, 角度制
        {
            name = "yaw",
            get = function (sprite, key)
                return sprite[yaw_modify]
            end,
            set = function (sprite, key, yaw)
                Jass.MHFrame_SetSpriteYaw(sprite.handle, yaw)
                sprite[yaw_modify] = yaw
            end
        },

        ---@缩放 number 整体缩放
        {
            name = "scale",
            get = function (sprite, key)
                local value = sprite[scale_modify]
                if value ~= nil then
                    return value
                end
                local x_scale = sprite[x_scale_modify]
                local y_scale = sprite[y_scale_modify]
                local z_scale = sprite[z_scale_modify]
                if x_scale ~= nil and x_scale == y_scale and y_scale == z_scale then
                    return x_scale
                end
                return 1
            end,
            set = function (sprite, key, scale)
                Jass.MHFrame_SetSpriteScale(sprite.handle, scale)
                sprite[scale_modify] = scale
                sprite[x_scale_modify] = scale
                sprite[y_scale_modify] = scale
                sprite[z_scale_modify] = scale
            end
        },

        ---@X缩放 number 整体缩放
        ---@usage sprite.x_scale
        ---@usage sprite.x_scale = 2
        {
            name = "x_scale",
            get = function (sprite, key)
                return get_axis_scale(sprite, x_scale_modify)
            end,
            set = function (sprite, key, x_scale)
                local y_scale = get_axis_scale(sprite, y_scale_modify)
                local z_scale = get_axis_scale(sprite, z_scale_modify)
                Jass.MHFrame_SetSpriteScaleEx(sprite.handle, x_scale, y_scale, z_scale)
                sprite[x_scale_modify] = x_scale
                sync_uniform_scale(sprite)
            end
        },

        ---@缩放 number 整体缩放
        ---@usage sprite.y_scale
        ---@usage sprite.y_scale = 2
        {
            name = "y_scale",
            get = function (sprite, key)
                return get_axis_scale(sprite, y_scale_modify)
            end,
            set = function (sprite, key, y_scale)
                local x_scale = get_axis_scale(sprite, x_scale_modify)
                local z_scale = get_axis_scale(sprite, z_scale_modify)
                Jass.MHFrame_SetSpriteScaleEx(sprite.handle, x_scale, y_scale, z_scale)
                sprite[y_scale_modify] = y_scale
                sync_uniform_scale(sprite)
            end
        },

        ---@缩放 number 整体缩放
        ---@usage sprite.z_scale
        ---@usage sprite.z_scale = 2
        {
            name = "z_scale",
            get = function (sprite, key)
                return get_axis_scale(sprite, z_scale_modify)
            end,
            set = function (sprite, key, z_scale)
                local x_scale = get_axis_scale(sprite, x_scale_modify)
                local y_scale = get_axis_scale(sprite, y_scale_modify)
                Jass.MHFrame_SetSpriteScaleEx(sprite.handle, x_scale, y_scale, z_scale)
                sprite[z_scale_modify] = z_scale
                sync_uniform_scale(sprite)
            end
        },

        ---@颜色 number 16进制颜色代码
        ---@usage sprite.color
        ---@usage sprite.color = 0xFFFF0000
        {
            name = "color",
            get = function (sprite, key)
                return sprite[color_modify]
            end,
            set = function (sprite, key, color)
                Jass.MHFrame_SetSpriteColor(sprite.handle, color)
                sprite[color_modify] = color
            end
        },

        ---@动画名称 string 动画名称 无附加动画名
        ---@usage sprite.animation
        ---@usage sprite.animation = "stand"
        {
            name = "animation",
            get = function (sprite, key)
                return sprite[animation_modify]
            end,
            set = function (sprite, key, animation_name)
                Jass.MHFrame_SetSpriteAnimation(sprite.handle, animation_name, nil)
                sprite[animation_modify] = animation_name
            end
        },

        ---@动画进度 number 动画进度 0~1
        ---@usage sprite.animation_progress
        ---@usage sprite.animation_progress = 0.5
        {
            name = "animation_progress",
            get = function (sprite, key)
                return Jass.MHFrame_GetSpriteAnimationProgress(sprite.handle)
            end,
            set = function (sprite, key, animation_progress)
                Jass.MHFrame_SetSpriteAnimationProgress(sprite.handle, animation_progress)
            end
        }
    }
})

--设置坐标
---@param sprite table Sprite对象
---@param x number X坐标
---@param y number Y坐标
---@param z number Z坐标
function Sprite.setPosition(sprite, x, y, z)
    Jass.MHFrame_SetSpritePosition(sprite.handle, x, y, z)
end

--设置缩放
---@param sprite table Sprite对象
---@param x_scale number X缩放
---@param y_scale number Y缩放
---@param z_scale number Z缩放
function Sprite.setScaleEx(sprite, x_scale, y_scale, z_scale)
    Jass.MHFrame_SetSpriteScaleEx(sprite.handle, x_scale, y_scale, z_scale)
    sprite[x_scale_modify] = x_scale
    sprite[y_scale_modify] = y_scale
    sprite[z_scale_modify] = z_scale
    sync_uniform_scale(sprite)
end

--设置动画
---@param sprite table Sprite对象
---@param animation_name string 动画名称
---@param attach_animation_name string 附加动画名称
function Sprite.setAnimation(sprite, animation_name, attach_animation_name)
    Jass.MHFrame_SetSpriteAnimation(sprite.handle, animation_name, attach_animation_name)
    sprite[animation_modify] = animation_name
end

--设置贴图
---@param sprite table Sprite对象
---@param texture string 贴图路径
---@param id integer 贴图ID?
function Sprite.setImage(sprite, texture, id)
    Jass.MHFrame_SetSpriteTexture(sprite.handle, texture, id)
end

return Sprite
