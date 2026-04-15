---@diagnostic disable: undefined-field

local class = {}
class.__index = class

---@class c_trigger
local trigger = {}
trigger.__index = trigger

local CreateTrigger = cj.CreateTrigger
local TriggerAddAction = cj.TriggerAddAction
local DestroyTrigger = cj.DestroyTrigger
local EnableTrigger = cj.EnableTrigger
local DisableTrigger = cj.DisableTrigger
local setmetatable = setmetatable

--新建触发器
---@param action function 可选 触发器动作
---@return trigger
function class:new( action )
    ---@class trigger : c_trigger 触发器对象
    local trg = {
        handle = CreateTrigger(),
        actions = {},
    }
    --debug.handle_ref( trg.handle )
    setmetatable( trg, trigger )
    if action then
        trg:action( action )
    end

    return trg
end

--添加触发器动作
---@param action func 触发器动作
function trigger:action( action )
    TriggerAddAction( self.handle, action )
    return self
end

--删除触发器
function trigger:del()

    DestroyTrigger(self.handle)
    --debug.handle_unref( self.handle )
    setmetatable( self, { __mode = 'kv' } )

end

--启用/禁用触发器
---@param bool bool 显示/隐藏
---@return self
function trigger:enable( bool )
    if bool then
        EnableTrigger( self.handle )
    else
        DisableTrigger( self.handle )
    end
    return self
end

return class