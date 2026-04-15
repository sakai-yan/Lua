local Game = require "Game"
local Jass = require "Lib.API.Jass"

local Terrain = {}

--[[ Legacy malformed doc block kept disabled; updated public docs are defined below.
Terrain 地形高度同步查询库

设计目标:
1. 运行期所有玩家尽量读取同一份高度图数据，避免直接依赖本地接口 `MHGame_GetAxisZ`。
2. 缺少 baked `HeightMapCode` 时，只在初始化阶段进行一次采样，后续查询始终走同步的双线性插值。
3. 保留可选导出能力，方便执行“单机生成一次 -> 导入 HeightMapCode -> 联机只读”的工作流。

推荐工作流:
1. 开发阶段将 `WRITE_HEIGHT_MAP` 临时设为 `true`，启动地图生成高度图文件。
2. 将导出文件中的字符串回填到 Lua 根环境的 `TerrainHeightMapCode` 或 `HeightMapCode`。
3. 发布前将 `WRITE_HEIGHT_MAP` 恢复为 `false`，让联机环境只读取 baked 数据。

导出说明:
- 默认导出路径为 `MFLua\\TerrainHeightMap.lua`。
- 当前实现不再依赖 `os.execute`。
- 若目标目录不存在，会优先尝试可选 `filesystem` 或 `lfs` 模块创建目录。
- 若运行环境既没有目录创建能力、目标目录也不存在，则 `Terrain.writeHeightMap` 返回 `false, err`。

常用接口:
```lua
local Terrain = require "FrameWork.GameSetting.Terrain"

local z = Terrain.getZ(x, y)
local unit_z = Terrain.getUnitZ(unit_handle)
local ok, err = Terrain.writeHeightMap("MFLua\\TerrainHeightMap.lua")
```
--]]

-- Runtime queries must stay synced, so all players should read the same baked data.
-- MHGame_GetAxisZ is only used as a local sampler when baked data is missing.
local SAMPLE_STEP = 64.0
local SAMPLE_INV = 1.0 / SAMPLE_STEP
-- Set to true only when you intentionally want to export a fresh height-map file.
local WRITE_HEIGHT_MAP = false
-- Single-player only validation switch for imported TerrainHeightMapCode.
local VALIDATE_IMPORTED_HEIGHT_MAP = false
-- Default export target for Terrain.writeHeightMap.
local EXPORT_FILE_PATH = "MFLua\\TerrainHeightMap.lua"
-- Variable name written into the exported Lua file.
local EXPORT_VARIABLE_NAME = "TerrainHeightMapCode"
-- Optional inline baked code; global TerrainHeightMapCode / HeightMapCode takes precedence.
local CONFIGURED_HEIGHT_MAP_CODE = false

local MINIMUM_Z = -2048
local CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!$&()[]=?:;,._#*~/{}<>^"
local NUMBER_OF_CHARS = #CHARS
local DEBUG = rawget(_G, "__DEBUG__") == true

local abs = math.abs
local floor = math.floor

local io_open = io.open
local path_separator = package.config and package.config:sub(1, 1) or "\\"

local string_format = string.format
local string_gmatch = string.gmatch
local string_match = string.match
local string_sub = string.sub

local table_concat = table.concat

local GetLocationZ = Jass.GetLocationZ
local GetPlayerController = Jass.GetPlayerController
local GetPlayerSlotState = Jass.GetPlayerSlotState
local GetRectMaxX = Jass.GetRectMaxX
local GetRectMaxY = Jass.GetRectMaxY
local GetRectMinX = Jass.GetRectMinX
local GetRectMinY = Jass.GetRectMinY
local GetUnitFlyHeight = Jass.GetUnitFlyHeight
local GetUnitX = Jass.GetUnitX
local GetUnitY = Jass.GetUnitY
local GetWorldBounds = Jass.GetWorldBounds
local Location = Jass.Location
local MHGame_GetAxisZ = Jass.MHGame_GetAxisZ
local MoveLocation = Jass.MoveLocation
local Player = Jass.Player

