# UI 框架全面审查报告

## 1. 审查范围与方法

- 审查对象：
- `Code/Core/UI` 下 16 个 UI 模块
- `doc/UI框架说明.md`
- `Code/Main.lua`
- `Code/Init.j`
- `Code/Lib/Base/Class.lua`
- 审查方法：
- 静态源码审查
- 文档与实现对照
- 初始化入口与打包入口对照
- 业务侧调用分布检索
- 非目标：
- 不改运行时代码
- 不做重型性能压测
- 不做具体页面设计和美术审查

## 2. 执行摘要

| 维度 | 结论 |
| --- | --- |
| 当前框架定位 | 更接近“JASS UI 句柄的 OOP 封装层 + 若干现代化实验模块”，还不是完全收敛的统一 UI 平台 |
| 最强能力 | 底层 Frame 封装、属性访问器、轻量组件封装、性能意识、事件/动画/样式/声明式能力雏形 |
| 最大风险 | 组件树所有权、销毁生命周期、缓存状态模型三条主线的公开契约不一致 |
| 业务采用现状 | 业务代码中几乎没有 `Style/Layout/Tween/Watcher/Builder` 的外部使用，现代化抽象主要存在于文档和框架层 |
| 现代前端对齐度 | 事件、样式、布局、状态监听、动画、声明式构建都“部分对齐”，但还未形成统一 contract |
| 审查结论 | 这套框架值得继续建设，但应先做 V1 修补和 V1.5 结构整理，再推进 V2 契约重构 |

## 3. 现状基线与 adoption

### 3.1 模块分层

| 分层 | 模块 | 当前角色 |
| --- | --- | --- |
| 基础层 | `Frame` | 句柄封装、属性系统、定位、事件、映射表、工具方法 |
| 组件层 | `Texture` `Text` `Button` `Slider` `Sprite` `Model` `Portrait` `SimpleTexture` `SimpleText` `TextArea` | 对不同 JASS Frame 类型做属性化封装 |
| 现代化抽象层 | `Style` `Layout` `Tween` `Watcher` `Builder` | 样式、布局、动画、状态监听、声明式构建 |

### 3.2 设计意图 - 实现 - 实际使用矩阵

| 能力 | 设计意图 | 真实实现状态 | 仓库实际使用 |
| --- | --- | --- | --- |
| `Frame`/组件层 | 稳定基础能力 | 已形成主要骨架 | 已进入 `Main.lua` 主入口 |
| `Style` | CSS Variables + Stylesheets | 功能存在，但非响应式、契约边界较薄 | 业务代码外部调用数 0 |
| `Layout` | 简化版 Flex/Grid | 一次性布局函数，定位能力够用 | 业务代码外部调用数 0 |
| `Tween` | CSS Transition / Web Animation API | 核心逻辑已写，但 delay 语义有明显缺陷 | 业务代码外部调用数 0 |
| `Watcher` | Vue watch | 机制存在，但注册成功不等于可触发 | 业务代码外部调用数 0 |
| `Builder` | React JSX / Web Components 风格声明式工厂 | 思路清晰，但 parent contract 和注册流程不稳定 | 业务代码外部调用数 0 |

### 3.3 adoption 证据

- 在 `Code` 业务代码中，`Builder.create`、`Style.apply`、`Style.define`、`Style.theme`、`Layout.horizontal`、`Layout.vertical`、`Layout.grid`、`Watcher.watch`、`Tween.animate`、`frame:animate()`、`frame:on()` 的外部调用数均为 0。
- `Style`、`Layout`、`Tween`、`Watcher`、`Builder` 的存在感主要来自 `doc/UI框架说明.md`，而不是业务层落地。
- `Main.lua:74-84` 只引入了组件层；`Init.j:74-80` 甚至只导入了更少的一部分组件文件，现代化抽象没有进入默认引导面。

**结论**：当前框架还处在“底层基础层已可用，现代化抽象尚未形成项目默认开发方式”的阶段。

## 4. 八条审查线与 Web 对照矩阵

