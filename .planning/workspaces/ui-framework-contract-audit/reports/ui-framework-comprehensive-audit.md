# UI框架全量审查与验证报告

更新时间：2026-03-21  
审查边界：`Code/Core/UI`、`Code/Lib/API`、`Code/Lib/Base/Class.lua`、`Code/FrameWork/Manager/Point.lua`、`Code/Main.lua`、`Code/Init.j`、`memory_hack` UI 相关入口、`AsphodelusUI` UI 相关入口。  
证据规则：本报告只使用本轮源码扫描、本地命令验证、smoke 脚本、全仓调用扫描、和最小 Lua 实验结果；旧审计报告不作为证据。

## 1. 当前真相快照

已确认的起始基线：

- `luac -p Code\Core\UI\Frame.lua` 通过
- `luac -p Code\Core\UI\Style.lua` 通过
- `luac -p Code\Core\UI\Theme.lua` 通过
- `luac -p Code\Core\UI\Component.lua` 通过
- `lua.exe .planning\tools\ui_framework_remaining_smoke.lua .` 当前结果为 `pass=8 / fail=0 / blocker=0`

但这套基线不能直接等价成“框架已经可靠”，因为本轮实证发现了一个更高优先级问题：

| 真实 `Point.lua` 输入 | 输出 |
| --- | --- |
| `Point(0.30, 0.15)` | `(-0.15, 0.15)` |
| `Point(0.20, 0.03)` | `(-0.03, 0.03)` |
| `Point(0.018, 0.018)` | `(-0.018, 0.018)` |
| `Point(-1, 2)` | `(2, 0)` |

而当前 UI 主链路里：

- `Frame.__init__` 用 `Point(config.width, config.height)` 和 `Point(config.x, config.y)`
- `Text.shadow_off` 用 `Point.get(...)`
- `Tween position/size` 用 `Point(...)` / `Point.get(...)`

这意味着：当前 geometry 主链路存在 `P0` 级正确性阻塞，而现有 smoke 并没有把它拦下来。

## 2. 分层架构图

```text
Authoring Layer
  - direct constructor: Panel({...}) / Text({...}) / ...
  - declarative constructor: Component({...})
  - registry path: Component.define(...) / Component.create(...)
  - style/theme authoring: style / layout / Theme.define / Theme.set
  - runtime reactions: Watcher / Tween / Frame helpers

Core Lua UI Layer
  - Component.lua
  - Theme.lua
  - Style.lua
  - Frame.lua
  - control classes: Panel / Texture / Text / SimpleText / TextArea / Button / Slider / Model / Sprite / Portrait

Foundation Layer
  - Class.lua
  - Point.lua
  - Constant.lua
  - Jass.lua

Native Bridge Layer
  - memory_hack/api/frame.j
  - memory_hack/api/game_ui.j
  - memory_hack/api/game_ui_data.j

Environment Layer
  - memory_hack.j
  - AsphodelusUI.j
  - Init.j
```

关键调用链：

- `Component({...}) -> Theme.apply -> Style.applyLayout -> class.new -> Theme.attach`
- `Theme.set(frame, theme) -> Theme.apply(runtime_config) -> Style.applyLayout(runtime_config) -> live frame replay`
- `frame:on(...) -> Jass.MHFrameEvent_RegisterByCode`
- `Watcher.watch(...) -> 包装 class setter`
- `Tween.animate(...) -> 插值 -> 回写 frame 属性`

## 3. 当前采用现状

全仓扫描后的采用现状非常明确：

- 高层 Lua UI 的真实仓库使用极少。
- 最完整的高层样本集中在 `.planning/tools/ui_framework_remaining_smoke.lua`。
- `../Style_demo.lua` 更像布局 authoring 演示，而不是业务稳定样本。
- `War3/map/war3map.j` 存在直接调用 `MHFrame_*` 的原生绕行样本。
- 在 `Code` 业务目录里，没有找到广泛的 `Component({...})`、`Panel({...})`、`Theme.set(...)`、`Watcher.watch(...)` 的真实业务使用面。

结论：

- 当前大量“能力存在”其实仍是框架自证，不是业务层已经证明。
- 文档、维护性、性能结论都必须带上“采用度不足”的限定词。

