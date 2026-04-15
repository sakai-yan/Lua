--[==[
    事件池模块  1.0
    ---@author:  2022-02-16 18:35:55

    雪月灬雪歌
]==]
local function table_insert(tb, val)
    local c = (tb[0] or 0) + 1
    tb[0] = c
    tb[c] = val
end

local pools = {}
---@class m_EventPool 模块
local module = {

    type = 'module',
    module = 'EventPool',

    --存放所有事件池
    pools = pools,
}
module.__index = module

---@class c_EventPool 事件类
---@field events event<string,table>
local class = {
    type = 'class',
    class = 'EventPool',

}
class.__index = class


--------------------------------
--         事件池模块
--------------------------------

--模块：新增一个事件池
---@param tag any 事件池标签
function module:new( tag )
    ---@class EventPool : c_EventPool  事件池对象 可以调用类方法
    local pool = {
        type = 'EventPool',
        events = {},--存储 所有事件类。
        names = {}, --存储事件名称
        tag = tag, --事件池标签
        module = self,
    }
    setmetatable( pool, {
        __index = class
    } )
    if not pools[ tag ] then
        pools[ tag ] = {}
    end
    table_insert( pools[tag], pool )
    return pool
end

--通知 指定标签 tag 的事件池
function module:notify( tag, name, ... )
    local list = pools[tag]

    if not list then
        return
    end

    local i = 1
    local pool = list[i]
    local check
    while pool do

        pool:update( name, ... )

        check = list[i]
        if pool ~= check then
            pool = check
        else
            i = i + 1
            pool = list[i]
        end
    end

end

--删除指定标签 tag 的事件池
function module:del( tag )
    if not pools[tag] then
        return
    end
    local tagPools = pools[tag]
    local i,len = 1, tagPools[0] or 0
    while i<=len do
        local pool = tagPools[i]
        pool.tag = nil
        pool.events = nil
        pool.module = nil
        tagPools[i] = nil
    end
    pools[tag] = nil
end


--------------------------------
--         事件池类
--------------------------------

---通知事件触发 调用事件on_update
---@param name any 事件名称
---@param ... any  传递参数 如需动态值参数 建议自己建立表
---@return ... @原值返回
function class:update( name, ... )
    local list = self.events[name] or {}
    local i = 1
    local event = list[i]
    local check
    while event do

        local func = event.on_update

        if func then
            func( event, ... )
        end

        check = list[i]
        if event ~= check then
            event = check
        else
            i = i + 1
            event = list[i]
        end
    end

    return ...
end

---@class cEvent
---@field pool EventPool 所属事件池
---@field name string 事件名
---@field on_update fun(event:event, params:table ) 事件回调
local event = {}


--事件池：新增一个事件 通过赋值事件的 on_update来设置更新回调
---@param name any 事件名称
---@return event
function class:new( name )
    ---@class event : cEvent 事件实例
    local t = {
        type = 'event',
        --notify = module.notify,
        pool = self,  --保存所属事件池
        name = name,
    }
    --新建元表 方便设置mode
    setmetatable( t, {
        __index = event
    } )

    if not self.events[name] then
        self.events[name] = {}
        table_insert( self.names, name )
    end

    table.insert(self.events[name], t )
    return t
end

---销毁事件池
function class:del()
    --销毁池子里所有事件
    for index, name in ipairs(self.names) do
        local i = 1
        local evts = self.events[name]
        local evt = evts[i]
        
        while evt do
            table.kv(evts[i])
            evts[i] = nil
            i=i+1
            evt = evts[i]
        end
    end
    --销毁池子
    local _pools = pools[self.tag]
    for index, pool in ipairs(_pools) do
        if pool == self then
            pool.tag = nil
            pool.events = nil
            pool.module = nil
            table.remove(_pools, index)
            table.kv(self)
            _pools[0] = _pools[0] - 1
            break
        end
    end

end

--------------------------------
--         事件类
--------------------------------

--销毁事件
function event:del()
    local list = self.pool.events[self.name]
    for index, evt in ipairs(list) do
        if evt == self then
            table.kv(self)
            table.remove(list, index)
            return
        end
    end
end



return module