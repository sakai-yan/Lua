local XGJAPI = XGJAPI

local sub_utf8 = string.sub_utf8

local calc_width = string.calc_width

Xfunc['XG_SubUTF8'] = function ()
    XGJAPI.string[0] = sub_utf8(
        XGJAPI.string[1] or '',
        XGJAPI.integer[2] or '',
        XGJAPI.integer[3] or ''
    ) or ''
end

Xfunc['XG_LenUTF8'] = function ()
    XGJAPI.integer[0] = calc_width(
        XGJAPI.string[1] or '',
        1,
        1
    ) or 0
end


