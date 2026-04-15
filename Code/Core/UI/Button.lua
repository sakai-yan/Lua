--[[
================================================================================
                            Button 按钮组件（CSimpleButton）

    简单按钮组件，支持点击交互和多状态贴图切换。
    通过事件系统（继承自Frame）绑定点击等交互事件。

    使用场景：
      - 可点击的UI按钮（技能按钮、菜单按钮等）
      - 需要鼠标悬停高亮效果的交互元素

    用法：
      local btn = Button({
          parent = parent_frame, level = 1,
          x = 0.3, y = 0.4, width = 0.04, height = 0.04
      })
      btn:on("click", function(frame) print("clicked") end)
================================================================================
--]]

local Jass = require "Lib.API.Jass"
local Constant = require "Lib.API.Constant"
local Class = require "Lib.Base.Class"
local Frame = require "Core.UI.Frame"

local state_modify = Class.modify_field("state")

local Button

Button = Class("Button", {

    --基类
    __baseclass__ = Frame,

    __type = "SIMPLEBUTTON",

    __constructor__ = Frame.__common_constructor,

    __init__ = function (_, button, template)
        if not template then
            return
        end

        if template.state ~= nil then
            button.state = template.state
        end
    end,

    __attributes__ = {

        --[[
            按钮状态
            用途：控制按钮的显示状态（正常、按下、禁用）
            实现：调用MHFrame_SetSimpleButtonState切换JASS底层状态
            使用场景：手动切换按钮外观，如禁用按钮时切换到灰色贴图

            状态常量：
              Constant.SIMPLE_BUTTON_STATE_ENABLE   - 正常状态
              Constant.SIMPLE_BUTTON_STATE_PUSHED    - 按下状态
              Constant.SIMPLE_BUTTON_STATE_DISABLE   - 禁用状态
        --]]
        {
            name = "state",
            get = function (button, key)
                return button[state_modify]
            end,
            set = function (button, key, state)
                Jass.MHFrame_SetSimpleButtonState(button.handle, state)
                button[state_modify] = state
            end
        }
    }
})

--[[
    模拟点击按钮
    用途：通过代码触发按钮的点击效果，等同于用户鼠标点击
    实现：封装MHFrame_Click
    使用场景：自动化操作、快捷键触发按钮等
--]]
---@param button table button实例
function Button.click(button)
    Jass.MHFrame_Click(button.handle)
end

--[[
    获取按钮指定状态的贴图handle
    用途：获取按钮在不同状态下显示的贴图frame的JASS handle
    实现：封装MHFrame_GetSimpleButtonTexture
    使用场景：需要动态修改按钮某个状态的贴图时，先获取贴图handle

    状态常量：
      Constant.SIMPLE_BUTTON_STATE_ENABLE   - 正常状态贴图
      Constant.SIMPLE_BUTTON_STATE_PUSHED    - 按下状态贴图
      Constant.SIMPLE_BUTTON_STATE_DISABLE   - 禁用状态贴图
--]]
---@param button table button实例
---@param state integer 按钮状态常量（SIMPLE_BUTTON_STATE_*）
---@return integer 贴图frame的JASS handle
function Button.getTexture(button, state)
    return Jass.MHFrame_GetSimpleButtonTexture(button.handle, state)
end

--[[
    获取按钮的高亮附加显示物handle
    用途：获取鼠标悬停时显示的高亮frame的JASS handle
    实现：封装MHFrame_GetSimpleButtonAdditiveFrame
    使用场景：自定义鼠标悬停时的高亮效果
--]]
---@param button table button实例
---@return integer 高亮frame的JASS handle
function Button.getHighlight(button)
    return Jass.MHFrame_GetSimpleButtonAdditiveFrame(button.handle)
end

return Button
