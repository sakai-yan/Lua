# UI 框架剩余代码面验证报告

日期：2026-03-19

## Update
- This report captured an earlier verification state before the latest bug fixes.
- Revalidation on 2026-03-19 now shows:
- `Core.UI.Frame` strict local load passes.
- `.planning/tools/ui_framework_remaining_smoke.lua` now returns `pass=7 / fail=0 / blocker=0`.
- For the current writing-model comparison against real `HTML5 + CSS + JS`, prefer `.planning/reports/ui-framework-authoring-gap-vs-html-css-js-2026-03-19.md`.

## Summary
- 本轮只验证当前工作区中仍然存在的 UI 框架代码，不再引用已删除的旧文档、旧 `Builder*`、旧 `Layout.lua`、旧 `Style_demo.lua`。
- 当前 UI 入口链已经对齐：`Main.lua` 与 `Init.j` 都加载同一组剩余 UI 模块，未再出现旧的 `Builder_demo` 失配。
- 当前框架最核心的严格运行时阻断点只剩一个：`Class.lua` 仍然把 `Set` 绑定到 `Lib.Base.BitSet`，但后续又调用 `Set.new()`，导致真实 `Frame` 栈加载失败。
- 在绕开该基座阻断后，本地 smoke 证明以下能力本身是成立的：`Point`、`Style.applyLayout/bindRuntimeLayout/updateSticky*`、`Watcher`、`Tween`、`Component.create`。
- 但如果拿 `HTML5 + CSS + JS` 的开发体验来对比，当前框架还没有达到“同样的开发体验”；它更接近“JASS Frame 的 Lua 包装层 + 一层 CSS 风格的布局编译器 + 少量 JS 风格工具能力”。

## Scope

### 本轮纳入验证的真实代码面
- 入口：
  - `Code/Main.lua`
  - `Code/Init.j`
- UI 核心：
  - `Code/Core/UI/Frame.lua`
  - `Code/Core/UI/Style.lua`
  - `Code/Core/UI/Watcher.lua`
  - `Code/Core/UI/Tween.lua`
  - `Code/Core/UI/Component.lua`
- UI 组件：
  - `Panel.lua`
  - `Texture.lua`
  - `Text.lua`
  - `Button.lua`
  - `Slider.lua`
  - `Sprite.lua`
  - `Model.lua`
  - `Portrait.lua`
  - `SimpleText.lua`
  - `TextArea.lua`
- 基础依赖：
  - `Code/FrameWork/Manager/Point.lua`
  - `Code/Lib/Base/Class.lua`
  - `Code/Lib/Base/Set.lua`
  - `Code/Lib/Base/BitSet.lua`

### 明确不再作为本轮基线的内容
- 已删除的 `doc/UI框架说明.md`
- 已删除的 `Code/Core/UI/Layout.lua`
- 已删除的 `Code/Core/UI/Builder*.lua`
- 已删除的 `Code/Core/UI/Style_demo.lua`

## Validation Method
- 静态入口审计：
  - 检查 `Main.lua` 与 `Init.j` 当前实际加载的 UI 模块集合。
- 语法验证：
  - 对当前剩余的 Lua 文件执行 `luac -p`。
  - `Init.j` 为 Jass + Lua 预处理混合文件，不适用 `luac -p`，只做静态导入链验证。
- 严格运行时验证：
  - 直接验证 `Point(...)` 是否可调用。
  - 使用最小 `Jass/Constant` stub 严格 `require("Core.UI.Frame")`，观察真实阻断点。
- 本地 smoke：
  - 使用 `.planning/tools/ui_framework_remaining_smoke.lua` 验证当前仍存在的可达能力。

## Runtime Truth

### 入口一致性
- `Main.lua:75-89` 当前加载：
  - `Core.UI.Frame`
  - `Core.UI.Panel`
  - `Core.UI.Texture`
  - `Core.UI.Text`
  - `Core.UI.Slider`
  - `Core.UI.Sprite`
  - `Core.UI.Model`
  - `Core.UI.Portrait`
  - `Core.UI.SimpleText`
  - `Core.UI.Button`
  - `Core.UI.TextArea`
  - `Core.UI.Style`
  - `Core.UI.Watcher`
  - `Core.UI.Tween`
  - `Core.UI.Component`
- `Init.j:75-89` 当前也导入同一组 UI 模块。
- 当前 `Code/Core/UI/` 目录实际存在的文件与这组入口匹配。

结论：
- 当前入口链已经从上一轮的“旧 Builder 漂移”恢复到一致状态。
- 入口层面没有再引用已删除的 UI 文件。

