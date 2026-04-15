local Jass = require "Lib.API.Jass"
local Class = require "Lib.Base.Class"
local Ability = Class.get("Ability") or error("Skill.pxlf:未获取到Ability类")
--神通：凭虚临风

local pxlf = Ability.skill("凭虚临风", {
    
    on_execute = function ()
        
    end
})

function pxlf.execute()
    local x = Jass.GetSpellTargetX()
    local y = Jass.GetSpellTargetY()
    local z
end