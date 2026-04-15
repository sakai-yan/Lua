local message = require 'jass.message'
--require 'XG_JAPI.Lua.Message'
local message_order_point = message.order_point
local message_order_target = message.order_target
local message_order_immediate = message.order_immediate

--[=[
local FLAG = {
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
]=]
local FLAG = {
    ["队列"] = 1 << 0,    -- 指令进入队列,相当于按住shift发布指令
    ["瞬发"] = 1 << 1,    -- 瞬发指令,该指令会立即触发发布命令事件(即使单位处于晕眩状态)
    ["独立"] = 1 << 2,    -- 单独施放,当选中多个单位时只有一个单位会响应该指令
    ["恢复"] = 1 << 5,    -- 恢复指令,该指令完成后会恢复之前的指令
}


Xfunc[ 'XG_OrderImmediate' ] = function ()
    message_order_immediate
    (
        XGJAPI.integer[1],
        FLAG["独立"] | FLAG["恢复"]
    )
end

Xfunc[ 'XG_OrderTarget' ] = function ()
    message_order_target
    (
        XGJAPI.integer[1],
        XGJAPI.real[2],
        XGJAPI.real[3],
        XGJAPI.integer[4], -- target handle
        FLAG["独立"] | FLAG["恢复"]
    )
end

Xfunc[ 'XG_OrderPoint' ] = function ()
    message_order_point
    (
        XGJAPI.integer[1],
        XGJAPI.real[2],
        XGJAPI.real[3],
        FLAG["独立"] | FLAG["恢复"]
    )
end
