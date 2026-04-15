local Set = require "Lib.Base.Set"

local has = Set.has

local attach_position_types = Set.addBatch(Set.new(),{
        "chest",        --胸部
        "weapon",       --武器
        "origin",       --起源
        "hand left" ,
        "hand right",
        "foot left" ,
        "foot right",
        "overhead",
    })

--附着点
local AttachPosition = {
    
    types = attach_position_types,

    verify = function (attach_name)
        return has(attach_position_types, attach_name)
    end
}

return AttachPosition
