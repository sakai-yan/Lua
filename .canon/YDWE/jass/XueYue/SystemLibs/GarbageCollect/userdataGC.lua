local trgs = table.new()
function gc_bind_unit_lua( trig )
    trgs[trig] = 'gc_bind_unit'
    return 'DoNothing()'
end

function gc_bind_item_lua( trig )
    trgs[trig] = 'gc_bind_item'
    return 'DoNothing()'
end

function TriggerAddAction_lua( trig, action )
    local ret = 'TriggerAddAction(' .. trig .. ',' .. action .. ')'
    trig = trig:lighter()
    action = action:lighter()

    local fn = trgs[ trig ]
    if not fn then
        return ret
    end

    ret = ret ..  '\ncall ' .. fn .. '(' .. action ..')'

    trgs[trig] = nil

    return ret
end