### 语法层结论
- `luac -p` 通过：
  - `Main.lua`
  - `Point.lua`
  - `BitSet.lua`
  - `Set.lua`
  - `Class.lua`
  - 剩余全部 `Code/Core/UI/*.lua`
- `Init.j` 不能用 `luac -p` 直接验证：
  - 它不是纯 Lua 文件。

结论：
- 当前剩余 Lua 代码面语法完整。
- 但“语法通过”不等于“真实运行链闭环”。

## Key Runtime Finding

### 严格阻断点：`Class.lua`
- 代码证据：
  - `Code/Lib/Base/Class.lua:3`：`local Set = require "Lib.Base.BitSet"`
  - `Code/Lib/Base/Class.lua:468`：`local attributes = class.__attributes__ or Set.new()`
- 运行时证据：
  - 新 smoke 脚本返回：
    - `BLOCKER | strict.frame.require | ./Code/Lib\Base\Class.lua:468: attempt to call a nil value (field 'new')`

结论：
- `Point.lua` 已经修复，不再是 blocker。
- 真实 `Frame` 栈现在被 `Class.lua` 的 `Set` 绑定错误阻断。
- 因为 `Main.lua` / `Init.j` 都先加载 `Core.UI.Frame`，所以这一个阻断点会连带阻断整个真实 UI 栈启动。

## Capability Matrix

| 模块族 | 能力 | 状态 | 证据 | 结论 |
| --- | --- | --- | --- | --- |
| Bootstrap | `Main.lua` 与 `Init.j` 的剩余 UI 模块加载链 | 已实现 | 入口审计 | 两个入口当前都指向同一组现存 UI 模块 |
| Base | `Point(...)` / `Point.get(...)` | 已实现 | 真实本地执行 + smoke | 调用与解包都已通过 |
| Base | `Class` 驱动的真实 class/frame 创建链 | 运行时阻断 | 代码 + 严格 require | `Set.new()` 调用落到 `BitSet` 上，真实 `Frame` 不能加载 |
| Frame | 属性访问、定位、事件、树创建、销毁、查询 API | 静态存在，但集成阻断 | 代码 + `luac -p` | API 面很完整，但当前无法穿过 `Class` 阻断做端到端创建验证 |
| Components | `Panel/Text/Button/Slider/Sprite/Model/Portrait/Texture/SimpleText/TextArea` | 静态存在，但集成阻断 | 文件存在 + 类定义 + `luac -p` | 组件文件齐全、继承链存在，但实例化同样被 `Frame/Class` 阻断 |
| Style | `applyLayout` | 已实现 | 代码 + smoke | 支持编译式 `position/display` 布局计算 |
| Style | `bindRuntimeLayout` | 已实现 | 代码 + smoke | `fixed` 能升级成相对锚点关系 |
| Style | `updateStickyFrame/updateStickyTree` | 已实现 | 代码 + smoke | `sticky` 需要显式滚动值驱动刷新 |
| Style | 独立主题系统、级联、选择器、样式继承 | 缺失 | 代码审计 | 当前 `Style.lua` 只是一套编译式布局器，不是 CSS 主题系统 |
| Layout | 独立 `Layout.lua` helper 表面 | 缺失/已删除 | 目录审计 | 当前工作区已无独立 `Layout` 模块 |
| Watcher | `watch/unwatch/unwatchAll/clear` | 已实现 | 代码 + smoke | 成功路径、失败路径、取消路径都可本地验证 |
| Tween | `Tween.animate/cancel/cancelAll` | 部分实现 | 代码 + smoke | 在 stub 环境里成立，但真实集成使用仍受 `Frame` 阻断 |
| Tween | `Frame.animate/stopAnimate` 扩展 | 部分实现 | 代码 + smoke | 语法糖成立，但依赖 `Frame` 真正可加载 |
| Component | `Component.define` | 已实现 | 代码 + smoke | 可以注册 type 名称与工厂 |
| Component | `Component.create` | 部分实现 | 代码 + smoke | 当前更像“工厂 registry”，不会吸收 `type_config.tree` 等更高层元数据 |
| Component | `Component.__call` | 未闭环 | 代码 + smoke | 会先走 `Style.applyLayout`，但 `Class.issubclass(ui_class, Component)` 这条门禁当前无法成立 |

## Smoke Result
- 脚本：`.planning/tools/ui_framework_remaining_smoke.lua`
- 结果：
  - `pass=5`
  - `fail=0`
  - `blocker=1`
- 通过项：
  - `strict.point`
  - `smoke.style`
  - `smoke.watcher`
  - `smoke.tween`
  - `smoke.component`
- 阻断项：
  - `strict.frame.require`

## HTML5 + CSS + JS Developer Experience Comparison

