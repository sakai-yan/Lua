# UI框架逐条验证矩阵

更新时间：2026-03-21  
用途：把本轮审查涉及的路径、验证方法、命令、预期、实际证据、风险逐条记录，作为后续复跑任务书。

## 1. 基线命令

### 1.1 语法基线

```powershell
.\.tools\lua53\bin\luac.exe -p Code\Core\UI\Frame.lua
.\.tools\lua53\bin\luac.exe -p Code\Core\UI\Style.lua
.\.tools\lua53\bin\luac.exe -p Code\Core\UI\Theme.lua
.\.tools\lua53\bin\luac.exe -p Code\Core\UI\Component.lua
```

结果：本轮全部通过。

### 1.2 smoke 基线

```powershell
.\.tools\lua53\bin\lua.exe .planning\tools\ui_framework_remaining_smoke.lua .
```

结果：`pass=8 / fail=0 / blocker=0`

注意：这是 bounded smoke，不是 live Warcraft end-to-end。

## 2. 入口与底层链路

| 路径 | 责任 | 验证方法 | 命令 / 查询 | 预期 | 实际证据 | 风险 |
| --- | --- | --- | --- | --- | --- | --- |
| `Code/Main.lua` | Lua 侧 UI 模块装载入口 | 静态扫描 require 顺序 | `rg -n "require 'Core.UI\\." Code/Main.lua` | UI 模块集中装载 | 找到 `Frame` 到 `Component` 的集中 require；Theme 不在顶层显式 require，而是通过 `Component` 间接进入。 | 入口清楚，但 Theme 依赖对顶层读者不够显式。 |
| `Code/Init.j` | JASS/Lua 混合启动链 | 静态扫描 include/import 顺序 | `Get-Content Code/Init.j -TotalCount 120` | memory_hack / AsphodelusUI 在 Lua UI 之前进入环境 | 顶部包含 `memory_hack`、`memory_hack_addon`、`AsphodelusUI`，之后 `importlua("Core.UI.*")`。 | 说明 Lua UI 依赖外部环境，不能只看 Lua 目录本身。 |
| `../AsphodelusUI/AsphodelusUI.j` | 外部 UI 环境库 | 静态读取头部和 library 分类 | `Get-Content ..\\AsphodelusUI\\AsphodelusUI.j -TotalCount 180` | 能看到 UI 环境级宏/函数 | 可见 `AsphodelusUIBase` 等 library、AUI 宏、地形与对象操作工具。 | 当前 Lua 层未直接点名依赖其高层语义。 |
| `../memory_hack/memory_hack.j` | native API 总入口 | 静态扫描 include | `Get-Content ..\\memory_hack\\memory_hack.j -TotalCount 120` | UI API 被统一 include | 可见 `api/frame.j`、`api/game_ui.j`、`api/game_ui_data.j` 等被总入口暴露。 | UI 真正底层在 `memory_hack`，本地 smoke 不能替代 live native 语义。 |
| `../memory_hack/api/frame.j` | `MHFrame_*` 原语 | 静态读取 API 列表 | `Get-Content ..\\memory_hack\\api\\frame.j -TotalCount 120` | 能看到创建、销毁、定位、尺寸、事件等原语 | 看到 `MHFrame_Create*`、`MHFrame_Destroy`、`MHFrame_SetAbsolutePoint`、`MHFrame_SetRelativePoint`、`MHFrame_SetWidth/Height/Size` 等。 | Lua UI 正确性最终仍依赖这些原语的 live 行为。 |
| `../memory_hack/api/game_ui.j` | `MHUI_*` 根节点与系统 UI 原语 | 静态读取 API 列表 | `Get-Content ..\\memory_hack\\api\\game_ui.j -TotalCount 120` | 能看到 `GameUI` / `ConsoleUI` 等入口 | 看到 `MHUI_GetGameUI`、`MHUI_GetConsoleUI` 等。 | 当前高层 Lua 封装只覆盖一小部分。 |
| `../memory_hack/api/game_ui_data.j` | UI 数据入口 | 静态存在性检查 | `Get-ChildItem ..\\memory_hack\\api | ? Name -match 'game_ui_data'` | 文件存在，作为潜在能力源 | 文件存在，但 `Code/Core/UI` 没发现直接调用。 | 不应把潜在能力误写成当前框架能力。 |
| `Code/Lib/API/Jass.lua` | Lua 到 `common/japi/code` 的统一桥 | 静态读取实现 | `Get-Content Code/Lib/API/Jass.lua -TotalCount 80` | 实现应尽量薄且可缓存 | 实现是 `__index` 惰性查找并缓存函数引用。 | 轻量，但没有额外的语义护栏。 |
| `Code/Lib/API/Constant.lua` | 常量整合层 | 常量点位抽查 | `rg -n "ANCHOR_|EVENT_ID_FRAME_|TEXT_COLOR_|SIMPLE_BUTTON_STATE_" Code/Lib/API/Constant.lua` | UI 用到的常量应齐全 | 能定位锚点、Frame 事件 ID、文本颜色、按钮状态常量。 | 文件巨大、可读性和维护成本高。 |

