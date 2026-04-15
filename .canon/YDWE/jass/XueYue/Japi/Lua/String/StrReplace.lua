local XGJAPI = XGJAPI
function XG_StrReplace_Single(str,i,s)
	return str:sub(1,i-1) .. s .. str:sub(i+1)
end

function XG_StrReplace_Multiple(str, i, j, s)
	return str:sub(1, i-1) .. s .. str:sub(j+1)
end

function XG_StringReplace(str, o, n, c)
    if c < 0 then
        return str:gsub(o, n)
    end
    c = (c==0) and 1 or c
    local lenOld = o:len()
    local i = 1
    local p
    while i <= c do

        p = str:find(o, p, true)
        if p == nil then
            break
        end
        i = i + 1
        -- 12[34]56
        str = str:sub(1, p-1) .. n .. str:sub(p + lenOld)

    end

    return str
end

Xfunc['XG_StrReplace_Single']=function ()
    XGJAPI.string[0] = XG_StrReplace_Single(
        XGJAPI.string[1] or '',
        XGJAPI.integer[2] or 0,
        XGJAPI.string[3] or ''
    )
end

Xfunc['XG_StrReplace_Multiple']=function ()
    XGJAPI.string[0] = XG_StrReplace_Multiple(
        XGJAPI.string[1] or '',
        XGJAPI.integer[2] or 0,
        XGJAPI.integer[3] or 0,
        XGJAPI.string[4] or ''
    )
end

Xfunc['XG_StringReplace']=function ()
    XGJAPI.string[0] = XG_StringReplace(
        XGJAPI.string[1] or '',
        XGJAPI.string[2] or '',
        XGJAPI.string[3] or '',
        XGJAPI.integer[4] or 0
    )
end
