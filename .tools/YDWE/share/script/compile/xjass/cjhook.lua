local mt = {

}
local patchs = {
--[[
    [funcname] = {

        function( ... ) end,
        function( ... ) end,

    }
]]
}

mt.patchs = patchs
function mt:hook( funcname, ... )
    local list = patchs[ funcname ]
    if not list then
        return
    end

    local params = { ... }


    local paramsCount = #params
    for i = 1, paramsCount do
        params[ i ] = params[ i ]:lighter()
    end

    local ret = funcname .. '( ' .. table.concat( params, ', ' ) .. ' )'

    for _, v in ipairs( list ) do
        local r = v( table.unpack( params ) )
        if r then
            ret = ret .. '\n' .. r
        end
    end

    return ret

end

local type = type
function mt:postfix(funcname, func)
    local list = patchs[ funcname ]
    if not list then
        patchs[ funcname ] = {  }
        list = patchs[ funcname ]
    end
    if type( func ) ~= 'function' then
        log.error( 'cjhook:postfix', funcname, 'func is not function' )
        return
    end
    table.insert( list, func )
end

return mt