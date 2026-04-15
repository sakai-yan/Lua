local XGJAPI = XGJAPI
local string = string

Xfunc['XG_Char2Ascii']=function ()
    XGJAPI.integer[0] = (XGJAPI.string[1] or ''):byte() or 0
end

Xfunc['XG_Ascii2Char'] = function ()
    XGJAPI.string[0] = string.char( XGJAPI.integer[1] or 0 )
end
