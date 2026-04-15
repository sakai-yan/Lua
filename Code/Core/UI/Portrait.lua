--[[
================================================================================
                        Portrait 肖像组件（CPortraitButton）

    3D 肖像显示组件，继承自 Sprite。
    除 Sprite 的 3D 属性外，额外提供模型设置和镜头控制能力。

    使用场景：
      - 英雄头像显示
      - 3D 模型预览
      - 单位信息面板中的模型展示
================================================================================
--]]

local Jass = require "Lib.API.Jass"
local Class = require "Lib.Base.Class"
local Frame = require "Core.UI.Frame"
local Sprite = require "Core.UI.Sprite"
local Point = require "FrameWork.Manager.Point"

local path_modify = Class.modify_field("path")

local Portrait = Class("Portrait", {
    __baseclass__ = Sprite,

    __constructor__ = function(_, template)
        if type(template) ~= "table" then
            return
        end

        return {
            handle = Jass.MHFrame_CreatePortrait(template.parent.handle),
        }
    end,

    __init__ = function(class, portrait, template)
        if template.camera_x and template.camera_y and template.camera_z then
            class.setCameraPosition(portrait, template.camera_x, template.camera_y, template.camera_z)
        end

        if template.focus_x and template.focus_y and template.focus_z then
            class.setCameraFocus(portrait, template.focus_x, template.focus_y, template.focus_z)
        end
    end,

    __attributes__ = {
        {
            name = "path",
            get = function(portrait, _)
                return portrait[path_modify]
            end,
            set = function(portrait, _, path)
                Jass.MHFrame_SetPortraitModel(portrait.handle, path, 0)
                portrait[path_modify] = path
            end,
        },
    },
})

--[[
    设置肖像镜头位置
    @param portrait table Portrait 实例
    @param x number 位置x坐标
    @param y number 位置y坐标
    @param z number 位置z坐标
--]]
function Portrait.setCameraPosition(portrait, x, y, z)
    Jass.MHFrame_SetPortraitCameraPosition(portrait.handle, x, y, z)
end

--[[
    设置肖像镜头焦点
    @param portrait table Portrait 实例
    @param x number 焦点x坐标
    @param y number 焦点y坐标
    @param z number 焦点z坐标
--]]
function Portrait.setCameraFocus(portrait, x, y, z)
    Jass.MHFrame_SetPortraitCameraFocus(portrait.handle, x, y, z)
end

return Portrait
