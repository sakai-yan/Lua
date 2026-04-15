--Ability系统的常数库
local common = require'jass.common'
local japi = require'jass.japi'

local Constant = {
    --@alias aidifficulty integer

    ---@type aidifficulty
    ---AI难度: 简单<br>
    ---来源: common.j
    AI_DIFFICULTY_NEWBIE = common.AI_DIFFICULTY_NEWBIE,
    ---@type aidifficulty
    ---AI难度: 普通<br>
    ---来源: common.j
    AI_DIFFICULTY_NORMAL = common.AI_DIFFICULTY_NORMAL,
    ---@type aidifficulty
    ---AI难度: 困难<br>
    ---来源: common.j
    AI_DIFFICULTY_INSANE = common.AI_DIFFICULTY_INSANE,



    --@alias alliancetype integer

    ---@type alliancetype
    ---联盟类型: 结盟 (不侵犯)<br>
    ---来源: common.j
    ALLIANCE_PASSIVE = common.ALLIANCE_PASSIVE,
    ---@type alliancetype
    ---联盟类型: 救援请求<br>
    ---来源: common.j
    ALLIANCE_HELP_REQUEST = common.ALLIANCE_HELP_REQUEST,
    ---@type alliancetype
    ---联盟类型: 救援回应<br>
    ---来源: common.j
    ALLIANCE_HELP_RESPONSE = common.ALLIANCE_HELP_RESPONSE,
    ---@type alliancetype
    ---联盟类型: 共享经验值<br>
    ---来源: common.j
    ALLIANCE_SHARED_XP = common.ALLIANCE_SHARED_XP,
    ---@type alliancetype
    ---联盟类型: 盟友魔法锁定<br>
    ---来源: common.j
    ALLIANCE_SHARED_SPELLS = common.ALLIANCE_SHARED_SPELLS,
    ---@type alliancetype
    ---联盟类型: 共享视野<br>
    ---来源: common.j
    ALLIANCE_SHARED_VISION = common.ALLIANCE_SHARED_VISION,
    ---@type alliancetype
    ---联盟类型: 共享单位<br>
    ---来源: common.j
    ALLIANCE_SHARED_CONTROL = common.ALLIANCE_SHARED_CONTROL,
    ---@type alliancetype
    ---联盟类型: 完全共享单位控制<br>
    ---来源: common.j
    ALLIANCE_SHARED_ADVANCED_CONTROL = common.ALLIANCE_SHARED_ADVANCED_CONTROL,
    ---@type alliancetype
    ---联盟类型: 可营救<br>
    ---来源: common.j
    ALLIANCE_RESCUABLE = common.ALLIANCE_RESCUABLE,
    ---@type alliancetype
    ---联盟类型: 共享视野<br>
    ---来源: common.j
    ALLIANCE_SHARED_VISION_FORCED = common.ALLIANCE_SHARED_VISION_FORCED,



    --@alias attacktype integer

    ---@type attacktype
    ---攻击类型: 法术<br>
    ---来源: common.j
    ATTACK_TYPE_NORMAL = common.ATTACK_TYPE_NORMAL,
    ---@type attacktype
    ---攻击类型: 普通<br>
    ---来源: common.j
    ATTACK_TYPE_MELEE = common.ATTACK_TYPE_MELEE,
    ---@type attacktype
    ---攻击类型: 穿刺<br>
    ---来源: common.j
    ATTACK_TYPE_PIERCE = common.ATTACK_TYPE_PIERCE,
    ---@type attacktype
    ---攻击类型: 攻城<br>
    ---来源: common.j
    ATTACK_TYPE_SIEGE = common.ATTACK_TYPE_SIEGE,
    ---@type attacktype
    ---攻击类型: 魔法<br>
    ---来源: common.j
    ATTACK_TYPE_MAGIC = common.ATTACK_TYPE_MAGIC,
    ---@type attacktype
    ---攻击类型: 混乱<br>
    ---来源: common.j
    ATTACK_TYPE_CHAOS = common.ATTACK_TYPE_CHAOS,
    ---@type attacktype
    ---攻击类型: 英雄<br>
    ---来源: common.j
    ATTACK_TYPE_HERO = common.ATTACK_TYPE_HERO,



    --@alias blendmode integer

    ---@type blendmode
    ---混合方式: 无混合物<br>
    ---来源: common.j
    BLEND_MODE_NONE = common.BLEND_MODE_NONE,
    ---@type blendmode
    ---混合方式: 无视混合物<br>
    ---来源: common.j
    BLEND_MODE_DONT_CARE = common.BLEND_MODE_DONT_CARE,
    ---@type blendmode
    ---混合方式: 关键的alpha混合物<br>
    ---来源: common.j
    BLEND_MODE_KEYALPHA = common.BLEND_MODE_KEYALPHA,
    ---@type blendmode
    ---混合方式: 普通混合物<br>
    ---来源: common.j
    BLEND_MODE_BLEND = common.BLEND_MODE_BLEND,
    ---@type blendmode
    ---混合方式: 附加的混合物<br>
    ---来源: common.j
    BLEND_MODE_ADDITIVE = common.BLEND_MODE_ADDITIVE,
    ---@type blendmode
    ---混合方式: 调整的混合物<br>
    ---来源: common.j
    BLEND_MODE_MODULATE = common.BLEND_MODE_MODULATE,
    ---@type blendmode
    ---混合方式: 调整的2倍混合物<br>
    ---来源: common.j
    BLEND_MODE_MODULATE_2X = common.BLEND_MODE_MODULATE_2X,



    --@alias camerafield integer

    ---@type camerafield
    ---镜头属性: 镜头距离<br>
    ---来源: common.j
    CAMERA_FIELD_TARGET_DISTANCE = common.CAMERA_FIELD_TARGET_DISTANCE,
    ---@type camerafield
    ---镜头属性: 远景裁剪<br>
    ---来源: common.j
    CAMERA_FIELD_FARZ = common.CAMERA_FIELD_FARZ,
    ---@type camerafield
    ---镜头属性: X 轴旋转角度<br>
    ---来源: common.j
    CAMERA_FIELD_ANGLE_OF_ATTACK = common.CAMERA_FIELD_ANGLE_OF_ATTACK,
    ---@type camerafield
    ---镜头属性: 镜头区域<br>
    ---来源: common.j
    CAMERA_FIELD_FIELD_OF_VIEW = common.CAMERA_FIELD_FIELD_OF_VIEW,
    ---@type camerafield
    ---镜头属性: Y 轴旋转角度<br>
    ---来源: common.j
    CAMERA_FIELD_ROLL = common.CAMERA_FIELD_ROLL,
    ---@type camerafield
    ---镜头属性: Z 轴旋转角度<br>
    ---来源: common.j
    CAMERA_FIELD_ROTATION = common.CAMERA_FIELD_ROTATION,
    ---@type camerafield
    ---镜头属性: Z 轴偏移<br>
    ---来源: common.j
    CAMERA_FIELD_ZOFFSET = common.CAMERA_FIELD_ZOFFSET,
    ---@type camerafield
    ---镜头属性: 近景裁剪<br>
    ---来源: common.j
    CAMERA_FIELD_NEARZ = common.CAMERA_FIELD_NEARZ,
    ---@type camerafield
    ---镜头属性: 局部纵摇(Z 轴)<br>
    ---来源: common.j
    CAMERA_FIELD_LOCAL_PITCH = common.CAMERA_FIELD_LOCAL_PITCH,
    ---@type camerafield
    ---镜头属性: 局部横摇(X 轴)<br>
    ---来源: common.j
    CAMERA_FIELD_LOCAL_YAW = common.CAMERA_FIELD_LOCAL_YAW,
    ---@type camerafield
    ---镜头属性: 局部滚摇(Y 轴)<br>
    ---来源: common.j
    CAMERA_FIELD_LOCAL_ROLL = common.CAMERA_FIELD_LOCAL_ROLL,



    --@alias damagetype integer

    ---@type damagetype
    ---伤害类型: 未知<br>
    ---来源: common.j
    DAMAGE_TYPE_UNKNOWN = common.DAMAGE_TYPE_UNKNOWN,
    ---@type damagetype
    ---伤害类型: 普通<br>
    ---来源: common.j
    DAMAGE_TYPE_NORMAL = common.DAMAGE_TYPE_NORMAL,
    ---@type damagetype
    ---伤害类型: 强化<br>
    ---来源: common.j
    DAMAGE_TYPE_ENHANCED = common.DAMAGE_TYPE_ENHANCED,
    ---@type damagetype
    ---伤害类型: 火焰<br>
    ---来源: common.j
    DAMAGE_TYPE_FIRE = common.DAMAGE_TYPE_FIRE,
    ---@type damagetype
    ---伤害类型: 冰冻<br>
    ---来源: common.j
    DAMAGE_TYPE_COLD = common.DAMAGE_TYPE_COLD,
    ---@type damagetype
    ---伤害类型: 闪电<br>
    ---来源: common.j
    DAMAGE_TYPE_LIGHTNING = common.DAMAGE_TYPE_LIGHTNING,
    ---@type damagetype
    ---伤害类型: 毒药<br>
    ---来源: common.j
    DAMAGE_TYPE_POISON = common.DAMAGE_TYPE_POISON,
    ---@type damagetype
    ---伤害类型: 疾病<br>
    ---来源: common.j
    DAMAGE_TYPE_DISEASE = common.DAMAGE_TYPE_DISEASE,
    ---@type damagetype
    ---伤害类型: 神圣<br>
    ---来源: common.j
    DAMAGE_TYPE_DIVINE = common.DAMAGE_TYPE_DIVINE,
    ---@type damagetype
    ---伤害类型: 魔法<br>
    ---来源: common.j
    DAMAGE_TYPE_MAGIC = common.DAMAGE_TYPE_MAGIC,
    ---@type damagetype
    ---伤害类型: 音速<br>
    ---来源: common.j
    DAMAGE_TYPE_SONIC = common.DAMAGE_TYPE_SONIC,
    ---@type damagetype
    ---伤害类型: 酸性<br>
    ---来源: common.j
    DAMAGE_TYPE_ACID = common.DAMAGE_TYPE_ACID,
    ---@type damagetype
    ---伤害类型: 力量<br>
    ---来源: common.j
    DAMAGE_TYPE_FORCE = common.DAMAGE_TYPE_FORCE,
    ---@type damagetype
    ---伤害类型: 死亡<br>
    ---来源: common.j
    DAMAGE_TYPE_DEATH = common.DAMAGE_TYPE_DEATH,
    ---@type damagetype
    ---伤害类型: 精神<br>
    ---来源: common.j
    DAMAGE_TYPE_MIND = common.DAMAGE_TYPE_MIND,
    ---@type damagetype
    ---伤害类型: 植物<br>
    ---来源: common.j
    DAMAGE_TYPE_PLANT = common.DAMAGE_TYPE_PLANT,
    ---@type damagetype
    ---伤害类型: 防御<br>
    ---来源: common.j
    DAMAGE_TYPE_DEFENSIVE = common.DAMAGE_TYPE_DEFENSIVE,
    ---@type damagetype
    ---伤害类型: 破坏<br>
    ---来源: common.j
    DAMAGE_TYPE_DEMOLITION = common.DAMAGE_TYPE_DEMOLITION,
    ---@type damagetype
    ---伤害类型: 慢性毒药<br>
    ---来源: common.j
    DAMAGE_TYPE_SLOW_POISON = common.DAMAGE_TYPE_SLOW_POISON,
    ---@type damagetype
    ---伤害类型: 灵魂锁链<br>
    ---来源: common.j
    DAMAGE_TYPE_SPIRIT_LINK = common.DAMAGE_TYPE_SPIRIT_LINK,
    ---@type damagetype
    ---伤害类型: 暗影突袭<br>
    ---来源: common.j
    DAMAGE_TYPE_SHADOW_STRIKE = common.DAMAGE_TYPE_SHADOW_STRIKE,
    ---@type damagetype
    ---伤害类型: 通用<br>
    ---来源: common.j
    DAMAGE_TYPE_UNIVERSAL = common.DAMAGE_TYPE_UNIVERSAL,



    --@alias dialogevent integer

    ---@type dialogevent
    ---对话框事件: 点击对话框按钮<br>
    ---来源: common.j
    EVENT_DIALOG_BUTTON_CLICK = common.EVENT_DIALOG_BUTTON_CLICK,
    ---@type dialogevent
    ---对话框事件: 点击对话框<br>
    ---来源: common.j
    EVENT_DIALOG_CLICK = common.EVENT_DIALOG_CLICK,



    --@alias fogstate integer

    ---@type fogstate
    ---迷雾状态: 黑色阴影<br>
    ---来源: common.j
    FOG_OF_WAR_MASKED = common.FOG_OF_WAR_MASKED,
    ---@type fogstate
    ---迷雾状态: 战争迷雾<br>
    ---来源: common.j
    FOG_OF_WAR_FOGGED = common.FOG_OF_WAR_FOGGED,
    ---@type fogstate
    ---迷雾状态: 可见<br>
    ---来源: common.j
    FOG_OF_WAR_VISIBLE = common.FOG_OF_WAR_VISIBLE,



    --@alias gamedifficulty integer

    ---@type gamedifficulty
    ---游戏难度: 简单<br>
    ---来源: common.j
    MAP_DIFFICULTY_EASY = common.MAP_DIFFICULTY_EASY,
    ---@type gamedifficulty
    ---游戏难度: 普通<br>
    ---来源: common.j
    MAP_DIFFICULTY_NORMAL = common.MAP_DIFFICULTY_NORMAL,
    ---@type gamedifficulty
    ---游戏难度: 困难<br>
    ---来源: common.j
    MAP_DIFFICULTY_HARD = common.MAP_DIFFICULTY_HARD,
    ---@type gamedifficulty
    ---游戏难度: 疯狂<br>
    ---来源: common.j
    MAP_DIFFICULTY_INSANE = common.MAP_DIFFICULTY_INSANE,



    --@alias gameevent integer

    ---@type gameevent
    ---游戏事件: 游戏胜利<br>
    ---来源: common.j
    EVENT_GAME_VICTORY = common.EVENT_GAME_VICTORY,
    ---@type gameevent
    ---游戏事件: 游戏本关结束<br>
    ---来源: common.j
    EVENT_GAME_END_LEVEL = common.EVENT_GAME_END_LEVEL,
    ---@type gameevent
    ---游戏事件: 游戏变量变更<br>
    ---来源: common.j
    EVENT_GAME_VARIABLE_LIMIT = common.EVENT_GAME_VARIABLE_LIMIT,
    ---@type gameevent
    ---游戏事件: 游戏状态变更<br>
    ---来源: common.j
    EVENT_GAME_STATE_LIMIT = common.EVENT_GAME_STATE_LIMIT,
    ---@type gameevent
    ---游戏事件: 游戏超时<br>
    ---来源: common.j
    EVENT_GAME_TIMER_EXPIRED = common.EVENT_GAME_TIMER_EXPIRED,
    ---@type gameevent
    ---游戏事件: 进入区域<br>
    ---来源: common.j
    EVENT_GAME_ENTER_REGION = common.EVENT_GAME_ENTER_REGION,
    ---@type gameevent
    ---游戏事件: 离开区域<br>
    ---来源: common.j
    EVENT_GAME_LEAVE_REGION = common.EVENT_GAME_LEAVE_REGION,
    ---@type gameevent
    ---游戏事件: 鼠标点击可追踪物<br>
    ---来源: common.j
    EVENT_GAME_TRACKABLE_HIT = common.EVENT_GAME_TRACKABLE_HIT,
    ---@type gameevent
    ---游戏事件: 鼠标移动到可追踪物<br>
    ---来源: common.j
    EVENT_GAME_TRACKABLE_TRACK = common.EVENT_GAME_TRACKABLE_TRACK,
    ---@type gameevent
    ---游戏事件: 显示技能<br>
    ---来源: common.j
    EVENT_GAME_SHOW_SKILL = common.EVENT_GAME_SHOW_SKILL,
    ---@type gameevent
    ---游戏事件: 创建子菜单<br>
    ---来源: common.j
    EVENT_GAME_BUILD_SUBMENU = common.EVENT_GAME_BUILD_SUBMENU,
    ---@type gameevent
    ---游戏事件: 游戏加装完毕<br>
    ---来源: common.j
    EVENT_GAME_LOADED = common.EVENT_GAME_LOADED,
    ---@type gameevent
    ---游戏事件: 比赛即将完成<br>
    ---来源: common.j
    EVENT_GAME_TOURNAMENT_FINISH_SOON = common.EVENT_GAME_TOURNAMENT_FINISH_SOON,
    ---@type gameevent
    ---游戏事件: 比赛完成<br>
    ---来源: common.j
    EVENT_GAME_TOURNAMENT_FINISH_NOW = common.EVENT_GAME_TOURNAMENT_FINISH_NOW,
    ---@type gameevent
    ---游戏事件: 存档<br>
    ---来源: common.j
    EVENT_GAME_SAVE = common.EVENT_GAME_SAVE,



    --@alias gamespeed integer

    ---@type gamespeed
    ---游戏速度: 最慢速<br>
    ---来源: common.j
    MAP_SPEED_SLOWEST = common.MAP_SPEED_SLOWEST,
    ---@type gamespeed
    ---游戏速度: 慢速<br>
    ---来源: common.j
    MAP_SPEED_SLOW = common.MAP_SPEED_SLOW,
    ---@type gamespeed
    ---游戏速度: 正常<br>
    ---来源: common.j
    MAP_SPEED_NORMAL = common.MAP_SPEED_NORMAL,
    ---@type gamespeed
    ---游戏速度: 快速<br>
    ---来源: common.j
    MAP_SPEED_FAST = common.MAP_SPEED_FAST,
    ---@type gamespeed
    ---游戏速度: 最快速<br>
    ---来源: common.j
    MAP_SPEED_FASTEST = common.MAP_SPEED_FASTEST,



    --@alias itemtype integer

    ---@type itemtype
    ---物品分类: 永久<br>
    ---来源: common.j
    ITEM_TYPE_PERMANENT = common.ITEM_TYPE_PERMANENT,
    ---@type itemtype
    ---物品分类: 可充<br>
    ---来源: common.j
    ITEM_TYPE_CHARGED = common.ITEM_TYPE_CHARGED,
    ---@type itemtype
    ---物品分类: 力量提升<br>
    ---来源: common.j
    ITEM_TYPE_POWERUP = common.ITEM_TYPE_POWERUP,
    ---@type itemtype
    ---物品分类: 人造<br>
    ---来源: common.j
    ITEM_TYPE_ARTIFACT = common.ITEM_TYPE_ARTIFACT,
    ---@type itemtype
    ---物品分类: 可购买<br>
    ---来源: common.j
    ITEM_TYPE_PURCHASABLE = common.ITEM_TYPE_PURCHASABLE,
    ---@type itemtype
    ---物品分类: 战役<br>
    ---来源: common.j
    ITEM_TYPE_CAMPAIGN = common.ITEM_TYPE_CAMPAIGN,
    ---@type itemtype
    ---物品分类: 混杂 (假)<br>
    ---来源: common.j
    ITEM_TYPE_MISCELLANEOUS = common.ITEM_TYPE_MISCELLANEOUS,
    ---@type itemtype
    ---物品分类: 未知<br>
    ---来源: common.j
    ITEM_TYPE_UNKNOWN = common.ITEM_TYPE_UNKNOWN,
    ---@type itemtype
    ---物品分类: 任何<br>
    ---来源: common.j
    ITEM_TYPE_ANY = common.ITEM_TYPE_ANY,



    --@alias limitop integer

    ---@type limitop
    ---变量事件: 小于<br>
    ---来源: common.j
    LESS_THAN = common.LESS_THAN,
    ---@type limitop
    ---变量事件: 小于 或 等于<br>
    ---来源: common.j
    LESS_THAN_OR_EQUAL = common.LESS_THAN_OR_EQUAL,
    ---@type limitop
    ---变量事件: 等于<br>
    ---来源: common.j
    EQUAL = common.EQUAL,
    ---@type limitop
    ---变量事件: 大于 或 等于<br>
    ---来源: common.j
    GREATER_THAN_OR_EQUAL = common.GREATER_THAN_OR_EQUAL,
    ---@type limitop
    ---变量事件: 大于<br>
    ---来源: common.j
    GREATER_THAN = common.GREATER_THAN,
    ---@type limitop
    ---变量事件: 不等于<br>
    ---来源: common.j
    NOT_EQUAL = common.NOT_EQUAL,



    --@alias mapcontrol integer

    ---@type mapcontrol
    ---玩家控制者类型: 用户<br>
    ---默认值在情节-玩家设置编辑, 游戏初始化时会按房间的玩家使用情况(槽位是否有打开/无玩家, 玩家是电脑还是用户)再次设置<br>
    ---来源: common.j
    MAP_CONTROL_USER = common.MAP_CONTROL_USER,
    ---@type mapcontrol
    ---玩家控制者类型: 电脑<br>
    ---默认值在情节-玩家设置编辑, 游戏初始化时会按房间的玩家使用情况(槽位是否有打开/无玩家, 玩家是电脑还是用户)再次设置<br>
    ---来源: common.j
    MAP_CONTROL_COMPUTER = common.MAP_CONTROL_COMPUTER,
    ---@type mapcontrol
    ---玩家控制者类型: 中立可营救<br>
    ---默认值写死, 随版本12/24人自动变化, 即在1.29或以上版本运行低版本编辑器制作的地图时, 该值仍会自动适配<br>
    ---来源: common.j
    MAP_CONTROL_RESCUABLE = common.MAP_CONTROL_RESCUABLE,
    ---@type mapcontrol
    ---玩家控制者类型: 中立被动<br>
    ---默认值写死, 随版本12/24人自动变化, 即在1.29或以上版本运行低版本编辑器制作的地图时, 该值仍会自动适配<br>
    ---来源: common.j
    MAP_CONTROL_NEUTRAL = common.MAP_CONTROL_NEUTRAL,
    ---@type mapcontrol
    ---玩家控制者类型: 中立敌对<br>
    ---默认值写死, 随版本12/24人自动变化, 即在1.29或以上版本运行低版本编辑器制作的地图时, 该值仍会自动适配<br>
    ---来源: common.j
    MAP_CONTROL_CREEP = common.MAP_CONTROL_CREEP,
    ---@type mapcontrol
    ---玩家控制者类型: 没有玩家<br>
    ---默认值在情节-玩家设置编辑, 游戏初始化时会按房间的玩家使用情况(槽位是否有打开/无玩家, 玩家是电脑还是用户)再次设置<br>
    ---来源: common.j
    MAP_CONTROL_NONE = common.MAP_CONTROL_NONE,



    --@alias mapflag integer

    ---@type mapflag
    ---地图参数: 隐藏地形<br>
    ---来源: common.j
    MAP_FOG_HIDE_TERRAIN = common.MAP_FOG_HIDE_TERRAIN,
    ---@type mapflag
    ---地图参数: 已探索地图/可见地形<br>
    ---来源: common.j
    MAP_FOG_MAP_EXPLORED = common.MAP_FOG_MAP_EXPLORED,
    ---@type mapflag
    ---地图参数: 始终可见<br>
    ---来源: common.j
    MAP_FOG_ALWAYS_VISIBLE = common.MAP_FOG_ALWAYS_VISIBLE,
    ---@type mapflag
    ---地图参数: 使用生命障碍<br>
    ---来源: common.j
    MAP_USE_HANDICAPS = common.MAP_USE_HANDICAPS,
    ---@type mapflag
    ---地图参数: 裁判/观战者<br>
    ---来源: common.j
    MAP_OBSERVERS = common.MAP_OBSERVERS,
    ---@type mapflag
    ---地图参数: 战败后成为观战者<br>
    ---来源: common.j
    MAP_OBSERVERS_ON_DEATH = common.MAP_OBSERVERS_ON_DEATH,
    ---@type mapflag
    ---地图参数: 固定玩家颜色<br>
    ---来源: common.j
    MAP_FIXED_COLORS = common.MAP_FIXED_COLORS,
    ---@type mapflag
    ---地图参数: 锁定交易资源 (禁止交易)<br>
    ---来源: common.j
    MAP_LOCK_RESOURCE_TRADING = common.MAP_LOCK_RESOURCE_TRADING,
    ---@type mapflag
    ---地图参数: 限制盟友资源交易<br>
    ---来源: common.j
    MAP_RESOURCE_TRADING_ALLIES_ONLY = common.MAP_RESOURCE_TRADING_ALLIES_ONLY,
    ---@type mapflag
    ---地图参数: 锁定联盟设置 (禁止更改)<br>
    ---来源: common.j
    MAP_LOCK_ALLIANCE_CHANGES = common.MAP_LOCK_ALLIANCE_CHANGES,
    ---@type mapflag
    ---地图参数: 隐藏联盟类型变更<br>
    ---来源: common.j
    MAP_ALLIANCE_CHANGES_HIDDEN = common.MAP_ALLIANCE_CHANGES_HIDDEN,
    ---@type mapflag
    ---地图参数: 作弊码<br>
    ---来源: common.j
    MAP_CHEATS = common.MAP_CHEATS,
    ---@type mapflag
    ---地图参数: 隐藏作弊码<br>
    ---来源: common.j
    MAP_CHEATS_HIDDEN = common.MAP_CHEATS_HIDDEN,
    ---@type mapflag
    ---地图参数: 锁定游戏速度<br>
    ---来源: common.j
    MAP_LOCK_SPEED = common.MAP_LOCK_SPEED,
    ---@type mapflag
    ---地图参数: 禁止随机游戏速度<br>
    ---来源: common.j
    MAP_LOCK_RANDOM_SEED = common.MAP_LOCK_RANDOM_SEED,
    ---@type mapflag
    ---地图参数: 共享高级控制<br>
    ---来源: common.j
    MAP_SHARED_ADVANCED_CONTROL = common.MAP_SHARED_ADVANCED_CONTROL,
    ---@type mapflag
    ---地图参数: 使用随机英雄<br>
    ---来源: common.j
    MAP_RANDOM_HERO = common.MAP_RANDOM_HERO,
    ---@type mapflag
    ---地图参数: 使用随机种族<br>
    ---来源: common.j
    MAP_RANDOM_RACES = common.MAP_RANDOM_RACES,
    ---@type mapflag
    ---地图参数: 地图转换 (加载新地图)<br>
    ---来源: common.j
    MAP_RELOADED = common.MAP_RELOADED,



    --@alias pathingflag integer

    ---@type pathingflag
    ---放置要求: 地面可通行<br>
    ---来源: common.j
    PATHING_FLAG_UNWALKABLE = common.PATHING_FLAG_UNWALKABLE,
    ---@type pathingflag
    ---放置要求: 空中单位可通行<br>
    ---来源: common.j
    PATHING_FLAG_UNFLYABLE = common.PATHING_FLAG_UNFLYABLE,
    ---@type pathingflag
    ---放置要求: 可建造地面<br>
    ---来源: common.j
    PATHING_FLAG_UNBUILDABLE = common.PATHING_FLAG_UNBUILDABLE,
    ---@type pathingflag
    ---放置要求: 工人可采集<br>
    ---来源: common.j
    PATHING_FLAG_UNPEONHARVEST = common.PATHING_FLAG_UNPEONHARVEST,
    ---@type pathingflag
    ---放置要求: 不是荒芜地表<br>
    ---来源: common.j
    PATHING_FLAG_BLIGHTED = common.PATHING_FLAG_BLIGHTED,
    ---@type pathingflag
    ---放置要求: 海面可通行<br>
    ---来源: common.j
    PATHING_FLAG_UNFLOATABLE = common.PATHING_FLAG_UNFLOATABLE,
    ---@type pathingflag
    ---放置要求: 两栖单位可通行<br>
    ---来源: common.j
    PATHING_FLAG_UNAMPHIBIOUS = common.PATHING_FLAG_UNAMPHIBIOUS,
    ---@type pathingflag
    ---放置要求: 物品可通行<br>
    ---来源: common.j
    PATHING_FLAG_UNITEMPLACABLE = common.PATHING_FLAG_UNITEMPLACABLE,



    --@alias pathingtype integer

    ---@type pathingtype
    ---路径类型: 任何<br>
    ---来源: common.j
    PATHING_TYPE_ANY = common.PATHING_TYPE_ANY,
    ---@type pathingtype
    ---路径类型: 可通行地面<br>
    ---来源: common.j
    PATHING_TYPE_WALKABILITY = common.PATHING_TYPE_WALKABILITY,
    ---@type pathingtype
    ---路径类型: 空中单位可通行<br>
    ---来源: common.j
    PATHING_TYPE_FLYABILITY = common.PATHING_TYPE_FLYABILITY,
    ---@type pathingtype
    ---路径类型: 可建造地面<br>
    ---来源: common.j
    PATHING_TYPE_BUILDABILITY = common.PATHING_TYPE_BUILDABILITY,
    ---@type pathingtype
    ---路径类型: 任何采集工人可通行<br>
    ---来源: common.j
    PATHING_TYPE_PEONHARVESTPATHING = common.PATHING_TYPE_PEONHARVESTPATHING,
    ---@type pathingtype
    ---路径类型: 荒芜地表<br>
    ---来源: common.j
    PATHING_TYPE_BLIGHTPATHING = common.PATHING_TYPE_BLIGHTPATHING,
    ---@type pathingtype
    ---路径类型: 可通行海面<br>
    ---来源: common.j
    PATHING_TYPE_FLOATABILITY = common.PATHING_TYPE_FLOATABILITY,
    ---@type pathingtype
    ---路径类型: 两栖单位可通行<br>
    ---来源: common.j
    PATHING_TYPE_AMPHIBIOUSPATHING = common.PATHING_TYPE_AMPHIBIOUSPATHING,



    --@alias playercolor integer

    ---@type playercolor
    ---玩家颜色: 红色<br>
    ---代码: |cFFFF0000|r<br>
    ---三色值: 255, 3, 3<br>
    ---来源: common.j
    PLAYER_COLOR_RED = common.PLAYER_COLOR_RED,
    ---@type playercolor
    ---玩家颜色: 蓝色<br>
    ---代码: |cFF0064FF|r<br>
    ---三色值: 0, 66, 255<br>
    ---来源: common.j
    PLAYER_COLOR_BLUE = common.PLAYER_COLOR_BLUE,
    ---@type playercolor
    ---玩家颜色: 青色<br>
    ---代码: |cFF1BE7BA|r<br>
    ---三色值: 28, 230, 185<br>
    ---来源: common.j
    PLAYER_COLOR_CYAN = common.PLAYER_COLOR_CYAN,
    ---@type playercolor
    ---玩家颜色: 紫色<br>
    ---代码: |cFF550081|r<br>
    ---三色值: 84, 0, 129<br>
    ---来源: common.j
    PLAYER_COLOR_PURPLE = common.PLAYER_COLOR_PURPLE,
    ---@type playercolor
    ---玩家颜色: 黄色<br>
    ---代码: |cFFFFFC00|r<br>
    ---三色值: 255, 252, 0<br>
    ---来源: common.j
    PLAYER_COLOR_YELLOW = common.PLAYER_COLOR_YELLOW,
    ---@type playercolor
    ---玩家颜色: 橙色<br>
    ---代码: |cFFFF8A0D|r<br>
    ---三色值: 254, 138, 14<br>
    ---来源: common.j
    PLAYER_COLOR_ORANGE = common.PLAYER_COLOR_ORANGE,
    ---@type playercolor
    ---玩家颜色: 绿色<br>
    ---代码: |cFF21BF00|r<br>
    ---三色值: 32, 192, 0<br>
    ---来源: common.j
    PLAYER_COLOR_GREEN = common.PLAYER_COLOR_GREEN,
    ---@type playercolor
    ---玩家颜色: 粉色<br>
    ---代码: |cFFE45CAF|r<br>
    ---三色值: 229, 91, 176<br>
    ---来源: common.j
    PLAYER_COLOR_PINK = common.PLAYER_COLOR_PINK,
    ---@type playercolor
    ---玩家颜色: 深灰色<br>
    ---代码: |cFF949696|r<br>
    ---三色值: 149, 150, 151<br>
    ---来源: common.j
    PLAYER_COLOR_LIGHT_GRAY = common.PLAYER_COLOR_LIGHT_GRAY,
    ---@type playercolor
    ---玩家颜色: 深蓝色<br>
    ---代码: |cFF7EBFF1|r<br>
    ---三色值: 126, 191, 241<br>
    ---来源: common.j
    PLAYER_COLOR_LIGHT_BLUE = common.PLAYER_COLOR_LIGHT_BLUE,
    ---@type playercolor
    ---玩家颜色: 浅绿色<br>
    ---代码: |cFF106247|r<br>
    ---三色值: 16, 98, 70<br>
    ---来源: common.j
    PLAYER_COLOR_AQUA = common.PLAYER_COLOR_AQUA,
    ---@type playercolor
    ---玩家颜色: 棕色<br>
    ---代码: |cFF4F2B05|r<br>
    ---三色值: 78, 42, 3<br>
    ---来源: common.j
    PLAYER_COLOR_BROWN = common.PLAYER_COLOR_BROWN,



    --@alias playerevent integer

    ---@type playerevent
    ---玩家事件: 玩家状态变更<br>
    ---来源: common.j
    EVENT_PLAYER_STATE_LIMIT = common.EVENT_PLAYER_STATE_LIMIT,
    ---@type playerevent
    ---玩家事件: 玩家联盟类型变更<br>
    ---来源: common.j
    EVENT_PLAYER_ALLIANCE_CHANGED = common.EVENT_PLAYER_ALLIANCE_CHANGED,
    ---@type playerevent
    ---玩家事件: 玩家失败<br>
    ---来源: common.j
    EVENT_PLAYER_DEFEAT = common.EVENT_PLAYER_DEFEAT,
    ---@type playerevent
    ---玩家事件: 玩家胜利<br>
    ---来源: common.j
    EVENT_PLAYER_VICTORY = common.EVENT_PLAYER_VICTORY,
    ---@type playerevent
    ---玩家事件: 玩家离开游戏<br>
    ---来源: common.j
    EVENT_PLAYER_LEAVE = common.EVENT_PLAYER_LEAVE,
    ---@type playerevent
    ---玩家事件: 玩家聊天<br>
    ---来源: common.j
    EVENT_PLAYER_CHAT = common.EVENT_PLAYER_CHAT,
    ---@type playerevent
    ---玩家事件: 玩家按下 ESC键<br>
    ---来源: common.j
    EVENT_PLAYER_END_CINEMATIC = common.EVENT_PLAYER_END_CINEMATIC,
    ---@type playerevent
    ---玩家事件: 按下 左方向键<br>
    ---来源: common.j
    EVENT_PLAYER_ARROW_LEFT_DOWN = common.EVENT_PLAYER_ARROW_LEFT_DOWN,
    ---@type playerevent
    ---玩家事件: 松开 左方向键<br>
    ---来源: common.j
    EVENT_PLAYER_ARROW_LEFT_UP = common.EVENT_PLAYER_ARROW_LEFT_UP,
    ---@type playerevent
    ---玩家事件: 按下 右方向键<br>
    ---来源: common.j
    EVENT_PLAYER_ARROW_RIGHT_DOWN = common.EVENT_PLAYER_ARROW_RIGHT_DOWN,
    ---@type playerevent
    ---玩家事件: 松开 右方向键<br>
    ---来源: common.j
    EVENT_PLAYER_ARROW_RIGHT_UP = common.EVENT_PLAYER_ARROW_RIGHT_UP,
    ---@type playerevent
    ---玩家事件: 按下 上方向键<br>
    ---来源: common.j
    EVENT_PLAYER_ARROW_DOWN_DOWN = common.EVENT_PLAYER_ARROW_DOWN_DOWN,
    ---@type playerevent
    ---玩家事件: 松开 上方向键<br>
    ---来源: common.j
    EVENT_PLAYER_ARROW_DOWN_UP = common.EVENT_PLAYER_ARROW_DOWN_UP,
    ---@type playerevent
    ---玩家事件: 按下 下方向键<br>
    ---来源: common.j
    EVENT_PLAYER_ARROW_UP_DOWN = common.EVENT_PLAYER_ARROW_UP_DOWN,
    ---@type playerevent
    ---玩家事件: 松开 下方向键<br>
    ---来源: common.j
    EVENT_PLAYER_ARROW_UP_UP = common.EVENT_PLAYER_ARROW_UP_UP,



    --@alias playergameresult integer

    ---@type playergameresult
    ---玩家游戏结果: 胜利<br>
    ---来源: common.j
    PLAYER_GAME_RESULT_VICTORY = common.PLAYER_GAME_RESULT_VICTORY,
    ---@type playergameresult
    ---玩家游戏结果: 失败<br>
    ---来源: common.j
    PLAYER_GAME_RESULT_DEFEAT = common.PLAYER_GAME_RESULT_DEFEAT,
    ---@type playergameresult
    ---玩家游戏结果: 平局<br>
    ---来源: common.j
    PLAYER_GAME_RESULT_TIE = common.PLAYER_GAME_RESULT_TIE,
    ---@type playergameresult
    ---玩家游戏结果: 不确定<br>
    ---来源: common.j
    PLAYER_GAME_RESULT_NEUTRAL = common.PLAYER_GAME_RESULT_NEUTRAL,



    --@alias playerscore integer

    ---@type playerscore
    ---玩家得分: 训练单位数量<br>
    ---来源: common.j
    PLAYER_SCORE_UNITS_TRAINED = common.PLAYER_SCORE_UNITS_TRAINED,
    ---@type playerscore
    ---玩家得分: 消灭单位数量<br>
    ---来源: common.j
    PLAYER_SCORE_UNITS_KILLED = common.PLAYER_SCORE_UNITS_KILLED,
    ---@type playerscore
    ---玩家得分: 已建造建筑数量<br>
    ---来源: common.j
    PLAYER_SCORE_STRUCT_BUILT = common.PLAYER_SCORE_STRUCT_BUILT,
    ---@type playerscore
    ---玩家得分: 被毁建筑数量<br>
    ---来源: common.j
    PLAYER_SCORE_STRUCT_RAZED = common.PLAYER_SCORE_STRUCT_RAZED,
    ---@type playerscore
    ---玩家得分: 科技百分比<br>
    ---来源: common.j
    PLAYER_SCORE_TECH_PERCENT = common.PLAYER_SCORE_TECH_PERCENT,
    ---@type playerscore
    ---玩家得分: 最大可用人口数量<br>
    ---来源: common.j
    PLAYER_SCORE_FOOD_MAXPROD = common.PLAYER_SCORE_FOOD_MAXPROD,
    ---@type playerscore
    ---玩家得分: 最大使用人口数量<br>
    ---来源: common.j
    PLAYER_SCORE_FOOD_MAXUSED = common.PLAYER_SCORE_FOOD_MAXUSED,
    ---@type playerscore
    ---玩家得分: 杀死英雄数量<br>
    ---来源: common.j
    PLAYER_SCORE_HEROES_KILLED = common.PLAYER_SCORE_HEROES_KILLED,
    ---@type playerscore
    ---玩家得分: 获得物品数量<br>
    ---来源: common.j
    PLAYER_SCORE_ITEMS_GAINED = common.PLAYER_SCORE_ITEMS_GAINED,
    ---@type playerscore
    ---玩家得分: 购买雇佣兵数量<br>
    ---来源: common.j
    PLAYER_SCORE_MERCS_HIRED = common.PLAYER_SCORE_MERCS_HIRED,
    ---@type playerscore
    ---玩家得分: 采集到的黄金数量(全部)<br>
    ---来源: common.j
    PLAYER_SCORE_GOLD_MINED_TOTAL = common.PLAYER_SCORE_GOLD_MINED_TOTAL,
    ---@type playerscore
    ---玩家得分: 采集到的黄金数量(维修费生效期间采集的)<br>
    ---来源: common.j
    PLAYER_SCORE_GOLD_MINED_UPKEEP = common.PLAYER_SCORE_GOLD_MINED_UPKEEP,
    ---@type playerscore
    ---玩家得分: 由于维修费而损失的黄金数量<br>
    ---来源: common.j
    PLAYER_SCORE_GOLD_LOST_UPKEEP = common.PLAYER_SCORE_GOLD_LOST_UPKEEP,
    ---@type playerscore
    ---玩家得分: 由于纳税损失的黄金数量<br>
    ---来源: common.j
    PLAYER_SCORE_GOLD_LOST_TAX = common.PLAYER_SCORE_GOLD_LOST_TAX,
    ---@type playerscore
    ---玩家得分: 给予盟友的黄金数量<br>
    ---来源: common.j
    PLAYER_SCORE_GOLD_GIVEN = common.PLAYER_SCORE_GOLD_GIVEN,
    ---@type playerscore
    ---玩家得分: 从盟友那收到的黄金数量<br>
    ---来源: common.j
    PLAYER_SCORE_GOLD_RECEIVED = common.PLAYER_SCORE_GOLD_RECEIVED,
    ---@type playerscore
    ---玩家得分: 采集到的木材数量<br>
    ---来源: common.j
    PLAYER_SCORE_LUMBER_TOTAL = common.PLAYER_SCORE_LUMBER_TOTAL,
    ---@type playerscore
    ---玩家得分: 由于维修费而损失的木材数量<br>
    ---来源: common.j
    PLAYER_SCORE_LUMBER_LOST_UPKEEP = common.PLAYER_SCORE_LUMBER_LOST_UPKEEP,
    ---@type playerscore
    ---玩家得分: 由于纳税损失的木材数量<br>
    ---来源: common.j
    PLAYER_SCORE_LUMBER_LOST_TAX = common.PLAYER_SCORE_LUMBER_LOST_TAX,
    ---@type playerscore
    ---玩家得分: 给予盟友的木材数量<br>
    ---来源: common.j
    PLAYER_SCORE_LUMBER_GIVEN = common.PLAYER_SCORE_LUMBER_GIVEN,
    ---@type playerscore
    ---玩家得分: 从盟友那收到的木材数量<br>
    ---来源: common.j
    PLAYER_SCORE_LUMBER_RECEIVED = common.PLAYER_SCORE_LUMBER_RECEIVED,
    ---@type playerscore
    ---玩家得分: 总的单位得分<br>
    ---来源: common.j
    PLAYER_SCORE_UNIT_TOTAL = common.PLAYER_SCORE_UNIT_TOTAL,
    ---@type playerscore
    ---玩家得分: 总的英雄得分<br>
    ---来源: common.j
    PLAYER_SCORE_HERO_TOTAL = common.PLAYER_SCORE_HERO_TOTAL,
    ---@type playerscore
    ---玩家得分: 总的资源得分<br>
    ---来源: common.j
    PLAYER_SCORE_RESOURCE_TOTAL = common.PLAYER_SCORE_RESOURCE_TOTAL,
    ---@type playerscore
    ---玩家得分: 总的整体得分<br>
    ---来源: common.j
    PLAYER_SCORE_TOTAL = common.PLAYER_SCORE_TOTAL,



    --@alias playerslotstate integer

    ---@type playerslotstate
    ---玩家槽状态: 没有玩家使用<br>
    ---来源: common.j
    PLAYER_SLOT_STATE_EMPTY = common.PLAYER_SLOT_STATE_EMPTY,
    ---@type playerslotstate
    ---玩家槽状态: 玩家正在游戏<br>
    ---来源: common.j
    PLAYER_SLOT_STATE_PLAYING = common.PLAYER_SLOT_STATE_PLAYING,
    ---@type playerslotstate
    ---玩家槽状态: 玩家已离开游戏<br>
    ---来源: common.j
    PLAYER_SLOT_STATE_LEFT = common.PLAYER_SLOT_STATE_LEFT,



    --@alias playerstate integer

    ---@type playerstate
    ---玩家状态: 现有黄金量<br>
    ---来源: common.j
    PLAYER_STATE_RESOURCE_GOLD = common.PLAYER_STATE_RESOURCE_GOLD,
    ---@type playerstate
    ---玩家状态: 现有木材量<br>
    ---来源: common.j
    PLAYER_STATE_RESOURCE_LUMBER = common.PLAYER_STATE_RESOURCE_LUMBER,
    ---@type playerstate
    ---玩家状态: 剩余可用英雄数<br>
    ---来源: common.j
    PLAYER_STATE_RESOURCE_HERO_TOKENS = common.PLAYER_STATE_RESOURCE_HERO_TOKENS,
    ---@type playerstate
    ---玩家状态: 可用人口数<br>
    ---默认为人口建筑提供的数量<br>
    ---来源: common.j
    PLAYER_STATE_RESOURCE_FOOD_CAP = common.PLAYER_STATE_RESOURCE_FOOD_CAP,
    ---@type playerstate
    ---玩家状态: 已使用人口数<br>
    ---来源: common.j
    PLAYER_STATE_RESOURCE_FOOD_USED = common.PLAYER_STATE_RESOURCE_FOOD_USED,
    ---@type playerstate
    ---玩家状态: 最大人口上限<br>
    ---平衡常数或触发限制的最大数量, 默认为100<br>
    ---来源: common.j
    PLAYER_STATE_FOOD_CAP_CEILING = common.PLAYER_STATE_FOOD_CAP_CEILING,
    ---@type playerstate
    ---玩家状态: 给予奖励<br>
    ---来源: common.j
    PLAYER_STATE_GIVES_BOUNTY = common.PLAYER_STATE_GIVES_BOUNTY,
    ---@type playerstate
    ---玩家状态: 联盟胜利<br>
    ---来源: common.j
    PLAYER_STATE_ALLIED_VICTORY = common.PLAYER_STATE_ALLIED_VICTORY,
    ---@type playerstate
    ---玩家状态: 放置<br>
    ---来源: common.j
    PLAYER_STATE_PLACED = common.PLAYER_STATE_PLACED,
    ---@type playerstate
    ---玩家状态: 战败后成为观战者<br>
    ---来源: common.j
    PLAYER_STATE_OBSERVER_ON_DEATH = common.PLAYER_STATE_OBSERVER_ON_DEATH,
    ---@type playerstate
    ---玩家状态: 裁判或观战者<br>
    ---来源: common.j
    PLAYER_STATE_OBSERVER = common.PLAYER_STATE_OBSERVER,
    ---@type playerstate
    ---玩家状态: 不可跟随<br>
    ---来源: common.j
    PLAYER_STATE_UNFOLLOWABLE = common.PLAYER_STATE_UNFOLLOWABLE,
    ---@type playerstate
    ---玩家状态: 黄金维修费率<br>
    ---来源: common.j
    PLAYER_STATE_GOLD_UPKEEP_RATE = common.PLAYER_STATE_GOLD_UPKEEP_RATE,
    ---@type playerstate
    ---玩家状态: 木材维修费率<br>
    ---来源: common.j
    PLAYER_STATE_LUMBER_UPKEEP_RATE = common.PLAYER_STATE_LUMBER_UPKEEP_RATE,
    ---@type playerstate
    ---玩家状态: 总金钱采集量<br>
    ---来源: common.j
    PLAYER_STATE_GOLD_GATHERED = common.PLAYER_STATE_GOLD_GATHERED,
    ---@type playerstate
    ---玩家状态: 总木材采集量<br>
    ---来源: common.j
    PLAYER_STATE_LUMBER_GATHERED = common.PLAYER_STATE_LUMBER_GATHERED,
    ---@type playerstate
    ---玩家状态: 中立敌对玩家单位睡眠<br>
    ---来源: common.j
    PLAYER_STATE_NO_CREEP_SLEEP = common.PLAYER_STATE_NO_CREEP_SLEEP,



    --@alias playerunitevent integer

    ---@type playerunitevent
    ---玩家单位事件: 单位被攻击<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_ATTACKED = common.EVENT_PLAYER_UNIT_ATTACKED,
    ---@type playerunitevent
    ---玩家单位事件: 单位被营救<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_RESCUED = common.EVENT_PLAYER_UNIT_RESCUED,
    ---@type playerunitevent
    ---玩家单位事件: 单位死亡<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_DEATH = common.EVENT_PLAYER_UNIT_DEATH,
    ---@type playerunitevent
    ---玩家单位事件: 单位(尸体)开始腐烂<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_DECAY = common.EVENT_PLAYER_UNIT_DECAY,
    ---@type playerunitevent
    ---玩家单位事件: 单位可侦测<br>
    ---可被反隐看到<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_DETECTED = common.EVENT_PLAYER_UNIT_DETECTED,
    ---@type playerunitevent
    ---玩家单位事件: 单位被隐藏<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_HIDDEN = common.EVENT_PLAYER_UNIT_HIDDEN,
    ---@type playerunitevent
    ---玩家单位事件: 选择单位<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_SELECTED = common.EVENT_PLAYER_UNIT_SELECTED,
    ---@type playerunitevent
    ---玩家单位事件: 取消选择单位<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_DESELECTED = common.EVENT_PLAYER_UNIT_DESELECTED,
    ---@type playerunitevent
    ---玩家单位事件: 开始建造<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_CONSTRUCT_START = common.EVENT_PLAYER_UNIT_CONSTRUCT_START,
    ---@type playerunitevent
    ---玩家单位事件: 取消建造<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL = common.EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL,
    ---@type playerunitevent
    ---玩家单位事件: 建造完成<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_CONSTRUCT_FINISH = common.EVENT_PLAYER_UNIT_CONSTRUCT_FINISH,
    ---@type playerunitevent
    ---玩家单位事件: 开始研究科技<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_UPGRADE_START = common.EVENT_PLAYER_UNIT_UPGRADE_START,
    ---@type playerunitevent
    ---玩家单位事件: 取消研究科技<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_UPGRADE_CANCEL = common.EVENT_PLAYER_UNIT_UPGRADE_CANCEL,
    ---@type playerunitevent
    ---玩家单位事件: 完成科技研究<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_UPGRADE_FINISH = common.EVENT_PLAYER_UNIT_UPGRADE_FINISH,
    ---@type playerunitevent
    ---玩家单位事件: 开始训练单位<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_TRAIN_START = common.EVENT_PLAYER_UNIT_TRAIN_START,
    ---@type playerunitevent
    ---玩家单位事件: 取消训练单位<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_TRAIN_CANCEL = common.EVENT_PLAYER_UNIT_TRAIN_CANCEL,
    ---@type playerunitevent
    ---玩家单位事件: 完成训练单位<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_TRAIN_FINISH = common.EVENT_PLAYER_UNIT_TRAIN_FINISH,
    ---@type playerunitevent
    ---玩家单位事件: 开始研究科技<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_RESEARCH_START = common.EVENT_PLAYER_UNIT_RESEARCH_START,
    ---@type playerunitevent
    ---玩家单位事件: 取消研究科技<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_RESEARCH_CANCEL = common.EVENT_PLAYER_UNIT_RESEARCH_CANCEL,
    ---@type playerunitevent
    ---玩家单位事件: 完成研究科技<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_RESEARCH_FINISH = common.EVENT_PLAYER_UNIT_RESEARCH_FINISH,
    ---@type playerunitevent
    ---玩家单位事件: 发布命令 (无目标)<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_ISSUED_ORDER = common.EVENT_PLAYER_UNIT_ISSUED_ORDER,
    ---@type playerunitevent
    ---玩家单位事件: 发布命令 (指定点)<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER = common.EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER,
    ---@type playerunitevent
    ---玩家单位事件: 发布命令 (指定单位)<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER = common.EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER,
    ---@type playerunitevent
    ---玩家单位事件: 发布命令 (指定单位)<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_ISSUED_UNIT_ORDER = common.EVENT_PLAYER_UNIT_ISSUED_UNIT_ORDER,
    ---@type playerunitevent
    ---玩家单位事件: 英雄升级<br>
    ---来源: common.j
    EVENT_PLAYER_HERO_LEVEL = common.EVENT_PLAYER_HERO_LEVEL,
    ---@type playerunitevent
    ---玩家单位事件: 英雄学习技能<br>
    ---来源: common.j
    EVENT_PLAYER_HERO_SKILL = common.EVENT_PLAYER_HERO_SKILL,
    ---@type playerunitevent
    ---玩家单位事件: 英雄可复活/阵亡<br>
    ---来源: common.j
    EVENT_PLAYER_HERO_REVIVABLE = common.EVENT_PLAYER_HERO_REVIVABLE,
    ---@type playerunitevent
    ---玩家单位事件: 英雄开始复活<br>
    ---来源: common.j
    EVENT_PLAYER_HERO_REVIVE_START = common.EVENT_PLAYER_HERO_REVIVE_START,
    ---@type playerunitevent
    ---玩家单位事件: 英雄取消复活<br>
    ---来源: common.j
    EVENT_PLAYER_HERO_REVIVE_CANCEL = common.EVENT_PLAYER_HERO_REVIVE_CANCEL,
    ---@type playerunitevent
    ---玩家单位事件: 英雄完成复活<br>
    ---来源: common.j
    EVENT_PLAYER_HERO_REVIVE_FINISH = common.EVENT_PLAYER_HERO_REVIVE_FINISH,
    ---@type playerunitevent
    ---玩家单位事件: 召唤单位<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_SUMMON = common.EVENT_PLAYER_UNIT_SUMMON,
    ---@type playerunitevent
    ---玩家单位事件: 物品掉落<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_DROP_ITEM = common.EVENT_PLAYER_UNIT_DROP_ITEM,
    ---@type playerunitevent
    ---玩家单位事件: 拾取物品<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_PICKUP_ITEM = common.EVENT_PLAYER_UNIT_PICKUP_ITEM,
    ---@type playerunitevent
    ---玩家单位事件: 使用物品<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_USE_ITEM = common.EVENT_PLAYER_UNIT_USE_ITEM,
    ---@type playerunitevent
    ---玩家单位事件: 单位被装载<br>
    ---被飞艇、船、被缠绕的金矿等装载<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_LOADED = common.EVENT_PLAYER_UNIT_LOADED,
    ---@type playerunitevent
    ---玩家单位事件: 单位被伤害<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_DAMAGED = common.EVENT_PLAYER_UNIT_DAMAGED,
    ---@type playerunitevent
    ---玩家单位事件: 单位造成伤害<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_DAMAGING = common.EVENT_PLAYER_UNIT_DAMAGING,
    ---@type playerunitevent
    ---玩家单位事件: 出售单位<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_SELL = common.EVENT_PLAYER_UNIT_SELL,
    ---@type playerunitevent
    ---玩家单位事件: 变更所属<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_CHANGE_OWNER = common.EVENT_PLAYER_UNIT_CHANGE_OWNER,
    ---@type playerunitevent
    ---玩家单位事件: 出售物品<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_SELL_ITEM = common.EVENT_PLAYER_UNIT_SELL_ITEM,
    ---@type playerunitevent
    ---玩家单位事件: 准备施放技能 (前摇开始)<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_SPELL_CHANNEL = common.EVENT_PLAYER_UNIT_SPELL_CHANNEL,
    ---@type playerunitevent
    ---玩家单位事件: 开始施放技能(前摇结束)<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_SPELL_CAST = common.EVENT_PLAYER_UNIT_SPELL_CAST,
    ---@type playerunitevent
    ---玩家单位事件: 发动技能效果(后摇开始)<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_SPELL_EFFECT = common.EVENT_PLAYER_UNIT_SPELL_EFFECT,
    ---@type playerunitevent
    ---玩家单位事件: 释放技能結束 (后摇结束)<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_SPELL_FINISH = common.EVENT_PLAYER_UNIT_SPELL_FINISH,
    ---@type playerunitevent
    ---玩家单位事件: 停止施放技能<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_SPELL_ENDCAST = common.EVENT_PLAYER_UNIT_SPELL_ENDCAST,
    ---@type playerunitevent
    ---玩家单位事件: 抵押(卖)物品<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_PAWN_ITEM = common.EVENT_PLAYER_UNIT_PAWN_ITEM,
    ---@type playerunitevent
    ---玩家单位事件: 堆叠物品<br>
    ---来源: common.j
    EVENT_PLAYER_UNIT_STACK_ITEM = common.EVENT_PLAYER_UNIT_STACK_ITEM,



    --@alias race integer

    ---@type race
    ---种族: 人类<br>
    ---来源: common.j
    RACE_HUMAN = common.RACE_HUMAN,
    ---@type race
    ---种族: 兽人<br>
    ---来源: common.j
    RACE_ORC = common.RACE_ORC,
    ---@type race
    ---种族: 不死族<br>
    ---来源: common.j
    RACE_UNDEAD = common.RACE_UNDEAD,
    ---@type race
    ---种族: 暗夜精灵<br>
    ---来源: common.j
    RACE_NIGHTELF = common.RACE_NIGHTELF,
    ---@type race
    ---种族: 恶魔族<br>
    ---来源: common.j
    RACE_DEMON = common.RACE_DEMON,
    ---@type race
    ---种族: 其他<br>
    ---来源: common.j
    RACE_OTHER = common.RACE_OTHER,



    --@alias racepreference integer

    ---@type racepreference
    ---预设玩家种族: 人类<br>
    ---来源: common.j
    RACE_PREF_HUMAN = common.RACE_PREF_HUMAN,
    ---@type racepreference
    ---预设玩家种族: 兽人<br>
    ---来源: common.j
    RACE_PREF_ORC = common.RACE_PREF_ORC,
    ---@type racepreference
    ---预设玩家种族: 暗夜精灵<br>
    ---来源: common.j
    RACE_PREF_NIGHTELF = common.RACE_PREF_NIGHTELF,
    ---@type racepreference
    ---预设玩家种族: 不死族<br>
    ---来源: common.j
    RACE_PREF_UNDEAD = common.RACE_PREF_UNDEAD,
    ---@type racepreference
    ---预设玩家种族: 恶魔<br>
    ---来源: common.j
    RACE_PREF_DEMON = common.RACE_PREF_DEMON,
    ---@type racepreference
    ---预设玩家种族: 随机<br>
    ---来源: common.j
    RACE_PREF_RANDOM = common.RACE_PREF_RANDOM,
    ---@type racepreference
    ---预设玩家种族: 用户可选择<br>
    ---来源: common.j
    RACE_PREF_USER_SELECTABLE = common.RACE_PREF_USER_SELECTABLE,



    --@alias texmapflags integer

    ---@type texmapflags
    ---纹理贴图标志: 无<br>
    ---来源: common.j
    TEXMAP_FLAG_NONE = common.TEXMAP_FLAG_NONE,
    ---@type texmapflags
    ---纹理贴图标志: 重叠 (U)<br>
    ---来源: common.j
    TEXMAP_FLAG_WRAP_U = common.TEXMAP_FLAG_WRAP_U,
    ---@type texmapflags
    ---纹理贴图标志: 重叠 (V)<br>
    ---来源: common.j
    TEXMAP_FLAG_WRAP_V = common.TEXMAP_FLAG_WRAP_V,
    ---@type texmapflags
    ---纹理贴图标志: 重叠 (UV)<br>
    ---来源: common.j
    TEXMAP_FLAG_WRAP_UV = common.TEXMAP_FLAG_WRAP_UV,



    --@alias unitevent integer

    ---@type unitevent
    ---单位事件: 单位受到伤害<br>
    ---来源: common.j
    EVENT_UNIT_DAMAGED = common.EVENT_UNIT_DAMAGED,
    ---@type unitevent
    ---单位事件: 单位死亡<br>
    ---来源: common.j
    EVENT_UNIT_DEATH = common.EVENT_UNIT_DEATH,
    ---@type unitevent
    ---单位事件: 单位(尸体)开始腐烂<br>
    ---来源: common.j
    EVENT_UNIT_DECAY = common.EVENT_UNIT_DECAY,
    ---@type unitevent
    ---单位事件: 单位可侦测<br>
    ---可被反隐看到<br>
    ---来源: common.j
    EVENT_UNIT_DETECTED = common.EVENT_UNIT_DETECTED,
    ---@type unitevent
    ---单位事件: 单位被隐藏<br>
    ---来源: common.j
    EVENT_UNIT_HIDDEN = common.EVENT_UNIT_HIDDEN,
    ---@type unitevent
    ---单位事件: 选择单位<br>
    ---来源: common.j
    EVENT_UNIT_SELECTED = common.EVENT_UNIT_SELECTED,
    ---@type unitevent
    ---单位事件: 取消选择单位<br>
    ---来源: common.j
    EVENT_UNIT_DESELECTED = common.EVENT_UNIT_DESELECTED,
    ---@type unitevent
    ---单位事件: 单位状态变更<br>
    ---来源: common.j
    EVENT_UNIT_STATE_LIMIT = common.EVENT_UNIT_STATE_LIMIT,
    ---@type unitevent
    ---单位事件: 单位获取到攻击目标<br>
    ---类似触发单位警戒攻击<br>
    ---来源: common.j
    EVENT_UNIT_ACQUIRED_TARGET = common.EVENT_UNIT_ACQUIRED_TARGET,
    ---@type unitevent
    ---单位事件: 目标在单位获取范围内<br>
    ---类似警戒范围<br>
    ---来源: common.j
    EVENT_UNIT_TARGET_IN_RANGE = common.EVENT_UNIT_TARGET_IN_RANGE,
    ---@type unitevent
    ---单位事件: 单位被攻击<br>
    ---来源: common.j
    EVENT_UNIT_ATTACKED = common.EVENT_UNIT_ATTACKED,
    ---@type unitevent
    ---单位事件: 单位被营救<br>
    ---来源: common.j
    EVENT_UNIT_RESCUED = common.EVENT_UNIT_RESCUED,
    ---@type unitevent
    ---单位事件: 取消建造<br>
    ---来源: common.j
    EVENT_UNIT_CONSTRUCT_CANCEL = common.EVENT_UNIT_CONSTRUCT_CANCEL,
    ---@type unitevent
    ---单位事件: 完成建造<br>
    ---来源: common.j
    EVENT_UNIT_CONSTRUCT_FINISH = common.EVENT_UNIT_CONSTRUCT_FINISH,
    ---@type unitevent
    ---单位事件: 开始研究科技<br>
    ---来源: common.j
    EVENT_UNIT_UPGRADE_START = common.EVENT_UNIT_UPGRADE_START,
    ---@type unitevent
    ---单位事件: 取消研究科技<br>
    ---来源: common.j
    EVENT_UNIT_UPGRADE_CANCEL = common.EVENT_UNIT_UPGRADE_CANCEL,
    ---@type unitevent
    ---单位事件: 完成研究科技<br>
    ---来源: common.j
    EVENT_UNIT_UPGRADE_FINISH = common.EVENT_UNIT_UPGRADE_FINISH,
    ---@type unitevent
    ---单位事件: 开始训练单位<br>
    ---来源: common.j
    EVENT_UNIT_TRAIN_START = common.EVENT_UNIT_TRAIN_START,
    ---@type unitevent
    ---单位事件: 取消训练单位<br>
    ---来源: common.j
    EVENT_UNIT_TRAIN_CANCEL = common.EVENT_UNIT_TRAIN_CANCEL,
    ---@type unitevent
    ---单位事件: 完成训练单位<br>
    ---来源: common.j
    EVENT_UNIT_TRAIN_FINISH = common.EVENT_UNIT_TRAIN_FINISH,
    ---@type unitevent
    ---单位事件: 开始研究科技<br>
    ---来源: common.j
    EVENT_UNIT_RESEARCH_START = common.EVENT_UNIT_RESEARCH_START,
    ---@type unitevent
    ---单位事件: 取消研究科技<br>
    ---来源: common.j
    EVENT_UNIT_RESEARCH_CANCEL = common.EVENT_UNIT_RESEARCH_CANCEL,
    ---@type unitevent
    ---单位事件: 完成研究科技<br>
    ---来源: common.j
    EVENT_UNIT_RESEARCH_FINISH = common.EVENT_UNIT_RESEARCH_FINISH,
    ---@type unitevent
    ---单位事件: 发布命令 (无目标)<br>
    ---来源: common.j
    EVENT_UNIT_ISSUED_ORDER = common.EVENT_UNIT_ISSUED_ORDER,
    ---@type unitevent
    ---单位事件: 发布命令 (指定点)<br>
    ---来源: common.j
    EVENT_UNIT_ISSUED_POINT_ORDER = common.EVENT_UNIT_ISSUED_POINT_ORDER,
    ---@type unitevent
    ---单位事件: 发布命令 (指定单位)<br>
    ---来源: common.j
    EVENT_UNIT_ISSUED_TARGET_ORDER = common.EVENT_UNIT_ISSUED_TARGET_ORDER,
    ---@type unitevent
    ---单位事件: 英雄升级<br>
    ---来源: common.j
    EVENT_UNIT_HERO_LEVEL = common.EVENT_UNIT_HERO_LEVEL,
    ---@type unitevent
    ---单位事件: 英雄学习技能<br>
    ---来源: common.j
    EVENT_UNIT_HERO_SKILL = common.EVENT_UNIT_HERO_SKILL,
    ---@type unitevent
    ---单位事件: 英雄可复活/阵亡<br>
    ---来源: common.j
    EVENT_UNIT_HERO_REVIVABLE = common.EVENT_UNIT_HERO_REVIVABLE,
    ---@type unitevent
    ---单位事件: 英雄开始复活<br>
    ---来源: common.j
    EVENT_UNIT_HERO_REVIVE_START = common.EVENT_UNIT_HERO_REVIVE_START,
    ---@type unitevent
    ---单位事件: 英雄取消复活<br>
    ---来源: common.j
    EVENT_UNIT_HERO_REVIVE_CANCEL = common.EVENT_UNIT_HERO_REVIVE_CANCEL,
    ---@type unitevent
    ---单位事件: 英雄完成复活<br>
    ---来源: common.j
    EVENT_UNIT_HERO_REVIVE_FINISH = common.EVENT_UNIT_HERO_REVIVE_FINISH,
    ---@type unitevent
    ---单位事件: 召唤单位<br>
    ---来源: common.j
    EVENT_UNIT_SUMMON = common.EVENT_UNIT_SUMMON,
    ---@type unitevent
    ---单位事件: 掉落物品<br>
    ---来源: common.j
    EVENT_UNIT_DROP_ITEM = common.EVENT_UNIT_DROP_ITEM,
    ---@type unitevent
    ---单位事件: 拾取物品<br>
    ---来源: common.j
    EVENT_UNIT_PICKUP_ITEM = common.EVENT_UNIT_PICKUP_ITEM,
    ---@type unitevent
    ---单位事件: 使用物品<br>
    ---来源: common.j
    EVENT_UNIT_USE_ITEM = common.EVENT_UNIT_USE_ITEM,
    ---@type unitevent
    ---单位事件: 单位被装载<br>
    ---被飞艇、船、被缠绕的金矿等装载<br>
    ---来源: common.j
    EVENT_UNIT_LOADED = common.EVENT_UNIT_LOADED,
    ---@type unitevent
    ---单位事件: 出售单位<br>
    ---来源: common.j
    EVENT_UNIT_SELL = common.EVENT_UNIT_SELL,
    ---@type unitevent
    ---单位事件: 单位所属变更<br>
    ---来源: common.j
    EVENT_UNIT_CHANGE_OWNER = common.EVENT_UNIT_CHANGE_OWNER,
    ---@type unitevent
    ---单位事件: 出售物品<br>
    ---来源: common.j
    EVENT_UNIT_SELL_ITEM = common.EVENT_UNIT_SELL_ITEM,
    ---@type unitevent
    ---单位事件: 准备施放技能 (前摇开始)<br>
    ---来源: common.j
    EVENT_UNIT_SPELL_CHANNEL = common.EVENT_UNIT_SPELL_CHANNEL,
    ---@type unitevent
    ---单位事件: 开始施放技能 (前摇结束)<br>
    ---来源: common.j
    EVENT_UNIT_SPELL_CAST = common.EVENT_UNIT_SPELL_CAST,
    ---@type unitevent
    ---单位事件: 发动技能效果 (后摇开始)<br>
    ---来源: common.j
    EVENT_UNIT_SPELL_EFFECT = common.EVENT_UNIT_SPELL_EFFECT,
    ---@type unitevent
    ---单位事件: 发动技能结束 (后摇结束)<br>
    ---来源: common.j
    EVENT_UNIT_SPELL_FINISH = common.EVENT_UNIT_SPELL_FINISH,
    ---@type unitevent
    ---单位事件: 停止施放技能<br>
    ---来源: common.j
    EVENT_UNIT_SPELL_ENDCAST = common.EVENT_UNIT_SPELL_ENDCAST,
    ---@type unitevent
    ---单位事件: 抵押(卖)物品<br>
    ---来源: common.j
    EVENT_UNIT_PAWN_ITEM = common.EVENT_UNIT_PAWN_ITEM,
    ---@type unitevent
    ---单位事件: 堆叠物品<br>
    ---来源: common.j
    EVENT_UNIT_STACK_ITEM = common.EVENT_UNIT_STACK_ITEM,



    --@alias unitstate integer

    ---@type unitstate
    ---单位状态: 单位当前生命值<br>
    ---来源: common.j
    UNIT_STATE_LIFE = common.UNIT_STATE_LIFE,
    ---@type unitstate
    ---单位状态: 单位最大生命值<br>
    ---来源: common.j
    UNIT_STATE_MAX_LIFE = common.UNIT_STATE_MAX_LIFE,
    ---@type unitstate
    ---单位状态: 单位当前法力值<br>
    ---来源: common.j
    UNIT_STATE_MANA = common.UNIT_STATE_MANA,
    ---@type unitstate
    ---单位状态: 单位最大法力值<br>
    ---来源: common.j
    UNIT_STATE_MAX_MANA = common.UNIT_STATE_MAX_MANA,



    --@alias unittype integer

    ---@type unittype
    ---单位类型: 英雄<br>
    ---来源: common.j
    UNIT_TYPE_HERO = common.UNIT_TYPE_HERO,
    ---@type unittype
    ---单位类型: 已死亡<br>
    ---来源: common.j
    UNIT_TYPE_DEAD = common.UNIT_TYPE_DEAD,
    ---@type unittype
    ---单位类型: 建筑<br>
    ---来源: common.j
    UNIT_TYPE_STRUCTURE = common.UNIT_TYPE_STRUCTURE,
    ---@type unittype
    ---单位类型: 飞行单位<br>
    ---来源: common.j
    UNIT_TYPE_FLYING = common.UNIT_TYPE_FLYING,
    ---@type unittype
    ---单位类型: 地面单位<br>
    ---来源: common.j
    UNIT_TYPE_GROUND = common.UNIT_TYPE_GROUND,
    ---@type unittype
    ---单位类型: 可以攻击飞行单位<br>
    ---来源: common.j
    UNIT_TYPE_ATTACKS_FLYING = common.UNIT_TYPE_ATTACKS_FLYING,
    ---@type unittype
    ---单位类型: 可以攻击地面单位<br>
    ---来源: common.j
    UNIT_TYPE_ATTACKS_GROUND = common.UNIT_TYPE_ATTACKS_GROUND,
    ---@type unittype
    ---单位类型: 近战攻击单位<br>
    ---来源: common.j
    UNIT_TYPE_MELEE_ATTACKER = common.UNIT_TYPE_MELEE_ATTACKER,
    ---@type unittype
    ---单位类型: 远程攻击单位<br>
    ---来源: common.j
    UNIT_TYPE_RANGED_ATTACKER = common.UNIT_TYPE_RANGED_ATTACKER,
    ---@type unittype
    ---单位类型: 泰坦<br>
    ---来源: common.j
    UNIT_TYPE_GIANT = common.UNIT_TYPE_GIANT,
    ---@type unittype
    ---单位类型: 召唤物<br>
    ---来源: common.j
    UNIT_TYPE_SUMMONED = common.UNIT_TYPE_SUMMONED,
    ---@type unittype
    ---单位类型: 被击晕的<br>
    ---来源: common.j
    UNIT_TYPE_STUNNED = common.UNIT_TYPE_STUNNED,
    ---@type unittype
    ---单位类型: 受折磨的<br>
    ---来源: common.j
    UNIT_TYPE_PLAGUED = common.UNIT_TYPE_PLAGUED,
    ---@type unittype
    ---单位类型: 被诱捕(被网住)<br>
    ---来源: common.j
    UNIT_TYPE_SNARED = common.UNIT_TYPE_SNARED,
    ---@type unittype
    ---单位类型: 不死族<br>
    ---来源: common.j
    UNIT_TYPE_UNDEAD = common.UNIT_TYPE_UNDEAD,
    ---@type unittype
    ---单位类型: 机械<br>
    ---来源: common.j
    UNIT_TYPE_MECHANICAL = common.UNIT_TYPE_MECHANICAL,
    ---@type unittype
    ---单位类型: 工人<br>
    ---来源: common.j
    UNIT_TYPE_PEON = common.UNIT_TYPE_PEON,
    ---@type unittype
    ---单位类型: 自爆工兵<br>
    ---来源: common.j
    UNIT_TYPE_SAPPER = common.UNIT_TYPE_SAPPER,
    ---@type unittype
    ---单位类型: 城镇<br>
    ---来源: common.j
    UNIT_TYPE_TOWNHALL = common.UNIT_TYPE_TOWNHALL,
    ---@type unittype
    ---单位类型: 古树<br>
    ---来源: common.j
    UNIT_TYPE_ANCIENT = common.UNIT_TYPE_ANCIENT,
    ---@type unittype
    ---单位类型: 牛头人<br>
    ---来源: common.j
    UNIT_TYPE_TAUREN = common.UNIT_TYPE_TAUREN,
    ---@type unittype
    ---单位类型: 已中毒<br>
    ---来源: common.j
    UNIT_TYPE_POISONED = common.UNIT_TYPE_POISONED,
    ---@type unittype
    ---单位类型: 被变形<br>
    ---来源: common.j
    UNIT_TYPE_POLYMORPHED = common.UNIT_TYPE_POLYMORPHED,
    ---@type unittype
    ---单位类型: 被催眠<br>
    ---夜晚睡觉也属于被催眠<br>
    ---来源: common.j
    UNIT_TYPE_SLEEPING = common.UNIT_TYPE_SLEEPING,
    ---@type unittype
    ---单位类型: 有抗性皮肤<br>
    ---来源: common.j
    UNIT_TYPE_RESISTANT = common.UNIT_TYPE_RESISTANT,
    ---@type unittype
    ---单位类型: 处于虚无状态<br>
    ---来源: common.j
    UNIT_TYPE_ETHEREAL = common.UNIT_TYPE_ETHEREAL,
    ---@type unittype
    ---单位类型: 免疫魔法<br>
    ---来源: common.j
    UNIT_TYPE_MAGIC_IMMUNE = common.UNIT_TYPE_MAGIC_IMMUNE,



    --@alias version integer

    ---@type version
    ---游戏版本: 混乱之治<br>
    ---来源: common.j
    VERSION_REIGN_OF_CHAOS = common.VERSION_REIGN_OF_CHAOS,
    ---@type version
    ---游戏版本: 冰封王座<br>
    ---来源: common.j
    VERSION_FROZEN_THRONE = common.VERSION_FROZEN_THRONE,



    --@alias volumegroup integer

    ---@type volumegroup
    ---声音频道: 单位移动声音<br>
    ---来源: common.j
    SOUND_VOLUMEGROUP_UNITMOVEMENT = common.SOUND_VOLUMEGROUP_UNITMOVEMENT,
    ---@type volumegroup
    ---声音频道: 单位回应声音<br>
    ---来源: common.j
    SOUND_VOLUMEGROUP_UNITSOUNDS = common.SOUND_VOLUMEGROUP_UNITSOUNDS,
    ---@type volumegroup
    ---声音频道: 战斗声音<br>
    ---来源: common.j
    SOUND_VOLUMEGROUP_COMBAT = common.SOUND_VOLUMEGROUP_COMBAT,
    ---@type volumegroup
    ---声音频道: 动画和法术声音<br>
    ---来源: common.j
    SOUND_VOLUMEGROUP_SPELLS = common.SOUND_VOLUMEGROUP_SPELLS,
    ---@type volumegroup
    ---声音频道: 用户界面(UI)声音<br>
    ---来源: common.j
    SOUND_VOLUMEGROUP_UI = common.SOUND_VOLUMEGROUP_UI,
    ---@type volumegroup
    ---声音频道: 音乐<br>
    ---来源: common.j
    SOUND_VOLUMEGROUP_MUSIC = common.SOUND_VOLUMEGROUP_MUSIC,
    ---@type volumegroup
    ---声音频道: 场景配音<br>
    ---来源: common.j
    SOUND_VOLUMEGROUP_AMBIENTSOUNDS = common.SOUND_VOLUMEGROUP_AMBIENTSOUNDS,
    ---@type volumegroup
    ---声音频道: 火焰声音<br>
    ---来源: common.j
    SOUND_VOLUMEGROUP_FIRE = common.SOUND_VOLUMEGROUP_FIRE,



    --@alias weapontype integer

    ---@type weapontype
    ---武器声音: 无<br>
    ---来源: common.j
    WEAPON_TYPE_WHOKNOWS = common.WEAPON_TYPE_WHOKNOWS,
    ---@type weapontype
    ---武器声音: 金属轻砍<br>
    ---来源: common.j
    WEAPON_TYPE_METAL_LIGHT_CHOP = common.WEAPON_TYPE_METAL_LIGHT_CHOP,
    ---@type weapontype
    ---武器声音: 金属中砍<br>
    ---来源: common.j
    WEAPON_TYPE_METAL_MEDIUM_CHOP = common.WEAPON_TYPE_METAL_MEDIUM_CHOP,
    ---@type weapontype
    ---武器声音: 金属重砍<br>
    ---来源: common.j
    WEAPON_TYPE_METAL_HEAVY_CHOP = common.WEAPON_TYPE_METAL_HEAVY_CHOP,
    ---@type weapontype
    ---武器声音: 金属轻切<br>
    ---来源: common.j
    WEAPON_TYPE_METAL_LIGHT_SLICE = common.WEAPON_TYPE_METAL_LIGHT_SLICE,
    ---@type weapontype
    ---武器声音: 金属中切<br>
    ---来源: common.j
    WEAPON_TYPE_METAL_MEDIUM_SLICE = common.WEAPON_TYPE_METAL_MEDIUM_SLICE,
    ---@type weapontype
    ---武器声音: 金属重切<br>
    ---来源: common.j
    WEAPON_TYPE_METAL_HEAVY_SLICE = common.WEAPON_TYPE_METAL_HEAVY_SLICE,
    ---@type weapontype
    ---武器声音: 金属中击<br>
    ---来源: common.j
    WEAPON_TYPE_METAL_MEDIUM_BASH = common.WEAPON_TYPE_METAL_MEDIUM_BASH,
    ---@type weapontype
    ---武器声音: 金属重击<br>
    ---来源: common.j
    WEAPON_TYPE_METAL_HEAVY_BASH = common.WEAPON_TYPE_METAL_HEAVY_BASH,
    ---@type weapontype
    ---武器声音: 金属中刺<br>
    ---来源: common.j
    WEAPON_TYPE_METAL_MEDIUM_STAB = common.WEAPON_TYPE_METAL_MEDIUM_STAB,
    ---@type weapontype
    ---武器声音: 金属重刺<br>
    ---来源: common.j
    WEAPON_TYPE_METAL_HEAVY_STAB = common.WEAPON_TYPE_METAL_HEAVY_STAB,
    ---@type weapontype
    ---武器声音: 木头轻切<br>
    ---来源: common.j
    WEAPON_TYPE_WOOD_LIGHT_SLICE = common.WEAPON_TYPE_WOOD_LIGHT_SLICE,
    ---@type weapontype
    ---武器声音: 木头中切<br>
    ---来源: common.j
    WEAPON_TYPE_WOOD_MEDIUM_SLICE = common.WEAPON_TYPE_WOOD_MEDIUM_SLICE,
    ---@type weapontype
    ---武器声音: 木头重切<br>
    ---来源: common.j
    WEAPON_TYPE_WOOD_HEAVY_SLICE = common.WEAPON_TYPE_WOOD_HEAVY_SLICE,
    ---@type weapontype
    ---武器声音: 木头轻击<br>
    ---来源: common.j
    WEAPON_TYPE_WOOD_LIGHT_BASH = common.WEAPON_TYPE_WOOD_LIGHT_BASH,
    ---@type weapontype
    ---武器声音: 木头中击<br>
    ---来源: common.j
    WEAPON_TYPE_WOOD_MEDIUM_BASH = common.WEAPON_TYPE_WOOD_MEDIUM_BASH,
    ---@type weapontype
    ---武器声音: 木头重击<br>
    ---来源: common.j
    WEAPON_TYPE_WOOD_HEAVY_BASH = common.WEAPON_TYPE_WOOD_HEAVY_BASH,
    ---@type weapontype
    ---武器声音: 木头轻刺<br>
    ---来源: common.j
    WEAPON_TYPE_WOOD_LIGHT_STAB = common.WEAPON_TYPE_WOOD_LIGHT_STAB,
    ---@type weapontype
    ---武器声音: 木头中刺<br>
    ---来源: common.j
    WEAPON_TYPE_WOOD_MEDIUM_STAB = common.WEAPON_TYPE_WOOD_MEDIUM_STAB,
    ---@type weapontype
    ---武器声音: 利爪轻切<br>
    ---来源: common.j
    WEAPON_TYPE_CLAW_LIGHT_SLICE = common.WEAPON_TYPE_CLAW_LIGHT_SLICE,
    ---@type weapontype
    ---武器声音: 利爪中切<br>
    ---来源: common.j
    WEAPON_TYPE_CLAW_MEDIUM_SLICE = common.WEAPON_TYPE_CLAW_MEDIUM_SLICE,
    ---@type weapontype
    ---武器声音: 利爪重切<br>
    ---来源: common.j
    WEAPON_TYPE_CLAW_HEAVY_SLICE = common.WEAPON_TYPE_CLAW_HEAVY_SLICE,
    ---@type weapontype
    ---武器声音: 斧头中砍<br>
    ---来源: common.j
    WEAPON_TYPE_AXE_MEDIUM_CHOP = common.WEAPON_TYPE_AXE_MEDIUM_CHOP,
    ---@type weapontype
    ---武器声音: 岩石重击<br>
    ---来源: common.j
    WEAPON_TYPE_ROCK_HEAVY_BASH = common.WEAPON_TYPE_ROCK_HEAVY_BASH,



    --@alias widgetevent integer

    ---@type widgetevent
    ---Widget事件: 单位/物品/可破坏物死亡<br>
    ---来源: common.j
    EVENT_WIDGET_DEATH = common.EVENT_WIDGET_DEATH,

    --@alias ABILITY_CAST_TYPE integer

    ---@type ABILITY_CAST_TYPE
    ---技能释放类型: 无目标<br>
    ---来源: MemHack
    ABILITY_CAST_TYPE_NONTARGET = japi.ABILITY_CAST_TYPE_NONTARGET,
    ---@type ABILITY_CAST_TYPE
    ---技能释放类型: 点目标<br>
    ---来源: MemHack
    ABILITY_CAST_TYPE_POINT = japi.ABILITY_CAST_TYPE_POINT,
    ---@type ABILITY_CAST_TYPE
    ---技能释放类型: 物体目标<br>
    ---来源: MemHack
    ABILITY_CAST_TYPE_TARGET = japi.ABILITY_CAST_TYPE_TARGET,
    ---@type ABILITY_CAST_TYPE
    ---技能释放类型: 单独释放<br>
    ---来源: MemHack
    ABILITY_CAST_TYPE_ALONE = japi.ABILITY_CAST_TYPE_ALONE,
    ---@type ABILITY_CAST_TYPE
    ---技能释放类型: 命令恢复<br>
    ---来源: MemHack
    ABILITY_CAST_TYPE_RESTORE = japi.ABILITY_CAST_TYPE_RESTORE,
    ---@type ABILITY_CAST_TYPE
    ---技能释放类型: 范围释放<br>
    ---来源: MemHack
    ABILITY_CAST_TYPE_AREA = japi.ABILITY_CAST_TYPE_AREA,
    ---@type ABILITY_CAST_TYPE
    ---技能释放类型: 立即释放<br>
    ---来源: MemHack
    ABILITY_CAST_TYPE_INSTANT = japi.ABILITY_CAST_TYPE_INSTANT,



    --@alias ABILITY_DEF_DATA integer

    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数): 基础ID<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_BASE_ID = japi.ABILITY_DEF_DATA_BASE_ID,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数): 等级要求<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_REQ_LEVEL = japi.ABILITY_DEF_DATA_REQ_LEVEL,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数): 最大等级<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_MAX_LEVEL = japi.ABILITY_DEF_DATA_MAX_LEVEL,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数): 跳级要求<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_LEVEL_SKIP = japi.ABILITY_DEF_DATA_LEVEL_SKIP,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数): 魔法偷取优先权<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_PRIORITY = japi.ABILITY_DEF_DATA_PRIORITY,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数): 按钮位置 - 普通(X)<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_BUTTON_X = japi.ABILITY_DEF_DATA_BUTTON_X,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数): 按钮位置 - 普通(Y)<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_BUTTON_Y = japi.ABILITY_DEF_DATA_BUTTON_Y,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数): 按钮位置 - 关闭(X)<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_UNBUTTON_X = japi.ABILITY_DEF_DATA_UNBUTTON_X,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数): 按钮位置 - 关闭(Y)<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_UNBUTTON_Y = japi.ABILITY_DEF_DATA_UNBUTTON_Y,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数): 按钮位置 - 研究(X)<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_RESEARCH_BUTTON_X = japi.ABILITY_DEF_DATA_RESEARCH_BUTTON_X,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数): 按钮位置 - 研究(Y)<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_RESEARCH_BUTTON_Y = japi.ABILITY_DEF_DATA_RESEARCH_BUTTON_Y,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数): 热键 - 普通<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_HOTKEY = japi.ABILITY_DEF_DATA_HOTKEY,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数): 热键 - 关闭<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_UNHOTKEY = japi.ABILITY_DEF_DATA_UNHOTKEY,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数): 热键 - 学习<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_RESEARCH_HOTKEY = japi.ABILITY_DEF_DATA_RESEARCH_HOTKEY,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数):<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_CASTER_ART_COUNT = japi.ABILITY_DEF_DATA_CASTER_ART_COUNT,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数):<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_TARGET_ART_COUNT = japi.ABILITY_DEF_DATA_TARGET_ART_COUNT,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数):<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_EFFECT_ART_COUNT = japi.ABILITY_DEF_DATA_EFFECT_ART_COUNT,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数):<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_MISSILE_ART_COUNT = japi.ABILITY_DEF_DATA_MISSILE_ART_COUNT,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数):<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_SPECIAL_ART_COUNT = japi.ABILITY_DEF_DATA_SPECIAL_ART_COUNT,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数):<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_LIGHTNING_EFFECT_COUNT = japi.ABILITY_DEF_DATA_LIGHTNING_EFFECT_COUNT,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数):<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_CASTER_ATTACH_COUNT = japi.ABILITY_DEF_DATA_CASTER_ATTACH_COUNT,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (整数):<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_TARGET_ATTACH_COUNT = japi.ABILITY_DEF_DATA_TARGET_ATTACH_COUNT,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (实数): 射弹速率<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_MISSILE_SPEED = japi.ABILITY_DEF_DATA_MISSILE_SPEED,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (实数): 射弹弧度<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_MISSILE_ARC = japi.ABILITY_DEF_DATA_MISSILE_ARC,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (布尔值): 射弹自导允许<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_MISSILE_HOMING = japi.ABILITY_DEF_DATA_MISSILE_HOMING,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (字符串): 名称<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_NAME = japi.ABILITY_DEF_DATA_NAME,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (字符串): 图标 - 普通<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_ART = japi.ABILITY_DEF_DATA_ART,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (字符串): 图标 - 关闭<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_UNART = japi.ABILITY_DEF_DATA_UNART,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (字符串): 图标 - 学习<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_RESEARCH_ART = japi.ABILITY_DEF_DATA_RESEARCH_ART,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (字符串): 提示工具 - 学习<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_RESEARCH_TIP = japi.ABILITY_DEF_DATA_RESEARCH_TIP,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (字符串): 提示工具 - 学习 - 扩展<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_RESEARCH_UBERTIP = japi.ABILITY_DEF_DATA_RESEARCH_UBERTIP,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (字符串): 音效<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_EFFECT_SOUND = japi.ABILITY_DEF_DATA_EFFECT_SOUND,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (字符串): 音效 (循环)<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_EFFECT_SOUND_LOOPED = japi.ABILITY_DEF_DATA_EFFECT_SOUND_LOOPED,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (字符串): 全局提示<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_GLOBAL_MESSAGE = japi.ABILITY_DEF_DATA_GLOBAL_MESSAGE,
    ---@type ABILITY_DEF_DATA
    ---技能物编数据 (字符串): 全局音效<br>
    ---来源: MemHack
    ABILITY_DEF_DATA_GLOBAL_SOUND = japi.ABILITY_DEF_DATA_GLOBAL_SOUND,



    --@alias ABILITY_FLAG1 integer

    ---@type ABILITY_FLAG1
    ---技能标志1: 显示释放边框<br>
    ---来源: MemHack
    ABILITY_FLAG1_ON_CAST = japi.ABILITY_FLAG1_ON_CAST,
    ---@type ABILITY_FLAG1
    ---技能标志1: 来自于物品<br>
    ---物品哈希地址在abil + 0xA0上, 拥有该flag的技能不会被沉默<br>
    ---来源: MemHack
    ABILITY_FLAG1_FROM_ITEM = japi.ABILITY_FLAG1_FROM_ITEM,
    ---@type ABILITY_FLAG1
    ---技能标志1: 开启<br>
    ---显示上的开启<br>
    ---开关类技能实际的开启<br>
    ---开关光环技能的刷新<br>
    ---来源: MemHack
    ABILITY_FLAG1_SWITCH_ON = japi.ABILITY_FLAG1_SWITCH_ON,
    ---@type ABILITY_FLAG1
    ---技能标志1: 冷却中<br>
    ---开关光环技能的隐藏<br>
    ---开关ABnP的多敲<br>
    ---开关被动技能?<br>
    ---来源: MemHack
    ABILITY_FLAG1_ON_COOLDOWN = japi.ABILITY_FLAG1_ON_COOLDOWN,
    ---@type ABILITY_FLAG1
    ---技能标志1: 开启自动释放<br>
    ---来源: MemHack
    ABILITY_FLAG1_AUTO_CAST_ON = japi.ABILITY_FLAG1_AUTO_CAST_ON,



    --@alias ABILITY_LEVEL_DEF_DATA integer

    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (整数): 目标允许<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_TARGET_ALLOW = japi.ABILITY_LEVEL_DEF_DATA_TARGET_ALLOW,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (整数): 魔法消耗<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_MANA_COST = japi.ABILITY_LEVEL_DEF_DATA_MANA_COST,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (整数): 召唤单位类型<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_UNIT_ID = japi.ABILITY_LEVEL_DEF_DATA_UNIT_ID,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (实数): 魔法施放时间<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_CAST_TIME = japi.ABILITY_LEVEL_DEF_DATA_CAST_TIME,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (实数): 持续时间 - 普通<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_NORMAL_DUR = japi.ABILITY_LEVEL_DEF_DATA_NORMAL_DUR,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (实数): 持续时间 - 英雄<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_HERO_DUR = japi.ABILITY_LEVEL_DEF_DATA_HERO_DUR,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (实数): 冷却时间<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_COOLDOWN = japi.ABILITY_LEVEL_DEF_DATA_COOLDOWN,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (实数): 影响区域<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_AREA = japi.ABILITY_LEVEL_DEF_DATA_AREA,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (实数): 施法距离<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_RANGE = japi.ABILITY_LEVEL_DEF_DATA_RANGE,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (实数): 数据A<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_DATA_A = japi.ABILITY_LEVEL_DEF_DATA_DATA_A,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (实数): 数据B<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_DATA_B = japi.ABILITY_LEVEL_DEF_DATA_DATA_B,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (实数): 数据C<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_DATA_C = japi.ABILITY_LEVEL_DEF_DATA_DATA_C,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (实数): 数据D<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_DATA_D = japi.ABILITY_LEVEL_DEF_DATA_DATA_D,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (实数): 数据E<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_DATA_E = japi.ABILITY_LEVEL_DEF_DATA_DATA_E,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (实数): 数据F<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_DATA_F = japi.ABILITY_LEVEL_DEF_DATA_DATA_F,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (实数): 数据G<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_DATA_G = japi.ABILITY_LEVEL_DEF_DATA_DATA_G,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (实数): 数据H<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_DATA_H = japi.ABILITY_LEVEL_DEF_DATA_DATA_H,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (实数): 数据I<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_DATA_I = japi.ABILITY_LEVEL_DEF_DATA_DATA_I,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (字符串)：提示工具 - 普通<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_TIP = japi.ABILITY_LEVEL_DEF_DATA_TIP,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (字符串)：提示工具 - 关闭<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_UNTIP = japi.ABILITY_LEVEL_DEF_DATA_UNTIP,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (字符串)：提示工具 - 普通 - 扩展<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_UBERTIP = japi.ABILITY_LEVEL_DEF_DATA_UBERTIP,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (字符串)：提示工具 - 关闭 - 扩展<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_UNUBERTIP = japi.ABILITY_LEVEL_DEF_DATA_UNUBERTIP,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (字符串)：效果 - 施法者<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_CASTER_ART = japi.ABILITY_LEVEL_DEF_DATA_CASTER_ART,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (字符串)：效果 - 目标<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_TARGET_ART = japi.ABILITY_LEVEL_DEF_DATA_TARGET_ART,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (字符串)：效果 - 目标点<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_EFFECT_ART = japi.ABILITY_LEVEL_DEF_DATA_EFFECT_ART,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (字符串)：投射物图像<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_MISSILE_ART = japi.ABILITY_LEVEL_DEF_DATA_MISSILE_ART,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (字符串)：效果 - 特殊<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_SPECIAL_ART = japi.ABILITY_LEVEL_DEF_DATA_SPECIAL_ART,
    ---@type ABILITY_LEVEL_DEF_DATA
    ---技能物编等级数据 (字符串)：闪电效果<br>
    ---来源: MemHack
    ABILITY_LEVEL_DEF_DATA_LIGHTNING_EFFECT = japi.ABILITY_LEVEL_DEF_DATA_LIGHTNING_EFFECT,



    --@alias ABILITY_LEVEL_EXTRA_DATA integer

    ---@type ABILITY_LEVEL_EXTRA_DATA
    ---技能额外等级数据 (整数): 黄金消耗<br>
    ---来源: MemHack
    ABILITY_LEVEL_EXTRA_DATA_GOLD_COST = japi.ABILITY_LEVEL_EXTRA_DATA_GOLD_COST,
    ---@type ABILITY_LEVEL_EXTRA_DATA
    ---技能额外等级数据 (整数): 木材消耗<br>
    ---来源: MemHack
    ABILITY_LEVEL_EXTRA_DATA_LUMBER_COST = japi.ABILITY_LEVEL_EXTRA_DATA_LUMBER_COST,
    ---@type ABILITY_LEVEL_EXTRA_DATA
    ---技能额外等级数据 (整数): 人口消耗<br>
    ---来源: MemHack
    ABILITY_LEVEL_EXTRA_DATA_FOOD_COST = japi.ABILITY_LEVEL_EXTRA_DATA_FOOD_COST,



    --@alias ABILITY_ORDEF_FLAG integer

    ---@type ABILITY_ORDEF_FLAG
    ---技能命令: 释放<br>
    ---来源: MemHack
    ABILITY_ORDER_FLAG_CAST = japi.ABILITY_ORDER_FLAG_CAST,
    ---@type ABILITY_ORDEF_FLAG
    ---技能命令: 开启<br>
    ---来源: MemHack
    ABILITY_ORDER_FLAG_ON = japi.ABILITY_ORDER_FLAG_ON,
    ---@type ABILITY_ORDEF_FLAG
    ---技能命令: 关闭<br>
    ---来源: MemHack
    ABILITY_ORDER_FLAG_OFF = japi.ABILITY_ORDER_FLAG_OFF,



    --@alias ABILITY_POLARITY integer

    ---@type ABILITY_POLARITY
    ---技能极性: 光环<br>
    ---来源: MemHack
    ABILITY_POLARITY_AURA = japi.ABILITY_POLARITY_AURA,
    ---@type ABILITY_POLARITY
    ---技能极性: 物理<br>
    ---来源: MemHack
    ABILITY_POLARITY_PHYSICAL = japi.ABILITY_POLARITY_PHYSICAL,
    ---@type ABILITY_POLARITY
    ---技能极性: 魔法<br>
    ---来源: MemHack
    ABILITY_POLARITY_MAGIC = japi.ABILITY_POLARITY_MAGIC,



    --@alias ANCHOR integer

    ---@type ANCHOR
    ---锚点: 左上<br>
    ---来源: MemHack
    ANCHOR_TOP_LEFT = japi.ANCHOR_TOP_LEFT,
    ---@type ANCHOR
    ---锚点: 顶部<br>
    ---来源: MemHack
    ANCHOR_TOP = japi.ANCHOR_TOP,
    ---@type ANCHOR
    ---锚点: 右上<br>
    ---来源: MemHack
    ANCHOR_TOP_RIGHT = japi.ANCHOR_TOP_RIGHT,
    ---@type ANCHOR
    ---锚点: 左侧<br>
    ---来源: MemHack
    ANCHOR_LEFT = japi.ANCHOR_LEFT,
    ---@type ANCHOR
    ---锚点: 中心<br>
    ---来源: MemHack
    ANCHOR_CENTER = japi.ANCHOR_CENTER,
    ---@type ANCHOR
    ---锚点: 右侧<br>
    ---来源: MemHack
    ANCHOR_RIGHT = japi.ANCHOR_RIGHT,
    ---@type ANCHOR
    ---锚点: 左下<br>
    ---来源: MemHack
    ANCHOR_BOTTOM_LEFT = japi.ANCHOR_BOTTOM_LEFT,
    ---@type ANCHOR
    ---锚点: 底部<br>
    ---来源: MemHack
    ANCHOR_BOTTOM = japi.ANCHOR_BOTTOM,
    ---@type ANCHOR
    ---锚点: 右下<br>
    ---来源: MemHack
    ANCHOR_BOTTOM_RIGHT = japi.ANCHOR_BOTTOM_RIGHT,



    --@alias ANIM_TYPE integer

    ---@type ANIM_TYPE
    ---动画类型: 出生<br>
    ---估计包含训练完成、创建、召唤<br>
    ---来源: MemHack
    ANIM_TYPE_BIRTH = japi.ANIM_TYPE_BIRTH,
    ---@type ANIM_TYPE
    ---动画类型: 死亡<br>
    ---来源: MemHack
    ANIM_TYPE_DEATH = japi.ANIM_TYPE_DEATH,
    ---@type ANIM_TYPE
    ---动画类型: 腐烂<br>
    ---来源: MemHack
    ANIM_TYPE_DECAY = japi.ANIM_TYPE_DECAY,
    ---@type ANIM_TYPE
    ---动画类型: 英雄消散<br>
    ---来源: MemHack
    ANIM_TYPE_DISSIPATE = japi.ANIM_TYPE_DISSIPATE,
    ---@type ANIM_TYPE
    ---动画类型: 站立<br>
    ---来源: MemHack
    ANIM_TYPE_STAND = japi.ANIM_TYPE_STAND,
    ---@type ANIM_TYPE
    ---动画类型: 行走<br>
    ---来源: MemHack
    ANIM_TYPE_WALK = japi.ANIM_TYPE_WALK,
    ---@type ANIM_TYPE
    ---动画类型: 攻击<br>
    ---来源: MemHack
    ANIM_TYPE_ATTACK = japi.ANIM_TYPE_ATTACK,
    ---@type ANIM_TYPE
    ---动画类型: 变身<br>
    ---来源: MemHack
    ANIM_TYPE_MORPH = japi.ANIM_TYPE_MORPH,
    ---@type ANIM_TYPE
    ---动画类型: 睡眠<br>
    ---来源: MemHack
    ANIM_TYPE_SLEEP = japi.ANIM_TYPE_SLEEP,
    ---@type ANIM_TYPE
    ---动画类型: 施法<br>
    ---来源: MemHack
    ANIM_TYPE_SPELL = japi.ANIM_TYPE_SPELL,
    ---@type ANIM_TYPE
    ---动画类型: 头像视窗<br>
    ---来源: MemHack
    ANIM_TYPE_PORTRAIT = japi.ANIM_TYPE_PORTRAIT,



    --@alias AUDIO_ATTENUATION integer

    ---@type AUDIO_ATTENUATION
    ---衰减类型: 无衰减<br>
    ---也不会空间化<br>
    ---来源: MemHack
    AUDIO_ATTENUATION_NONE = japi.AUDIO_ATTENUATION_NONE,
    ---@type AUDIO_ATTENUATION
    ---反比例衰减<br>
    ---来源: MemHack
    AUDIO_ATTENUATION_INVERSE = japi.AUDIO_ATTENUATION_INVERSE,
    ---@type AUDIO_ATTENUATION
    ---线性衰减<br>
    ---来源: MemHack
    AUDIO_ATTENUATION_LINEAR = japi.AUDIO_ATTENUATION_LINEAR,
    ---@type AUDIO_ATTENUATION
    ---指数衰减<br>
    ---来源: MemHack
    AUDIO_ATTENUATION_EXPONENTIAL = japi.AUDIO_ATTENUATION_EXPONENTIAL,



    --@alias AUDIO_TYPE integer

    ---@type AUDIO_TYPE
    ---音频类型: 音效<br>
    ---来源: MemHack
    AUDIO_TYPE_AUDIO = japi.AUDIO_TYPE_AUDIO,
    ---@type AUDIO_TYPE
    ---音频类型: 音乐<br>
    ---来源: MemHack
    AUDIO_TYPE_MUSIC = japi.AUDIO_TYPE_MUSIC,



    --@alias BORDER_FLAG integer

    ---@type BORDER_FLAG
    ---边框标志: 左<br>
    ---来源: MemHack
    BORDER_FLAG_LEFT = japi.BORDER_FLAG_LEFT,
    ---@type BORDER_FLAG
    ---边框标志: 右<br>
    ---来源: MemHack
    BORDER_FLAG_RIGHT = japi.BORDER_FLAG_RIGHT,
    ---@type BORDER_FLAG
    ---边框标志: 上<br>
    ---来源: MemHack
    BORDER_FLAG_TOP = japi.BORDER_FLAG_TOP,
    ---@type BORDER_FLAG
    ---边框标志: 下<br>
    ---来源: MemHack
    BORDER_FLAG_BOTTOM = japi.BORDER_FLAG_BOTTOM,
    ---@type BORDER_FLAG
    ---边框标志: 左上<br>
    ---来源: MemHack
    BORDER_FLAG_TOP_LEFT = japi.BORDER_FLAG_TOP_LEFT,
    ---@type BORDER_FLAG
    ---边框标志: 右上<br>
    ---来源: MemHack
    BORDER_FLAG_TOP_RIGHT = japi.BORDER_FLAG_TOP_RIGHT,
    ---@type BORDER_FLAG
    ---边框标志: 左下<br>
    ---来源: MemHack
    BORDER_FLAG_BOTTOM_LEFT = japi.BORDER_FLAG_BOTTOM_LEFT,
    ---@type BORDER_FLAG
    ---边框标志: 右下<br>
    ---来源: MemHack
    BORDER_FLAG_BOTTOM_RIGHT = japi.BORDER_FLAG_BOTTOM_RIGHT,



    --@alias BUFF_POLARITY integer

    ---@type BUFF_POLARITY
    ---魔法效果极性: 正面<br>
    ---来源: MemHack
    BUFF_POLARITY_POSITIVE = japi.BUFF_POLARITY_POSITIVE,
    ---@type BUFF_POLARITY
    ---魔法效果极性: 负面<br>
    ---来源: MemHack
    BUFF_POLARITY_NEGATIVE = japi.BUFF_POLARITY_NEGATIVE,
    ---@type BUFF_POLARITY
    ---魔法效果极性: 光环<br>
    ---来源: MemHack
    BUFF_POLARITY_AURA = japi.BUFF_POLARITY_AURA,
    ---@type BUFF_POLARITY
    ---魔法效果极性: 生命周期<br>
    ---来源: MemHack
    BUFF_POLARITY_TIMED_LIFE = japi.BUFF_POLARITY_TIMED_LIFE,
    ---@type BUFF_POLARITY
    ---魔法效果极性: 物理<br>
    ---来源: MemHack
    BUFF_POLARITY_PHYSICAL = japi.BUFF_POLARITY_PHYSICAL,
    ---@type BUFF_POLARITY
    ---魔法效果极性: 魔法<br>
    ---来源: MemHack
    BUFF_POLARITY_MAGIC = japi.BUFF_POLARITY_MAGIC,
    ---@type BUFF_POLARITY
    ---魔法效果极性: 不可驱散<br>
    ---来源: MemHack
    BUFF_POLARITY_CANT_DISPEL = japi.BUFF_POLARITY_CANT_DISPEL,



    --@alias BUFF_TEMPLATE integer

    ---@type BUFF_TEMPLATE
    ---BUFF模板: 心灵之火<br>
    ---vf(0x354, target, &dur, &DataA, &DataB, &DataD, &DataE)<br>
    ---来源: MemHack
    BUFF_TEMPLATE_BINF = japi.BUFF_TEMPLATE_BINF,
    ---@type BUFF_TEMPLATE
    ---BUFF模板: 减速<br>
    ---vf(0x354, target, &dur, source, &DataA, &DataB)<br>
    ---来源: MemHack
    BUFF_TEMPLATE_BSLO = japi.BUFF_TEMPLATE_BSLO,
    ---@type BUFF_TEMPLATE
    ---BUFF模板: 嗜血术<br>
    ---vf(0x354, target, &dur, source, &DataB, &DataA, &DataC)<br>
    ---来源: MemHack
    BUFF_TEMPLATE_BBLO = japi.BUFF_TEMPLATE_BBLO,
    ---@type BUFF_TEMPLATE
    ---BUFF模板: 闪电护盾<br>
    ---vf(0x358, target, &dur, &0.5f, &area, &(DataA / 2.f), 2, source->owner_id, 0xD008E, abil)<br>
    ---来源: MemHack
    BUFF_TEMPLATE_BLSH = japi.BUFF_TEMPLATE_BLSH,
    ---@type BUFF_TEMPLATE
    ---BUFF模板: 霜冻护甲<br>
    ---vf(0x358, target, &dur, &0.5f, &area, &(DataA / 2.f), 2, source->owner_id, 0xD008E, abil)<br>
    ---来源: MemHack
    BUFF_TEMPLATE_BUFA = japi.BUFF_TEMPLATE_BUFA,
    ---@type BUFF_TEMPLATE
    ---BUFF模板: 残废<br>
    ---来源: MemHack
    BUFF_TEMPLATE_BCRI = japi.BUFF_TEMPLATE_BCRI,
    ---@type BUFF_TEMPLATE
    ---BUFF模板: 邪恶狂热<br>
    ---来源: MemHack
    BUFF_TEMPLATE_BUHF = japi.BUFF_TEMPLATE_BUHF,
    ---@type BUFF_TEMPLATE
    ---BUFF模板: 诅咒<br>
    ---来源: MemHack
    BUFF_TEMPLATE_BCRS = japi.BUFF_TEMPLATE_BCRS,
    ---@type BUFF_TEMPLATE
    ---BUFF模板: 暗影突袭<br>
    ---来源: MemHack
    BUFF_TEMPLATE_BESH = japi.BUFF_TEMPLATE_BESH,
    ---@type BUFF_TEMPLATE
    ---BUFF模板: 精灵之火<br>
    ---来源: MemHack
    BUFF_TEMPLATE_BFAE = japi.BUFF_TEMPLATE_BFAE,
    ---@type BUFF_TEMPLATE
    ---BUFF模板: 咆哮<br>
    ---来源: MemHack
    BUFF_TEMPLATE_BROA = japi.BUFF_TEMPLATE_BROA,
    ---@type BUFF_TEMPLATE
    ---BUFF模板: 恐怖嚎叫<br>
    ---来源: MemHack
    BUFF_TEMPLATE_BNHT = japi.BUFF_TEMPLATE_BNHT,
    ---@type BUFF_TEMPLATE
    ---BUFF模板: 酸性炸弹<br>
    ---来源: MemHack
    BUFF_TEMPLATE_BNAB = japi.BUFF_TEMPLATE_BNAB,
    ---@type BUFF_TEMPLATE
    ---BUFF模板: 灵魂燃烧<br>
    ---来源: MemHack
    BUFF_TEMPLATE_BNSO = japi.BUFF_TEMPLATE_BNSO,
    ---@type BUFF_TEMPLATE
    ---BUFF模板: 醉酒云雾<br>
    ---来源: MemHack
    BUFF_TEMPLATE_BNDH = japi.BUFF_TEMPLATE_BNDH,



    --@alias CHAT_CHANNEL integer

    ---@type CHAT_CHANNEL
    ---玩家聊天频道: 全部<br>
    ---来源: MemHack
    CHAT_CHANNEL_ALL = japi.CHAT_CHANNEL_ALL,
    ---@type CHAT_CHANNEL
    ---玩家聊天频道: 盟友<br>
    ---来源: MemHack
    CHAT_CHANNEL_ALLY = japi.CHAT_CHANNEL_ALLY,
    ---@type CHAT_CHANNEL
    ---玩家聊天频道: 裁判<br>
    ---来源: MemHack
    CHAT_CHANNEL_OBSERVER = japi.CHAT_CHANNEL_OBSERVER,
    ---@type CHAT_CHANNEL
    ---玩家聊天频道: 私人<br>
    ---来源: MemHack
    CHAT_CHANNEL_PRIVATE = japi.CHAT_CHANNEL_PRIVATE,



    --@alias CHEAT_FLAG integer

    ---@type CHEAT_FLAG
    ---作弊标志: 无敌<br>
    ---来源: MemHack
    CHEAT_FLAG_WHOSYOURDADDY = japi.CHEAT_FLAG_WHOSYOURDADDY,
    ---@type CHEAT_FLAG
    ---作弊标志: 快速建造<br>
    ---来源: MemHack
    CHEAT_FLAG_WARPTEN = japi.CHEAT_FLAG_WARPTEN,
    ---@type CHEAT_FLAG
    ---作弊标志: 无限人口<br>
    ---来源: MemHack
    CHEAT_FLAG_POINTBREAK = japi.CHEAT_FLAG_POINTBREAK,
    ---@type CHEAT_FLAG
    ---作弊标志: 无限蓝<br>
    ---来源: MemHack
    CHEAT_FLAG_THEREISNOSPOON = japi.CHEAT_FLAG_THEREISNOSPOON,
    ---@type CHEAT_FLAG
    ---作弊标志: 不会失败<br>
    ---来源: MemHack
    CHEAT_FLAG_STRENGTHANDHONOR = japi.CHEAT_FLAG_STRENGTHANDHONOR,
    ---@type CHEAT_FLAG
    ---作弊标志: 不会胜利<br>
    ---来源: MemHack
    CHEAT_FLAG_ITVEXESME = japi.CHEAT_FLAG_ITVEXESME,
    ---@type CHEAT_FLAG
    ---作弊标志: 取消学习技能等级限制<br>
    ---来源: MemHack
    CHEAT_FLAG_WHOISJOHNGALT = japi.CHEAT_FLAG_WHOISJOHNGALT,
    ---@type CHEAT_FLAG
    ---作弊标志: 全图<br>
    ---来源: MemHack
    CHEAT_FLAG_ISEEDEADPEOPLE = japi.CHEAT_FLAG_ISEEDEADPEOPLE,
    ---@type CHEAT_FLAG
    ---作弊标志: 全科技<br>
    ---来源: MemHack
    CHEAT_FLAG_SYNERGY = japi.CHEAT_FLAG_SYNERGY,
    ---@type CHEAT_FLAG
    ---作弊标志: 停止时间流逝<br>
    ---来源: MemHack
    CHEAT_FLAG_DAYLIGHTSAVINGS = japi.CHEAT_FLAG_DAYLIGHTSAVINGS,



    --@alias DAMAGE_FLAG integer

    ---@type DAMAGE_FLAG
    ---伤害标志: 远程伤害<br>
    ---来源: MemHack
    DAMAGE_FLAG_RANGED = japi.DAMAGE_FLAG_RANGED,
    ---@type DAMAGE_FLAG
    ---伤害标志: 无效伤害<br>
    ---不会结算伤害<br>
    ---但是会触发受伤单位的一些被动效果<br>
    ---来源: MemHack
    DAMAGE_FLAG_INVALID = japi.DAMAGE_FLAG_INVALID,
    ---@type DAMAGE_FLAG
    ---伤害标志: 炮火伤害<br>
    ---致死时会播放尸体爆炸的特效 (效果 - 特殊)<br>
    ---来源: MemHack
    DAMAGE_FLAG_ARTILLERY = japi.DAMAGE_FLAG_ARTILLERY,
    ---@type DAMAGE_FLAG
    ---伤害标志: BUFF伤害<br>
    ---给予/失去BUFF时会有该标志<br>
    ---不会结算伤害<br>
    ---若要制作自定义伤害系统可在前伤害事件中添加该标志以屏蔽原生伤害事件<br>
    ---来源: MemHack
    DAMAGE_FLAG_BUFF = japi.DAMAGE_FLAG_BUFF,
    ---@type DAMAGE_FLAG
    ---伤害标志: 无视无敌<br>
    ---来源: MemHack
    DAMAGE_FLAG_IGNORE_INVULNERABLE = japi.DAMAGE_FLAG_IGNORE_INVULNERABLE,
    ---@type DAMAGE_FLAG
    ---伤害标志: 范围伤害<br>
    ---来源: MemHack
    DAMAGE_FLAG_AREA = japi.DAMAGE_FLAG_AREA,
    ---@type DAMAGE_FLAG
    ---伤害标志: 攻击伤害<br>
    ---来源: MemHack
    DAMAGE_FLAG_ATTACK = japi.DAMAGE_FLAG_ATTACK,
    ---@type DAMAGE_FLAG
    ---伤害标志: 不会丢失<br>
    ---致命一击/重击/醉拳等开启不会丢失后的标志<br>
    ---仍然会因为高低差而丢失 (见游戏平衡常数)<br>
    ---来源: MemHack
    DAMAGE_FLAG_SURE_HIT = japi.DAMAGE_FLAG_SURE_HIT,



    --@alias EVENT_ID integer

    ---@type EVENT_ID
    ---事件ID: 进入地图<br>
    ---来源: MemHack
    EVENT_ID_GAME_START = japi.EVENT_ID_GAME_START,
    ---@type EVENT_ID
    ---事件ID: 游戏TICK<br>
    ---来源: MemHack
    EVENT_ID_GAME_TICK = japi.EVENT_ID_GAME_TICK,
    ---@type EVENT_ID
    ---事件ID: 任意单位被创建<br>
    ---来源: MemHack
    EVENT_ID_UNIT_CREATE = japi.EVENT_ID_UNIT_CREATE,
    ---@type EVENT_ID
    ---事件ID: 任意单位被删除<br>
    ---来源: MemHack
    EVENT_ID_UNIT_REMOVE = japi.EVENT_ID_UNIT_REMOVE,
    ---@type EVENT_ID
    ---事件ID: 任意单位攻击出手<br>
    ---来源: MemHack
    EVENT_ID_UNIT_ATTACK_LAUNCH = japi.EVENT_ID_UNIT_ATTACK_LAUNCH,
    ---@type EVENT_ID
    ---事件ID: 任意单位切换仇恨目标<br>
    ---来源: MemHack
    EVENT_ID_UNIT_SEARCH_TARGET = japi.EVENT_ID_UNIT_SEARCH_TARGET,
    ---@type EVENT_ID
    ---事件ID: 任意单位恢复生命值<br>
    ---来源: MemHack
    EVENT_ID_UNIT_RESTORE_LIFE = japi.EVENT_ID_UNIT_RESTORE_LIFE,
    ---@type EVENT_ID
    ---事件ID: 任意单位恢复魔法值<br>
    ---来源: MemHack
    EVENT_ID_UNIT_RESTORE_MANA = japi.EVENT_ID_UNIT_RESTORE_MANA,
    ---@type EVENT_ID
    ---事件ID: 任意单位被驱散魔法效果<br>
    ---来源: MemHack
    EVENT_ID_UNIT_DISPEL_BUFF = japi.EVENT_ID_UNIT_DISPEL_BUFF,
    ---@type EVENT_ID
    ---事件ID: 任意单位送回资源<br>
    ---来源: MemHack
    EVENT_ID_UNIT_HARVEST = japi.EVENT_ID_UNIT_HARVEST,
    ---@type EVENT_ID
    ---事件ID: 任意单位获取经验值<br>
    ---来源: MemHack
    EVENT_ID_HERO_GET_EXP = japi.EVENT_ID_HERO_GET_EXP,
    ---@type EVENT_ID
    ---事件ID: 任意单位接受伤害<br>
    ---来源: MemHack
    EVENT_ID_UNIT_DAMAGE = japi.EVENT_ID_UNIT_DAMAGE,
    ---@type EVENT_ID
    ---事件ID: 任意单位即将受伤<br>
    ---来源: MemHack
    EVENT_ID_UNIT_DAMAGING = japi.EVENT_ID_UNIT_DAMAGING,
    ---@type EVENT_ID
    ---事件ID: 任意技能被添加<br>
    ---来源: MemHack
    EVENT_ID_ABILITY_ADD = japi.EVENT_ID_ABILITY_ADD,
    ---@type EVENT_ID
    ---事件ID: 任意技能被删除<br>
    ---来源: MemHack
    EVENT_ID_ABILITY_REMOVE = japi.EVENT_ID_ABILITY_REMOVE,
    ---@type EVENT_ID
    ---事件ID: 任意技能进入冷却<br>
    ---来源: MemHack
    EVENT_ID_ABILITY_START_COOLDOWN = japi.EVENT_ID_ABILITY_START_COOLDOWN,
    ---@type EVENT_ID
    ---事件ID: 任意技能结束冷却<br>
    ---来源: MemHack
    EVENT_ID_ABILITY_END_COOLDOWN = japi.EVENT_ID_ABILITY_END_COOLDOWN,
    ---@type EVENT_ID
    ---事件ID: 任意光环技能刷新<br>
    ---来源: MemHack
    EVENT_ID_ABILITY_REFRESH_AURA = japi.EVENT_ID_ABILITY_REFRESH_AURA,
    ---@type EVENT_ID
    ---事件ID: 任意物品被创建<br>
    ---来源: MemHack
    EVENT_ID_ITEM_CREATE = japi.EVENT_ID_ITEM_CREATE,
    ---@type EVENT_ID
    ---事件ID: 任意物品被删除<br>
    ---来源: MemHack
    EVENT_ID_ITEM_REMOVE = japi.EVENT_ID_ITEM_REMOVE,
    ---@type EVENT_ID
    ---事件ID: 任意玩家黄金变动<br>
    ---来源: MemHack
    EVENT_ID_PLAYER_GOLD_CHANGE = japi.EVENT_ID_PLAYER_GOLD_CHANGE,
    ---@type EVENT_ID
    ---事件ID: 任意玩家木材变动<br>
    ---来源: MemHack
    EVENT_ID_PLAYER_LUMBER_CHANGE = japi.EVENT_ID_PLAYER_LUMBER_CHANGE,
    ---@type EVENT_ID
    ---事件ID: 任意投射物发射<br>
    ---来源: MemHack
    EVENT_ID_MISSILE_LAUNCH = japi.EVENT_ID_MISSILE_LAUNCH,
    ---@type EVENT_ID
    ---事件ID: 任意投射物命中<br>
    ---来源: MemHack
    EVENT_ID_MISSILE_HIT = japi.EVENT_ID_MISSILE_HIT,
    ---@type EVENT_ID
    ---事件ID: 哈希表数据改变<br>
    ---来源: MemHack
    EVENT_ID_HASHTABLE_CHANGE = japi.EVENT_ID_HASHTABLE_CHANGE,
    ---@type EVENT_ID
    ---事件ID: 数据同步<br>
    ---来源: MemHack
    EVENT_ID_SYNC = japi.EVENT_ID_SYNC,
    ---@type EVENT_ID
    ---事件ID: 停止地图<br>
    ---来源: MemHack
    EVENT_ID_GAME_STOP = japi.EVENT_ID_GAME_STOP,
    ---@type EVENT_ID
    ---事件ID: 退出地图<br>
    ---来源: MemHack
    EVENT_ID_GAME_EXIT = japi.EVENT_ID_GAME_EXIT,
    ---@type EVENT_ID
    ---事件ID: 任意玩家离开<br>
    ---来源: MemHack
    EVENT_ID_PLAYER_LEAVE = japi.EVENT_ID_PLAYER_LEAVE,
    ---@type EVENT_ID
    ---事件ID: 鼠标进入任意Frame<br>
    ---来源: MemHack
    EVENT_ID_FRAME_MOUSE_ENTER = japi.EVENT_ID_FRAME_MOUSE_ENTER,
    ---@type EVENT_ID
    ---事件ID: 鼠标离开任意Frame<br>
    ---来源: MemHack
    EVENT_ID_FRAME_MOUSE_LEAVE = japi.EVENT_ID_FRAME_MOUSE_LEAVE,
    ---@type EVENT_ID
    ---事件ID: 鼠标按下任意Frame<br>
    ---来源: MemHack
    EVENT_ID_FRAME_MOUSE_DOWN = japi.EVENT_ID_FRAME_MOUSE_DOWN,
    ---@type EVENT_ID
    ---事件ID: 鼠标弹起任意Frame<br>
    ---来源: MemHack
    EVENT_ID_FRAME_MOUSE_UP = japi.EVENT_ID_FRAME_MOUSE_UP,
    ---@type EVENT_ID
    ---事件ID: 鼠标点击任意Frame<br>
    ---来源: MemHack
    EVENT_ID_FRAME_MOUSE_CLICK = japi.EVENT_ID_FRAME_MOUSE_CLICK,
    ---@type EVENT_ID
    ---事件ID: 鼠标双击任意Frame<br>
    ---来源: MemHack
    EVENT_ID_FRAME_MOUSE_DOUBLE_CLICK = japi.EVENT_ID_FRAME_MOUSE_DOUBLE_CLICK,
    ---@type EVENT_ID
    ---事件ID: 鼠标滚动任意Frame<br>
    ---来源: MemHack
    EVENT_ID_FRAME_MOUSE_SCROLL = japi.EVENT_ID_FRAME_MOUSE_SCROLL,
    ---@type EVENT_ID
    ---事件ID: 本地玩家按键弹起<br>
    ---来源: MemHack
    EVENT_ID_KEY_UP = japi.EVENT_ID_KEY_UP,
    ---@type EVENT_ID
    ---事件ID: 本地玩家按键按下<br>
    ---来源: MemHack
    EVENT_ID_KEY_DOWN = japi.EVENT_ID_KEY_DOWN,
    ---@type EVENT_ID
    ---事件ID: 本地玩家按键按住<br>
    ---来源: MemHack
    EVENT_ID_KEY_HOLD = japi.EVENT_ID_KEY_HOLD,
    ---@type EVENT_ID
    ---事件ID: 本地玩家鼠标弹起<br>
    ---来源: MemHack
    EVENT_ID_MOUSE_UP = japi.EVENT_ID_MOUSE_UP,
    ---@type EVENT_ID
    ---事件ID: 本地玩家鼠标按下<br>
    ---来源: MemHack
    EVENT_ID_MOUSE_DOWN = japi.EVENT_ID_MOUSE_DOWN,
    ---@type EVENT_ID
    ---事件ID: 本地玩家鼠标滚动<br>
    ---来源: MemHack
    EVENT_ID_MOUSE_SCROLL = japi.EVENT_ID_MOUSE_SCROLL,
    ---@type EVENT_ID
    ---事件ID: 本地玩家鼠标移动<br>
    ---来源: MemHack
    EVENT_ID_MOUSE_MOVE = japi.EVENT_ID_MOUSE_MOVE,
    ---@type EVENT_ID
    ---事件ID: 本地玩家按下目标指示器<br>
    ---来源: MemHack
    EVENT_ID_TARGET_INDICATOR = japi.EVENT_ID_TARGET_INDICATOR,
    ---@type EVENT_ID
    ---事件ID: 本地玩家调起目标指示器<br>
    ---来源: MemHack
    EVENT_ID_CALL_TARGET_MODE = japi.EVENT_ID_CALL_TARGET_MODE,
    ---@type EVENT_ID
    ---事件ID: 本地玩家调起建造指示器<br>
    ---来源: MemHack
    EVENT_ID_CALL_BUILD_MODE = japi.EVENT_ID_CALL_BUILD_MODE,
    ---@type EVENT_ID
    ---事件ID: 本地玩家取消指示器<br>
    ---来源: MemHack
    EVENT_ID_CANCEL_INDICATOR = japi.EVENT_ID_CANCEL_INDICATOR,
    ---@type EVENT_ID
    ---事件ID: 本地玩家发布无目标命令<br>
    ---来源: MemHack
    EVENT_ID_LOCAL_IMMEDIATE_ORDER = japi.EVENT_ID_LOCAL_IMMEDIATE_ORDER,
    ---@type EVENT_ID
    ---事件ID: 本地玩家发布目标命令<br>
    ---来源: MemHack
    EVENT_ID_LOCAL_TARGET_ORDER = japi.EVENT_ID_LOCAL_TARGET_ORDER,
    ---@type EVENT_ID
    ---事件ID: 本地玩家发布丢弃物品命令<br>
    ---来源: MemHack
    EVENT_ID_LOCAL_DROPITEM_ORDER = japi.EVENT_ID_LOCAL_DROPITEM_ORDER,
    ---@type EVENT_ID
    ---事件ID: 本地玩家发布右键物体命令<br>
    ---来源: MemHack
    EVENT_ID_LOCAL_SMART_ORDER = japi.EVENT_ID_LOCAL_SMART_ORDER,
    ---@type EVENT_ID
    ---事件ID: 帧绘制<br>
    ---来源: MemHack
    EVENT_ID_FRAME_TICK = japi.EVENT_ID_FRAME_TICK,
    ---@type EVENT_ID
    ---事件ID: 血条刷新<br>
    ---来源: MemHack
    EVENT_ID_REFRESH_HPBAR = japi.EVENT_ID_REFRESH_HPBAR,
    ---@type EVENT_ID
    ---事件ID: 预渲染<br>
    ---来源: MemHack
    EVENT_ID_PRERENDER = japi.EVENT_ID_PRERENDER,
    ---@type EVENT_ID
    ---事件ID: 窗口大小变化<br>
    ---来源: MemHack
    EVENT_ID_WINDOW_RESIZE = japi.EVENT_ID_WINDOW_RESIZE,
    ---@type EVENT_ID
    ---事件ID: 开始播放音频<br>
    ---来源: MemHack
    EVENT_ID_AUDIO_START = japi.EVENT_ID_AUDIO_START,
    ---@type EVENT_ID
    ---事件ID: 停止播放音频<br>
    ---来源: MemHack
    EVENT_ID_AUDIO_STOP = japi.EVENT_ID_AUDIO_STOP,
    ---@type EVENT_ID
    ---事件ID: HTTP消息<br>
    ---来源: MemHack
    EVENT_ID_HTTP_MESSAGE = japi.EVENT_ID_HTTP_MESSAGE,
    ---@type EVENT_ID
    ---事件ID: WebSocket客户端建立连接<br>
    ---来源: MemHack
    EVENT_ID_WS_CLIENT_OPEN = japi.EVENT_ID_WS_CLIENT_OPEN,
    ---@type EVENT_ID
    ---事件ID: WebSocket客户端断开连接<br>
    ---来源: MemHack
    EVENT_ID_WS_CLIENT_CLOSE = japi.EVENT_ID_WS_CLIENT_CLOSE,
    ---@type EVENT_ID
    ---事件ID: WebSocket客户端连接失败<br>
    ---来源: MemHack
    EVENT_ID_WS_CLIENT_FAIL = japi.EVENT_ID_WS_CLIENT_FAIL,
    ---@type EVENT_ID
    ---事件ID: WebSocket客户端尝试重连<br>
    ---来源: MemHack
    EVENT_ID_WS_CLIENT_RECONNECT = japi.EVENT_ID_WS_CLIENT_RECONNECT,
    ---@type EVENT_ID
    ---事件ID: WebSocket客户端正在重连<br>
    ---来源: MemHack
    EVENT_ID_WS_CLIENT_RECONNECTING = japi.EVENT_ID_WS_CLIENT_RECONNECTING,
    ---@type EVENT_ID
    ---事件ID: WebSocket客户端建立Socket连接<br>
    ---来源: MemHack
    EVENT_ID_WS_CLIENT_OPEN_SOCKET = japi.EVENT_ID_WS_CLIENT_OPEN_SOCKET,
    ---@type EVENT_ID
    ---事件ID: WebSocket客户端关闭Socket连接<br>
    ---来源: MemHack
    EVENT_ID_WS_CLIENT_CLOSE_SOCKET = japi.EVENT_ID_WS_CLIENT_CLOSE_SOCKET,
    ---@type EVENT_ID
    ---事件ID: WebSocket套接字消息<br>
    ---来源: MemHack
    EVENT_ID_WS_SOCKET_MESSAGE = japi.EVENT_ID_WS_SOCKET_MESSAGE,



    --@alias FLAG_OPERATOR integer

    ---@type FLAG_OPERATOR
    ---操作类型: 添加<br>
    ---来源: MemHack
    FLAG_OPERATOR_ADD = japi.FLAG_OPERATOR_ADD,
    ---@type FLAG_OPERATOR
    ---操作类型: 删除<br>
    ---来源: MemHack
    FLAG_OPERATOR_REMOVE = japi.FLAG_OPERATOR_REMOVE,



    --@alias FRAME_POINT integer

    ---@type FRAME_POINT
    ---锚点类型: 绝对锚点<br>
    ---来源: MemHack
    FRAME_POINT_ABSOLUTE = japi.FRAME_POINT_ABSOLUTE,
    ---@type FRAME_POINT
    ---锚点类型: 相对锚点<br>
    ---来源: MemHack
    FRAME_POINT_RELATIVE = japi.FRAME_POINT_RELATIVE,



    --@alias GAME_OPTION integer

    ---@type GAME_OPTION
    ---游戏设置: 分辨率宽度<br>
    ---来源: MemHack
    GAME_OPTION_RE_WIDTH = japi.GAME_OPTION_RE_WIDTH,
    ---@type GAME_OPTION
    ---游戏设置: 分辨率高度<br>
    ---来源: MemHack
    GAME_OPTION_RE_HEIGHT = japi.GAME_OPTION_RE_HEIGHT,
    ---@type GAME_OPTION
    ---游戏设置: 颜色深度<br>
    ---32|64<br>
    ---来源: MemHack
    GAME_OPTION_COLOR_DEPTH = japi.GAME_OPTION_COLOR_DEPTH,
    ---@type GAME_OPTION
    ---游戏设置: 适配器?<br>
    ---来源: MemHack
    GAME_OPTION_ADAPTER = japi.GAME_OPTION_ADAPTER,
    ---@type GAME_OPTION
    ---游戏设置: 刷新率<br>
    ---来源: MemHack
    GAME_OPTION_REFRESH_RATE = japi.GAME_OPTION_REFRESH_RATE,
    ---@type GAME_OPTION
    ---游戏设置: 伽马值<br>
    ---0~100<br>
    ---来源: MemHack
    GAME_OPTION_GAMMA = japi.GAME_OPTION_GAMMA,
    ---@type GAME_OPTION
    ---游戏设置: 模型细节<br>
    ---0~2表示低中高<br>
    ---来源: MemHack
    GAME_OPTION_MODEL_DETAIL = japi.GAME_OPTION_MODEL_DETAIL,
    ---@type GAME_OPTION
    ---游戏设置: 动画质量<br>
    ---0~2表示低中高<br>
    ---来源: MemHack
    GAME_OPTION_ANIMATION_QUALITY = japi.GAME_OPTION_ANIMATION_QUALITY,
    ---@type GAME_OPTION
    ---游戏设置: 纹理质量<br>
    ---0~2表示低中高<br>
    ---来源: MemHack
    GAME_OPTION_TEXTURE_QUALITY = japi.GAME_OPTION_TEXTURE_QUALITY,
    ---@type GAME_OPTION
    ---游戏设置: mipmap等级?<br>
    ---来源: MemHack
    GAME_OPTION_MIP_LEVEL = japi.GAME_OPTION_MIP_LEVEL,
    ---@type GAME_OPTION
    ---游戏设置: 纹理颜色深度<br>
    ---32|64<br>
    ---来源: MemHack
    GAME_OPTION_TEXTURE_COLOR_DEPTH = japi.GAME_OPTION_TEXTURE_COLOR_DEPTH,
    ---@type GAME_OPTION
    ---游戏设置: 粒子<br>
    ---0~2表示低中高<br>
    ---来源: MemHack
    GAME_OPTION_PARTICLES = japi.GAME_OPTION_PARTICLES,
    ---@type GAME_OPTION
    ---游戏设置: 光线<br>
    ---0~2表示低中高<br>
    ---来源: MemHack
    GAME_OPTION_LIGHTS = japi.GAME_OPTION_LIGHTS,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---true|false<br>
    ---来源: MemHack
    GAME_OPTION_LOCKFB = japi.GAME_OPTION_LOCKFB,
    ---@type GAME_OPTION
    ---游戏设置: 单位阴影<br>
    ---true|false<br>
    ---来源: MemHack
    GAME_OPTION_UNIT_SHADOWS = japi.GAME_OPTION_UNIT_SHADOWS,
    ---@type GAME_OPTION
    ---游戏设置: 闭塞<br>
    ---true|false<br>
    ---来源: MemHack
    GAME_OPTION_OCCLUSION = japi.GAME_OPTION_OCCLUSION,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_CINEMATIC_OVERRIDES = japi.GAME_OPTION_CINEMATIC_OVERRIDES,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_CINEMATIC_REFRESH = japi.GAME_OPTION_CINEMATIC_REFRESH,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_CINEMATIC_BPP = japi.GAME_OPTION_CINEMATIC_BPP,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_CINEMATIC_WIDTH = japi.GAME_OPTION_CINEMATIC_WIDTH,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_CINEMATIC_HEIGHT = japi.GAME_OPTION_CINEMATIC_HEIGHT,
    ---@type GAME_OPTION
    ---游戏设置: 魔法效果<br>
    ---0~2表示低中高<br>
    ---来源: MemHack
    GAME_OPTION_SPELL_FILTER = japi.GAME_OPTION_SPELL_FILTER,
    ---@type GAME_OPTION
    ---游戏设置: 最大帧数<br>
    ---默认200<br>
    ---来源: MemHack
    GAME_OPTION_MAX_FPS = japi.GAME_OPTION_MAX_FPS,
    ---@type GAME_OPTION
    ---游戏设置: 声音驱动<br>
    ---0~2表示Dolby Surround/Miles Emulated 3D/Creative Labs EXA2<br>
    ---来源: MemHack
    GAME_OPTION_PROVIDER = japi.GAME_OPTION_PROVIDER,
    ---@type GAME_OPTION
    ---游戏设置: 3D音效<br>
    ---true|false<br>
    ---来源: MemHack
    GAME_OPTION_POSITIONAL = japi.GAME_OPTION_POSITIONAL,
    ---@type GAME_OPTION
    ---游戏设置: 环境效果<br>
    ---true|false<br>
    ---来源: MemHack
    GAME_OPTION_ENVIRONMENTAL = japi.GAME_OPTION_ENVIRONMENTAL,
    ---@type GAME_OPTION
    ---游戏设置: 开启音乐<br>
    ---true|false<br>
    ---来源: MemHack
    GAME_OPTION_MUSIC = japi.GAME_OPTION_MUSIC,
    ---@type GAME_OPTION
    ---游戏设置: 音乐音量<br>
    ---0~100<br>
    ---来源: MemHack
    GAME_OPTION_MUSIC_VOLUME = japi.GAME_OPTION_MUSIC_VOLUME,
    ---@type GAME_OPTION
    ---游戏设置: 开启声效<br>
    ---true|false<br>
    ---来源: MemHack
    GAME_OPTION_SFX = japi.GAME_OPTION_SFX,
    ---@type GAME_OPTION
    ---游戏设置: 声效音量<br>
    ---0~100<br>
    ---来源: MemHack
    GAME_OPTION_SFX_VOLUME = japi.GAME_OPTION_SFX_VOLUME,
    ---@type GAME_OPTION
    ---游戏设置: 环绕音响<br>
    ---true|false<br>
    ---来源: MemHack
    GAME_OPTION_AMBIENT = japi.GAME_OPTION_AMBIENT,
    ---@type GAME_OPTION
    ---游戏设置: 移动声音<br>
    ---true|false<br>
    ---来源: MemHack
    GAME_OPTION_MOVEMENT = japi.GAME_OPTION_MOVEMENT,
    ---@type GAME_OPTION
    ---游戏设置: 单位回应<br>
    ---true|false<br>
    ---来源: MemHack
    GAME_OPTION_UNIT = japi.GAME_OPTION_UNIT,
    ---@type GAME_OPTION
    ---游戏设置: 字幕<br>
    ---true|false<br>
    ---来源: MemHack
    GAME_OPTION_SUBTITLES = japi.GAME_OPTION_SUBTITLES,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_NO_MIDI = japi.GAME_OPTION_NO_MIDI,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_SOFTWARE_MIDI = japi.GAME_OPTION_SOFTWARE_MIDI,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_NO_SOUND_WARN = japi.GAME_OPTION_NO_SOUND_WARN,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_DO_NOT_USE_WAVE_OUT = japi.GAME_OPTION_DO_NOT_USE_WAVE_OUT,
    ---@type GAME_OPTION
    ---游戏设置: 游戏速度 不是设置里的游戏速度<br>
    ---来源: MemHack
    GAME_OPTION_GAME_SPEED = japi.GAME_OPTION_GAME_SPEED,
    ---@type GAME_OPTION
    ---游戏设置: 鼠标滚动<br>
    ---0~100<br>
    ---来源: MemHack
    GAME_OPTION_MOUSE_SCROLL = japi.GAME_OPTION_MOUSE_SCROLL,
    ---@type GAME_OPTION
    ---游戏设置: 取消鼠标滚动<br>
    ---true|false<br>
    ---来源: MemHack
    GAME_OPTION_MOUSE_SCROLL_DISABLE = japi.GAME_OPTION_MOUSE_SCROLL_DISABLE,
    ---@type GAME_OPTION
    ---游戏设置: 键盘滚动<br>
    ---0~100<br>
    ---来源: MemHack
    GAME_OPTION_KEY_SCROLL = japi.GAME_OPTION_KEY_SCROLL,
    ---@type GAME_OPTION
    ---游戏设置: 高级工具提示<br>
    ---true|false<br>
    ---来源: MemHack
    GAME_OPTION_TOOLTIPS = japi.GAME_OPTION_TOOLTIPS,
    ---@type GAME_OPTION
    ---游戏设置: 始终显示生命条<br>
    ---true|false<br>
    ---来源: MemHack
    GAME_OPTION_HEALTH_BARS = japi.GAME_OPTION_HEALTH_BARS,
    ---@type GAME_OPTION
    ---游戏设置: 开关队形移动<br>
    ---true|false<br>
    ---来源: MemHack
    GAME_OPTION_FORMATIONS = japi.GAME_OPTION_FORMATIONS,
    ---@type GAME_OPTION
    ---游戏设置: 启动队形移动开关<br>
    ---true|false<br>
    ---来源: MemHack
    GAME_OPTION_FORMATION_TOGGLE = japi.GAME_OPTION_FORMATION_TOGGLE,
    ---@type GAME_OPTION
    ---游戏设置: 是否显示英雄栏<br>
    ---来源: MemHack
    GAME_OPTION_HERO_BAR = japi.GAME_OPTION_HERO_BAR,
    ---@type GAME_OPTION
    ---游戏设置: 游戏端口<br>
    ---来源: MemHack
    GAME_OPTION_NET_GAME_PORT = japi.GAME_OPTION_NET_GAME_PORT,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_INPUT_SPROCKET = japi.GAME_OPTION_INPUT_SPROCKET,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_AMM_TYPE = japi.GAME_OPTION_AMM_TYPE,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_AMM_STYLES = japi.GAME_OPTION_AMM_STYLES,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_AMM_MAP_PREFS = japi.GAME_OPTION_AMM_MAP_PREFS,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_AMM_MAP_HASHES = japi.GAME_OPTION_AMM_MAP_HASHES,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_AMM_RACE = japi.GAME_OPTION_AMM_RACE,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_CUSTOM_FILTER = japi.GAME_OPTION_CUSTOM_FILTER,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_CUSTOM_MASK = japi.GAME_OPTION_CUSTOM_MASK,
    ---@type GAME_OPTION
    ---游戏设置: 联盟颜色模式<br>
    ---0~2代表模式1~模式3<br>
    ---来源: MemHack
    GAME_OPTION_ALLY_FILTER = japi.GAME_OPTION_ALLY_FILTER,
    ---@type GAME_OPTION
    ---游戏设置: 开关小地图中立单位显示<br>
    ---true|false<br>
    ---来源: MemHack
    GAME_OPTION_CREEP_FILTER = japi.GAME_OPTION_CREEP_FILTER,
    ---@type GAME_OPTION
    ---游戏设置: 开关小地图地形显示<br>
    ---true|false<br>
    ---来源: MemHack
    GAME_OPTION_TERRAIN_FIELTER = japi.GAME_OPTION_TERRAIN_FIELTER,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_SUBGROUP_ORDER = japi.GAME_OPTION_SUBGROUP_ORDER,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_MULTIBOARD_ON = japi.GAME_OPTION_MULTIBOARD_ON,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_CUSTOM_KEYS = japi.GAME_OPTION_CUSTOM_KEYS,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_SCHED_RACE = japi.GAME_OPTION_SCHED_RACE,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_AUTO_SAVE_REPLY = japi.GAME_OPTION_AUTO_SAVE_REPLY,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_USER_BNET = japi.GAME_OPTION_USER_BNET,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_USER_LOCAL = japi.GAME_OPTION_USER_LOCAL,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_SKIRMISH_V0 = japi.GAME_OPTION_SKIRMISH_V0,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_SKIRMISH_V1 = japi.GAME_OPTION_SKIRMISH_V1,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_LAN_V0 = japi.GAME_OPTION_LAN_V0,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_LAN_V1 = japi.GAME_OPTION_LAN_V1,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_BATTLENET_V0 = japi.GAME_OPTION_BATTLENET_V0,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_BATTLENET_V1 = japi.GAME_OPTION_BATTLENET_V1,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_SEEN_INTRO_MOVIE = japi.GAME_OPTION_SEEN_INTRO_MOVIE,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_CAMPAIGN_PRIFILE = japi.GAME_OPTION_CAMPAIGN_PRIFILE,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_CHECKED_TOURN = japi.GAME_OPTION_CHECKED_TOURN,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_CHECKED_LAN = japi.GAME_OPTION_CHECKED_LAN,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_CHECKED_LADDER = japi.GAME_OPTION_CHECKED_LADDER,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_CHECKED_AD = japi.GAME_OPTION_CHECKED_AD,
    ---@type GAME_OPTION
    ---游戏设置: 未知<br>
    ---来源: MemHack
    GAME_OPTION_CHAT_SUPPORT = japi.GAME_OPTION_CHAT_SUPPORT,



    --@alias HASHTABLE_CHANGE integer

    ---@type HASHTABLE_CHANGE
    ---变动的哈希项类型: 整数哈希项<br>
    ---来源: MemHack
    HASHTABLE_CHANGE_INT = japi.HASHTABLE_CHANGE_INT,
    ---@type HASHTABLE_CHANGE
    ---变动的哈希项类型: 实数哈希项<br>
    ---来源: MemHack
    HASHTABLE_CHANGE_REAL = japi.HASHTABLE_CHANGE_REAL,
    ---@type HASHTABLE_CHANGE
    ---变动的哈希项类型: 布尔值哈希项<br>
    ---来源: MemHack
    HASHTABLE_CHANGE_BOOL = japi.HASHTABLE_CHANGE_BOOL,
    ---@type HASHTABLE_CHANGE
    ---变动的哈希项类型: 字符串哈希项<br>
    ---来源: MemHack
    HASHTABLE_CHANGE_STR = japi.HASHTABLE_CHANGE_STR,



    --@alias HERO_ATTR integer

    ---@type HERO_ATTR
    ---英雄属性: 力量<br>
    ---来源: MemHack
    HERO_ATTR_STR = japi.HERO_ATTR_STR,
    ---@type HERO_ATTR
    ---英雄属性: 智力<br>
    ---来源: MemHack
    HERO_ATTR_INT = japi.HERO_ATTR_INT,
    ---@type HERO_ATTR
    ---英雄属性: 敏捷<br>
    ---来源: MemHack
    HERO_ATTR_AGI = japi.HERO_ATTR_AGI,



    --@alias HTTP_ERROR integer

    ---@type HTTP_ERROR
    ---http错误码: 成功 (无错误)<br>
    ---来源: MemHack
    HTTP_ERROR_SUCCESS = japi.HTTP_ERROR_SUCCESS,
    ---@type HTTP_ERROR
    ---http错误码: 未知错误<br>
    ---来源: MemHack
    HTTP_ERROR_UNKNOWN = japi.HTTP_ERROR_UNKNOWN,
    ---@type HTTP_ERROR
    ---http错误码: 连接失败<br>
    ---来源: MemHack
    HTTP_ERROR_CONNECTION = japi.HTTP_ERROR_CONNECTION,
    ---@type HTTP_ERROR
    ---http错误码: 绑定IP地址失败<br>
    ---来源: MemHack
    HTTP_ERROR_BINDIPADDRESS = japi.HTTP_ERROR_BINDIPADDRESS,
    ---@type HTTP_ERROR
    ---http错误码: 读取数据失败<br>
    ---来源: MemHack
    HTTP_ERROR_READ = japi.HTTP_ERROR_READ,
    ---@type HTTP_ERROR
    ---http错误码: 写入数据失败<br>
    ---来源: MemHack
    HTTP_ERROR_WRITE = japi.HTTP_ERROR_WRITE,
    ---@type HTTP_ERROR
    ---http错误码: 超出最大重定向次数限制<br>
    ---来源: MemHack
    HTTP_ERROR_EXCEEDREDIRECTCOUNT = japi.HTTP_ERROR_EXCEEDREDIRECTCOUNT,
    ---@type HTTP_ERROR
    ---http错误码: 请求被取消<br>
    ---来源: MemHack
    HTTP_ERROR_CANCELED = japi.HTTP_ERROR_CANCELED,
    ---@type HTTP_ERROR
    ---http错误码: 建立SSL连接失败<br>
    ---来源: MemHack
    HTTP_ERROR_SSLCONNECTION = japi.HTTP_ERROR_SSLCONNECTION,
    ---@type HTTP_ERROR
    ---http错误码: 客户端SSL证书加载失败<br>
    ---来源: MemHack
    HTTP_ERROR_SSLLOADINGCERTS = japi.HTTP_ERROR_SSLLOADINGCERTS,
    ---@type HTTP_ERROR
    ---http错误码: 服务端SSL证书校验失败<br>
    ---来源: MemHack
    HTTP_ERROR_SSLSERVERVERIFICATION = japi.HTTP_ERROR_SSLSERVERVERIFICATION,
    ---@type HTTP_ERROR
    ---http错误码: 主机名校验失败<br>
    ---来源: MemHack
    HTTP_ERROR_SSLSERVERHOSTNAMEVERIFICATION = japi.HTTP_ERROR_SSLSERVERHOSTNAMEVERIFICATION,
    ---@type HTTP_ERROR
    ---http错误码: 不支持的Multipart边界字符<br>
    ---来源: MemHack
    HTTP_ERROR_UNSUPPORTEDMULTIPARTBOUNDARYCHARS = japi.HTTP_ERROR_UNSUPPORTEDMULTIPARTBOUNDARYCHARS,
    ---@type HTTP_ERROR
    ---http错误码: 数据压缩/解压失败<br>
    ---来源: MemHack
    HTTP_ERROR_COMPRESSION = japi.HTTP_ERROR_COMPRESSION,
    ---@type HTTP_ERROR
    ---http错误码: 连接超时<br>
    ---来源: MemHack
    HTTP_ERROR_CONNECTIONTIMEOUT = japi.HTTP_ERROR_CONNECTIONTIMEOUT,
    ---@type HTTP_ERROR
    ---http错误码: 代理服务器连接失败<br>
    ---来源: MemHack
    HTTP_ERROR_PROXYCONNECTION = japi.HTTP_ERROR_PROXYCONNECTION,



    --@alias INDICATOR_TYPE integer

    ---@type INDICATOR_TYPE
    ---指示器类型: 指示器<br>
    ---来源: MemHack
    INDICATOR_TYPE_TARGET_MODE = japi.INDICATOR_TYPE_TARGET_MODE,
    ---@type INDICATOR_TYPE
    ---指示器类型: 选择器<br>
    ---来源: MemHack
    INDICATOR_TYPE_SELECT_MODE = japi.INDICATOR_TYPE_SELECT_MODE,
    ---@type INDICATOR_TYPE
    ---指示器类型: 框选<br>
    ---来源: MemHack
    INDICATOR_TYPE_DRAG_SELECT_MODE = japi.INDICATOR_TYPE_DRAG_SELECT_MODE,
    ---@type INDICATOR_TYPE
    ---指示器类型: 镜头拖动<br>
    ---来源: MemHack
    INDICATOR_TYPE_DRAG_SCROLL_MODE = japi.INDICATOR_TYPE_DRAG_SCROLL_MODE,
    ---@type INDICATOR_TYPE
    ---指示器类型: 建造指示器<br>
    ---来源: MemHack
    INDICATOR_TYPE_BUILD_MODE = japi.INDICATOR_TYPE_BUILD_MODE,
    ---@type INDICATOR_TYPE
    ---指示器类型: 信号指示器<br>
    ---来源: MemHack
    INDICATOR_TYPE_SIGNAL_MODE = japi.INDICATOR_TYPE_SIGNAL_MODE,
    ---@type INDICATOR_TYPE
    ---指示器类型: 任意<br>
    ---来源: MemHack
    INDICATOR_TYPE_ANY = japi.INDICATOR_TYPE_ANY,



    --@alias ITEM_DEF_DATA integer

    ---@type ITEM_DEF_DATA
    ---物品物编数据 (整数): 基础ID<br>
    ---来源: MemHack
    ITEM_DEF_DATA_BASE_ID = japi.ITEM_DEF_DATA_BASE_ID,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (整数): 黄金消耗<br>
    ---来源: MemHack
    ITEM_DEF_DATA_GOLD_COST = japi.ITEM_DEF_DATA_GOLD_COST,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (整数): 木材消耗<br>
    ---来源: MemHack
    ITEM_DEF_DATA_LUMBER_COST = japi.ITEM_DEF_DATA_LUMBER_COST,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (整数): 最大库存量<br>
    ---来源: MemHack
    ITEM_DEF_DATA_STOCK_MAX = japi.ITEM_DEF_DATA_STOCK_MAX,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (整数): 等级<br>
    ---来源: MemHack
    ITEM_DEF_DATA_LEVEL = japi.ITEM_DEF_DATA_LEVEL,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (整数): 分类<br>
    ---来源: MemHack
    ITEM_DEF_DATA_CLASS = japi.ITEM_DEF_DATA_CLASS,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (整数): 使用次数<br>
    ---来源: MemHack
    ITEM_DEF_DATA_USES = japi.ITEM_DEF_DATA_USES,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (整数): CD间隔组<br>
    ---来源: MemHack
    ITEM_DEF_DATA_COOLDOWN_ID = japi.ITEM_DEF_DATA_COOLDOWN_ID,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (整数): 热键<br>
    ---来源: MemHack
    ITEM_DEF_DATA_HOTKEY = japi.ITEM_DEF_DATA_HOTKEY,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (布尔值): 有效的物品转换目标<br>
    ---来源: MemHack
    ITEM_DEF_DATA_MORPH = japi.ITEM_DEF_DATA_MORPH,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (布尔值): 可作为随机物品<br>
    ---来源: MemHack
    ITEM_DEF_DATA_PICK_RANDOM = japi.ITEM_DEF_DATA_PICK_RANDOM,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (布尔值): 捡取时使用<br>
    ---来源: MemHack
    ITEM_DEF_DATA_USE_ON_PICKUP = japi.ITEM_DEF_DATA_USE_ON_PICKUP,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (布尔值): 可被市场出售<br>
    ---来源: MemHack
    ITEM_DEF_DATA_SELLABLE = japi.ITEM_DEF_DATA_SELLABLE,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (布尔值): 可以被抵押<br>
    ---来源: MemHack
    ITEM_DEF_DATA_PAWNABLE = japi.ITEM_DEF_DATA_PAWNABLE,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (布尔值): 主动使用<br>
    ---来源: MemHack
    ITEM_DEF_DATA_USABLE = japi.ITEM_DEF_DATA_USABLE,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (布尔值): 使用完消失<br>
    ---来源: MemHack
    ITEM_DEF_DATA_PERISHABLE = japi.ITEM_DEF_DATA_PERISHABLE,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (布尔值): 可以丢弃<br>
    ---来源: MemHack
    ITEM_DEF_DATA_DROPPABLE = japi.ITEM_DEF_DATA_DROPPABLE,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (布尔值): 死亡时掉落<br>
    ---来源: MemHack
    ITEM_DEF_DATA_DROP_ON_DEATH = japi.ITEM_DEF_DATA_DROP_ON_DEATH,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (布尔值): 无视CD间隔<br>
    ---来源: MemHack
    ITEM_DEF_DATA_IGNORE_CD = japi.ITEM_DEF_DATA_IGNORE_CD,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (字符串): 技能列表<br>
    ---多个技能用逗号隔开<br>
    ---来源: MemHack
    ITEM_DEF_DATA_ABIL_LIST = japi.ITEM_DEF_DATA_ABIL_LIST,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (字符串): 名字<br>
    ---来源: MemHack
    ITEM_DEF_DATA_NAME = japi.ITEM_DEF_DATA_NAME,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (字符串): 图标<br>
    ---来源: MemHack
    ITEM_DEF_DATA_ART = japi.ITEM_DEF_DATA_ART,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (字符串): 提示工具<br>
    ---来源: MemHack
    ITEM_DEF_DATA_TIP = japi.ITEM_DEF_DATA_TIP,
    ---@type ITEM_DEF_DATA
    ---物品物编数据 (字符串): 提示工具 - 扩展<br>
    ---来源: MemHack
    ITEM_DEF_DATA_UBERTIP = japi.ITEM_DEF_DATA_UBERTIP,



    --@alias LAYER_STYLE integer

    ---@type LAYER_STYLE
    ---layer标志: 视口<br>
    ---打开后子frame超出该frame的部分不会渲染<br>
    ---来源: MemHack
    LAYER_STYLE_VIEW_PORT = japi.LAYER_STYLE_VIEW_PORT,
    ---@type LAYER_STYLE
    ---忽略追踪事件<br>
    ---打开后不会触发事件, 鼠标也可穿透该frame<br>
    ---来源: MemHack
    LAYER_STYLE_IGNORE_TRACK_EVENT = japi.LAYER_STYLE_IGNORE_TRACK_EVENT,



    --@alias LAYOUT_LAYER integer

    ---@type LAYOUT_LAYER
    ---layout渲染层级: 背景<br>
    ---来源: MemHack
    LAYOUT_LAYER_BACKGROUND = japi.LAYOUT_LAYER_BACKGROUND,
    ---@type LAYOUT_LAYER
    ---layout渲染层级: 边框<br>
    ---来源: MemHack
    LAYOUT_LAYER_CASE = japi.LAYOUT_LAYER_CASE,
    ---@type LAYOUT_LAYER
    ---layout渲染层级: 图像<br>
    ---来源: MemHack
    LAYOUT_LAYER_ARTWORK = japi.LAYOUT_LAYER_ARTWORK,
    ---@type LAYOUT_LAYER
    ---layout渲染层级: 图像背景<br>
    ---来源: MemHack
    LAYOUT_LAYER_ARTWORK_OVERLAY = japi.LAYOUT_LAYER_ARTWORK_OVERLAY,



    --@alias LOCAL_ORDER_FLAG integer

    ---@type LOCAL_ORDER_FLAG
    ---本地命令标志: 正常<br>
    ---来源: MemHack
    LOCAL_ORDER_FLAG_NORMAL = japi.LOCAL_ORDER_FLAG_NORMAL,
    ---@type LOCAL_ORDER_FLAG
    ---本地命令标志: 队列<br>
    ---来源: MemHack
    LOCAL_ORDER_FLAG_QUEUE = japi.LOCAL_ORDER_FLAG_QUEUE,
    ---@type LOCAL_ORDER_FLAG
    ---本地命令标志: 立即<br>
    ---来源: MemHack
    LOCAL_ORDER_FLAG_INSTANT = japi.LOCAL_ORDER_FLAG_INSTANT,
    ---@type LOCAL_ORDER_FLAG
    ---本地命令标志: 单独释放<br>
    ---来源: MemHack
    LOCAL_ORDER_FLAG_ALONE = japi.LOCAL_ORDER_FLAG_ALONE,
    ---@type LOCAL_ORDER_FLAG
    ---本地命令标志: 物品命令<br>
    ---来源: MemHack
    LOCAL_ORDER_FLAG_ITEM = japi.LOCAL_ORDER_FLAG_ITEM,
    ---@type LOCAL_ORDER_FLAG
    ---本地命令标志: 命令恢复<br>
    ---来源: MemHack
    LOCAL_ORDER_FLAG_RESTORE = japi.LOCAL_ORDER_FLAG_RESTORE,
}

