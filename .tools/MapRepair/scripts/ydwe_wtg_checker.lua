local ydwe_root = assert(arg[1], "usage: ydwe_wtg_checker.lua <ydwe-root> <wtg-path>")
local wtg_path = assert(arg[2], "usage: ydwe_wtg_checker.lua <ydwe-root> <wtg-path>")

local function normalize_path(path)
    return (path:gsub("\\", "/"))
end

ydwe_root = normalize_path(ydwe_root)
wtg_path = normalize_path(wtg_path)

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

local checker = require "fix-wtg.checker"
local load_triggerdata = require "triggerdata"
local ui_list = require "ui"
local _, _, state = load_triggerdata(ui_list, true)

if arg[3] == "--has-action" then
    local action_name = assert(arg[4], "usage: ydwe_wtg_checker.lua <ydwe-root> <wtg-path> --has-action <action-name>")
    local action = state.ui and state.ui.action and state.ui.action[action_name]
    if not action then
        io.write("MISSING\n")
        os.exit(2, true)
    end

    io.write("FOUND ")
    io.write(tostring(#(action.args or {})))
    io.write("\n")
    os.exit(0, true)
end

local wtg = io.load(fs.path(wtg_path))

if arg[3] == "--debug-missing" then
    local type_map = {
        [0] = "event",
        [1] = "condition",
        [2] = "action",
        [3] = "call",
    }

    local index = 1
    local a
    local b
    local read_eca

    local function get_ui_arg_count(kind, name)
        local item = state.ui[kind] and state.ui[kind][name]
        if not item then
            error(("MISSING %s %s"):format(tostring(kind), tostring(name)))
        end

        local count = 0
        if item.args then
            for _, parameter in ipairs(item.args) do
                if parameter.type ~= "nothing" then
                    count = count + 1
                end
            end
        end

        return count
    end

    local function read_head()
        local signature
        signature, b, index = string.unpack("c4l", wtg, index)
        assert(signature == "WTG!" and b == 7, "invalid WTG header")
    end

    local function read_category()
        _, _, _, index = string.unpack("lzl", wtg, index)
    end

    local function read_categories()
        a, index = string.unpack("l", wtg, index)
        for _ = 1, a do
            read_category()
        end
    end

    local function read_var()
        _, _, _, _, _, _, _, index = string.unpack("zzllllz", wtg, index)
    end

    local function read_vars()
        _, a, index = string.unpack("ll", wtg, index)
        for _ = 1, a do
            read_var()
        end
    end

    local function read_int()
        local value
        value, index = string.unpack("l", wtg, index)
        return value
    end

    local function read_cstring()
        local value
        value, index = string.unpack("z", wtg, index)
        return value
    end

    local function read_arg()
        read_int()
        read_cstring()

        local has_call = read_int()
        if has_call == 1 then
            read_eca(false, true)
        end

        local has_array_index = read_int()
        if has_array_index == 1 then
            read_arg()
        end
    end

    local function read_child_ecas(count)
        for _ = 1, count do
            read_eca(true)
        end
    end

    function read_eca(is_child, _)
        local kind = read_int()
        if is_child then
            read_int()
        end

        local name = read_cstring()
        read_int()

        local count = get_ui_arg_count(type_map[kind], name)
        for _ = 1, count do
            read_arg()
        end

        local child_count = read_int()
        if child_count > 0 then
            read_child_ecas(child_count)
        end
    end

    local function read_trigger()
        _, _, index = string.unpack("zz", wtg, index)
        index = index + 24

        local root_count = read_int()
        for _ = 1, root_count do
            read_eca(false)
        end
    end

    local function read_triggers()
        a, index = string.unpack("l", wtg, index)
        for _ = 1, a do
            read_trigger()
        end
    end

    local ok, message = pcall(function()
        read_head()
        read_categories()
        read_vars()
        read_triggers()
    end)

    if ok then
        io.write("PASS\n")
        os.exit(0, true)
    end

    io.stderr:write(message or "debug walk failed")
    os.exit(1, true)
end

local ok, err = checker(wtg, state)

if not ok then
    io.stderr:write(err or "YDWE checker rejected WTG")
    os.exit(1, true)
end

io.write("PASS\n")
