local math_ceil = math.ceil
local math_floor = math.floor
local math_tointeger = math.tointeger

local SCALE = 10000
local UINT32_MASK = 0xFFFFFFFF
local INT32_SIGN_BIT = 0x80000000
local UINT32_WRAP = 0x100000000
local INT32_MIN = -0x80000000
local INT32_MAX = 0x7FFFFFFF

local function round4(value)
    if value >= 0 then
        return math_floor(value * SCALE + 0.5)
    end
    return math_ceil(value * SCALE - 0.5)
end

local function assert_coordinate(value, name)
    assert(type(value) == "number", "Point.new: " .. name .. " must be a number")
    assert(value == value and value ~= math.huge and value ~= -math.huge,
        "Point.new: " .. name .. " must be a finite number")

    local integer = math_tointeger(round4(value))
    assert(integer, "Point.new: " .. name .. " is outside integer range after 4-decimal scaling")
    assert(integer >= INT32_MIN and integer <= INT32_MAX,
        "Point.new: " .. name .. " is outside supported range [-214748.3648, 214748.3647]")
    return integer
end

local function sign32(value)
    value = value & UINT32_MASK
    if value >= INT32_SIGN_BIT then
        return value - UINT32_WRAP
    end
    return value
end

local Point = {
    scale = SCALE,
    min_value = INT32_MIN / SCALE,
    max_value = INT32_MAX / SCALE,

    new = function(x, y)
        local x_int = assert_coordinate(x, "x")
        local y_int = assert_coordinate(y, "y")
        return ((x_int & UINT32_MASK) << 32) | (y_int & UINT32_MASK)
    end,

    get = function(point)
        local packed = math_tointeger(point)
        assert(packed, "Point.get: point must be a packed integer number")

        local x_int = sign32((packed >> 32) & UINT32_MASK)
        local y_int = sign32(packed & UINT32_MASK)
        return x_int / SCALE, y_int / SCALE
    end,

    __call = function(self, x, y)
        return self.new(x, y)
    end,
}

setmetatable(Point, Point)

return Point
