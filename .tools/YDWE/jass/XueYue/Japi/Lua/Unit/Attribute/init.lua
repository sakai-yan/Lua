--[[

    unit :
        userdata = [key] 
        ...
    
    datas[key] = 
    {
        ---private
        _original = 0, --本应该存在userdata的值，被转移到此处，而userdata则被当成一个指针指向数据表

        ---public
        ...
    }
    

]]
local cj = require 'jass.common'
local SetUnitUserData = cj.SetUnitUserData
local GetUnitUserData = cj.GetUnitUserData
local traceback = debug.traceback
local XGJAPI = XGJAPI
local modf = math.modf
local pairs = pairs
local assert = assert
local type = type
local math_type = math.type

local datas = {}
local _id = 0
local idMap = {}

---通过单位获取数据ID
---@param unit unit
---@return int 失败返回0
local function getId(unit)
    local dataId = GetUnitUserData( unit )

    if dataId ~= 0 then
        if idMap[unit] then
            return dataId
        end
    end
    return 0
end

--更新数据表
local function updateUnitData_unsafe(dataId)
    datas[dataId] = {
        --原始自定义值
        _original = datas[dataId]._original,

    }

end

local function FreeData_unsafe( unit )
    local dataId = idMap[unit]
    idMap[unit] = nil
    datas[dataId] = nil
end

local function AllocData_unsafe(unit)
    _id = _id + 1
    local dataId = _id
    idMap[unit] = dataId

    datas[dataId] = {
        --原始自定义值
        _original = GetUnitUserData(unit),

    }

    SetUnitUserData( unit, dataId )

    return dataId
end

---申请一个数据ID，用以存储单位的属性数据
local function AllocDataId(unit)
    local dataId = GetUnitUserData( unit )

    if dataId ~= 0 then
        if idMap[unit] then
            return dataId
        end
    end

    return AllocData_unsafe(unit)
end

patch( 'SetUnitUserData' ):NoReturnValue():PreFix(
    function( __result, unit, value )
        assert( type(value) == 'number', traceback( '单位自定义值必须为数字' ) )
        local dataId = AllocDataId(unit)
        local data = datas[dataId]
        data._original = value

        return true --拦截
    end
)

patch( 'GetUnitUserData' ):PreFix(
    function( __result, unit )
        local dataId = getId(unit)
        if dataId == 0 then
            return __result
        end

        local data = datas[dataId]
        return (data._original or 0)
    end
)


---将一个单位单位属性转移到另一个单位，可以用来支持变身 或者换英雄
---@param unit unit 原属性持有单位
---@param target unit 获得属性的目标
local function AttributeTransfer( unit, target )
    local sourceId = getId(unit)
    local targetId = getId(target)

    if sourceId == 0 and targetId == 0 then
        return
    end

    if sourceId == 0 then
        sourceId = AllocData_unsafe(unit)
    else
        --移除原单位的属性表.还原自定义值
        SetUnitUserData( unit,  datas[sourceId]._original)
        datas[sourceId] = nil
        idMap[unit] = nil
    end

    if targetId ~= 0 then
        datas[sourceId]._original = datas[target]._original
        datas[targetId] = datas[sourceId]
    end

    SetUnitUserData( target,  sourceId)
end

---将一个单位单位属性复制给另一个单位
---@param unit unit 原属性持有单位
---@param target unit 获得属性的目标
---@param overwriteOrOverride bool T覆写/F覆盖 覆写:新数据表 覆盖:在原表基础上覆盖
local function CopyAttribute( unit, target, overwriteOrOverride )
    local sourceId = getId(unit)
    local targetId = getId(target)

    --souce和target单位id都为0
    if sourceId | targetId == 0 then
        return
    end

    if sourceId == 0 then
        sourceId = AllocData_unsafe(unit)
    end

    if targetId == 0 then
        targetId = AllocData_unsafe(target)
        --overwriteOrOverride = true
    else
        --覆写
        if overwriteOrOverride then
            updateUnitData_unsafe( targetId )
        end
    end

    local backup_original = datas[sourceId]._original
    for key, value in pairs( datas[sourceId] ) do

        datas[targetId][key] = value

    end
    datas[targetId]._original = backup_original
end

---将一个单位单位属性复制给另一个单位
---@param unit unit 原属性持有单位
local function RemoveAttribute( unit )
    local sourceId = getId(unit)
    if sourceId == 0 then
        return
    end
    FreeData_unsafe(sourceId)
end
local string_format = string.format
---@return number
local XG_GetUnitAttribute = function (unit, attributeName)
    --print( unit, attributeName )
    if not unit or unit == 0 then
        return 0.00
    end
    if not attributeName or attributeName == '' then
        return 0.00
    end

    local dataId = getId(unit)
    if dataId == 0 then
        return 0.00
    end

    local data = datas[dataId][attributeName]
    if not data then
        return 0.00
    end

    return string_format('%.6f', data ) + 0.00
end

---@return number
local XG_GetUnitAttribute_Integer = function (unit, attributeName)
    --print( unit, attributeName )
    if not unit or unit == 0 then
        return 0
    end
    if not attributeName or attributeName == '' then
        return 0
    end

    local dataId = getId(unit)
    if dataId == 0 then
        return 0
    end

    local data = datas[dataId][attributeName]
    if not data then
        return 0
    end

    return data // 1 >> 0
