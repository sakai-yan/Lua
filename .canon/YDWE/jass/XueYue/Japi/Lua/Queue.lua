--[[
    队列模块 v1.0
    
    队列是一个通常情况下只允许向后入队列，从头出队列的“数组”
    图例(箭头代表方向)  << 1|2|3|4|5 <<
]]
---@class mQueue 队列模块
local mQueue = {
    type = 'Module:Queue'
}

---@class cQueue 队列抽象
local cQueue = {
    type = 'Queue',
    [0] = 0,
}

--------------------------------
local ipairs = ipairs
local table_remove = table.remove
local assert = assert
local traceback = debug.traceback
local setmetatable = setmetatable
local getmetatable = getmetatable
--------------------------------

---添加元素到队列尾部
---@param elem any 元素
---@return Queue
function cQueue:put( elem )
    assert( type( elem ) ~= 'nil', traceback( '队列元素不能为nil' ) )
    self[0] = self[0] + 1
    self[self[0]] = elem
    ---@type Queue
    return self
end

---从队列头取出元素
---@return any
function cQueue:get()
    local count = self[0]
    if count < 1 then
        return nil
    end
    self[0] = count - 1
    return table_remove( self, 1 )
end

---从队列头取出元素
---@return any
function cQueue:getFromPosition( pos )
    local count = self[0]
    if count < pos then
        return nil
    end
    self[0] = count - 1
    return table_remove( self, pos )
end


--获取队列长度
---@return int
function cQueue:len()
    return self[0]
end

---初始化队列
function cQueue:init()

end

---删除队列对象
function cQueue:del()
    local mt = getmetatable( self )
    mt.__mode = 'kv'
    mt.__index = nil
    self[0] = 0
    self[1] = nil
end

---@return Queue
function mQueue:new()
    ---@class Queue : cQueue 队列实例
    local o = setmetatable({}, { __index = cQueue})
    o:init()
    return o
end



return mQueue