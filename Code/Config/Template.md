## Packer 当前模板说明

### 源文件示例

`Code/Config/UnitType/Zs.lua`

```lua
local Unit = require "Core.Entity.Unit"

Unit.unitType("Boss", {
    ["名字"] = "张三",
    ["称谓"] = "帮主",
    ["模型"] = "units\\human\\HeroPaladin\\HeroPaladin",
})
```

### 当前输出行为

Packer 不会改项目源码。

它会在输出目录中做两件事：

1. 生成补全后的源文件副本：

```text
<War3 根目录>/map/Config/UnitType/Zs.lua
```

2. 生成一个只负责聚合 `require` 的入口：

```lua
-- <War3 根目录>/map/Config/UnitTypeInit.lua
require "Config.UnitType.Zs"
```

### unit.ini 输出

当前生成位置：

```text
<War3 根目录>/table/unit.ini
```

继承字段继续写成：

```ini
_parent = "Hblm"
```

不是：

```ini
parent = "Hblm"
```
