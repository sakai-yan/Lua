local Jass = require "Lib.API.Jass"
local Constant = require "Lib.API.Constant"
local Class = require "Lib.Base.Class"
local DataType = require "Lib.Base.DataType"
local Queue = require "Lib.Base.Queue"
local Vector3 = require "Lib.Base.Vector3"
local AttachPosition = require "FrameWork.GameSetting.AttachPosition"


local MHEffect_SetPosition = Jass.MHEffect_SetPosition
local MHEffect_SetZ = Jass.MHEffect_SetZ
local MHEffect_BindToWidget = Jass.MHEffect_BindToWidget
local MHEffect_Unbind = Jass.MHEffect_Unbind
local MHEffect_ResetMatrix = Jass.MHEffect_ResetMatrix
local MHEffect_Hide = Jass.MHEffect_Hide
local AddSpecialEffect = Jass.AddSpecialEffect
local AddSpecialEffectTarget = Jass.AddSpecialEffectTarget

local model_modify = Class.modify_field("model")
local roll_modify = Class.modify_field("roll")
local pitch_modify = Class.modify_field("pitch")
local yaw_modify = Class.modify_field("yaw")
local scale_modify = Class.modify_field("scale")
local team_color_modify = Class.modify_field("team_color")
local team_glow_modify = Class.modify_field("team_glow")
local alpha_modify = Class.modify_field("alpha")
local color_modify = Class.modify_field("color")
local animation_speed_modify = Class.modify_field("animation_speed")
local vector_modify = Class.modify_field("vector")
local particle_scale_modify = Class.modify_field("particle_scale")

