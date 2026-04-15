local excel = {}

local TRIM_PATTERN = "^%s*(.-)%s*$"
local ZIP_EOCD_SIGNATURE = 0x06054B50
local ZIP_CENTRAL_SIGNATURE = 0x02014B50
local ZIP_LOCAL_SIGNATURE = 0x04034B50
local DEFLATE_STORED = 0
local DEFLATE_FIXED = 1
local DEFLATE_DYNAMIC = 2
local WINDOW_SIZE = 32768
local CHUNK_SIZE = 4096

local table_insert = table.insert
local table_concat = table.concat
local table_unpack = table.unpack
local string_byte = string.byte
local string_char = string.char
local string_find = string.find
local string_gsub = string.gsub
local string_sub = string.sub
local string_unpack = string.unpack
local math_min = math.min
local math_max = math.max
local tonumber = tonumber
local tostring = tostring
local type = type
local pcall = pcall
local setmetatable = setmetatable
local io_open = io.open
local utf8_char = utf8 and utf8.char

excel.header = true
excel.skip_empty = true
excel.trim = false
excel.sheet = 1
excel.infer_types = false

local LENGTH_BASE = {
    3, 4, 5, 6, 7, 8, 9, 10,
    11, 13, 15, 17,
    19, 23, 27, 31,
    35, 43, 51, 59,
    67, 83, 99, 115,
    131, 163, 195, 227,
    258
}

local LENGTH_EXTRA = {
    0, 0, 0, 0, 0, 0, 0, 0,
    1, 1, 1, 1,
    2, 2, 2, 2,
    3, 3, 3, 3,
    4, 4, 4, 4,
    5, 5, 5, 5,
    0
}

local DISTANCE_BASE = {
    1, 2, 3, 4, 5, 7, 9, 13,
    17, 25, 33, 49, 65, 97, 129, 193,
    257, 385, 513, 769, 1025, 1537, 2049, 3073,
    4097, 6145, 8193, 12289, 16385, 24577
}

local DISTANCE_EXTRA = {
    0, 0, 0, 0, 1, 1, 2, 2,
    3, 3, 4, 4, 5, 5, 6, 6,
    7, 7, 8, 8, 9, 9, 10, 10,
    11, 11, 12, 12, 13, 13
}

local CODE_LENGTH_ORDER = {
    16, 17, 18, 0, 8, 7, 9, 6, 10,
    5, 11, 4, 12, 3, 13, 2, 14, 1, 15
}

local fixed_literal_tree
local fixed_distance_tree

local function trim_string(value)
    return (value:match(TRIM_PATTERN)) or value
end

local function clone_array(values)
    local cloned = {}
    for index = 1, #values do
        cloned[index] = values[index]
    end
    return cloned
end

local function escape_pattern(value)
    return (value:gsub("(%W)", "%%%1"))
end

local function decode_codepoint(codepoint)
    if not codepoint or not utf8_char then
        return nil
    end
    local ok, result = pcall(utf8_char, codepoint)
    if ok then
        return result
    end
end

local function decode_xml_text(value)
    if not value or value == "" then
        return ""
    end
    value = string_gsub(value, "&#x([0-9A-Fa-f]+);", function(hex)
        return decode_codepoint(tonumber(hex, 16)) or ("&#x" .. hex .. ";")
    end)
    value = string_gsub(value, "&#([0-9]+);", function(decimal)
        return decode_codepoint(tonumber(decimal, 10)) or ("&#" .. decimal .. ";")
    end)
    value = string_gsub(value, "&lt;", "<")
    value = string_gsub(value, "&gt;", ">")
    value = string_gsub(value, "&quot;", "\"")
    value = string_gsub(value, "&apos;", "'")
    value = string_gsub(value, "&amp;", "&")
    return value
end

local function read_attribute(source, name)
    local pattern = escape_pattern(name)
    local value = source:match(pattern .. '%s*=%s*"(.-)"')
    if value ~= nil then
        return decode_xml_text(value)
    end
    value = source:match(pattern .. "%s*=%s*'(.-)'")
    if value ~= nil then
        return decode_xml_text(value)
    end
end

local function is_tag_boundary(character)
    return character == ""
        or character == " "
        or character == "\n"
        or character == "\r"
        or character == "\t"
        or character == "/"
        or character == ">"
