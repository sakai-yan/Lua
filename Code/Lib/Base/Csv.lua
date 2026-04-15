-- CSV解析器模块
local csv = {}

--[[
功能描述:
  提供高效的CSV文件解析和遍历功能，支持自定义配置、逐行读取和逐单元格遍历。
  模块本身作为默认解析器使用，同时支持创建自定义配置的解析器实例。
  注意：空单元格会被解析为空字符串，而不是nil
使用示例:
  -- 使用默认配置
  for line_num, header, value in csv:cells("data.csv") do
      print(line_num, header, value)
  end
  -- 使用自定义配置
  local parser = csv.new({separator = ";"})
  for line_num, header, value in parser:cells("data.csv") do
      print(line_num, header, value)
  end
--]]

-- 预编译模式和缓存
local TRIM_PATTERN = "^%s*(.-)%s*$"
local NON_WHITESPACE_PATTERN = "%S"
local table_insert = table.insert
local table_concat = table.concat
local string_byte = string.byte
local string_char = string.char
local string_sub = string.sub
local string_gsub = string.gsub
local string_find = string.find
local math_min = math.min

-- 默认配置
csv.separator = ","      -- 字段分隔符，默认为逗号
csv.quote = '"'          -- 引号字符，用于包围包含特殊字符的字段
csv.trim = true          -- 是否修剪字段两端的空白字符
csv.header = true        -- 是否将第一行作为表头
csv.skip_empty = true    -- 是否跳过空行

--[[
创建新的CSV解析器实例
@param options table 可选配置参数
  - separator string 字段分隔符，默认为逗号
  - quote string 引号字符，默认为双引号
  - trim boolean 是否修剪字段空白，默认为true
  - header boolean 是否使用表头，默认为true
  - skip_empty boolean 是否跳过空行，默认为true
@return table 新的解析器实例
@usage
  local parser = csv.new({separator = ";"})
  local parser2 = csv.new() -- 使用默认配置
--]]
function csv.new(options)
    local config = options or {}
    local parser = {
        separator = config.separator or csv.separator,
        quote = config.quote or csv.quote,
        trim = config.trim ~= false,
        header = config.header ~= false,
        skip_empty = config.skip_empty ~= false,
    }
    return setmetatable(parser, {__index = csv})
end

--[[
修改默认解析器的配置
@param options table 配置参数
  - separator string 字段分隔符
  - quote string 引号字符
  - trim boolean 是否修剪字段空白
  - header boolean 是否使用表头
  - skip_empty boolean 是否跳过空行
@usage
  csv.setup({separator = "|", header = false})
--]]
function csv.setup(options)
    if options.separator then csv.separator = options.separator end
    if options.quote then csv.quote = options.quote end
    if options.trim ~= nil then csv.trim = options.trim end
    if options.header ~= nil then csv.header = options.header end
    if options.skip_empty ~= nil then csv.skip_empty = options.skip_empty end
end

