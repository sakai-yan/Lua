local ydwe_root = assert(arg[1], "usage: canon_ydwe_frontend_probe.lua <ydwe-root> <wtg-path>")
local wtg_path = assert(arg[2], "usage: canon_ydwe_frontend_probe.lua <ydwe-root> <wtg-path>")

local function normalize_path(path)
    return (path:gsub("\\", "/"))
end

ydwe_root = normalize_path(ydwe_root)
wtg_path = normalize_path(wtg_path)

local source_script_root = ydwe_root .. "/source/Development/Component/plugin/w3x2lni/script"

package.path = table.concat({
    source_script_root .. "/?.lua",
    source_script_root .. "/?/init.lua",
    source_script_root .. "/core/?.lua",
    source_script_root .. "/core/?/init.lua",
    source_script_root .. "/share/?.lua",
    source_script_root .. "/share/?/init.lua",
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

current_language = "zhCN"

local function json_escape(value)
    return value:gsub('[%z\1-\31\\"]', function(char)
        if char == "\\" then
            return "\\\\"
        elseif char == '"' then
            return '\\"'
        elseif char == "\b" then
            return "\\b"
        elseif char == "\f" then
            return "\\f"
        elseif char == "\n" then
            return "\\n"
        elseif char == "\r" then
            return "\\r"
        elseif char == "\t" then
            return "\\t"
        end
        return ("\\u%04x"):format(char:byte())
    end)
end

local function is_array(value)
    if type(value) ~= "table" then
        return false
    end

    local count = 0
    local max = 0
    for key in pairs(value) do
        if type(key) ~= "number" or key < 1 or key % 1 ~= 0 then
            return false
        end
        if key > max then
            max = key
        end
        count = count + 1
    end

    return max == count
end

local function json_encode(value)
    local value_type = type(value)
    if value_type == "nil" then
        return "null"
    elseif value_type == "boolean" or value_type == "number" then
        return tostring(value)
    elseif value_type == "string" then
        return '"' .. json_escape(value) .. '"'
    elseif value_type == "table" then
        local parts = {}
        if is_array(value) then
            for index = 1, #value do
                parts[#parts + 1] = json_encode(value[index])
            end
            return "[" .. table.concat(parts, ",") .. "]"
        end

        local keys = {}
        for key in pairs(value) do
            keys[#keys + 1] = key
        end
        table.sort(keys, function(left, right)
            return tostring(left) < tostring(right)
        end)
        for _, key in ipairs(keys) do
            parts[#parts + 1] = json_encode(tostring(key)) .. ":" .. json_encode(value[key])
        end
        return "{" .. table.concat(parts, ",") .. "}"
    end

    error("unsupported json type: " .. value_type)
end

local function add_unique(target, seen, value)
    if value and value ~= "" and not seen[value] then
        seen[value] = true
        target[#target + 1] = value
    end
end

local ui_roots = {
    ydwe_root .. "/ui",
    ydwe_root .. "/share/ui",
    ydwe_root .. "/share/mpq",
    ydwe_root .. "/source/Development/Component/ui",
}

local loaded_ui_paths = {}

local function load_ui_entry(filename)
    local relative = filename:gsub("^ui\\", ""):gsub("\\", "/")
    for _, root in ipairs(ui_roots) do
        local candidate = fs.path(root) / relative
        local buf = io.load(candidate)
        if buf then
            loaded_ui_paths[#loaded_ui_paths + 1] = candidate:string()
            return buf
        end
    end
    return nil, "missing ui entry: " .. filename
end

local frontend_trg = require "slk.frontend_trg"
local frontend_wtg = require "slk.frontend_wtg"

local state = {
    ydweRoot = ydwe_root,
    wtgPath = wtg_path,
    frontendTrgPass = false,
    frontendWtgPass = false,
    triggerCount = 0,
    categoryCount = 0,
    variableCount = 0,
    metadataCounts = {
        event = 0,
        condition = 0,
        action = 0,
        call = 0,
    },
    metadataNames = {
        event = {},
        condition = {},
        action = {},
        call = {},
    },
    loadedUiPaths = loaded_ui_paths,
    firstFailStage = nil,
    firstFailMessage = nil,
}

local w2l = {
    setting = {
        data_ui = "${YDWE}",
    },
    messager = {
        report = function() end,
        text = function() end,
    },
    trg = nil,
}

function w2l:data_load(filename)
    return load_ui_entry(filename)
end

function w2l:frontend_trg()
    return frontend_trg(self)
end

local function collect_metadata(kind, table_name)
    local names = {}
    local seen = {}
    for name in pairs(table_name) do
        add_unique(names, seen, name)
    end
    table.sort(names)
    state.metadataCounts[kind] = #names
    state.metadataNames[kind] = names
end

local ok, trg_state = pcall(function()
    return frontend_trg(w2l)
end)

if not ok then
    state.firstFailStage = "frontend_trg"
    state.firstFailMessage = trg_state
    io.write(json_encode(state))
    os.exit(1, true)
end

state.frontendTrgPass = true
collect_metadata("event", trg_state.ui.event or {})
collect_metadata("condition", trg_state.ui.condition or {})
collect_metadata("action", trg_state.ui.action or {})
collect_metadata("call", trg_state.ui.call or {})

local wtg_bytes = assert(io.load(fs.path(wtg_path)), "unable to read wtg file")

local ok_wtg, chunk = pcall(function()
    return frontend_wtg(w2l, wtg_bytes)
end)

if not ok_wtg then
    state.firstFailStage = "frontend_wtg"
    state.firstFailMessage = chunk
    io.write(json_encode(state))
    os.exit(2, true)
end

state.frontendWtgPass = true
state.triggerCount = #(chunk.triggers or {})
state.categoryCount = #(chunk.categories or {})
state.variableCount = #(chunk.vars or {}) >= 2 and (#chunk.vars - 2) or 0

io.write(json_encode(state))
