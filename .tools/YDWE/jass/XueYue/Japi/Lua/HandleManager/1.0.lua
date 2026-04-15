local cj = require 'jass.common'
local patch = patch

local datas = {}

local loads = {
    'LoadInteger',
    'LoadReal',
    'LoadBoolean',
    'LoadStr',

}
--[[
patch('InitHashtable'):PreFix(
    function (__result)
        
    end
)
local ht = {
    int = {},
    real = {},
    bool = {},
    str = {},
    handle = {},
}
]]
local function init_data( ht, pk )
    local data = datas[ht]
    if not data then
        data = {}
        datas[ht] = data -- unit.ht = {}
    end

    local tb = data[pk]
    if not tb then
        tb = {}
        data = tb   -- unit.ht.pk = {}
    end
    return data, tb
end

local function init_db_str( tb )
    local db = tb.str
    if not db then
        db = {}
        tb.str = db
    end
    return db
end


patch('SaveStr')
    :NoReturnValue()
    :PreFix(
        function (__result, ht, pk, ck, val)
            local data,tb = init_data(ht, pk)
            local db = init_db_str( tb )


            return true
        end
    )