### 对比矩阵
| Web 开发面向 | 当前框架对应物 | 接近度 | 说明 |
| --- | --- | --- | --- |
| HTML 结构树 | `tree` 配置、`Frame` 父子关系、组件类 | 部分接近 | 能表达树，但没有真正的标记语言、语义标签、模板解析器 |
| HTML/组件声明式创建 | `Component` | 较弱 | `Component.create` 只是 registry 工厂；`Component.__call` 还没闭环，离 JSX/模板体验差很远 |
| CSS 盒模型定位 | `Style.applyLayout` 的 `padding/gap/position` | 部分接近 | 有盒模型味道，但只有配置表，没有 CSS 语法层 |
| CSS `display:flex/grid/table` | `Style` 的编译式 display 分支 | 部分接近 | 能算出位置，但不是浏览器运行时 layout engine |
| CSS `absolute/fixed/sticky` | `Style` + `bindRuntimeLayout/updateSticky*` | 部分接近 | `fixed` 需要绑定运行时锚点，`sticky` 需要手动传 scroll 值刷新 |
| CSS 选择器 / 级联 / 继承 / className | 无 | 缺失 | 当前没有 selector、cascade、样式继承、主题 token 分发体系 |
| JS 事件系统 | `Frame.on/off` | 部分接近 | 有事件监听风格，但仅限框架定义的 frame 事件 |
| JS 状态监听 | `Watcher.watch` | 部分接近 | 更像 setter 级观察器，不是完整状态系统 |
| JS 动画 | `Tween.animate` / `Frame.animate` | 部分接近 | 补间逻辑存在，但真实集成路径仍被 `Frame` 阻断 |
| DOM 查询 | `Frame.getByName/getByHandle/getGameUI/getConsoleUI` | 较弱 | 只有定向查询，没有 `querySelector` / `querySelectorAll` |
| 浏览器自动回流 / 响应式布局 | 无 | 缺失 | 当前布局是 compile-first，不是浏览器那种持续 reflow/repaint 模型 |

### 总体判断
- 如果问题是“是否已经实现了和 `HTML5 + CSS + JS` 同样的开发体验”，结论是：还没有。
- 如果问题是“是否已经实现了一个带有 HTML/CSS/JS 影子的 Lua UI 框架”，结论是：已经实现了一部分，而且方向非常明确。

### 当前最接近 Web 的部分
- `Frame` 的属性式访问、事件监听、父子树、相对锚点。
- `Style.applyLayout` 对 `position/display/padding/gap` 的表达。
- `Watcher` 与 `Tween` 提供的“JS 风格联动”和“动画”能力。

### 当前离 Web 体验最远的部分
- 没有真正可用的声明式入口。
- 没有 CSS 级联、选择器、主题和继承。
- 没有浏览器式自动回流与自动 sticky/fixed 运行时维护。
- 没有 DOM 级查询和组件复用生态。

## Final Assessment

### 已经真实成立的能力
- 当前入口链一致。
- 当前剩余 Lua 文件语法完整。
- `Point` 已恢复可用。
- `Style` 的 compile-first 布局能力成立。
- `Watcher` 成立。
- `Tween` 的核心算法成立。
- `Component.create` 作为最小 registry/factory 成立。

### 当前仍未闭环的能力
- 真实 `Frame` 栈加载。
- 真实组件实例化与树创建。
- `Tween` 在真实 UI 栈中的集成可用性。
- `Component.__call` 作为 HTML/JSX 风格入口的可用性。

### 对“是否实现了同样的开发体验”的结论
- 不是“同样的开发体验”。
- 是“一套已经具备部分 Web 语义，但还停留在半框架、半工具层的 UI 基础设施”。

## Recommended Next Actions
1. 先修 `Code/Lib/Base/Class.lua` 的 `Set` 绑定错误，让真实 `Frame` 栈恢复可加载。
2. 修完后立刻做第二轮 integrated smoke，验证 `Frame` 与各组件能否真实实例化。
3. 明确 `Component` 到底是要成为真正的声明式入口，还是只保留为 registry helper。
4. 如果目标是接近 `HTML5 + CSS + JS` 体验，下一阶段应优先补：
   - 统一 declarative entry
   - 真实可复用的样式系统
   - 自动 re-layout / sticky 更新机制
   - 更接近 DOM 的查询与组合能力

## Evidence Commands
- 语法检查：
  - `.\.tools\lua53\bin\luac.exe -p <current-lua-files>`
- 当前 smoke：
  - `.\.tools\lua53\bin\lua.exe .planning\tools\ui_framework_remaining_smoke.lua .`
- 当前 smoke 输出：
  - `SUMMARY | pass=5 | fail=0 | blocker=1`
