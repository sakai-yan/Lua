---@diagnostic disable: lowercase-global, discard-returns
local table_insert = table.insert
local string_format = string.format
local Strs = {}
local function split( str,reps )
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function ( w )
        table_insert(resultStrList,w)
    end)
    return resultStrList
end

local function XG_Sub(str,left,right)
	if left > right then
		return ''
	end
	return str:sub(left,right)
end

function XG_StrFormat_Reg_Lua(name, code, f)
	local isVariable = true
	name = name:gsub('^%s*(.+)%s*$', '%1')
	code = code:gsub('^%s*(.+)%s*$', '%1')
	--log.debug(  'str_reg', name, code )
	if code:sub(1,1) == '"' then
		code = code:sub(2, -2)
		isVariable = false
	end

	Strs[name] = {
		code = code,
		variable = isVariable
	}

	return 'DoNothing()'
end

function XG_StrFormat_withParams(s,a)
	local str,p = {},1
	local q,f = '',0
	for i=1,#a do
		s=s:gsub('([^\\])(\\n)(.)',
			function(x,w,y)
				if x==y and x=='"' then
					return '"\\n"'
				end
				return x..'"+'..'"\\n"'..'+"'..y
			end
		)

		s=s:gsub('\\\\n','\\n')
		local m = s:find("%s",nil,true)
		if m==nil then
			break
		end

		if m <= p then
			q = ''
		else
			q = XG_Sub(s,p,m-1)
		end

		if Strs[a[i]] == nil then
            Strs[a[i]] = {
				code = a[i],
				variable = false,
            }
            --return '."雪月： '..a[i]..' 未绑定字符串！"'
		end

		if Strs[a[i]].variable then --连接

			if f==2 then --上次 常量
				table_insert(str,q)
				table_insert(str,'"')
			elseif f==1 and q~='' then  --上次 变量
				table_insert(str,'+"')
				table_insert(str,q)
				table_insert(str,'"')
			else

			end

			if f ~= 0 then
			  table_insert(str,'+')
			elseif q~='' then
			  table_insert(str,'"')
			  table_insert(str,q)
			  table_insert(str,'"+')
			end

			table_insert( str, Strs[ a[i] ].code )
			f = 1
			s = s:sub( m + 2 )
		else --格式化
		   if f==1 then --上次 变量
		     table_insert(str,'+"')
		   elseif f==0 then
		     table_insert(str,'"')
		   end
			table_insert(str,q)
			table_insert(str,Strs[a[i]].code)
			f = 2
			s=s:sub(m+2)
		end
	end
	if f == 2 then
        s = s..'"'
    elseif f==1 then
        s = '+"'..s..'"'
    else
        s = '"'..s..'"'
    end
    table_insert(str, s)
	return table.concat(str)
end
function XG_StrFormat_Do_Lua(s, c)
	s = s:gsub('^%s*(.+)%s*$', '%1')
	c = c:gsub('^%s*(.+)%s*$', '%1')
	--c = c:sub(2,-2)
	--s = s:sub(2,-2)
	local a, b=split(c,","),''
	for i=1,#a do
		if a[i]==nil then
			b='."XGstrFormat: params['.. i ..'] is nil"'
			break
		end
	end
	if #a==0 then
		b='."XGstrFormat: has no params"'
	end
	return b .. XG_StrFormat_withParams(s, a)
	--[[return b..'"'..load('return string.format("'..s..'",'..table.concat(a,',')..')')()..'"']]
end

