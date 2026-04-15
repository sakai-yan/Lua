--[[
================================================================================
                            Model 模型组件（MODEL）

    Model 是一个相对轻量的 3D 模型显示组件。
    如果你只需要“放一个模型出来”，而不需要 Sprite 那样完整的 3D 属性控制，
    那么 Model 会更直接。

    适用场景：
    1. 简单 3D 预览
    2. 非交互模型展示
    3. 只需要设置 path 的模型组件

    设计说明：
    - 当前只暴露 `path`
    - `path` 是单参数 JASS API，因此仍保留为 attribute
    - direct constructor 支持直接写 `path`
================================================================================
--]]

local Jass = require "Lib.API.Jass"
local Class = require "Lib.Base.Class"
local Frame = require "Core.UI.Frame"

local path_modify = Class.modify_field("path")

local Model = Class("Model", {
    -- 基类
    __baseclass__ = Frame,

    -- JASS frame 类型
    __type = "MODEL",

    __constructor__ = Frame.__common_constructor,

    --[[
        Model 子类初始化
        用途：让 direct constructor 能直接吃掉 `path`

        @param _ table 当前类
        @param model table Model 实例
        @param template table 创建模板
        @usage
          local model = Model({
              parent = panel,
              level = 1,
              x = 0.1, y = 0.1,
              width = 0.1, height = 0.1,
              path = "units\\human\\Footman\\Footman.mdl",
          })
    --]]
    __init__ = function (_, model, template)
        if template.path ~= nil then
            model.path = template.path
        end
    end,

    __attributes__ = {
        {
            name = "path",
            get = function(model, key)
                return model[path_modify]
            end,
            set = function (model, key, path)
                Jass.MHFrame_SetModel(model.handle, path, 0, 0)
                model[path_modify] = path
            end
        }
    }
})

return Model
