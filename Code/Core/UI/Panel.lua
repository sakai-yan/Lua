--[[
================================================================================
                            Panel 贴图容器（BACKDROP）

    Panel 是最常用的基础容器之一，通常可以把它理解成 HTML 里的 `<div>`。
    它既可以作为纯背景，也可以作为其他 UI 的父容器。

    适用场景：
    1. 面板背景
    2. 带贴图的容器
    3. 纯色块或装饰底图

    设计说明：
    - `image` / `is_tile` / `color` 都是单参数 JASS API，因此仍然保留为 attribute
    - direct constructor 现在支持直接传入这些贴图专属字段，减少“先创建再赋值”的样板代码

    direct constructor 用法：
      local panel = Panel({
          parent = game_ui,
          level = 1,
          x = 0.2, y = 0.3,
          width = 0.2, height = 0.15,
          is_show = true,
          alpha = 220,
          image = "war3mapImported\\panel_bg.blp",
          color = 0xFFFFFFFF,
      })
================================================================================
--]]

local Jass = require "Lib.API.Jass"
local Class = require "Lib.Base.Class"
local Frame = require "Core.UI.Frame"

local image_modify = Class.modify_field("image")
local is_tile_modify = Class.modify_field("is_tile")

local Panel = Class("Panel", {
    -- 基类
    __baseclass__ = Frame,

    -- JASS frame 类型
    __type = "BACKDROP",

    -- 复用 Frame 通用构造器
    __constructor__ = Frame.__common_constructor,

    --[[
        Panel 子类初始化
        为什么这样设计：
        - Frame.__init__ 先负责通用字段
        - Panel.__init__ 再负责贴图相关的组件专属字段

        @param _ table 当前类
        @param panel table Panel 实例
        @param template table 创建模板
        @usage
          local panel = Panel({
              parent = parent_frame,
              level = 1,
              x = 0.1, y = 0.1,
              width = 0.1, height = 0.1,
              image = "xxx.blp",
          })
    --]]
    __init__ = function (_, panel, template)
        if not template then
            return
        end

        if template.image ~= nil then
            panel.image = template.image
        end

        if template.is_tile ~= nil then
            panel.is_tile = template.is_tile
        end
    end,

    __attributes__ = {
        -- 贴图路径
        {
            name = "image",
            get = function (panel, key)
                return panel[image_modify]
            end,
            set = function (panel, key, path)
                Jass.MHFrame_SetTexture(panel.handle, path, false)
                panel[image_modify] = path
            end
        },

        -- 是否平铺
        {
            name = "is_tile",
            get = function (panel, key)
                return panel[is_tile_modify]
            end,
            set = function (panel, key, is_tile)
                Jass.MHFrame_SetTexture(panel.handle, panel[image_modify], is_tile)
                panel[is_tile_modify] = is_tile
            end
        }
    }
})

--[[
    为Panel添加边框和背景（类似CSS的border + background）
    用途：给Panel添加可视化的边框和背景贴图
    实现：封装MHFrame_AddBorder，传递边框贴图、背景贴图及相关参数
    使用场景：面板需要边框装饰、背景底图等

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
function Panel.addBorder(slider, border_file, bg_file, flag, border_size, padding, is_tile)
    Jass.MHFrame_AddBorder(slider.handle, border_file, bg_file, flag, border_size, padding, is_tile)
end

return Panel
