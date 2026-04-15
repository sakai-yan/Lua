local XGJAPI = XGJAPI
--[=[

将整数拆成单字的字符串数组，
从而避免导致Jass字符串表被伤害值字符串大量占用问题

通常直接使用这些单数字字符连接成固定的几个 数字模型/贴图 路径

]=]

local function intToStringArray( nInt )
    --将整数逐字分割为数组
    --如果存在负号，将负号放在0号索引，数字从1号索引开始

    --结果存放在 XGJAPI.string 表中
    --例如，-1234 将被分割为 {- , 1, 2, 3, 4}

    --XGJAPI.integer[1] 记录数组长度

    --****将整数转换为字符串****
    local strInt

    --如果整数为负数，将负号放在0号索引
    if nInt < 0 then
        XGJAPI.string[0] = "-"
        strInt = -nInt .. ''
    else
        XGJAPI.string[0] = ''
        strInt =  nInt .. ''
    end

    --****将整数逐字分割为数组****
    local len = #strInt
    XGJAPI.integer[ 1 ] = len

    for i = 1, len do
        XGJAPI.string[i] = strInt:sub( i, i )
    end

end


local function realToStringArray( fReal )
    --将实数逐字分割为数组
    --如果存在负号，将负号放在0号索引，数字从1号索引开始

    --结果存放在 XGJAPI.string 表中
    --例如，-1234.5678 将被分割为 {- , 1, 2, 3, 4, . , 5, 6, 7, 8}

    --XGJAPI.integer[1] 记录数组长度
    --XGJAPI.integer[2] 记录小数点的位置

    --****将实数转换为字符串****
    local strReal

    --如果整数为负数，将负号放在0号索引
    if fReal < 0 then
        XGJAPI.string[0] = "-"
        strReal = -fReal .. ''
    else
        XGJAPI.string[0] = ''
        strReal =  fReal .. ''
    end

    --****将实数逐字分割为数组****

    local len = #strReal
    XGJAPI.integer[ 1 ] = len


    for i = 1, #strReal do
        local c = strReal:sub( i, i )
        XGJAPI.string[i] = c
        if c == "." then
            XGJAPI.integer[ 2 ] = i
        end
    end

end

Xfunc['XG_IntToStringArray'] = function ()
    intToStringArray( XGJAPI.integer[ 1 ] or 0 )
end

Xfunc['XG_RealToStringArray'] = function ()
    realToStringArray( XGJAPI.real[ 1 ] or 0.00 )
end

local string_match = string.match
Xfunc['XG_String_Match'] = function ( )
    local str = XGJAPI.string[ 1 ] or ''
    local sPattern = XGJAPI.string[ 2 ] or ''
    if str == '' or sPattern == '' then
        XGJAPI.string[ 1 ] = ''
        XGJAPI.string[ 2 ] = ''
        XGJAPI.integer[ 1 ] = 0
        return
    end
    local ret = { string_match(str, sPattern ) }
    local count = #ret

    if count == 0 then
        XGJAPI.string[ 1 ] = ''
        XGJAPI.string[ 2 ] = ''
        XGJAPI.integer[ 1 ] = 0
        return
    end

    for i = 1, count do
        XGJAPI.string[ i ] = ret[ i ]
    end
    XGJAPI.integer[ 1 ] = count
    if count == 1 then
        XGJAPI.string[ 2 ] = ''
    end

end

local string_gmatch = string.gmatch
Xfunc['XG_String_GMatch'] = function ( )
    local str = XGJAPI.string[ 1 ] or ''
    local sPattern = XGJAPI.string[ 2 ] or ''
    if str == '' or sPattern == '' then
        XGJAPI.string[ 1 ] = ''
        XGJAPI.string[ 2 ] = ''
        XGJAPI.integer[ 1 ] = 0
        return
    end
    local count = 0
    for v in string_gmatch(str, sPattern ) do
        count = count + 1
        XGJAPI.string[ count ] = v
    end

    if count == 0 then
        XGJAPI.string[ 1 ] = ''
        XGJAPI.string[ 2 ] = ''
        XGJAPI.integer[ 1 ] = 0
        return
    end

    XGJAPI.integer[ 1 ] = count
    if count == 1 then
        XGJAPI.string[ 2 ] = ''
    end

end

local string_split = string.split
local table_unpack = table.unpack
local string_format = string.format
local xpcall = xpcall
Xfunc['XG_String_Format'] = function ( )
    local sFormat = XGJAPI.string[ 8190 ] or ''
    local sParams = XGJAPI.string[ 8191 ] or ''
    local params = {}
    local countParams = #sParams
    local p2v = {
        i = 'integer',
        f = 'real',
        r = 'real',
        s = 'string',

        S = 'string',
        I = 'integer',
        R = 'real',
        F = 'real',
    }
    local i = 0
    local v
    local ret = ''
    local b
    sFormat = sFormat:gsub('\\n', '\n')
    while true do
        i = i + 1
        v = p2v[ sParams:sub(i, i) ]
        if i > countParams or v == nil then
            break
        end

        v = XGJAPI[ v ]
        if v == nil then
            b = true
            break
        end
        params[i] = v[i]

    end
    if b or sFormat == '' or sParams == '' then
        XGJAPI.string[ 0 ] = ret
        return
    end
    b, ret = xpcall( function ( )
        return string_format(sFormat, table_unpack(params))
    end, function (msg)
        --print(msg)
    end)
    if not b then
        ret = ''
    end
    XGJAPI.string[ 0 ] = ret
end