## 3. 基础设施与核心 UI 内核

| 路径 | 责任 | 验证方法 | 命令 / 查询 | 预期 | 实际证据 | 风险 |
| --- | --- | --- | --- | --- | --- | --- |
| `Code/Lib/Base/Class.lua` | class / attribute / constructor / destroy 地基 | 静态读取设计块 | `Get-Content Code/Lib/Base/Class.lua -TotalCount 220` | 应存在访问器编译和生命周期支持 | 文件明确实现 class / proxy / getter/setter / destroy / 继承链传播。 | 复杂度高，维护门槛高。 |
| `Code/FrameWork/Manager/Point.lua` | 点值容器 | 真实 round-trip 微实验 | `lua.exe -` 载入真实 `Point.lua` 后跑 `(0.30,0.15)`、`(-1,2)` 样例 | 若作为 UI 坐标容器，应能正确 round-trip 小数与负值 | 实际得到 `(0.30,0.15) -> (-0.15,0.15)`，`(-1,2) -> (2,0)`；只对整数样例正确。 | `P0`。UI 常用小数坐标与负偏移不安全。 |
| `Code/Core/UI/Frame.lua` | base frame、对象注册、事件、定位、生命周期 | 静态扫描 + smoke require | `rg -n "function Frame\\.|name = \"|Jass\\.MHFrame_" Code/Core/UI/Frame.lua` | 应集中承载公共 UI 语义 | 找到对象注册、只读 `childs`、`__common_constructor`、属性面、helper、事件注册、bind/unbind 等。 | `Frame.__init__` 使用 `Point(config.width,height)` 和 `Point(config.x,y)`，geometry 被 `Point` 风险污染。 |
| `Code/Core/UI/Style.lua` | 布局编译器 | 静态读取 + smoke.style | `rg -n "function Style\\.|display|sticky|fixed" Code/Core/UI/Style.lua` + smoke | 应是 compile-time layout，不是浏览器 runtime | `smoke.style` 通过，确认 `flex/grid/static/relative/absolute/fixed/sticky` 关键路径可运行于 stub。 | `display:none` 仍非 CSS 等价；实机 native 成本未验证。 |
| `Code/Core/UI/Theme.lua` | Theme 预处理与 runtime replay | 静态读取 + smoke.theme | `rg -n "function Theme\\.|mergeable_keys|attach\\(|applyRuntime" Code/Core/UI/Theme.lua` + smoke | 应作为 `Component` 拥有的应用层能力 | `smoke.theme` 通过，确认 `define/get/apply/attach/set/refresh`、label/id selector、runtime switching 存在。 | selector 浅层；runtime replay 是 bounded，不是 cascade。 |
| `Code/Core/UI/Component.lua` | 高层 authoring 入口 | 静态读取 + smoke.component | `rg -n "function Component\\." Code/Core/UI/Component.lua` + smoke | 应把 Theme/Style/Frame 串成正式入口 | `smoke.component` 通过，确认 `Theme.apply` 在 `Style.applyLayout` 之前，且会 `Theme.attach`。 | registry `tree` metadata 契约不稳，smoke 已点名。 |
| `Code/Core/UI/Watcher.lua` | 属性监听系统 | 静态读取 + smoke.watcher | `rg -n "function Watcher\\." Code/Core/UI/Watcher.lua` + smoke | watch / unwatch / clear 应可工作 | `smoke.watcher` 通过，alpha 成功/失败/unwatch 路径被验证。 | 主要验证的是标量 setter，其他属性覆盖仍少。 |
| `Code/Core/UI/Tween.lua` | 补间系统 | 静态读取 + smoke.tween | `rg -n "function Tween\\.|Frame\\.animate|Frame\\.stopAnimate|Point" Code/Core/UI/Tween.lua` + smoke | animate/cancel/cancelAll 与 sugar 应工作 | `smoke.tween` 通过，但 `Tween.lua` 明确对 `position/size` 使用 `Point(...)`。 | 标量补间可继续信任；几何补间被 `Point` 风险阻塞。 |

