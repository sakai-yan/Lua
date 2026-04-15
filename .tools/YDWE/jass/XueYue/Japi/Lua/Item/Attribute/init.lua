--[[

    item :
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
local SetItemUserData = cj.SetItemUserData
local GetItemUserData = cj.GetItemUserData
local traceback = debug.traceback
local XGJAPI = XGJAPI
local modf = math.modf

local datas = {}
local _id = 0
local idMap = {}

local function getId(item)
    local dataId = GetItemUserData( item )

    if dataId ~= 0 then
        if idMap[item] then
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
local function FreeData_unsafe( item )
    local dataId = idMap[item]
    idMap[item] = nil
    datas[dataId] = nil
end

local function AllocData_unsafe(item)
    _id = _id + 1
    local dataId = _id
    idMap[item] = dataId

    datas[dataId] = {
        --原始自定义值
        _original = GetItemUserData(item),

    }

    SetItemUserData( item, dataId )

    return dataId
end

---申请一个数据ID，用以存储单位的属性数据
local function AllocDataId(item)
    local dataId = GetItemUserData( item )

    if dataId ~= 0 then
        if idMap[item] then
            return dataId
        end
    end

    return AllocData_unsafe(item)
end

patch( 'SetItemUserData' ):NoReturnValue():PreFix(
    function( __result, item, value )
        assert( type(value) == 'number', traceback( '单位自定义值必须为数字' ) )
        local dataId = AllocDataId(item)
        local data = datas[dataId]
        data._original = value

        return true --拦截
    end
)

patch( 'GetItemUserData' ):PreFix(
    function( __result, item )
        local dataId = getId(item)
        if dataId == 0 then
            return __result
        end

        local data = datas[dataId]
        return (data._original or 0)
    end
)


---将一个单位单位属性转移到另一个单位，可以用来支持变身 或者换英雄
---@param item item 原属性持有单位
---@param target item 获得属性的目标
local function AttributeTransfer( item, target )
    local sourceId = getId(item)
    local targetId = getId(target)

    --souce和target单位id都为0
    if sourceId | targetId == 0 then
        return
    end

    if sourceId == 0 then
        sourceId = AllocData_unsafe(item)
    else
        --移除原单位的属性表.还原自定义值
        SetItemUserData( item,  datas[sourceId]._original)
        datas[sourceId] = nil
        idMap[item] = nil
    end

    if targetId ~= 0 then
        datas[sourceId]._original = datas[target]._original
        datas[targetId] = datas[sourceId]
    end

    SetItemUserData( target,  sourceId)
end

---将一个单位单位属性复制给另一个单位
---@param item item 原属性持有单位
---@param target item 获得属性的目标
---@param overwriteOrOverride bool T覆写/F覆盖 覆写:新数据表 覆盖:在原表基础上覆盖
local function CopyAttribute( item, target, overwriteOrOverride )
    local sourceId = getId(item)
    local targetId = getId(target)

    --souce和target单位id都为0
    if sourceId | targetId == 0 then
        return
    end

    if sourceId == 0 then
        sourceId = AllocData_unsafe(item)
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
---@param item item 原属性持有单位
local function RemoveAttribute( item )
    local sourceId = getId(item)
    if sourceId == 0 then
        return
    end
    FreeData_unsafe(sourceId)
end

Xfunc['XG_GetItemAttribute'] = function ()
    local item = XGJAPI.item[1]
    local attributeName = XGJAPI.string[2]

    local dataId = getId(item)
    if dataId == 0 then
        XGJAPI.real[0] = 0.00
        return
    end

    local data = datas[dataId]

    XGJAPI.real[0] = data[attributeName]

end

Xfunc['XG_AdjustItemAttribute'] = function ()
    local item = XGJAPI.item[1]
    local attributeName = XGJAPI.string[2]
    local method = XGJAPI.string[3]
    local value = XGJAPI.real[4] or 0

    if not item or item == 0 then
        return
    end

    if not method then
        return
    end

    if not attributeName then
        attributeName = ''
    end

    local dataId = AllocDataId(item)
    local data = datas[dataId]

    if method == '=' then
        data[attributeName] = value
    elseif method == '+=' then
        data[attributeName] = (data[attributeName] or 0.00) + value
    elseif method == '-=' then
        data[attributeName] = (data[attributeName] or 0.00) - value
    elseif method == '*=' then
        data[attributeName] = (data[attributeName] or 0.00) * value
    elseif method == '/=' then
        data[attributeName] = (data[attributeName] or 0.00) / value
    end

end

Xfunc['XG_TransferItemAttribute'] = function ()
    local source = XGJAPI.item[1]
    local target = XGJAPI.item[2]

    if not source or source == 0 then
        return
    end
    if not target or target == 0 then
        return
    end

    AttributeTransfer( source, target)
end

Xfunc['XG_CopyItemAttribute'] = function ()
    local source = XGJAPI.item[1]
    local target = XGJAPI.item[2]
    local overwriteOrOverride = XGJAPI.bool[3]

    if not source or source == 0 then
        return
    end
    if not target or target == 0 then
        return
    end

    CopyAttribute( source, target, overwriteOrOverride)
end

Xfunc['XG_RemoveItemAttribute'] = function ()
    local source = XGJAPI.item[1]
    if not source or source == 0 then
        return
    end

    RemoveAttribute( source )
end

Xfunc['XG_GetItemAttribute_String'] = function ()
    local source = XGJAPI.item[1]
    local attributeName = XGJAPI.string[2]
    local method = XGJAPI.string[3] -- int, real， real1,  real2,  real3

    if not source or source == 0 then
        XGJAPI.real[0] = 0.00
        return
    end

    local dataId = getId(source)
    if dataId == 0 then
        XGJAPI.real[0] = 0.00
        return
    end

    local v = datas[dataId][attributeName] or 0.00

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


Xfunc['XG_GetItemAttributeDataId'] = function ()
    local source = XGJAPI.item[1]
    if not source or source == 0 then
        XGJAPI.integer[0] = 0
        return
    end

    XGJAPI.integer[0] = getId(source)
end

Xfunc['XG_SeItemAttributeDataId'] = function ()
    local source = XGJAPI.item[1]
    local id_new = XGJAPI.integer[2]
    if not source or source == 0 then
        return
    end
    local id_origin = getId(source)
    if id_origin ~= 0 then
        if id_new ~= id_origin then
            FreeData_unsafe(source)
        end
    end
    SetItemUserData( source, id_new )
end

