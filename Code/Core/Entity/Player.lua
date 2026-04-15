local Jass = require("Lib.API.Jass")
local Constant = require("Lib.API.Constant")
local Tool = require("Lib.API.Tool")
local Class = require("Lib.Base.Class")
local DataType = require("Lib.Base.DataType")


local Player

Player = Class("Player", {

    --实例以键值弱引用的方式存储数据
    __mode = "kv",

    --存放所有玩家实例，强引用，用于保证player不被回收，也可以用id为索引获取玩家
    __players = {},

    --可以以句柄为索引获取玩家
    __players_by_handle = table.setmode({}, "kv"),

    --实例构造器
    ---@param class table Player类
    ---@param player_handle userdata|nil 玩家句柄（可选）
    ---@return table|nil 玩家实例
    ---@usage local player = Player.new(Jass.Player(0))
    __constructor__ = function (class, player_handle)
        if __DEBUG__ then
            assert(Tool.isHandleType(player_handle, "player"), "Player.__constructor__:不能用非player的句柄创建玩家实例")
        end
        if not player_handle or class.__players_by_handle[player_handle] then return nil end

        local player = DataType.set({
            handle = player_handle,
            id = Jass.GetPlayerId(player_handle)
        }, "player")

        class.__players_by_handle[player.handle] = player
        class.__players[player.id] = player
        return player
    end,

    --根据句柄获取玩家实例
    ---@param player_handle userdata 玩家句柄
    ---@return table|nil 玩家实例
    getPlayerByHandle = function (player_handle)
        return Player.__players_by_handle[player_handle]
    end,

    --根据id获取玩家实例
    ---@param player_id number 玩家id
    ---@return table|nil 玩家实例
    getPlayerById = function (player_id)
        return Player.__players[player_id]
    end,

    --获取本地玩家实例
    ---@return table|nil 本地玩家实例
    getLocalPlayer = function ()
        return Player.__players_by_handle[Jass.GetLocalPlayer()]
    end,

    ---@阵营颜色 playercolor
    _player_color = table.setmode({
        RED = Constant.PLAYER_COLOR_RED,                --红色
        BLUE = Constant.PLAYER_COLOR_BLUE,              --蓝色
        CYAN = Constant.PLAYER_COLOR_CYAN,              --青色
        PURPLE = Constant.PLAYER_COLOR_PURPLE,          --紫色
        YELLOW = Constant.PLAYER_COLOR_YELLOW,          --黄色
        ORANGE = Constant.PLAYER_COLOR_ORANGE,          --橙色
        GREEN = Constant.PLAYER_COLOR_GREEN,            --绿色
        PINK = Constant.PLAYER_COLOR_PINK,              --粉色
        LIGHT_GRAY = Constant.PLAYER_COLOR_LIGHT_GRAY,  --灰色
        LIGHT_BLUE = Constant.PLAYER_COLOR_LIGHT_BLUE,  --浅蓝色
        AQUA = Constant.PLAYER_COLOR_AQUA,              --青色
        BROWN = Constant.PLAYER_COLOR_BROWN,            --棕色
    }, "v"),

    ---@种族 race
    _player_race = table.setmode({
        HUMAN = Constant.RACE_HUMAN,                  --人类
        ORC = Constant.RACE_ORC,                      --兽族
        UNDEAD = Constant.RACE_UNDEAD,                --亡灵
        NIGHTELF = Constant.RACE_NIGHTELF,            --夜精灵
        DEMON = Constant.RACE_DEMON,                  --恶魔
        OTHER = Constant.RACE_OTHER,                  --其他
    }, "v"),

    ---@联盟类型 alliance_type
    _alliance_type = table.setmode({
        PASSIVE = Constant.ALLIANCE_PASSIVE,          --被动
        HELP_REQUEST = Constant.ALLIANCE_HELP_REQUEST, --求助
        HELP_RESPONSE = Constant.ALLIANCE_HELP_RESPONSE, --回应
        SHARED_XP = Constant.ALLIANCE_SHARED_XP,        --共享经验
        SHARED_SPELLS = Constant.ALLIANCE_SHARED_SPELLS, --共享技能
        SHARED_VISION = Constant.ALLIANCE_SHARED_VISION, --共享视野
        SHARED_CONTROL = Constant.ALLIANCE_SHARED_CONTROL, --共享控制
    }, "v"),

    __attributes__ = {

        ---@名字 string
        ---@usage player.name = "玩家名字"
        ---@usage local name = player.name
        {
            name = "name",
            get = function (player)
                return Jass.GetPlayerName(player.handle)
            end,
            set = function (player, player_name)
                Jass.SetPlayerName(player.handle, player_name)
            end
        },

        ---@阵营 integer
        ---@usage player.team = 1
        ---@usage local team = player.team
        {
            name = "team",
            get = function (player)
                return Jass.GetPlayerTeam(player.handle)
            end,
            set = function (player, team)
                Jass.SetPlayerTeam(player.handle, team)
            end
        },

        ---@颜色 playercolor
        ---@usage player.color = Player._player_color.RED
        ---@usage local color = player.color
        {
            name = "color",
            get = function (player)
                return Jass.GetPlayerColor(player.handle)
            end,
            set = function (player, color)
                Jass.SetPlayerColor(player.handle, color)
            end
        },

        ---@金钱 integer
        ---@usage player.gold = 100
        ---@usage local gold = player.gold
        {
            name = "gold",
            get = function (player)
                return Jass.GetPlayerState(player.handle, Constant.PLAYER_STATE_RESOURCE_GOLD)
            end,
            set = function (player, gold_value)
                Jass.SetPlayerState(player.handle, Constant.PLAYER_STATE_RESOURCE_GOLD, gold_value)
            end
        },

        ---@木材 integer
        ---@usage player.lumber = 100
        ---@usage local lumber = player.lumber
        {
            name = "lumber",
            get = function (player)
                return Jass.GetPlayerState(player.handle, Constant.PLAYER_STATE_RESOURCE_LUMBER)
            end,
            set = function (player, lumber_value)
                Jass.SetPlayerState(player.handle, Constant.PLAYER_STATE_RESOURCE_LUMBER, lumber_value)
            end
        }

    }
})

function Player.getId(player)
    if not player then
        return nil
    end
    return player.id
end

-- 增加金钱
function Player.addGold(player, amount)
    if not player or not Tool.isHandleType(player.handle, "player") then return end
    player.gold = player.gold + amount
end

-- 增加木材
function Player.addLumber(player, amount)
    if not player or not Tool.isHandleType(player.handle, "player") then return end
    player.lumber = player.lumber + amount
end

--是否敌对
--[[
    player[other_player]
]]
function Player.isEnemy(player, other_player)
    return Jass.IsPlayerEnemy(player.handle, other_player.handle)
end

--原生玩家预创建
local function player_init()
    for index = 0, 15 do
        Player.new(Jass.Player(index))
    end
end

player_init()

return Player