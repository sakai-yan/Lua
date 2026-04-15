local message = require 'jass.message'
--require 'XG_JAPI.Lua.Message'
--message.selection()
--message.msgHook[]


Xfunc[ 'GetSelectedUnit' ] = function ()
    XGJAPI.unit[0] = message.selection()
end