| 审查线 | 当前模块 | Web 对照 | 状态 | 审查结论 |
| --- | --- | --- | --- | --- |
| 节点树与所有权 | `Frame`, `Builder` | DOM tree / ownership | 语义偏移 | 父子关系 contract 在 frame、handle、文档、Builder 之间不统一，是当前最危险的结构问题 |
| 生命周期 | `Frame`, `Tween`, `Watcher` | mount / unmount / destroy | 缺失 | 有销毁入口，但没有统一 teardown 语义，destroy 甚至对 unnamed frame 不安全 |
| 事件系统 | `Frame.on/off` | `addEventListener/removeEventListener` | 部分对齐 | 事件模型方向是对的，但销毁与注销没有纳入统一生命周期 |
| 定位与布局 | `Frame`, `Layout` | absolute / relative / flex / grid | 部分对齐 | API 表达力足够，但缓存状态不是权威真相，`Layout` 也是一次性布局 |
| 样式与主题 | `Style` | tokens / variables / stylesheet | 部分对齐 | 有主题和命名样式，但非响应式且未成为默认 runtime contract |
| 状态监听 | `Watcher` | `watch` / subscriptions | 部分对齐 | 监听机制存在，但注册成功和可触发之间没有强约束 |
| 动画 | `Tween` | transition / WAAPI | 部分对齐 | 核心框架有了，但 delay 行为与文档语义不一致 |
| 声明式构建 | `Builder` | JSX / template tree | 语义偏移 | 方向正确，但 `parent` 契约、类型注册、load-order 都不够稳 |

## 5. 重点问题清单

### P0-1 组件树 ownership contract 内部不一致

- 现象：
- `Frame.__common_constructor` 明确要求 `template.parent` 是 table，并使用 `template.parent.handle` 创建子节点，见 `Code/Core/UI/Frame.lua:150-160`。
- `Builder.create` 构造 template 时直接透传 `config.parent`，而递归创建子节点时又把 `child_config.parent = frame.handle`，见 `Code/Core/UI/Builder.lua:190-205` 与 `Code/Core/UI/Builder.lua:243-249`。
- 文档和模块注释中的示例大量传入 `game_ui_handle`、`panel.handle`、`root.handle`，见 `doc/UI框架说明.md:59-75` 与 `doc/UI框架说明.md:730-756`。
- `Frame.parent` 的 getter 返回 raw parent handle，而 setter 又把 `parent_frame` 原样传给 `MHFrame_SetParent`，并继续当作 frame 对象写 `parent_frame.childs`，见 `Code/Core/UI/Frame.lua:241-248`。
- `childsUpdate` 从 `parent_frame.child` 读，setter 却写 `parent_frame.childs`，见 `Code/Core/UI/Frame.lua:92-119` 与 `Code/Core/UI/Frame.lua:248`。
- 根因：
- 低层 handle 语义和高层 frame 语义没有统一 public contract。
- `Builder`、`Frame`、文档分别站在不同 contract 上写代码。
- 影响面：
- 声明式创建
- 运行时 reparent
- 子级同步
- 文档可信度
- V2 组件树设计
- 建议：
- V1：增加统一 parent 归一化逻辑，显式支持 frame 或 handle，修复 `child`/`childs` 漂移，并让 getter/setter 语义对称。
- V1.5：把 parent 处理提炼为单点 helper，禁止模块各自猜测 parent 形态。
- V2：明确公开契约，只保留一种主语义，另一种走显式适配层。
- 成本：中
- 兼容性姿态：`适配过渡`，V2 进入重定义

### P0-2 destroy 生命周期既不安全也不完整

- 现象：
- `Frame.__del__` 无条件执行 `class.__frames_by_name[frame.name] = nil`，见 `Code/Core/UI/Frame.lua:227-233`。当 `frame.name` 为 nil 时，Lua table 以 nil 为 key 会直接报错。
- 框架另有 `Watcher.clear`、`Tween.cancelAll`、`Frame.off` 等清理入口，见 `Code/Core/UI/Watcher.lua:227-247`、`Code/Core/UI/Tween.lua:394-430`、`Code/Core/UI/Frame.lua:750-760`，但 `destroy()` 没有统一调用它们。
- 根因：
- destroy 只处理了 JASS handle 和映射表，没有把“现代化抽象层”纳入统一生命周期。
- 影响面：
- unnamed frame 销毁安全性
- 动画中销毁
- 监听器和事件残留
- 后续组件生命周期扩展
- 建议：
- V1：修复 unnamed frame 销毁；引入统一 `preDestroy` 清理路径，至少处理事件表、watcher、tween。
- V1.5：把组件 teardown 明确成框架 contract，而不是散落在模块方法里。
- V2：引入显式生命周期钩子或统一 `dispose` 语义。
- 成本：中
- 兼容性姿态：`保留并修正`，V2 深化

