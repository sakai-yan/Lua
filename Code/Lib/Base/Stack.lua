local DataType = require "Lib.Base.DataType"
local setmetatable = setmetatable
local type = type
local math_type = math.type
local math_min = math.min
local math_floor = math.floor


local Stack = {}
--//@栈的索引逻辑是从栈顶开始

--代理表中有capacity	version字段	

--//@栈索引，以代理表为索引获取栈所在的表
local private = {}
--设置private为弱键表
table.setmode(private, "k")

--//@压栈操作
local function __push(self, value)
	if value == nil then return end
	local stack = private[self]
	local index = #stack + 1
	stack[index] = value
	self.version = self.version + 1
	return stack
end

--//@带限制的压栈操作
local function __pushEx(self, value)
	local stack = private[self]
	local index = #stack + 1
	if value == nil or index > self.capacity then return end
	stack[index] = value
	self.version = self.version + 1
	return stack
end

--//@批量压栈
--//@values		table
local function __pushAll(self, values)
	if type(values) ~= 'table' or #values <= 0 then
        return private[self]
    end
	local stack = private[self]
	local count = #stack
	for index = 1, #values do
		 stack[count + index] = values[index]
	end
	self.version = self.version + 1
    return stack
end

--//@带限制的批量压栈
--//@values		table
local function __pushAllEx(self, values)
    if type(values) ~= 'table' or #values <= 0 then
        return private[self]
    end
	local stack = private[self]
	local count = #stack
	local max = math_min(self.capacity - count, #values)
	for index = 1, max do
		 stack[count + index] = values[index]
	end
	self.version = self.version + 1
    return stack
end

--//@弹栈操作
local function __pop(self)
	local stack = private[self]
	local index = #stack
	if index == 0 then
		return nil
	end
	local value = stack[index]
	stack[index] = nil
	self.version = self.version + 1
    return value
end

--//@查看栈顶
local function __peek(self)
    local stack = private[self]
	return stack[#stack]
end

--//@获取大小
local function __size(self)
	return #private[self]
end

--//@是否空栈
local function __empty(self)
	return #private[self] == 0
end

--//@清空栈
local function __clear(self)
	local stack = private[self]
	for index = #stack, 1, -1 do
		stack[index] = nil
	end
	self.version = self.version + 1
end

--调整栈容量
local function __setCapacity(self, new_capacity)
	if not new_capacity or type(new_capacity) ~= "number" or new_capacity <= 0 then
		return false
	end
	if math_type(new_capacity) ~= 'integer' then
		new_capacity = math_floor(new_capacity)
	end
	local stack = private[self]
	--//如果新容量小于当前栈大小，需要截断
	local top = #stack
	if top > new_capacity then
		for index = top, new_capacity + 1, -1 do
			stack[index] = nil
		end
	end
	self.capacity = new_capacity
	self.version = self.version + 1
	return true
end

--//@高效迭代器
--//@返回的索引是从栈顶开始计数，栈顶为1
local function __iterator(self)
    local stack = private[self]
	local version = self.version
    local top = #stack
	local index = top
    return function()
        if version ~= self.version then
			error("迭代期间栈已经被修改")
		end
		if index >= 1 then
			local pos_from_top = top - index + 1
			local value = stack[index]
			index = index - 1
			return pos_from_top, value
		end
		return nil
    end
end

--//@查找元素
--//@可用 if __find(self, value) then		来判断是否存在该元素
local function __find(self, value)
    local stack = private[self]
	local top = #stack
	for index = top, 1, -1 do
        if stack[index] == value then
            return top - index + 1
        end
    end
    return nil
end

--//@获取栈中指定位置的元素（从栈顶开始计数）
local function __get(self, index_from_top)
    local stack = private[self]
	local top = #stack
	if index_from_top < 1 or index_from_top > top then
        return nil
    end
    return stack[top - index_from_top + 1]
end

--//@统计元素出现次数
local function __count(self, value)
    local stack = private[self]
	local count = 0
    for index = 1, #stack do
        if stack[index] == value then
            count = count + 1
        end
    end
    return count
end

--新建栈，栈可以设置元表
function Stack.new(capacity)
	local data = {}
	local proxy = {
		pop = __pop,
		peek = __peek,
		size = __size,
		empty = __empty,
		clear = __clear,
		iterator = __iterator,
		find = __find,
		get = __get,
		count = __count,
		version = 0,
	}
	if capacity and type(capacity) == "number" and capacity > 0 then
		if math_type(capacity) ~= 'integer' then
			capacity = math_floor(capacity)
		end
		proxy.push = __pushEx
		proxy.pushAll = __pushAllEx
		proxy.setCapacity = __setCapacity
		proxy.capacity = capacity
	else
		proxy.push = __push
		proxy.pushAll = __pushAll
	end
	private[proxy] = data
	return DataType.set(proxy, "stack")
end



--//@安全栈的数据受到最严格的保护

function Stack.safe(capacity)
	local self = {}
	local version = 0
	local proxy = {
		--//@弹栈操作
		pop = function()
			local index = #self
			if index == 0 then
				return nil
			end
			local value = self[index]
			self[index] = nil
			version = version + 1
			return value
		end,

		--//@查看栈顶
		peek = function()
			return self[#self]
		end,

		--//@获取大小
		size = function()
			return #self
		end,

		--//@是否空栈
		empty = function()
			return #self == 0
		end,

		--//@清空栈
		clear = function()
			for index = #self, 1, -1 do
				self[index] = nil
			end
			version = version + 1
		end,

		--//@高效迭代器
		--//@返回的索引是从栈顶开始计数，栈顶为1
		iterator = function()
			local ver = version
			local size = #self
			 local index = size
			return function()
				if ver ~= version then
					error("迭代期间栈已经被修改")
				end
				if index >= 1 then
					local pos_from_top = size - index + 1
					local value = self[index]
					index = index - 1
					return pos_from_top, value
				end
				return nil
			end
		end,

		--//@查找元素
		--//@可用 if Stack:find(value) then		来判断是否存在该元素
		find = function(value)
			local top = #self
			for index = top, 1, -1 do
				if self[index] == value then
					return top - index + 1
				end
			end
			return nil
		end,

		--//@获取栈中指定位置的元素（从栈顶开始计数）
		get = function(index_from_top)
			local top = #self
			if index_from_top < 1 or index_from_top > top then
				return nil
			end
			return self[top - index_from_top + 1]
		end,

		--//@统计元素出现次数
		count = function(value)
			local count = 0
			for index = 1, #self do
				if self[index] == value then
					count = count + 1
				end
			end
			return count
		end
	}
	if capacity and type(capacity) == "number" then
		if math_type(capacity) ~= 'integer' then
			capacity = math_floor(capacity)
		end
		--//@带限制的压栈操作
		proxy.push = function(value)
			local index = #self + 1
			if value == nil or index > capacity then return end
			self[index] = value
			version = version + 1
			return self
		end
		
		--//@带限制的批量压栈
		--//@values		table
		proxy.pushAll = function(values)
			if type(values) ~= 'table' or #values <= 0 then
				return self
			end
			local count = #self
			local max = math_min(capacity - count, #values)
			for index = 1, max do
				 self[count + index] = values[index]
			end
			version = version + 1
			return self
		end
		
		proxy.setCapacity = function(new_capacity)
			if not new_capacity or math_type(new_capacity) ~= 'integer' or new_capacity <= 0 then
                return false
            end
            --//如果新容量小于当前栈大小，需要截断
			local top = #self
            if top > new_capacity then
                for index = top, new_capacity + 1, -1 do
                    self[index] = nil
                end
            end
            capacity = new_capacity
            version = version + 1
            return true
		end
	else
		--//@压栈操作
		proxy.push = function(value)
			if value == nil then return end
			local index = #self + 1
			self[index] = value
			version = version + 1
			return self
		end
		
		--//@批量压栈
		--//@values		table
		proxy.pushAll = function(values)
			if type(values) ~= 'table' or #values <= 0 then
				return self
			end
			local count = #self
			for index = 1, #values do
				 self[count + index] = values[index]
			end
			version = version + 1
			return self
		end
	end
	return DataType.set(proxy, "stack")
end

return Stack
