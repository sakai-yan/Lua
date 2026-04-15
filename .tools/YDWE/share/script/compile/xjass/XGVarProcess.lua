        ----------------------------------------------------
        --                  雪月中文变量
        ----------------------------------------------------

local table_insert = table.insert
local table_remove = table.remove

local xT={} --可用字符集
local xI={}
for i=1,26 do
  table_insert(xT,string.char(64+i))
  table_insert(xT,string.char(123-i))
end

--[[local function isCharVaild(c)
 local n = c:byte()
 return (n>64 and n<91) or (n>96 and n<123) or (n>47 and n<58) or c=='_'
end]]

local function isVariableNameVaild(str)

    local a, b = str:match("udg_([%w_]+)(.*)%s*=?")
    if not a then
        return false
    end

    --最后一个字符不能是下划线
    if a:sub(-1) == '_' then
        return false
    end

    -- b == nil(不应该) 但是这说明都是 合法字符串，被a匹配完了
    if not b then
        return true
    end

    if b == '' then
        return true
    end

    -- 仅有 a有字符 b无字符时为合法字符串（同时 a不以_结尾）
    return false
    --return str:match("udg_%a[%w_]*[%w]%s*=?") and true or false
end

local function genVarName() --生成一个新变量名
    local n = #xT
    local s, x, t = 0, 1, ''
    for i = 1, #xI do
        if x > 0 then --进值数
            if xI[i] + x <= n then
                xI[i] = xI[i] + x
                x = 0
            else
                s = ( x + xI[i] ) % n --余数
                x = ( ( x + xI[i] ) / n ) // 1 | 0 --进位
                xI[i] = s
            end
        end
        t = t .. xT[xI[i]]
    end
    return t
end

local function XG_udg_chs(g)
    local v
    local i, w = 0, {}
    while i < #g do

        i = i + 1
        --[[
        v = false
        for n = 1, #g[i] do
            if not isCharVaild( g[i]:sub(n,n) ) then
                v = true --中文变量
                break
            end
        end
        ]]
        v = not isVariableNameVaild( g[i] )

        if v then
            table_insert(w, 'xgdg_' .. genVarName() )
            log.trace( w[#w] , '>>replace>>' , g[i])
        else
            table_remove(g, i)
            i=i-1
        end

    end


    for n=2,#g do
        for j=1,#g do
            if g[n]:len() > g[j]:len() and n > j then
                table_insert( g, j, g[n] )
                table_remove( g, n + 1 )
                table_insert( w, j, w [ n ] )
                table_remove( w, n + 1 )
                break
            end
        end
    end

    log.trace("XG Udg chs done!!!.")
    return g, w
end

local function XG_Global_Deal(t) --处理变量 仅留变量名
    local str, s = ''
    local i = 1
    local all = #t
    while true do
        if i > all then break end
        str = t [ i ]

        if str:sub(1,2) == "//" or not( str:match("(udg_)") ) then
            table_remove(t,i)
            all = all - 1
        else
            local commit = str:match("/%*.+%*/")
            if commit then
                str = str:replace( commit, '' )
            end

            local start, last = str:find("=", 1, true)
            if start then
                t[i] = str:match("(udg_.+)="):lighter()
            else
                t[i] = str:match("(udg_.*)"):lighter()
            end

            i = i + 1
        end
    end
    log.trace("XG Global Completed!!!")		
    return t
end
local function Hc_GetGlobal(jass) --遍历全局变量
    local t = {}
    local index = 0
    local start,last
    local g = {}
    local reg = "%s*(.-)%s*\r?\n"
    local str -- temp string
    while true do
        start, last, str = jass:find(reg, (last or 0 ) + 1)
        if not start then break end

        if not g[1] then --globals 开始位置
            if str == 'globals' then
                g[1] = start
            end
        elseif str == 'endglobals' then
            break
        else
            if str then
                index = index + 1
                t [ index ] = str
            end
        end

    end

    log.trace( "XG Global Num: ", #t )
    return XG_Global_Deal(t)
end


function Hc_XG_BxL(jass)
	local g, w = Hc_GetGlobal(jass) --表
	xI = {} --长度
	for i = 1, (#g..''):len() do
		if i==1 then
			table_insert(xI, 0)
		else
			table_insert(xI, 1)
		end
	end
	g, w = XG_udg_chs(g)
	for i=1,#g do
		jass = jass:replace( g[i], w[i] )
	end

	return jass
end
