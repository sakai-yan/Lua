local ydwe_root = assert(arg[1], "usage: ydwe_wtgloader_probe.lua <ydwe-root> <wtg-path> [--read-on-fail]")
local wtg_path = assert(arg[2], "usage: ydwe_wtgloader_probe.lua <ydwe-root> <wtg-path> [--read-on-fail]")
local read_on_fail = arg[3] == "--read-on-fail"

local function normalize_path(path)
    return (path:gsub("\\", "/"))
end

ydwe_root = normalize_path(ydwe_root)
wtg_path = normalize_path(wtg_path)

local ydwe_dev_root = ydwe_root .. "/source/Development/Component"
local plugin_script_root = ydwe_root .. "/plugin/w3x2lni_zhCN_v2.7.3/script"
local ydwe_script_root = ydwe_dev_root .. "/script/ydwe"

package.path = table.concat({
    plugin_script_root .. "/core/?.lua",
    plugin_script_root .. "/core/?/init.lua",
    plugin_script_root .. "/share/?.lua",
    plugin_script_root .. "/share/?/init.lua",
    ydwe_script_root .. "/?.lua",
    ydwe_script_root .. "/?/init.lua",
    package.path,
}, ";")

fs = require "bee.filesystem"

local raw_io_open = io.open
io.open = function(path, mode)
    if type(path) ~= "string" and path and path.string then
        path = path:string()
    end
    return raw_io_open(path, mode)
end

function io.load(path)
    local file = io.open(path, "rb")
    if not file then
        return nil
    end
    local data = file:read("a")
    file:close()
    return data
end

if not string.trim then
    function string.trim(value)
        return (value:gsub("^%s*(.-)%s*$", "%1"))
    end
end

local function parse_ini(path)
    local result = {}
    local current = nil
    local file = assert(io.open(path, "r"))
    for raw_line in file:lines() do
        local line = string.trim(raw_line)
        if line ~= "" and line:sub(1, 1) ~= ";" and line:sub(1, 1) ~= "#" then
            local section = line:match("^%[(.-)%]$")
            if section then
                current = {}
                result[section] = current
            else
                local key, value = line:match("^([^=]+)=(.*)$")
                if key and current then
                    current[string.trim(key)] = string.trim(value)
                end
            end
        end
    end
    file:close()
    return result
end

sys = {
    ini_load = function(path)
        return parse_ini(path)
    end,
}

log = {
    trace = function() end,
    debug = function() end,
    info = function() end,
    error = function() end,
}

function fs.ydwe_path()
    return fs.path(ydwe_root)
end

function fs.ydwe_devpath()
    return fs.path(ydwe_dev_root)
end

local ui_list = require "ui"
local load_triggerdata = require "triggerdata"
local wtg_checker = require "w3x2lni.wtg_checker"
local wtg_reader = require "w3x2lni.wtg_reader"

local _, _, checker_state = load_triggerdata(ui_list, true)
local wtg = io.load(fs.path(wtg_path))
local ok, check_error = wtg_checker(wtg, checker_state)

if ok then
    io.write("CHECK PASS\n")
    os.exit(0, true)
end

io.write("CHECK FAIL\n")
if check_error and check_error ~= "" then
    io.write(check_error)
    io.write("\n")
end

if not read_on_fail then
    os.exit(1, true)
end

local _, _, reader_state = load_triggerdata(ui_list, false)
local reader_ok, chunk_or_error, fix = pcall(wtg_reader, wtg, reader_state)
if not reader_ok then
    io.write("READER FAIL\n")
    io.write(chunk_or_error or "unknown reader failure")
    io.write("\n")
    os.exit(2, true)
end

local function count_fix_entries(tbl)
    local total = 0
    for _, value in pairs(tbl) do
        total = total + 1
    end
    return total
end

io.write("READER PASS\n")
io.write(("triggers=%d vars=%d actionFix=%d conditionFix=%d eventFix=%d callFix=%d\n"):format(
    #(chunk_or_error.triggers or {}),
    #(chunk_or_error.vars or {}),
    count_fix_entries(fix.ui.action or {}),
    count_fix_entries(fix.ui.condition or {}),
    count_fix_entries(fix.ui.event or {}),
    count_fix_entries(fix.ui.call or {})
))
os.exit(1, true)
