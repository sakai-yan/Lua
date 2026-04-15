local find = string.find
local concat = table.concat

--检查字符串是否包含子串
function string.contains(str, substring)
    return find(str, substring, 1, true) ~= nil
end

--拼接大量字符串
function string.link(...)
    local str = {...}
    if #str == 0 then
        return nil
    end
    return concat(str)
end

-- 分割字符串
function string.split(str, sep)
    local result = {}
    for part in str:gmatch("([^" .. sep .. "]+)") do
        result[#result + 1] = part
    end
    return result
end

-- 去除首尾空白
function string.trim(str)
    return str:match("^%s*(.-)%s*$")
end
