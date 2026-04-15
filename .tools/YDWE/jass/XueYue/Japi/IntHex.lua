local XGJAPI = XGJAPI
local s = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ!\"#$%&'()*+,.:;<=>?@[\\]^_`{|}~abcdefghijklmnopqrstuvwxyz"  -- /和 \同哈希值  大小写字母同哈希值  弃用哈希表 改用遍历 /仍不能用
local maxHex = #s
local code = {}
code = setmetatable(code,{
__index = function(t,k)
    if type(k)=="string" then
        return 0
    end
    return "0"
end
})
local function zy(str)
    if str=='"' or str == "\\"  then return "\\"..str end
    return str
end
local  toint = function (n)
    return n // 1 | 0
end
local c
for i = 0,#s do
    c = s:sub(i+1,i+1)
    code[i] = c
    code[c] = i
end

function XG_IntHex_Encode(iInt)
        local sign = "" --符号
        local rtn = ""
        local res = 0
        local mod = 0
        if iInt < 0 then
             sign = "-"
             iInt = iInt * -1
        end
        if iInt == 0 then
             rtn = code[mod]
        end
        
        while not(iInt == 0) do
             res = toint(iInt / maxHex) --结果
             mod = iInt - res * maxHex --余数
             iInt = res
             rtn = code[mod] .. rtn
        end
        return sign .. rtn
end
function XG_IntHex_Decode(iStr)
        local  l = iStr:len()
        local  c = ""
        local  result = 0
        local  i = 0
        local  fix = 1
       if iStr:sub(1,1) == "-" then
            iStr = iStr:sub(2)
            l = l - 1
            fix = -1
        end
        while not(i > l-1)  do
            c = iStr:sub(l-i,l-i)  --SubString(iStr,l-1-i,l-i)
            result = result + code[c] * math.pow( maxHex, i )
            i = i + 1
        end
        return result * fix
end
Xfunc['XG_IntHex_Encode']=function ()
    XGJAPI.string[0] = XG_IntHex_Encode(XGJAPI.integer[1]) or ''
end
Xfunc['XG_IntHex_Decode']=function ()
    XGJAPI.integer[0] = XG_IntHex_Decode(XGJAPI.string[1] or '')
end
