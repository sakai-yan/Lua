# Excel 库

`Lib/Base/Excel.lua` 提供一个纯 Lua 5.3 的 Excel 读取库，接口尽量贴近现有 `Csv`。

## 支持范围

- 支持 `xlsx` / `xlsm` / `xltx` / `xltm` 这类 OpenXML 工作簿
- 不支持旧版二进制 `xls`
- 默认读取单个工作表，默认工作表为第一个
- 默认返回字符串风格结果；开启 `infer_types = true` 时会把数字和布尔值转成 Lua 值
- 公式读取的是工作簿里缓存的结果值，不会重新计算公式

## 快速开始

```lua
local Excel = require("Lib.Base.Excel")

for line_num, headers, row in Excel:rows("UnitData.xlsx") do
    if row then
        print(line_num, row["名字"], row["生命"])
    end
end
```

## 与 `Csv` 类似的接口

### `Excel.new(options)`

创建一个带默认配置的解析器实例。

可用配置：

- `sheet`: 工作表序号或名称，默认 `1`
- `header`: 是否把第一条有效行当表头，默认 `true`
- `skip_empty`: 是否跳过空行，默认 `true`
- `trim`: 是否裁剪文本两端空白，默认 `false`
- `infer_types`: 是否把数字和布尔值转换成 Lua 值，默认 `false`

### `Excel.setup(options)`

修改模块级默认配置。

### `Excel:sheets(file_path)`

读取工作簿中的工作表列表：

```lua
local sheets = Excel:sheets("UnitData.xlsx")
for _, sheet in ipairs(sheets) do
    print(sheet.index, sheet.name, sheet.state)
end
```

### `Excel:rows(file_path[, sheet])`

行为与 `Csv:rows` 对齐：

- 表头行返回 `line_num, headers, nil`
- 数据行返回 `line_num, headers, row`
- `row` 同时支持数字索引和表头键索引

```lua
local parser = Excel.new({ sheet = "单位表" })
for line_num, headers, row in parser:rows("UnitData.xlsx") do
    if row then
        print(line_num, row[1], row["名字"])
    end
end
```

### `Excel:cells(file_path[, sheet])`

逐单元格遍历，返回：

- `line_num`
- `header`
- `value`
- `col_idx`

### `Excel:parse(file_path[, sheet])`

把一个工作表完整读入内存：

```lua
local data = Excel:parse("UnitData.xlsx", "单位表")
print(data.sheet, #data.headers, #data.rows)
```

## 更高效的复用方式

如果需要重复读取同一个工作簿，优先用 `open`：

```lua
local Excel = require("Lib.Base.Excel")
local book = assert(Excel:open("UnitData.xlsx"))

for _, sheet in ipairs(book:sheets()) do
    print(sheet.name)
end

local data = assert(book:parse("单位表"))
book:close()
```

这样可以避免反复重新打开和解析工作簿结构。