end

Xfunc['XG_GetUnitAttribute'] = function ()
    local unit = XGJAPI.unit[1]
    local attributeName = XGJAPI.string[2]

    XGJAPI.real[0] = XG_GetUnitAttribute(unit, attributeName)
end

Xfunc['XG_GetUnitAttribute_Integer'] = function ()
    local unit = XGJAPI.unit[1]
    local attributeName = XGJAPI.string[2]

    XGJAPI.integer[0] = XG_GetUnitAttribute_Integer(unit, attributeName)
end

Xfunc['XG_AdjustUnitAttribute'] = function ()
    local unit = XGJAPI.unit[1]
    local attributeName = XGJAPI.string[2]
    local method = XGJAPI.string[3]
    local value = XGJAPI.real[4] or 0

    if not unit or unit == 0 then
        return
    end

    if not method then
        return
    end

    if not attributeName then
        attributeName = ''
    end

    local dataId = AllocDataId(unit)
    local data = datas[dataId]

    if method == '=' then
        data[attributeName] = value
    elseif method == '+=' then
        data[attributeName] = (data[attributeName] or 0.00) + value
    elseif method == '-=' then
        data[attributeName] = (data[attributeName] or 0.00) - value
    elseif method == '*=' then
        data[attributeName] = (data[attributeName] or 0.00) * value
    elseif method == '/=' and value ~= 0 then
        data[attributeName] = (data[attributeName] or 0.00) / value
    end

end

Xfunc['XG_AdjustUnitAttribute_Integer'] = function ()
    local unit = XGJAPI.unit[1]
    local attributeName = XGJAPI.string[2]
    local method = XGJAPI.string[3]
    local value = XGJAPI.integer[4] or 0

    if not unit or unit == 0 then
        return
    end

    if not method then
        return
    end

    if not attributeName then
        attributeName = ''
    end

    local dataId = AllocDataId(unit)
    local data = datas[dataId]

    local v = data[attributeName]
    if v == nil then
        v = 0
    elseif math_type(v) ~= 'integer' then
        v = v // 1 >> 0
    end

    if method == '=' then
        data[attributeName] = value
    elseif method == '+=' then
        data[attributeName] = v + value
    elseif method == '-=' then
        data[attributeName] = v - value
    elseif method == '*=' then
        data[attributeName] = v * value
    elseif method == '/=' and value ~= 0 then
        data[attributeName] = v / value
    end

end

Xfunc['XG_TransferUnitAttribute'] = function ()
    local source = XGJAPI.unit[1]
    local target = XGJAPI.unit[2]

    if not source or source == 0 then
        return
    end
    if not target or target == 0 then
        return
    end

    AttributeTransfer( source, target)
end

Xfunc['XG_CopyUnitAttribute'] = function ()
    local source = XGJAPI.unit[1]
    local target = XGJAPI.unit[2]
    local overwriteOrOverride = XGJAPI.bool[3]

    if not source or source == 0 then
        return
    end
    if not target or target == 0 then
        return
    end

    CopyAttribute( source, target, overwriteOrOverride)
end

Xfunc['XG_RemoveUnitAttribute'] = function ()
    local source = XGJAPI.unit[1]
    if not source or source == 0 then
        return
    end

    RemoveAttribute( source )
end

Xfunc['XG_GetUnitAttribute_String'] = function ()
    local source = XGJAPI.unit[1]
    local attributeName = XGJAPI.string[2]
    local method = XGJAPI.string[3] -- int, real， real1,  real2,  real3

    local v = 0.00

    while true do

        if not source or source == 0 then
            break
        end

        local dataId = getId(source)
        if dataId == 0 then
            break
        end

        v = datas[dataId][attributeName] or 0.00
        break
    end

    if method == 'int' then
        XGJAPI.string[0] = ( v // 1 |0 ) .. ''
    elseif method == 'real' then
        XGJAPI.string[0] = v .. ''
    elseif method:sub(1,4) == 'real' then
        local n, s = modf(v)
        XGJAPI.string[0] = n .. (s .. ''):sub(2, 2 + (method:sub(5,5)//1|0) )
    else
        XGJAPI.string[0] = v .. ''
    end
end

--用做变身技能，由于不是两个单位，所以需要把变身前的属性用id的方式设置复制到变身后的单位上
Xfunc['XG_GetUnitAttributeDataId'] = function ()
    --int XG_GetUnitAttributeDataId(u);
    local source = XGJAPI.unit[1]
    if not source or source == 0 then
        XGJAPI.integer[0] = 0
        return
    end

    XGJAPI.integer[0] = getId(source)
end

Xfunc['XG_SetUnitAttributeDataId'] = function ()
    local source = XGJAPI.unit[1]
    local id_new = XGJAPI.integer[2]
    if not source or source == 0 then
        return
    end
    local id_origin = getId(source)
    if id_origin ~= 0 then
        FreeData_unsafe(source)
    end
    SetUnitUserData( source, id_new )
end

return {
    XG_GetUnitAttribute = XG_GetUnitAttribute,
    XG_GetUnitAttribute_Integer = XG_GetUnitAttribute_Integer,
    
}