### P0-3 Tween 的 delay 语义与文档承诺不一致

- 现象：
- `Tween.animate` 用 `elapsed = -delay` 表示延迟，见 `Code/Core/UI/Tween.lua:337-353`。
- `onTick` 里计算 `t = tw.elapsed / tw.duration` 后只做上限裁剪，没有下限裁剪，也没有在 delay 未结束时跳过属性写入，见 `Code/Core/UI/Tween.lua:213-227`。
- 文档却把 `delay` 描述成“延迟启动”，见 `doc/UI框架说明.md:625-629`。
- 根因：
- 实现把 delay 建模成负进度，但 tick 阶段仍然执行 easing 和 lerp。
- 影响面：
- 动画起始帧正确性
- `on_update` 语义
- Builder 示例中带 `delay` 的动画可信度
- 建议：
- V1：当 `elapsed < 0` 时直接保留 tween，不更新属性；或对 `t` 做 `[0,1]` 裁剪。
- V1.5：把 delay、fill、cancel 语义写成统一动画 contract。
- 成本：低
- 兼容性姿态：`保留并修正`

### P1-1 缓存式 state model 不是 authoritative source of truth

- 现象：
- `position` getter 直接返回缓存字段 `frame[position_modify]`，见 `Code/Core/UI/Frame.lua:281-289`；但 `setPoint`、`centerIn`、`above`、`below`、`leftOf`、`rightOf` 都不会同步该缓存，见 `Code/Core/UI/Frame.lua:562-639`。
- `size` getter 也只读缓存字段，见 `Code/Core/UI/Frame.lua:437-445`；但 `width`、`height` setter 不会同步 `size`，见 `Code/Core/UI/Frame.lua:255-273`。
- `Slider.max_limit/min_limit`、`Sprite.x_scale/y_scale/z_scale` 同样依赖未初始化的兄弟缓存值，见 `Code/Core/UI/Slider.lua:35-45` 与 `Code/Core/UI/Sprite.lua:128-146`。
- 根因：
- 为了减少 JASS 查询而采用缓存，但没有建立缓存失效与同步规则。
- 影响面：
- 状态可预测性
- `Tween` 读取起始状态正确性
- 布局与动画组合
- 调试难度
- 建议：
- V1：明确哪些 getter 是缓存值、哪些是 runtime 真值；修复最危险的组合属性。
- V1.5：建立统一缓存策略和同步 helper。
- V2：统一 state model，不再让 public getter 混合“缓存语义”和“运行时真值语义”。
- 成本：中
- 兼容性姿态：`适配过渡`，V2 进入重定义

### P1-2 Builder 的注册和装载流程存在隐藏陷阱

- 现象：
- `ensureTypesLoaded()` 首次会装载内建类型，见 `Code/Core/UI/Builder.lua:64-76`。
- 但 `Builder.register()` 会把 `_types_loaded = true`，见 `Code/Core/UI/Builder.lua:138-140`。如果用户先注册自定义类型，再第一次调用 `create()`，内建类型装载可能被整体跳过。
- 同时，Builder 的 parent contract 也没有归一化，见 `Code/Core/UI/Builder.lua:190-205` 与 `Code/Core/UI/Builder.lua:243-249`。
- 根因：
- 自定义扩展与内建类型装载共享了同一个布尔开关，扩展协议设计过窄。
- 影响面：
- 自定义组件注册
- 声明式构建稳定性
- 未来插件机制
- 建议：
- V1：把“内建类型已装载”和“允许用户注册类型”拆开。
- V1.5：将 Builder 组件注册升级为显式 registry contract。
- V2：让 Builder 成为 schema-first 的公开入口，而不是“若干隐式前提 + 递归 table”。
- 成本：低到中
- 兼容性姿态：`适配过渡`

### P1-3 命名漂移已经造成跨模块集成失败

