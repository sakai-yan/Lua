# Packer Cleanup And Docs 2026-03-21

## Goal

- 去掉 `Mapper.default.*.*.ID` 的兼容，只认 `parent`
- 工具、项目、命名统一为 `Packer`
- 清掉旧 `UnitPacker` 遗留生成物
- 补齐详细中文使用说明和规则说明

## Completed Work

- 移除了 `MapperLoader` 对旧 `ID` 分支元数据的兼容读取，正式只认 `parent`
- 把解决方案、项目、服务类、测试类、WinForms 标题和文档统一到 `Packer`
- 修复了 `PackerService.cs` 以及多处内部工具文件中的损坏字符串，恢复可编译状态
- 重写了 `.tools/Packer/README.md`
- 重写了 `.tools/Packer/USAGE.md`
- 重写了 `.tools/Packer/RULES.md`
- 清理了 `.tools/Packer/publish` 以及各项目的 `bin` / `obj`，随后重新构建并重新测试

## Validation

- `dotnet build .tools/Packer/Packer.sln`
- `dotnet test .tools/Packer/Packer.sln`

结果：

- build 通过
- test 通过
- 10/10 测试通过

## Final State

- `default.*.*.parent` 是唯一合法的模板继承元数据
- `_parent` 仍然写入 `unit.ini`，但来源只来自 `Mapper.default`
- 非生成源码、文档、界面文案中已不再保留 `UnitPacker`
- 非生成源码、文档中对旧 `ID` 的描述只保留为“已不支持”的规则说明
