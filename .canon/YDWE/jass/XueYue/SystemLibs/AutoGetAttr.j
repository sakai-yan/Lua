#ifndef XgAutoGetAttrIncluded
#define XgAutoGetAttrIncluded
library XgAutoAttrSystem
globals
hashtable XgAutoAttrSystem_htb = InitHashtable()
endglobals
<? local slk = require "slk"
local L = require('ffi.unicode').a2u
local bak_tostring = tostring
local function tostring(s)

 if type(s) == "nil" then
   s = ""
 end
 return bak_tostring(s)
end
local bak_tonumber = tonumber
local tonumber = function (s)
 if type(s) == "nil" then
   s = 0
 end
 return bak_tonumber(s)
end
local floor,ceil = math.floor, math.ceil
local table_concat = table.concat

xg_item_attr = nil
local xg_item_attr = xg_item_attr
local map = nil
local function initAttrTable()
    xg_item_attr = {
        class = "",
        attrCount = 0,
    }
    map = {}
end
initAttrTable()
local function reset()
    local t = xg_item_attr
    xg_item_attr = {
        class = t.class,
        attrCount = 0,
    }
end

local function getRawString(str)
    str = str:gsub
    (
        "|[cC]([a-z0-9A-Z]+)",
        function(w)
            return w:sub(9) --返回多余的非颜色数值
        end
    )
    str = str:gsub('|[rR]','')
    str = str:gsub('\t','')
    str = str:gsub("\n","|n")
    str = str:gsub('%s','') --空格
    return str
end

function string.split(str, f)
    local p,arr,s,ls,le = 1,{},""
    f = f or ','
    if f == '' then return {} end

    str = str .. f

    while true do
        ls,le = str:find(f,p,true)
        if ls == nil then break end
        s = str:sub(p, ls-1) --从起始位置到分隔符
        table.insert(arr, s)
        p = le+1
    end
    return arr
end

