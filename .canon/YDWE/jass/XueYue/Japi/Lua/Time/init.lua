--[[
%a	一星期中天数的简写	(Fri)
%A	一星期中天数的全称	(Wednesday)
%b	月份的简写	(Sep)
%B	月份的全称	(May)
%c	日期和时间	(09/16/98 23:48:10)
%x	日期	(09/16/98)
%X	时间	(23:48:10)


%d	一个月中的第几天	(28)[0 - 31]
%H	24小时制中的小时数	(18)[00 - 23]
%I	12小时制中的小时数	(10)[01 - 12]
%j	一年中的第几天	(209)[01 - 366]
%M	分钟数	(48)[00 - 59]
%m	月份数	(09)[01 - 12]
%P	上午或下午	(pm)[am - pm]
%S	一分钟之内秒数	(10)[00 - 59]
%w	一星期中的第几天	(3)[0 - 6 = 星期天 - 星期六]
%W	一年中的第几个星期	(2)0 - 52

%y	两位数的年份	(16)[00 - 99]
%Y	完整的年份	(2016)

%%	字符串'%'	(%)
]]

local XGJAPI = XGJAPI
local S2I = base.S2I
local R2I = base.R2I
local os_date = os.date
local os_clock = os.clock
local os_time = os.time

local srv_stamp_start = require'jass.japi'.DzAPI_Map_GetGameStartTime()

if srv_stamp_start == 0 then
    srv_stamp_start = os_time()
end

local map = {
    [1] = '%d',
    [2] = '%H',
    [3] = '%I',
    [4] = '%j',
    [5] = '%M',
    [6] = '%m',
    [7] = '%P',
    [8] = '%S',
    [9] = '%w',
    [10] = '%W',

    [11] = '%y',
    [12] = '%Y',
}


Xfunc['XG_Stamp2DatePart'] = function ()
    local stamp = XGJAPI.integer[1]
    local retType = XGJAPI.integer[2]
    local format = map[ retType ]
    if not format then
        XGJAPI.integer[0] = -1
        return
    end

    local ret = os_date(format, stamp)

    if retType == 7 then
        if ret == 'am' then
            ret = '0'
        else
            ret = '1'
        end
    elseif retType == 9 then
        if ret == 0 then
            ret = '7'
        end
    end

    XGJAPI.integer[0] = S2I(ret)
end

Xfunc['XG_Stamp2Date'] = function ()
    local stamp = XGJAPI.integer[1]
    local format = XGJAPI.string[2]

    local ret = os_date(format, stamp)

    XGJAPI.string[0] = ret
end


Xfunc['XG_GetTickCount'] = function ()
    local t = os_clock() * 1000
    XGJAPI.integer [0] = R2I( t )
end

Xfunc['XG_GetCurClientTimeStamp'] = function ()
    XGJAPI.integer [0] = os_time()
end

Xfunc['XG_GetCurServerTimeStamp'] = function ()
    XGJAPI.integer [0] = srv_stamp_start + R2I(os_clock())
end

local formats = {
    "(%d+)[^%d]+(%d+)[^%d]+(%d+)[^%d]+%s*(%d+)[^%d]+(%d+)[^%d]+(%d+)",
    "(%d+)[^%d]+(%d+)[^%d]+(%d+)[^%d]+%s*(%d+)[^%d]+(%d+)",
    "(%d+)[^%d]+(%d+)[^%d]+(%d+)[^%d]+%s*(%d+)",
    '(%d+)[^%d]+(%d+)[^%d]+(%d+)',
}

local string_match = string.match

Xfunc['XG_String2Stamp'] = function ()
    local str = XGJAPI.string[1]
    local y, m, d, _hour, _min, _sec

    for i = 1, #formats do
        local f = formats[i]
        y, m, d, _hour, _min, _sec = string_match(str, f)
        if y then
            break
        end
    end

    local timestamp = os.time( {year=y, month = m, day = d, hour = _hour or 0, min = _min or 0, sec = _sec or 0} )

    XGJAPI.integer[0] = timestamp
end
