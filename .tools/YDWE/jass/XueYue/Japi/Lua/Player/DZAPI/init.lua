local getRealPlayerNmae = require 'jass.japi'.DzAPI_Map_GetPlayerUserName

local getPlayerName = require 'jass.common'.GetPlayerName
local random_int = base.randomInt

local custom_name = ''
local custom_id = -1

if not getRealPlayerNmae then
    getRealPlayerNmae = function (player)
        local name = custom_name
        local id = custom_id

        if name == '' then
            name = getPlayerName(player) or '获取失败'
        end

        if id == -1 then
            id = random_int(1, 9999) or '1'
        end

        return  name ..  '#' .. id
    end
end

local XGJAPI = XGJAPI

Xfunc['XG_DZAPI_GetRealPlayerNmae'] = function ()
    local p = XGJAPI.player[1] or 0
    custom_name = XGJAPI.string[2] or ''
    custom_id = XGJAPI.integer[3] or 0

    XGJAPI.string[0] =  getRealPlayerNmae( p ) or ''
end

