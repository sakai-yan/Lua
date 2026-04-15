local trgs = table.new()
function gc_bind_unit_lua( trig )
    trgs[trig] = 'gc_bind_unit'
    return 'DoNothing()'
end

function gc_bind_item_lua( trig )
    trgs[trig] = 'gc_bind_item'
    return 'DoNothing()'
end


cjhook:postfix( 'TriggerAddAction', function( trig, action )
    local fn = trgs[ trig ]
    if not fn then
        return ret
    end

    local ret =  'call ' .. fn .. '(' .. action ..')'

    trgs[trig] = nil

    return ret
end )