local MAP_CONTROL_USER = Jass.MAP_CONTROL_USER
local PLAYER_SLOT_STATE_PLAYING = Jass.PLAYER_SLOT_STATE_PLAYING

local height_map = {}
local cell_coeff_a = {}
local cell_coeff_b = {}
local cell_coeff_c = {}
local cell_coeff_d = {}

local moveable_loc = nil

local sample_min_x = 0.0
local sample_min_y = 0.0
local sample_offset_x = 1.0
local sample_offset_y = 1.0

local point_cols = 0
local point_rows = 0
local row_stride = 0
local cell_cols = 0
local cell_rows = 0
local sample_count = 0

local is_ready = false
local is_initializing = false
local cached_height_map_code = false

local char_values = nil
local index_chars = nil
local filesystem = nil
local lua_filesystem = nil

do
    local ok, mod = pcall(require, "filesystem")
    if ok then
        filesystem = rawget(_G, "fs") or (type(mod) == "table" and mod or nil)
    end

    if not filesystem then
        local ok_lfs, mod = pcall(require, "lfs")
        if ok_lfs then
            lua_filesystem = mod
        end
    end
end

local function buildCharMaps()
    if char_values and index_chars then
        return char_values, index_chars
    end

    local values = {}
    local chars = {}
    for index = 1, NUMBER_OF_CHARS do
        local char = string_sub(CHARS, index, index)
        values[char] = index - 1
        chars[index] = char
    end

    char_values = values
    index_chars = chars
    return values, chars
end

local function getConfiguredHeightMapCode()
    return rawget(_G, "TerrainHeightMapCode")
        or rawget(_G, "HeightMapCode")
        or CONFIGURED_HEIGHT_MAP_CODE
end

local function isSinglePlayer()
    local user_controlled_players = 0

    for index = 0, 16 do
        if GetPlayerController(Player(index)) == MAP_CONTROL_USER
            and GetPlayerSlotState(Player(index)) == PLAYER_SLOT_STATE_PLAYING then
            user_controlled_players = user_controlled_players + 1
            if user_controlled_players > 1 then
                return false
            end
        end
    end

    return user_controlled_players == 1
end

local function sampleFallbackZ(x, y)
    if not moveable_loc then
        moveable_loc = Location(0.0, 0.0)
    end

    MoveLocation(moveable_loc, x, y)
    return GetLocationZ(moveable_loc)
end

local function sampleAxisZ(x, y)
    if MHGame_GetAxisZ then
        return MHGame_GetAxisZ(x, y)
    end
    return sampleFallbackZ(x, y)
end

local function captureWorldBounds()
    local world_bounds = GetWorldBounds()
    local world_min_x = GetRectMinX(world_bounds)
    local world_min_y = GetRectMinY(world_bounds)
    local world_max_x = GetRectMaxX(world_bounds)
    local world_max_y = GetRectMaxY(world_bounds)

    sample_min_x = floor(world_min_x * SAMPLE_INV) * SAMPLE_STEP
    sample_min_y = floor(world_min_y * SAMPLE_INV) * SAMPLE_STEP
    sample_offset_x = 1.0 - sample_min_x * SAMPLE_INV
    sample_offset_y = 1.0 - sample_min_y * SAMPLE_INV

    local sample_max_x = floor(world_max_x * SAMPLE_INV) * SAMPLE_STEP
    local sample_max_y = floor(world_max_y * SAMPLE_INV) * SAMPLE_STEP

    point_cols = floor((sample_max_x - sample_min_x) * SAMPLE_INV) + 1
    point_rows = floor((sample_max_y - sample_min_y) * SAMPLE_INV) + 1
    row_stride = point_rows
    cell_cols = point_cols - 1
    cell_rows = point_rows - 1
    sample_count = point_cols * point_rows
end

local function resetHeightMap()
    height_map = {}
    cached_height_map_code = false
end