do
    local japi = japi
    local _ENV = Constant

    --@alias MEMHACK_VK integer

    ---@type MEMHACK_VK
    ---鼠标左键<br>
    ---来源: MemHack
    MEMHACK_VK_LBUTTON = japi.MEMHACK_VK_LBUTTON
    ---@type MEMHACK_VK
    ---鼠标右键<br>
    ---来源: MemHack
    MEMHACK_VK_RBUTTON = japi.MEMHACK_VK_RBUTTON
    ---@type MEMHACK_VK
    ---控制中断处理<br>
    ---来源: MemHack
    MEMHACK_VK_CANCEL = japi.MEMHACK_VK_CANCEL
    ---@type MEMHACK_VK
    ---鼠标中间按钮<br>
    ---来源: MemHack
    MEMHACK_VK_MBUTTON = japi.MEMHACK_VK_MBUTTON
    ---@type MEMHACK_VK
    ---X1 鼠标按钮<br>
    ---来源: MemHack
    MEMHACK_VK_XBUTTON1 = japi.MEMHACK_VK_XBUTTON1
    ---@type MEMHACK_VK
    ---X2 鼠标按钮<br>
    ---来源: MemHack
    MEMHACK_VK_XBUTTON2 = japi.MEMHACK_VK_XBUTTON2
    ---@type MEMHACK_VK
    ---Backspace 键<br>
    ---来源: MemHack
    MEMHACK_VK_BACK = japi.MEMHACK_VK_BACK
    ---@type MEMHACK_VK
    ---Tab 键<br>
    ---来源: MemHack
    MEMHACK_VK_TAB = japi.MEMHACK_VK_TAB
    ---@type MEMHACK_VK
    ---清除键<br>
    ---来源: MemHack
    MEMHACK_VK_CLEAR = japi.MEMHACK_VK_CLEAR
    ---@type MEMHACK_VK
    ---输入键<br>
    ---来源: MemHack
    MEMHACK_VK_RETURN = japi.MEMHACK_VK_RETURN
    ---@type MEMHACK_VK
    ---换档键<br>
    ---来源: MemHack
    MEMHACK_VK_SHIFT = japi.MEMHACK_VK_SHIFT
    ---@type MEMHACK_VK
    ---Ctrl 键<br>
    ---来源: MemHack
    MEMHACK_VK_CONTROL = japi.MEMHACK_VK_CONTROL
    ---@type MEMHACK_VK
    ---Alt 键<br>
    ---来源: MemHack
    MEMHACK_VK_MENU = japi.MEMHACK_VK_MENU
    ---@type MEMHACK_VK
    ---暂停键<br>
    ---来源: MemHack
    MEMHACK_VK_PAUSE = japi.MEMHACK_VK_PAUSE
    ---@type MEMHACK_VK
    ---Caps lock 键<br>
    ---来源: MemHack
    MEMHACK_VK_CAPITAL = japi.MEMHACK_VK_CAPITAL
    ---@type MEMHACK_VK
    ---IME 假名模式<br>
    ---来源: MemHack
    MEMHACK_VK_KANA = japi.MEMHACK_VK_KANA
    ---@type MEMHACK_VK
    ---IME 朝鲜文模式<br>
    ---与 VK_KANA 值相同<br>
    ---来源: MemHack
    MEMHACK_VK_HANGUL = japi.MEMHACK_VK_HANGUL
    ---@type MEMHACK_VK
    ---IME On<br>
    ---来源: MemHack
    MEMHACK_VK_IME_ON = japi.MEMHACK_VK_IME_ON
    ---@type MEMHACK_VK
    ---IME Junja 模式<br>
    ---来源: MemHack
    MEMHACK_VK_JUNJA = japi.MEMHACK_VK_JUNJA
    ---@type MEMHACK_VK
    ---IME 最终模式<br>
    ---来源: MemHack
    MEMHACK_VK_FINAL = japi.MEMHACK_VK_FINAL
    ---@type MEMHACK_VK
    ---IME Hanja 模式<br>
    ---来源: MemHack
    MEMHACK_VK_HANJA = japi.MEMHACK_VK_HANJA
    ---@type MEMHACK_VK
    ---IME 汉字模式<br>
    ---与 VK_HANJA 值相同<br>
    ---来源: MemHack
    MEMHACK_VK_KANJI = japi.MEMHACK_VK_KANJI
    ---@type MEMHACK_VK
    ---IME 关闭<br>
    ---来源: MemHack
    MEMHACK_VK_IME_OFF = japi.MEMHACK_VK_IME_OFF
    ---@type MEMHACK_VK
    ---Esc 键<br>
    ---来源: MemHack
    MEMHACK_VK_ESCAPE = japi.MEMHACK_VK_ESCAPE
    ---@type MEMHACK_VK
    ---IME 转换<br>
    ---来源: MemHack
    MEMHACK_VK_CONVERT = japi.MEMHACK_VK_CONVERT
    ---@type MEMHACK_VK
    ---IME 非转换<br>
    ---来源: MemHack
    MEMHACK_VK_NONCONVERT = japi.MEMHACK_VK_NONCONVERT
    ---@type MEMHACK_VK
    ---IME 接受<br>
    ---来源: MemHack
    MEMHACK_VK_ACCEPT = japi.MEMHACK_VK_ACCEPT
    ---@type MEMHACK_VK
    ---IME 模式更改请求<br>
    ---来源: MemHack
    MEMHACK_VK_MODECHANGE = japi.MEMHACK_VK_MODECHANGE
    ---@type MEMHACK_VK
    ---空格键<br>
    ---来源: MemHack
    MEMHACK_VK_SPACE = japi.MEMHACK_VK_SPACE
    ---@type MEMHACK_VK
    ---Page up 键<br>
    ---来源: MemHack
    MEMHACK_VK_PRIOR = japi.MEMHACK_VK_PRIOR
    ---@type MEMHACK_VK
    ---Page down 键<br>
    ---来源: MemHack
    MEMHACK_VK_NEXT = japi.MEMHACK_VK_NEXT
    ---@type MEMHACK_VK
    ---结束键<br>
    ---来源: MemHack
    MEMHACK_VK_END = japi.MEMHACK_VK_END
    ---@type MEMHACK_VK
    ---主键<br>
    ---来源: MemHack
    MEMHACK_VK_HOME = japi.MEMHACK_VK_HOME
    ---@type MEMHACK_VK
    ---向左键<br>
    ---来源: MemHack
    MEMHACK_VK_LEFT = japi.MEMHACK_VK_LEFT
    ---@type MEMHACK_VK
    ---向上键<br>
    ---来源: MemHack
    MEMHACK_VK_UP = japi.MEMHACK_VK_UP
    ---@type MEMHACK_VK
    ---向右键<br>
    ---来源: MemHack
    MEMHACK_VK_RIGHT = japi.MEMHACK_VK_RIGHT
    ---@type MEMHACK_VK
    ---向下键<br>
    ---来源: MemHack
    MEMHACK_VK_DOWN = japi.MEMHACK_VK_DOWN
    ---@type MEMHACK_VK
    ---选择密钥<br>
    ---来源: MemHack
    MEMHACK_VK_SELECT = japi.MEMHACK_VK_SELECT
    ---@type MEMHACK_VK
    ---打印键<br>
    ---来源: MemHack
    MEMHACK_VK_PRINT = japi.MEMHACK_VK_PRINT
    ---@type MEMHACK_VK
    ---执行键<br>
    ---来源: MemHack
    MEMHACK_VK_EXECUTE = japi.MEMHACK_VK_EXECUTE
    ---@type MEMHACK_VK
    ---打印屏幕键<br>
    ---来源: MemHack
    MEMHACK_VK_SNAPSHOT = japi.MEMHACK_VK_SNAPSHOT
    ---@type MEMHACK_VK
    ---插入键<br>
    ---来源: MemHack
    MEMHACK_VK_INSERT = japi.MEMHACK_VK_INSERT
    ---@type MEMHACK_VK
    ---删除密钥<br>
    ---来源: MemHack
    MEMHACK_VK_DELETE = japi.MEMHACK_VK_DELETE
    ---@type MEMHACK_VK
    ---帮助密钥<br>
    ---来源: MemHack
    MEMHACK_VK_HELP = japi.MEMHACK_VK_HELP
    ---@type MEMHACK_VK
    ---0 键 ('0')<br>
    ---来源: MemHack
    MEMHACK_VK_0 = japi.MEMHACK_VK_0
    ---@type MEMHACK_VK
    ---1 键 ('1')<br>
    ---来源: MemHack
    MEMHACK_VK_1 = japi.MEMHACK_VK_1
    ---@type MEMHACK_VK
    ---2 键 ('2')<br>
    ---来源: MemHack
    MEMHACK_VK_2 = japi.MEMHACK_VK_2
    ---@type MEMHACK_VK
    ---3 键 ('3')<br>
    ---来源: MemHack
    MEMHACK_VK_3 = japi.MEMHACK_VK_3
    ---@type MEMHACK_VK
    ---4 键 ('4')<br>
    ---来源: MemHack
    MEMHACK_VK_4 = japi.MEMHACK_VK_4
    ---@type MEMHACK_VK
    ---5 键 ('5')<br>
    ---来源: MemHack
    MEMHACK_VK_5 = japi.MEMHACK_VK_5
    ---@type MEMHACK_VK
    ---6 键 ('6')<br>
    ---来源: MemHack
    MEMHACK_VK_6 = japi.MEMHACK_VK_6
    ---@type MEMHACK_VK
    ---7 键 ('7')<br>
    ---来源: MemHack
    MEMHACK_VK_7 = japi.MEMHACK_VK_7
    ---@type MEMHACK_VK
    ---8 键 ('8')<br>
    ---来源: MemHack
    MEMHACK_VK_8 = japi.MEMHACK_VK_8
    ---@type MEMHACK_VK
    ---9 键 ('9')<br>
    ---来源: MemHack
    MEMHACK_VK_9 = japi.MEMHACK_VK_9
    ---@type MEMHACK_VK
    ---A 键 ('A')<br>
    ---来源: MemHack
    MEMHACK_VK_A = japi.MEMHACK_VK_A
    ---@type MEMHACK_VK
    ---B 键 ('B')<br>
    ---来源: MemHack
    MEMHACK_VK_B = japi.MEMHACK_VK_B
    ---@type MEMHACK_VK
    ---C 键 ('C')<br>
    ---来源: MemHack
    MEMHACK_VK_C = japi.MEMHACK_VK_C
    ---@type MEMHACK_VK
    ---D 键 ('D')<br>
    ---来源: MemHack
    MEMHACK_VK_D = japi.MEMHACK_VK_D
    ---@type MEMHACK_VK
    ---E 键 ('E')<br>
    ---来源: MemHack
    MEMHACK_VK_E = japi.MEMHACK_VK_E
    ---@type MEMHACK_VK
    ---F 键 ('F')<br>
    ---来源: MemHack
    MEMHACK_VK_F = japi.MEMHACK_VK_F
    ---@type MEMHACK_VK
    ---G 键 ('G')<br>
    ---来源: MemHack
    MEMHACK_VK_G = japi.MEMHACK_VK_G
    ---@type MEMHACK_VK
    ---H 键 ('H')<br>
    ---来源: MemHack
    MEMHACK_VK_H = japi.MEMHACK_VK_H
    ---@type MEMHACK_VK
    ---I 键 ('I')<br>
    ---来源: MemHack
    MEMHACK_VK_I = japi.MEMHACK_VK_I
    ---@type MEMHACK_VK
    ---J 键 ('J')<br>
    ---来源: MemHack
    MEMHACK_VK_J = japi.MEMHACK_VK_J
    ---@type MEMHACK_VK
    ---K 键 ('K')<br>
    ---来源: MemHack
    MEMHACK_VK_K = japi.MEMHACK_VK_K
    ---@type MEMHACK_VK
    ---L 键 ('L')<br>
    ---来源: MemHack
    MEMHACK_VK_L = japi.MEMHACK_VK_L
    ---@type MEMHACK_VK
    ---M 键 ('M')<br>
    ---来源: MemHack
    MEMHACK_VK_M = japi.MEMHACK_VK_M
    ---@type MEMHACK_VK
    ---N 键 ('N')<br>
    ---来源: MemHack
    MEMHACK_VK_N = japi.MEMHACK_VK_N
    ---@type MEMHACK_VK
    ---O 键 ('O')<br>
    ---来源: MemHack
    MEMHACK_VK_O = japi.MEMHACK_VK_O
    ---@type MEMHACK_VK
    ---P 键 ('P')<br>
    ---来源: MemHack
    MEMHACK_VK_P = japi.MEMHACK_VK_P
    ---@type MEMHACK_VK
    ---Q 键 ('Q')<br>
    ---来源: MemHack
    MEMHACK_VK_Q = japi.MEMHACK_VK_Q
    ---@type MEMHACK_VK
    ---R 键 ('R')<br>
    ---来源: MemHack
    MEMHACK_VK_R = japi.MEMHACK_VK_R
    ---@type MEMHACK_VK
    ---S 键 ('S')<br>
    ---来源: MemHack
    MEMHACK_VK_S = japi.MEMHACK_VK_S
    ---@type MEMHACK_VK
    ---T 键 ('T')<br>
    ---来源: MemHack
    MEMHACK_VK_T = japi.MEMHACK_VK_T
    ---@type MEMHACK_VK
    ---U 键 ('U')<br>
    ---来源: MemHack
    MEMHACK_VK_U = japi.MEMHACK_VK_U
    ---@type MEMHACK_VK
    ---V 键 ('V')<br>
    ---来源: MemHack
    MEMHACK_VK_V = japi.MEMHACK_VK_V
    ---@type MEMHACK_VK
    ---W 键 ('W')<br>
    ---来源: MemHack
    MEMHACK_VK_W = japi.MEMHACK_VK_W
    ---@type MEMHACK_VK
    ---X 键 ('X')<br>
    ---来源: MemHack
    MEMHACK_VK_X = japi.MEMHACK_VK_X
    ---@type MEMHACK_VK
    ---Y 键 ('Y')<br>
    ---来源: MemHack
    MEMHACK_VK_Y = japi.MEMHACK_VK_Y
    ---@type MEMHACK_VK
    ---Z 键 ('Z')<br>
    ---来源: MemHack
    MEMHACK_VK_Z = japi.MEMHACK_VK_Z
    ---@type MEMHACK_VK
    ---左 Windows 徽标键<br>
    ---来源: MemHack
    MEMHACK_VK_LWIN = japi.MEMHACK_VK_LWIN
    ---@type MEMHACK_VK
    ---右 Windows 徽标键<br>
    ---来源: MemHack
    MEMHACK_VK_RWIN = japi.MEMHACK_VK_RWIN
    ---@type MEMHACK_VK
    ---应用程序密钥<br>
    ---来源: MemHack
    MEMHACK_VK_APPS = japi.MEMHACK_VK_APPS
    ---@type MEMHACK_VK
    ---0x5E 保留<br>
    ---计算机睡眠键<br>
    ---来源: MemHack
    MEMHACK_VK_SLEEP = japi.MEMHACK_VK_SLEEP
    ---@type MEMHACK_VK
    ---数字键盘 0 键<br>
    ---来源: MemHack
    MEMHACK_VK_NUMPAD0 = japi.MEMHACK_VK_NUMPAD0
    ---@type MEMHACK_VK
    ---数字键盘 1 键<br>
    ---来源: MemHack
    MEMHACK_VK_NUMPAD1 = japi.MEMHACK_VK_NUMPAD1
    ---@type MEMHACK_VK
    ---数字键盘 2 键<br>
    ---来源: MemHack
    MEMHACK_VK_NUMPAD2 = japi.MEMHACK_VK_NUMPAD2
    ---@type MEMHACK_VK
    ---数字键盘 3 键<br>
    ---来源: MemHack
    MEMHACK_VK_NUMPAD3 = japi.MEMHACK_VK_NUMPAD3
    ---@type MEMHACK_VK
    ---数字键盘 4 键<br>
    ---来源: MemHack
    MEMHACK_VK_NUMPAD4 = japi.MEMHACK_VK_NUMPAD4
    ---@type MEMHACK_VK
    ---数字键盘 5 键<br>
    ---来源: MemHack
    MEMHACK_VK_NUMPAD5 = japi.MEMHACK_VK_NUMPAD5
    ---@type MEMHACK_VK
    ---数字键盘 6 键<br>
    ---来源: MemHack
    MEMHACK_VK_NUMPAD6 = japi.MEMHACK_VK_NUMPAD6
    ---@type MEMHACK_VK
    ---数字键盘 7 键<br>
    ---来源: MemHack
    MEMHACK_VK_NUMPAD7 = japi.MEMHACK_VK_NUMPAD7
    ---@type MEMHACK_VK
    ---数字键盘 8 键<br>
    ---来源: MemHack
    MEMHACK_VK_NUMPAD8 = japi.MEMHACK_VK_NUMPAD8
    ---@type MEMHACK_VK
    ---数字键盘 9 键<br>
    ---来源: MemHack
    MEMHACK_VK_NUMPAD9 = japi.MEMHACK_VK_NUMPAD9
    ---@type MEMHACK_VK
    ---相乘键<br>
    ---来源: MemHack
    MEMHACK_VK_MULTIPLY = japi.MEMHACK_VK_MULTIPLY
    ---@type MEMHACK_VK
    ---添加密钥<br>
    ---来源: MemHack
    MEMHACK_VK_ADD = japi.MEMHACK_VK_ADD
    ---@type MEMHACK_VK
    ---分隔符键<br>
    ---来源: MemHack
    MEMHACK_VK_SEPARATOR = japi.MEMHACK_VK_SEPARATOR
    ---@type MEMHACK_VK
    ---减去键<br>
    ---来源: MemHack
    MEMHACK_VK_SUBTRACT = japi.MEMHACK_VK_SUBTRACT
    ---@type MEMHACK_VK
    ---十进制键<br>
    ---来源: MemHack
    MEMHACK_VK_DECIMAL = japi.MEMHACK_VK_DECIMAL
    ---@type MEMHACK_VK
    ---除键<br>
    ---来源: MemHack
    MEMHACK_VK_DIVIDE = japi.MEMHACK_VK_DIVIDE
    ---@type MEMHACK_VK
    ---F1 键<br>
    ---来源: MemHack
    MEMHACK_VK_F1 = japi.MEMHACK_VK_F1
    ---@type MEMHACK_VK
    ---F2 键<br>
    ---来源: MemHack
    MEMHACK_VK_F2 = japi.MEMHACK_VK_F2
    ---@type MEMHACK_VK
    ---F3 键<br>
    ---来源: MemHack
    MEMHACK_VK_F3 = japi.MEMHACK_VK_F3
    ---@type MEMHACK_VK
    ---F4 键<br>
    ---来源: MemHack
    MEMHACK_VK_F4 = japi.MEMHACK_VK_F4
    ---@type MEMHACK_VK
    ---F5 键<br>
    ---来源: MemHack
    MEMHACK_VK_F5 = japi.MEMHACK_VK_F5
    ---@type MEMHACK_VK
    ---F6 键<br>
    ---来源: MemHack
    MEMHACK_VK_F6 = japi.MEMHACK_VK_F6
    ---@type MEMHACK_VK
    ---F7 键<br>
    ---来源: MemHack
    MEMHACK_VK_F7 = japi.MEMHACK_VK_F7
    ---@type MEMHACK_VK
    ---F8 键<br>
    ---来源: MemHack
    MEMHACK_VK_F8 = japi.MEMHACK_VK_F8
    ---@type MEMHACK_VK
    ---F9 键<br>
    ---来源: MemHack
    MEMHACK_VK_F9 = japi.MEMHACK_VK_F9
    ---@type MEMHACK_VK
    ---F10 键<br>
    ---来源: MemHack
    MEMHACK_VK_F10 = japi.MEMHACK_VK_F10
    ---@type MEMHACK_VK
    ---F11 键<br>
    ---来源: MemHack
    MEMHACK_VK_F11 = japi.MEMHACK_VK_F11
    ---@type MEMHACK_VK
    ---F12 键<br>
    ---来源: MemHack
    MEMHACK_VK_F12 = japi.MEMHACK_VK_F12
    ---@type MEMHACK_VK
    ---F13 键<br>
    ---来源: MemHack
    MEMHACK_VK_F13 = japi.MEMHACK_VK_F13
    ---@type MEMHACK_VK
    ---F14 键<br>
    ---来源: MemHack
    MEMHACK_VK_F14 = japi.MEMHACK_VK_F14
    ---@type MEMHACK_VK
    ---F15 键<br>
    ---来源: MemHack
    MEMHACK_VK_F15 = japi.MEMHACK_VK_F15
    ---@type MEMHACK_VK
    ---F16 键<br>
    ---来源: MemHack
    MEMHACK_VK_F16 = japi.MEMHACK_VK_F16
    ---@type MEMHACK_VK
    ---F17 键<br>
    ---来源: MemHack
    MEMHACK_VK_F17 = japi.MEMHACK_VK_F17
    ---@type MEMHACK_VK
    ---F18 键<br>
    ---来源: MemHack
    MEMHACK_VK_F18 = japi.MEMHACK_VK_F18
    ---@type MEMHACK_VK
    ---F19 键<br>
    ---来源: MemHack
    MEMHACK_VK_F19 = japi.MEMHACK_VK_F19
    ---@type MEMHACK_VK
    ---F20 键<br>
    ---来源: MemHack
    MEMHACK_VK_F20 = japi.MEMHACK_VK_F20
    ---@type MEMHACK_VK
    ---F21 键<br>
    ---来源: MemHack
    MEMHACK_VK_F21 = japi.MEMHACK_VK_F21
    ---@type MEMHACK_VK
    ---F22 键<br>
    ---来源: MemHack
    MEMHACK_VK_F22 = japi.MEMHACK_VK_F22
    ---@type MEMHACK_VK
    ---F23 键<br>
    ---来源: MemHack
    MEMHACK_VK_F23 = japi.MEMHACK_VK_F23
    ---@type MEMHACK_VK
    ---F24 键<br>
    ---来源: MemHack
    MEMHACK_VK_F24 = japi.MEMHACK_VK_F24
    ---@type MEMHACK_VK
    ---Num lock 键<br>
    ---来源: MemHack
    MEMHACK_VK_NUMLOCK = japi.MEMHACK_VK_NUMLOCK
    ---@type MEMHACK_VK
    ---滚动锁键<br>
    ---来源: MemHack
    MEMHACK_VK_SCROLL = japi.MEMHACK_VK_SCROLL
    ---@type MEMHACK_VK
    ---左移键<br>
    ---来源: MemHack
    MEMHACK_VK_LSHIFT = japi.MEMHACK_VK_LSHIFT
    ---@type MEMHACK_VK
    ---右移键<br>
    ---来源: MemHack
    MEMHACK_VK_RSHIFT = japi.MEMHACK_VK_RSHIFT
    ---@type MEMHACK_VK
    ---左 Ctrl 键<br>
    ---来源: MemHack
    MEMHACK_VK_LCONTROL = japi.MEMHACK_VK_LCONTROL
    ---@type MEMHACK_VK
    ---右 Ctrl 键<br>
    ---来源: MemHack
    MEMHACK_VK_RCONTROL = japi.MEMHACK_VK_RCONTROL
    ---@type MEMHACK_VK
    ---左 Alt 键<br>
    ---来源: MemHack
    MEMHACK_VK_LMENU = japi.MEMHACK_VK_LMENU
    ---@type MEMHACK_VK
    ---右 Alt 键<br>
    ---来源: MemHack
    MEMHACK_VK_RMENU = japi.MEMHACK_VK_RMENU
    ---@type MEMHACK_VK
    ---浏览器后退键<br>
    ---来源: MemHack
    MEMHACK_VK_BROWSER_BACK = japi.MEMHACK_VK_BROWSER_BACK
    ---@type MEMHACK_VK
    ---浏览器转发密钥<br>
    ---来源: MemHack
    MEMHACK_VK_BROWSER_FORWARD = japi.MEMHACK_VK_BROWSER_FORWARD
    ---@type MEMHACK_VK
    ---浏览器刷新密钥<br>
    ---来源: MemHack
    MEMHACK_VK_BROWSER_REFRESH = japi.MEMHACK_VK_BROWSER_REFRESH
    ---@type MEMHACK_VK
    ---浏览器停止键<br>
    ---来源: MemHack
    MEMHACK_VK_BROWSER_STOP = japi.MEMHACK_VK_BROWSER_STOP
    ---@type MEMHACK_VK
    ---浏览器搜索键<br>
    ---来源: MemHack
    MEMHACK_VK_BROWSER_SEARCH = japi.MEMHACK_VK_BROWSER_SEARCH
    ---@type MEMHACK_VK
    ---浏览器收藏夹密钥<br>
    ---来源: MemHack
    MEMHACK_VK_BROWSER_FAVORITES = japi.MEMHACK_VK_BROWSER_FAVORITES
    ---@type MEMHACK_VK
    ---浏览器"开始"和"开始"键<br>
    ---来源: MemHack
    MEMHACK_VK_BROWSER_HOME = japi.MEMHACK_VK_BROWSER_HOME
    ---@type MEMHACK_VK
    ---音量静音键<br>
    ---来源: MemHack
    MEMHACK_VK_VOLUME_MUTE = japi.MEMHACK_VK_VOLUME_MUTE
    ---@type MEMHACK_VK
    ---调低音量键<br>
    ---来源: MemHack
    MEMHACK_VK_VOLUME_DOWN = japi.MEMHACK_VK_VOLUME_DOWN
    ---@type MEMHACK_VK
    ---调高音量键<br>
    ---来源: MemHack
    MEMHACK_VK_VOLUME_UP = japi.MEMHACK_VK_VOLUME_UP
    ---@type MEMHACK_VK
    ---下一个 Track 键<br>
    ---来源: MemHack
    MEMHACK_VK_MEDIA_NEXT_TRACK = japi.MEMHACK_VK_MEDIA_NEXT_TRACK
    ---@type MEMHACK_VK
    ---上一曲目键<br>
    ---来源: MemHack
    MEMHACK_VK_MEDIA_PREV_TRACK = japi.MEMHACK_VK_MEDIA_PREV_TRACK
    ---@type MEMHACK_VK
    ---停止媒体键<br>
    ---来源: MemHack
    MEMHACK_VK_MEDIA_STOP = japi.MEMHACK_VK_MEDIA_STOP
    ---@type MEMHACK_VK
    ---播放/暂停媒体键<br>
    ---来源: MemHack
    MEMHACK_VK_MEDIA_PLAY_PAUSE = japi.MEMHACK_VK_MEDIA_PLAY_PAUSE
    ---@type MEMHACK_VK
    ---启动邮件密钥<br>
    ---来源: MemHack
    MEMHACK_VK_LAUNCH_MAIL = japi.MEMHACK_VK_LAUNCH_MAIL
    ---@type MEMHACK_VK
    ---选择媒体键<br>
    ---来源: MemHack
    MEMHACK_VK_LAUNCH_MEDIA_SELECT = japi.MEMHACK_VK_LAUNCH_MEDIA_SELECT
    ---@type MEMHACK_VK
    ---启动应用程序 1 密钥<br>
    ---来源: MemHack
    MEMHACK_VK_LAUNCH_APP1 = japi.MEMHACK_VK_LAUNCH_APP1
    ---@type MEMHACK_VK
    ---启动应用程序 2 密钥<br>
    ---来源: MemHack
    MEMHACK_VK_LAUNCH_APP2 = japi.MEMHACK_VK_LAUNCH_APP2
    ---@type MEMHACK_VK
    ---它可能因键盘而异。<br>
    ---对于 US ANSI 键盘, 使用 Semiсolon 和冒号键<br>
    ---来源: MemHack
    MEMHACK_VK_OEM_1 = japi.MEMHACK_VK_OEM_1
    ---@type MEMHACK_VK
    ---对于任何国家/地区, "等于"和"加号"键<br>
    ---来源: MemHack
    MEMHACK_VK_OEM_PLUS = japi.MEMHACK_VK_OEM_PLUS
    ---@type MEMHACK_VK
    ---对于任何国家/地区, 逗号和小于键<br>
    ---来源: MemHack
    MEMHACK_VK_OEM_COMMA = japi.MEMHACK_VK_OEM_COMMA
    ---@type MEMHACK_VK
    ---对于任何国家/地区, 短划线和下划线键<br>
    ---来源: MemHack
    MEMHACK_VK_OEM_MINUS = japi.MEMHACK_VK_OEM_MINUS
    ---@type MEMHACK_VK
    ---对于任何国家/地区, "时间段"和"大于"键<br>
    ---来源: MemHack
    MEMHACK_VK_OEM_PERIOD = japi.MEMHACK_VK_OEM_PERIOD
    ---@type MEMHACK_VK
    ---它可能因键盘而异。 对于 US ANSI 键盘, "正斜杠"和"问号"键<br>
    ---来源: MemHack
    MEMHACK_VK_OEM_2 = japi.MEMHACK_VK_OEM_2
    ---@type MEMHACK_VK
    ---它可能因键盘而异。 对于 US ANSI 键盘, "严重重音"和"波形符"键<br>
    ---来源: MemHack
    MEMHACK_VK_OEM_3 = japi.MEMHACK_VK_OEM_3
    ---@type MEMHACK_VK
    ---它可能因键盘而异。 对于 US ANSI 键盘, 左大括号键<br>
    ---来源: MemHack
    MEMHACK_VK_OEM_4 = japi.MEMHACK_VK_OEM_4
    ---@type MEMHACK_VK
    ---它可能因键盘而异。 对于 US ANSI 键盘, 反斜杠和管道键<br>
    ---来源: MemHack
    MEMHACK_VK_OEM_5 = japi.MEMHACK_VK_OEM_5
    ---@type MEMHACK_VK
    ---它可能因键盘而异。 对于 US ANSI 键盘, 右大括号键<br>
    ---来源: MemHack
    MEMHACK_VK_OEM_6 = japi.MEMHACK_VK_OEM_6
    ---@type MEMHACK_VK
    ---它可能因键盘而异。 对于 US ANSI 键盘, "撇号"和"双引号"键<br>
    ---来源: MemHack
    MEMHACK_VK_OEM_7 = japi.MEMHACK_VK_OEM_7
    ---@type MEMHACK_VK
    ---它可能因键盘而异。 对于加拿大 CSA 键盘, 为右 Ctrl 键<br>
    ---来源: MemHack
    MEMHACK_VK_OEM_8 = japi.MEMHACK_VK_OEM_8
    ---@type MEMHACK_VK
    ---它可能因键盘而异。 对于欧洲 ISO 键盘, 反斜杠和管道键<br>
    ---来源: MemHack
    MEMHACK_VK_OEM_102 = japi.MEMHACK_VK_OEM_102
    ---@type MEMHACK_VK
    ---0xE3-E4 OEM 特定<br>
    ---IME PROCESS 密钥<br>
    ---来源: MemHack
    MEMHACK_VK_PROCESSKEY = japi.MEMHACK_VK_PROCESSKEY
    ---@type MEMHACK_VK
    ---用于传递 Unicode 字符, 就像是击键一样。<br>
    ---VK_PACKET 键是用于非键盘输入方法的 32 位虚拟键值的低字。<br>
    ---有关详细信息, 请参阅 KEYBDINPUT/SendInput/WM_KEYDOWN和 WM_KEYUP 中的备注<br>
    ---来源: MemHack
    MEMHACK_VK_PACKET = japi.MEMHACK_VK_PACKET
    ---@type MEMHACK_VK
    ---Attn 键<br>
    ---来源: MemHack
    MEMHACK_VK_ATTN = japi.MEMHACK_VK_ATTN
    ---@type MEMHACK_VK
    ---CrSel 键<br>
    ---来源: MemHack
    MEMHACK_VK_CRSEL = japi.MEMHACK_VK_CRSEL
    ---@type MEMHACK_VK
    ---ExSel 密钥<br>
    ---来源: MemHack
    MEMHACK_VK_EXSEL = japi.MEMHACK_VK_EXSEL
    ---@type MEMHACK_VK
    ---擦除 EOF 密钥<br>
    ---来源: MemHack
    MEMHACK_VK_EREOF = japi.MEMHACK_VK_EREOF
    ---@type MEMHACK_VK
    ---播放键<br>
    ---来源: MemHack
    MEMHACK_VK_PLAY = japi.MEMHACK_VK_PLAY
    ---@type MEMHACK_VK
    ---缩放键<br>
    ---来源: MemHack
    MEMHACK_VK_ZOOM = japi.MEMHACK_VK_ZOOM
    ---@type MEMHACK_VK
    ---保留<br>
    ---来源: MemHack
    MEMHACK_VK_NONAME = japi.MEMHACK_VK_NONAME
    ---@type MEMHACK_VK
    ---PA1 密钥<br>
    ---来源: MemHack
    MEMHACK_VK_PA1 = japi.MEMHACK_VK_PA1
    ---@type MEMHACK_VK
    ---清除键<br>
    ---来源: MemHack
    MEMHACK_VK_OEM_CLEAR = japi.MEMHACK_VK_OEM_CLEAR



    --@alias MIRROR_AXIS integer

    ---@type MIRROR_AXIS
    ---镜像轴: XY平面<br>
    ---来源: MemHack
    MIRROR_AXIS_XY = japi.MIRROR_AXIS_XY
    ---@type MIRROR_AXIS
    ---镜像轴: XZ平面<br>
    ---来源: MemHack
    MIRROR_AXIS_XZ = japi.MIRROR_AXIS_XZ
    ---@type MIRROR_AXIS
    ---镜像轴: YZ平面<br>
    ---来源: MemHack
    MIRROR_AXIS_YZ = japi.MIRROR_AXIS_YZ



    --@alias MISSILE_DATA integer

    ---@type MISSILE_DATA
    ---投射物数据 (整数): 基础ID<br>
    ---来源: MemHack
    MISSILE_DATA_BASE_ID = japi.MISSILE_DATA_BASE_ID
    ---@type MISSILE_DATA
    ---投射物数据 (整数): 攻击类型<br>
    ---来源: MemHack
    MISSILE_DATA_ATTACK_TYPE = japi.MISSILE_DATA_ATTACK_TYPE
    ---@type MISSILE_DATA
    ---投射物数据 (整数): 伤害类型<br>
    ---来源: MemHack
    MISSILE_DATA_DAMAGE_TYPE = japi.MISSILE_DATA_DAMAGE_TYPE
    ---@type MISSILE_DATA
    ---投射物数据 (整数): 武器类型<br>
    ---来源: MemHack
    MISSILE_DATA_WEAPON_TYPE = japi.MISSILE_DATA_WEAPON_TYPE
    ---@type MISSILE_DATA
    ---投射物数据 (整数): 伤害标志<br>
    ---来源: MemHack
    MISSILE_DATA_DAMAGE_FLAG = japi.MISSILE_DATA_DAMAGE_FLAG
    ---@type MISSILE_DATA
    ---投射物数据 (整数): 目标允许<br>
    ---来源: MemHack
    MISSILE_DATA_TARGET_ALLOW = japi.MISSILE_DATA_TARGET_ALLOW
    ---@type MISSILE_DATA
    ---投射物数据 (整数): 弹射次数<br>
    ---来源: MemHack
    MISSILE_DATA_BOUNCE_TIMES = japi.MISSILE_DATA_BOUNCE_TIMES
    ---@type MISSILE_DATA
    ---投射物数据 (实数): 基础伤害<br>
    ---来源: MemHack
    MISSILE_DATA_DAMAGE = japi.MISSILE_DATA_DAMAGE
    ---@type MISSILE_DATA
    ---投射物数据 (实数): 附加伤害<br>
    ---来源: MemHack
    MISSILE_DATA_BONUS_DAMAGE = japi.MISSILE_DATA_BONUS_DAMAGE
    ---@type MISSILE_DATA
    ---投射物数据 (实数): 射弹速率<br>
    ---来源: MemHack
    MISSILE_DATA_SPEED = japi.MISSILE_DATA_SPEED
    ---@type MISSILE_DATA
    ---投射物数据 (实数): 射弹弧度<br>
    ---来源: MemHack
    MISSILE_DATA_ARC = japi.MISSILE_DATA_ARC
    ---@type MISSILE_DATA
    ---投射物数据 (实数): 弹射范围<br>
    ---来源: MemHack
    MISSILE_DATA_BOUNCE_RADIUS = japi.MISSILE_DATA_BOUNCE_RADIUS
    ---@type MISSILE_DATA
    ---投射物数据 (实数): 伤害衰减<br>
    ---来源: MemHack
    MISSILE_DATA_DMG_LOSS = japi.MISSILE_DATA_DMG_LOSS
    ---@type MISSILE_DATA
    ---投射物数据 (实数): 穿透距离<br>
    ---来源: MemHack
    MISSILE_DATA_SPILL_RANGE = japi.MISSILE_DATA_SPILL_RANGE
    ---@type MISSILE_DATA
    ---投射物数据 (实数): 穿透范围<br>
    ---来源: MemHack
    MISSILE_DATA_SPILL_RADIUS = japi.MISSILE_DATA_SPILL_RADIUS
    ---@type MISSILE_DATA
    ---投射物数据 (实数): 半伤害因数<br>
    ---来源: MemHack
    MISSILE_DATA_HALF_FACTOR = japi.MISSILE_DATA_HALF_FACTOR
    ---@type MISSILE_DATA
    ---投射物数据 (实数): 小伤害因数<br>
    ---来源: MemHack
    MISSILE_DATA_SMALL_FACTOR = japi.MISSILE_DATA_SMALL_FACTOR
    ---@type MISSILE_DATA
    ---投射物数据 (实数): 全伤害范围<br>
    ---来源: MemHack
    MISSILE_DATA_FULL_AREA = japi.MISSILE_DATA_FULL_AREA
    ---@type MISSILE_DATA
    ---投射物数据 (实数): 半伤害范围<br>
    ---来源: MemHack
    MISSILE_DATA_HALF_AREA = japi.MISSILE_DATA_HALF_AREA
    ---@type MISSILE_DATA
    ---投射物数据 (实数): 小伤害范围<br>
    ---来源: MemHack
    MISSILE_DATA_SMALL_AREA = japi.MISSILE_DATA_SMALL_AREA



    --@alias PLAYER_LEAVE_REASON integer

    ---@type PLAYER_LEAVE_REASON
    ---玩家离开原因: 退出游戏<br>
    ---来源: MemHack
    PLAYER_LEAVE_REASON_NORMAL = japi.PLAYER_LEAVE_REASON_NORMAL
    ---@type PLAYER_LEAVE_REASON
    ---玩家离开原因: 掉线<br>
    ---来源: MemHack
    PLAYER_LEAVE_REASON_DESYNC = japi.PLAYER_LEAVE_REASON_DESYNC



    --@alias SIMPLE_BUTTON_STATE integer

    ---@type SIMPLE_BUTTON_STATE
    ---CSimpleButton状态: 禁用<br>
    ---来源: MemHack
    SIMPLE_BUTTON_STATE_DISABLE = japi.SIMPLE_BUTTON_STATE_DISABLE
    ---@type SIMPLE_BUTTON_STATE
    ---CSimpleButton状态: 启用<br>
    ---来源: MemHack
    SIMPLE_BUTTON_STATE_ENABLE = japi.SIMPLE_BUTTON_STATE_ENABLE
    ---@type SIMPLE_BUTTON_STATE
    ---CSimpleButton状态: 按下<br>
    ---来源: MemHack
    SIMPLE_BUTTON_STATE_PUSHED = japi.SIMPLE_BUTTON_STATE_PUSHED



    --@alias SLK_TABLE integer

    ---@type SLK_TABLE
    ---slk表: 技能<br>
    ---来源: MemHack
    SLK_TABLE_ABILITY = japi.SLK_TABLE_ABILITY
    ---@type SLK_TABLE
    ---slk表: 魔法效果<br>
    ---来源: MemHack
    SLK_TABLE_BUFF = japi.SLK_TABLE_BUFF
    ---@type SLK_TABLE
    ---slk表: 单位<br>
    ---来源: MemHack
    SLK_TABLE_UNIT = japi.SLK_TABLE_UNIT
    ---@type SLK_TABLE
    ---slk表: 物品<br>
    ---来源: MemHack
    SLK_TABLE_ITEM = japi.SLK_TABLE_ITEM
    ---@type SLK_TABLE
    ---slk表: 科技<br>
    ---来源: MemHack
    SLK_TABLE_UPGRADE = japi.SLK_TABLE_UPGRADE
    ---@type SLK_TABLE
    ---slk表: 装饰物<br>
    ---来源: MemHack
    SLK_TABLE_DOODAD = japi.SLK_TABLE_DOODAD
    ---@type SLK_TABLE
    ---slk表: 可破坏物<br>
    ---来源: MemHack
    SLK_TABLE_DESTRUCTABLE = japi.SLK_TABLE_DESTRUCTABLE
    ---@type SLK_TABLE
    ---slk表: 杂项<br>
    ---来源: MemHack
    SLK_TABLE_MISC = japi.SLK_TABLE_MISC



    --@alias SUBANIM_TYPE integer

    ---@type SUBANIM_TYPE
    ---子动画类型: 定身<br>
    ---来源: MemHack
    SUBANIM_TYPE_ROOTED = japi.SUBANIM_TYPE_ROOTED
    ---@type SUBANIM_TYPE
    ---子动画类型: 变形<br>
    ---来源: MemHack
    SUBANIM_TYPE_ALTERNATE_EX = japi.SUBANIM_TYPE_ALTERNATE_EX
    ---@type SUBANIM_TYPE
    ---子动画类型: 循环<br>
    ---来源: MemHack
    SUBANIM_TYPE_LOOPING = japi.SUBANIM_TYPE_LOOPING
    ---@type SUBANIM_TYPE
    ---子动画类型: 猛击<br>
    ---来源: MemHack
    SUBANIM_TYPE_SLAM = japi.SUBANIM_TYPE_SLAM
    ---@type SUBANIM_TYPE
    ---子动画类型: 投掷<br>
    ---来源: MemHack
    SUBANIM_TYPE_THROW = japi.SUBANIM_TYPE_THROW
    ---@type SUBANIM_TYPE
    ---子动画类型: 尖刺<br>
    ---来源: MemHack
    SUBANIM_TYPE_SPIKED = japi.SUBANIM_TYPE_SPIKED
    ---@type SUBANIM_TYPE
    ---子动画类型: 快速<br>
    ---来源: MemHack
    SUBANIM_TYPE_FAST = japi.SUBANIM_TYPE_FAST
    ---@type SUBANIM_TYPE
    ---子动画类型: 旋转<br>
    ---来源: MemHack
    SUBANIM_TYPE_SPIN = japi.SUBANIM_TYPE_SPIN
    ---@type SUBANIM_TYPE
    ---子动画类型: 就绪<br>
    ---来源: MemHack
    SUBANIM_TYPE_READY = japi.SUBANIM_TYPE_READY
    ---@type SUBANIM_TYPE
    ---子动画类型: 引导<br>
    ---来源: MemHack
    SUBANIM_TYPE_CHANNEL = japi.SUBANIM_TYPE_CHANNEL
    ---@type SUBANIM_TYPE
    ---子动画类型: 防御<br>
    ---来源: MemHack
    SUBANIM_TYPE_DEFEND = japi.SUBANIM_TYPE_DEFEND
    ---@type SUBANIM_TYPE
    ---子动画类型: 庆祝胜利<br>
    ---来源: MemHack
    SUBANIM_TYPE_VICTORY = japi.SUBANIM_TYPE_VICTORY
    ---@type SUBANIM_TYPE
    ---子动画类型: 转身<br>
    ---来源: MemHack
    SUBANIM_TYPE_TURN = japi.SUBANIM_TYPE_TURN
    ---@type SUBANIM_TYPE
    ---子动画类型: 往左<br>
    ---来源: MemHack
    SUBANIM_TYPE_LEFT = japi.SUBANIM_TYPE_LEFT
    ---@type SUBANIM_TYPE
    ---子动画类型: 往右<br>
    ---来源: MemHack
    SUBANIM_TYPE_RIGHT = japi.SUBANIM_TYPE_RIGHT
    ---@type SUBANIM_TYPE
    ---子动画类型: 火焰<br>
    ---来源: MemHack
    SUBANIM_TYPE_FIRE = japi.SUBANIM_TYPE_FIRE
    ---@type SUBANIM_TYPE
    ---子动画类型: 血肉<br>
    ---来源: MemHack
    SUBANIM_TYPE_FLESH = japi.SUBANIM_TYPE_FLESH
    ---@type SUBANIM_TYPE
    ---子动画类型: 命中<br>
    ---来源: MemHack
    SUBANIM_TYPE_HIT = japi.SUBANIM_TYPE_HIT
    ---@type SUBANIM_TYPE
    ---子动画类型: 受伤<br>
    ---来源: MemHack
    SUBANIM_TYPE_WOUNDED = japi.SUBANIM_TYPE_WOUNDED
    ---@type SUBANIM_TYPE
    ---子动画类型: 发光<br>
    ---来源: MemHack
    SUBANIM_TYPE_LIGHT = japi.SUBANIM_TYPE_LIGHT
    ---@type SUBANIM_TYPE
    ---子动画类型: 温和<br>
    ---来源: MemHack
    SUBANIM_TYPE_MODERATE = japi.SUBANIM_TYPE_MODERATE
    ---@type SUBANIM_TYPE
    ---子动画类型: 严厉<br>
    ---来源: MemHack
    SUBANIM_TYPE_SEVERE = japi.SUBANIM_TYPE_SEVERE
    ---@type SUBANIM_TYPE
    ---子动画类型: 关键<br>
    ---来源: MemHack
    SUBANIM_TYPE_CRITICAL = japi.SUBANIM_TYPE_CRITICAL
    ---@type SUBANIM_TYPE
    ---子动画类型: 完成<br>
    ---来源: MemHack
    SUBANIM_TYPE_COMPLETE = japi.SUBANIM_TYPE_COMPLETE
    ---@type SUBANIM_TYPE
    ---子动画类型: 背运黄金<br>
    ---来源: MemHack
    SUBANIM_TYPE_GOLD = japi.SUBANIM_TYPE_GOLD
    ---@type SUBANIM_TYPE
    ---子动画类型: 背运木材<br>
    ---来源: MemHack
    SUBANIM_TYPE_LUMBER = japi.SUBANIM_TYPE_LUMBER
    ---@type SUBANIM_TYPE
    ---子动画类型: 工作<br>
    ---来源: MemHack
    SUBANIM_TYPE_WORK = japi.SUBANIM_TYPE_WORK
    ---@type SUBANIM_TYPE
    ---子动画类型: 交谈<br>
    ---来源: MemHack
    SUBANIM_TYPE_TALK = japi.SUBANIM_TYPE_TALK
    ---@type SUBANIM_TYPE
    ---子动画类型: 第一<br>
    ---来源: MemHack
    SUBANIM_TYPE_FIRST = japi.SUBANIM_TYPE_FIRST
    ---@type SUBANIM_TYPE
    ---子动画类型: 第二<br>
    ---来源: MemHack
    SUBANIM_TYPE_SECOND = japi.SUBANIM_TYPE_SECOND
    ---@type SUBANIM_TYPE
    ---子动画类型: 第三<br>
    ---来源: MemHack
    SUBANIM_TYPE_THIRD = japi.SUBANIM_TYPE_THIRD
    ---@type SUBANIM_TYPE
    ---子动画类型: 第四<br>
    ---来源: MemHack
    SUBANIM_TYPE_FOURTH = japi.SUBANIM_TYPE_FOURTH
    ---@type SUBANIM_TYPE
    ---子动画类型: 第五<br>
    ---来源: MemHack
    SUBANIM_TYPE_FIFTH = japi.SUBANIM_TYPE_FIFTH
    ---@type SUBANIM_TYPE
    ---子动画类型: 一<br>
    ---来源: MemHack
    SUBANIM_TYPE_ONE = japi.SUBANIM_TYPE_ONE
    ---@type SUBANIM_TYPE
    ---子动画类型: 二<br>
    ---来源: MemHack
    SUBANIM_TYPE_TWO = japi.SUBANIM_TYPE_TWO
    ---@type SUBANIM_TYPE
    ---子动画类型: 三<br>
    ---来源: MemHack
    SUBANIM_TYPE_THREE = japi.SUBANIM_TYPE_THREE
    ---@type SUBANIM_TYPE
    ---子动画类型: 四<br>
    ---来源: MemHack
    SUBANIM_TYPE_FOUR = japi.SUBANIM_TYPE_FOUR
    ---@type SUBANIM_TYPE
    ---子动画类型: 五<br>
    ---来源: MemHack
    SUBANIM_TYPE_FIVE = japi.SUBANIM_TYPE_FIVE
    ---@type SUBANIM_TYPE
    ---子动画类型: 小<br>
    ---来源: MemHack
    SUBANIM_TYPE_SMALL = japi.SUBANIM_TYPE_SMALL
    ---@type SUBANIM_TYPE
    ---子动画类型: 中<br>
    ---来源: MemHack
    SUBANIM_TYPE_MEDIUM = japi.SUBANIM_TYPE_MEDIUM
    ---@type SUBANIM_TYPE
    ---子动画类型: 大<br>
    ---来源: MemHack
    SUBANIM_TYPE_LARGE = japi.SUBANIM_TYPE_LARGE
    ---@type SUBANIM_TYPE
    ---子动画类型: 升级<br>
    ---来源: MemHack
    SUBANIM_TYPE_UPGRADE = japi.SUBANIM_TYPE_UPGRADE
    ---@type SUBANIM_TYPE
    ---子动画类型: 吸取<br>
    ---来源: MemHack
    SUBANIM_TYPE_DRAIN = japi.SUBANIM_TYPE_DRAIN
    ---@type SUBANIM_TYPE
    ---子动画类型: 吞噬<br>
    ---来源: MemHack
    SUBANIM_TYPE_FILL = japi.SUBANIM_TYPE_FILL
    ---@type SUBANIM_TYPE
    ---子动画类型: 闪电链<br>
    ---来源: MemHack
    SUBANIM_TYPE_CHAINLIGHTNING = japi.SUBANIM_TYPE_CHAINLIGHTNING
    ---@type SUBANIM_TYPE
    ---子动画类型: 吃树<br>
    ---来源: MemHack
    SUBANIM_TYPE_EATTREE = japi.SUBANIM_TYPE_EATTREE
    ---@type SUBANIM_TYPE
    ---子动画类型: 呕吐<br>
    ---来源: MemHack
    SUBANIM_TYPE_PUKE = japi.SUBANIM_TYPE_PUKE
    ---@type SUBANIM_TYPE
    ---子动画类型: 抽打<br>
    ---来源: MemHack
    SUBANIM_TYPE_FLAIL = japi.SUBANIM_TYPE_FLAIL
    ---@type SUBANIM_TYPE
    ---子动画类型: 关闭<br>
    ---来源: MemHack
    SUBANIM_TYPE_OFF = japi.SUBANIM_TYPE_OFF
    ---@type SUBANIM_TYPE
    ---子动画类型: 游泳<br>
    ---来源: MemHack
    SUBANIM_TYPE_SWIM = japi.SUBANIM_TYPE_SWIM
    ---@type SUBANIM_TYPE
    ---子动画类型: 缠绕<br>
    ---来源: MemHack
    SUBANIM_TYPE_ENTANGLE = japi.SUBANIM_TYPE_ENTANGLE
    ---@type SUBANIM_TYPE
    ---子动画类型: 狂暴<br>
    ---来源: MemHack
    SUBANIM_TYPE_BERSERK = japi.SUBANIM_TYPE_BERSERK



    --@alias SYSTEM_TIME integer

    ---@type SYSTEM_TIME
    ---系统时间: 年<br>
    ---来源: MemHack
    SYSTEM_TIME_YEAR = japi.SYSTEM_TIME_YEAR
    ---@type SYSTEM_TIME
    ---系统时间: 月<br>
    ---来源: MemHack
    SYSTEM_TIME_MONTH = japi.SYSTEM_TIME_MONTH
    ---@type SYSTEM_TIME
    ---系统时间: 日<br>
    ---来源: MemHack
    SYSTEM_TIME_DAY = japi.SYSTEM_TIME_DAY
    ---@type SYSTEM_TIME
    ---系统时间: 时<br>
    ---来源: MemHack
    SYSTEM_TIME_HOUR = japi.SYSTEM_TIME_HOUR
    ---@type SYSTEM_TIME
    ---系统时间: 分<br>
    ---来源: MemHack
    SYSTEM_TIME_MINUTE = japi.SYSTEM_TIME_MINUTE
    ---@type SYSTEM_TIME
    ---系统时间: 秒<br>
    ---来源: MemHack
    SYSTEM_TIME_SECOND = japi.SYSTEM_TIME_SECOND
    ---@type SYSTEM_TIME
    ---系统时间: 毫秒<br>
    ---来源: MemHack
    SYSTEM_TIME_MSECOND = japi.SYSTEM_TIME_MSECOND



    --@alias TARGET_ALLOW integer

    ---@type TARGET_ALLOW
    ---目标允许: 地形<br>
    ---来源: MemHack
    TARGET_ALLOW_TERRAIN = japi.TARGET_ALLOW_TERRAIN
    ---@type TARGET_ALLOW
    ---目标允许: 没有<br>
    ---来源: MemHack
    TARGET_ALLOW_NONE = japi.TARGET_ALLOW_NONE
    ---@type TARGET_ALLOW
    ---目标允许: 地面<br>
    ---来源: MemHack
    TARGET_ALLOW_GROUND = japi.TARGET_ALLOW_GROUND
    ---@type TARGET_ALLOW
    ---目标允许: 空中<br>
    ---来源: MemHack
    TARGET_ALLOW_AIR = japi.TARGET_ALLOW_AIR
    ---@type TARGET_ALLOW
    ---目标允许: 建筑<br>
    ---来源: MemHack
    TARGET_ALLOW_STRUCTURE = japi.TARGET_ALLOW_STRUCTURE
    ---@type TARGET_ALLOW
    ---目标允许: 守卫<br>
    ---来源: MemHack
    TARGET_ALLOW_WARD = japi.TARGET_ALLOW_WARD
    ---@type TARGET_ALLOW
    ---目标允许: 物品<br>
    ---来源: MemHack
    TARGET_ALLOW_ITEM = japi.TARGET_ALLOW_ITEM
    ---@type TARGET_ALLOW
    ---目标允许: 树木<br>
    ---来源: MemHack
    TARGET_ALLOW_TREE = japi.TARGET_ALLOW_TREE
    ---@type TARGET_ALLOW
    ---目标允许: 墙<br>
    ---来源: MemHack
    TARGET_ALLOW_WALL = japi.TARGET_ALLOW_WALL
    ---@type TARGET_ALLOW
    ---目标允许: 残骸<br>
    ---来源: MemHack
    TARGET_ALLOW_DEBRIS = japi.TARGET_ALLOW_DEBRIS
    ---@type TARGET_ALLOW
    ---目标允许: 装饰物<br>
    ---来源: MemHack
    TARGET_ALLOW_DECORATION = japi.TARGET_ALLOW_DECORATION
    ---@type TARGET_ALLOW
    ---目标允许: 桥<br>
    ---来源: MemHack
    TARGET_ALLOW_BRIDGE = japi.TARGET_ALLOW_BRIDGE
    ---@type TARGET_ALLOW
    ---目标允许: 自己<br>
    ---来源: MemHack
    TARGET_ALLOW_SELF = japi.TARGET_ALLOW_SELF
    ---@type TARGET_ALLOW
    ---目标允许: 玩家单位<br>
    ---来源: MemHack
    TARGET_ALLOW_PLAYER = japi.TARGET_ALLOW_PLAYER
    ---@type TARGET_ALLOW
    ---目标允许: 联盟<br>
    ---来源: MemHack
    TARGET_ALLOW_ALLIES = japi.TARGET_ALLOW_ALLIES
    ---@type TARGET_ALLOW
    ---目标允许: 友军单位<br>
    ---等价于: 玩家单位 + 联盟<br>
    ---来源: MemHack
    TARGET_ALLOW_FRIEND = japi.TARGET_ALLOW_FRIEND
    ---@type TARGET_ALLOW
    ---目标允许: 中立<br>
    ---来源: MemHack
    TARGET_ALLOW_NEUTRAL = japi.TARGET_ALLOW_NEUTRAL
    ---@type TARGET_ALLOW
    ---目标允许: 敌人<br>
    ---来源: MemHack
    TARGET_ALLOW_ENEMIES = japi.TARGET_ALLOW_ENEMIES
    ---@type TARGET_ALLOW
    ---目标允许: 别人<br>
    ---等价于: 玩家单位 + 联盟 + 中立 + 敌人<br>
    ---来源: MemHack
    TARGET_ALLOW_NOTSELF = japi.TARGET_ALLOW_NOTSELF
    ---@type TARGET_ALLOW
    ---目标允许: 可攻击的<br>
    ---来源: MemHack
    TARGET_ALLOW_VULNERABLE = japi.TARGET_ALLOW_VULNERABLE
    ---@type TARGET_ALLOW
    ---目标允许: 无敌<br>
    ---来源: MemHack
    TARGET_ALLOW_INVULNERABLE = japi.TARGET_ALLOW_INVULNERABLE
    ---@type TARGET_ALLOW
    ---目标允许: 英雄<br>
    ---来源: MemHack
    TARGET_ALLOW_HERO = japi.TARGET_ALLOW_HERO
    ---@type TARGET_ALLOW
    ---目标允许: 非 - 英雄<br>
    ---来源: MemHack
    TARGET_ALLOW_NONHERO = japi.TARGET_ALLOW_NONHERO
    ---@type TARGET_ALLOW
    ---目标允许: 存活<br>
    ---来源: MemHack
    TARGET_ALLOW_ALIVE = japi.TARGET_ALLOW_ALIVE
    ---@type TARGET_ALLOW
    ---目标允许: 死亡<br>
    ---来源: MemHack
    TARGET_ALLOW_DEAD = japi.TARGET_ALLOW_DEAD
    ---@type TARGET_ALLOW
    ---目标允许: 有机生物<br>
    ---来源: MemHack
    TARGET_ALLOW_ORGANIC = japi.TARGET_ALLOW_ORGANIC
    ---@type TARGET_ALLOW
    ---目标允许: 机械类<br>
    ---来源: MemHack
    TARGET_ALLOW_MECHANICAL = japi.TARGET_ALLOW_MECHANICAL
    ---@type TARGET_ALLOW
    ---目标允许: 非 - 自爆工兵<br>
    ---来源: MemHack
    TARGET_ALLOW_NONSAPPER = japi.TARGET_ALLOW_NONSAPPER
    ---@type TARGET_ALLOW
    ---目标允许: 自爆工兵<br>
    ---来源: MemHack
    TARGET_ALLOW_SAPPER = japi.TARGET_ALLOW_SAPPER
    ---@type TARGET_ALLOW
    ---目标允许: 非 - 古树<br>
    ---来源: MemHack
    TARGET_ALLOW_NONANCIENT = japi.TARGET_ALLOW_NONANCIENT
    ---@type TARGET_ALLOW
    ---目标允许: 古树<br>
    ---来源: MemHack
    TARGET_ALLOW_ANCIENT = japi.TARGET_ALLOW_ANCIENT



    --@alias TEXT_COLOR integer

    ---@type TEXT_COLOR
    ---文本颜色: 文本颜色<br>
    ---来源: MemHack
    TEXT_COLOR_NORMAL = japi.TEXT_COLOR_NORMAL
    ---@type TEXT_COLOR
    ---文本颜色: 禁用颜色<br>
    ---来源: MemHack
    TEXT_COLOR_DISABLED = japi.TEXT_COLOR_DISABLED
    ---@type TEXT_COLOR
    ---文本颜色: 高亮颜色<br>
    ---来源: MemHack
    TEXT_COLOR_HIGHLIGHT = japi.TEXT_COLOR_HIGHLIGHT
    ---@type TEXT_COLOR
    ---文本颜色: 阴影颜色<br>
    ---来源: MemHack
    TEXT_COLOR_SHADOW = japi.TEXT_COLOR_SHADOW



    --@alias TEXT_FLAG integer

    ---@type TEXT_FLAG
    ---文本标志: 水平对齐: 左<br>
    ---来源: MemHack
    TEXT_FLAG_ALIGN_LEFT = japi.TEXT_FLAG_ALIGN_LEFT
    ---@type TEXT_FLAG
    ---文本标志: 水平对齐: 中<br>
    ---来源: MemHack
    TEXT_FLAG_ALIGN_CENTER = japi.TEXT_FLAG_ALIGN_CENTER
    ---@type TEXT_FLAG
    ---文本标志: 水平对齐: 右<br>
    ---来源: MemHack
    TEXT_FLAG_ALIGN_RIGHT = japi.TEXT_FLAG_ALIGN_RIGHT
    ---@type TEXT_FLAG
    ---文本标志: 垂直对齐: 上<br>
    ---来源: MemHack
    TEXT_FLAG_ALIGN_TOP = japi.TEXT_FLAG_ALIGN_TOP
    ---@type TEXT_FLAG
    ---文本标志: 垂直对齐: 中<br>
    ---来源: MemHack
    TEXT_FLAG_ALIGN_MIDDLE = japi.TEXT_FLAG_ALIGN_MIDDLE
    ---@type TEXT_FLAG
    ---文本标志: 垂直对齐: 下<br>
    ---来源: MemHack
    TEXT_FLAG_ALIGN_BOTTOM = japi.TEXT_FLAG_ALIGN_BOTTOM
    ---@type TEXT_FLAG
    ---文本标志: 不换行<br>
    ---来源: MemHack
    TEXT_FLAG_NO_WRAP = japi.TEXT_FLAG_NO_WRAP
    ---@type TEXT_FLAG
    ---文本标志: 固定尺寸<br>
    ---来源: MemHack
    TEXT_FLAG_FIXED_SIZE = japi.TEXT_FLAG_FIXED_SIZE
    ---@type TEXT_FLAG
    ---文本标志: 固定颜色<br>
    ---来源: MemHack
    TEXT_FLAG_FIXED_COLOR = japi.TEXT_FLAG_FIXED_COLOR
    ---@type TEXT_FLAG
    ---文本标志: 等宽字体<br>
    ---来源: MemHack
    TEXT_FLAG_MONOSPACED = japi.TEXT_FLAG_MONOSPACED
    ---@type TEXT_FLAG
    ---文本标志: 忽略颜色代码<br>
    ---来源: MemHack
    TEXT_FLAG_IGNORE_COLOR = japi.TEXT_FLAG_IGNORE_COLOR
    ---@type TEXT_FLAG
    ---文本标志: 忽略换行符<br>
    ---来源: MemHack
    TEXT_FLAG_IGNORE_NEWLINE = japi.TEXT_FLAG_IGNORE_NEWLINE



    --@alias TEXT_HORIZON_ALIGN integer

    ---@type TEXT_HORIZON_ALIGN
    ---文本水平对齐方式：左边<br>
    ---来源: MemHack
    TEXT_HORIZON_ALIGN_LEFT = japi.TEXT_HORIZON_ALIGN_LEFT
    ---@type TEXT_HORIZON_ALIGN
    ---文本水平对齐方式：中心<br>
    ---来源: MemHack
    TEXT_HORIZON_ALIGN_CENTER = japi.TEXT_HORIZON_ALIGN_CENTER
    ---@type TEXT_HORIZON_ALIGN
    ---文本水平对齐方式：右边<br>
    ---来源: MemHack
    TEXT_HORIZON_ALIGN_RIGHT = japi.TEXT_HORIZON_ALIGN_RIGHT



    --@alias TEXT_STYLE integer

    ---@type TEXT_STYLE
    ---文本样式：使用阴影<br>
    ---来源: MemHack
    TEXT_STYLE_SHADOW = japi.TEXT_STYLE_SHADOW
    ---@type TEXT_STYLE
    ---文本样式：使用禁用颜色<br>
    ---来源: MemHack
    TEXT_STYLE_DISABLED_COLOR = japi.TEXT_STYLE_DISABLED_COLOR
    ---@type TEXT_STYLE
    ---文本样式：使用密码样式<br>
    ---来源: MemHack
    TEXT_STYLE_PASSWORD = japi.TEXT_STYLE_PASSWORD
    ---@type TEXT_STYLE
    ---文本样式：使用悬停高亮<br>
    ---来源: MemHack
    TEXT_STYLE_HOVER_HIGHLIGHT = japi.TEXT_STYLE_HOVER_HIGHLIGHT



    --@alias TEXT_TYPE integer

    ---@type TEXT_TYPE
    ---文本类型: 普通<br>
    ---来源: MemHack
    TEXT_TYPE_NORMAL = japi.TEXT_TYPE_NORMAL
    ---@type TEXT_TYPE
    ---文本类型: 描边<br>
    ---来源: MemHack
    TEXT_TYPE_OUTLINE = japi.TEXT_TYPE_OUTLINE
    ---@type TEXT_TYPE
    ---文本类型: 细体<br>
    ---来源: MemHack
    TEXT_TYPE_THICK = japi.TEXT_TYPE_THICK



    --@alias TEXT_VERTEX_ALIGN integer

    ---@type TEXT_VERTEX_ALIGN
    ---文本垂直对齐方式: 顶部<br>
    ---来源: MemHack
    TEXT_VERTEX_ALIGN_TOP = japi.TEXT_VERTEX_ALIGN_TOP
    ---@type TEXT_VERTEX_ALIGN
    ---文本垂直对齐方式: 中心<br>
    ---来源: MemHack
    TEXT_VERTEX_ALIGN_CENTER = japi.TEXT_VERTEX_ALIGN_CENTER
    ---@type TEXT_VERTEX_ALIGN
    ---文本垂直对齐方式: 底部<br>
    ---来源: MemHack
    TEXT_VERTEX_ALIGN_BOTTOM = japi.TEXT_VERTEX_ALIGN_BOTTOM



    --@alias UNIT_ARMOUR_TYPE integer

    ---@type UNIT_ARMOUR_TYPE
    ---单位护甲类型: 轻甲<br>
    ---来源: MemHack
    UNIT_ARMOUR_TYPE_LIGHT = japi.UNIT_ARMOUR_TYPE_LIGHT
    ---@type UNIT_ARMOUR_TYPE
    ---单位护甲类型: 中甲<br>
    ---来源: MemHack
    UNIT_ARMOUR_TYPE_MIDIUM = japi.UNIT_ARMOUR_TYPE_MIDIUM
    ---@type UNIT_ARMOUR_TYPE
    ---单位护甲类型: 重甲<br>
    ---来源: MemHack
    UNIT_ARMOUR_TYPE_HEAVY = japi.UNIT_ARMOUR_TYPE_HEAVY
    ---@type UNIT_ARMOUR_TYPE
    ---单位护甲类型: 城甲<br>
    ---来源: MemHack
    UNIT_ARMOUR_TYPE_FORTIFIED = japi.UNIT_ARMOUR_TYPE_FORTIFIED
    ---@type UNIT_ARMOUR_TYPE
    ---单位护甲类型: 普通甲<br>
    ---来源: MemHack
    UNIT_ARMOUR_TYPE_NORMAL = japi.UNIT_ARMOUR_TYPE_NORMAL
    ---@type UNIT_ARMOUR_TYPE
    ---单位护甲类型: 英雄甲<br>
    ---来源: MemHack
    UNIT_ARMOUR_TYPE_HERO = japi.UNIT_ARMOUR_TYPE_HERO
    ---@type UNIT_ARMOUR_TYPE
    ---单位护甲类型: 神圣甲<br>
    ---来源: MemHack
    UNIT_ARMOUR_TYPE_DIVINE = japi.UNIT_ARMOUR_TYPE_DIVINE
    ---@type UNIT_ARMOUR_TYPE
    ---单位护甲类型: 无护甲<br>
    ---来源: MemHack
    UNIT_ARMOUR_TYPE_UNARMOURED = japi.UNIT_ARMOUR_TYPE_UNARMOURED



    --@alias UNIT_ATK_DATA integer

    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (整数): 当前攻击索引<br>
    ---取值范围为0~3. 其中0代表不能攻击, 3代表攻击1和攻击2<br>
    ---来源: MemHack
    UNIT_ATK_DATA_WEAPONS_ON = japi.UNIT_ATK_DATA_WEAPONS_ON
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (整数): 攻击类型1<br>
    ---取值范围参考common.j中对ConvertAttackType函数的调用<br>
    ---来源: MemHack
    UNIT_ATK_DATA_ATTACK_TYPE1 = japi.UNIT_ATK_DATA_ATTACK_TYPE1
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (整数): 攻击类型2<br>
    ---取值范围参考common.j中对ConvertAttackType函数的调用<br>
    ---来源: MemHack
    UNIT_ATK_DATA_ATTACK_TYPE2 = japi.UNIT_ATK_DATA_ATTACK_TYPE2
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (整数): 武器类型1<br>
    ---指近战、箭矢等武器类型<br>
    ---来源: MemHack
    UNIT_ATK_DATA_WEAPON_TYPE1 = japi.UNIT_ATK_DATA_WEAPON_TYPE1
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (整数): 武器类型2<br>
    ---指近战、箭矢等武器类型<br>
    ---来源: MemHack
    UNIT_ATK_DATA_WEAPON_TYPE2 = japi.UNIT_ATK_DATA_WEAPON_TYPE2
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (整数): 目标允许1<br>
    ---BitSet. 取值范围参考文档中的目标允许常数<br>
    ---来源: MemHack
    UNIT_ATK_DATA_TARGET_ALLOW1 = japi.UNIT_ATK_DATA_TARGET_ALLOW1
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (整数): 目标允许2<br>
    ---BitSet. 取值范围参考文档中的目标允许常数<br>
    ---来源: MemHack
    UNIT_ATK_DATA_TARGET_ALLOW2 = japi.UNIT_ATK_DATA_TARGET_ALLOW2
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (整数): 最大目标数1<br>
    ---仅对弹射攻击有效<br>
    ---来源: MemHack
    UNIT_ATK_DATA_TARGET_COUNT1 = japi.UNIT_ATK_DATA_TARGET_COUNT1
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (整数): 最大目标数2<br>
    ---仅对弹射攻击有效<br>
    ---来源: MemHack
    UNIT_ATK_DATA_TARGET_COUNT2 = japi.UNIT_ATK_DATA_TARGET_COUNT2
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (整数): 基础伤害1<br>
    ---来源: MemHack
    UNIT_ATK_DATA_BASE_DAMAGE1 = japi.UNIT_ATK_DATA_BASE_DAMAGE1
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (整数): 基础伤害2<br>
    ---来源: MemHack
    UNIT_ATK_DATA_BASE_DAMAGE2 = japi.UNIT_ATK_DATA_BASE_DAMAGE2
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (整数): 附加伤害1<br>
    ---若设置该数值则会反映到基础伤害上<br>
    ---来源: MemHack
    UNIT_ATK_DATA_BONUS_DAMAGE1 = japi.UNIT_ATK_DATA_BONUS_DAMAGE1
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (整数): 附加伤害2<br>
    ---若设置该数值则会反映到基础伤害上<br>
    ---来源: MemHack
    UNIT_ATK_DATA_BONUS_DAMAGE2 = japi.UNIT_ATK_DATA_BONUS_DAMAGE2
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (整数): 伤害骰子数量1<br>
    ---来源: MemHack
    UNIT_ATK_DATA_DAMAGE_DICE1 = japi.UNIT_ATK_DATA_DAMAGE_DICE1
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (整数): 伤害骰子数量2<br>
    ---来源: MemHack
    UNIT_ATK_DATA_DAMAGE_DICE2 = japi.UNIT_ATK_DATA_DAMAGE_DICE2
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (整数): 伤害骰子面数1<br>
    ---来源: MemHack
    UNIT_ATK_DATA_DAMAGE_SIDES1 = japi.UNIT_ATK_DATA_DAMAGE_SIDES1
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (整数): 伤害骰子面数2<br>
    ---来源: MemHack
    UNIT_ATK_DATA_DAMAGE_SIDES2 = japi.UNIT_ATK_DATA_DAMAGE_SIDES2
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (整数): 武器声音<br>
    ---取值范围参考common.j中对ConvertWeaponType函数的调用<br>
    ---来源: MemHack
    UNIT_ATK_DATA_WEAPON_SOUND = japi.UNIT_ATK_DATA_WEAPON_SOUND
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 攻击速度<br>
    ---指攻速增幅乘数, 1代表无增幅, 同时影响攻击1和攻击2<br>
    ---默认最大限制为5, 最小限制为0.25<br>
    ---来源: MemHack
    UNIT_ATK_DATA_ATTACK_SPEED = japi.UNIT_ATK_DATA_ATTACK_SPEED
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 主动攻击范围<br>
    ---来源: MemHack
    UNIT_ATK_DATA_ACQUISION_RANGE = japi.UNIT_ATK_DATA_ACQUISION_RANGE
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 最小攻击范围<br>
    ---来源: MemHack
    UNIT_ATK_DATA_MIN_RANGE = japi.UNIT_ATK_DATA_MIN_RANGE
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 攻击范围1<br>
    ---设置该数值超过主动攻击范围时, 单位不会主动攻击但可手动攻击<br>
    ---来源: MemHack
    UNIT_ATK_DATA_ATTACK_RANGE1 = japi.UNIT_ATK_DATA_ATTACK_RANGE1
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 攻击范围2<br>
    ---设置该数值超过主动攻击范围时, 单位不会主动攻击但可手动攻击<br>
    ---来源: MemHack
    UNIT_ATK_DATA_ATTACK_RANGE2 = japi.UNIT_ATK_DATA_ATTACK_RANGE2
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 攻击范围缓冲1<br>
    ---来源: MemHack
    UNIT_ATK_DATA_RANGE_BUFFER1 = japi.UNIT_ATK_DATA_RANGE_BUFFER1
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 攻击范围缓冲2<br>
    ---来源: MemHack
    UNIT_ATK_DATA_RANGE_BUFFER2 = japi.UNIT_ATK_DATA_RANGE_BUFFER2
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 攻击间隔1<br>
    ---来源: MemHack
    UNIT_ATK_DATA_BAT1 = japi.UNIT_ATK_DATA_BAT1
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 攻击间隔2<br>
    ---来源: MemHack
    UNIT_ATK_DATA_BAT2 = japi.UNIT_ATK_DATA_BAT2
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 攻击前摇1<br>
    ---来源: MemHack
    UNIT_ATK_DATA_ATTACK_POINT1 = japi.UNIT_ATK_DATA_ATTACK_POINT1
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 攻击前摇2<br>
    ---来源: MemHack
    UNIT_ATK_DATA_ATTACK_POINT2 = japi.UNIT_ATK_DATA_ATTACK_POINT2
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 攻击后摇1<br>
    ---来源: MemHack
    UNIT_ATK_DATA_BACK_SWING1 = japi.UNIT_ATK_DATA_BACK_SWING1
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 攻击后摇2<br>
    ---来源: MemHack
    UNIT_ATK_DATA_BACK_SWING2 = japi.UNIT_ATK_DATA_BACK_SWING2
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 中伤害参数1<br>
    ---来源: MemHack
    UNIT_ATK_DATA_HALF_FACTOR1 = japi.UNIT_ATK_DATA_HALF_FACTOR1
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 中伤害参数2<br>
    ---来源: MemHack
    UNIT_ATK_DATA_HALF_FACTOR2 = japi.UNIT_ATK_DATA_HALF_FACTOR2
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 小伤害参数1<br>
    ---来源: MemHack
    UNIT_ATK_DATA_SMALL_FACTOR1 = japi.UNIT_ATK_DATA_SMALL_FACTOR1
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 小伤害参数2<br>
    ---来源: MemHack
    UNIT_ATK_DATA_SMALL_FACTOR2 = japi.UNIT_ATK_DATA_SMALL_FACTOR2
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 全伤害范围1<br>
    ---来源: MemHack
    UNIT_ATK_DATA_FULL_AREA1 = japi.UNIT_ATK_DATA_FULL_AREA1
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 全伤害范围2<br>
    ---来源: MemHack
    UNIT_ATK_DATA_FULL_AREA2 = japi.UNIT_ATK_DATA_FULL_AREA2
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 中伤害范围1<br>
    ---来源: MemHack
    UNIT_ATK_DATA_HALF_AREA1 = japi.UNIT_ATK_DATA_HALF_AREA1
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 中伤害范围2<br>
    ---来源: MemHack
    UNIT_ATK_DATA_HALF_AREA2 = japi.UNIT_ATK_DATA_HALF_AREA2
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 小伤害范围1<br>
    ---来源: MemHack
    UNIT_ATK_DATA_SMALL_AREA1 = japi.UNIT_ATK_DATA_SMALL_AREA1
    ---@type UNIT_ATK_DATA
    ---单位攻击数据 (实数): 小伤害范围2<br>
    ---来源: MemHack
    UNIT_ATK_DATA_SMALL_AREA2 = japi.UNIT_ATK_DATA_SMALL_AREA2



    --@alias UNIT_COLLISION_TYPE integer

    ---@type UNIT_COLLISION_TYPE
    ---单位碰撞类型: 无<br>
    ---来源: MemHack
    UNIT_COLLISION_TYPE_NONE = japi.UNIT_COLLISION_TYPE_NONE
    ---@type UNIT_COLLISION_TYPE
    ---单位碰撞类型: 任何<br>
    ---来源: MemHack
    UNIT_COLLISION_TYPE_ANY = japi.UNIT_COLLISION_TYPE_ANY
    ---@type UNIT_COLLISION_TYPE
    ---单位碰撞类型: 步行<br>
    ---来源: MemHack
    UNIT_COLLISION_TYPE_FOOT = japi.UNIT_COLLISION_TYPE_FOOT
    ---@type UNIT_COLLISION_TYPE
    ---单位碰撞类型: 飞行<br>
    ---来源: MemHack
    UNIT_COLLISION_TYPE_AIR = japi.UNIT_COLLISION_TYPE_AIR
    ---@type UNIT_COLLISION_TYPE
    ---单位碰撞类型: 建筑<br>
    ---来源: MemHack
    UNIT_COLLISION_TYPE_BUILDING = japi.UNIT_COLLISION_TYPE_BUILDING
    ---@type UNIT_COLLISION_TYPE
    ---单位碰撞类型: 采集工<br>
    ---来源: MemHack
    UNIT_COLLISION_TYPE_HARVESTER = japi.UNIT_COLLISION_TYPE_HARVESTER
    ---@type UNIT_COLLISION_TYPE
    ---单位碰撞类型: 荒芜之地<br>
    ---来源: MemHack
    UNIT_COLLISION_TYPE_BLIGHTED = japi.UNIT_COLLISION_TYPE_BLIGHTED
    ---@type UNIT_COLLISION_TYPE
    ---单位碰撞类型: 浮空 (陆)<br>
    ---来源: MemHack
    UNIT_COLLISION_TYPE_HOVER = japi.UNIT_COLLISION_TYPE_HOVER
    ---@type UNIT_COLLISION_TYPE
    ---单位碰撞类型: 两栖<br>
    ---来源: MemHack
    UNIT_COLLISION_TYPE_AMPH = japi.UNIT_COLLISION_TYPE_AMPH
    ---@type UNIT_COLLISION_TYPE
    ---单位碰撞类型: 地面<br>
    ---等于 步行 + 建筑 + 浮空 (陆) + 两栖<br>
    ---来源: MemHack
    UNIT_COLLISION_TYPE_GROUND = japi.UNIT_COLLISION_TYPE_GROUND



    --@alias UNIT_CUR_STATE integer

    ---@type UNIT_CUR_STATE
    ---单位状态: 正常<br>
    ---来源: MemHack
    UNIT_CUR_STATE_NORMAL = japi.UNIT_CUR_STATE_NORMAL
    ---@type UNIT_CUR_STATE
    ---单位状态: 攻击<br>
    ---来源: MemHack
    UNIT_CUR_STATE_ATTACK = japi.UNIT_CUR_STATE_ATTACK
    ---@type UNIT_CUR_STATE
    ---单位状态: 施法<br>
    ---建造也属于这个状态<br>
    ---来源: MemHack
    UNIT_CUR_STATE_SPELL = japi.UNIT_CUR_STATE_SPELL
    ---@type UNIT_CUR_STATE
    ---单位状态: 死亡<br>
    ---来源: MemHack
    UNIT_CUR_STATE_DEAD = japi.UNIT_CUR_STATE_DEAD
    ---@type UNIT_CUR_STATE
    ---单位状态: 采集<br>
    ---来源: MemHack
    UNIT_CUR_STATE_HARVEST = japi.UNIT_CUR_STATE_HARVEST



    --@alias UNIT_DATA integer

    ---@type UNIT_DATA
    ---单位数据: 最大生命值<br>
    ---游戏不会存储真实生命值, 仅记录基础生命值和上次更改基础生命值的时间戳<br>
    ---当需要用到真实生命值的时候，才会计算: 基础生命值 + (当前时间戳 - 上次的时间戳) * 生命恢复速度<br>
    ---当受到伤害/治疗或者触发器等外界因素影响生命值时就会更新基础生命值和时间戳<br>
    ---来源: MemHack
    UNIT_DATA_MAX_LIFE = japi.UNIT_DATA_MAX_LIFE
    ---@type UNIT_DATA
    ---单位数据: 最大魔法值<br>
    ---游戏不会存储真实魔法值, 仅记录基础魔法值和上次更改基础魔法值的时间戳<br>
    ---当需要用到真实魔法值的时候, 才会计算：基础魔法值 + (当前时间戳 - 上次的时间戳) * 魔法恢复速度<br>
    ---当恢复魔法或者触发器等外界因素影响魔法值时就会更新基础魔法值和时间戳<br>
    ---来源: MemHack
    UNIT_DATA_MAX_MANA = japi.UNIT_DATA_MAX_MANA
    ---@type UNIT_DATA
    ---单位数据: 生命恢复速度<br>
    ---来源: MemHack
    UNIT_DATA_LIFE_REGEN = japi.UNIT_DATA_LIFE_REGEN
    ---@type UNIT_DATA
    ---单位数据: 魔法恢复速度<br>
    ---来源: MemHack
    UNIT_DATA_MANA_REGEN = japi.UNIT_DATA_MANA_REGEN
    ---@type UNIT_DATA
    ---单位数据: 护甲值<br>
    ---指的是白字 + 绿字, 若设置护甲值则会反映到白字护甲值上面<br>
    ---来源: MemHack
    UNIT_DATA_DEF_VALUE = japi.UNIT_DATA_DEF_VALUE
    ---@type UNIT_DATA
    ---单位数据: Z轴坐标<br>
    ---来源: MemHack
    UNIT_DATA_POSITION_Z = japi.UNIT_DATA_POSITION_Z
    ---@type UNIT_DATA
    ---单位数据: 当前视野<br>
    ---不会超过最大视野限制<br>
    ---来源: MemHack
    UNIT_DATA_CUR_SIGHT = japi.UNIT_DATA_CUR_SIGHT
    ---@type UNIT_DATA
    ---单位数据: 射弹碰撞偏移 - Z<br>
    ---来源: MemHack
    UNIT_DATA_IMPACT_Z = japi.UNIT_DATA_IMPACT_Z
    ---@type UNIT_DATA
    ---单位数据: 射弹碰撞偏移 - Z (深水)<br>
    ---来源: MemHack
    UNIT_DATA_IMPACT_Z_SWIM = japi.UNIT_DATA_IMPACT_Z_SWIM
    ---@type UNIT_DATA
    ---单位数据: 射弹偏移 - X<br>
    ---来源: MemHack
    UNIT_DATA_LAUNCH_X = japi.UNIT_DATA_LAUNCH_X
    ---@type UNIT_DATA
    ---单位数据: 射弹偏移 - Y<br>
    ---来源: MemHack
    UNIT_DATA_LAUNCH_Y = japi.UNIT_DATA_LAUNCH_Y
    ---@type UNIT_DATA
    ---单位数据: 射弹偏移 - Z<br>
    ---来源: MemHack
    UNIT_DATA_LAUNCH_Z = japi.UNIT_DATA_LAUNCH_Z
    ---@type UNIT_DATA
    ---单位数据: 射弹偏移 - Z (深水)<br>
    ---来源: MemHack
    UNIT_DATA_LAUNCH_Z_SWIM = japi.UNIT_DATA_LAUNCH_Z_SWIM
    ---@type UNIT_DATA
    ---单位数据: 模型缩放<br>
    ---来源: MemHack
    UNIT_DATA_MODEL_SCALE = japi.UNIT_DATA_MODEL_SCALE
    ---@type UNIT_DATA
    ---单位数据: Z轴缩放<br>
    ---可以设置, 但是当单位有了新的动作后就会恢复<br>
    ---来源: MemHack
    UNIT_DATA_Z_SCALE = japi.UNIT_DATA_Z_SCALE
    ---@type UNIT_DATA
    ---单位数据: 血条高度<br>
    ---来源: MemHack
    UNIT_DATA_HPBAR_HEIGHT = japi.UNIT_DATA_HPBAR_HEIGHT
    ---@type UNIT_DATA
    ---单位数据: 动画播放速度<br>
    ---来源: MemHack
    UNIT_DATA_TIME_SCALE = japi.UNIT_DATA_TIME_SCALE
    ---@type UNIT_DATA
    ---单位数据: 碰撞大小<br>
    ---来源: MemHack
    UNIT_DATA_COLLISION = japi.UNIT_DATA_COLLISION
    ---@type UNIT_DATA
    ---单位数据: 附加移速<br>
    ---来源: MemHack
    UNIT_DATA_BONUS_MOVESPEED = japi.UNIT_DATA_BONUS_MOVESPEED
    ---@type UNIT_DATA
    ---单位数据: 魔法抗性<br>
    ---不包括护甲类型, 不可修改, 返回伤害乘数<br>
    ---来源: MemHack
    UNIT_DATA_MAGIC_RESIST = japi.UNIT_DATA_MAGIC_RESIST



    --@alias UNIT_DEF_DATA integer

    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 单位ID<br>
    ---来源: MemHack
    UNIT_DEF_DATA_ID = japi.UNIT_DEF_DATA_ID
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 建造时间<br>
    ---来源: MemHack
    UNIT_DEF_DATA_BUILD_TIME = japi.UNIT_DEF_DATA_BUILD_TIME
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 修理时间<br>
    ---来源: MemHack
    UNIT_DEF_DATA_REPAIR_TIME = japi.UNIT_DEF_DATA_REPAIR_TIME
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 黄金消耗<br>
    ---来源: MemHack
    UNIT_DEF_DATA_GOLD_COST = japi.UNIT_DEF_DATA_GOLD_COST
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 木材消耗<br>
    ---来源: MemHack
    UNIT_DEF_DATA_LUMBER_COST = japi.UNIT_DEF_DATA_LUMBER_COST
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 黄金奖励 - 骰子数量<br>
    ---来源: MemHack
    UNIT_DEF_DATA_GOLD_BOUNTY_DICE = japi.UNIT_DEF_DATA_GOLD_BOUNTY_DICE
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 黄金奖励 - 骰子面数<br>
    ---来源: MemHack
    UNIT_DEF_DATA_GOLD_BOUNTY_SIDES = japi.UNIT_DEF_DATA_GOLD_BOUNTY_SIDES
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 黄金奖励 - 基础值<br>
    ---来源: MemHack
    UNIT_DEF_DATA_GOLD_BOUNTY_BASE = japi.UNIT_DEF_DATA_GOLD_BOUNTY_BASE
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 木材奖励 - 骰子数量<br>
    ---来源: MemHack
    UNIT_DEF_DATA_LUMBER_BOUNTY_DICE = japi.UNIT_DEF_DATA_LUMBER_BOUNTY_DICE
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 木材奖励 - 骰子面数<br>
    ---来源: MemHack
    UNIT_DEF_DATA_LUMBER_BOUNTY_SIDES = japi.UNIT_DEF_DATA_LUMBER_BOUNTY_SIDES
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 木材奖励 - 基础值<br>
    ---来源: MemHack
    UNIT_DEF_DATA_LUMBER_BOUNTY_BASE = japi.UNIT_DEF_DATA_LUMBER_BOUNTY_BASE
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 最大库存量<br>
    ---来源: MemHack
    UNIT_DEF_DATA_STOCK_MAX = japi.UNIT_DEF_DATA_STOCK_MAX
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 运输尺寸<br>
    ---来源: MemHack
    UNIT_DEF_DATA_CARGO_SIZE = japi.UNIT_DEF_DATA_CARGO_SIZE
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 等级<br>
    ---来源: MemHack
    UNIT_DEF_DATA_LEVEL = japi.UNIT_DEF_DATA_LEVEL
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 生命回复类型<br>
    ---来源: MemHack
    UNIT_DEF_DATA_REGEN_TYPE = japi.UNIT_DEF_DATA_REGEN_TYPE
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 护甲类型<br>
    ---来源: MemHack
    UNIT_DEF_DATA_DEF_TYPE = japi.UNIT_DEF_DATA_DEF_TYPE
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 允许攻击模式<br>
    ---来源: MemHack
    UNIT_DEF_DATA_WEAPONS_ON = japi.UNIT_DEF_DATA_WEAPONS_ON
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 目标允许1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_TARGET_ALLOW1 = japi.UNIT_DEF_DATA_TARGET_ALLOW1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 目标允许2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_TARGET_ALLOW2 = japi.UNIT_DEF_DATA_TARGET_ALLOW2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 伤害升级奖励1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_DAMAGE_UP1 = japi.UNIT_DEF_DATA_DAMAGE_UP1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 伤害升级奖励2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_DAMAGE_UP2 = japi.UNIT_DEF_DATA_DAMAGE_UP2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 伤害骰子数量1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_DAMAGE_DICE1 = japi.UNIT_DEF_DATA_DAMAGE_DICE1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 伤害骰子数量2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_DAMAGE_DICE2 = japi.UNIT_DEF_DATA_DAMAGE_DICE2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 伤害骰子面数1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_DAMAGE_SIDES1 = japi.UNIT_DEF_DATA_DAMAGE_SIDES1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 伤害骰子面数2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_DAMAGE_SIDES2 = japi.UNIT_DEF_DATA_DAMAGE_SIDES2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 基础伤害1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_DAMAGE_BASE1 = japi.UNIT_DEF_DATA_DAMAGE_BASE1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 基础伤害2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_DAMAGE_BASE2 = japi.UNIT_DEF_DATA_DAMAGE_BASE2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 最大目标数1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_TARGET_COUNT1 = japi.UNIT_DEF_DATA_TARGET_COUNT1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 最大目标数2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_TARGET_COUNT2 = japi.UNIT_DEF_DATA_TARGET_COUNT2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 攻击类型1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_ATTACK_TYPE1 = japi.UNIT_DEF_DATA_ATTACK_TYPE1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 攻击类型2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_ATTACK_TYPE2 = japi.UNIT_DEF_DATA_ATTACK_TYPE2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 武器声音1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_WEAPON_SOUND1 = japi.UNIT_DEF_DATA_WEAPON_SOUND1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 武器声音2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_WEAPON_SOUND2 = japi.UNIT_DEF_DATA_WEAPON_SOUND2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 武器类型1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_WEAPON_TYPE1 = japi.UNIT_DEF_DATA_WEAPON_TYPE1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 武器类型2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_WEAPON_TYPE2 = japi.UNIT_DEF_DATA_WEAPON_TYPE2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 初始力量<br>
    ---来源: MemHack
    UNIT_DEF_DATA_INIT_STR = japi.UNIT_DEF_DATA_INIT_STR
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 初始敏捷<br>
    ---来源: MemHack
    UNIT_DEF_DATA_INIT_AGI = japi.UNIT_DEF_DATA_INIT_AGI
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 初始智力<br>
    ---来源: MemHack
    UNIT_DEF_DATA_INIT_INT = japi.UNIT_DEF_DATA_INIT_INT
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 主要属性<br>
    ---来源: MemHack
    UNIT_DEF_DATA_PRIMARY_ATTR = japi.UNIT_DEF_DATA_PRIMARY_ATTR
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 种族<br>
    ---来源: MemHack
    UNIT_DEF_DATA_RACE = japi.UNIT_DEF_DATA_RACE
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 单位类别<br>
    ---来源: MemHack
    UNIT_DEF_DATA_TYPE = japi.UNIT_DEF_DATA_TYPE
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 碰撞类型 (别人碰撞自己)<br>
    ---来源: MemHack
    UNIT_DEF_DATA_COLLISION_TYPE_FROM_OTHER = japi.UNIT_DEF_DATA_COLLISION_TYPE_FROM_OTHER
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 碰撞类型 (自己碰撞别人)<br>
    ---来源: MemHack
    UNIT_DEF_DATA_COLLISION_TYPE_TO_OTHER = japi.UNIT_DEF_DATA_COLLISION_TYPE_TO_OTHER
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 占用人口<br>
    ---来源: MemHack
    UNIT_DEF_DATA_FOOD_USED = japi.UNIT_DEF_DATA_FOOD_USED
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 提供人口<br>
    ---来源: MemHack
    UNIT_DEF_DATA_FOOD_MADE = japi.UNIT_DEF_DATA_FOOD_MADE
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 附加值<br>
    ---来源: MemHack
    UNIT_DEF_DATA_POINTS = japi.UNIT_DEF_DATA_POINTS
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数):<br>
    ---来源: MemHack
    UNIT_DEF_DATA_COLOR = japi.UNIT_DEF_DATA_COLOR
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数):<br>
    ---来源: MemHack
    UNIT_DEF_DATA_LOOPING_SND_FADE_IN = japi.UNIT_DEF_DATA_LOOPING_SND_FADE_IN
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数):<br>
    ---来源: MemHack
    UNIT_DEF_DATA_LOOPING_SND_FADE_OUT = japi.UNIT_DEF_DATA_LOOPING_SND_FADE_OUT
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 按钮位置 (X)<br>
    ---来源: MemHack
    UNIT_DEF_DATA_BUTTON_X = japi.UNIT_DEF_DATA_BUTTON_X
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 按钮位置 (Y)<br>
    ---来源: MemHack
    UNIT_DEF_DATA_BUTTON_Y = japi.UNIT_DEF_DATA_BUTTON_Y
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (整数): 热键<br>
    ---来源: MemHack
    UNIT_DEF_DATA_HOTKEY = japi.UNIT_DEF_DATA_HOTKEY
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 雇用时间间隔<br>
    ---来源: MemHack
    UNIT_DEF_DATA_STOCK_REGEN = japi.UNIT_DEF_DATA_STOCK_REGEN
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 雇佣开始时间<br>
    ---来源: MemHack
    UNIT_DEF_DATA_STOCK_START = japi.UNIT_DEF_DATA_STOCK_START
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 施法前摇<br>
    ---来源: MemHack
    UNIT_DEF_DATA_CAST_POINT = japi.UNIT_DEF_DATA_CAST_POINT
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 施法后摇<br>
    ---来源: MemHack
    UNIT_DEF_DATA_CAST_BACKSWING = japi.UNIT_DEF_DATA_CAST_BACKSWING
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 死亡时间<br>
    ---来源: MemHack
    UNIT_DEF_DATA_DEATH_TIME = japi.UNIT_DEF_DATA_DEATH_TIME
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 生命恢复速度<br>
    ---来源: MemHack
    UNIT_DEF_DATA_LIFE_REGEN = japi.UNIT_DEF_DATA_LIFE_REGEN
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 最大生命值<br>
    ---来源: MemHack
    UNIT_DEF_DATA_MAX_LIFE = japi.UNIT_DEF_DATA_MAX_LIFE
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 初始魔法值<br>
    ---来源: MemHack
    UNIT_DEF_DATA_INIT_MANA = japi.UNIT_DEF_DATA_INIT_MANA
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 最大魔法值<br>
    ---来源: MemHack
    UNIT_DEF_DATA_MAX_MANA = japi.UNIT_DEF_DATA_MAX_MANA
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 魔法恢复速度<br>
    ---来源: MemHack
    UNIT_DEF_DATA_MANA_REGEN = japi.UNIT_DEF_DATA_MANA_REGEN
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 护甲值<br>
    ---来源: MemHack
    UNIT_DEF_DATA_DEF_VALUE = japi.UNIT_DEF_DATA_DEF_VALUE
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 护甲升级奖励<br>
    ---来源: MemHack
    UNIT_DEF_DATA_DEF_UP = japi.UNIT_DEF_DATA_DEF_UP
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 伤害衰减参数1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_DAMAGE_LOSS1 = japi.UNIT_DEF_DATA_DAMAGE_LOSS1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 伤害衰减参数2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_DAMAGE_LOSS2 = japi.UNIT_DEF_DATA_DAMAGE_LOSS2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 穿透伤害距离1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_SPILL_DIST1 = japi.UNIT_DEF_DATA_SPILL_DIST1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 穿透伤害距离2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_SPILL_DIST2 = japi.UNIT_DEF_DATA_SPILL_DIST2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 穿透伤害范围1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_SPILL_RADIUS1 = japi.UNIT_DEF_DATA_SPILL_RADIUS1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 穿透伤害范围2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_SPILL_RADIUS2 = japi.UNIT_DEF_DATA_SPILL_RADIUS2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 攻击范围1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_ATTACK_RANGE1 = japi.UNIT_DEF_DATA_ATTACK_RANGE1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 攻击范围2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_ATTACK_RANGE2 = japi.UNIT_DEF_DATA_ATTACK_RANGE2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 攻击范围缓冲1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_RANGE_BUFFER1 = japi.UNIT_DEF_DATA_RANGE_BUFFER1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 攻击范围缓冲2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_RANGE_BUFFER2 = japi.UNIT_DEF_DATA_RANGE_BUFFER2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 攻击间隔1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_BAT1 = japi.UNIT_DEF_DATA_BAT1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 攻击间隔2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_BAT2 = japi.UNIT_DEF_DATA_BAT2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 攻击前摇1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_ATTACK_POINT1 = japi.UNIT_DEF_DATA_ATTACK_POINT1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 攻击前摇2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_ATTACK_POINT2 = japi.UNIT_DEF_DATA_ATTACK_POINT2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 攻击后摇1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_ATTACK_BACSWING1 = japi.UNIT_DEF_DATA_ATTACK_BACSWING1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 攻击后摇2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_ATTACK_BACSWING2 = japi.UNIT_DEF_DATA_ATTACK_BACSWING2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 全伤害范围1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_FULL_AREA1 = japi.UNIT_DEF_DATA_FULL_AREA1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 全伤害范围2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_FULL_AREA2 = japi.UNIT_DEF_DATA_FULL_AREA2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 半伤害范围1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_HALF_AREA1 = japi.UNIT_DEF_DATA_HALF_AREA1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 半伤害范围2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_HALF_AREA2 = japi.UNIT_DEF_DATA_HALF_AREA2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 小伤害范围1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_SMALL_AREA1 = japi.UNIT_DEF_DATA_SMALL_AREA1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 小伤害范围2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_SMALL_AREA2 = japi.UNIT_DEF_DATA_SMALL_AREA2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 半伤害因数1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_HALF_FACTOR1 = japi.UNIT_DEF_DATA_HALF_FACTOR1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 半伤害因数2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_HALF_FACTOR2 = japi.UNIT_DEF_DATA_HALF_FACTOR2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 小伤害因数1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_SMALL_FACTOR1 = japi.UNIT_DEF_DATA_SMALL_FACTOR1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 小伤害因数2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_SMALL_FACTOR2 = japi.UNIT_DEF_DATA_SMALL_FACTOR2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 每级提升力量<br>
    ---来源: MemHack
    UNIT_DEF_DATA_STR_UP = japi.UNIT_DEF_DATA_STR_UP
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 每级提升敏捷<br>
    ---来源: MemHack
    UNIT_DEF_DATA_AGI_UP = japi.UNIT_DEF_DATA_AGI_UP
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 每级提升智力<br>
    ---来源: MemHack
    UNIT_DEF_DATA_INT_UP = japi.UNIT_DEF_DATA_INT_UP
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 视野范围 (白天)<br>
    ---来源: MemHack
    UNIT_DEF_DATA_SIGHT_DAY = japi.UNIT_DEF_DATA_SIGHT_DAY
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 视野范围 (夜晚)<br>
    ---来源: MemHack
    UNIT_DEF_DATA_SIGHT_NIGHT = japi.UNIT_DEF_DATA_SIGHT_NIGHT
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 主动攻击范围<br>
    ---来源: MemHack
    UNIT_DEF_DATA_ACQUISION_RANGE = japi.UNIT_DEF_DATA_ACQUISION_RANGE
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 最小攻击范围<br>
    ---来源: MemHack
    UNIT_DEF_DATA_MIN_RANGE = japi.UNIT_DEF_DATA_MIN_RANGE
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 碰撞体积<br>
    ---来源: MemHack
    UNIT_DEF_DATA_COLLISION = japi.UNIT_DEF_DATA_COLLISION
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数):<br>
    ---来源: MemHack
    UNIT_DEF_DATA_FOG_RADIUS = japi.UNIT_DEF_DATA_FOG_RADIUS
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数):<br>
    ---来源: MemHack
    UNIT_DEF_DATA_AI_RADIUS = japi.UNIT_DEF_DATA_AI_RADIUS
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 移动速度<br>
    ---来源: MemHack
    UNIT_DEF_DATA_SPEED = japi.UNIT_DEF_DATA_SPEED
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 最小移动速度<br>
    ---来源: MemHack
    UNIT_DEF_DATA_MIN_SPEED = japi.UNIT_DEF_DATA_MIN_SPEED
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 最大移动速度<br>
    ---来源: MemHack
    UNIT_DEF_DATA_MAX_SPEED = japi.UNIT_DEF_DATA_MAX_SPEED
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 转身速度<br>
    ---来源: MemHack
    UNIT_DEF_DATA_TURN_RATE = japi.UNIT_DEF_DATA_TURN_RATE
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 转向角度<br>
    ---来源: MemHack
    UNIT_DEF_DATA_PROP_WIN = japi.UNIT_DEF_DATA_PROP_WIN
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 转向补正<br>
    ---来源: MemHack
    UNIT_DEF_DATA_ORIENT_INTERP = japi.UNIT_DEF_DATA_ORIENT_INTERP
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 闭塞高度<br>
    ---来源: MemHack
    UNIT_DEF_DATA_OCCLUSION_HEIGHT = japi.UNIT_DEF_DATA_OCCLUSION_HEIGHT
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 高度<br>
    ---来源: MemHack
    UNIT_DEF_DATA_HEIGHT = japi.UNIT_DEF_DATA_HEIGHT
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 最小高度<br>
    ---来源: MemHack
    UNIT_DEF_DATA_MOVE_FLOOR = japi.UNIT_DEF_DATA_MOVE_FLOOR
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 射弹偏移 - X<br>
    ---来源: MemHack
    UNIT_DEF_DATA_LAUNCH_X = japi.UNIT_DEF_DATA_LAUNCH_X
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 射弹偏移 - Y<br>
    ---来源: MemHack
    UNIT_DEF_DATA_LAUNCH_Y = japi.UNIT_DEF_DATA_LAUNCH_Y
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 射弹偏移 - Z<br>
    ---来源: MemHack
    UNIT_DEF_DATA_LAUNCH_Z = japi.UNIT_DEF_DATA_LAUNCH_Z
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 射弹偏移 - Z (深水)<br>
    ---来源: MemHack
    UNIT_DEF_DATA_LAUNCH_Z_SWIM = japi.UNIT_DEF_DATA_LAUNCH_Z_SWIM
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 射弹碰撞偏移 - Z<br>
    ---来源: MemHack
    UNIT_DEF_DATA_IMPACT_Z = japi.UNIT_DEF_DATA_IMPACT_Z
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 射弹碰撞偏移 - Z (深水)<br>
    ---来源: MemHack
    UNIT_DEF_DATA_IMPACT_Z_SWIM = japi.UNIT_DEF_DATA_IMPACT_Z_SWIM
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 混合时间<br>
    ---来源: MemHack
    UNIT_DEF_DATA_BLEND = japi.UNIT_DEF_DATA_BLEND
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 行走速度<br>
    ---来源: MemHack
    UNIT_DEF_DATA_WALK_SPEED = japi.UNIT_DEF_DATA_WALK_SPEED
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 跑步速度<br>
    ---来源: MemHack
    UNIT_DEF_DATA_RUN_SPEED = japi.UNIT_DEF_DATA_RUN_SPEED
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 选择圈缩放<br>
    ---来源: MemHack
    UNIT_DEF_DATA_CIRCLE_SCALE = japi.UNIT_DEF_DATA_CIRCLE_SCALE
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 选择圈高度<br>
    ---来源: MemHack
    UNIT_DEF_DATA_CIRCLE_Z = japi.UNIT_DEF_DATA_CIRCLE_Z
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 射弹速率1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_MISSILE_SPEED1 = japi.UNIT_DEF_DATA_MISSILE_SPEED1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 射弹速率2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_MISSILE_SPEED2 = japi.UNIT_DEF_DATA_MISSILE_SPEED2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 射弹弧度1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_MISSILE_ARC1 = japi.UNIT_DEF_DATA_MISSILE_ARC1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 射弹弧度2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_MISSILE_ARC2 = japi.UNIT_DEF_DATA_MISSILE_ARC2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 阴影图像 - X轴偏移<br>
    ---来源: MemHack
    UNIT_DEF_DATA_SHADOW_X = japi.UNIT_DEF_DATA_SHADOW_X
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 阴影图像 - Y轴偏移<br>
    ---来源: MemHack
    UNIT_DEF_DATA_SHADOW_Y = japi.UNIT_DEF_DATA_SHADOW_Y
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 阴影图像 - 宽度<br>
    ---来源: MemHack
    UNIT_DEF_DATA_SHADOW_WIDTH = japi.UNIT_DEF_DATA_SHADOW_WIDTH
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 阴影图像 - 高度<br>
    ---来源: MemHack
    UNIT_DEF_DATA_SHADOW_HEIGHT = japi.UNIT_DEF_DATA_SHADOW_HEIGHT
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (实数): 模型缩放<br>
    ---来源: MemHack
    UNIT_DEF_DATA_SCALE = japi.UNIT_DEF_DATA_SCALE
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (布尔值): 允许睡眠<br>
    ---来源: MemHack
    UNIT_DEF_DATA_CAN_SLEEP = japi.UNIT_DEF_DATA_CAN_SLEEP
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (布尔值): 可以逃跑<br>
    ---来源: MemHack
    UNIT_DEF_DATA_CAN_FLEE = japi.UNIT_DEF_DATA_CAN_FLEE
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (布尔值): 显示UI1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_SHOW_UI1 = japi.UNIT_DEF_DATA_SHOW_UI1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (布尔值): 显示UI2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_SHOW_UI2 = japi.UNIT_DEF_DATA_SHOW_UI2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (字符串): 名字<br>
    ---来源: MemHack
    UNIT_DEF_DATA_NAME = japi.UNIT_DEF_DATA_NAME
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (字符串): 模型路径<br>
    ---来源: MemHack
    UNIT_DEF_DATA_MODEL = japi.UNIT_DEF_DATA_MODEL
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (字符串): 肖像路径<br>
    ---来源: MemHack
    UNIT_DEF_DATA_PORTRAIT = japi.UNIT_DEF_DATA_PORTRAIT
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (字符串): 投射物图像1<br>
    ---来源: MemHack
    UNIT_DEF_DATA_MISSILE_ART1 = japi.UNIT_DEF_DATA_MISSILE_ART1
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (字符串): 投射物图像2<br>
    ---来源: MemHack
    UNIT_DEF_DATA_MISSILE_ART2 = japi.UNIT_DEF_DATA_MISSILE_ART2
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (字符串): 计分屏图标<br>
    ---来源: MemHack
    UNIT_DEF_DATA_SCORE_SCREEN_ICON = japi.UNIT_DEF_DATA_SCORE_SCREEN_ICON
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (字符串): 图标<br>
    ---来源: MemHack
    UNIT_DEF_DATA_ART = japi.UNIT_DEF_DATA_ART
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (字符串): 提示工具 - 普通<br>
    ---来源: MemHack
    UNIT_DEF_DATA_TIP = japi.UNIT_DEF_DATA_TIP
    ---@type UNIT_DEF_DATA
    ---单位物编数据 (字符串): 提示工具 - 普通 - 扩展<br>
    ---来源: MemHack
    UNIT_DEF_DATA_UBERTIP = japi.UNIT_DEF_DATA_UBERTIP



    --@alias UNIT_FLAG1 integer

    ---@type UNIT_FLAG1
    ---单位标志1: 隐藏<br>
    ---来源: MemHack
    UNIT_FLAG1_HIDE = japi.UNIT_FLAG1_HIDE
    ---@type UNIT_FLAG1
    ---单位标志1: 能被选择<br>
    ---删除后与蝗虫类似, 不能被点选和框选<br>
    ---来源: MemHack
    UNIT_FLAG1_CANSELECT = japi.UNIT_FLAG1_CANSELECT
    ---@type UNIT_FLAG1
    ---单位标志1: 能成为目标<br>
    ---删除后不能成为指示器的目标<br>
    ---来源: MemHack
    UNIT_FLAG1_CANBETARGET = japi.UNIT_FLAG1_CANBETARGET
    ---@type UNIT_FLAG1
    ---单位标志1: 无敌<br>
    ---可作为判定无敌的依据. 可添加但不推荐<br>
    ---来源: MemHack
    UNIT_FLAG1_INVULNERABLE = japi.UNIT_FLAG1_INVULNERABLE
    ---@type UNIT_FLAG1
    ---单位标志1: 对所有人可见<br>
    ---类似所有主基地被摧毁后, 模型可以无视战争迷雾显示<br>
    ---来源: MemHack
    UNIT_FLAG1_VISIBLE_TO_ALL = japi.UNIT_FLAG1_VISIBLE_TO_ALL
    ---@type UNIT_FLAG1
    ---单位标志1: 普通攻击索敌中<br>
    ---来源: MemHack
    UNIT_FLAG1_SEARCHING_ATTACK_TARGET = japi.UNIT_FLAG1_SEARCHING_ATTACK_TARGET
    ---@type UNIT_FLAG1
    ---单位标志1: 可设置飞行高度<br>
    ---相当于添加删除风暴之鸦技能<br>
    ---来源: MemHack
    UNIT_FLAG1_CANSET_FLYHEIGHT = japi.UNIT_FLAG1_CANSET_FLYHEIGHT
    ---@type UNIT_FLAG1
    ---单位标志1: 钻地、潜水等<br>
    ---来源: MemHack
    UNIT_FLAG1_BURROWED = japi.UNIT_FLAG1_BURROWED
    ---@type UNIT_FLAG1
    ---单位标志1: 禁止反击<br>
    ---类似农民, 被敌人攻击时不会主动反击<br>
    ---来源: MemHack
    UNIT_FLAG1_COUNTERATTACK_DISABLE = japi.UNIT_FLAG1_COUNTERATTACK_DISABLE



    --@alias UNIT_FLAG2 integer

    ---@type UNIT_FLAG2
    ---单位标志2: 死亡<br>
    ---来源: MemHack
    UNIT_FLAG2_DEAD = japi.UNIT_FLAG2_DEAD
    ---@type UNIT_FLAG2
    ---单位标志2: 正在腐化<br>
    ---指死亡后到尸体完全消失这段时间<br>
    ---来源: MemHack
    UNIT_FLAG2_DECAY = japi.UNIT_FLAG2_DECAY
    ---@type UNIT_FLAG2
    ---单位标志2: 死亡时播放特殊效果<br>
    ---来源: MemHack
    UNIT_FLAG2_WITH_SPECIAL_ART = japi.UNIT_FLAG2_WITH_SPECIAL_ART
    ---@type UNIT_FLAG2
    ---单位标志2: 是建筑<br>
    ---来源: MemHack
    UNIT_FLAG2_BUILDING = japi.UNIT_FLAG2_BUILDING
    ---@type UNIT_FLAG2
    ---单位标志2: 小地图图标为金矿<br>
    ---来源: MemHack
    UNIT_FLAG2_MINMAP_ICON_GOLD = japi.UNIT_FLAG2_MINMAP_ICON_GOLD
    ---@type UNIT_FLAG2
    ---单位标志2: 小地图图标为中立商店<br>
    ---来源: MemHack
    UNIT_FLAG2_MINMAP_ICON_TAVERN = japi.UNIT_FLAG2_MINMAP_ICON_TAVERN
    ---@type UNIT_FLAG2
    ---单位标志2: 小地图图标隐藏<br>
    ---来源: MemHack
    UNIT_FLAG2_MINMAP_ICON_HIDE = japi.UNIT_FLAG2_MINMAP_ICON_HIDE
    ---@type UNIT_FLAG2
    ---单位标志2: 眩晕中<br>
    ---可作为判定眩晕的依据. 不建议手动添加<br>
    ---来源: MemHack
    UNIT_FLAG2_STUN = japi.UNIT_FLAG2_STUN
    ---@type UNIT_FLAG2
    ---单位标志2: 暂停<br>
    ---可作为判定暂停的依据. 不建议手动添加<br>
    ---来源: MemHack
    UNIT_FLAG2_PAUSE = japi.UNIT_FLAG2_PAUSE
    ---@type UNIT_FLAG2
    ---单位标志2: 隐形<br>
    ---可作为判定隐形的依据. 不建议手动添加<br>
    ---来源: MemHack
    UNIT_FLAG2_INVISIBLE = japi.UNIT_FLAG2_INVISIBLE
    ---@type UNIT_FLAG2
    ---单位标志2: 隐藏面板<br>
    ---来源: MemHack
    UNIT_FLAG2_HIDE_PANEL = japi.UNIT_FLAG2_HIDE_PANEL
    ---@type UNIT_FLAG2
    ---单位标志2: 飞行视野<br>
    ---删除该标志后单位失去飞行视野, 飞行高度也不会随树而变化<br>
    ---来源: MemHack
    UNIT_FLAG2_FLY_VISION = japi.UNIT_FLAG2_FLY_VISION
    ---@type UNIT_FLAG2
    ---单位标志2: 幻象<br>
    ---可作为判定幻象的依据. 不建议手动添加<br>
    ---来源: MemHack
    UNIT_FLAG2_ILLUSION = japi.UNIT_FLAG2_ILLUSION
    ---@type UNIT_FLAG2
    ---单位标志2: 操纵死尸<br>
    ---可作为判定操纵死尸的依据. 不建议手动添加<br>
    ---来源: MemHack
    UNIT_FLAG2_ANIMATED = japi.UNIT_FLAG2_ANIMATED



    --@alias UNIT_FLAG_TYPE integer

    ---@type UNIT_FLAG_TYPE
    ---单位种类: 泰坦族<br>
    ---来源: MemHack
    UNIT_FLAG_TYPE_GIANT = japi.UNIT_FLAG_TYPE_GIANT
    ---@type UNIT_FLAG_TYPE
    ---单位种类: 不死族<br>
    ---来源: MemHack
    UNIT_FLAG_TYPE_UNDEAD = japi.UNIT_FLAG_TYPE_UNDEAD
    ---@type UNIT_FLAG_TYPE
    ---单位种类: 召唤单位<br>
    ---来源: MemHack
    UNIT_FLAG_TYPE_SUMMON = japi.UNIT_FLAG_TYPE_SUMMON
    ---@type UNIT_FLAG_TYPE
    ---单位种类: 机械类<br>
    ---来源: MemHack
    UNIT_FLAG_TYPE_MECHANICAL = japi.UNIT_FLAG_TYPE_MECHANICAL
    ---@type UNIT_FLAG_TYPE
    ---单位种类: 工人<br>
    ---来源: MemHack
    UNIT_FLAG_TYPE_PEON = japi.UNIT_FLAG_TYPE_PEON
    ---@type UNIT_FLAG_TYPE
    ---单位种类: 自爆工兵<br>
    ---来源: MemHack
    UNIT_FLAG_TYPE_SAPPER = japi.UNIT_FLAG_TYPE_SAPPER
    ---@type UNIT_FLAG_TYPE
    ---单位种类: 城镇大厅<br>
    ---来源: MemHack
    UNIT_FLAG_TYPE_TOWNHALL = japi.UNIT_FLAG_TYPE_TOWNHALL
    ---@type UNIT_FLAG_TYPE
    ---单位种类: 古树<br>
    ---来源: MemHack
    UNIT_FLAG_TYPE_ANCIENT = japi.UNIT_FLAG_TYPE_ANCIENT
    ---@type UNIT_FLAG_TYPE
    ---单位种类: 守卫<br>
    ---来源: MemHack
    UNIT_FLAG_TYPE_WARD = japi.UNIT_FLAG_TYPE_WARD
    ---@type UNIT_FLAG_TYPE
    ---单位种类: 可通行<br>
    ---来源: MemHack
    UNIT_FLAG_TYPE_STANDON = japi.UNIT_FLAG_TYPE_STANDON
    ---@type UNIT_FLAG_TYPE
    ---单位种类: 牛头人<br>
    ---来源: MemHack
    UNIT_FLAG_TYPE_TAUREN = japi.UNIT_FLAG_TYPE_TAUREN



    --@alias UNIT_LEVEL_DEF_DATA integer

    ---@type UNIT_LEVEL_DEF_DATA
    ---单位物编等级数据 (整数): 使用科技<br>
    ---来源: MemHack
    UNIT_LEVEL_DATA_UPGRADE = japi.UNIT_LEVEL_DATA_UPGRADE
    ---@type UNIT_LEVEL_DEF_DATA
    ---单位物编等级数据 (整数): 技能<br>
    ---来源: MemHack
    UNIT_LEVEL_DATA_ABILITY = japi.UNIT_LEVEL_DATA_ABILITY
    ---@type UNIT_LEVEL_DEF_DATA
    ---单位物编等级数据 (整数): 要求动画名<br>
    ---来源: MemHack
    UNIT_LEVEL_DATA_ANIM_PROP = japi.UNIT_LEVEL_DATA_ANIM_PROP
    ---@type UNIT_LEVEL_DEF_DATA
    ---单位物编等级数据 (整数): 要求动画名 - 附加动画<br>
    ---来源: MemHack
    UNIT_LEVEL_DATA_ATTACH_PROP = japi.UNIT_LEVEL_DATA_ATTACH_PROP
    ---@type UNIT_LEVEL_DEF_DATA
    ---单位物编等级数据 (整数): 要求附加动画链接名<br>
    ---来源: MemHack
    UNIT_LEVEL_DATA_ATTACH_LINK_PROP = japi.UNIT_LEVEL_DATA_ATTACH_LINK_PROP
    ---@type UNIT_LEVEL_DEF_DATA
    ---单位物编等级数据 (整数): 要求骨骼名<br>
    ---来源: MemHack
    UNIT_LEVEL_DATA_BONE_PROP = japi.UNIT_LEVEL_DATA_BONE_PROP
    ---@type UNIT_LEVEL_DEF_DATA
    ---单位物编等级数据 (整数): 从属等价物<br>
    ---来源: MemHack
    UNIT_LEVEL_DATA_DEPENDENCY_OR = japi.UNIT_LEVEL_DATA_DEPENDENCY_OR
    ---@type UNIT_LEVEL_DEF_DATA
    ---单位物编等级数据 (整数): 建筑升级<br>
    ---来源: MemHack
    UNIT_LEVEL_DATA_BUILDING_UPGRADE = japi.UNIT_LEVEL_DATA_BUILDING_UPGRADE
    ---@type UNIT_LEVEL_DEF_DATA
    ---单位物编等级数据 (整数): 可建造建筑<br>
    ---来源: MemHack
    UNIT_LEVEL_DATA_BUILD = japi.UNIT_LEVEL_DATA_BUILD
    ---@type UNIT_LEVEL_DEF_DATA
    ---单位物编等级数据 (整数): 训练单位<br>
    ---来源: MemHack
    UNIT_LEVEL_DATA_TRAIN = japi.UNIT_LEVEL_DATA_TRAIN
    ---@type UNIT_LEVEL_DEF_DATA
    ---单位物编等级数据 (整数): 可研究项目<br>
    ---来源: MemHack
    UNIT_LEVEL_DATA_RESEARCH = japi.UNIT_LEVEL_DATA_RESEARCH
    ---@type UNIT_LEVEL_DEF_DATA
    ---单位物编等级数据 (整数): 售出单位<br>
    ---来源: MemHack
    UNIT_LEVEL_DATA_SELL_UNIT = japi.UNIT_LEVEL_DATA_SELL_UNIT
    ---@type UNIT_LEVEL_DEF_DATA
    ---单位物编等级数据 (整数): 售出物品<br>
    ---来源: MemHack
    UNIT_LEVEL_DATA_SELL_ITEM = japi.UNIT_LEVEL_DATA_SELL_ITEM
    ---@type UNIT_LEVEL_DEF_DATA
    ---单位物编等级数据 (整数): 制造物品<br>
    ---来源: MemHack
    UNIT_LEVEL_DATA_MAKE_ITEM = japi.UNIT_LEVEL_DATA_MAKE_ITEM
    ---@type UNIT_LEVEL_DEF_DATA
    ---单位物编等级数据 (整数): 科技需求<br>
    ---来源: MemHack
    UNIT_LEVEL_DATA_REQUIRE = japi.UNIT_LEVEL_DATA_REQUIRE
    ---@type UNIT_LEVEL_DEF_DATA
    ---单位物编等级数据 (整数): 科技需求值<br>
    ---来源: MemHack
    UNIT_LEVEL_DATA_REQUIRE_AMOUNT = japi.UNIT_LEVEL_DATA_REQUIRE_AMOUNT
    ---@type UNIT_LEVEL_DEF_DATA
    ---单位物编等级数据 (字符串): 称谓<br>
    ---来源: MemHack
    UNIT_LEVEL_DATA_PROPER_NAME = japi.UNIT_LEVEL_DATA_PROPER_NAME



    --@alias UNIT_MOVE_TYPE integer

    ---@type UNIT_MOVE_TYPE
    ---单位移动类型: 没有<br>
    ---无视地形<br>
    ---来源: MemHack
    UNIT_MOVE_TYPE_NONE = japi.UNIT_MOVE_TYPE_NONE
    ---@type UNIT_MOVE_TYPE
    ---单位移动类型: 无法移动<br>
    ---类似于单位被网住<br>
    ---来源: MemHack
    UNIT_MOVE_TYPE_DISABLE = japi.UNIT_MOVE_TYPE_DISABLE
    ---@type UNIT_MOVE_TYPE
    ---单位移动类型: 步行<br>
    ---来源: MemHack
    UNIT_MOVE_TYPE_FOOT = japi.UNIT_MOVE_TYPE_FOOT
    ---@type UNIT_MOVE_TYPE
    ---单位移动类型: 飞行<br>
    ---来源: MemHack
    UNIT_MOVE_TYPE_FLY = japi.UNIT_MOVE_TYPE_FLY
    ---@type UNIT_MOVE_TYPE
    ---单位移动类型: 地精地雷<br>
    ---表现为无法通过不可建造区域<br>
    ---来源: MemHack
    UNIT_MOVE_TYPE_LANDMINE = japi.UNIT_MOVE_TYPE_LANDMINE
    ---@type UNIT_MOVE_TYPE
    ---单位移动类型: 疾风步<br>
    ---来源: MemHack
    UNIT_MOVE_TYPE_WINDWALK = japi.UNIT_MOVE_TYPE_WINDWALK
    ---@type UNIT_MOVE_TYPE
    ---单位移动类型: 浮空 (陆)<br>
    ---来源: MemHack
    UNIT_MOVE_TYPE_HOVER = japi.UNIT_MOVE_TYPE_HOVER
    ---@type UNIT_MOVE_TYPE
    ---单位移动类型: 两栖<br>
    ---来源: MemHack
    UNIT_MOVE_TYPE_AMPH = japi.UNIT_MOVE_TYPE_AMPH



    --@alias UNIT_PATH_TYPE integer

    ---@type UNIT_PATH_TYPE
    ---单位寻路类型: 步行<br>
    ---来源: MemHack
    UNIT_PATH_TYPE_FOOT = japi.UNIT_PATH_TYPE_FOOT
    ---@type UNIT_PATH_TYPE
    ---单位寻路类型: 两栖<br>
    ---来源: MemHack
    UNIT_PATH_TYPE_AMPH = japi.UNIT_PATH_TYPE_AMPH
    ---@type UNIT_PATH_TYPE
    ---单位寻路类型: 漂浮 (水)<br>
    ---来源: MemHack
    UNIT_PATH_TYPE_FLOAT = japi.UNIT_PATH_TYPE_FLOAT
    ---@type UNIT_PATH_TYPE
    ---单位寻路类型: 飞行<br>
    ---相当于步行 + 两栖<br>
    ---来源: MemHack
    UNIT_PATH_TYPE_FLY = japi.UNIT_PATH_TYPE_FLY



    --@alias UNIT_WEAPON_TYPE integer

    ---@type UNIT_WEAPON_TYPE
    ---单位武器类型: 没有<br>
    ---来源: MemHack
    UNIT_WEAPON_TYPE_NONE = japi.UNIT_WEAPON_TYPE_NONE
    ---@type UNIT_WEAPON_TYPE
    ---单位武器类型: 近战<br>
    ---来源: MemHack
    UNIT_WEAPON_TYPE_MELEE = japi.UNIT_WEAPON_TYPE_MELEE
    ---@type UNIT_WEAPON_TYPE
    ---单位武器类型: 箭矢<br>
    ---来源: MemHack
    UNIT_WEAPON_TYPE_MISSILE = japi.UNIT_WEAPON_TYPE_MISSILE
    ---@type UNIT_WEAPON_TYPE
    ---单位武器类型: 炮火<br>
    ---来源: MemHack
    UNIT_WEAPON_TYPE_ARTILLERY = japi.UNIT_WEAPON_TYPE_ARTILLERY
    ---@type UNIT_WEAPON_TYPE
    ---单位武器类型: 立即<br>
    ---来源: MemHack
    UNIT_WEAPON_TYPE_INSTANT = japi.UNIT_WEAPON_TYPE_INSTANT
    ---@type UNIT_WEAPON_TYPE
    ---单位武器类型: 箭矢 (溅射)<br>
    ---来源: MemHack
    UNIT_WEAPON_TYPE_MISSILE_SPLASH = japi.UNIT_WEAPON_TYPE_MISSILE_SPLASH
    ---@type UNIT_WEAPON_TYPE
    ---单位武器类型: 箭矢 (弹射)<br>
    ---来源: MemHack
    UNIT_WEAPON_TYPE_MISSILE_BOUNCE = japi.UNIT_WEAPON_TYPE_MISSILE_BOUNCE
    ---@type UNIT_WEAPON_TYPE
    ---单位武器类型: 箭矢 (穿透)<br>
    ---来源: MemHack
    UNIT_WEAPON_TYPE_MISSILE_LINE = japi.UNIT_WEAPON_TYPE_MISSILE_LINE
    ---@type UNIT_WEAPON_TYPE
    ---单位武器类型: 炮火 (穿透)<br>
    ---来源: MemHack
    UNIT_WEAPON_TYPE_ARTILLERY_LINE = japi.UNIT_WEAPON_TYPE_ARTILLERY_LINE



    --@alias ABILITY_DATA integer

    ---@type ABILITY_DATA
    ---技能数据 (整数): 目标允许<br>
    ---来源: ydjapi
    ABILITY_DATA_TARGS = japi.ABILITY_DATA_TARGS
    ---@type ABILITY_DATA
    ---技能数据 (实数): 魔法施放时间<br>
    ---来源: ydjapi
    ABILITY_DATA_CAST = japi.ABILITY_DATA_CAST
    ---@type ABILITY_DATA
    ---技能数据 (实数): 持续时间 - 普通<br>
    ---来源: ydjapi
    ABILITY_DATA_DUR = japi.ABILITY_DATA_DUR
    ---@type ABILITY_DATA
    ---技能数据 (实数): 持续时间 - 英雄<br>
    ---来源: ydjapi
    ABILITY_DATA_HERODUR = japi.ABILITY_DATA_HERODUR
    ---@type ABILITY_DATA
    ---技能数据 (整数): 魔法消耗<br>
    ---来源: ydjapi
    ABILITY_DATA_COST = japi.ABILITY_DATA_COST
    ---@type ABILITY_DATA
    ---技能数据 (实数): 冷却时间<br>
    ---来源: ydjapi
    ABILITY_DATA_COOL = japi.ABILITY_DATA_COOL
    ---@type ABILITY_DATA
    ---技能数据 (实数): 影响区域<br>
    ---来源: ydjapi
    ABILITY_DATA_AREA = japi.ABILITY_DATA_AREA
    ---@type ABILITY_DATA
    ---技能数据 (实数): 施法距离<br>
    ---来源: ydjapi
    ABILITY_DATA_RNG = japi.ABILITY_DATA_RNG
    ---@type ABILITY_DATA
    ---技能数据 (实数): 数据A<br>
    ---来源: ydjapi
    ABILITY_DATA_DATA_A = japi.ABILITY_DATA_DATA_A
    ---@type ABILITY_DATA
    ---技能数据 (实数): 数据B<br>
    ---来源: ydjapi
    ABILITY_DATA_DATA_B = japi.ABILITY_DATA_DATA_B
    ---@type ABILITY_DATA
    ---技能数据 (实数): 数据C<br>
    ---来源: ydjapi
    ABILITY_DATA_DATA_C = japi.ABILITY_DATA_DATA_C
    ---@type ABILITY_DATA
    ---技能数据 (实数): 数据D<br>
    ---来源: ydjapi
    ABILITY_DATA_DATA_D = japi.ABILITY_DATA_DATA_D
    ---@type ABILITY_DATA
    ---技能数据 (实数): 数据E<br>
    ---来源: ydjapi
    ABILITY_DATA_DATA_E = japi.ABILITY_DATA_DATA_E
    ---@type ABILITY_DATA
    ---技能数据 (实数): 数据F<br>
    ---来源: ydjapi
    ABILITY_DATA_DATA_F = japi.ABILITY_DATA_DATA_F
    ---@type ABILITY_DATA
    ---技能数据 (实数): 数据G<br>
    ---来源: ydjapi
    ABILITY_DATA_DATA_G = japi.ABILITY_DATA_DATA_G
    ---@type ABILITY_DATA
    ---技能数据 (实数): 数据H<br>
    ---来源: ydjapi
    ABILITY_DATA_DATA_H = japi.ABILITY_DATA_DATA_H
    ---@type ABILITY_DATA
    ---技能数据 (实数): 数据I<br>
    ---来源: ydjapi
    ABILITY_DATA_DATA_I = japi.ABILITY_DATA_DATA_I
    ---@type ABILITY_DATA
    ---技能数据 (整数): 召唤单位类型<br>
    ---来源: ydjapi
    ABILITY_DATA_UNITID = japi.ABILITY_DATA_UNITID
    ---@type ABILITY_DATA
    ---技能数据 (整数): 热键 - 普通<br>
    ---来源: ydjapi
    ABILITY_DATA_HOTKET = japi.ABILITY_DATA_HOTKET
    ---@type ABILITY_DATA
    ---技能数据 (整数): 热键 - 关闭<br>
    ---来源: ydjapi
    ABILITY_DATA_UNHOTKET = japi.ABILITY_DATA_UNHOTKET
    ---@type ABILITY_DATA
    ---技能数据 (整数): 热键 - 学习<br>
    ---来源: ydjapi
    ABILITY_DATA_RESEARCH_HOTKEY = japi.ABILITY_DATA_RESEARCH_HOTKEY
    ---@type ABILITY_DATA
    ---技能数据 (字符串): 名称<br>
    ---来源: ydjapi
    ABILITY_DATA_NAME = japi.ABILITY_DATA_NAME
    ---@type ABILITY_DATA
    ---技能数据 (字符串): 图标 - 普通<br>
    ---来源: ydjapi
    ABILITY_DATA_ART = japi.ABILITY_DATA_ART
    ---@type ABILITY_DATA
    ---技能数据 (字符串): 效果 - 目标<br>
    ---来源: ydjapi
    ABILITY_DATA_TARGET_ART = japi.ABILITY_DATA_TARGET_ART
    ---@type ABILITY_DATA
    ---技能数据 (字符串): 效果 - 施法者<br>
    ---来源: ydjapi
    ABILITY_DATA_CASTER_ART = japi.ABILITY_DATA_CASTER_ART
    ---@type ABILITY_DATA
    ---技能数据 (字符串): 效果 - 目标点<br>
    ---来源: ydjapi
    ABILITY_DATA_EFFECT_ART = japi.ABILITY_DATA_EFFECT_ART
    ---@type ABILITY_DATA
    ---技能数据 (字符串): 区域持续效果?<br>
    ---来源: ydjapi
    ABILITY_DATA_AREAEFFECT_ART = japi.ABILITY_DATA_AREAEFFECT_ART
    ---@type ABILITY_DATA
    ---技能数据 (字符串): 投射物图像<br>
    ---来源: ydjapi
    ABILITY_DATA_MISSILE_ART = japi.ABILITY_DATA_MISSILE_ART
    ---@type ABILITY_DATA
    ---技能数据 (字符串): 效果 - 特殊<br>
    ---来源: ydjapi
    ABILITY_DATA_SPECIAL_ART = japi.ABILITY_DATA_SPECIAL_ART
    ---@type ABILITY_DATA
    ---技能数据 (字符串): 闪电效果<br>
    ---来源: ydjapi
    ABILITY_DATA_LIGHTNING_EFFECT = japi.ABILITY_DATA_LIGHTNING_EFFECT
    ---@type ABILITY_DATA
    ---技能数据 (字符串): 魔法效果的提示工具 - 普通?<br>
    ---来源: ydjapi
    ABILITY_DATA_BUFF_TIP = japi.ABILITY_DATA_BUFF_TIP
    ---@type ABILITY_DATA
    ---技能数据 (字符串): 魔法效果的提示工具 - 扩展?<br>
    ---来源: ydjapi
    ABILITY_DATA_BUFF_UBERTIP = japi.ABILITY_DATA_BUFF_UBERTIP
    ---@type ABILITY_DATA
    ---技能数据 (字符串): 提示工具 - 学习<br>
    ---来源: ydjapi
    ABILITY_DATA_RESEARCH_TIP = japi.ABILITY_DATA_RESEARCH_TIP
    ---@type ABILITY_DATA
    ---技能数据 (字符串): 提示工具 - 普通<br>
    ---来源: ydjapi
    ABILITY_DATA_TIP = japi.ABILITY_DATA_TIP
    ---@type ABILITY_DATA
    ---技能数据 (字符串): 提示工具 - 关闭<br>
    ---来源: ydjapi
    ABILITY_DATA_UNTIP = japi.ABILITY_DATA_UNTIP
    ---@type ABILITY_DATA
    ---技能数据 (字符串): 提示工具 - 学习 - 扩展<br>
    ---来源: ydjapi
    ABILITY_DATA_RESEARCH_UBERTIP = japi.ABILITY_DATA_RESEARCH_UBERTIP
    ---@type ABILITY_DATA
    ---技能数据 (字符串): 提示工具 - 扩展<br>
    ---来源: ydjapi
    ABILITY_DATA_UBERTIP = japi.ABILITY_DATA_UBERTIP
    ---@type ABILITY_DATA
    ---技能数据 (字符串): 提示工具 - 关闭 - 扩展<br>
    ---来源: ydjapi
    ABILITY_DATA_UNUBERTIP = japi.ABILITY_DATA_UNUBERTIP
    ---@type ABILITY_DATA
    ---技能数据 (字符串): 图标 - 关闭<br>
    ---来源: ydjapi
    ABILITY_DATA_UNART = japi.ABILITY_DATA_UNART



    --@alias ABILITY_STATE integer

    ---@type ABILITY_STATE
    ---技能属性: 冷却时间<br>
    ---来源: ydjapi
    ABILITY_STATE_COOLDOWN = japi.ABILITY_STATE_COOLDOWN



    --@alias CHAT_RECIPIENT integer

    ---@type CHAT_RECIPIENT
    ---聊天频道: 所有人<br>
    ---来源: ydjapi
    CHAT_RECIPIENT_ALL = japi.CHAT_RECIPIENT_ALL
    ---@type CHAT_RECIPIENT
    ---聊天频道: 盟友<br>
    ---来源: ydjapi
    CHAT_RECIPIENT_ALLIES = japi.CHAT_RECIPIENT_ALLIES
    ---@type CHAT_RECIPIENT
    ---聊天频道: 观看者<br>
    ---来源: ydjapi
    CHAT_RECIPIENT_OBSERVERS = japi.CHAT_RECIPIENT_OBSERVERS
    ---@type CHAT_RECIPIENT
    ---聊天频道: 裁判<br>
    ---来源: ydjapi
    CHAT_RECIPIENT_REFEREES = japi.CHAT_RECIPIENT_REFEREES
    ---@type CHAT_RECIPIENT
    ---聊天频道: 私人的<br>
    ---来源: ydjapi
    CHAT_RECIPIENT_PRIVATE = japi.CHAT_RECIPIENT_PRIVATE



    --@alias EVENT_DAMAGE_DATA integer

    ---@type EVENT_DAMAGE_DATA
    ---伤害事件数据: 伤害数据有效<br>
    ---来源: ydjapi
    EVENT_DAMAGE_DATA_VAILD = japi.EVENT_DAMAGE_DATA_VAILD
    ---@type EVENT_DAMAGE_DATA
    ---伤害事件数据: 是物理伤害<br>
    ---来源: ydjapi
    EVENT_DAMAGE_DATA_IS_PHYSICAL = japi.EVENT_DAMAGE_DATA_IS_PHYSICAL
    ---@type EVENT_DAMAGE_DATA
    ---伤害事件数据: 是攻击伤害<br>
    ---来源: ydjapi
    EVENT_DAMAGE_DATA_IS_ATTACK = japi.EVENT_DAMAGE_DATA_IS_ATTACK
    ---@type EVENT_DAMAGE_DATA
    ---伤害事件数据: 是远程伤害<br>
    ---来源: ydjapi
    EVENT_DAMAGE_DATA_IS_RANGED = japi.EVENT_DAMAGE_DATA_IS_RANGED
    ---@type EVENT_DAMAGE_DATA
    ---伤害事件数据: 伤害类型<br>
    ---来源: ydjapi
    EVENT_DAMAGE_DATA_DAMAGE_TYPE = japi.EVENT_DAMAGE_DATA_DAMAGE_TYPE
    ---@type EVENT_DAMAGE_DATA
    ---伤害事件数据: 武器类型<br>
    ---来源: ydjapi
    EVENT_DAMAGE_DATA_WEAPON_TYPE = japi.EVENT_DAMAGE_DATA_WEAPON_TYPE
    ---@type EVENT_DAMAGE_DATA
    ---伤害事件数据: 攻击类型<br>
    ---来源: ydjapi
    EVENT_DAMAGE_DATA_ATTACK_TYPE = japi.EVENT_DAMAGE_DATA_ATTACK_TYPE



    --@alias YDWE_OBJECT_TYPE integer

    ---@type YDWE_OBJECT_TYPE
    ---slk表: 技能<br>
    ---来源: ydjapi
    YDWE_OBJECT_TYPE_ABILITY = japi.YDWE_OBJECT_TYPE_ABILITY
    ---@type YDWE_OBJECT_TYPE
    ---slk表: 魔法效果<br>
    ---来源: ydjapi
    YDWE_OBJECT_TYPE_BUFF = japi.YDWE_OBJECT_TYPE_BUFF
    ---@type YDWE_OBJECT_TYPE
    ---slk表: 单位<br>
    ---来源: ydjapi
    YDWE_OBJECT_TYPE_UNIT = japi.YDWE_OBJECT_TYPE_UNIT
    ---@type YDWE_OBJECT_TYPE
    ---slk表: 物品<br>
    ---来源: ydjapi
    YDWE_OBJECT_TYPE_ITEM = japi.YDWE_OBJECT_TYPE_ITEM
    ---@type YDWE_OBJECT_TYPE
    ---slk表: 科技<br>
    ---来源: ydjapi
    YDWE_OBJECT_TYPE_UPGRADE = japi.YDWE_OBJECT_TYPE_UPGRADE
    ---@type YDWE_OBJECT_TYPE
    ---slk表: 装饰物<br>
    ---来源: ydjapi
    YDWE_OBJECT_TYPE_DOODAD = japi.YDWE_OBJECT_TYPE_DOODAD
    ---@type YDWE_OBJECT_TYPE
    ---slk表: 可破坏物<br>
    ---来源: ydjapi
    YDWE_OBJECT_TYPE_DESTRUCTABLE = japi.YDWE_OBJECT_TYPE_DESTRUCTABLE
end

table.setmode(Constant, "v")

return Constant
    