---替换换行符
---@param str string
---@param variable any
local function changeLine( str, variable )
	if variable then
		return str
	end

	local pos = str:find('\\n', 1, true)
	
	local last = ''
	while pos do
		local chr = str:sub(pos-3,pos-1)
		local newstr = ''

		if chr == '\\\\\\' then
			goto next
		end

		if pos == 2 and chr:sub(1,1) == '"' then
			--前段为变量
			newstr = ' + "\\n" + '
		else
			--前段为常量
			newstr = '" + "\\n" + "'
		end

		str = str:sub(1,pos-2) .. newstr .. str:sub(pos+2)

		pos = pos +  (#newstr - 2)

		::next::
		pos = str:find('\\n', pos+1, true)
	end

	return str

end
--一体式  玩家 ${p} 获得了 ${gold} 金币
function XG_StrFormat_AIO_Lua(str)
	str = str:gsub('^%s*(.+)%s*$', '%1')
	--str = str:sub(2,-2)
	local i,strLen = 1,str:len()
	--空的格式字符串
	if strLen == 0 then
		return '""'
	end

	local rtn,count = {},0
	local start
	local name = ''

	local case
	local first = true
	while i <= strLen do
		local chr = str:sub(i,i)

		if start then
			if chr ~= '}' then
				name = name .. chr
			else
				count = count + 1
				rtn[count] = {
					name = name,
					variable = Strs[name] and Strs[name].variable or false,
					format = true,
				 }
				start = false
				name = ''
			end

			goto next
		end

		if chr == '$' then
			if str:sub(i+1,i+1) == '{' then
				i = i + 1
				start = true
				if name ~= '' then
					count = count + 1
					rtn[count] = {
						--name = string_format('%q',name):sub(2,-2),
						name = name,
						variable = false,
					}
					name = ''
				end
				goto next
			end
		end

		name = name .. chr
		if i >= strLen then
			count = count + 1
			rtn[count] = {
				--name = string_format('%q',name):sub(2,-2),
				name = name,
				variable = false,
			}
		end
		::next::
		i=i+1
	end

	local variable
	for index, value in ipairs(rtn) do
		local newvariable = value.variable
		name = value.name

		if variable then
			case = 0 + (newvariable and 0 or 1) -- 0：变量+变量 1: 变量+常量
		else
			case = 1 + (newvariable and 1 or 2) --2：常量+变量 3.常量+常量
		end
		--""" + XGJAPI_GetStr( bj_forLoopBIndex) + """
		if case == 0 then	--0：变量+变量
			rtn[index] = ' + ' .. (Strs[name] and Strs[name].code or '"'..name..'"')
		elseif case == 1 then -- 1: 变量+常量
			rtn[index] = ' + "' .. name
		elseif case == 2 then --2：常量+变量

			if index == 1 then
				rtn[index] = (Strs[name] and (Strs[name].code) or '"'..name..'"')
			else
				rtn[index] = '" + ' .. (Strs[name] and Strs[name].code or '"'..name..'"')
			end
			
		elseif case == 3 then	-- 3.常量+常量
			--log.debug( 'const+const', name,  newvariable)
			if index == 1 then
				rtn[index] = '"' .. (value.format and Strs[name].code or name)
			else
				rtn[index] = (value.format and (Strs[name] and Strs[name].code or name) or name )
			end
		end

		rtn[index] = changeLine(rtn[index], newvariable)
		
		variable = newvariable
	end
	if not variable then
		count = count + 1
			rtn[count] = '"'
	end

	return table.concat(rtn)
end

--[[
	local j = io.open(fs.ydwe_path() /"share"/"script"/ 'compile' / 'xjass' / "XGStrFormat.lua", "a+b")
	if not j then
		break
	end
	jass =  '<? '..j:read("*a") .. ' ?>' .. jass
	j:close()
	
	]]
--[[ 旧代码备份：xjass_wave

    for i=1,#t do
        local s,q =  jass:find(t[i], nil, true)
        if s then

            reload 'XGStrFormat'

            log.trace(">StrFormat")
            jass = jass:gsub("XG_StrFormat_Reg%s-%(%s*(.-)%s*,%s*(.-)%s*%)[\r\n]", --[\r\n]兼容保存加速
                function(x,y)
                local z = ",false" --是否字符串常量
                A = x
                B = y
                if y:sub(1,1) ~= '"' then
                    y =  '"' .. y .. '"'
                    z = ",true"
                end
                
                return load("return XG_StrFormat_Reg_Lua(A,B"..z..")")()..'\r\n'
            end)
            jass = jass:gsub("XG_StrFormat_Do%s-%(%s*(.-)%s*,%s*(.-)%s*%)",
                function(x,y)
                return XG_StrFormat_Do_Lua(x,y)
            end)

            jass = jass:gsub("XG_StrFormat_AIO%s-%(%s*(.-)%s*%)",
            function(x,y)
                return XG_StrFormat_AIO_Lua(x)
            end)
            local strft = true
            break
        end
    end
]]