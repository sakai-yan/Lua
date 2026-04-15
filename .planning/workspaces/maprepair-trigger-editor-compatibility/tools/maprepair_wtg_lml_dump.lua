local ydwe_root = assert(arg[1], "usage: maprepair_wtg_lml_dump.lua <ydwe-root> <wtg-path> <wct-path> <output-dir> [wts-path]")
local wtg_path = assert(arg[2], "usage: maprepair_wtg_lml_dump.lua <ydwe-root> <wtg-path> <wct-path> <output-dir> [wts-path]")
local wct_path = assert(arg[3], "usage: maprepair_wtg_lml_dump.lua <ydwe-root> <wtg-path> <wct-path> <output-dir> [wts-path]")
local output_dir = assert(arg[4], "usage: maprepair_wtg_lml_dump.lua <ydwe-root> <wtg-path> <wct-path> <output-dir> [wts-path]")
local wts_path = arg[5]

local function normalize_path(path)
    return (path:gsub("\\", "/"))
end

ydwe_root = normalize_path(ydwe_root)
wtg_path = normalize_path(wtg_path)
wct_path = normalize_path(wct_path)
output_dir = normalize_path(output_dir)
wts_path = wts_path and normalize_path(wts_path) or nil

local plugin_script_root = ydwe_root .. "/plugin/w3x2lni_zhCN_v2.7.3/script"
local share_script_root = ydwe_root .. "/share/script"

package.path = table.concat({
    plugin_script_root .. "/?.lua",
    plugin_script_root .. "/?/init.lua",
    share_script_root .. "/?.lua",
    share_script_root .. "/?/init.lua",
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

function io.save(path, data)
    local file = assert(io.open(path, "wb"))
    file:write(data)
    file:close()
end

if not string.trim then
    function string.trim(value)
        return (value:gsub("^%s*(.-)%s*$", "%1"))
    end
end

local function parse_lni_scalar(value)
    value = string.trim(value)
    if value == "" then
        return ""
    end

    if value == "true" then
        return true
    end

    if value == "false" then
        return false
    end

    local number = tonumber(value)
    if number ~= nil then
        return number
    end

    if value:sub(1, 1) == '"' and value:sub(-1) == '"' and #value >= 2 then
        return value:sub(2, -2)
    end

    return value
end

local function parse_ui_lni(buf, target)
    local sections = target or {}
    local current_section = nil
    local current_block = nil

    for raw_line in buf:gmatch("[^\r\n]+") do
        local line = raw_line
        if line:sub(1, 3) == "\239\187\191" then
            line = line:sub(4)
        end

        line = string.trim(line)
        if line ~= "" and line:sub(1, 2) ~= "//" then
            local repeated_name = line:match("^%[%[(.-)%]%]$")
            if repeated_name then
                repeated_name = repeated_name:gsub("^%.", "")
                if not current_section then
                    error("unexpected repeated block without section header")
                end

                local list = current_section[repeated_name]
                if type(list) ~= "table" then
                    list = {}
                    current_section[repeated_name] = list
                end

                current_block = {}
                list[#list + 1] = current_block
            else
                local section_name = line:match("^%[(.-)%]$")
                if section_name then
                    current_section = {}
                    current_block = nil
                    sections[section_name] = current_section
                else
                    local key, value = line:match("^([^=]+)=(.*)$")
                    if key and current_section then
                        local destination = current_block or current_section
                        destination[string.trim(key)] = parse_lni_scalar(value)
                    end
                end
            end
        end
    end

    return sections
end

package.preload["lni-c"] = function()
    return function(buf, _, target)
        return parse_ui_lni(buf, target)
    end
end

package.preload["backend.ydwe_path"] = function()
    return function()
        return fs.path(ydwe_root)
    end
end

fs.ydwe_path = function()
    return fs.path(ydwe_root)
end

log = {
    trace = function() end,
    info = function() end,
    error = function() end,
}

global_config = {
    ThirdPartyPlugin = {
        EnableYDTrigger = "1",
    },
}

current_language = "zhCN"

local create_core = assert(loadfile(plugin_script_root .. "/backend/sandbox.lua"))()
local data_load_path = plugin_script_root .. "/backend/data_load.lua"
local data_load_chunk = assert(io.load(data_load_path), "missing data_load.lua at " .. data_load_path)
local data_load = assert(load(data_load_chunk, "@" .. data_load_path, "t"))()
local core = create_core(plugin_script_root .. "/core/", io.open, {
    ["w3xparser"] = require "w3xparser",
    ["lni"] = require "lni",
    ["lpeglabel"] = require "lpeglabel",
    ["lml"] = require "lml",
    ["lang"] = require "share.lang",
    ["data_load"] = data_load,
})
local config = require "share.config"

local function create_w2l()
    local w2l = type(core) == "function" and core() or core
    w2l.input_ar = {
        get = function() end,
        set = function() end,
        remove = function() end,
    }
    w2l.output_ar = {
        get = function() end,
        set = function() end,
        remove = function() end,
    }

    local set_setting = w2l.set_setting
    function w2l.set_setting(self, data)
        data = data or {}
        local setting = {}
        for k, v in pairs(config.global) do
            setting[k] = v
        end
        if config[data.mode] then
            for k, v in pairs(config[data.mode]) do
                setting[k] = v
            end
        end
        for k, v in pairs(data) do
            setting[k] = v
        end
        set_setting(self, setting)
    end

    w2l:set_setting()
    return w2l
end

local w2l = create_w2l()
w2l:set_setting({ mode = "lni" })

local wtg = assert(io.load(fs.path(wtg_path)), "missing WTG: " .. wtg_path)
local wct = assert(io.load(fs.path(wct_path)), "missing WCT: " .. wct_path)
local wts = wts_path and io.load(fs.path(wts_path)) or nil

local wtg_data = w2l:frontend_wtg(wtg)
local wct_data = w2l:frontend_wct(wct)
local files = w2l:backend_lml(wtg_data, wct_data, wts)

local output_root = fs.path(output_dir)
fs.create_directories(output_root)

for path, buf in pairs(files) do
    local target = output_root / path
    fs.create_directories(target:parent_path())
    io.save(target, buf)
end

io.write("DUMPED\n")
io.write(output_dir)
io.write("\n")
