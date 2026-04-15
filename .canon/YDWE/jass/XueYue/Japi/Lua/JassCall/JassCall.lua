local XGJAPI = XGJAPI
local japi = require 'jass.japi'
local cj = require 'jass.common'
local jdebug = require 'jass.debug'
local hook = require 'jass.hook'
---@type fun(frameType:string, name:string, parent:integer, template:string, id:integer):integer
local DzCreateFrameByTagName = japi.DzCreateFrameByTagName

---@type fun(frame:integer, eventId:integer, xfuncHandle:code, sync:boolean):nil
local DzFrameSetScriptByCode = japi.DzFrameSetScriptByCode
---@type fun( frame:integer ):nil
local DzClickFrame = japi.DzClickFrame
local DzConvertWorldPosition = japi.DzConvertWorldPosition

local GameUI = japi.DzGetGameUI()
local DzDestroyFrame = japi.DzDestroyFrame
local type = type

local registeredFunc = {} -- code -> func name
local registeredFuncName = {} -- func name -> code
local triggers = {} -- func name -> trigger
local mainTrigger

local uuid = 0

local _trigger
local _code

Xfunc['XG_JassCall_GetTrigger'] = function ()
    print('XG_JassCall_GetTrigger', _trigger, _code)
    XGJAPI.integer[1] = _trigger
    XGJAPI.code[0] = _code
    return  _trigger
end

local function regCodeForTrigger( trigger, code )
    XGJAPI.integer[1] = trigger
    XGJAPI.code[0] = code
    _trigger = trigger
    _code = code
    DzClickFrame(mainTrigger)
end

---@alias JassCallRegisterCode
---|0 OK (成功)
---|1 Failed (失败)
---|2 InvalidCode (无效代码)
---|3 AlreadyRegistered (已注册)

---@return JassCallRegisterCode
local register = function ( funcName, code )
    if code == nil or type(code) ~= "number" or code == 0 then
        return 2 -- invalid code
    end
    if registeredFunc[code] then
        return 3 -- already registered
    end
    uuid = uuid + 1
    local TriggerName = 'XG_JassCall_' .. funcName .. '_' .. uuid
    local codeTrigger = DzCreateFrameByTagName( 'TEXT', TriggerName, GameUI, 'template', 0 )
    if codeTrigger == nil or codeTrigger == 0 then
        return 1 -- failed
    end
    DzFrameSetScriptByCode( codeTrigger, 1, code, false )

    registeredFunc[code] = funcName
    registeredFuncName[funcName] = code
    triggers[funcName] = codeTrigger

    return 0 -- ok
end

Xfunc['XG_JassCall_RegisterWithLua'] = function ()
    local funcName = XGJAPI.string[1]
    local code = XGJAPI.code[0]
    XGJAPI.integer[0] = register(funcName, code)
end

---@return integer 0为未注册，非0为已注册
local getCode = function ( funcName )
    return registeredFuncName[funcName] or 0
end

local callRegisterCode = function ( funcName )
    local trigger = triggers[funcName]
    if not trigger then
        return 0
    end
    DzClickFrame(trigger)
    return 1
end

-- 一次性匿名调用
---@return JassCallRegisterCode
local call = function ( code )
    if code == nil or type(code) ~= "number" or code == 0 then
        return 2 -- invalid code
    end
    uuid = uuid + 1
    XGJAPI.code[0] = code
    xpcall(cj.TriggerEvaluate,
        function (msg)
            print('error', msg, debug.traceback('',4))
        end,
        mainTrigger
    )

    --local TriggerName = 'XG_JassCall_' .. 'Anonymous' .. '_' .. uuid
    --local codeTrigger =  DzCreateFrameByTagName( 'TEXT', TriggerName, GameUI, 'template', 0 )

    if codeTrigger == nil or codeTrigger == 0 then
        return 1 -- failed
    end

    --[[DzFrameSetScriptByCode( codeTrigger, 1, XGJAPI.code[0], false )
    xpcall(DzFrameSetScriptByCode,
        function (msg)
            print('error', msg, debug.traceback('',4))
        end,
        codeTrigger, 1, XGJAPI.code[0], false
    )
    ]]
    --print( 'call anonymous' , TriggerName, codeTrigger, code)
    --regCodeForTrigger(codeTrigger, code)
    --DzClickFrame(codeTrigger)

    --DzDestroyFrame(codeTrigger)

    return 0
end

local cacheCode = {}

Xfunc['XG_JassCall_C2I'] = function ()
    local code = XGJAPI.code[0]

    if cacheCode[code] then
        XGJAPI.integer[0] = 0
        return
    end

    cacheCode[code] = code
    XGJAPI.integer[0] = code

end

Xfunc['XG_JassCall_I2C'] = function ()
    local code = XGJAPI.integer[1]
    if code == nil or code == 0 then
        XGJAPI.code[0] = XGJAPI.code['DoNothing']
        return
    end
    -- 安全检查
    if not cacheCode[code] then
        XGJAPI.code[0] = XGJAPI.code['DoNothing']
        return
    end

    XGJAPI.code[0] = code
end

Xfunc['XG_JassCall_CallByIndex'] = function ()
    local code = XGJAPI.integer[1]
    --print('call', code)
    call( code )
end

Xfunc['XG_JassCall_Init'] = function ()
    mainTrigger = XGJAPI.trigger[1]
end

return {
    register = register,
    getCode = getCode,
    callRegisterCode = callRegisterCode,
    call = call,
}