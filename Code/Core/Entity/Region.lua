local Jass = require "Lib.API.Jass"
local Tool = require("Lib.API.Tool")
local DataType = require "Lib.Base.DataType"
local Class       = require "Lib.Base.Class"
local Set         = require "Lib.Base.Set"

--基础网格，用于组成各类复杂Region
local reusable_rect = Jass.Rect(0, 0, 0, 0)

-- 坐标压缩参数
local _Coord_Precision = 1000  -- 精度因子，保留3位小数
local _Coord_Bits = 16         -- 每个坐标占16位（范围0-65535）
local _Coord_Mask = 0xFFFF     -- 16位掩码

--将浮点坐标转换为整数
local function floatToInt(val)
    return math.floor(val * _Coord_Precision + 0.5) -- 四舍五入取整
end

--将整数坐标还原为浮点
local function intToFloat(val)
    return val / _Coord_Precision
end

-- 压缩单个矩形：将4个坐标打包到1个64位整数中
local function packRect(minX, minY, maxX, maxY)
    local q_minX = floatToInt(minX)
    local q_minY = floatToInt(minY)
    local q_maxX = floatToInt(maxX)
    local q_maxY = floatToInt(maxY)
    
    -- 验证坐标范围（16位无符号整数）
    assert(q_minX >= 0 and q_minX <= _Coord_Mask, "minX coordinate out of range")
    assert(q_minY >= 0 and q_minY <= _Coord_Mask, "minY coordinate out of range")
    assert(q_maxX >= 0 and q_maxX <= _Coord_Mask, "maxX coordinate out of range")
    assert(q_maxY >= 0 and q_maxY <= _Coord_Mask, "maxY coordinate out of range")
    
    -- 使用位运算将4个16位坐标打包到1个64位整数
    -- 布局: minX(16位) | minY(16位) | maxX(16位) | maxY(16位)
    local packed = 0
    packed = packed | (q_minX << 48)
    packed = packed | (q_minY << 32)
    packed = packed | (q_maxX << 16)
    packed = packed | q_maxY
    
    return packed
end

-- 解压单个矩形：从64位整数中提取4个坐标
local function unpackRect(packed)
    local q_minX = (packed >> 48) & _Coord_Mask
    local q_minY = (packed >> 32) & _Coord_Mask
    local q_maxX = (packed >> 16) & _Coord_Mask
    local q_maxY = packed & _Coord_Mask
    return intToFloat(q_minX), intToFloat(q_minY), intToFloat(q_maxX), intToFloat(q_maxY)
end

--为region添加rect
local function regionAddRect(region, minX, minY, maxX, maxY)
    Jass.SetRect(reusable_rect, minX, minY, maxX, maxY)
    Jass.RegionAddRect(region.handle, reusable_rect)
    table.insert(region.rects, packRect(minX, minY, maxX, maxY))
end


--区域类
local Region
Region = Class("Region", {

    __regions = Set.new(),

    __regions_by_handle = {},
    
    __constructor__ = function(class)
        local region = DataType.set({
            handle = Jass.CreateRegion(),
            rects = {}
        }, "region")
        class.__regions:add(region)
        class.__regions_by_handle[region.handle] = region
        return region
    end,

    -- 销毁region
    __del__ = function(class, region)
        if Tool.isHandleType(region.handle, "region") then
            Jass.RemoveRegion(region.handle)
        end
        class.__regions:discard(region)
        class.__regions_by_handle[region.handle] = nil
        region.handle = nil
        region.rects = nil 
    end,

    -- 便捷函数：创建圆形region
    Circle = function(cx, cy, radius, segments)
        segments = segments or 32
        local region = Region.new()
        local step = 2 * radius / segments
        local start_y = cy - radius
        
        for i = 0, segments - 1 do
            local current_y = start_y + i * step
            local mid_y_offset = current_y + step / 2 - cy
            local half_width_sq = radius * radius - mid_y_offset * mid_y_offset
            
            if half_width_sq > 0 then
                local half_width = math.sqrt(half_width_sq)
                local minX = cx - half_width
                local minY = current_y
                local maxX = cx + half_width
                local maxY = current_y + step
                regionAddRect(region, minX, minY, maxX, maxY)
            end

        end
        return region
    end,

    -- 便捷函数：创建矩形region
    Rectangle = function(minX, minY, maxX, maxY)
        local region = Region.new()
        regionAddRect(region, minX, minY, maxX, maxY)
        return region
    end,

    -- 合并多个region，创建一个新的region
    Merge = function(...)
        local regions = {...}
        local region = Region.new()
        for index = 1, #regions do
            local source_region = regions[index]
            if DataType.get(source_region) == "region" then
                local rects = #source_region.rects
                for i = 1, #rects do
                    regionAddRect(region, unpackRect(rects[i]))
                end
            end
        end
        return region
    end

})

-- 将一个region添加到另一个region
function Region.AddRegion(target_region, source_region)
    if __DEBUG__ then
        assert(DataType.get(target_region) == "region" and DataType.get(source_region) == "region", "Region.AddRegion:输入参数类型错误")
    end
    local rects = #source_region.rects
    for index = 1, #rects do
        regionAddRect(target_region, unpackRect(rects[index]))
    end
    return target_region
end

-- 复制一个region
function Region.Copy(region)
    if __DEBUG__ then
        assert(DataType.get(region) == "region", "Region.Copy:输入参数错误")
    end
    return Region.AddRegion(Region.new(), region)
end

return Region
