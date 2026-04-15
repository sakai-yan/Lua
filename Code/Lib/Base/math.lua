--增强数学库
-- 保存原生数学函数
local sqrt   = math.sqrt
local log    = math.log
local exp    = math.exp
local sin    = math.sin
local cos    = math.cos
local tan    = math.tan
local asin   = math.asin
local acos   = math.acos
local atan   = math.atan
local floor  = math.floor
local ceil   = math.ceil
local abs    = math.abs
local pi     = math.pi
local huge   = math.huge
--[[
截断函数
@description 将数字截断到指定的小数位数，直接丢弃超出部分，不进行四舍五入
@param x number 要处理的数字
@param [decimals] integer 要保留的小数位数，默认为0（返回整数）
@return number 截断后的数字
@usage
  mathx.trunc(3.14159)      --> 3
  mathx.trunc(3.14159, 2)   --> 3.14
  mathx.trunc(-3.789, 1)    --> -3.7
  mathx.trunc(123.456, -1)  --> 120 (支持负的小数位数)
]]
function math.trunc(x, decimals)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if x >= 0 then
        return floor(x * factor) / factor
    else
        return ceil(x * factor) / factor
    end
end

--[[
四舍五入函数
@description 将数字四舍五入到指定的小数位数
@param x number 要处理的数字
@param [decimals] integer 要保留的小数位数，默认为0（返回整数）
@return number 四舍五入后的数字
@usage
  mathx.round(3.14159)      --> 3
  mathx.round(3.14159, 2)   --> 3.14
  mathx.round(3.145, 2)     --> 3.15
  mathx.round(-3.789, 1)    --> -3.8
  mathx.round(123.456, -1)  --> 120 (支持负的小数位数)
]]
function math.round(x, decimals)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if x >= 0 then
        return floor(x * factor + 0.5) / factor
    else
        return ceil(x * factor - 0.5) / factor
    end
end

--- 获取两个坐标距离
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function math.distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return sqrt(dx * dx + dy * dy)
end

function math.distance3D(x1, y1, z1, x2, y2, z2)
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1
    return sqrt(dx * dx + dy * dy + dz * dz)
end

--将输入值 x 限制在 [min, max] 的闭区间内
function math.clamp(x, min, max)
    return x < min and min or (x > max and max or x)
end