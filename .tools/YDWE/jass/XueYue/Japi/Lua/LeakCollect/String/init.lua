local string_unref = require 'jass.japi'.DzReleaseString
if not string_unref then
    return
end

local timer = require 'Time.Timer'
local os_date = os.date
local print = print
--[[
    native DzReleaseString takes string str returns nothing
]]

local queue = table.new()

timer:loop( 10, function (t)
    local i, imax = 1, queue[0]

    while i <= imax do
        local h = queue[i]

        string_unref(h)

        queue[i] = nil
        i = i + 1
    end

    queue[0] = 0

    if imax > 0 then
        print('['.. os_date('%H:%M:%S')..']雪月字符串排泄:' , imax )
    end
end  )


Xfunc[ 'XG_LeakCollect_StringRelease' ] = function ()
    queue:insert(XGJAPI.string[1])
end
