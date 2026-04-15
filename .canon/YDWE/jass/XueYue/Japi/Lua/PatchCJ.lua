----------------------------------------
--    Common Jass Patch  by 雪月灬雪歌
----------------------------------------

--[[
        使用方法 与 Harmony 类似

        一般遵守几个原则
        1.前置补丁不返回值[保证原函数执行]
        2.后置补丁如果需要改动返回值，请排泄掉原返回值

    --前置补丁： 一般return __result
    --当你返回了结果时，将不会执行原方法
    --对于本就没有返回值的函数需要在patch后调用元方法:NoReturnValue(),然后返回true表示拦截
    patch( 'UnitId' ):PreFix ( function ( __result, x )

        return __result
    end ) 

    --后置补丁: 在prefix 以及原方法执行给出返回值后
    patch( 'UnitId' ):PostFix ( function ( __result, x )

        return __result
    end ) 

    所以如果你不需要对返回值发生更改的话，完全可以return nil

]]
if patch then
    return
end

local hook = require 'jass.hook'
local cj = require 'jass.common'
local ipairs = ipairs
local setmetatable = setmetatable

--已补丁的函数
local patched = {
    
}


local mt = {

}
mt.__index = mt

---@class mPatch_jass cj Patch 模块 通过直接调用，传入函数名，返回一个patch类实例
local mPatch = {
    
}
setmetatable(mPatch, mt)
patch = mPatch

---@class cPatch_jass cj Patch 类
local cPatch = {

}


---@return patch_jass
function mt:__call( funcName )
    local patchClass = patched[funcName]
    if patchClass then
        return patchClass
    end

    local patchs_preFix = table.new()
    local patchs_postFix = table.new()
    ---@class patch_jass : cPatch_jass
    local t = {
        patchs_preFix = patchs_preFix,
        patchs_postFix = patchs_postFix,
        isNoReturnValue = false,

        funcName = funcName,
        real = cj[funcName] or _G[funcName],
        fake = hook[funcName],
    }

    setmetatable(t, { __index = cPatch } )

    patched[funcName] = t

    t.patch = function (...)
        local __result

        for _, patchFunc in ipairs(patchs_preFix) do
            __result = patchFunc(__result, ...)
        end

        if t.isNoReturnValue then
            --无返回值函数 __result则表示是否拦截原函数
            if not __result then


                if t.fake then
                    t.fake(...)
                else
                    t.real(...)
                end


            end
            __result = nil
        else
            --具有返回值的函数 __result则直接表示返回值

            --缺失返回值
            if __result == nil then

                if t.fake then
                    __result = t.fake(...)
                else
                    __result = t.real(...)
                end

            end
        end

        for _, patchFunc in ipairs(patchs_postFix) do
            __result = patchFunc(__result, ...)
        end

        return t.isNoReturnValue and nil or __result
    end
    hook[funcName] = t.patch
    return t
end

---@param self patch_jass
function cPatch:NoReturnValue( )
    self.isNoReturnValue = true
    return self
end

---@param self patch_jass
function cPatch:PreFix( func )
    self.patchs_preFix:insert( func )
    return self
end

---@param self patch_jass
function cPatch:PostFix( func )
    self.patchs_postFix:insert( func )
    return self
end

---@param self patch_jass
function cPatch:del(  )
    local now = hook[ self.funcName ]
    --检查是否是当前patch类所补丁
    if now ~= patch then
        return
    end
    -- 还原hook
    hook[ self.funcName ] = self.fake
    local mt =  getmetatable(self)
    mt.__mode = "kv"
    mt.__index = nil
end