- 现象：
- `Text` 组件定义的是 `disbale_color`，见 `Code/Core/UI/Text.lua:110-118`。
- `Style` 和 `Builder` 暴露给外部的却是 `disable_color`，见 `Code/Core/UI/Style.lua:47-50` 与 `Code/Core/UI/Builder.lua:100-103`。
- `child` 与 `childs` 也出现同类漂移，见 `Code/Core/UI/Frame.lua:94` 与 `Code/Core/UI/Frame.lua:248`。
- 根因：
- 缺少统一 API 名称表和最小契约校验。
- 影响面：
- 样式应用
- Builder 声明式属性
- 文档可信度
- 建议：
- V1：补别名并修正主拼写，保持兼容。
- V1.5：增加 API 名称表或元数据驱动校验。
- V2：统一命名规范并冻结公开词汇表。
- 成本：低
- 兼容性姿态：`保留并修正`

### P1-4 Watcher 注册成功不等于监听真正成立

- 现象：
- `wrapSetter` 在找不到 `__setattr__` 或目标 setter 时直接 return，见 `Code/Core/UI/Watcher.lua:83-92`。
- `Watcher.watch` 仍会继续创建 watcher list 并返回 `LinkedList_add(...)` 的结果，见 `Code/Core/UI/Watcher.lua:168-186`。
- 根因：
- 监听注册流程没有把“setter 已成功包装”作为前置成功条件。
- 影响面：
- 状态监听可信度
- 调试成本
- 未来响应式绑定
- 建议：
- V1：让 `wrapSetter` 返回布尔值，并在 `watch()` 中失败即返回 false。
- V1.5：补充对只读属性、无 setter 属性的显式错误路径。
- 成本：低
- 兼容性姿态：`保留并修正`

### P1-5 文档、主入口和打包入口没有描述同一套框架表面

- 现象：
- 文档把 `Style`、`Layout`、`Tween`、`Watcher`、`Builder` 作为框架特性完整介绍，见 `doc/UI框架说明.md:500-765`。
- `Main.lua:74-84` 只默认加载组件层，不包含这些现代化模块。
- `Init.j:74-80` 只导入了更少的一组组件文件，连 `Portrait`、`SimpleTexture`、`SimpleText`、`Button`、`TextArea` 都没有对齐到 `Main.lua`。
- 文档中 Builder 示例直接用了 `dialog:animate(...)`，但 Tween 的方法注入需要显式 `require "Core.UI.Tween"`，见 `doc/UI框架说明.md:618-636` 与 `doc/UI框架说明.md:730-756`。
- 根因：
- 现代化能力还停留在“文档里的能力集合”，没有沉淀成统一 bootstrap contract。
- 影响面：
- 新人接入体验
- 打包与运行一致性
- 现代化抽象 adoption
- 建议：
- V1：补文档说明和 bootstrap 对照表。
- V1.5：统一 `Main.lua` / `Init.j` / 文档的支持面。
- V2：去掉依赖隐式注入的 contract。
- 成本：低到中
- 兼容性姿态：`适配过渡`

## 6. 哪些设计值得保留

- 固定属性列表、缓存局部函数、低分配遍历这些性能意识值得保留。
- `Frame` 的对象化封装方向值得保留，因为它显著降低了直接操作 JASS API 的心智负担。
- `Style`、`Layout`、`Tween`、`Watcher`、`Builder` 这五个抽象方向都值得保留，因为它们对应的是未来 UI 平台的核心能力。
- 文档主动用 HTML/CSS/JS 类比是对的，但前提是 contract 需要先收敛。

## 7. 公共接口分类

| 接口 | 归类 | 原因 |
| --- | --- | --- |
| `Frame` 基础属性与 `includePoint`、`bindToUnit` 等工具方法 | 保留并修正 | 基础价值高，但需要修正 parent、destroy、缓存语义 |
| `Frame.on/off` | 保留并修正 | 事件模型方向正确，但要纳入统一生命周期 |
| `Frame.setPoint/centerIn/...` | 保留并修正 | 表达力够用，但应和 position/state contract 对齐 |
| 各具体组件类 | 保留并修正 | 组件层是框架基础，但专用组件初始化重复度高 |
| `Style.theme/define/apply` | 适配过渡 | 能力成立，但 token 与响应式边界需要在 V2 重构 |
| `Layout.horizontal/vertical/grid` | 适配过渡 | 一次性布局适合保留为 helper，但不应冒充完整 layout system |
| `Watcher` | 适配过渡 | 值得保留为观察机制原型，但 contract 需要更严格 |
| `Builder.create/register` | 适配过渡 | 方向重要，但当前 contract 太脆弱 |
| `Tween.animate/cancel/cancelAll` | 保留并修正 | 动画引擎有价值，但语义需要修补 |
| `frame:animate()` 注入式接口 | 进入 V2 重定义 | 依赖 load-order 的隐式注入不适合作为长期公共契约 |

