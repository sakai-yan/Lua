local Constant = require("Lib.API.Constant")
local BitSet = require("Lib.Base.BitSet")

--目标允许
local TargetType = {
    ["地形"] = Constant.TARGET_ALLOW_TERRAIN,
    ["没有"] = Constant.TARGET_ALLOW_NONE,
    ["地面"] = Constant.TARGET_ALLOW_GROUND,
    ["空中"] = Constant.TARGET_ALLOW_AIR,
    ["建筑"] = Constant.TARGET_ALLOW_STRUCTURE,
    ["守卫"] = Constant.TARGET_ALLOW_WARD,
    ["物品"] = Constant.TARGET_ALLOW_ITEM,
    ["树木"] = Constant.TARGET_ALLOW_TREE,
    ["墙"] = Constant.TARGET_ALLOW_WALL,
    ["残骸"] = Constant.TARGET_ALLOW_DEBRIS,
    ["装饰物"] = Constant.TARGET_ALLOW_DECORATION,
    ["桥"] = Constant.TARGET_ALLOW_BRIDGE,
    ["自己"] = Constant.TARGET_ALLOW_SELF,
    ["玩家单位"] = Constant.TARGET_ALLOW_PLAYER,
    ["联盟"] = Constant.TARGET_ALLOW_ALLIES,
    ["友军单位"] = Constant.TARGET_ALLOW_FRIEND,
    ["中立"] = Constant.TARGET_ALLOW_NEUTRAL,
    ["敌人"] = Constant.TARGET_ALLOW_ENEMIES,
    ["别人"] = Constant.TARGET_ALLOW_NOTSELF,
    ["可攻击的"] = Constant.TARGET_ALLOW_VULNERABLE,
    ["无敌"] = Constant.TARGET_ALLOW_INVULNERABLE,
    ["英雄"] = Constant.TARGET_ALLOW_HERO,
    ["非英雄"] = Constant.TARGET_ALLOW_NONHERO,
    ["存活"] = Constant.TARGET_ALLOW_ALIVE,
    ["死亡"] = Constant.TARGET_ALLOW_DEAD,
    ["有机生物"] = Constant.TARGET_ALLOW_ORGANIC,
    ["机械类"] = Constant.TARGET_ALLOW_MECHANICAL,
    ["非自爆工兵"] = Constant.TARGET_ALLOW_NONSAPPER,
    ["自爆工兵"] = Constant.TARGET_ALLOW_SAPPER,
    ["非古树"] = Constant.TARGET_ALLOW_NONANCIENT,
    ["古树"] = Constant.TARGET_ALLOW_ANCIENT
}

--获取目标允许
--用法：TargetType("敌人", "中立", ...)
setmetatable(TargetType, {
    __call = function (t, ...)
        local target_allow = 0
        local bitset = BitSet.add
        for index = 1, select('#', ...) do
            local tarType = TargetType[select(index, ...)]
            if tarType then
                target_allow = bitset(target_allow, tarType)
            else
                print("TargetType警告: 未知的目标类型: " .. tostring(select(index, ...)))
            end
        end
        return target_allow
    end
})


return TargetType