
local is_init = false

local Game
Game = {
    
    init_callbacks = {},

    --将回调装入执行队列，用于在加载完所有库后统一执行
    hookInit = function(callback)
        if not is_init and type(callback) == "function" then
            table.insert(Game.init_callbacks, callback)
        end
    end,

    --执行执行队列中的所有回调
    execute = function ()
        if is_init then return end
        local init_callbacks = Game.init_callbacks
        for index = 1, #init_callbacks do
            pcall(init_callbacks[index])
        end
        is_init = true
        Game.init_callbacks = nil
    end
}

return Game
