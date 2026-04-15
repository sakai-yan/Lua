--[[
    version:1.0.0
]]
package.path = package.path .. [[;##VBS_REPLACE_1##/?.lua]]
require 'U2A'

local real_traceback = debug.traceback
local real_assert = assert
local real_error = error
local real_warn = warn

assert = function( v, msg, ...)
    if not v then
        real_assert(v, Utf8ToAnsi(msg) or '??', ...)
    end
    lv = 0
    return v, ...
end

error = function( msg, level)
    real_error(Utf8ToAnsi(msg) or '??', level)
end

warn = function( msg, level)
    real_warn(Utf8ToAnsi(msg) or '??', level)
end

--[[
debug.traceback = function (message, level)

    return real_traceback( Utf8ToAnsi(message or '') or '??', level )
end
]]
return true