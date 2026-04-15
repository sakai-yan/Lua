local trgs = table.new()


local vaildEventType = {
    Show = 1,
    Hide = 2,

}
local uni = require 'ffi.unicode'
local L = uni.a2u
local type = type
function XG_TipToolAbilityBasic_AsyncEvent_lua( trig, eventType)
    local ret
    local errMsg = ''
    while true do
        if type( eventType ) ~= 'string' then
            errMsg = '触发器参数错误'
            break
        end
        if type( trig ) ~= 'string' then
            errMsg = '事件类型参数错误'
            break
        end
        trig = trig:lighter()
        eventType = eventType:lighter()
        -- 去除引号
        if eventType:match('^%b""') then
            eventType = eventType:match '"(.-)"'
        end
        local eid = vaildEventType[eventType]
        if not eid then
            errMsg = '事件类型参数错误'
            break
        end
        ret = true
        break
    end

    if not ret then
        error( '\n' ..
            L('雪月技能UI事件 - ' .. errMsg) .. ':\n' ..
            L'触发器: ' .. (trig or 'nil') .. '\n' ..
            L'事件类型: ' .. (eventType or 'nil')
        )
    end
    trgs[ trig ] = {
        args = { trig, eventType }
    }
    return 'DoNothing()'
end

cjhook:postfix( 'TriggerAddAction', function( trig, action )
    local rec = trgs[ trig ]
    local ret
    if rec then
        local args = rec.args
        ret = (ret or '') .. (
            'call TriggerAddCondition( %s, Condition(%s) )'
        )
        :format(
            'XGUITipToolAbility_AsyncEventTrigger_' .. args[2] ,
            action
        )

        trgs[trig] = nil
    end

    return ret
end )


