----------------------------------------
--      雪月 常用函数库 by 雪月灬雪歌
----------------------------------------
--to int   '123.01'//1>>0 -- | 位或效率更高
--to float '123.01'+0

---@alias bool boolean
---@alias frame integer

local table_remove = table.remove
local table_concat = table.concat
local tostring = tostring
local ipairs = ipairs
local type = type
local assert = assert
local cj = require 'jass.common'

local floor,ceil = math.floor, math.ceil
base = {

    ---转化为整数id
    ---@param s string
    iid = function( s )
        if type(s) ~= 'string' then
            error( ('base.iid 传入了一个错误的参数类型:')..type(s)..(s and tostring(s) or 'nil') )
        end
        local id = 0
        for i=1 , s:len() do
            id = id * 256 + s:byte(i)
        end
        return id
    end,

    B2I = function (b)
        if b then
            return 1
        end
        return 0
    end,
    I2B = function (i)
        if i==0 then
            return false
        end
        return true
    end,
    ---将函数返回值保存为table
    ---例如 table = Params2Table( str:match( "(%d-),(%d)" ) ) 多个返回值存为表
    Params2Table = function ( ... )
        return {...}
    end,

    ---@type fun( int low, int high )
    ---@return int
    randomInt = cj.GetRandomInt,

    -- 高效数据类型转换
    S2I = function (s)
        return s // 1 | 0
    end,
    S2R = function (s)
        return s + 0
    end,

    I2S = function (i)
        return i .. ''
    end,
    I2R = function (i)
        return i + 0
    end,

    R2S = function (r)
        return r .. ''
    end,
    R2I = function (r)
        if r > 0 then
            return floor(r)
        end
        return ceil(r)
    end,
    print = orig_print,
}
orig_print = nil
local toint = base.R2I
---转化为字符串id
base.sid = function ( s )
    s = toint(s or 0)
    local result = {}
    local i = 0
    local x=1
    while x ~= 0 do
        x =  s % 256 --余数
        s = ( s - x ) / 256 --下一个除数
        i = i + 1
        result [ i ] = (x..''):char()
    end
    result [ i ] = nil --去掉末尾0
    return table_concat(result):reverse()
end

local table_insert = table.insert
local string_sub = string.sub
local string_find = string.find

