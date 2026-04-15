--[[
    追踪对象创建者,用于调试分析泄露
        by: 雪月灬雪歌
]]

local XGJAPI = XGJAPI
local patch = patch
local Track = {}
local map_code2str = {}
local code_sync = {}
local cj = require 'jass.common'
local jdebug = require 'jass.debug'

local Force = cj.CreateForce()
cj.ForceAddPlayer(Force, cj.Player(0))
local ForForce = cj.ForForce

local ht = {}

local mt_map = {
    
}

local function GetTickCount()
    return os.date( '%H:%M:%S', os.time())
end

-- 从Track中获取创建者: 触发器, 计时器 的函数名
local function GetCreater()
    if #Track == 0 then
        return 'NULL'
    end
    return Track[#Track].funcName or 'NULL'
end

local function PushTrack( funcName, value )
    Track[#Track + 1] = {
        funcName = funcName,
        creater = GetCreater(),
    }
end

local function PopTrack()
    return table.remove(Track)
end

local function code2str( code )
    return tostring(code)
end


function mt_map:record( key, value )
    if not self.tRecord then
        self.tRecord = {}
    end
    self.tRecord[#self.tRecord + 1] =
    {
        key = key,
        value = value,
        ['创建时间'] = GetTickCount(),
        ['访问时间'] = GetTickCount(),
        ['创建者'] = GetCreater(),
    }
end
function mt_map:getRecord( key )
    for i = #self.tRecord, 1, -1 do
        local record = self.tRecord[i]
        if record.key == key then
            --record['访问时间'] = GetTickCount()
            return record
        end
    end
    return {}
end


local mt = {
    
}

local allocMap = function( name )
    local map = {
        name = name or "default",
    }
    setmetatable(map, {
        __mode = "kv",
        __index = function(map, key)
            return mt_map[key] or mt
        end,
    })
    return map
end

function mt:record_unit( unitHandle )
    ht.unitMap:record(unitHandle)
end
function mt:record_trigger( triggerHandle )
    ht.triggerMap:record(triggerHandle)
end
function mt:record_location( locationHandle )
    ht.locationMap:record(locationHandle)
end
function mt:record_timer( timerHandle )
    ht.timerMap:record(timerHandle)
end

function mt:init()
    ht.unitMap = allocMap( 'unit' )
    ht.triggerMap = allocMap( 'trigger' )
    ht.locationMap = allocMap( 'location' )
    ht.timerMap = allocMap( 'timer' )
end

patch('CreateUnit'):PostFix(
    function(__result, playerId, unitId, x, y, face)
        mt:record_unit(__result)
        --print('CreateUnit', __result, playerId, unitId, x, y, face)
        print('====HandleHelper====')
        for key, value in pairs(ht.unitMap:getRecord(__result)) do
            print(key, value)
        end
        return __result
    end
)
patch('CreateTrigger'):PostFix(
    function(__result)
        mt:record_trigger(__result)
        return __result
    end
)
patch('Location'):PostFix(
    function(__result, x, y)
        mt:record_location(__result)
        return __result
    end
)
patch('CreateTimer'):PostFix(
    function(__result)
        mt:record_timer(__result)
        return __result
    end
)

patch('TriggerAddAction'):PreFix(
    function(__result, trigger, action, real)
        local syncCode = code_sync[action]
        if not syncCode then
            syncCode = function ()
                PushTrack( map_code2str[action], action )
                print('track', map_code2str[action], action)
                ForForce(Force, action)
                PopTrack()
            end
            code_sync[action] = syncCode
        end
        --print(real, syncCode, trigger, action)
        __result = real(trigger, syncCode)
        return __result
    end
)

patch('TimerStart'):PreFix(
    function(__result, timer, timeout, periodic, action, real)
        local syncCode = code_sync[action]
        if not syncCode then
            syncCode = function ()
                PushTrack( map_code2str[action], action )
                ForForce(Force, action)
                PopTrack()
            end
            code_sync[action] = syncCode
        end
        __result = real(timer, timeout, periodic, syncCode)
        return __result
    end
)
patch('ForGroup'):PreFix(
    function(__result, group, action, real)
        local syncCode = code_sync[action]
        if not syncCode then
            syncCode = function ()
                PushTrack( map_code2str[action], action )
                ForForce(Force, action)
                PopTrack()
            end
            code_sync[action] = syncCode
        end
        __result = real(group, syncCode)
        return __result
    end
)
patch('ForForce'):PreFix(
    function(__result, force, action, real)
        local syncCode = code_sync[action]
        if not syncCode then
            syncCode = function ()
                PushTrack( map_code2str[action], action )
                ForForce(Force, action)
                PopTrack()
            end
            code_sync[action] = syncCode
        end
        __result = real(force, syncCode)
        return __result
    end
)
local codeName
patch('Filter'):PreFix(
   function(__result, code, real)
        __result = real(code)
        if codeName then
            map_code2str[code] = codeName
            codeName = nil
        end
        return __result
    end
)

Xfunc['XG_HandleHelper_CodeRecord'] = function ()
    local code = XGJAPI.code[0]
    codeName = XGJAPI.string[1]
    --map_code2str[code] = codeName
    --print('codeName', codeName, code)
end

mt:init()

require 'XG_JAPI.Lua.XUI'
--xui.panel:new( { x = 0.1, y = 0.1, w = 0.3, h = 0.3, template = 'BattleNetControlBackdropTemplate'  } )
xui.listview:new {
    x = 0.1,
    y = 0.1,
    w = 0.3,
    h = 0.4,
    template = 'BattleNetControlBackdropTemplate',
    itemCount = 1,
    list = {
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '10',
        '11',
        '12',
        '13',
        '14',
        '15',
        '16',
        '17',
        '18',
        '19',
        '20',
        '21',
        '22',
        '23',
        '24',
        '25',
        '26',
        '27',
        '28',
        '29',
        '30',
    }
}
for i = 1, 12, 1 do
    
end
