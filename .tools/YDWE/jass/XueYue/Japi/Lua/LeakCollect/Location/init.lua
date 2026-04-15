--local cj = require 'jass.common'
---@type mTimer 中心计时器
local timer = require 'Time.Timer'
local jdebug = require 'jass.debug'
local os_date = os.date
local print = print
local get_def = jdebug.handledef
local unref = jdebug.handle_unref
----------------------------------------
--    点 自动排泄系统    by 雪月灬雪歌
----------------------------------------

--[[
constant native GetCameraEyePositionLoc takes nothing returns location
constant native GetCameraTargetPositionLoc takes nothing returns location
constant native GetOrderPointLoc takes nothing returns location

constant native GetStartLocationLoc takes integer whichStartLocation returns location
constant native GetSpellTargetLoc takes nothing returns location
constant native GetUnitLoc takes unit whichUnit returns location

native Location takes real x, real y returns location
]]

local address = 80000000 --安全偏移值 handle起始值 0x100000
local queue = table.new()

timer:loop( 10, function (t)
    local i, imax = 1, queue[0]
    local offset = 0
    local count = 0

    while i <= imax do
        local h = queue[i]
        local def = get_def(h)

        if def then
            if def.type == '+loc' and def.reference <= 1 then
                if def.reference == 1 then
                    unref(h)
                end
                count = count + 1
                offset = offset + 1

                imax = imax - 1
                queue[i] = queue[i + offset]
                queue[i + offset] = nil
            else
                i = i + 1
            end
        else
            imax = imax - 1
            queue[i] = queue[i + offset]
            queue[i + offset] = nil
        end

    end

    queue[0] = imax

    if offset > 0 then
        print('['.. os_date('%H:%M:%S')..']雪月点自动排泄:' , count )
    end
end  )

local fake = function ( __result, ... )
    queue:insert(__result)
    queue[address + __result] = true
    return __result
end

patch('GetCameraEyePositionLoc'):PostFix(fake)
patch('GetCameraTargetPositionLoc'):PostFix(fake)
patch('GetOrderPointLoc'):PostFix(fake)

patch('GetStartLocationLoc'):PostFix(fake)
patch('GetSpellTargetLoc'):PostFix(fake)
patch('GetUnitLoc'):PostFix(fake)

patch('Location'):PostFix(fake)

--已删除的点移除队列
patch('RemoveLocation'):NoReturnValue():PreFix(
    function (__result, handle)

        if queue[address + handle] then

            for i, _ in queue:ipairs() do

                if queue[ i ] then
                    queue:remove(i)
                    queue[address + handle] = nil
                    break
                end

            end

        end

        local def = get_def(handle)
        if def and def.reference then
            for _ = 1, def.reference-1, 1 do
                unref(handle)
            end
        end
        return __result
    end
)
print('点自动排泄系统已启动')
--[[
patch('SaveLocationHandle'):PostFix(
    function (__result, ht, pk, ck, loc)
       -- jdebug.handle_ref(__result)
    end
)

patch('RemoveSavedHandle'):PostFix(
    function (__result, ht, pk, ck)
        local def = jdebug.handledef(__result)

        if def and def.type == '+loc' and def.reference <= 1 then
           -- jdebug.handle_unref(h)
        end

    end
)
]]
--native FlushChildHashtable takes hashtable table, integer parentKey returns nothing
--native FlushParentHashtable takes hashtable table returns nothing