--分割字符串
--@param str string 完整的字符串
--@param split_char string 分隔符
--@return table 返回一个表
function string.split(str, split_char)--分割字符串
    if not(str and split_char) then return {} end
    local sub_str_tab = {}
    while true do
        local pos,pos2 = string_find(str, split_char, 1, true) --四号参数 设为true 则作为普通文本处理 而不是模式匹配
        if not pos then
            table_insert(sub_str_tab,str)
            break
        end
        local sub_str = string.sub(str, 1, pos - 1)
        table_insert(sub_str_tab, sub_str)
        str = string_sub(str, pos2 + 1, #str)
    end
    return sub_str_tab
end

---@param s string 完整文本
---@param p string 寻找的字符串
---@param a integer 开始位置
function string.xfind(s,p,a)
    local l = p:len()
    if not a then a = 1 end
    for i=a,s:len() do
        if s:sub(i,i+l-1)==p then
            return i , i+l-1
        end
    end
    return nil,nil
end

math.pow = function(x, y)
    local res = 1
    for i=1 , y do
        res = res * x
    end
    return res
end

function string.calc_width(str, fontSize_UTF8, fontSize_ASCII)
    assert(type(str) == 'string', 'string.calc_width #1 err type')
    fontSize_UTF8 = fontSize_UTF8 or 2
    fontSize_ASCII = fontSize_ASCII or 1

    local lenInByte = str:len()
    local width = 0

    local i = 1
    while i <= lenInByte do
        local curByte = str:byte(i)
        local byteCount = 1

        if curByte > 0 and curByte <= 127 then
            byteCount = 1
        elseif curByte >= 192 and curByte < 223 then
            byteCount = 2
        elseif curByte >= 224 and curByte < 239 then
            byteCount = 3
        elseif curByte >= 240 and curByte <= 247 then
            byteCount = 4
        end

        --local char = string.sub(str, i, i+byteCount-1)
        i = i + byteCount -- 1

        if byteCount == 1 then
            width = width + fontSize_ASCII
        else
            width = width + fontSize_UTF8
            --width = width - fontSize_ASCII*(byteCount-1)
            --print(char)   --中文
        end

        --i = i + 1
    end

    return width // 1 | 0
end

function string.sub_utf8(str, pos_start, pos_end)
    assert(type(str) == 'string', 'string.sub_utf8 #1 err type')

    local lenInByte = str:len()
    local ret = ""

    if not pos_start then
        return ""
    end

    if pos_end then
        if pos_end > lenInByte then
            pos_end = lenInByte
        end
    else
        pos_end = lenInByte
    end

    if pos_end == 0 then
        return ""
    elseif pos_end > 0 then

    else
        pos_end = lenInByte + pos_end + 1
    end

    if pos_start == 0 then
        return ""
    elseif pos_start < 0 then
        pos_start = lenInByte + pos_start + 1
    end

    local i = pos_end - pos_start + 1
    local cur = 1
    local curPos = 0
    while i > 0 and cur <= lenInByte do
        local curByte = str:byte(cur)
        local byteCount = 1
        if not curByte  then
           break
        end

        if curByte > 0 and curByte <= 127 then
            byteCount = 1
        elseif curByte >= 192 and curByte < 223 then
            byteCount = 2
        elseif curByte >= 224 and curByte < 239 then
            byteCount = 3
        elseif curByte >= 240 and curByte <= 247 then
            byteCount = 4
        end

        local char = str:sub( cur, cur+byteCount-1)

        curPos = curPos + 1

        if ( curPos >= pos_start ) then
            i = i - 1
            ret = ret .. char
        end

        cur = cur + byteCount

    end

    return ret
end

local mt_xTable = {
    type = 'xTable',

    insert = function (self, ...)
        local idx = (self[0] or 0)
        for _, v in ipairs({...}) do

            idx = idx + 1
            self[ idx ] = v

        end
        self[0] = idx
        return idx
    end,

    remove = function (self, index)
        if not self[0] or self[0] < 1 then
            return
        end
        self[0] = (self[0] or 0) - 1
        table_remove(self, index)
    end,

    del = function (self)

        local mt = getmetatable(self)
        mt.__mode = 'kv'
        self:reset()

    end,

    reset = function (self, clean)

        if not clean then
            self[1] = nil
            self[2] = nil
        else

            for i = 1, self[0] do

                self[ i ] = nil

            end

        end

        self[0] = 0
    end,

    len = function (self)
        return self[0]
    end,

    ipairs = function (self)
        return ipairs(self)
    end,



}
---返回一个xTable
---自带元方法 insert/remove/del 用法与 table.inset相同，可连续插入
---使用该方法插入可使用 tb[0] 快速查看数组长度
---@param tb? table  自带元方法 insert/remove/del 用法与 table.inset相同，可连续插入
---@return table
function table.new( tb )
    if not tb then
        tb = {
            [0] = 0,
        }
    else
        local i = 0
        for _,_ in ipairs(tb) do
            i = i +1
        end
        tb[0] = i
    end

    return setmetatable( tb,
    {
        __index = mt_xTable
    }
    )
end


local meta_k = { __mode = 'k', }
local meta_v = { __mode = 'v', }
local meta_kv = { __mode = 'kv', }

---创建或更改表键为弱引用从而实现自动排泄
---意思是当t作为key为弱引用，当你把t作为其他表的key时，gc会无视他的引用
---@param t table
---@return table
table.k = function( t )
    local mt = getmetatable(t)
    if mt then
        mt.__mode = 'k'
        return t
    else
        mt = {
            __mode = 'k'
        }
    end
    return setmetatable( t or {}, meta_k )
end

---创建或更改表的键值为弱引用从而实现自动排泄
---意思是当t作为value为弱引用，当你把t作为其他表的value时，gc会无视他的引用
---@param t table
---@return table
table.v = function ( t )
    local mt = getmetatable(t)
    if mt then
        mt.__mode = 'v'
        return t
    else
        mt = {
            __mode = 'v'
        }
    end
    return setmetatable( t or {}, meta_v )
end

---创建或更改表键与值为弱引用从而实现自动排泄
---意思是当t作为key或者value时都为弱引用。也就是gc不管你是否在引用
---@param t table
---@return table
table.kv = function( t )
    local mt = getmetatable(t)
    if mt then
        mt.__mode = 'kv'
        return t
    else
        mt = {
            __mode = 'kv'
        }
    end
    return setmetatable( t or {}, meta_kv )
end

local real_require = require
require = function ( lua_path )
    assert( type(lua_path) == "string" , 'require 参数类型错误！ '..type(lua_path)..':'.. lua_path )
    return real_require(lua_path)
end
include = require

local cache_bytes = {}
function bytes(str)
    if cache_bytes[str] then
        return cache_bytes[str]
    end

    local bt = { str:byte( 1, #str ) }
    local c = #bt
    local result = 0
    for i=1,c do
        result = result*10 + bt[i]
    end

    cache_bytes[str] = result
    return result
end

---选择排序 一般用来给pairs返回的列表进行排序
---舍弃 除了string与number类型的值
---@param t table<int,string|number>
function select_sort(t)
    local count = #t
    local i = 1
    local j = 1

    local a,b

    while i <= count-1 do
        local tp1 = type(t[i])

        if tp1 ~= 'string' and tp1 ~= 'number' then
            t[i] = t[count]
            t[count] = nil
            count = count - 1
            i=i-1
        else

            a = bytes( tostring( t[i] ) )

            j = i + 1
            while j <= count do
                local tp2 = type(t[j])
                if tp2 ~= 'string' and tp2 ~= 'number' then
                    t[j] = t[count]
                    t[count] = nil
                    count = count - 1
                    j=j-1
                else
                    b = bytes( tostring( t[j] ) )

                    if a > b then
                        a = b
                        t[i], t[j] = t[j],t[i]
                    end


                end

                j=j+1
            end

        end

       i = i + 1
    end

end

---排序遍历迭代器
---与pairs不同的是。他只会列出string和number类型的key
---并排序，使不同设备访问k,v时的顺序能够相同
---
---经过随机字符碰撞测试,字符串长度小于7时容易哈希碰撞(越短越容易)
---
---但平常使用的key不同于随机字符串，也难以出现哈希碰撞,仅需避免 kv 和 iv 混用,否则短字符可能会和index碰撞
---@return func iterator迭代器
function xPairs( tb )
    assert(type(tb) == 'table', debug.traceback("table expected"))
    local keys = {}
    local count = 0
    for k, v in pairs(tb) do
        count = count + 1
        keys[count] = k .. ''
    end
    select_sort(keys)
    local i = 0
    return function ()
        i = i + 1
        local k = keys[i]
        if i <= count then
            return k, tb[ k ]
        end
    end
end

