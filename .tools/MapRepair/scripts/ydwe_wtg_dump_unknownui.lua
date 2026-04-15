local ydwe_root = assert(arg[1], "usage: ydwe_wtg_dump_unknownui.lua <ydwe-root> <wtg-path> <output-dir>")
local wtg_path = assert(arg[2], "usage: ydwe_wtg_dump_unknownui.lua <ydwe-root> <wtg-path> <output-dir>")
local output_dir = assert(arg[3], "usage: ydwe_wtg_dump_unknownui.lua <ydwe-root> <wtg-path> <output-dir>")

local function normalize_path(path)
    return (path:gsub("\\", "/"))
end

ydwe_root = normalize_path(ydwe_root)
wtg_path = normalize_path(wtg_path)
output_dir = normalize_path(output_dir)

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
    local file = assert(io.open(path, "rb"))
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

local ui = require "ui-builder.init"
local load_triggerdata = require "triggerdata"
local reader = require "fix-wtg.reader"
local ui_list = require "ui"

local _, _, state = load_triggerdata(ui_list, false)
local wtg = io.load(fs.path(wtg_path))
local ok, chunk_or_error, fix = pcall(reader, wtg, state)
if not ok then
    io.stderr:write(chunk_or_error or "wtg reader failed")
    os.exit(1, true)
end

fs.create_directories(fs.path(output_dir))
local define_txt, event_txt, condition_txt, action_txt, call_txt = ui.new_writer(fix)
io.save(fs.path(output_dir) / "define.txt", define_txt)
io.save(fs.path(output_dir) / "event.txt", event_txt)
io.save(fs.path(output_dir) / "condition.txt", condition_txt)
io.save(fs.path(output_dir) / "action.txt", action_txt)
io.save(fs.path(output_dir) / "call.txt", call_txt)

io.write("DUMPED\n")
io.write(output_dir)
io.write("\n")
