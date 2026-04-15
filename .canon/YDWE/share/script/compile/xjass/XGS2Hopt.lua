        ----------------------------------------------------
        --                  StringHash优化
        ----------------------------------------------------

local t = {}
local StringHash = StringHash

function XG_S2H_Compile_Do(key)
    local cons
    if key:find('\"')~=nil then

        key=key:gsub('(%b"")',
        function (str)
            cons = true
            local h
        	str = str:sub(2, str:len()-1)
            h = StringHash(str)
--[[
            if not t [h] then
                t [h] = str
            elseif t [h] == str then
            else
                h = '."XG Hash Collision: ' .. str .. " & " ..  t [h] ..'"'    --与另一个哈希值产生了碰撞
            end
]]
            return h
        end)
    end
    if cons then
        return key
    end
    return 'StringHash('..key..')'
end


function XG_S2H_Compile(jass)
    local start,last,braket,code,func
    local j = 0
    while true do
        j = j + 1
        if j>100000 then
            log.error("S2Hopt","endless loop")
            break
        end
        start,last = jass:find('StringHash%s*%(',start)
        if start then
            braket = match_braket(jass,last)
            if braket then
                code = "return XG_S2H_Compile_Do([[" .. jass:sub(last+1,braket-1) .. "]])"
                func = load(code)
                if func then
                    jass = jass:sub( 1, start-1 ) .. func() .. jass:sub( braket+1 )

                end
            end
            start = start + 1
        else
            break
        end


    end

    return jass
end