end

local function find_element(xml, position, tag_name)
    local search = "<" .. tag_name
    local search_length = #search
    while true do
        local start_pos = string_find(xml, search, position, true)
        if not start_pos then
            return nil
        end
        local boundary = string_sub(xml, start_pos + search_length, start_pos + search_length)
        if is_tag_boundary(boundary) then
            local tag_end = string_find(xml, ">", start_pos, true)
            if not tag_end then
                return nil, "Excel: XML 标签未闭合: " .. tag_name
            end
            local attributes_text = trim_string(string_sub(xml, start_pos + search_length, tag_end - 1))
            local self_closing = string_sub(attributes_text, -1) == "/"
            if self_closing then
                attributes_text = trim_string(string_sub(attributes_text, 1, -2))
                return {
                    attributes_text = attributes_text,
                    body = "",
                    self_closing = true,
                    next_pos = tag_end + 1
                }
            end
            local close_tag = "</" .. tag_name .. ">"
            local close_pos = string_find(xml, close_tag, tag_end + 1, true)
            if not close_pos then
                return nil, "Excel: XML 缺少结束标签: " .. tag_name
            end
            return {
                attributes_text = attributes_text,
                body = string_sub(xml, tag_end + 1, close_pos - 1),
                self_closing = false,
                next_pos = close_pos + #close_tag
            }
        end
        position = start_pos + search_length
    end
end

