# MapRepair

`MapRepair` 是一个独立的 YDWE 可开图修复工具。

## 项目结构

- `src/MapRepair.Core`
  - MPQ 读写、地图巡检、修复编排、报告输出
- `src/MapRepair.Wpf`
  - 桌面界面入口
- `src/MapRepair.Smoke`
  - 合成坏图 smoke

## 构建

```powershell
dotnet build .tools/MapRepair/MapRepair.sln
```

## 一键入口

- 启动脚本：` .tools/MapRepair/Run-MapRepair.cmd`
- 发布目录：` .tools/MapRepair/publish/win-x64-self-contained `

## 运行桌面工具

```powershell
dotnet run --project .tools/MapRepair/src/MapRepair.Wpf/MapRepair.Wpf.csproj
```

## 运行 smoke

```powershell
dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj
```

## 当前能力

- 读取经典 MPQ 地图并按已知文件名提取内容
- 支持未压缩、`zlib`、`PKWare implode (0x08)` 压缩文件
- 缺失 `war3map.w3i` 时基于仓库模板重建
- 缺失 `war3map.wpm` / `war3map.doo` / `war3mapUnits.doo` 时生成最小可编辑壳
- 缺失 `war3map.wtg` / `war3map.wct` 时回填仓库健康模板
- 输出新的未压缩 `.w3x` 与 `repair-report.json` / `repair-report.md`

## 当前限制

- v1 只覆盖 `.w3x`
- 不做 `Lua -> JASS` 转换
- 仍不支持非 `zlib` / 非 `PKWare implode` 的压缩内容组合
- 是否能被真实 YDWE 打开，仍建议用你的目标地图做一次人工验收
