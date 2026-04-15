--[[
    同步模块
]]
local DzSyncData = japi.DzSyncData
local DzTriggerRegisterSyncData = japi.DzTriggerRegisterSyncData
local DzGetTriggerSyncData = japi.DzGetTriggerSyncData

local SYNC_SYSTEM_TAG = 'XG_SYNC'
local sync_data = {}
sync_data.__index = sync_data
sync_data.__call = function(t)
	return table.concat(t,"&")
end
function sync_data:Add(...)
	local d = { ... }
	for i=1,#d do
		local p = type(d[i])
		if p == 'nil' then
		elseif p == 'string' then
			table.insert(self,d[i])
		elseif p == 'table' then
			for j=1,#d[i] do
				table.insert(self,tostring(d[i][j]))
			end
		else
			table.insert(self,tostring(d[i]))
		end
	end
end
--生成同步数据包
function NewSyncData(d) 
    local t = setmetatable( {}, sync_data )
    if d~=nil then t:Add(d) end
    return t
end
--解析同步数据包
local package = setmetatable( {}, sync_data )
local __callback = {}
function LoadSyncData()
	return package
end
--发送同步数据包
function sync_data:Send(tag)
    table.insert(self,1,tag)
	DzSyncData( SYNC_SYSTEM_TAG, self( ) )
end
--注册同步回调
function SyncCallback(tag,func)
    if type(func) ~= 'function' then return end
    if not __callback.tag then
        __callback.tag = { func }
    else
        table.insert( __callback.tag, func )
    end
    return func
end

local trg = cj.CreateTrigger()
DzTriggerRegisterSyncData(trg, SYNC_SYSTEM_TAG, false)
local action = function ()
    local data = ( DzGetTriggerSyncData() or '' ):split( "&" )
    setmetatable( data, sync_data )
    local tag = data [ 1 ] or ''
    table.remove(data,1)
    package = data
    for i,v in ipairs( __callback.tag or {} ) do
        v ( )
    end
end
cj.TriggerAddAction( trg, action )