## 4. 五维总评

| 维度 | 总评 | 结论 |
| --- | --- | --- |
| 性能 / 消耗 | 中等 | 设计上明显在规避浏览器式全量运行时；但 `Class` 元方法分发、Theme/Style 预处理、`childs` 同步、Tween 插值仍有持续成本。 |
| 结构边界 | 良好 | `Component -> Theme -> Style -> Frame` 的职责边界现在是清晰的，Theme 不再污染 Frame。 |
| 开发便利性 | 中等 | 同时支持 direct constructor、declarative Component、Theme、Style、Watcher、Tween，表达力强；但入口较多，证据级别不均。 |
| 可维护性 | 中等 | 模块切分合理，控件类线性扩展；但 `Class.lua` 心智负担高，`Constant.lua` 体量巨大，多数控件仍是 source-only。 |
| 当前可验证正确性 | 偏弱 | geometry 主链路暴露出真实 `Point` 风险，且 smoke 对这部分存在盲区。 |

## 5. 模块级审查

### 5.1 入口、桥接、外部底层

| 模块 | 公开入口 | 依赖入口 | 运行时副作用 | 当前判断 | 验证状态 |
| --- | --- | --- | --- | --- | --- |
| `Code/Main.lua` | 顶层 `require` 链 | `Runtime`、`Debug`、`Game`、`Core.UI.*` | 固定装载顺序 | 负责 Lua 侧总装载；Theme 经 `Component` 间接进入，入口清楚但有隐藏依赖。 | 静态扫描 |
| `Code/Init.j` | JASS/Lua 混合导入 | `memory_hack`、`AsphodelusUI`、`importlua("Core.UI.*")` | 固定 include/import 顺序 | 负责启动链拼接；证明 Lua UI 依赖外部 JASS/native 环境。 | 静态扫描 |
| `../AsphodelusUI/AsphodelusUI.j` | AUI 基础宏和函数 | JASS 环境 | 全局宏 / library | 更像环境级依赖，不是当前 Lua 框架的直接高层语义来源。 | 静态扫描 |
| `../memory_hack/memory_hack.j` | native 总入口 | `api/frame.j`、`api/game_ui.j`、`api/game_ui_data.j` | 暴露大量 native API | 证明 UI 真正底盘在 `memory_hack`。 | 静态扫描 |
| `../memory_hack/api/frame.j` | `MHFrame_*` 原语 | Japi placeholder | 创建 / 销毁 / 定位 / 纹理 / 文本 / 事件 | Lua `Frame.lua` 与所有控件最终都落到这里。 | 静态扫描 |
| `../memory_hack/api/game_ui.j` | `MHUI_*` 根节点与系统 UI 原语 | Japi placeholder | 访问 GameUI / ConsoleUI / 系统 UI | `Frame.getGameUI()` 与 `Frame.getConsoleUI()` 的来源明确。 | 静态扫描 |
| `../memory_hack/api/game_ui_data.j` | UI 数据入口 | Japi placeholder | 读取 UI 数据 | 当前 Lua UI 框架未直接使用，应视为潜在能力。 | 静态扫描 |
| `Code/Lib/API/Jass.lua` | 统一 Lua API 桥 | `jass.common` / `jass.japi` / `jass.code` | 首次访问后缓存函数引用 | 很薄、很轻，但几乎没有额外保护层。 | 静态扫描 |
| `Code/Lib/API/Constant.lua` | 统一常量表 | `common` / `japi` | 无 | 功能完整，但文件体量大、可读性一般，维护成本高。 | 静态扫描 |
| `Code/Lib/Base/Class.lua` | 类 / 属性访问器 / 生命周期 | `DataType` / `Set` | 元方法分发、getter/setter 编译、实例构造销毁 | UI 对象模型地基；设计目标偏性能，但复杂度高。 | 静态扫描 |
| `Code/FrameWork/Manager/Point.lua` | `Point(...)` / `Point.get(...)` | `math` | 坐标打包与解包 | 对整数成立、对小数和负值失真，是当前最大正确性风险。 | 源码 + 实验已验证 |

### 5.2 核心 UI 内核与运行时扩展

