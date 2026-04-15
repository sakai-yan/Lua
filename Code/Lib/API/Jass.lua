------------------jass库--------------------
local common = require "jass.common"
local code = require "jass.code"
local japi = require "jass.japi"

local Jass = {}

setmetatable(Jass, {
	__index = function(_, key)
		local Func = common[key] or japi[key] or code[key]
		if Func then
			Jass[key] = Func
			return Func
		end
	end
})

return Jass
