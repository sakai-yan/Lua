local jdebug = require "jass.debug"

local typesLabel = {
    all = "正在使用",
    max = "最大值",

    ["+flt"] = "过滤器",

    ["+tmr"] = "计时器",
    ['ghth'] = "哈希表",
    ['+mdb'] = "多面板",
    ["+loc"] = "点",

    ["+EIP"] = "对点特效",
    ["+EIm"] = "附着特效",
    ['+EIf'] = "施法特效",
    
    ['+dlb'] = "对话框按钮",
    ['+dlg'] = "对话框",

    ["+ply"] = "玩家",
    ["+frc"] = "玩家组",

    ["+w3u"] = "单位",
    ["+grp"] = "单位组",

    ["item"] = "物品",
    ['ipol'] = "物品池",

    ["+w3d"] = "可破坏物",

    ["+rct"] = "区域",
    ["+snd"] = "声音",
    ["+que"] = "任务",

    ["+trg"] = "触发器",
    ["+tac"] = "触发器动作",
    ["tcnd"] = "触发器条件",

    ["pcvt"] = "玩家聊天事件",
    ["pevt"] = "玩家事件",
    ["uevt"] = "单位事件",
    ["wdvt"] = "可破坏物事件",

    ["+rev"] = "其他事件",
    ["alvt"] = "其他事件",
    ["bevt"] = "其他事件",
    ["devt"] = "其他事件",
    ["gevt"] = "其他事件",
    ["gfvt"] = "其他事件",
    ["psvt"] = "其他事件",
    ["tmet"] = "其他事件",
    ["tmvt"] = "其他事件",

    ['+agr'] = "范围",
}
local cj = require 'jass.common'
local japi = require "jass.japi"
local DisplayTimedTextToPlayer = cj.DisplayTimedTextToPlayer
local GetLocalPlayer = cj.GetLocalPlayer
local print = function(msg)
    DisplayTimedTextToPlayer( GetLocalPlayer(), 0, 0, 30, msg )
end

local first = true
local cache_count = {
[0] = 0,
}

local debugData = function()
    local types = {  }
    local count = { all = 0, max = jdebug.handlemax() }
    for c = 1, count.max do
        local h = 0x100000 + c
        local info = jdebug.handledef(h)
        if (info and info.type) then
            local typeName = typesLabel[info.type] or info.type
            if not types[ typeName ] then
                table.insert(types, typeName)
                types[ typeName ] = true
                if not cache_count[typeName] then
                    cache_count[0] = cache_count[0] + 1
                    cache_count[ cache_count[0] ] = typeName
                end
            end
            if (count[typeName] == nil) then
                count[typeName] = 0
            end
            count.all = count.all + 1
            count[typeName] = count[typeName] + 1
        end
    end

    if japi.DzGetJassStringTableCount then
        if not cache_count[ '字符串' ] then
            cache_count[0] = cache_count[0] + 1
            cache_count[ cache_count[0] ] = "字符串"
        end
        count['字符串'] = japi.DzGetJassStringTableCount()
    end

    local txts = {}
    local i = 0
    local index = 1

    local col = 2
    if cache_count[0] > 26 then
        col = 3
    end

    txts[index] = "--------雪月泄露检测--------"
    for _, t in ipairs(cache_count) do

        count[t] = count[t] or 0
        local delta = count[t] - (cache_count[t] or 0)

        if count[t] == 0 and count[t] == delta then
            goto next_cache
        end

        i = i + 1

        if i == col then
            i = 0
        elseif i == 1 then
            index = index + 1
            txts[index] = ""
        end

        local cnt = count[t] .. ''
        local lcnt = #cnt

        if first then
            delta = 0
        end
        cache_count[t] = count[t]
        if delta > 0 then
            cnt = cnt .. "(|cffff0000+" .. (delta) .. '|r)'
        elseif delta < 0 then
            cnt = cnt .. "(|cff00ff00-" .. (-delta) ..'|r)'
        end

        if delta == 0 then
            cnt = cnt .. (" "):rep(13 - lcnt)
        else
            cnt = cnt .. (" "):rep(13 - lcnt - 2 - #(delta..'') )
        end

        local lab = t

        lab = lab .. (" "):rep( (6*2 - lab:calc_width())-1 )

        local str = ("  %s : %s  "):format(  lab ,   cnt )

        --if count[t] == 0 then

        --end

        txts[index] =  txts[index] .. str
        ::next_cache::
    end

    index = index + 1
    txts [index] = ' '.. typesLabel.all .. " = " ..(count.all or 0) .. "         " .. typesLabel.max .. " = " ..(count.max or 0)
    index = index + 1
    txts[index] = "--------".. os.date("%H:%M:%S",os.time()) .. "--------"

    for _,v in ipairs(txts) do
        print( v )
    end
    first = false
end

Xfunc.LeakMonitor = debugData