--[[
解析单行CSV数据（内部函数）
@param line string 要解析的CSV行
@param separator string 字段分隔符
@param quote string 引号字符
@param trim boolean 是否修剪字段空白
@return table 解析后的字段数组
@note
  此函数正确处理引号转义和字段分隔，是解析器的核心算法
--]]
local function parseLine(line, separator, quote, trim)
    local fields = {}
    local current = {}
    local in_quotes = false
    local i, len = 1, #line
    local quote_byte = quote:byte(1)
    local sep_byte = separator:byte(1)
    while i <= len do
        local byte = line:byte(i)
        if byte == quote_byte then
            if in_quotes and i < len and line:byte(i + 1) == quote_byte then
                current[#current + 1] = quote
                i = i + 1
            else
                in_quotes = not in_quotes
            end
        elseif byte == sep_byte and not in_quotes then
            local field = table_concat(current)
            if trim then field = (field:match(TRIM_PATTERN)) or field end
            fields[#fields + 1] = field
            current = {}
        else
            current[#current + 1] = string_char(byte)
        end
        i = i + 1
    end
    local last_field = table_concat(current)
    if trim then last_field = (last_field:match(TRIM_PATTERN)) or last_field end
    fields[#fields + 1] = last_field
    return fields
end

--[[
检查是否为空行（内部函数）
@param line string 要检查的行
@return boolean 如果是空行返回true，否则返回false
@note
  空行定义为nil、空字符串或只包含空白字符的行
--]]
local function is_empty_line(line)
    return not line or not string_find(line, NON_WHITESPACE_PATTERN)
end

--[[
行迭代器：逐行遍历CSV文件
@param file_path string CSV文件路径
@return function 迭代器函数，每次调用返回下一行数据
@return nil, string 如果文件打开失败，返回nil和错误信息
@return values (从迭代器)
  - line_number number 当前行号
  - headers table 表头数组（仅在第一次有表头行时返回，后续返回的都是同一个表头）
  - row_data table 行数据表，包含数值索引和表头索引（如果有表头）
@usage
  for line_num, headers, row in parser:rows("data.csv") do
      if row then
          print("行", line_num, ":", row.Name, row.Age)
      else
          print("表头:", table.concat(headers, ", "))
      end
  end
--]]
function csv:rows(file_path)
    local config = self ~= csv and self or csv
    local file, err = io.open(file_path, "r")
    if not file then return nil, "无法打开文件: " .. (err or "未知错误") end
    -- 缓存配置到局部变量（性能优化）
    local separator = config.separator
    local quote_char = config.quote
    local should_trim = config.trim
    local has_header = config.header
    local skip_empty = config.skip_empty
    local headers = {}
    local line_number = 0
    local header_processed = not has_header
    return function()
        local line
        repeat
            line = file:read("*l")
            if not line then
                file:close()
                return nil
            end
            line_number = line_number + 1
            -- 跳过空行（使用预编译模式）
            if skip_empty and is_empty_line(line) then
                line = nil
            end
        until line
        local fields = parseLine(line, separator, quote_char, should_trim)
        -- 处理表头
        if has_header and not header_processed then
            headers = fields
            header_processed = true
            return line_number, headers, nil
        end
        -- 构建行数据
        local row_data = {}
        local field_count = #fields
        local header_count = #headers
        for i = 1, field_count do
            row_data[i] = fields[i]
        end
        if has_header and header_count > 0 then
            local min_count = math_min(header_count, field_count)
            for i = 1, min_count do
                row_data[headers[i]] = fields[i]
            end
        end
        return line_number, headers, row_data
    end
end

--[[
单元格迭代器：逐个遍历CSV文件中的所有单元格
@param file_path string CSV文件路径
@return function 迭代器函数，每次调用返回下一个单元格数据
@return nil, string 如果文件打开失败，返回nil和错误信息
@return values (从迭代器)
  - line_number number 当前行号
  - header string 当前列的表头（如果没有表头则使用列号）
  - cell_value string 单元格的值
  - column_index number 列索引（从1开始）
@usage
  for line_num, header, value, col_idx in parser:cells("data.csv") do
      print(string.format("行%d [%s](列%d): %s", line_num, header, col_idx, value))
  end
--]]
function csv:cells(file_path)
    local config = self ~= csv and self or csv
    local row_iter, err = config:rows(file_path)
    if not row_iter then return nil, err end
    local current_line, current_headers, current_row
    local current_col = 0
    return function()
        while true do
            if not current_row or current_col >= #current_row then
                current_line, current_headers, current_row = row_iter()
                if not current_line then return nil end
                current_col = 0
                if not current_row then
                    current_col = 0
                end
            end
            current_col = current_col + 1
            if current_row and current_row[current_col] then
                local header = current_headers and current_headers[current_col] or tostring(current_col)
                return current_line, header, current_row[current_col], current_col
            end
        end
    end
end

--[[
完整解析CSV文件：将整个CSV文件读入内存
@param file_path string CSV文件路径
@return table 解析结果，包含以下字段：
  - headers table 表头数组
  - rows table 数据行数组，每行是一个包含数值索引和表头索引的表
@usage
  local data = parser:parse("data.csv")
  print("表头:", table.concat(data.headers, ", "))
  for i, row in ipairs(data.rows) do
      print("行", i, ":", row.Name, row.Age)
  end
--]]
function csv:parse(file_path)
    local config = self ~= csv and self or csv
    local result = {
        headers = {},
        rows = {}
    }
    for line_num, headers, row in config:rows(file_path) do
        if row then
            table_insert(result.rows, row)
        elseif headers then
            result.headers = headers
        end
    end
    return result
end

--测试
if __DEBUG__ then
    -- 测试统一配置键名
    local function test_unified_config()
        print("=== 测试统一配置键名 ===")
        
        -- 创建测试文件
        local test_data = [[Name;Age;City
        John;25;New York
        Jane;30;Los Angeles]]

        local test_file = "test.csv"
        local file = io.open(test_file, "w")
        assert(file, "test_unified_config:无法创建测试文件")
        file:write(test_data)
        file:close()
        -- 测试自定义分隔符
        print("\n1. 测试自定义分隔符:")
        local parser = csv.new({separator = ";"})
        for line_num, header, value in parser:cells(test_file) do
            if line_num <= 4 then
                print(string.format("  行%d [%s]: %s", line_num, header, value))
            end
        end
        -- 测试无表头配置
        print("\n2. 测试无表头配置:")
        local no_header_parser = csv.new({separator = ";", header = false})
        for line_num, header, value in no_header_parser:cells(test_file) do
            if line_num <= 3 then
                print(string.format("  行%d [%s]: %s", line_num, header, value))
            end
        end
        -- 测试配置访问
        print("\n3. 测试配置访问:")
        print("  默认分隔符:", csv.separator)
        print("  自定义解析器分隔符:", parser.separator)
        -- 清理
        --os.remove(test_file)
        print("\n=== 测试完成 ===")
    end

    test_unified_config()

    -- 测试性能优化的效果
    local function test_performance()
        print("=== 测试性能优化 ===")
        
        -- 创建大型测试文件
        local test_file = "large_test.csv"
        local file = io.open(test_file, "w")
        assert(file, "test_performance:无法创建测试文件")
        -- 写入表头
        file:write("Name,Age,City,Salary,Department,Email,Phone,Address,Status,Notes\n")
        
        -- 写入大量数据
        for i = 1, 1000 do
            file:write(string.format('"User %d",%d,"City %d",%d,"Dept %d","user%d@test.com","555-010%d","Address %d","Active","Note %d"\n', 
                i, 20 + (i % 50), i, 30000 + (i % 50000), i % 10, i, i % 10, i, i))
        end
        
        file:close()
        
        -- 测试单元格遍历性能
        print("开始单元格遍历...")
        local start_time = os.clock()
        local cell_count = 0
        
        for line_num, header, value in csv:cells(test_file) do
            cell_count = cell_count + 1
        end
        
        local end_time = os.clock()
        print(string.format("遍历 %d 个单元格耗时: %.3f 秒", cell_count, end_time - start_time))
        
        -- 测试行遍历性能
        print("开始行遍历...")
        start_time = os.clock()
        local row_count = 0
        
        for line_num, headers, row in csv:rows(test_file) do
            if row then
                row_count = row_count + 1
            end
        end
        
        end_time = os.clock()
        print(string.format("遍历 %d 行数据耗时: %.3f 秒", row_count, end_time - start_time))
        
        -- 清理
        --os.remove(test_file)
        print("=== 性能测试完成 ===")
    end

    -- 常规使用示例
    local function normal_usage()
        print("=== 常规使用示例 ===")
        
        -- 创建测试文件
        local test_data = [[Name,Age,City
    John,25,"New York"
    Jane,30,"Los Angeles"
    "Bob, Jr.",35,Chicago]]
        
        local test_file = "test.csv"
        local file = io.open(test_file, "w")
        assert(file, "normal_usage:无法创建测试文件")
        file:write(test_data)
        file:close()
        
        -- 使用默认配置遍历单元格
        print("单元格遍历:")
        for line_num, header, value in csv:cells(test_file) do
            print(string.format("  行%d [%s]: %s", line_num, header, value))
        end
        
        -- 使用便捷函数
        print("\n使用便捷函数:")
        local data = csv:parse(test_file)
        print("表头:", table.concat(data.headers, ", "))
        print("数据行数:", #data.rows)
        
        -- 清理
        --os.remove(test_file)
        print("=== 常规使用示例完成 ===")
    end

    -- 运行测试
    normal_usage()
    test_performance()
end

return csv