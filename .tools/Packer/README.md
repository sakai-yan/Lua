# Packer

`Packer` 位于 `.tools/Packer`，用于把你选择的代码项目目录输出到 War3 运行目录，并补全 UnitType 数据、生成 `UnitTypeInit.lua` 与 `table/unit.ini`。

## 当前行为

- 输入固定为 6 项：
  - 项目根目录
  - UnitType 目录
  - Mapper 文件
  - Excel 文件
  - 备份和错误信息目录
  - War3 根目录
- 普通项目文件按相对路径复制到 `<War3 根目录>/map/...`
- UnitType 输出规则：
  - 只有源文件中包含 `Unit.unitType` 的文件才参与这部分输出
  - 输出保留补全后的 `map/Config/UnitType/*.lua`
  - 额外生成一个只负责 `require` 这些源文件的 `map/Config/UnitTypeInit.lua`
- `unit.ini` 输出到：
  - `<War3 根目录>/table/unit.ini`
- 失败时会写：
  - `manifest.md`
  - `error.md`
  - `overwritten/`
  - `staging/`

## 文档入口

- 使用说明：`./USAGE.md`
- 规则说明：`./RULES.md`

## 开发命令

- 构建：`dotnet build .tools/Packer/Packer.sln`
- 发布：`dotnet publish .tools/Packer/src/Packer.WinForms/Packer.WinForms.csproj -c Release -r win-x64 -p:PublishSingleFile=true -p:SelfContained=true`