--特效类
local Effect
Effect = Class("Effect", {

    --存放所有effect实例，强引用，用于保证不被回收
    __effects = {},

    --以handle为索引获取effect
    __effects_by_handle = table.setmode({}, "kv"),

    --特效句柄池
    __handle_pool = {},

    --获取特效
    ---@usage Effect.new({model = "path_str", x = 100.0, y = 100.0, z = 100.0})
    ---@usage Effect.new({model = "path_str", bind_object = unit, attach_position = "origin"})
    __constructor__ = function (class, config)
        if __DEBUG__ then
            assert(type(config.model) == "string", "Effect.new:model must be a string")
            if (config.x and config.y and config.z) then
                assert(type(config.x) == "number", "Effect.new:x must be a number")
                assert(type(config.y) == "number", "Effect.new:y must be a number")
                assert(type(config.z) == "number", "Effect.new:z must be a number")
            elseif config.bind_object then
                assert(type(config.bind_object) == "table", "Effect.new:bind_object must be a table")
                assert(type(config.attach_position) == "string", "Effect.new:attach_position must be a string")
            else
                error("Effect.new:参数必须有x、y、z或需要绑定的物体")
            end
        end

        local pool = class.__handle_pool[config.model]
        if not pool then
            pool = Queue.new()
            class.__handle_pool[config.model] = pool
        end

        local effect = config or {
            handle = false
        }

        effect.handle = pool:popleft()
        if not effect.handle then
            --另一种实现是统一创建到坐标，然后再绑
            if effect.bind_object then
                AddSpecialEffectTarget(effect.model, effect.bind_object, effect.attach_position)
            else
                AddSpecialEffect(effect.model, effect.x or 0.0, effect.y or 0.0)
                MHEffect_SetZ(effect.handle, effect.z or 0.0)
            end
        else
            MHEffect_Hide(effect.handle, false)
            if effect.bind_object then
                MHEffect_BindToWidget(effect.handle, effect.bind_object, effect.attach_position)
            else
                MHEffect_SetPosition(effect.handle, effect.x or 0.0, effect.y or 0.0, effect.z or 0.0)
            end
        end
        
        effect.x = nil
        effect.y = nil
        effect.z = nil
        effect.model = nil

        class.__effects_by_handle[effect.handle] = DataType.set(effect, "effect")
        class.__effects:add(effect)

        return effect
    end,

    __newinstance__ = function (meta, class, config)
        return class.__constructor__(class, config)
    end,

    ---@usage Effect.destroy(effect) / effect:destroy()
    __del__ = function (class, effect)
        if __DEBUG__ then
            assert(DataType.get(effect) == "effect", "Effect.destroy:param must be effect")
            assert(type(effect.model) == "string", "Effect.destroy:model must be string")
        end

        local effect_handle = effect.handle

        if effect_handle then
            local pool = class.__handle_pool[effect.model]
            if not pool then
                pool = Queue.new()
                class.__handle_pool[effect.model] = pool
            end
            pool:append(effect_handle)

            --解除绑定
            if effect.bind_object then
                MHEffect_Unbind(effect_handle)
            end

            --重置大小方向
            MHEffect_ResetMatrix(effect_handle)
            --隐藏特效
            MHEffect_Hide(effect_handle, true)

            class.__effects_by_handle[effect_handle] = nil
            effect.handle = nil
        end

        class.__effects:discard(effect)
    end,

    --选取圆形范围内特效
    enumInRange = function (effect, x, y, action)
        if __DEBUG__ then
            assert(type(x) == "number" and type(y) == "number", "Effect.enumInRange:参数类型错误")
            assert(type(action) == "function", "Effect.enumInRange:action应为函数")
        end
        Jass.MHEffect_EnumInRange(effect.handle, x, y, action)
    end,

    --获取选取的特效
    getEnumEffect = function ()
        local effect_handle = Jass.MHEffect_GetEnumEffect()
        if effect_handle then
            return Effect.__effects_by_handle[effect_handle]
        end
        return nil
    end,

    __attributes__ = {
        ---@模型 string
        ---@usage effect.model = "model"
        ---@usage local model = effect.model
        {
            name = "model",
            get = function (effect)
                return rawget(effect, model_modify)
            end,
            set = function (effect, model)
                Jass.MHEffect_SetModel(effect.handle, model, false)
                rawset(effect, model_modify, model)
            end
        },

        ---@x坐标 number
        ---@usage effect.x = 100
        ---@usage local x = effect.x
        {
            name = "x",
            get = function (effect)
                return Jass.MHEffect_GetX(effect.handle)
            end,
            set = function (effect, value)
                Jass.MHEffect_SetX(effect, value)
            end
        },

        ---@y坐标 number
        ---@usage effect.y = 100
        ---@usage local y = effect.y
        {
            name = "y",
            get = function (effect)
                return Jass.MHEffect_GetY(effect.handle)
            end,
            set = function (effect, value)
                Jass.MHEffect_SetY(effect, value)
            end
        },

        ---@z坐标
        ---@usage effect.z = 100
        ---@usage local z = effect.z
        {
            name = "z",
            get = function (effect)
                return Jass.MHEffect_GetZ(effect.handle)
            end,
            set = function (effect, value)
                Jass.MHEffect_SetZ(effect, value)
            end
        },

        ---@横滚角 number 多次调用会累加。绕X轴转角 (角度制)
        ---@usage effect.roll = 100
        ---@usage local roll = effect.roll
        {
            name = "roll",
            get = function (effect)
                return rawget(effect, roll_modify)
            end,
            set = function (effect, roll_value)
                Jass.MHEffect_SetRoll(effect.handle, roll_value)
                rawset(effect, roll_modify, roll_value)
            end
        },

        ---@俯仰角 number 多次调用会累加。绕y轴转角 (角度制)
        ---@usage effect.pitch = 100
        ---@usage local pitch = effect.pitch
        {
            name = "pitch",
            get = function (effect)
                return rawget(effect, pitch_modify)
            end,
            set = function (effect, pitch_value)
                Jass.MHEffect_SetPitch(effect.handle, pitch_value)
                rawset(effect, pitch_modify, pitch_value)
            end
        },

        ---@偏航角 number 多次调用会累加。绕z轴转角 (角度制)
        ---@usage effect.yaw = 100
        ---@usage local yaw = effect.yaw
        {
            name = "yaw",
            get = function (effect)
                return rawget(effect, yaw_modify)
            end,
            set = function (effect, yaw_value)
                Jass.MHEffect_SetYaw(effect.handle, yaw_value)
                rawset(effect, yaw_modify, yaw_value)
            end
        },

        ---@自转角 number 多次调用会累加。右手螺旋定则 (角度制)
        ---@usage effect.rotate = 100
        ---@usage local rotate = effect.rotate
        {
            name = "rotate",
            get = function (effect)
                return Jass.MHEffect_Rotation(effect.handle)
            end,
            set = function (effect, rotate_value)
                Jass.MHEffect_Rotate(effect.handle, rotate_value)
            end
        },

        ---@缩放 number
        ---@usage effect.scale = 100
        ---@usage local scale = effect.scale
        {
            name = "scale",
            get = function (effect)
                return rawget(effect, scale_modify)
            end,
            set = function (effect, scale)
                Jass.MHEffect_SetScale(effect.handle, scale)
                rawset(effect, scale_modify, scale)
            end
        },

        ---@粒子缩放 number 多次设置会乘算叠加
        ---@usage effect.particle_scale = 100
        ---@usage local particle_scale = effect.particle_scale
        {
            name = "particle_scale",
            get = function (effect)
                return rawget(effect, particle_scale_modify)
            end,
            set = function (effect, particle_scale)
                Jass.MHEffect_SetParticleScale(effect.handle, particle_scale)
                rawset(effect, particle_scale_modify, particle_scale)
            end
        },

        ---@显示 boolean
        ---@usage effect.is_show = true
        ---@usage local is_show = effect.is_show
        {
            name = "is_show",
            get = function (effect)
                return not Jass.MHEffect_IsHidden(effect.handle)
            end,
            set = function (effect, show)
                Jass.MHEffect_Hide(effect.handle, not show)
            end
        },

        ---@队伍颜色 playercolor
        ---@usage effect.team_color = Player._player_color.RED
        ---@usage local team_color = effect.team_color
        {
            name = "team_color",
            get = function (effect)
                return rawget(effect, team_color_modify)
            end,
            set = function (effect, team_color)
                Jass.MHEffect_SetTeamColor(effect.handle, team_color)
                rawset(effect, team_color_modify, team_color)
            end
        },

        ---@队伍光晕 playercolor
        ---@usage effect.team_glow = Player._player_color.RED
        ---@usage local team_glow = effect.team_glow
        {
            name = "team_glow",
            get = function (effect)
                return rawget(effect, team_glow_modify)
            end,
            set = function (effect, team_glow)
                Jass.MHEffect_SetTeamGlow(effect.handle, team_glow)
                rawset(effect, team_glow_modify, team_glow)
            end
        },

        ---@透明度 integer
        ---@usage effect.alpha = 100
        ---@usage local alpha = effect.alpha
        {
            name = "alpha",
            get = function (effect)
                return rawget(effect, alpha_modify)
            end,
            set = function (effect, alpha)
                Jass.MHEffect_SetAlpha(effect.handle, alpha)
                rawset(effect, alpha_modify, alpha)
            end
        },

        ---@颜色 integer 16进制颜色代码。例如0xFFFF0000表示不透明红色
        ---@usage effect.color = 0xFFFF0000
        ---@usage local color = effect.color
        {
            name = "color",
            get = function (effect)
                return rawget(effect, color_modify)
            end,
            set = function (effect, color)
                Jass.MHEffect_SetColor(effect.handle, color)
                rawset(effect, color_modify, color)
            end
        },

        ---@动画进度 number 0~1
        ---@usage effect.animation_progress = 0.5
        ---@usage local animation_progress = effect.animation_progress
        {
            name = "animation_progress",
            get = function (effect)
                return Jass.MHEffect_GetAnimationProgress(effect.handle)
            end,
            set = function (effect, progress)
                Jass.MHEffect_SetAnimationProgress(effect.handle, progress)
            end
        },

        ---@动画播放速度 number
        ---@usage effect.animation_speed = 1.0
        ---@usage local animation_speed = effect.animation_speed
        {
            name = "animation_speed",
            get = function (effect)
                return rawget(effect, animation_speed_modify)
            end,
            set = function (effect, animation_speed)
                Jass.MHEffect_SetTimeScale(effect.handle, animation_speed)
                rawset(effect, animation_speed_modify, animation_speed)
            end
        },

        ---@方向向量 Vector3 (1, 0, 0) 表示初始方向 (正东)。不需要归一化
        ---@usage effect.vector = Vector3.new(1.0, 0.0, 0.0)
        ---@usage local vector = effect.vector
        {
            name = "vector",
            get = function (effect)
                return rawget(effect, vector_modify)
            end,
            set = function (effect, vector)
                local x, y, z = Vector3.get(vector)
                Jass.MHEffect_SetVector(effect.handle, x, y, z)
                rawset(effect, vector_modify, vector)
            end
        }
    },

    _animation_types = {
        -- 动画类型 - 出生(估计包含训练完成、创建、召唤)
        birth = Constant.ANIMATION_TYPE_BIRTH,
        -- 动画类型 - 死亡
        death = Constant.ANIMATION_TYPE_DEATH,
        -- 动画类型 - 腐烂
        decay = Constant.ANIMATION_TYPE_DECAY,
        -- 动画类型 - 英雄消散
        dissipate = Constant.ANIMATION_TYPE_DISSIPATE,
        -- 动画类型 - 站立
        stand = Constant.ANIMATION_TYPE_STAND,
        -- 动画类型 - 行走
        walk = Constant.ANIMATION_TYPE_WALK,
        -- 动画类型 - 攻击
        attack = Constant.ANIMATION_TYPE_ATTACK,
        -- 动画类型 - 变身
        morph = Constant.ANIMATION_TYPE_MORPH,
        -- 动画类型 - 睡眠
        sleep = Constant.ANIMATION_TYPE_SLEEP,
        -- 动画类型 - 施法
        spell = Constant.ANIMATION_TYPE_SPELL,
        -- 动画类型 - 头像视窗
        portrait = Constant.ANIMATION_TYPE_PORTRAIT,
    }
})

