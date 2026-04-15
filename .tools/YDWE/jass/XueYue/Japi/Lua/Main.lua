-- ********  雪月JAPI优化系统  ********
    --  初始化系统 请勿随意更改
local CJ = require 'jass.common'
japi = require 'jass.japi'
cj = CJ
local runtime	= require 'jass.runtime'
--runtime.catch_crash = false  --默认开启
local last_handle_level = runtime.handle_level

if not package.path:find('?\\init.lua', nil, true) then
    package.path = package.path .. ';?\\init.lua'
end
if not package.path:find('XG_JAPI\\?.lua', nil, true) then
    package.path = package.path .. ';XG_JAPI\\?.lua'
    package.path = package.path .. ';XG_JAPI\\Lua\\?.lua'
end

--[[
    runtime.handle_level
###0: handle在lua中是number，jass无法理解lua中handle的引用，增加引用计数不会保护handle
###1: handle封装在lightuserdata中，0可以隐式转换为nil，也不会增加handle的引用计数
###2：句柄封装在userdata中，增加lua持有句柄时句柄的引用计数。当然，在函数结束后，局部变量会自动回收并释放以处理引用。
]]

local lp = 'C:\\?.lua;'
local package_path = package.path
package.path = lp .. package.path
isDebug = require('XGEDITOR_DEBUG')
package.path = package_path

if isDebug then
    package.loaded['XGEDITOR_DEBUG'] = nil
end

require "jass.console".enable = isDebug and true or false

orig_print = print
local print = require "jass.console".write
_G.print = print

function printf( format, ... )
    print( format:format( ... ) )
end

print("--初始化雪月JAPI优化系统--")

require 'XG_JAPI.Lua.Common'
require 'XG_JAPI.Lua.PatchCJ'
----------------------------------------
--     使用XGJAPI.integer 指向整数数组
----------------------------------------
--     可用类型: integer real bool string unit item trigger player code
--     其中 code 只有 [1]
---@class XGJAPI
---@field integer table
---@field real table
---@field bool table
---@field string table
---@field unit table
---@field item table
---@field trigger table
---@field player table
---@field code table
XGJAPI = {
    --MAX_PARAM_SIZE = 32,
    --MAX_STACK = 200,
    --CUR_STACK = 0,
}

local XGJAPI = XGJAPI
local jdebug = require 'jass.debug'
local type = type
----------------------------------------
--          防混淆变量解析
----------------------------------------

local math_type = math.type
local function filterVar(g)
    local val = g[8191]
    local tp = type(val)
    if tp == 'string' and val == 'XGJAPI_string' then
        print( 'XGJAPI_string' , 'found' )
        XGJAPI.string = g
    elseif tp == 'number'  then
        if math_type(val) == "integer" and val == CJ.StringHash("XGJAPI_integer") then
            print( 'XGJAPI_integer' , 'found' )
            XGJAPI.integer = g
        elseif val == CJ.I2R(CJ.StringHash("XGJAPI_real")) then
            print( 'XGJAPI_real' , 'found' )
            XGJAPI.real = g
        end
    elseif tp == 'boolean' and val then
        print( 'XGJAPI_bool' , 'found' )
        XGJAPI.bool = g
    end
end

local global = require 'jass.globals'

runtime.handle_level = 1

local temp = {}
local maybe_code = {}
for key, g in pairs(global) do
    if type(g) == 'table'  then
        if g[8191] ~= nil then
            filterVar(g)
        else
            temp[key] = g
        end
    elseif type(g) == 'number' then
        if g == 0 then
            maybe_code[key] = g
        end
    end
    --[[if key == 'XGJAPI_code' then
        --XGJAPI.code = g
        print(key, type(g), g)
    end]]
end

runtime.handle_level = 0
--unit
XGJAPI.integer[8191] = 1
for key, g in pairs(temp) do
    local v = g[8191]
    g[8191] = 1
    if g[8191] == 1 then
        CJ.TriggerExecute( XGJAPI.integer[1] )
        if g[8191] == 0 then
            XGJAPI.unit = g
            temp[key] = nil
            print( 'XGJAPI_unit' , 'found' )
            break
        else -- 还原
            g[8191] = v
        end

    end

end

--item
XGJAPI.integer[8191] = 2
for key, g in pairs(temp) do
    local v = g[8191]
    g[8191] = 1
    if g[8191] == 1 then
        CJ.TriggerExecute( XGJAPI.integer[1] )
        if g[8191] == 0 then
            XGJAPI.item = g
            temp[key] = nil
            print( 'XGJAPI_item' , 'found' )
            break
        else -- 还原
            g[8191] = v
        end

    end

end

--trigger
XGJAPI.integer[8191] = 3
for key, g in pairs(temp) do
    local v = g[8191]
    g[8191] = 1
    if g[8191] == 1 then
        CJ.TriggerExecute( XGJAPI.integer[1] )
        if g[8191] == 0 then
            XGJAPI.trigger = g
            temp[key] = nil
            print( 'XGJAPI_trigger' , 'found' )
            break
        else -- 还原
            g[8191] = v
        end

    end

