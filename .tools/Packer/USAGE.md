# Packer 使用说明

## 1. 做什么

`Packer` 会：

- 把项目根目录中的文件按相对路径复制到 `<War3 根目录>/map`
- 读取 UnitType Lua、Excel、Mapper.default 并补全 UnitType 输出文件
- 生成 `map/Config/UnitTypeInit.lua`
- 生成 `<War3 根目录>/table/unit.ini`
- 输出 `manifest.md`、`error.md` 和备份目录

项目源码不会被回写。

## 2. 六个输入项

### 项目根目录

这是要复制到地图里的源码根目录。

### UnitType 目录

这里放所有 UnitType Lua 源文件。

当前参与规则：

- 只有“文件里包含 `Unit.unitType`”的 UnitType Lua 才参与这部分输出
- 不是看文件名
- 也不是看目录名

### Mapper 文件

负责提供：

- `attr_key`
- `attr_value`
- `default`

### Excel 文件

用于补全 UnitType 字段，并按严格的 `ID + 名字 + 称谓` 规则匹配。

### 备份和错误信息目录

每次运行会在这里生成一个时间戳目录，里面包含：

- `manifest.md`
- `error.md`
- `overwritten/`
- `staging/`

### War3 根目录

当前固定推导为：

- Lua 输出根：`<War3 根目录>/map`
- ini 输出：`<War3 根目录>/table/unit.ini`

## 3. UnitType 输出

当前不是把所有 UnitType 定义直接合并写进 `UnitTypeInit.lua`。

当前行为是：

1. 输出补全后的源文件到 `map/Config/UnitType/*.lua`
2. 再生成一个聚合入口 `map/Config/UnitTypeInit.lua`
3. `UnitTypeInit.lua` 只负责 `require` 这些源文件

也就是说：

- 源文件补全发生在输出副本里
- 项目源码不改
- `UnitTypeInit.lua` 不是“大杂烩定义文件”

## 4. unit.ini 输出

当前生成位置：

```text
<War3 根目录>/table/unit.ini
```

不是：

```text
<War3 根目录>/table/unit.ini
```

`_parent` 来自 `Mapper.default.<hero|unit>.<remote|meele>.parent`。

## 5. 预检与打包

### 预检

预检会检查：

- 路径是否存在
- Mapper 是否可读
- Excel 是否可读
- UnitType Lua 是否可扫描
- 是否识别到可打包单位

### 打包

打包大致顺序：

1. 创建本次备份目录
2. 复制项目文件到输出 map
3. 读取 Mapper / Excel / UnitType
4. 补全输出 UnitType 源文件
5. 生成 `UnitTypeInit.lua`
6. 生成 `table/unit.ini`
7. 写出 `manifest.md` 和 `error.md`

## 6. 失败时

如果某个单位失败：

- 该单位会被跳过
- 错误会写入 `error.md`

如果本轮没有任何成功单位：

- 不覆盖地图输出
- 只写 `manifest.md` 与 `error.md`

## 7. 当前桌面端补充

- 6 个路径会自动记住上次输入
- 下次启动会自动恢复
