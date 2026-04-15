local cj = require 'jass.common'
local TriggerEvaluate = cj.TriggerEvaluate
local TriggerExecute = cj.TriggerExecute
local CreateTrigger = cj.CreateTrigger
local MAX_PLAYER_SLOTS = 16
local table_new = table.new
--[[
    native TriggerRegisterPlayerUnitEvent takes trigger whichTrigger, player whichPlayer, playerunitevent whichPlayerUnitEvent, boolexpr filter returns event
]]


--id1-16 与 玩家handle直接相互转换
local players = {}
for i = 1, MAX_PLAYER_SLOTS, 1 do
    local p = cj.Player(i-1)
    players[i] = p
    players[p] = i
end

local center = {

}
local actions = {

}

local trigs = table_new(

)

local function exec_trig_condition(trig)
    if TriggerEvaluate(trig) then
        TriggerExecute(trig)
    end
end


patch('TriggerRegisterPlayerUnitEvent'):PreFix(
    function (__result, _trig, _player, _evtType, filter)
        if filter and filter ~= 0 then
            return __result --带过滤器放行
        end

        local newTriggerRequired = false


        local list_player = trigs[_player]

        if not list_player then
            newTriggerRequired = true
            list_player = table_new()
            trigs[_player] = list_player
        end


        local list_evt = trigs[_player][_evtType]

        if not list_evt then
            newTriggerRequired = true

            list_evt = table_new()

            trigs[_player][_evtType] = list_evt

            center[_player] = {
                [_evtType] = CreateTrigger() ,
            }
            list_player:insert( list_evt )
        end


        if newTriggerRequired then
            ------------Trigger_Action----------------
            if not actions[_player] then
                actions[_player] = {}
            end
            actions[_player][_evtType] = function ()

                for i=1, list_evt[0] do

                    exec_trig_condition(  list_evt[i].trig  )

                end

            end
            ----------------------------------------
            cj.TriggerRegisterPlayerUnitEvent( center[_player][_evtType], _player, _evtType, nil )
            cj.TriggerAddAction( center[_player][_evtType], actions[_player][_evtType] )
        end

        list_evt:insert(
            {
                trig = _trig,
                --player = _player,
                evt = _evtType,
                --filter = nil,
            }
        )

        trigs[_trig] = true
        -- return NULL
        return 0
    end
)

--[=[
    Player
        - index evts

    Evts
        - index cache
]=]


patch('DestroyTrigger'):NoReturnValue():PreFix(
    function (__result, _trig)

        if not trigs[_trig] then
            return __result
        end

        trigs[_trig] = nil

        for i = 1, MAX_PLAYER_SLOTS, 1 do
            local list_player =  trigs[ players[i] ]

            for n, list_evt in ipairs(list_player) do
                local j, jmax = 1, list_evt[0]
                local offset = 0

                while j <= jmax do

                    if list_evt[j].trig == _trig then
                        offset = offset + 1

                        list_evt[j] = list_evt[j + offset]
                        list_evt[j + offset] = nil
                        j = j - 1
                        jmax = jmax - 1
                    end

                    j = j + 1
                end

                list_evt[jmax + 1] = nil
                list_evt[0] = jmax

            end

        end

        return __result
    end

)


print('玩家事件优化 已启动')