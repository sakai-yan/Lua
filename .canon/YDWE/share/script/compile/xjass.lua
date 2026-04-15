local toint = function (n)
    return n // 1 | 0
end
local table_remove = table.remove
require "sys"
require "filesystem"
require "util"
require 'compile.xjass.xjass_wave'
storm    = require 'ffi.storm'

xjass.path     = fs.ydwe_path() / "plugin" / "HCcompiler"
xjass.exe_path = xjass.path / "HCcompiler.exe"

local mt_xTable = {
    type = 'xTable',

    insert = function (self, ...)
        local idx = (self[0] or 0)
        for _, v in ipairs({...}) do

            idx = idx + 1
            self[ idx ] = v

        end
        self[0] = idx
        return idx
    end,

    remove = function (self, index)
        if not self[0] or self[0] < 1 then
            return
        end
        self[0] = (self[0] or 0) - 1
        table_remove(self, index)
    end,

    del = function (self)

        local mt = getmetatable(self)
        mt.__mode = 'kv'

    end,

    reset = function (self)
        for i = self[0], 1, -1 do
            table_remove( self, i )
        end

        self[0] = 0
    end,

}
---返回一个xTable
---自带元方法 insert/remove/del 用法与 table.inset相同，可连续插入
---使用该方法插入可使用 tb[0] 快速查看数组长度
---@param tb? table  自带元方法 insert/remove/del 用法与 table.inset相同，可连续插入
---@return table
function table.new( tb )
    if not tb then
        tb = {
            [0] = 0,
        }
    else
        local i = 0
        for _,_ in ipairs(tb) do
            i = i +1
        end
        tb[0] = i
    end
    ---@class xTable
    return setmetatable( tb,
    {
        __index = mt_xTable
    }
    )
end


local function pathstring(path)
	local str = path:string()
	if str:sub(-1) == '\\' then
		return '"' .. str .. ' "'
	else
		return '"' .. str .. '"'
	end
end
function match_braket(str,start)  --匹配括号   返回 结束位置
    local quo,j,last,chr={0,0},1
    local l = ''
    for i = start+1,str:len() do
        chr = str:sub(i,i)
        if chr == '(' and not(quo[1]%2==1 or quo[2]%2==1) then
            j = j + 1
        elseif chr == ')' and not(quo[1]%2==1 or quo[2]%2==1) then
            j = j - 1               -- 当 j = 0 时括号匹配完成
            if j == 0 then
                last = i
                break
            end
        elseif chr == "'" then
            if quo[2]%2 ~=1 and l ~= '\\' then
                quo[1] = quo[1] + 1
            end
        elseif chr == '"' then
            if quo[1]%2 ~=1  and l ~= '\\' then
                quo[2] = quo[2] + 1
            end
        end
        l = chr
    end

    return last --last==nil则未匹配到
end

function getString(str, pos, max, simp)
    simp = simp or '"'
    local start = pos
    pos = pos + 1
    while pos <= max do
        local chr = str:sub(pos,pos)
        if chr == '\\' then
            pos = pos + 1
        elseif chr == simp then
            return pos - start
        end
        pos = pos + 1
    end
    return 1
end

function getParam(str, pos, max)
    pos = pos + 1
    local start = pos
    local pSt = start
    local count = 0
    local params = {}
    max = max or #str
    while pos <= max do
       local chr = str:sub(pos,pos)
       if chr == ',' then
           --新参数开始点 非常量
           --print( params, str:sub( pSt, pos-1 ) )
           pSt = pos + 1
           
       elseif chr == ')' then
           --函数结束
           return pos - start, params
       elseif chr == ' ' then
           
       else
            --新表达式
            local skip = getExpression(str, pos, max)
            pos = pos + skip
            table.insert(params, str:sub(pSt,pos))

       end
       pos = pos + 1
    end
    print('err params', pos, max)
    return 1,{}
end

---@return number,table,number 跳过字符数，参数(0为函数名), 结束位置
function getExpression(str, pos, max)  --匹配参数   返回 结束位置
    pos = pos or 1
    max = max or #str
    local start = pos
    local funcName = ''
    local params,skip = {}
    while pos <= max do
        local chr = str:sub(pos, pos)
        if chr == '(' then
            if funcName ~= '' then
                skip,params = getParam(str, pos, max)
                skip = skip + 1 --跳过)括号
                params[0] = funcName
            else
                skip,params = getParam( str, pos,max )
                skip = skip + 1 --跳过)括号
            end
            pos = pos + skip
            return pos - start, params, pos
        elseif chr == '"' or chr == "'" then
            skip = getString(str, pos, max, chr)
            pos = pos + skip
            table.insert( params, str:sub(start,pos) )
            return pos - start, params, pos
        elseif chr == ' ' then

        elseif chr == ')' or chr == ',' or pos > max then
           --常量结束
           table.insert( params, str:sub( start, pos - 1 ) )
           return pos - start - 1 , params , pos
        else
            funcName = funcName .. chr
        end

        pos = pos + 1
    end
    table.insert( params, str )
    return pos - start , params, pos
end
function string.lighter(s) --去首尾空
    return s:match("^[%s]*(.-)[%s]*$")
end

function StringHash(str)
    local a=storm.string_hash(str)
    if a>2^31 then
        a=a-2^32
    end
    return toint(a)
end

function string.replace( str, s, newStr )
    local offset = newStr:len() - s:len()
    local pS,pE = str:find( s, 1, true )
    while pS do
        str = str:sub(1,pS-1) .. newStr .. str:sub( pE + 1 )

        pS,pE = str:find( s, pE + offset+1, true )
    end
    return str
end

-- 使用雪月编译器编译地图
-- map_path - 地图路径，fs.path对象
-- option - 附加编译选项, table，支持选项为：
--	enable_jasshelper_debug - 启用Debug模式，true/false
--	runtime_version - 魔兽版本
-- 返回：true编译成功，false编译失败
function xjass.do_compile(self, map_path, temp_path, jass_path, output_path)
-- 规定参数：[/type <map0/jass1/mix2>]  [/path <path>] [/import <on/off>] [/comment <on/off>]
	local command_line = string.format('"%s" /type 0 /mappath "%s" /jasspath "%s" /output "%s" /temppath "%s" /import on /impdir "%s" /impdir "%s" /comment on /method cmp',
		xjass.exe_path:string(),
		map_path:string(),
        jass_path,
        output_path,
        temp_path,
        (fs.ydwe_path() / "jass"):string(),
		(fs.ydwe_path() / "jass"/ 'XueYue' / 'Framework' / 'res' ):string()
	)

    -- local proc, out_rd, err_rd, in_wr = sys.spawn_pipe(command_line, nil)
	-- if proc then
		-- local out = out_rd:read("*a")
		-- local err = err_rd:read("*a")
		-- local exit_code = proc:wait()
		-- proc:close()
		-- proc = nil
		-- return exit_code, out, err
	-- else
		-- return -1, nil, nil
	-- end
	return sys.spawn(command_line, self.path, true)
end
---@param self any
---@param temp_path string 地图临时处理目录
---@param map_path any
---@param jass_path any
---@param output_path any
function xjass:compile( map_path, temp_path, jass_path, output_path)
	log.trace("xJass compilation start.")
	self:do_compile(map_path, temp_path, jass_path, output_path)
--source_path target temp_path
--F:\F-drive\Desk\XG_lua优化.w3x	F:\F-drive\Desk\XG_lua优化.w3xTemp\XG_lua优化.w3x	F:\F-drive\Desk\XG_lua优化.w3xTemp
	xjass_config_reload() --重载def.ini

	return true
end
