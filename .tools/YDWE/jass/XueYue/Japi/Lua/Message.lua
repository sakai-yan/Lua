---@diagnostic disable: lowercase-global
---@alias unit unit
----------------------------------------
--      截取自雪月框架 - 防止冲突
----------------------------------------
if(message)then
    return
end
----------------------------------------
--  jass.message hook
----------------------------------------
--[[
keyboard        table: 1E3B7620
order_target    function: 508ACCA4
order_point     function: 508ACC07
order_immediate function: 508ACB91
selection       function: 508AC8FB
button  function: 508AC838
order_enable_debug      function: 508ACD60
mouse   function: 508AC742
local FLAG_UNITTYPE = {
    ["地面"]        = 1 << 1,
    ["空中"]        = 1 << 2,
    ["建筑"]        = 1 << 3,
    ["守卫"]        = 1 << 4,
    ["物品"]        = 1 << 5,
    ["树木"]        = 1 << 6,
    ["墙"]          = 1 << 7,
    ["残骸"]        = 1 << 8,
    ["装饰物"]      = 1 << 9,
    ["桥"]          = 1 << 10,
    ["位置"]        = 1 << 11,
    ["自己"]        = 1 << 12,
    ["玩家单位"]    = 1 << 13,
    ["联盟"]        = 1 << 14,
    ["中立"]        = 1 << 15,
    ["敌人"]        = 1 << 16,
    ["未知"]        = 1 << 17,
    ["未知"]        = 1 << 18,
    ["未知"]        = 1 << 19,
    ["可攻击的"]    = 1 << 20,
    ["无敌"]        = 1 << 21,
    ["英雄"]        = 1 << 22,
    ["非-英雄"]     = 1 << 23,
    ["存活"]        = 1 << 24,
    ["死亡"]        = 1 << 25,
    ["有机生物"]    = 1 << 26,
    ["机械类"]      = 1 << 27,
    ["非-自爆工兵"] = 1 << 28,
    ["自爆工兵"]    = 1 << 29,
    ["非-古树"]     = 1 << 30,
    ["古树"]        = 1 << 31,
}
FLAG["敌我判断"] = FLAG["自己"] | FLAG["玩家单位"] | FLAG["联盟"] | FLAG["中立"] | FLAG["敌人"]

local FLAG_ORDER = {
    ["队列"] = 1 << 0,    -- 指令进入队列,相当于按住shift发布指令
    ["瞬发"] = 1 << 1,    -- 瞬发指令,该指令会立即触发发布命令事件(即使单位处于晕眩状态)
    ["独立"] = 1 << 2,    -- 单独施放,当选中多个单位时只有一个单位会响应该指令
    ["恢复"] = 1 << 5,    -- 恢复指令,该指令完成后会恢复之前的指令
}

["独立"] | ["恢复"]

-- 点目标命令
        message.order_point(order, x, y, FLAG["独立"] | FLAG["恢复"])

-- 单位目标命令
        message.order_target(order, x, y, target, FLAG["独立"] | FLAG["恢复"])
        
-- 无目标命令
        message.order_immediate(order, FLAG["独立"] | FLAG["恢复"])
]]

local mtMsg = require 'jass.message'
local data = {}
---@class message
---@field selection fun():unit 返回玩家选择的第一个单位
message = setmetatable({}, {
    __index = function (_, k)
        return mtMsg[k] or data[k]
    end,
    __newindex = function (_,key,value)
        if mtMsg[key] or key == 'hook' then
            mtMsg[key] = value
            return
        end
        data[key] = value
    end
} )

local defaultHook = function (msg)

    return true
end

local msgHook = setmetatable(
{
--[[
    ['mouse_down'] = function (msg) --鼠标在 按下 单位或地面时
        local code = msg.code   -- 左键为 1  右键为 4
        local x, y = msg.x, msg.y --鼠标世界坐标

        return true
    end,
    ['mouse_up'] = function (msg) --鼠标弹起

        return true
    end,

    ['mouse_ability'] = function (msg) --当鼠标点击技能按钮事件
        local ability_id = msg.ability
        local order_id = msg.order

        return true
    end,

    ['key_down'] = function (msg) --键盘按下事件  不会跟聊天框冲突
        local code = msg.code --整数 键码
        local state = msg.state -- 默认为0  判断组合键用 alt + 字母键 时  为 4  当 ctrl + 字母键时 为 2  shift 1

        --修改 msg.code 可以进行改键
        msg.code = code

        return true
    end,
    ['key_up'] = function (msg) --键盘弹起事件  不会跟聊天框冲突 
        local code = msg.code --整数 键码
        local state = msg.state -- 默认为0  判断组合键用 alt + 字母键 时  为 4  当 ctrl + 字母键时 为 2

        --修改 msg.code 可以进行改键
        msg.code = code

        return true
    end,
]]
    
},{__index = function (_, _)
    return defaultHook
end})

---使用mouse_down/mouse_up/mouse_ability/key_down/key_up作为key定义函数function(msg)来捕捉/拦截硬件对魔兽的消息
message.msgHook = msgHook

----kk更新后，msg hook会导致崩溃。煞笔kk
message.hook = function (msg)
    
    return msgHook[msg.type] ( msg )
end

--[[
设置 message.msgHook['mouse_down'] = function(msg)

    ......
    ......

    return true
end
即可HOOK鼠标按下事件，对其返回FALSE的话，魔兽将不会处理他

]]
print('Message hook loaded')