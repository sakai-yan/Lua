
local XGJAPI = XGJAPI

local jslk = require 'jass.slk'

--XG_GetObjectString(obj_type, obj_code, obj_proprerty)
local XG_GetObjectString = function (obj_type, obj_code, obj_property)
    local isOK = false
    local ret = ''

    while true do

        local slk = jslk[ obj_type ]
        if not slk then
            break
        end

        if slk[ obj_code ] then
            local str = slk[ obj_code ][ obj_property ]
            if str then
                ret = str
                isOK = true
            end
        end
        break
    end

    if not isOK then
        return ''
    end

    return  ret
end

local iid = base.iid
local sid = base.sid

Xfunc['XG_GetObjectStringByIID'] = function ()
    local id = XGJAPI.integer[2]
    if not id or id == 0 then
        XGJAPI.string[0] = ''
        return
    end

    XGJAPI.string[0] = XG_GetObjectString(
        XGJAPI.string[1] or '',
        sid(XGJAPI.integer[2]),
        XGJAPI.string[3] or ''
    ) .. ''
end

Xfunc['XG_GetObjectStringBySID'] = function ()
    local id = XGJAPI.string[2]
    if not id or id == '' then
        XGJAPI.string[0] = ''
        return
    end

    XGJAPI.string[0] = XG_GetObjectString(
        XGJAPI.string[1] or '',
        XGJAPI.string[2],
        XGJAPI.string[3] or ''
    ) .. ''
end