--设置特效位置
function Effect.setPosition(effect, x, y, z)
    Jass.MHEffect_SetPosition(effect.handle, x, y, z)
end

function Effect.getPosition(effect)
    local effect_handle = effect.handle
    return Jass.MHEffect_GetX(effect_handle), Jass.MHEffect_GetY(effect_handle), Jass.MHEffect_GetZ(effect_handle)
end

--设置特效朝向
---@param effect table Effect对象
---@param target_x number 目标x坐标
---@param target_y number 目标y坐标
---@param target_z number 目标z坐标
function Effect.setFacing(effect, target_x, target_y, target_z)
    Jass.MHEffect_Towards(effect.handle, target_x, target_y, target_z)
end

--将特效按某一平面镜像
---@param effect table Effect对象
---@param axis MIRROR_AXIS
function Effect.Mirror(effect, axis)
    Jass.MHEffect_SetMirror(effect.handle, axis)
end

--重置大小和方向
function Effect.resetMatrix(effect)
    Jass.MHEffect_ResetMatrix(effect.handle)
end

--根据动画名设置动画
---@param animation_name string 动画名
---@param attachment string 附加链接动画名。一般不填
function Effect.setAnimationByName(effect, animation_name, attachment)
    Jass.MHEffect_SetAnimationByName(effect.handle, animation_name, attachment)
