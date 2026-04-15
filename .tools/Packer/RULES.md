# Packer 规则说明

## 1. 规则来源

Packer 的单位打包规则由三部分共同决定：

- UnitType Lua
- Excel
- Mapper

其中 Mapper 是正式规则主源。

## 2. Mapper 结构

Packer 只认 `Slk_Mapper` 下的三个主块：

- `attr_key`
- `attr_value`
- `default`

### attr_key

把中文字段名映射为 `unit.ini` 键名。

### attr_value

把中文字符串值映射为 `unit.ini` 最终值。

### default

负责两件事：

- 补默认字段
- 提供 `_parent`

`parent` 只是模板元数据，不会写回输出 Lua，也不会作为普通 ini 字段输出。

## 3. default 分支

当前正式结构：

```lua
default = {
    common = { ... },
    hero = {
        common = { ... },
        remote = { parent = "Hblm", ... },
        meele = { parent = "Hpal", ... },
    },
    unit = {
        common = { ... },
        remote = { parent = "hmpr", ... },
        meele = { parent = "hfoo", ... },
    },
}
```

旧的 `default.*.*.ID` 已不再支持。

## 4. 字段优先级

固定为：

```text
default < Excel < Lua
```

含义：

- default 只补缺失或空值
- Excel 可以覆盖 default
- Lua 显式值优先级最高

## 5. 单位分类

### hero / unit

依据最终单位 ID 首字母：

- 大写 ASCII 字母：`hero`
- 其它：`unit`

### remote / meele

依据最终 `远程` 字段判断。

如果 `远程` 缺失或无法识别，单位报错并跳过。

## 6. Excel 匹配

当前只接受一种匹配：

```text
ID + 名字 + 称谓
```

三者必须同时精确匹配。

任一不匹配：

- 单位跳过
- 写入 `error.md`

## 7. UnitType 文件参与规则

当前按“文件是否包含 `Unit.unitType`”决定是否参与 UnitType 这部分输出。

### 会参与

- 文件里直接出现 `Unit.unitType(...)`
- 文件里把 `Unit.unitType` 显式赋值给本地变量后再调用

### 不参与

- 只是普通 Lua 文件，但没有 `Unit.unitType`
- 依赖一套通用裸别名推断的写法

当前不会再把任意裸 `unitType(...)` 当成默认常用别名自动识别。

## 8. 输出 Lua 规则

当前输出策略是：

1. 先输出补全后的源文件副本到 `map/Config/UnitType/*.lua`
2. 再生成 `map/Config/UnitTypeInit.lua`
3. `UnitTypeInit.lua` 只负责 `require` 参与输出的源文件

所以：

- 项目源码不改
- 输出副本会被补字段
- `UnitTypeInit.lua` 不直接承载所有单位定义正文

## 9. unit.ini 规则

当前输出位置：

```text
<War3 根目录>/table/unit.ini
```

### `_parent` 来源

只来自以下四个分支之一：

- `default.hero.remote.parent`
- `default.hero.meele.parent`
- `default.unit.remote.parent`
- `default.unit.meele.parent`

### 字段来源

来自完整合并结果：

- Lua
- Excel
- default

然后再经过：

- `attr_key`
- `attr_value`

### 近战导弹字段过滤

对 `meele` 单位仍跳过：

- `Missilearc`
- `Missileart`
- `Missilespeed`

## 10. 失败保护

如果本轮没有任何成功单位：

- 不覆盖地图输出
- 只写 `manifest.md`
- 只写 `error.md`
