require "localization"
local ffi = require "ffi"

local loader = {}
------------------------------------------------
local api = {}
local def = {
	{
		name = "SetCurrentDirectoryW",
		declaration = [[int SetCurrentDirectoryW(const wchar_t* lpPathName);]],
	},
	{
		name = "GetCurrentDirectoryW",
		declaration = [[int GetCurrentDirectoryW(int nBufferLength, wchar_t* lpBuffer);]],
	},

}
for _, v in ipairs(def) do
	local s, r = xpcall(ffi.cdef, function()
		log.error('faild: ' .. v.name)
	end, v.declaration)

	if not s then
		log.error('faild: ' .. r)
		api[v.name] = ffi.C[v.name]
	else
		api[v.name] = ffi.C[v.name]
	end
end

local SetCurrentDirectoryW = api.SetCurrentDirectoryW
local GetCurrentDirectoryW = api.GetCurrentDirectoryW

local uni = require 'ffi.unicode'
local function __(str)
	return uni.u2a(str)
end
------------------------------------------------

loader.load = function(path)
	local path_current = ffi.new("wchar_t[260]")
	GetCurrentDirectoryW(260, path_current)

	local s, r = pcall(ffi.load, __(path:string()))

	if not s then
		log.error('failed: ' .. r)
		return false
	end
	SetCurrentDirectoryW(path_current)
	loader.dll = r

	ffi.cdef[[
		bool unload();
	]]

	return true
end

loader.unload = function()
	loader.dll.unload()
end

return loader