## 4. 控件层

| 路径 | 责任 | 验证方法 | 命令 / 查询 | 预期 | 实际证据 | 风险 |
| --- | --- | --- | --- | --- | --- | --- |
| `Code/Core/UI/Panel.lua` | 容器与背景贴图 | 静态读取 + smoke.authoring 间接覆盖 | `Select-String -Path Code/Core/UI/Panel.lua -Pattern 'name = \"'` | 应暴露 `image` / `is_tile` | 找到 `image`、`is_tile`；Panel 构造在 smoke 里至少创建成功。 | `is_tile` 仍无独立 smoke。 |
| `Code/Core/UI/Texture.lua` | 轻量纹理 | 静态读取 | `Select-String -Path Code/Core/UI/Texture.lua -Pattern 'name = \"'` | 应暴露 `color` / `blend_mode` | 找到 `color`、`blend_mode`。 | 仍是 source-only。 |
| `Code/Core/UI/Text.lua` | 标准文本 | 静态读取 + smoke.authoring 部分覆盖 | `Select-String -Path Code/Core/UI/Text.lua -Pattern 'name = \"'` + `rg -n "function Text\\."` | 应暴露 value/font/align/color 等面 | 找到文本属性和 `setFont/setAlign`；Text 构造在 smoke 里可创建。 | `shadow_off` 使用 `Point.get`，受 `P0` 影响。 |
| `Code/Core/UI/SimpleText.lua` | 轻量文本 | 静态读取 | `Select-String -Path Code/Core/UI/SimpleText.lua -Pattern 'name = \"'` + `rg -n "function SimpleText\\."` | 应暴露精简文本面 | 找到 `value/font_height/limit/color` 和 `setFont/setAlign`。 | source-only。 |
| `Code/Core/UI/TextArea.lua` | 多行文本区域 | 静态读取 | `Select-String -Path Code/Core/UI/TextArea.lua -Pattern 'name = \"'` + `rg -n "function TextArea\\."` | 应暴露 `value`、`setFont`、`addText` | 源码存在完整公开面。 | source-only。 |
| `Code/Core/UI/Button.lua` | 按钮状态与辅助访问 | 静态读取 | `Select-String -Path Code/Core/UI/Button.lua -Pattern 'name = \"'` + `rg -n "function Button\\."` | 应暴露 `state` 和辅助方法 | 找到 `state`、`click`、`getTexture`、`getHighlight`。 | source-only，且依赖 `Frame.on/off` 事件面未单独 smoke。 |
| `Code/Core/UI/Slider.lua` | 滑条与边框辅助 | 静态读取 | `Select-String -Path Code/Core/UI/Slider.lua -Pattern 'name = \"'` + `rg -n "function Slider\\."` | 应暴露 value/min/max 和边框方法 | 找到 `value/max_limit/min_limit` 与 `addBorder`。 | source-only。 |
| `Code/Core/UI/Model.lua` | 简单模型显示 | 静态读取 | `Select-String -Path Code/Core/UI/Model.lua -Pattern 'name = \"'` | 应暴露 `path` | 找到 `path`。 | source-only。 |
| `Code/Core/UI/Sprite.lua` | 丰富 3D sprite 控制 | 静态读取 | `Select-String -Path Code/Core/UI/Sprite.lua -Pattern 'name = \"'` + `rg -n "function Sprite\\."` | 应暴露 3D 坐标、缩放、动画、贴图 | 找到 `x/y/z/roll/pitch/yaw/scale/x_scale/y_scale/z_scale/color/animation/animation_progress` 和四个实例方法。 | source-only，验证缺口大。 |
| `Code/Core/UI/Portrait.lua` | 3D portrait 与相机 | 静态读取 | `Select-String -Path Code/Core/UI/Portrait.lua -Pattern 'name = \"'` + `rg -n "function Portrait\\."` | 应暴露 `path` 与 camera API | 找到 `path`、`setCameraPosition`、`setCameraFocus`。 | source-only。 |