local function rebuildCellCoefficients()
    local coeff_a = {}
    local coeff_b = {}
    local coeff_c = {}
    local coeff_d = {}

    for i = 1, cell_cols do
        local row_base = (i - 1) * row_stride
        local cell_base = (i - 1) * cell_rows

        for j = 1, cell_rows do
            local p00 = row_base + j
            local p10 = p00 + row_stride
            local p01 = p00 + 1
            local p11 = p10 + 1

            local h00 = height_map[p00]
            local h10 = height_map[p10]
            local h01 = height_map[p01]
            local h11 = height_map[p11]

            local cell_index = cell_base + j
            coeff_a[cell_index] = h00
            coeff_b[cell_index] = h10 - h00
            coeff_c[cell_index] = h01 - h00
            coeff_d[cell_index] = h11 - h10 - h01 + h00
        end
    end

    cell_coeff_a = coeff_a
    cell_coeff_b = coeff_b
    cell_coeff_c = coeff_c
    cell_coeff_d = coeff_d
end

local function buildHeightMapFromSampler()
    local x = sample_min_x

    for i = 1, point_cols do
        local row_base = (i - 1) * row_stride
        local y = sample_min_y

        for j = 1, point_rows do
            height_map[row_base + j] = sampleAxisZ(x, y)
            y = y + SAMPLE_STEP
        end

        x = x + SAMPLE_STEP
    end

    cached_height_map_code = false
end

local function encodeAbsoluteValue(value)
    local _, chars = buildCharMaps()
    local shifted = floor(value) - MINIMUM_Z
    local first_char_index = floor(shifted / NUMBER_OF_CHARS) + 1
    local second_char_index = shifted - floor(shifted / NUMBER_OF_CHARS) * NUMBER_OF_CHARS + 1
    return chars[first_char_index] .. chars[second_char_index]
end

