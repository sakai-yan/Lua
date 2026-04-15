if not message then
    require 'XG_JAPI.Lua.Message'
end

local hook_key_down = function (msg) --键盘按下事件  不会跟聊天框冲突
    local code = msg.code --整数 键码
    local state = msg.state -- 默认为0  判断组合键用 alt + 字母键 时  为 4  当 ctrl + 字母键时 为 2  shift 1

    --修改 msg.code 可以进行改键
    msg.code = code
    --print('key_down', code, state)
    if code == 779 then
        return false
    end
    return true
end


Xfunc['XG_Keyboard_Hook'] = function()
    local key = XGJAPI.integer[1]
    local combo = XGJAPI.integer[2]
    local method = XGJAPI.integer[3]

    

end