## 8. V1 / V1.5 / V2 路线图

### V1 保守修补

- 修复 `Frame.__del__` 对 unnamed frame 的销毁安全问题。
- 修复 `Frame.parent`、`child`/`childs` 和 Builder parent 传参契约。
- 修复 Tween delay 的负进度问题。
- 为 `disable_color` 提供兼容别名并修复拼写主名。
- 让 `Watcher.watch` 对不可监听属性返回失败。
- 在文档里补充 bootstrap 与显式 `require` 依赖说明。

### V1.5 结构整理

- 抽出专用组件共享初始化逻辑，去掉 `SimpleText`、`SimpleTexture`、`Portrait` 的重复 `__init__`。
- 建立统一 destroy cleanup 路径，收束事件、watcher、tween 的 teardown。
- 建立公共 API 名称表或元数据，用于 Style/Builder/组件属性的一致性校验。
- 明确缓存属性的规则，避免 public getter 混用“缓存值”和“运行时真值”。
- 统一 `Main.lua`、`Init.j`、文档中“框架支持面”的说法。

### V2 破坏性重构

- 组件树：统一 parent/child contract，确定是 frame-first 还是 explicit-handle-wrapper。
- 属性命名：冻结公开属性词汇表，彻底清理拼写漂移与历史别名。
- 样式 token：把 `theme/define/apply` 升级为明确 token + style schema。
- 布局描述：把一次性 helper 和声明式 layout descriptor 区分开。
- 状态/监听：统一 authoritative state model，重新定义 watch/bind/update contract。
- 销毁清理：引入统一 lifecycle，杜绝“destroy 后还要手动 cancel/clear/off”的碎片化语义。

## 9. V2 第一版 contract 提纲

### 9.1 组件树

- `parent` 只接受一种主语义。
- 如果保留兼容模式，必须走显式 adapter，而不是隐式猜测 handle/frame。
- `children` 只能从统一只读视图读取，内部更新名称必须唯一。

### 9.2 属性命名

- 组件属性名建立单一来源表。
- Style、Builder、组件定义都必须共享同一份属性元数据。
- 历史别名通过兼容层管理，并在文档中标记淘汰窗口。

### 9.3 样式 token

- 区分 design token、component style、runtime state style。
- `theme` 不再只是字符串替换，而是明确 token 解析规则。

### 9.4 布局描述

- 一次性 helper 保留为 helper。
- 真正的布局系统应支持可重算、组合和明确的 container contract。

### 9.5 状态 / 监听

- Public getter 必须说明是 runtime truth 还是 cached projection。
- 监听只能注册到可观测属性，失败要可见。

### 9.6 销毁清理

- `destroy()` 必须是最终一致的释放入口。
- 事件、watcher、tween、name map、handle map 都由统一 lifecycle 托管。

## 10. 五个固定问题的答案

### 10.1 当前框架真正擅长什么

- 擅长把底层 JASS Frame API 包装成更容易写、更容易读的 Lua 对象接口。
- 擅长用低分配、显式缓存的方式表达性能意识。
- 擅长提供“现代 UI 能力雏形”，为未来做平台化演进留好了方向。

### 10.2 当前框架最危险的设计债是什么

- 最危险的是组件树所有权、生命周期和状态模型没有统一 contract。
- 这不是单点 bug，而是会同时影响 Builder、事件、动画、监听、文档可信度和 V2 演进的系统级设计债。

### 10.3 哪些地方值得小修

- destroy 安全性
- parent/child 命名和传参一致性
- Tween delay
- Watcher 注册失败语义
- `disable_color` 兼容别名
- bootstrap 文档对齐

### 10.4 哪些地方不值得继续补丁式演进

- 不值得继续在“handle 和 frame 混用”上打补丁。
- 不值得继续依赖隐式方法注入作为长期公共 API。
- 不值得让缓存 getter 继续兼任运行时真值而不声明规则。

### 10.5 如果做 V2，第一版公开契约应该先统一什么

- 先统一组件树 ownership contract。
- 第二优先统一 authoritative state model。
- 第三优先统一 destroy lifecycle。

只要这三件事不统一，样式、布局、监听、动画、Builder 都会继续带着歧义演进。