local function parseStr_item( slk_id, maxLv, str )
    str = getRawString(str) --去除颜色空格
    local arrAttrLines = string.split(str, '|n') --按行分割

    for i, attr in ipairs(arrAttrLines) do --遍历所有属性条目
        
        for j, rule in ipairs(xg_item_attr) do --遍历所有规则
            --log.debug(rule.regexp)
            
            local attrMatchs = {attr:match(rule.regexp)} --匹配正则表达式
            
            if #attrMatchs == 0 then
                goto next_reg
            end
            local isMatched = false
            local value = attrMatchs[1]
            for k, sMatch in ipairs(attrMatchs) do --遍历所有匹配结果
                
                if sMatch:sub(1,1) == '+' then --如果匹配结果+100，则去掉+
                    sMatch = sMatch:sub(2)
                    if sMatch == '' then
                        break
                    end
                end
                --处理特殊规则
                local code = rule.code
                if code and #code > 0 then
                    for pi = 1, #attrMatchs do
                        code = code:gsub( "#" .. pi, sMatch )
                    end
                    
                    --log.debug( slk_id,   attr, code, type(code), #code )
                    local func = load("return  " .. code  )
                    if not func then error ( debug.traceback( L(("属性预读->[%s] %s :1附加规则 %s"):format( slk_id, attr, code) )) ) end
                    code = func() or ''
                    --log.debug '--'
                    local func = load("return  " .. code )
                    assert(func, debug.traceback( L(("属性预读->[%s] %s :2附加规则 %s"):format( slk_id, attr, code )) ))
                    value = func() or '0'
                    --log.debug '**'
                end
                
                local key = rule.saveKey

                if not map[slk_id] then
                    map[slk_id] = {
                        attrList = {},
                        attrValue = {},
                        map = {},
                    }
                end
                local tSlk = map[slk_id]
                --log.debug((rule.regexp) , attr, #attrMatchs, rule.saveKey)

                --属性表[物品][属性名] = 属性表[物品][属性名] + 属性值
                value = tonumber(value) + (tSlk.map[ key ] or 0)
                tSlk.map[ key ] = value
                
                --为属性做顺序化处理
                local tAttr = tSlk.attrList
                local tAttrVal = tSlk.attrValue
                -- 物品[属性key] = { 0=该属性数量   }
                if not tSlk[key] then
                    tSlk[key] = (tAttr[0] or 0) + 1
                    tAttr[0] = tSlk[key]
                end
                tAttr[tSlk[key]] = key
                tAttrVal[tSlk[key]] = value
                isMatched = true
            end
            --log.debug("breakWhenMatch", isMatched, rule.breakWhenMatch)
            if isMatched and rule.breakWhenMatch then
                
                break
            end
            ::next_reg::
        end
        
    end

    local tSlk = map[slk_id]
    local result = ""
    if tSlk and #tSlk.attrList > 0 then
        local prefixInt = "call SaveInteger(XgAutoAttrSystem_htb,'".. slk_id .."',"
        local prefixReal = "call SaveReal(XgAutoAttrSystem_htb,'".. slk_id .."',"
        result = result ..
        -- 物品[id][属性数量] = xxx
        prefixInt .. "0,".. #tSlk.attrList ..")\r\n"

        for i = 1,#tSlk.attrList do
            result = result ..
            prefixInt .. i .. "," ..tostring(tSlk.attrList[i]) .. ")\r\n"..
            prefixReal .. tostring(tSlk.attrList[i]) .. "," .. tostring(tSlk.attrValue[i]) .. ")\r\n"
        end
    end
    
    return result
end


    function XG_AutoAttr_Start_Lua()
		local result = ""
        local class = xg_item_attr["class"]
        for id, obj in pairs(slk.item) do
            if  obj.class == class or class == ''  then
                result = result .. parseStr_item(id, 1, obj.Ubertip)
            end
        end
            reset()
        return 'DoNothing()\r\n'..result
    end

    function XG_AutoAttr_SetClass_Lua(str)
        xg_item_attr["class"] = str
        return 'DoNothing()'
    end

    function XG_AutoAttr_AddAttr_Lua(sReg, nKey, v, code, breakWhenMatch)
        local n = (xg_item_attr.attrCount or 0) + 1
        xg_item_attr.attrCount = n
        xg_item_attr[n] =
        {
            ["regexp"] =  sReg,
            ["saveKey"] = nKey,
            ['code'] = code,
            breakWhenMatch = breakWhenMatch,
        }
        return 'XG_AutoAttr_AddAttr('..nKey..',"'..v..'")'
    end
 ?>

 //添加属性 key value
function XG_AutoAttr_AddAttr takes integer a, string v returns nothing
    local integer i = LoadInteger(XgAutoAttrSystem_htb, 0, 0) + 1
    call SaveInteger(XgAutoAttrSystem_htb, 0, i, a)
    //call SaveStr(XgAutoAttrSystem_htb, 0, i, v)
    //key绑定value
    call SaveStr(XgAutoAttrSystem_htb, 0, a, v)
    call SaveInteger(XgAutoAttrSystem_htb, 0, 0, i)
endfunction

//获取物品i属性数量
function XG_AutoAttr_GetAttrNum takes integer i returns integer
    return LoadInteger(XgAutoAttrSystem_htb, i, 0)
endfunction

//获取 物品i 的 第a条 属性的Key
function XG_AutoAttr_GetAttrKey takes integer i, integer a returns integer
    return LoadInteger(XgAutoAttrSystem_htb, i, a)
endfunction

//获取物品i 的 第a条 属性值
function XG_AutoAttr_GetAttrVal takes integer i,integer a returns real
    return LoadReal(XgAutoAttrSystem_htb, i, a)
endfunction

//获取key绑定的属性名
function XG_AutoAttr_GetAttrName takes integer i returns string
    return LoadStr(XgAutoAttrSystem_htb, 0, i)
endfunction



endlibrary
#endif