## 5. 验证资产与盲区

| 路径 | 责任 | 验证方法 | 命令 / 查询 | 预期 | 实际证据 | 风险 |
| --- | --- | --- | --- | --- | --- | --- |
| `../Style_demo.lua` | Style 演示样本 | 静态读取 | `Get-Content ..\\Style_demo.lua -TotalCount 260` | 应能展示 layout DSL 用法 | 文件展示了 `style`、`display`、`tree` 风格的 authoring。 | demo 不等于业务稳定样本。 |
| `.planning/tools/ui_framework_remaining_smoke.lua` | 当前 smoke 基线 | 运行 + 静态查询 | `lua.exe .planning\\tools\\ui_framework_remaining_smoke.lua .` + `rg -n "make_point_stub|strict.point" ...` | 应覆盖核心切片 | 运行结果 `pass=8`；静态查询表明 `strict.point` 只断言 `Point(3,7)`。 | 对真实 `Point` 的小数/负值盲区明显。 |
| `.planning/tools/ui_framework_smoke.lua` | 旧 smoke 参考 | 静态读取 | `rg -n "Style.applyLayout|Component\\(" .planning\\tools\\ui_framework_smoke.lua` | 应提供历史对照 | 文件仍展示早期 smoke 结构。 | 不应高于 `remaining_smoke` 的当前基线地位。 |
| 全仓调用扫描 | 真实使用分布 | `rg` 扫描 | `rg -n ... .` | 应区分业务使用、smoke、demo、原生绕行 | 高层 Lua UI 使用几乎只出现在 smoke / demo；`War3/map/war3map.j` 有 raw `MHFrame_*` 样本。 | 仓库采用度不足，不能过度外推。 |
| `War3/map/war3map.j` | 原生 UI 绕行样本 | 静态读取 snippet | `Get-Content War3\\map\\war3map.j -TotalCount 340 | Select-Object -Last 40` | 应能看到不经 Lua 框架的 native 写法 | 找到 `MHFrame_LoadTOC`、`MHFrame_CreateSimple`、`MHFrame_SetTexture`、`MHFrame_SetAbsolutePoint`、`MHFrame_SetSize`。 | 说明仓库存在绕过高层框架的路径。 |

## 6. 退出标准

这轮审查后的后续实现轮，建议把以下项目当作“可关闭该审查结论”的验证门槛：

1. 真实 `Point` 小数/负值 round-trip 被修复或被 UI 路径彻底移除。
2. smoke 正式覆盖小数 `position/size`，不再只用整数样例。
3. `Component.define/create` 的 `tree` 契约被写清楚并加 smoke。
4. `Frame.on/off`、相对定位 helper、Button/Slider/Sprite/Portrait 的公开面至少各补 1 组 bounded smoke。
5. 如果要继续宣传 CSS 风格 authoring，则必须先决定 `display:none` 和 selector 深度的真实边界。
