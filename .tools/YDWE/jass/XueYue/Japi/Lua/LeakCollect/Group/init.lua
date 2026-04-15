--local cj = require 'jass.common'
---@type mTimer 中心计时器
local timer = require 'Time.Timer'
local jdebug = require 'jass.debug'
local os_date = os.date
local print = print
local get_def = jdebug.handledef
local unref = jdebug.handle_unref
----------------------------------------
--    单位组 自动排泄系统    by 雪月灬雪歌
----------------------------------------


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
            if def.type == '+grp' and def.reference <= 1 then
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
        print('['.. os_date('%H:%M:%S')..']雪月单位组自动排泄:' , count )
    end
end  )

local fake = function ( __result, ... )
    queue:insert(__result)
    queue[address + __result] = true
    return __result
end

patch('CreateGroup'):PostFix(fake)

--已删除的handle移除队列
patch('DestroyGroup'):NoReturnValue():PreFix(
    function (__result, handle)

        if queue[address + handle] then

            for i, v in ipairs(queue) do

                if queue[ i ] then
                    queue:remove(i)
                    queue[address + handle] = nil
                    break
                end

            end

            local def = get_def(handle)
            if def and def.reference then
                for i = 1, def.reference-1, 1 do
                    unref(handle)
                end
            end

        end
        return __result
    end
)
print('单位组自动排泄系统已启动')