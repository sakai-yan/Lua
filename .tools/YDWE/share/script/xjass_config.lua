require "util"
require "sys"
require "filesystem"
local file = fs.ydwe_path() / "plugin" / "HCcompiler" / "HCcompiler.ini"
local ffi = require "ffi"
ffi.cdef[[
	//SetCurrentDirectory
	int SetCurrentDirectoryW(const wchar_t* lpPathName);
    int GetCurrentDirectoryW(int nBufferLength, wchar_t* lpBuffer);
]]

xjass = {}

local tbl_index = {
	cJass = {
		Enable = "1"
	},

}

function xjass_config_reload()
	local tbl = sys.ini_load(file)
    local tbx = sys.ini_load(fs.ydwe_path() / "plugin" / "HCcompiler" / "def.ini")
	if not tbl then
		tbl = {}
	end
	tbl = setmetatable(tbl, {__index = function(t,k)  
        if tbl_index[k] then 
            return tbl_index[k]
        end
        return "0"
        end})
    if not tbx then
		tbx = {}
	end
    tbx = setmetatable(tbx, {__index = function(t,k)  

        return "0"
        end})
	xjass.config = tbl
    xjass.def   = tbx

end
xjass_config_reload()

function xjass:w2l_slk(map_path)
    local w2l_path = ( fs.ydwe_path() / "plugin" / "w3x2lni_zhCN_v2.7.3" / "w2l.exe" ) : string()
    --xjass.config['w2l']['path']
    if tonumber(xjass.config['w2l']['slk_when_test']) ~= 1 then
        return
    end
    --if w2l_path == "0" then
    --    return
    --end
    log.debug( "w2l_slk: "  , map_path )
    local command_line = '"'.. w2l_path .. '" slk "' .. map_path .. '" "' .. map_path .. '"'
    sys.spawn(command_line, nil, true, false)
end



function xjass:copy_plugin(force)
    local version_dll = fs.war3_path() / 'version.dll'
    if not fs.exists(version_dll) or force then
		pcall(fs.copy_file, fs.ydwe_path() / 'XueYue' / 'dzPlugin' / 'version.dll', version_dll, true)
    end

	local dz_w3_plugin_dll = fs.war3_path() / 'dz_w3_plugin.dll'
    if not fs.exists(dz_w3_plugin_dll) or force then
		pcall(fs.copy_file, fs.ydwe_path() / 'XueYue' / 'dzPlugin' / 'dz_w3_plugin.dll', dz_w3_plugin_dll, true)
    end

	local dz_w3_plugin_x64_dll = fs.war3_path() / 'dz_w3_plugin_x64.dll'
    if not fs.exists(dz_w3_plugin_x64_dll) or force then
		pcall(fs.copy_file, fs.ydwe_path() / 'XueYue' / 'dzPlugin' / 'dz_w3_plugin_x64.dll', dz_w3_plugin_x64_dll, true)
    end
end

---@param cmd string
---@param multiplayer boolean
function xjass:TestOn11(application_name, commandline, number_of_player, mappath )
    local yd = fs.path( fs.ydwe_path():string() ):remove_filename():parent_path():parent_path() / '11Tester'
    local yd_exe =  yd / 'YDWE.exe'
    local yd_arg = "-kkwe"
    local yd_arg_11 = "-ydwe"

	local target = yd / 'bin' / 'EverConfig.cfg'
	pcall(fs.copy_file, fs.ydwe_path() / 'bin' / 'EverConfig.cfg' , target, true)

    commandline = commandline:match( 'war3.exe\"?%s*(.+)' )
    --log.trace( commandline )
    local war3_helper_dll = yd / 'plugin' / 'warcraft3' / 'yd_loader.dll'
    commandline = commandline:gsub
    (
        yd_arg..' "(.-)"',
        (yd_arg_11..' "%s"'):format( yd:string() )
    )
    if not commandline:find('-auto') then
       --commandline = commandline .. ' -loadfile "' .. mappath:string() .. '"' 
    end
    for i = 1, number_of_player do
		--result = sys.spawn_inject(application_name, commandline, nil, war3_helper_dll)
        sys.spawn ( '"' .. yd_exe:string()..'" -war3 ' .. commandline )
	end

    --F:\G-drive\YDWE\11Tester\YDWE.exe -war3 -loadfile

    --2023-12-07 19:26:20.  9 [lua]-[error] Executed 
    --"F:\G-drive\YDWE\1.8.0_雪月编辑器\11Tester\YDWE.exe" -war3 "F:\E-drive\Game\Warcraft III Frozen Throne\war3.exe" -loadfile "F:\E-drive\Game\Warcraft III Frozen Throne\Maps\Test\WorldEditTestMap.w3x" -window -ydwe "F:\G-drive\YDWE\1.8.0_雪月编辑器\11Tester" -loadfile "F:\E-drive\Game\Warcraft III Frozen Throne\Maps\Test\WorldEditTestMap.w3x" failed
	--sys.spawn ( '"' .. yd:string()..'" -war3  -loadfile "' .. mappath:string() .. '"' )
end


--package.path  = package.path  ..  (fs.ydwe_path()  / "plugin" / "w3x2lni" / "script" ):string() .. "/?.lua;" 
 