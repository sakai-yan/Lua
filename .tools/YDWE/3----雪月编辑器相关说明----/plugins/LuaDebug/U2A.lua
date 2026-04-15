--[[
    @author: 雪月灬雪歌
    以前写的屎山代码小改后搬出来用，可能有bug

]]


local gbk = require "GBK18030"

local char = string.char
local table_concat = table.concat
local table_insert = table.insert

local function Bytes4Char(theByte)
    local seperate = {0, 0xc0, 0xe0, 0xf0}
    for i = #seperate, 1, -1 do
        if theByte >= seperate[i] then return i end
    end
    return 1
end

local function To10(t)
    local n=0
    local s,len=1,#t
    while s<=len do
        if t:sub(s,s)=='0' then
            t=t:sub(s+1)
            s=s-1
        else
            break
        end
        s=s+1
    end
    for i = 1,#t do
        n = n + ( t:sub(i,i) + 0 ) * 2^( #t - i )
    end

    return n // 1 | 0
end

local function To2(src)
    local result,i = {},0
    local bitLen = (src..''):len()
    while src~=0 do
        i=i+1
        result[i] = src % 2
        src = (src / 2) // 1 | 0
    end
    return table_concat(result):reverse()
end

local function characters(utf8Str, aChineseCharBytes)
    aChineseCharBytes = aChineseCharBytes or 2
    local i = 1
    local characterSum = 0
    while (i <= #utf8Str) do      -- 编码的关系
        local bytes4Character = Bytes4Char(string.byte(utf8Str, i))
        characterSum = characterSum + (bytes4Character > aChineseCharBytes and aChineseCharBytes or bytes4Character)
        i = i + bytes4Character
    end
    return characterSum
end


function UnicodeToAnsi(arr)
    local id = To10(table_concat(arr))
    local s2 = To2(gbk[id] or 0)
    --print(id,s2,To10(s2:sub(1,8)), To10(s2:sub(9,16)) )
    return char
    (
        To10(s2:sub(1,8)),
        To10(s2:sub(9,16))
    )
end

function Utf8ToAnsi(str)
    local i,bit,x,m=1,0,0,0
    local char,s,tmp = '',{},{}
    local length = #str
    while i <= length+1 do
        char = str:sub(i,i)
        bit = char:byte()
        if x==0 then

            if #tmp>0 then
                table_insert(s, UnicodeToAnsi( tmp ) )
                tmp={}
            end

            if i>#str then
                break
            end

            x = Bytes4Char(bit)
            if x ==1 then --单字符
                x=x-1
                table_insert(s,char)
            else --多字符
                m=x
                tmp ={}
               tmp[1] = To2(bit):sub(x+2)
                x=x-1
            end
        else --多字节
            tmp[m-x+1] = To2(bit):sub(3)
            x=x-1
        end
        i=i+1
    end
    return table_concat(s)
end

