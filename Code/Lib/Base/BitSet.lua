local bj = require "API.bj"
local BitSet = {}

--bit应为整数
local select = select

--为bitset1添加bitset2
---@param bitset1 integer
---@param bitset2 integer
---@return integer
function BitSet.add(bitset1, bitset2)
    return bitset1 | bitset2
end

--为bitset1删除bitset2
---@param bitset1 integer
---@param bitset2 integer
---@return integer
function BitSet.del(bitset1, bitset2)
    return bitset1 & ~bitset2
end

--合并多个bitset
function BitSet.adds(...)
    local result = 0
    for i = 1, select('#', ...) do
        local bitset = select(i, ...)
        result = result | bitset
    end
    return result
end

--检查bitset1是否包含bitset2的所有位
function BitSet.has(bitset1, bitset2)
    return (bitset1 & bitset2) == bitset2
end

--获取bitset1与mask的交集（提取指定位）
function BitSet.get(bitset, mask)
    return bitset & mask
end

--test
if __DEBUG__ then
    local bitsetadd = BitSet.add
    local osclock = bj.MHTool_Clock
    local result = 0
    local time1 = osclock()
    for i = 1, 10000 do
        result = bitsetadd(result, 0x3)
    end
    local time2 = osclock()
    print("bitset:", BitSet.add(0x6, 0x3), BitSet.del(0x6, 0x3), result, time1, time2)


    local bitset_mhadd = bj.MHMath_AddBit
    local result = 0
    local time1 = osclock()
    for i = 1, 10000 do
        result = bitset_mhadd(result, 0x3)
    end
    local time2 = osclock()
    print("mhbitset:", bitset_mhadd(0x6, 0x3), bj.MHMath_RemoveBit(0x6, 0x3), result, time1, time2)
end



return BitSet