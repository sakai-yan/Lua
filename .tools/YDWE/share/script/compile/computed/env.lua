return setmetatable({
	import = require 'compile.computed.import', 
	StringHash = require 'compile.computed.stringHash',
	abilityOrder = require 'compile.computed.abilityOrder',
}, {__index = _G})