end

--player
XGJAPI.integer[8191] = 4
for key, g in pairs(temp) do
    local v = g[8191]
    g[8191] = 1
    if g[8191] == 1 then
        CJ.TriggerExecute( XGJAPI.integer[1] )
        if g[8191] == 0 then
            XGJAPI.player = g
            temp[key] = nil
            print( 'XGJAPI_player' , 'found' )
            break
        else -- 还原
            g[8191] = v
        end

    end

end

local codeVarName = {
    --[[
        [0] = 'XGJAPI_code',
    ]]
}
local code = setmetatable({}, {
    __index = function(t, k)
        local key = codeVarName[k]
        if key == nil then
            print( ('XGJAPI_code_get: key %s , only support 0\n%s'):format(k, debug.traceback()) )
            return
        end
        return global[key]
    end,
    __newindex = function(t, k, v)
        local key = codeVarName[k]
        if key == nil then
            print( ('XGJAPI_code_set: key %s , only support 0\n%s'):format(k,debug.traceback()) )
            return
        end
        global[key] = v
    end,
})
XGJAPI.code = code

--code
XGJAPI.integer[8191] = 5
for key, g in pairs(maybe_code) do
    local v = g
    global[key] = 1
    if global[key] == 1 then
        CJ.TriggerExecute( XGJAPI.integer[1] )
        if global[key] == 0 then
            codeVarName[0] = key
            maybe_code[key] = nil
            print( 'XGJAPI_code' , 'found' )
            break
        else -- 还原
            global[key] = v
        end

    end

end


--初始化变量
XGJAPI.integer[8191] = -1
CJ.TriggerExecute( XGJAPI.integer[1] )

for i = 1, 5, 1 do
    XGJAPI.integer[8191] = i
    CJ.TriggerExecute( XGJAPI.integer[1] )
    if i == 5 then
        rawset( code, 'DoNothing', code[0] )
    end
end

--销毁JassCall
XGJAPI.integer[8191] = -1
CJ.TriggerExecute( XGJAPI.integer[1] )

--JAPI优化系统不再持有Handle的引用
runtime.handle_level = 0
last_handle_level = nil

----------------------------------------
--          防混淆结束
----------------------------------------


----------------------------------------
--        Jass重定向Lua方法
----------------------------------------
if not Xfunc then
    Xfunc = {}
end
local Xfunc = Xfunc


--在Jass中可以获得增强函数的返回值，非数值会被转为布尔[0 1]
patch('UnitId'):PreFix(
    function ( __result, x )
        local code = Xfunc[x]
        if type( code ) ~= 'function' then
            return __result
        end

        __result = code()
        if __result and type(__result) ~= 'number' then
            __result = 1
        end

        return __result or 0

    end
)

----------------------------------------
--          重定向结束
----------------------------------------

--因为table.concat会检索最大索引，扩容后，拼接字符串时可能会报错，所以需要固定表
--仅XG_StringContact_Lv3使用
local StringConcatLv3 = {}

--table_concat指定table的索引只能扩充不能缩小，拼接5个字符串后，拼接3个字符串时，会报错，他会检索5个索引
local table_concat = table.concat

Xfunc['XG_StringContact_Lv3'] = function ()

    StringConcatLv3[1] = XGJAPI.string[1] or ''
    StringConcatLv3[2] = XGJAPI.string[2] or ''
    StringConcatLv3[3] = XGJAPI.string[3] or ''

	XGJAPI.string[0] = table_concat(StringConcatLv3) --table concat更高效且不会返回nil

end


Xfunc['require'] = function ()
    require(XGJAPI.string[1])
end

local iid = base.iid
Xfunc['XG_S2ID'] = function ()
    XGJAPI.integer[0] = iid( XGJAPI.string[1] )
end

local sid = base.sid
Xfunc['XG_ID2S'] = function ()
    XGJAPI.string[0] = sid( XGJAPI.integer[1] )
end


--[[
print( collectgarbage("count") )
print( collectgarbage("collect") )
print( collectgarbage("count") )

    handledef
reference       1
type    +EIP

for key, value in pairs(require 'jass.japi') do
    print(key,value)
end

]]

require 'XG_JAPI.Lua.Message'
require 'XG_JAPI.Lua.Const'
eventpool = require 'XG_JAPI.Lua.EventPool'
trigger = require 'XG_JAPI.Lua.Trigger'

print("--雪月JAPI优化系统 加载完成--")

  do return end  -- TEST

--for key, value in pairs(require'jass.code') do
--    print(key,value)
--end
--DzClearJassStringNotReference()
local jass_code = require 'jass.code'
jass_code.Trig_ESC111Actions = function ()
    print('jass_code.Trig_ESC111Actions')
end