| 模块 | 公开入口 | 依赖入口 | 运行时副作用 | 当前判断 | 验证状态 |
| --- | --- | --- | --- | --- | --- |
| `Code/Core/UI/Frame.lua` | base class、属性面、事件、定位 helper、对象注册 | `Jass`、`Constant`、`Class`、`Point`、`LinkedList` | 创建/销毁 handle、同步 `childs`、注册事件、绑定单位 | Theme 边界已清理干净，但 geometry 主链路被 `Point` 污染。 | 静态扫描 + smoke 边界验证 |
| `Code/Core/UI/Style.lua` | `applyLayout`、runtime sticky 绑定 | `Constant`、`Frame` | 编译 layout、写 runtime layout 元数据 | 是 compile-time layout compiler，不是浏览器 runtime。 | 静态扫描 + smoke 验证 |
| `Code/Core/UI/Theme.lua` | `define/get/resolve/apply/attach/set/refresh` | `Style`、弱表声明快照 | 预处理 config、运行时 theme replay | 归属边界是对的；风险在 selector 浅层、hot-swap 范围有限。 | 静态扫描 + smoke 验证 |
| `Code/Core/UI/Component.lua` | `define/create/__call` | `Class`、`Frame`、`Style`、`Theme` | 归一化 config、创建 frame、attach Theme | 当前最合理的统一入口，但 registry metadata/tree 叙事仍不稳。 | 静态扫描 + smoke 验证 |
| `Code/Core/UI/Watcher.lua` | `watch/unwatch/unwatchAll/clear` | `LinkedList`、class setter 表 | 包装 setter、分发监听器 | alpha 成功路径和失败路径都已有 smoke。 | 静态扫描 + smoke 验证 |
| `Code/Core/UI/Tween.lua` | `animate/cancel/cancelAll`、`Frame.animate`、`Frame.stopAnimate` | `Tool`、`Point`、计时环境 | 保存 tween 状态、按帧插值回写属性 | 标量补间路径较清楚，`position/size` 被 `Point` 风险直接波及。 | 静态扫描 + smoke 部分验证 |

### 5.3 控件层

| 模块 | 公开入口 | 当前判断 | 验证状态 |
| --- | --- | --- | --- |
| `Panel.lua` | `Panel({...})`、`image`、`is_tile` | 最基础的容器类，结构简单；`is_tile` 仍无独立 smoke。 | 构造 smoke 部分验证 |
| `Texture.lua` | `Texture({...})`、`color`、`blend_mode` | 轻量纹理类清楚，但当前无独立 smoke。 | source-only |
| `Text.lua` | `Text({...})`、文本颜色/flag/style、`setFont/setAlign` | 文本 API 丰富，但 `shadow_off` 受 `Point` 风险影响。 | 构造 smoke 部分验证 |
| `SimpleText.lua` | `SimpleText({...})`、`setFont/setAlign` | 轻量文本定位清楚，但验证不足。 | source-only |
| `TextArea.lua` | `TextArea({...})`、`setFont/addText` | 存在能力，但目前只到源码级。 | source-only |
| `Button.lua` | `Button({...})`、`state`、`click/getTexture/getHighlight` | 与 `Frame.on/off` 配合思路合理，但未被 smoke 覆盖。 | source-only |
| `Slider.lua` | `Slider({...})`、`value/min/max`、`addBorder` | 接口完整，但验证不足。 | source-only |
| `Model.lua` | `Model({...})`、`path` | 简单明了。 | source-only |
| `Sprite.lua` | `Sprite({...})`、3D 位置/旋转/缩放/动画/贴图 | 能力多但验证缺口最大。 | source-only |
| `Portrait.lua` | `Portrait({...})`、`path`、`setCameraPosition/setCameraFocus` | 边界清楚，但全是源码级证据。 | source-only |

## 6. 核心发现

### 6.1 `P0`：真实 `Point.lua` 与 UI 小数坐标链路不兼容

证据链：

- `Point.lua` 使用 Cantor 配对公式压缩坐标
- 真实实验表明它只能稳定处理整数样例
- `Frame.__init__`、`Text.shadow_off`、`Tween position/size` 都依赖它

影响面：

- direct constructor
- `Component({...})`
- Style 编译结果最终写回 `Frame.position/size`
- Tween 的位置与尺寸补间
- 文本阴影偏移

