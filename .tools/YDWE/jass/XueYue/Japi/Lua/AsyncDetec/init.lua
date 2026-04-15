---@type mTimer 中心计时器
local timer = require 'Time.Timer'
local cj = require 'jass.common'
local japi = require 'jass.japi'

local get_rad = cj.GetRandomInt
local new_location = cj.Location
local del_location = cj.RemoveLocation

local DzSyncData = japi.DzSyncData
local DzGetTriggerSyncData = japi.DzGetTriggerSyncData
local sync_tag = 'xg_AsyncDetec'

local my_rad = 0
local my_h = 0

local lpid = cj.GetPlayerId(cj.GetLocalPlayer()) + 1

local times = 0

local action = function ()
    if times < 1 then
        return
    end
    local msg = DzGetTriggerSyncData() or ''
    local id, rad, h = msg:match 'p=(%d-)&rad=(%-?%d-)&h=(.+)'
    if not(id and rad and h) then
        print '异步检测: 获取同步数据失败'
        return
    end
    id = id // 1 | 0
    rad = rad // 1 | 0
    h = h // 1 | 0


    local async
    local errmsg = ''
    if (rad ~= my_rad) then
        errmsg = errmsg .. ' |cffff0000随机数:' .. my_rad .. ' != ' .. rad
        async = true
    end
    if (h ~= my_h) then
        errmsg = errmsg .. ' |cffffff00HandleId:' .. my_h .. ' != ' .. h
        async = true
    end

    if async then
        times = times - 1
        cj.DisplayTimedTextFromPlayer(
            cj.GetLocalPlayer(),
            0.00,
            0.00,
            10,
            '异步检测:与玩家' .. id .. "数据比对异常 " .. errmsg
        )

    end
end


--    native DzTriggerRegisterSyncData takes trigger trig, string prefix, boolean server returns nothing

local on_start = function ()
    local trig = cj.CreateTrigger()
    japi.DzTriggerRegisterSyncData( trig, sync_tag, false )
    cj.TriggerAddAction( trig, action )


    timer:loop( 1, function (t)
        my_rad = get_rad(1, 100) or 0
        my_h = new_location( 0.00 , 0.00 )
        del_location( my_h )

        for i = 1, 12 do
            if i == lpid then
                local msg = 'p=' .. lpid .. '&rad=' .. my_rad .. '&h=' .. my_h
                DzSyncData( sync_tag, msg )
                break
            end
        end
        
    end )

end
local is_start
--设置异步提示次数
Xfunc['XG_AsyncDetec_setTimes'] = function ()
    times = XGJAPI.integer[1]
    if not is_start then
        is_start = true
        on_start()
    end
end
