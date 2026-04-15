local cj = require "API.cj"
--矩形区域

--对外接口
local Rect = {}

Rect.__WorldBounds__ = cj.GetWorldBounds()

function Rect.getWorldBounds()
    return Rect.__WorldBounds__
end

return Rect