这不是边角 bug，而是默认 UI authoring 值就会踩中的主链路风险。

### 6.2 Theme / Style / Frame 的边界方向是正确的

- Theme 已经回到 `Component` 所拥有的应用层
- Style 仍然是编译器，而不是伪浏览器
- Frame 不再承载 Theme 运行时状态
- runtime theme replay 明确依赖 `frame.childs`

说明框架“怎么分层”大体做对了，当前更大的问题在正确性地基和验证覆盖。

### 6.3 控件层能力面比验证面大得多

- 2D：Panel / Texture / Text / SimpleText / TextArea / Button / Slider
- 3D：Model / Sprite / Portrait

但多数控件仍停留在：

- 源码有能力
- 注释写了用法
- 本地没有独立 smoke
- 业务层没有真实采用

## 7. 已知限制与风险列表

- `display = "none"` 仍不是 CSS 等价行为。
- Theme selector 仍是单节点浅层匹配，不支持 descendant/cascade。
- runtime Theme 仍是 bounded replay，不是浏览器级样式系统。
- `Component.define/create` 的 `tree` / metadata 契约仍需重新明确。
- 高层 Lua UI 的真实业务采用仍然稀少。
- `Frame.on/off`、相对定位 helper、大量控件专有方法仍缺少 smoke。
- 控件层 source-only 面积较大。
- 实机性能结论当前仍只能做静态热路径分析，不能做 FPS 结论。

## 8. 优先级整改建议

| 优先级 | 项目 | 影响面 | 建议验证方式 |
| --- | --- | --- | --- |
| `P0` | 修复或替换 `Point` 在 UI 几何链路中的表示方式；在修复前，不应继续宣称高层 UI authoring 已稳态可用。 | `Frame`、`Text`、`Tween`、全部 direct constructor、`Component`、Style 输出落地 | 新增真实 `Point` round-trip 测试；新增不使用 stub 的 `Frame.position/size` 最小验证 |
| `P0` | 修正 smoke 的 Point 盲区，至少把小数和负值样例纳入正式验证。 | `.planning/tools/ui_framework_remaining_smoke.lua` | 让 smoke 同时覆盖整数、小数、负值 |
| `P1` | 明确 `Component.define/create` 的 registry metadata 与 `tree` 契约。 | `Component.lua`、Theme/authoring 文档 | 新增针对 registry tree 的 smoke |
| `P1` | 为 runtime Theme 建立按控件分类的 hot-apply 白名单矩阵。 | `Theme.lua`、各控件类 | 逐控件列出可安全 replay 的属性，并新增 smoke |
| `P2` | 扩充 smoke：`Frame.on/off`、相对定位 helper、`Button.getTexture`、`Slider.addBorder`、`Sprite.setImage/setAnimation`、`Portrait.setCamera*`。 | `Frame.lua`、控件层 | 每个 source-only 公开面至少有 1 个 bounded smoke |
| `P2` | 统一并公开“高层推荐入口”叙事：何时用 `Component`，何时用 direct constructor，何时必须手动 `Theme.attach`。 | 文档与未来业务接入 | 用本轮写法手册为基础，产出对外作者文档 |
| `P3` | 决定 selector 是否要走 descendant/cascade 路线。 | `Theme.lua`、性能模型、作者心智 | 设计评审 + 原型，不宜直接实装 |
| `P3` | 决定 manual `Theme.attach(...)` 是否需要更高层包装 API。 | `Component` / Theme authoring | 结合未来业务接入面决定 |

## 9. 结论

这套 UI 框架在“边界设计”上已经比旧阶段健康得多，尤其是 Theme 从 Frame 中退出之后，`Component -> Theme -> Style -> Frame` 的分层非常像一套可继续演进的正确骨架。

但当前不能把它判定成“高效率、低消耗、开发便利、可维护、已验证可靠”的成熟框架，因为几何主链路存在一个已经被实证的 `Point` 阻塞问题，而现有 smoke 又恰好对这块存在盲区。  
所以本轮最准确的结论是：

- 架构方向对
- 能力面广
- 验证基线已有雏形
- 但 geometry correctness 还有一个必须先清掉的 `P0`