end

--根据动画类型设置动画
---@param animation_type integer 动画类型 例如：Effect._animation_types.birth
---@param is_looping boolean 是否循环
function Effect.setAnimationByType(effect, animation_type, is_looping)
    Jass.MHEffect_SetAnimationByType(effect.handle, animation_type, is_looping)
end

--根据动画索引设置动画
---@param index integer 动画索引
function Effect.setAnimationByIndex(effect, index)
    Jass.MHEffect_SetAnimation(effect.handle, index, 0)
end

--绑定到单位、物品、可破坏物
---@param effect table Effect对象
---@param widget table Unit、Item、Destructable对象
---@param attach_position string 绑定位置
function Effect.bindToWidget(effect, widget, attach_position)
    if __DEBUG__ then
        assert(DataType.get(effect) == "effect", "Effect.bindToEffect:param must be effect")
        assert(DataType.get(widget) == "unit" or DataType.get(widget) == "item", "Effect.bindToEffect:widget must be effect")
        assert(type(attach_position) == "string", "Effect.bindToEffect:attach_position must be string")
        assert(AttachPosition.verify(attach_position), "Effect.bindToEffect:attach_position error")
    end
    Jass.MHEffect_BindToWidget(effect.handle, widget.handle, attach_position)
end


--绑定到特效
---@param effect_target table Effect对象
function Effect.bindToEffect(effect, effect_target, attach_position)
    if __DEBUG__ then
        assert(DataType.get(effect) == "effect", "Effect.bindToEffect:param must be effect")
        assert(DataType.get(effect_target) == "effect", "Effect.bindToEffect:effect_target must be effect")
        assert(type(attach_position) == "string", "Effect.bindToEffect:attach_position must be string")
        assert(AttachPosition.verify(attach_position), "Effect.bindToEffect:attach_position error")
    end
    Jass.MHEffect_BindToEffect(effect.handle, effect_target.handle, attach_position)
end

--绑定到特效 仅支持Sprite和Portrait
---@param frame_target table Sprite、Portrait对象
function Effect.bindToFrame(effect, frame_target, attach_position)
    if __DEBUG__ then
        assert(DataType.get(effect) == "effect", "Effect.bindToEffect:param must be effect")
        assert(DataType.get(frame_target) == "sprite" or DataType.get(frame_target) == "portrait", "Effect.bindToEffect:frame_target must be effect")
        assert(type(attach_position) == "string", "Effect.bindToEffect:attach_position must be string")
        assert(AttachPosition.verify(attach_position), "Effect.bindToEffect:attach_position error")
    end
    Jass.MHEffect_BindToFrame(effect.handle, frame_target.handle, attach_position)
end

--解绑
function Effect.unBind(effect)
    if __DEBUG__ then
        assert(DataType.get(effect) == "effect", "Effect.unBind:param must be effect")
    end
    Jass.MHEffect_UnBind(effect.handle)
end


return Effect