local function collect_text_nodes(xml)
    local parts = {}
    local position = 1
    while true do
        local element, err = find_element(xml, position, "t")
        if err then
            error(err, 0)
        end
        if not element then
            break
        end
        parts[#parts + 1] = decode_xml_text(element.body)
        position = element.next_pos
    end
    return table_concat(parts)
end

local function normalize_zip_path(path)
    local normalized = {}
    local raw_path = path
    if string_sub(raw_path, 1, 1) == "/" then
        raw_path = string_sub(raw_path, 2)
    end
    for segment in raw_path:gmatch("[^/]+") do
        if segment == ".." then
            normalized[#normalized] = nil
        elseif segment ~= "." and segment ~= "" then
            normalized[#normalized + 1] = segment
        end
    end
    return table_concat(normalized, "/")
end

local function normalize_workbook_target(target)
    if string_sub(target, 1, 1) == "/" or target:match("^xl/") then
        return normalize_zip_path(target)
    end
    return normalize_zip_path("xl/" .. target)
end

local function cell_ref_to_column(ref)
    if not ref or ref == "" then
        return nil
    end
    local letters = ref:match("^([A-Za-z]+)")
    if not letters then
        return nil
    end
    letters = letters:upper()
    local column = 0
    for index = 1, #letters do
        column = column * 26 + (letters:byte(index) - 64)
    end
    return column
end

local function is_empty_row(values, count)
    for index = 1, count do
        if values[index] ~= nil and values[index] ~= "" then
            return false
        end
    end
    return true
end

local function normalize_headers(values, count)
    local headers = {}
    for index = 1, count do
        local value = values[index]
        if value == nil then
            headers[index] = ""
        elseif type(value) == "string" then
            headers[index] = value
        else
            headers[index] = tostring(value)
        end
    end
    return headers
end

local function build_row_data(values, headers, use_header)
    local row = {}
    local value_count = #values
    local header_count = headers and #headers or 0
    local count = math_max(value_count, header_count)
    for index = 1, count do
        local value = values[index]
        if value == nil then
            value = ""
        end
        row[index] = value
    end
    if use_header and header_count > 0 then
        for index = 1, header_count do
            local key = headers[index]
            if key and key ~= "" then
                row[key] = row[index]
            end
        end
    end
    return row
end

local function has_non_zero(lengths)
    for index = 1, #lengths do
        if lengths[index] and lengths[index] > 0 then
            return true
        end
    end
    return false
end

local OutputBuffer = {}
OutputBuffer.__index = OutputBuffer

function OutputBuffer.new()
    return setmetatable({
        window = {},
        window_head = 0,
        chunk_bytes = {},
        chunk_count = 0,
        chunks = {}
    }, OutputBuffer)
end

function OutputBuffer:_flush_chunk()
    if self.chunk_count == 0 then
        return
    end
    self.chunks[#self.chunks + 1] = string_char(table_unpack(self.chunk_bytes, 1, self.chunk_count))
    self.chunk_bytes = {}
    self.chunk_count = 0
end

function OutputBuffer:emit_byte(byte_value)
    self.chunk_count = self.chunk_count + 1
    self.chunk_bytes[self.chunk_count] = byte_value
    if self.chunk_count >= CHUNK_SIZE then
        self:_flush_chunk()
    end
    self.window_head = self.window_head + 1
    self.window[((self.window_head - 1) % WINDOW_SIZE) + 1] = byte_value
end

function OutputBuffer:copy(distance, length)
    if distance < 1 then
        error("Excel: 无效的压缩距离", 0)
    end
    local start = self.window_head - distance + 1
    if start < 1 then
        error("Excel: 压缩距离超出历史窗口", 0)
    end
    for offset = 0, length - 1 do
        local source_position = start + offset
        local byte_value = self.window[((source_position - 1) % WINDOW_SIZE) + 1]
        if byte_value == nil then
            error("Excel: 无法从历史窗口复制压缩数据", 0)
        end
        self:emit_byte(byte_value)
    end
end

function OutputBuffer:finish()
    self:_flush_chunk()
    return table_concat(self.chunks)
end

local BitStream = {}
BitStream.__index = BitStream

function BitStream.new(data)
    return setmetatable({
        data = data,
        pos = 1,
        bit_buffer = 0,
        bit_count = 0
    }, BitStream)
end

function BitStream:_ensure(bits)
    while self.bit_count < bits do
        local byte_value = string_byte(self.data, self.pos)
        if not byte_value then
            return nil, "Excel: 压缩数据意外结束"
        end
        self.bit_buffer = self.bit_buffer | (byte_value << self.bit_count)
        self.bit_count = self.bit_count + 8
        self.pos = self.pos + 1
    end
    return true
end

function BitStream:read(bits)
    local ok, err = self:_ensure(bits)
    if not ok then
        error(err, 0)
    end
    local mask = (1 << bits) - 1
    local value = self.bit_buffer & mask
    self.bit_buffer = self.bit_buffer >> bits
    self.bit_count = self.bit_count - bits
    return value
end

function BitStream:align_byte()
    local drop = self.bit_count % 8
    if drop > 0 then
        self:read(drop)
    end
end

function BitStream:read_aligned_byte()
    if self.bit_count >= 8 then
        return self:read(8)
    end
    local byte_value = string_byte(self.data, self.pos)
    if not byte_value then
        error("Excel: 压缩数据意外结束", 0)
    end
    self.pos = self.pos + 1
    return byte_value
end

local function reverse_bits(value, width)
    local result = 0
    for _ = 1, width do
        result = (result << 1) | (value & 1)
        value = value >> 1
    end
    return result
end

local function build_huffman_tree(lengths)
    local counts = {}
    local max_bits = 0
    for index = 1, #lengths do
        local length = lengths[index] or 0
        if length > 0 then
            counts[length] = (counts[length] or 0) + 1
            if length > max_bits then
                max_bits = length
            end
        end
    end
    local code = 0
    local next_code = {}
    for bits = 1, max_bits do
        code = (code + (counts[bits - 1] or 0)) << 1
        next_code[bits] = code
    end
    local root = {}
    for symbol = 0, #lengths - 1 do
        local length = lengths[symbol + 1] or 0
        if length > 0 then
            local assigned = next_code[length]
            next_code[length] = assigned + 1
            local reversed = reverse_bits(assigned, length)
            local node = root
            for bit_index = 1, length do
                local bit = (reversed >> (bit_index - 1)) & 1
                if bit_index == length then
                    node[bit] = symbol
                else
                    local child = node[bit]
                    if type(child) ~= "table" then
                        child = {}
                        node[bit] = child
                    end
                    node = child
                end
            end
        end
    end
    return root
end

local function decode_symbol(stream, tree)
    local node = tree
    while type(node) ~= "number" do
        local bit = stream:read(1)
        node = node[bit]
        if node == nil then
            error("Excel: 遇到无效的 Huffman 编码", 0)
        end
    end
    return node
end

local function get_fixed_trees()
    if fixed_literal_tree and fixed_distance_tree then
        return fixed_literal_tree, fixed_distance_tree
    end
    local literal_lengths = {}
    for symbol = 0, 287 do
        if symbol <= 143 then
            literal_lengths[symbol + 1] = 8
        elseif symbol <= 255 then
            literal_lengths[symbol + 1] = 9
        elseif symbol <= 279 then
            literal_lengths[symbol + 1] = 7
        else
            literal_lengths[symbol + 1] = 8
        end
    end
    local distance_lengths = {}
    for index = 1, 32 do
        distance_lengths[index] = 5
    end
    fixed_literal_tree = build_huffman_tree(literal_lengths)
    fixed_distance_tree = build_huffman_tree(distance_lengths)
    return fixed_literal_tree, fixed_distance_tree
end

local function read_dynamic_trees(stream)
    local hlit = stream:read(5) + 257
    local hdist = stream:read(5) + 1
    local hclen = stream:read(4) + 4
    local code_length_lengths = {}
    for index = 1, 19 do
        code_length_lengths[index] = 0
    end
    for index = 1, hclen do
        code_length_lengths[CODE_LENGTH_ORDER[index] + 1] = stream:read(3)
    end
    local code_length_tree = build_huffman_tree(code_length_lengths)
    local lengths = {}
    local total = hlit + hdist
    local cursor = 1
    while cursor <= total do
        local symbol = decode_symbol(stream, code_length_tree)
        if symbol <= 15 then
            lengths[cursor] = symbol
            cursor = cursor + 1
        elseif symbol == 16 then
            local repeat_count = stream:read(2) + 3
            local previous = lengths[cursor - 1]
            if previous == nil then
                error("Excel: 动态 Huffman 长度码缺少前置值", 0)
            end
            for _ = 1, repeat_count do
                lengths[cursor] = previous
                cursor = cursor + 1
            end
        elseif symbol == 17 then
            local repeat_count = stream:read(3) + 3
            for _ = 1, repeat_count do
                lengths[cursor] = 0
                cursor = cursor + 1
            end
        elseif symbol == 18 then
            local repeat_count = stream:read(7) + 11
            for _ = 1, repeat_count do
                lengths[cursor] = 0
                cursor = cursor + 1
            end
        else
            error("Excel: 未知的动态 Huffman 长度码", 0)
        end
    end
    local literal_lengths = {}
    local distance_lengths = {}
    for index = 1, hlit do
        literal_lengths[index] = lengths[index] or 0
    end
    for index = 1, hdist do
        distance_lengths[index] = lengths[hlit + index] or 0
    end
    if not has_non_zero(distance_lengths) then
        distance_lengths[1] = 1
    end
    return build_huffman_tree(literal_lengths), build_huffman_tree(distance_lengths)
end

local function inflate_deflate(data)
    local stream = BitStream.new(data)
    local output = OutputBuffer.new()
    local is_final = false
    while not is_final do
        is_final = stream:read(1) == 1
        local block_type = stream:read(2)
        if block_type == DEFLATE_STORED then
            stream:align_byte()
            local len = stream:read_aligned_byte() | (stream:read_aligned_byte() << 8)
            local nlen = stream:read_aligned_byte() | (stream:read_aligned_byte() << 8)
            if ((len ~ nlen) & 0xFFFF) ~= 0xFFFF then
                error("Excel: 未压缩块长度校验失败", 0)
            end
            for _ = 1, len do
                output:emit_byte(stream:read_aligned_byte())
            end
        elseif block_type == DEFLATE_FIXED or block_type == DEFLATE_DYNAMIC then
            local literal_tree
            local distance_tree
            if block_type == DEFLATE_FIXED then
                literal_tree, distance_tree = get_fixed_trees()
            else
                literal_tree, distance_tree = read_dynamic_trees(stream)
            end
            while true do
                local symbol = decode_symbol(stream, literal_tree)
                if symbol < 256 then
                    output:emit_byte(symbol)
                elseif symbol == 256 then
                    break
                else
                    local length_index = symbol - 257 + 1
                    local base_length = LENGTH_BASE[length_index]
                    if not base_length then
                        error("Excel: 长度码超出支持范围", 0)
                    end
                    local extra_length = LENGTH_EXTRA[length_index]
                    local length = base_length + (extra_length > 0 and stream:read(extra_length) or 0)
                    local distance_symbol = decode_symbol(stream, distance_tree)
                    local base_distance = DISTANCE_BASE[distance_symbol + 1]
                    if not base_distance then
                        error("Excel: 距离码超出支持范围", 0)
                    end
                    local extra_distance = DISTANCE_EXTRA[distance_symbol + 1]
                    local distance = base_distance + (extra_distance > 0 and stream:read(extra_distance) or 0)
                    output:copy(distance, length)
                end
            end
        else
            error("Excel: 不支持的 DEFLATE 块类型", 0)
        end
    end
    return output:finish()
end

local ZipArchive = {}
ZipArchive.__index = ZipArchive

function ZipArchive.open(file_path)
    local file, err = io_open(file_path, "rb")
    if not file then
        return nil, "Excel: 无法打开文件: " .. (err or "未知错误")
    end
    local archive = setmetatable({
        file = file,
        file_path = file_path,
        entries = {},
        closed = false
    }, ZipArchive)
    local ok, open_err = pcall(archive._load_entries, archive)
    if not ok then
        archive:close()
        return nil, open_err
    end
    return archive
end

function ZipArchive:_load_entries()
    local file_size = self.file:seek("end")
    if not file_size or file_size < 22 then
        error("Excel: 文件不是有效的 OpenXML 工作簿", 0)
    end
    local tail_size = math_min(file_size, 65557)
    self.file:seek("set", file_size - tail_size)
    local tail = self.file:read(tail_size)
    local eocd_pos
    for index = #tail - 3, 1, -1 do
        if tail:byte(index) == 0x50
            and tail:byte(index + 1) == 0x4B
            and tail:byte(index + 2) == 0x05
            and tail:byte(index + 3) == 0x06 then
            eocd_pos = index
            break
        end
    end
    if not eocd_pos then
        error("Excel: 当前仅支持 OpenXML 工作簿（xlsx/xlsm/xltx/xltm）", 0)
    end
    local signature, _, _, _, total_entries, central_size, central_offset = string_unpack(
        "<I4I2I2I2I2I4I4I2",
        tail,
        eocd_pos
    )
    if signature ~= ZIP_EOCD_SIGNATURE then
        error("Excel: ZIP 目录结束标记损坏", 0)
    end
    if total_entries == 0xFFFF or central_offset == 0xFFFFFFFF then
        error("Excel: 暂不支持 ZIP64 工作簿", 0)
    end
    self.file:seek("set", central_offset)
    local directory = self.file:read(central_size)
    local position = 1
    for _ = 1, total_entries do
        local central_signature, _, _, flag, method, _, _, _, compressed_size, uncompressed_size,
            name_length, extra_length, comment_length, _, _, _, local_offset, next_pos = string_unpack(
            "<I4I2I2I2I2I2I2I4I4I4I2I2I2I2I2I4I4",
            directory,
            position
        )
        if central_signature ~= ZIP_CENTRAL_SIGNATURE then
            error("Excel: ZIP 中央目录损坏", 0)
        end
        local name = string_sub(directory, next_pos, next_pos + name_length - 1)
        self.entries[name] = {
            name = name,
            flag = flag,
            method = method,
            compressed_size = compressed_size,
            uncompressed_size = uncompressed_size,
            local_offset = local_offset
        }
        position = next_pos + name_length + extra_length + comment_length
    end
end

function ZipArchive:close()
    if not self.closed and self.file then
        self.file:close()
        self.file = nil
        self.closed = true
    end
end

function ZipArchive:read_entry(name)
    if self.closed then
        return nil, "Excel: ZIP 归档已关闭"
    end
    local entry = self.entries[name]
    if not entry then
        return nil, "Excel: 工作簿缺少必要条目: " .. name
    end
    if (entry.flag & 0x0001) ~= 0 then
        return nil, "Excel: 不支持加密的工作簿"
    end
    if entry.method ~= 0 and entry.method ~= 8 then
        return nil, "Excel: 不支持的 ZIP 压缩方法: " .. tostring(entry.method)
    end
    self.file:seek("set", entry.local_offset)
    local header = self.file:read(30)
    if not header or #header < 30 then
        return nil, "Excel: 无法读取 ZIP 本地头: " .. name
    end
    local signature, _, _, _, _, _, _, _, _, name_length, extra_length = string_unpack(
        "<I4I2I2I2I2I2I4I4I4I2I2",
        header
    )
    if signature ~= ZIP_LOCAL_SIGNATURE then
        return nil, "Excel: ZIP 本地头损坏: " .. name
    end
    local data_offset = entry.local_offset + 30 + name_length + extra_length
    self.file:seek("set", data_offset)
    local compressed = self.file:read(entry.compressed_size)
    if not compressed or #compressed < entry.compressed_size then
        return nil, "Excel: 无法读取压缩数据: " .. name
    end
    if entry.method == 0 then
        return compressed
    end
    local ok, inflated = pcall(inflate_deflate, compressed)
    if not ok then
        return nil, inflated
    end
    if entry.uncompressed_size and entry.uncompressed_size > 0 and #inflated ~= entry.uncompressed_size then
        return nil, "Excel: 解压结果长度与目录记录不一致: " .. name
    end
    return inflated
end

local function resolve_cell_value(cell_body, cell_type, config, shared_strings)
    local value
    if cell_type == "inlineStr" then
        value = collect_text_nodes(cell_body)
    else
        value = cell_body:match("<v[^>]*>(.-)</v>")
        if value ~= nil then
            value = decode_xml_text(value)
        end
        if cell_type == "s" then
            local index = tonumber(value)
            value = index and shared_strings[index + 1] or ""
        elseif cell_type == "b" then
            if config.infer_types then
                return value == "1"
            end
            value = value == "1" and "TRUE" or "FALSE"
        elseif config.infer_types and value ~= nil and value ~= "" and cell_type ~= "str" and cell_type ~= "e" then
            local numeric = tonumber(value)
            if numeric ~= nil then
                return numeric
            end
        end
    end
    if value == nil then
        value = ""
    end
    if config.trim and type(value) == "string" then
        value = trim_string(value)
    end
    return value
end

local function collect_row_values(row_body, config, shared_strings)
    local values = {}
    local position = 1
    local previous_column = 0
    while true do
        local cell, err = find_element(row_body, position, "c")
        if err then
            error(err, 0)
        end
        if not cell then
            break
        end
        local ref = read_attribute(cell.attributes_text, "r")
        local column = cell_ref_to_column(ref) or (previous_column + 1)
        for index = previous_column + 1, column - 1 do
            values[index] = ""
        end
        local cell_type = read_attribute(cell.attributes_text, "t")
        values[column] = resolve_cell_value(cell.body, cell_type, config, shared_strings)
        previous_column = column
        position = cell.next_pos
    end
    return values
end

local Workbook = {}
Workbook.__index = Workbook

local function snapshot_config(source)
    return {
        header = source.header ~= nil and source.header or excel.header,
        skip_empty = source.skip_empty ~= nil and source.skip_empty or excel.skip_empty,
        trim = source.trim ~= nil and source.trim or excel.trim,
        sheet = source.sheet ~= nil and source.sheet or excel.sheet,
        infer_types = source.infer_types ~= nil and source.infer_types or excel.infer_types
    }
end

function Workbook.open(file_path, config)
    local archive, err = ZipArchive.open(file_path)
    if not archive then
        return nil, err
    end
    local workbook = setmetatable({
        archive = archive,
        file_path = file_path,
        config = snapshot_config(config or excel),
        sheets_meta = {},
        sheets_by_name = {},
        shared_strings = {},
        sheet_cache = {},
        closed = false
    }, Workbook)
    local ok, open_err = pcall(workbook._initialize, workbook)
    if not ok then
        workbook:close()
        return nil, open_err
    end
    return workbook
end

function Workbook:_initialize()
    local workbook_xml, workbook_err = self.archive:read_entry("xl/workbook.xml")
    if not workbook_xml then
        error(workbook_err, 0)
    end
    local rels_xml, rels_err = self.archive:read_entry("xl/_rels/workbook.xml.rels")
    if not rels_xml then
        error(rels_err, 0)
    end
    local relationships = {}
    local rel_position = 1
    while true do
        local rel, err = find_element(rels_xml, rel_position, "Relationship")
        if err then
            error(err, 0)
        end
        if not rel then
            break
        end
        local id = read_attribute(rel.attributes_text, "Id")
        local target = read_attribute(rel.attributes_text, "Target")
        if id and target then
            relationships[id] = normalize_workbook_target(target)
        end
        rel_position = rel.next_pos
    end
    local sheet_position = 1
    local index = 0
    while true do
        local sheet, err = find_element(workbook_xml, sheet_position, "sheet")
        if err then
            error(err, 0)
        end
        if not sheet then
            break
        end
        local name = read_attribute(sheet.attributes_text, "name") or ("Sheet" .. tostring(index + 1))
        local rel_id = read_attribute(sheet.attributes_text, "r:id")
        local target = rel_id and relationships[rel_id]
        if target then
            index = index + 1
            local meta = {
                index = index,
                name = name,
                sheet_id = tonumber(read_attribute(sheet.attributes_text, "sheetId")),
                state = read_attribute(sheet.attributes_text, "state") or "visible",
                path = target
            }
            self.sheets_meta[index] = meta
            self.sheets_by_name[name] = meta
        end
        sheet_position = sheet.next_pos
    end
    if #self.sheets_meta == 0 then
        error("Excel: 工作簿中没有可读取的工作表", 0)
    end
    if self.archive.entries["xl/sharedStrings.xml"] then
        local shared_strings_xml, shared_err = self.archive:read_entry("xl/sharedStrings.xml")
        if not shared_strings_xml then
            error(shared_err, 0)
        end
        local position = 1
        while true do
            local item, err = find_element(shared_strings_xml, position, "si")
            if err then
                error(err, 0)
            end
            if not item then
                break
            end
            table_insert(self.shared_strings, collect_text_nodes(item.body))
            position = item.next_pos
        end
    end
end

function Workbook:_ensure_open()
    if self.closed or not self.archive then
        error("Excel: 工作簿已关闭", 0)
    end
end

function Workbook:close()
    if not self.closed then
        self.closed = true
        self.sheet_cache = {}
        if self.archive then
            self.archive:close()
            self.archive = nil
        end
    end
end

function Workbook:sheets()
    self:_ensure_open()
    local sheets = {}
    for index = 1, #self.sheets_meta do
        local meta = self.sheets_meta[index]
        sheets[index] = {
            index = meta.index,
            name = meta.name,
            sheet_id = meta.sheet_id,
            state = meta.state,
            path = meta.path
        }
    end
    return sheets
end

function Workbook:_resolve_sheet(selector)
    self:_ensure_open()
    local target = selector
    if target == nil then
        target = self.config.sheet
    end
    if type(target) == "number" then
        local sheet = self.sheets_meta[target]
        if not sheet then
            return nil, "Excel: 工作表序号超出范围: " .. tostring(target)
        end
        return sheet
    end
    if type(target) == "string" then
        local sheet = self.sheets_by_name[target]
        if not sheet then
            return nil, "Excel: 未找到工作表: " .. target
        end
        return sheet
    end
    return nil, "Excel: sheet 参数只能是序号或名称"
end

function Workbook:_load_sheet_xml(sheet)
    self:_ensure_open()
    local cached = self.sheet_cache[sheet.path]
    if cached then
        return cached
    end
    local sheet_xml, err = self.archive:read_entry(sheet.path)
    if not sheet_xml then
        return nil, err
    end
    self.sheet_cache[sheet.path] = sheet_xml
    return sheet_xml
end

function Workbook:rows(sheet_selector)
    local sheet, err = self:_resolve_sheet(sheet_selector)
    if not sheet then
        return nil, err
    end
    local sheet_xml, xml_err = self:_load_sheet_xml(sheet)
    if not sheet_xml then
        return nil, xml_err
    end
    local position = 1
    local headers = {}
    local header_processed = not self.config.header
    local fallback_row_number = 0
    local config = self.config
    local shared_strings = self.shared_strings
    return function()
        while true do
            local row, row_err = find_element(sheet_xml, position, "row")
            if row_err then
                error(row_err, 0)
            end
            if not row then
                return nil
            end
            position = row.next_pos
            fallback_row_number = fallback_row_number + 1
            local row_number = tonumber(read_attribute(row.attributes_text, "r")) or fallback_row_number
            local values = collect_row_values(row.body, config, shared_strings)
            local count = #values
            if header_processed and #headers > count then
                for index = count + 1, #headers do
                    values[index] = ""
                end
                count = #headers
            end
            if not (config.skip_empty and is_empty_row(values, count)) then
                if config.header and not header_processed then
                    headers = normalize_headers(values, count)
                    header_processed = true
                    return row_number, headers, nil
                end
                return row_number, headers, build_row_data(values, headers, config.header)
            end
        end
    end
end

function Workbook:cells(sheet_selector)
    local row_iter, err = self:rows(sheet_selector)
    if not row_iter then
        return nil, err
    end
    local current_line
    local current_headers
    local current_row
    local current_col = 0
    return function()
        while true do
            if not current_row or current_col >= #current_row then
                current_line, current_headers, current_row = row_iter()
                if not current_line then
                    return nil
                end
                current_col = 0
            end
            if current_row then
                current_col = current_col + 1
                if current_row[current_col] ~= nil then
                    local header = current_headers and current_headers[current_col] or tostring(current_col)
                    return current_line, header, current_row[current_col], current_col
                end
            end
        end
    end
end

function Workbook:parse(sheet_selector)
    local sheet, err = self:_resolve_sheet(sheet_selector)
    if not sheet then
        return nil, err
    end
    local row_iter, iter_err = self:rows(sheet_selector)
    if not row_iter then
        return nil, iter_err
    end
    local result = {
        sheet = sheet.name,
        sheet_index = sheet.index,
        headers = {},
        rows = {}
    }
    for _, headers, row in row_iter do
        if row then
            table_insert(result.rows, row)
        elseif headers then
            result.headers = clone_array(headers)
        end
    end
    return result
end

function excel.new(options)
    local parser = snapshot_config(options or {})
    return setmetatable(parser, { __index = excel })
end

function excel.setup(options)
    if not options then
        return
    end
    if options.header ~= nil then
        excel.header = options.header
    end
    if options.skip_empty ~= nil then
        excel.skip_empty = options.skip_empty
    end
    if options.trim ~= nil then
        excel.trim = options.trim
    end
    if options.sheet ~= nil then
        excel.sheet = options.sheet
    end
    if options.infer_types ~= nil then
        excel.infer_types = options.infer_types
    end
end

function excel:open(file_path)
    local config = self ~= excel and self or excel
    return Workbook.open(file_path, config)
end

function excel:sheets(file_path)
    local workbook, err = self:open(file_path)
    if not workbook then
        return nil, err
    end
    local ok, result = pcall(workbook.sheets, workbook)
    workbook:close()
    if not ok then
        return nil, result
    end
    return result
end

function excel:rows(file_path, sheet_selector)
    local workbook, err = self:open(file_path)
    if not workbook then
        return nil, err
    end
    local row_iter, iter_err = workbook:rows(sheet_selector)
    if not row_iter then
        workbook:close()
        return nil, iter_err
    end
    local closed = false
    local function close_once()
        if not closed then
            closed = true
            workbook:close()
        end
    end
    return function()
        local ok, line_num, headers, row = pcall(row_iter)
        if not ok then
            close_once()
            error(line_num, 0)
        end
        if line_num == nil then
            close_once()
            return nil
        end
        return line_num, headers, row
    end
end

function excel:cells(file_path, sheet_selector)
    local workbook, err = self:open(file_path)
    if not workbook then
        return nil, err
    end
    local cell_iter, iter_err = workbook:cells(sheet_selector)
    if not cell_iter then
        workbook:close()
        return nil, iter_err
    end
    local closed = false
    local function close_once()
        if not closed then
            closed = true
            workbook:close()
        end
    end
    return function()
        local ok, line_num, header, value, col_idx = pcall(cell_iter)
        if not ok then
            close_once()
            error(line_num, 0)
        end
        if line_num == nil then
            close_once()
            return nil
        end
        return line_num, header, value, col_idx
    end
end

function excel:parse(file_path, sheet_selector)
    local workbook, err = self:open(file_path)
    if not workbook then
        return nil, err
    end
    local ok, result = pcall(workbook.parse, workbook, sheet_selector)
    workbook:close()
    if not ok then
        return nil, result
    end
    return result
end

return excel