local function encodeHeightMap()
    buildCharMaps()

    if cached_height_map_code then
        return cached_height_map_code
    end

    local parts = {}
    local segment_type = "abs"
    local last_value = 0
    local num_repetitions = 0

    for index = 1, sample_count do
        local current_value = floor(height_map[index])

        if index == 1 then
            parts[#parts + 1] = "|"
            parts[#parts + 1] = encodeAbsoluteValue(current_value)
            last_value = current_value
        else
            local diff = current_value - last_value

            if diff == 0 then
                num_repetitions = num_repetitions + 1
            else
                if num_repetitions > 0 then
                    parts[#parts + 1] = tostring(num_repetitions)
                    num_repetitions = 0
                end

                if diff > 0 and diff < NUMBER_OF_CHARS then
                    if segment_type ~= "plus" then
                        parts[#parts + 1] = "+"
                        segment_type = "plus"
                    end
                    parts[#parts + 1] = index_chars[diff + 1]
                elseif diff < 0 and -diff < NUMBER_OF_CHARS then
                    if segment_type ~= "minus" then
                        parts[#parts + 1] = "-"
                        segment_type = "minus"
                    end
                    parts[#parts + 1] = index_chars[-diff + 1]
                else
                    if segment_type ~= "abs" then
                        parts[#parts + 1] = "|"
                        segment_type = "abs"
                    end
                    parts[#parts + 1] = encodeAbsoluteValue(current_value)
                end

                last_value = current_value
            end
        end
    end

    if num_repetitions > 0 then
        parts[#parts + 1] = tostring(num_repetitions)
    end

    cached_height_map_code = table_concat(parts)
    return cached_height_map_code
end

local function decodeHeightMap(code)
    local values = buildCharMaps()
    local char_pos = 0
    local first_char = nil
    local num_repetitions = 0
    local segment_type = "abs"

    for index = 1, sample_count do
        if num_repetitions > 0 then
            height_map[index] = height_map[index - 1]
            num_repetitions = num_repetitions - 1
        else
            local value_determined = false

            while not value_determined do
                char_pos = char_pos + 1
                local char = string_sub(code, char_pos, char_pos)

                if char == "+" then
                    segment_type = "plus"
                    char_pos = char_pos + 1
                    char = string_sub(code, char_pos, char_pos)
                elseif char == "-" then
                    segment_type = "minus"
                    char_pos = char_pos + 1
                    char = string_sub(code, char_pos, char_pos)
                elseif char == "|" then
                    segment_type = "abs"
                    char_pos = char_pos + 1
                    char = string_sub(code, char_pos, char_pos)
                end

                if tonumber(char) then
                    local k = 0
                    while tonumber(string_sub(code, char_pos + k + 1, char_pos + k + 1)) do
                        k = k + 1
                    end
                    num_repetitions = tonumber(string_sub(code, char_pos, char_pos + k)) - 1
                    char_pos = char_pos + k
                    height_map[index] = height_map[index - 1]
                    value_determined = true
                elseif segment_type == "plus" then
                    height_map[index] = height_map[index - 1] + values[char]
                    value_determined = true
                elseif segment_type == "minus" then
                    height_map[index] = height_map[index - 1] - values[char]
                    value_determined = true
                elseif first_char then
                    local first_value = values[first_char]
                    local second_value = values[char]
                    if first_value and second_value then
                        height_map[index] = first_value * NUMBER_OF_CHARS + second_value + MINIMUM_Z
                    else
                        height_map[index] = 0
                    end
                    first_char = nil
                    value_determined = true
                else
                    first_char = char
                end
            end
        end
    end

    cached_height_map_code = code
end

local function buildExportLuaSource(code, variable_name)
    local export_name = variable_name or EXPORT_VARIABLE_NAME
    return table_concat({
        export_name, " = ", string_format("%q", code), "\n",
        "return ", export_name, "\n",
    })
end

local function toFilesystemPath(directory)
    if not filesystem or not filesystem.path then
        return directory
    end

    local ok, fs_path = pcall(filesystem.path, directory)
    if ok and fs_path then
        return fs_path
    end

    return directory
end

local function ensureDirectoryExistsWithLfs(directory)
    local current = ""
    local remaining = directory

    if string_match(remaining, "^%a:[/\\]") then
        current = string_sub(remaining, 1, 3)
        remaining = string_sub(remaining, 4)
    elseif string_match(remaining, "^[/\\]") then
        current = string_sub(remaining, 1, 1)
        remaining = string_sub(remaining, 2)
    end

    for segment in string_gmatch(remaining, "[^/\\]+") do
        if segment ~= "" and segment ~= "." then
            if current == ""
                or current == path_separator
                or string_match(current, "^%a:[/\\]$") then
                current = current .. segment
            else
                current = current .. path_separator .. segment
            end

            local attributes = lua_filesystem.attributes(current)
            if attributes then
                if attributes.mode ~= "directory" then
                    return false, "path exists but is not a directory: " .. current
                end
            else
                local ok, err = lua_filesystem.mkdir(current)
                if not ok then
                    return false, err
                end
            end
        end
    end

    return true
end

local function ensureDirectoryExists(directory)
    if not directory or directory == "" then
        return true
    end

    if filesystem then
        local fs_path = toFilesystemPath(directory)

        if filesystem.exists then
            local ok_exists, exists = pcall(filesystem.exists, fs_path)
            if ok_exists and exists then
                if filesystem.is_directory then
                    local ok_is_dir, is_dir = pcall(filesystem.is_directory, fs_path)
                    if not ok_is_dir then
                        return false, is_dir
                    end
                    if not is_dir then
                        return false, "path exists but is not a directory: " .. directory
                    end
                end
                return true
            end
        end

        if filesystem.create_directories then
            local ok_create, create_err = pcall(filesystem.create_directories, fs_path)
            if ok_create then
                return true
            end
            return false, create_err
        end
    end

    if lua_filesystem and lua_filesystem.attributes and lua_filesystem.mkdir then
        return ensureDirectoryExistsWithLfs(directory)
    end

    return false, "target directory is missing and no supported filesystem module is available: " .. directory
end

local function writeTextFile(file_path, text)
    local directory = string_match(file_path, "^(.*)[/\\][^/\\]+$")
    if directory and directory ~= "" then
        local ok, err = ensureDirectoryExists(directory)
        if not ok then
            return false, err
        end
    end

    local file, err = io_open(file_path, "wb")
    if not file then
        return false, err
    end

    local ok, write_err = file:write(text)
    file:close()

    if not ok then
        return false, write_err
    end

    return true
end

local function validateImportedHeightMap()
    if not VALIDATE_IMPORTED_HEIGHT_MAP or not isSinglePlayer() then
        return
    end

    local mismatched = 0
    local x = sample_min_x

    for i = 1, point_cols do
        local row_base = (i - 1) * row_stride
        local y = sample_min_y

        for j = 1, point_rows do
            if abs(sampleAxisZ(x, y) - height_map[row_base + j]) > 1.0 then
                mismatched = mismatched + 1
            end
            y = y + SAMPLE_STEP
        end

        x = x + SAMPLE_STEP
    end

    if mismatched > 0 then
        print("Terrain warning: imported HeightMapCode mismatched at " .. mismatched .. " sample points.")
    end
end

local function initializeHeightMap()
    captureWorldBounds()
    resetHeightMap()

    local code = getConfiguredHeightMapCode()
    if code and code ~= "" then
        decodeHeightMap(code)
        rebuildCellCoefficients()
        validateImportedHeightMap()
        return
    end

    buildHeightMapFromSampler()
    rebuildCellCoefficients()

    if WRITE_HEIGHT_MAP then
        local ok, err = writeTextFile(
            EXPORT_FILE_PATH,
            buildExportLuaSource(encodeHeightMap(), EXPORT_VARIABLE_NAME)
        )

        if not ok then
            print("Terrain warning: failed to export height map: " .. tostring(err))
        end
    elseif not isSinglePlayer() then
        print("Terrain warning: baked HeightMapCode is missing; local generation is not safe for release multiplayer.")
    end
end

local function ensureInitialized()
    if is_ready then
        return true
    end

    if is_initializing then
        return false
    end

    is_initializing = true
    local ok, err = pcall(initializeHeightMap)
    is_initializing = false

    if not ok then
        error(err, 0)
    end

    is_ready = true
    return true
end

local function queryZ(x, y)
    if DEBUG then
        assert(type(x) == "number" and type(y) == "number", "Terrain.getZ: x and y must be number")
    end

    if not is_ready and not ensureInitialized() then
        return 0.0
    end

    local rx = x * SAMPLE_INV + sample_offset_x
    local ry = y * SAMPLE_INV + sample_offset_y

    local i = floor(rx)
    local j = floor(ry)

    rx = rx - i
    ry = ry - j

    if i < 1 then
        i = 1
        rx = 0.0
    elseif i > cell_cols then
        i = cell_cols
        rx = 1.0
    end

    if j < 1 then
        j = 1
        ry = 0.0
    elseif j > cell_rows then
        j = cell_rows
        ry = 1.0
    end

    local cell_index = (i - 1) * cell_rows + j
    return cell_coeff_a[cell_index]
        + cell_coeff_b[cell_index] * rx
        + cell_coeff_c[cell_index] * ry
        + cell_coeff_d[cell_index] * rx * ry
end

--- Returns whether the terrain height map has completed initialization.
--- Useful for debugging callers that may run before `Game.hookInit`.
--- @return boolean ready
function Terrain.isReady()
    return is_ready
end

--[[

--- 将当前高度图编码写出为 Lua 文件。
--- 适合单机生成一次 baked 数据，然后将结果回填到 `TerrainHeightMapCode`。
--- @param file_path string|nil 导出目标路径，默认 `MFLua\\TerrainHeightMap.lua`
--- @param variable_name string|nil 导出变量名，默认 `TerrainHeightMapCode`
--- @return boolean ok 是否写入成功
--- @return string|nil err 失败时返回错误信息
function Terrain.writeHeightMap(file_path, variable_name)
    if not ensureInitialized() then
        return false, "failed to build terrain height map source"
    end

    return writeTextFile(
        file_path or EXPORT_FILE_PATH,
        buildExportLuaSource(encodeHeightMap(), variable_name)
    )
end

--- 返回指定坐标的地表高度。
--- 这是库的主入口，结果来自初始化后的高度图双线性插值。
--- @param x number 世界坐标 X
--- @param y number 世界坐标 Y
--- @return number z 地表高度
Terrain.getLocZ = queryZ

--- `Terrain.getZ` 的同义接口，保留旧命名兼容。
--- @param x number 世界坐标 X
--- @param y number 世界坐标 Y
--- @return number z 地表高度
Terrain.getTerrainZ = queryZ

--- 返回指定坐标的地表高度。
--- 推荐在同步逻辑里使用此接口，而不是直接调用本地采样 API。
--- @param x number 世界坐标 X
--- @param y number 世界坐标 Y
--- @return number z 地表高度
Terrain.getZ = queryZ

--- 返回单位当前世界 Z 坐标。
--- 结果等于地表高度加飞行高度。
--- @param unit_handle unit|nil 单位句柄
--- @return number z 单位当前 Z 坐标；句柄为空时返回 0
function Terrain.getUnitZ(unit_handle)
    if unit_handle == nil then
        return 0.0
    end

    local x = GetUnitX(unit_handle)
    local y = GetUnitY(unit_handle)
    return queryZ(x, y) + GetUnitFlyHeight(unit_handle)
end

--- 返回单位当前的世界坐标。
--- @param unit_handle unit|nil 单位句柄
--- @return number x
--- @return number y
--- @return number z 结果等于地表高度加飞行高度；句柄为空时返回 0, 0, 0
function Terrain.getUnitCoordinates(unit_handle)
    if unit_handle == nil then
        return 0.0, 0.0, 0.0
    end

    local x = GetUnitX(unit_handle)
    local y = GetUnitY(unit_handle)
    return x, y, queryZ(x, y) + GetUnitFlyHeight(unit_handle)
end

--]]

--- Exports the current height-map code as a Lua file.
--- Recommended workflow: generate once in single-player, then import the string as `TerrainHeightMapCode`.
--- @param file_path string|nil export target path, defaults to `MFLua\\TerrainHeightMap.lua`
--- @param variable_name string|nil exported variable name, defaults to `TerrainHeightMapCode`
--- @return boolean ok
--- @return string|nil err
function Terrain.writeHeightMap(file_path, variable_name)
    if not ensureInitialized() then
        return false, "failed to build terrain height map source"
    end

    return writeTextFile(
        file_path or EXPORT_FILE_PATH,
        buildExportLuaSource(encodeHeightMap(), variable_name)
    )
end

--- Alias of `Terrain.getZ`.
--- @param x number world X
--- @param y number world Y
--- @return number z
Terrain.getLocZ = queryZ

--- Alias of `Terrain.getZ`, kept for older naming habits.
--- @param x number world X
--- @param y number world Y
--- @return number z
Terrain.getTerrainZ = queryZ

--- Returns the terrain surface height at the given coordinates.
--- This is the main synchronized query entry point for gameplay code.
--- @param x number world X
--- @param y number world Y
--- @return number z
Terrain.getZ = queryZ

--- Returns the unit world Z coordinate.
--- The result equals terrain height plus fly height.
--- @param unit_handle unit|nil
--- @return number z
function Terrain.getUnitZ(unit_handle)
    if unit_handle == nil then
        return 0.0
    end

    local x = GetUnitX(unit_handle)
    local y = GetUnitY(unit_handle)
    return queryZ(x, y) + GetUnitFlyHeight(unit_handle)
end

--- Returns the unit world coordinates.
--- @param unit_handle unit|nil
--- @return number x
--- @return number y
--- @return number z
function Terrain.getUnitCoordinates(unit_handle)
    if unit_handle == nil then
        return 0.0, 0.0, 0.0
    end

    local x = GetUnitX(unit_handle)
    local y = GetUnitY(unit_handle)
    return x, y, queryZ(x, y) + GetUnitFlyHeight(unit_handle)
end

Game.hookInit(ensureInitialized)

return Terrain
