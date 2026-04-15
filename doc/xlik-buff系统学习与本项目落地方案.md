# xlik Buff 系统学习与本项目落地方案

## 1. 研究范围与总判断

本文基于以下内容整理：

- `Reference (not included in the project)/xlik-jade-main/library/class/meta/buff.lua`
- `Reference (not included in the project)/xlik-jade-main/library/class/vast/_vast.lua`
- `Reference (not included in the project)/xlik-jade-main/library/common/superposition.lua`
- `Reference (not included in the project)/xlik-jade-main/library/class/vast/unit.lua`
- `Reference (not included in the project)/xlik-jade-main/library/ability/*.lua`
- `Reference (not included in the project)/xlik-jade-main/exe/lib/embeds/new/scripts/globals/setup/txtAttribute.lua`
- `Reference (not included in the project)/xlik-jade-main/library/class/meta/uiKit.lua`
- `Reference (not included in the project)/xlik-jade-main/library/class/ui/tooltips.lua`
- `Reference (not included in the project)/xlik-jade-main/exe/lib/luaAssets.go`
- 当前工程中的 `Code/Core/Entity/Buff.lua`、`Code/Logic/Define/Attribute.lua`、`Code/FrameWork/GameSetting/Attribute.lua`、`Code/Core/UI/*`

核心结论：

1. `xlik` 的“Buff 系统”不是单纯的状态表，而是一个“带生命周期、可回滚、可查询、可显示”的运行时对象系统。
2. `xlik` 里其实有两种 Buff：
   - `slk_buff(...)`：物编/SLK 层的魔法效果资源。
   - `Buff({...})`：运行时状态对象。
   这两者有关联，但不是同一个层级的东西。
3. `xlik` 的 Buff 真正强大的点，不是“能挂个图标”，而是：
   - 可以把任何临时属性变化封装成 Buff；
   - 可以把眩晕、沉默、缴械、隐身、无敌这类控制状态统一纳入同一套对象模型；
   - 可以统一做查询、清除、显示、提示、持续时间管理。
4. `xlik` 的 Buff UI 设计思路是清楚的，但 `Reference` 目录里没有 `war3mapUI/xlik_buff/main.lua` / `main.fdf` 源文件，所以“具体布局代码”我无法直接逐行还原；本文会把“可直接确认的事实”和“根据装载机制推断的 UI 结构”分开写清楚。
5. 你当前项目已经具备做出一套“仿 xlik 但更适配本项目”的 Buff 系统的大部分基础：
   - 有 `Buff` 实体雏形；
   - 有 `Timer`；
   - 有 `Event`；
   - 有完整的属性系统 `Attr + Unit.setAttr`；
   - 有一套足够做 Buff 面板的 UI 框架。
6. 你当前项目真正缺的，不是底层能力，而是“把 Buff、属性变化、状态叠加、UI 展示、选择目标同步”串成一条完整链路。

---

## 2. 先分清 xlik 里的两种 Buff

### 2.1 SLK Buff：物编层 Buff

`xlik` 文档 `2.Slk资源/1.魔法效果 Buff.md` 里的 `slk_buff({...})`，本质上是在生成物编中的 Buff/Effect 条目，例如：

```lua
local b = slk_buff({
    _parent = "Apiv",
    Name = "新隐身",
})
slk_ability({
    _parent = "Apiv",
    BuffID = { b._id },
})
```

这层 Buff 的作用是：

- 给技能绑定物编 BuffID；
- 决定原生图标、Bufftip、Buffubertip、Buffart、特效挂点等；
- 让技能在原生数据层有一个“魔法效果定义”。

这不是本文重点，因为它更接近“资源声明”和“物编生成”。

### 2.2 Runtime Buff：运行时 Buff 对象

真正的 xlik Buff 系统在：

- `library/class/meta/buff.lua`

这层才是游戏逻辑真正依赖的“状态系统”。

它负责：

- 挂到对象/单位身上；
- 执行效果；
- 记录剩余时间；
- 到期回滚；
- 提供查询与清除接口；
- 提供 UI 所需的名称、图标、描述、可见性、中心文字等元数据。

后文说“xlik Buff 系统”，默认都指这一层。

---

## 3. xlik Buff 运行时系统是怎么实现的

## 3.1 Buff 的数据模型

`library/class/meta/buff.lua` 中，Buff 是一个 Meta 对象，关键字段包括：

- `_object`：Buff 作用对象。
- `_key`：Buff 逻辑键。
- `_name`：显示名。
- `_icon`：图标。
- `_description`：描述。
- `_text`：图标中央的强调文本。
- `_duration`：持续时间，默认 `-1`。
- `_visible`：是否允许 UI 显示。
- `_signal`：Buff 类型标识，通常是 `buffSignal.up` 或 `buffSignal.down`。
- `_purpose`：应用逻辑。
- `_rollback`：回滚逻辑。
- `_durationTimer`：持续时间计时器。
- `_running`：是否处于生效状态。

可以把它理解成：

> “一个带元数据和回滚函数的临时行为对象”

而不是：

> “一个只记录剩余秒数的状态条目”

这就是 xlik Buff 设计的第一层价值。

## 3.2 Buff 的创建流程

`Buff(params)` 的流程是：

1. 校验参数：
   - `object`
   - `key`
   - `purpose`
   - `rollback`
2. 确保目标对象有 `_buffs` 容器，没有就创建 `Array()`。
3. 组装 Buff 元数据：
   - 名称默认来自 `params.name` 或 `attribute._labels[key]`；
   - 图标来自 `params.icon` 或 `attribute.icon(key)`；
   - 描述、文字、可见性、持续时间等按参数写入。
4. 生成 Buff 对象并分配唯一 ID。
5. 如果目标对象还活着：
   - 立刻执行 `o._purpose(obj)`；
   - 把自己放进 `obj._buffs`；
   - 如果 `duration > 0`，就创建计时器，到时调用 `o:rollback()`。

也就是说：

- xlik Buff 是“创建即生效”；
- 生效的同时就把“如何回滚”保存好了；
- 所以它天然适合做临时属性、临时状态、临时控制。

## 3.3 Buff 的销毁流程

`rollback()` 是统一出口，流程是：

1. 检查当前 Buff 是否还在运行；
2. 调用 `_rollback(o)` 撤销效果；
3. 从 `o._buffs` 中删除自己；
4. 销毁持续时间计时器；
5. 把 `_running` 设为 `false`；
6. 最后 `class.destroy(self)`。

这套结构非常关键，因为它保证了：

- Buff 的应用逻辑和撤销逻辑是配对的；
- 到期、手动清除、对象析构三条路径都能走同一套回滚；
- 不容易留下“加上去了但忘了减回来”的脏状态。

## 3.4 Buff 的查询与清理

xlik 给了四组非常实用的运行时接口：

- `BuffCatch(object, filter)`：抓取 Buff 列表。
- `BuffOne(object, filter)`：抓取一个 Buff。
- `BuffHas(object, key)`：判断某个 key 是否存在。
- `BuffClear(object, filter)`：按条件批量清除。

过滤条件支持：

- `key`
- `name`
- `signal`
- `forward`
- `limit`
- 自定义 `filter(enumBuff)`

这意味着 xlik 的 Buff 不是“只能挂和摘”，而是支持业务层精确管理：

- 清掉所有 `stun`
- 只清除某个来源的增益
- 只找最近一个同 key Buff
- 只找 `down` 类负面状态

这比你当前工程里只有 `_buffbar = {}` 的方式强很多。

## 3.5 xlik 的关键设计：Buff 不只是控制，也能包装临时属性变化

`library/class/vast/_vast.lua` 是理解 xlik Buff 价值的关键文件。

在 xlik 里，很多对象属性修改都走：

```lua
object:set(name, variety, duration, domain)
```

当 `duration <= 0` 时，直接改属性。

当 `duration > 0` 时，不直接留下一个“裸定时器”，而是自动转成一个 Buff：

- `purpose`：把动态变化值加上去；
- `rollback`：到期后把动态值减回去；
- `description`：自动生成“变化多少、持续多久”的文本；
- `signal`：根据正负变化和属性是否是反属性，自动判断是 `up` 还是 `down`。

这一层设计带来的收益非常大：

1. 临时属性和控制状态使用的是同一套系统。
2. UI 不需要区分“这是攻击加成”还是“这是眩晕”，都能显示为 Buff。
3. 清除 Buff 时，属性也会跟着回滚。
4. 所有临时变化都有统一的持续时间管理。

这也是你当前项目最值得学习的部分。

## 3.6 xlik 如何实现“状态叠加而不是互相打架”

xlik 没有把“眩晕/沉默/无敌/隐身”直接写死在 Buff 对象里，而是通过：

- `library/common/superposition.lua`
- `library/class/vast/unit.lua`

实现了一个“叠加态计数器”。

例如：

- `superposition.plus(unit, "stun")`
- `superposition.minus(unit, "stun")`
- `superposition.is(unit, "stun")`

其规则不是简单布尔值，而是“计数穿越临界点时触发上下钩子”：

- 从 `0 -> 1` 时执行 `up`
- 从 `1 -> 0` 时执行 `down`
- `2 -> 3` 或 `3 -> 2` 不重复执行钩子

这能解决一个很常见的问题：

> 两个不同来源同时给单位挂眩晕，第一个结束时不能直接解除眩晕，必须等最后一个也结束。

xlik 的做法正是为了解决这个问题。

## 3.7 xlik 的控制类 Buff 是怎么写的

典型文件：

- `library/ability/stun.lua`
- `library/ability/silent.lua`
- `library/ability/unArm.lua`
- `library/ability/invisible.lua`
- `library/ability/invulnerable.lua`

这些文件的套路几乎一致：

1. 检查目标是否合法；
2. 算持续时间、概率、抗性等；
3. 创建 Buff；
4. `purpose` 中：
   - 挂特效；
   - `superposition.plus(...)`；
   - 必要时附带 `pause`、`noAttack` 等附加状态；
5. `rollback` 中：
   - 卸特效；
   - `superposition.minus(...)`。

例如 `stun`：

- `superposition.plus(buffObj, "stun")`
- `superposition.plus(buffObj, "pause")`

例如 `unArm`：

- `superposition.plus(buffObj, "unArm")`
- `superposition.plus(buffObj, "noAttack")`

例如 `invulnerable`：

- `superposition.plus(buffObj, "invulnerable")`

而真正对 Warcraft 原生单位做事的，是 `superposition.config(UnitClass, key, up, down)` 中注册的行为：

- `pause` 会调用 `PauseUnit`
- `noAttack` 会调用 `DZ_UnitDisableAttack`
- `invulnerable` 会添加/移除原生无敌技能
- `invisible` 会添加/移除原生隐身技能

所以 xlik 的控制系统分成两层：

- Buff 层：管理生命周期；
- Superposition 层：管理状态叠加和原生副作用。

这是非常成熟的拆分。

## 3.8 xlik Buff 系统实际能实现什么

综合源码和示例，xlik 的 Buff 系统至少能实现：

1. 常规正负面 Buff：
   - 增益
   - 减益
   - 持续伤害/持续治疗
   - 临时属性强化/削弱

2. 硬控制与软控制：
   - 眩晕
   - 沉默
   - 缴械
   - 暂停
   - 禁止攻击

3. 特殊状态：
   - 隐身
   - 无敌
   - 反隐相关配合

4. 可叠层 Buff：
   - 示例 `demo.lua` 里的“剑之勇气”会根据血量损失重建层数 Buff；
   - 图标中央还可以显示层数文字。

5. 可查询、可定向移除的 Buff：
   - 按 `key`
   - 按 `name`
   - 按 `signal`
   - 按自定义过滤器

6. 自动化属性 Buff：
   - 任意属性临时变化都能被统一收口进 Buff。

7. UI 可展示 Buff：
   - 名称
   - 图标
   - 描述
   - 可见性
   - 图标中央数字/文字
   - 剩余时间

---

## 4. xlik Buff UI 是怎么组织的

## 4.1 我能直接确认的事实

以下内容可以直接从源码确认：

### 4.1.1 Buff UI 使用的是 UI Kit 体系

`assets_ui("xlik_buff")` 说明 Buff UI 被当成一个独立套件装载。

而 `luaAssets.go` 的 `asUI()` 说明 UI Kit 的结构是：

- `war3mapUI/<kit>/main.lua`
- `war3mapUI/<kit>/main.fdf` 可选
- `war3mapUI/<kit>/assets/*`

并且会被打包到地图资源中。

### 4.1.2 UI Kit 的运行时入口是 `UIKit(kit)`

`library/class/meta/uiKit.lua` 表明每个 Kit 都会得到一个 `UIKit` 对象，并有两个生命周期：

- `onSetup()`
- `onStart()`

这说明 `xlik_buff` 不会是散落在各处的零碎 UI 代码，而是一个自成一体的 Buff 面板模块。

### 4.1.3 Buff 对象本身就带 UI 元数据

`library/class/meta/buff.lua` 直接暴露了：

- `icon()`
- `description()`
- `text()`
- `visible()`
- `name()`

这说明 xlik 设计 Buff 时，已经把“逻辑”和“展示”打通了。

### 4.1.4 图标资源是预先声明的

`exe/lib/embeds/new/assets/image_buff.lua` 声明了一批 Buff 图标资源。

`exe/lib/embeds/new/scripts/globals/setup/txtAttribute.lua` 又通过 `attribute.conf(...)` 给很多属性/状态配置了默认图标：

- `stun`
- `silent`
- `unArm`
- `invisible`
- `invulnerable`
- 各类属性图标
- 各类抗性图标

这意味着 xlik 的 Buff UI 不是靠“临时写死字符串路径”来显示图标，而是有一套统一的图标来源。

### 4.1.5 Tooltip 是通用 UI 组件，而不是 Buff 专用硬编码

`library/class/ui/tooltips.lua` 提供了一个通用提示框 `UITooltips`，支持：

- 图标行
- 文本行
- 进度条
- padding
- 对齐

所以 Buff UI 很可能不是自己再发明一套 tooltip，而是复用这个通用提示框。

## 4.2 当前 Reference 里缺失的关键信息

当前 `Reference/xlik-jade-main` 中，没有找到：

- `assets/war3mapUI/xlik_buff/main.lua`
- `assets/war3mapUI/xlik_buff/main.fdf`

也就是说：

> Buff Kit 的具体布局代码、刷新逻辑、槽位排列方式，在你当前提供的 Reference 里并不完整。

因此下面关于“xlik_buff 具体怎么画出来”的部分，我只能做基于现有装载机制的推断，不能伪装成我已经看到了完整源码。

## 4.3 基于源码可以高可信推断出的 UI 结构

虽然具体 Kit 源码缺失，但根据 `UIKit`、`Buff` 元数据、`UITooltips`、`assets_ui` 装载规则，可以高可信地推断：

1. `xlik_buff` 是一个独立 Kit。
2. 它一定会在 `main.lua` 中实例化 `UIKit("xlik_buff")`。
3. 它一定会订阅某个“当前观察单位/当前选中单位”的变化。
4. 它一定会遍历该单位身上的 Buff 列表。
5. 对于每个可见 Buff：
   - 取 `buff:icon()` 显示图标；
   - 取 `buff:text()` 显示中央文字或层数；
   - 取 `buff:description()` 作为 tooltip 内容；
   - 可能结合 `buff:remain()` / `buff:duration()` 画剩余时间。
6. `visible()` 的存在基本就是给 UI 做过滤用的。

## 4.4 xlik Buff UI 的设计意图

即使没有完整 Kit 源码，xlik 这套设计意图已经很清楚：

1. Buff UI 不是直接读原生魔兽 Buff 面板，而是读框架自己的 Buff 对象。
2. Buff UI 不是只显示图标，而是展示：
   - 图标
   - 名称
   - 描述
   - 层数/强调文字
   - 持续时间
3. Buff UI 与 Buff 逻辑是事件驱动关系，而不是死轮询硬编码。

这也是你当前项目最值得借鉴的 UI 思路。

---

## 5. xlik 源码里值得注意的几个细节

## 5.1 `signal` 赋值处看起来像源码笔误

`library/class/meta/buff.lua` 中有一段：

```lua
if (type(params.signal) == "table") then
    p._signal = params._signal
end
```

但从文档和调用方看，`signal` 明显是字符串：

- `buffSignal.up`
- `buffSignal.down`

所以这里大概率应该是：

```lua
if (type(params.signal) == "string") then
    p._signal = params.signal
end
```

也就是说：

> 如果你要仿照 xlik 设计，理念可以学，但不要把这个细节原样照抄。

## 5.2 Buff UI 资源是完整体系的一部分，而不是 Buff 自己随手拼出来的

xlik 的图标、属性名、抗性图标、tooltip 组件、UIKit 生命周期，都是统一设计的。

这意味着：

> xlik 的 Buff UI 强，不是因为 Buff.lua 一个人厉害，而是因为它背后有完整的资源与 UI 体系支撑。

你当前项目也应该按这个思路来做，而不是把所有显示逻辑塞回 `Code/Core/Entity/Buff.lua`。

---

## 6. 结合你当前项目看：哪些地方已经像 xlik，哪些地方还差很多

## 6.1 你当前项目已经具备的基础

### 6.1.1 已有 Buff 实体雏形

`Code/Core/Entity/Buff.lua` 已经有：

- `BuffType`
- `Buff.new`
- `Buff.add`
- `Buff.remove`
- `Buff.getRemainTime`
- `Buff.getDurationTime`
- `Buff.onAdd/onUpdate/onRemove`
- interval Buff tick
- 负面 Buff 受“意志”影响时长

所以你不是从零开始。

### 6.1.2 已有非常强的属性系统

`Code/Logic/Define/Attribute.lua` + `Code/FrameWork/GameSetting/Attribute.lua` 已经做了：

- `Attr.define`
- `Unit.setAttr`
- `Attr.reward`
- 动态属性联动
- 基础/附加/总属性分层

这对临时属性 Buff 极其重要。

一句话：

> 你当前项目做“xlik 风格属性 Buff”的最佳落点，不是另起一套属性系统，而是把 Buff 接到现有 `Unit.setAttr` 上。

### 6.1.3 已有可靠 Timer 和 Event

`Code/FrameWork/Manager/Timer.lua` 足够承担：

- 到期 Buff
- 周期 Buff
- 剩余时间查询
- 暂停/恢复/重排

`Code/FrameWork/Manager/Event.lua` 足够承担：

- Buff 生命周期广播
- UI 刷新事件
- 业务监听

### 6.1.4 已有可用的 UI 框架

当前项目有：

- `Component`
- `Theme`
- `Style`
- `Frame`
- `Panel`
- `Texture`
- `Text`
- `TextArea`
- `Button`
- `Watcher`
- `Tween`

而且 `Point.lua` 已在 2026-03-22 改成 32+32 位定点打包实现，所以之前“Point 不适合 UI 小数坐标”的老风险已经被专项修复。

这表示：

> 你完全可以直接在当前工程里做一个 BuffBar，而不需要照搬 xlik 的 UIKit 体系。

## 6.2 你当前项目的明显缺口

### 6.2.1 Buff 模块目前基本还没真正接入业务

全文检索结果表明，当前工程里：

- `Buff.new`
- `Buff.add`
- `Buff.remove`
- `Buff.onAdd`

基本都没有在业务代码里真正使用。

也就是说当前 `Code/Core/Entity/Buff.lua` 更像“预备好的底层模块”，还不是一条跑通的 Buff 链路。

### 6.2.2 当前 Buff 只有列表，没有像 xlik 那样完整的查询层

当前实现里只有：

- `target._buffbar = {}`

但没有：

- `Buff.catch`
- `Buff.one`
- `Buff.has`
- `Buff.clear`
- 按 `key` / `name` / `signal` / `source` 查询

所以业务层以后如果要做：

- 驱散
- 同 key 刷新
- 同类 Buff 覆盖
- 负面状态净化

会非常不方便。

### 6.2.3 当前缺少“状态叠加层”

你当前项目还没有一个类似 xlik `superposition` 的“计数式状态层”。

所以像：

- 两个眩晕同时存在
- 一个结束了但另一个还在
- 两个不同来源都使单位不能攻击

这类情况，当前实现很容易互相打架。

### 6.2.4 当前 Buff 没有与属性系统统一

现在 Buff 的 `add_rule/remove_rule/update_rule` 是存在的，但没有现成辅助层把：

- 临时攻击增加
- 临时移速降低
- 临时护甲改变

这种需求自动封装成 Buff。

而 xlik 的强点正是这一步。

### 6.2.5 当前还没有 Buff UI 业务层

你有 UI 框架，但没有：

- 当前观察单位管理器
- BuffBar 组件
- BuffTooltip 组件
- Buff 与 UI 的绑定层

所以当前项目不是“不能做 Buff UI”，而是“UI 框架有，Buff 展示层还没建”。

### 6.2.6 当前实现里还有两个细节风险

1. `Code/Core/Entity/Buff.lua` 声明了 `__buffs = {}` 强引用表，但当前代码没有真正把 Buff 实例放进去或移出来，这个字段目前没有发挥作用。
2. 当前 Buff 没有看到与“单位删除/死亡清理”完整联动的逻辑，后续需要补齐统一清理出口。

---

## 7. 如果仿照 xlik，我建议你当前项目这样实现

## 7.1 总原则：学结构，不要硬搬实现

最应该学习的是 xlik 的结构分层：

1. Buff 对象层：负责生命周期。
2. 状态叠加层：负责布尔/控制状态的临界切换。
3. 属性层：负责数值变更。
4. UI 层：负责图标、层数、提示、剩余时间。

不建议原样照搬的部分：

- xlik 的 Meta/Vast 体系本身；
- xlik UIKit Kit 体系；
- xlik 源码里 `signal` 那段明显可疑的赋值细节。

## 7.2 我建议你当前项目的分层改造

### 第一层：强化 `Code/Core/Entity/Buff.lua`

建议保留现有 `BuffType + Buff实例` 结构，但新增这些字段与能力：

- `key`
- `name`
- `signal`
- `icon`
- `description`
- `visible`
- `text`
- `stack`
- `tags`
- `refresh_rule`
- `apply_rule`
- `rollback_rule`
- `source`
- `target`

并补上以下接口：

- `Buff.catch(target, filter)`
- `Buff.one(target, filter)`
- `Buff.has(target, key_or_filter)`
- `Buff.clear(target, filter)`
- `Buff.refresh(buff, new_duration)`
- `Buff.setText(buff, text)`

这里的目标就是把当前 `_buffbar` 从“裸数组”升级成“可管理的 Buff 容器”。

### 第二层：加一个“状态叠加层”

建议新增一个类似 `superposition` 的模块，例如：

- `Code/Core/Entity/UnitState.lua`

职责：

- `UnitState.plus(unit, "stun")`
- `UnitState.minus(unit, "stun")`
- `UnitState.has(unit, "stun")`
- `UnitState.config("stun", on_enter, on_leave)`

这样做的收益：

1. 多来源相同状态不会互相覆盖。
2. 眩晕、沉默、缴械、不可攻击、暂停等都能统一处理。
3. Buff 只负责“加一个状态”和“减一个状态”，不直接关心状态重叠问题。

### 第三层：做一个“属性 Buff 辅助层”

建议新增辅助方法，例如：

```lua
Buff.addAttr(target, source, {
    key = "attack_up",
    attr_name = "攻击",
    delta = 30,
    duration = 5,
    signal = "up",
    icon = "...",
    description = function(buff) ... end,
})
```

内部逻辑不要直接改 `unit["攻击"]`，而应走：

- `Attr.getBonusName(attr_name)`
- `Unit.setAttr(unit, real_attr_name, delta, "add")`

到期时再做反向回滚。

这样你就能把 xlik `Vast:set(..., duration)` 那种体验，在当前项目里用现有属性系统重建出来。

### 第四层：把控制类 Buff 建成模板化能力

建议做一个 `Code/Logic/Define/Buff.lua` 或等价模块，集中定义 Buff 模板，比如：

- 眩晕
- 沉默
- 缴械
- 无敌
- 隐身
- 中毒
- 灼烧
- 护盾
- 攻击提升
- 移速降低

每个模板统一包含：

- 元数据
- 应用逻辑
- 回滚逻辑
- 是否可叠加
- 是否刷新持续时间
- 是否可显示

这样业务层就不需要每次都手写 `Buff.new + Buff.add`。

---

## 8. 我建议的具体落地接口

下面不是要你现在立刻照抄的代码，而是“当前工程最适合长出来的接口形态”。

## 8.1 BuffType 建议形态

```lua
local Slow = Buff.buffType("减速", {
    key = "slow",
    signal = "down",
    icon = "war3mapImported\\buff_slow.blp",
    description = function(buff)
        return {
            "移动速度降低 30%",
            string.format("剩余 %.1f 秒", Buff.getRemainTime(buff)),
        }
    end,
    duration = 5.0,
    visible = true,
    stack_mode = "refresh",
    apply_rule = function(buff)
        Unit.setAttr(buff.target, Attr.getBonusName("移动速度"), -30, "add")
    end,
    rollback_rule = function(buff)
        Unit.setAttr(buff.target, Attr.getBonusName("移动速度"), 30, "add")
    end,
})
```

## 8.2 控制类 Buff 建议形态

```lua
local Stun = Buff.buffType("眩晕", {
    key = "stun",
    signal = "down",
    icon = "war3mapImported\\buff_stun.blp",
    duration = 2.0,
    visible = true,
    apply_rule = function(buff)
        UnitState.plus(buff.target, "stun")
        UnitState.plus(buff.target, "pause")
    end,
    rollback_rule = function(buff)
        UnitState.minus(buff.target, "pause")
        UnitState.minus(buff.target, "stun")
    end,
})
```

## 8.3 周期 Buff 建议形态

```lua
local Burn = Buff.buffType("灼烧", {
    key = "burn",
    signal = "down",
    icon = "war3mapImported\\buff_burn.blp",
    duration = 6.0,
    interval = 1.0,
    visible = true,
    update_rule = function(buff)
        -- 这里走你现有的伤害流程
        -- Damage.apply(buff.origin, buff.target, 10, ...)
    end,
})
```

## 8.4 统一使用入口建议

```lua
local buff = Buff.new(Stun, caster)
Buff.add(buff, target)
```

再往上可以继续封装：

```lua
Buff.cast(Stun, caster, target)
```

---

## 9. Buff UI 在你当前项目里的推荐做法

## 9.1 不建议照搬 xlik UIKit，建议直接用你现有 UI 框架

原因很简单：

1. 你已经有 `Code/Core/UI/*`；
2. 你项目的 UI 技术栈和 xlik 不一样；
3. 直接复刻 `war3mapUI/xlik_buff` 对你当前工程来说迁移成本更高。

所以推荐方案是：

> 学 xlik 的“数据驱动思路”，但 UI 直接用你当前的 `Component + Panel + Text + Button + TextArea + Watcher` 做。

## 9.2 BuffBar 推荐组成

建议做一个独立模块，例如：

- `Code/Logic/UI/BuffBar.lua`

它至少负责：

1. 维护“当前观察单位”。
2. 读取该单位的 Buff 列表。
3. 渲染 8~16 个 Buff 槽位。
4. 每个槽位展示：
   - 图标
   - 层数/文字
   - 剩余时间
5. 鼠标移入时显示 Tooltip。

## 9.3 Slot 结构建议

一个 Buff Slot 至少需要：

- `Panel`：底板
- `Texture/Panel`：图标
- `Text`：层数
- `Text`：剩余时间
- `Button` 或可追踪 frame：负责 hover/click

Tooltip 可以单独做一个浮层：

- `Panel`：背景
- `TextArea`：多行说明

## 9.4 UI 刷新不要靠全量轮询，建议事件驱动 + 小频率时钟

推荐做法：

1. `Buff.onAdd / onRemove / onUpdate` 触发结构刷新。
2. 仅对“当前观察单位”的 Buff 面板做剩余时间文本更新。
3. 剩余时间这种变化快的字段，可以用一个低频本地 Timer 或 UI Tick 做刷新，例如 `0.1s` 一次。

这样比每帧全量重绘更稳。

## 9.5 当前项目还缺一个“观察目标服务”

因为当前仓库里我还没有找到现成的“当前选中单位 UI 服务”，所以第一版建议不要一上来就和“玩家当前选中单位”深耦合。

更稳的落地顺序是：

1. 第一版 BuffBar 先支持手动绑定某个单位：
   - `BuffBar.bind(unit)`
2. 第二版再接入“当前选中单位/当前主控英雄”的同步服务。
3. 第三版如果需要，再做“单位头顶 Buff 图标”：
   - 这时可以利用你当前 `Frame.bindToUnit(...)`。

---

## 10. 推荐实施顺序

## 阶段 1：先把 Buff 逻辑层跑通

目标：

- 补齐 `Buff.catch/one/has/clear`
- 补齐 `key/signal/icon/description/visible/text`
- 补齐 `refresh` 与手动清理
- 让两个示例 Buff 能稳定工作：
  - 眩晕
  - 临时攻击提升

## 阶段 2：接上状态叠加层

目标：

- 实现 `UnitState.plus/minus/has`
- 用它承接 `stun/silent/unArm/pause/noAttack`
- 验证“多来源控制状态不冲突”

## 阶段 3：把属性 Buff 和现有属性系统打通

目标：

- 所有临时属性变化都走 `Unit.setAttr`
- 到期能完全回滚
- 负面 Buff 持续时间继续受“意志”影响

## 阶段 4：做 BuffBar 与 Tooltip

目标：

- 能显示图标
- 能显示层数
- 能显示剩余时间
- 能显示描述

## 阶段 5：再补高级策略

例如：

- 同 key 覆盖/叠加/刷新
- 驱散与净化
- 免疫类过滤
- 抗性缩短时长
- 优先级排序
- 分类显示（增益/减益）

---

## 11. 最值得直接抄走的 xlik 设计思想

如果要把 xlik 研究压缩成最有价值的几点，我认为是这五条：

1. Buff 不是状态字典，而是生命周期对象。
2. Buff 一定要有“应用”和“回滚”两个对称出口。
3. 临时属性变化也应该纳入 Buff，而不是散落成裸 Timer。
4. 控制状态最好通过“叠加计数层”处理，而不是直接布尔开关。
5. UI 不直接读原生面板，而是读框架自己的 Buff 数据。

---

## 12. 结合你当前项目的最终建议

一句话总结：

> 你当前项目最适合走的路线，不是把 xlik 整套搬过来，而是把 xlik 的 Buff 设计思想，嫁接到你现有的 `Buff + Attr + Timer + Event + UI` 体系上。

更具体一点：

- 逻辑层学 xlik：
  - 生命周期
  - 回滚
  - 查询
  - 状态叠加
  - 临时属性 Buff 化
- UI 层用你自己的：
  - `Component`
  - `Panel`
  - `Text`
  - `TextArea`
  - `Button`
  - `Watcher`

如果按这个方向做，你最终得到的会是：

1. 比当前项目更完整的 Buff 系统；
2. 比直接照抄 xlik 更贴合你工程的实现；
3. 一套能继续扩展驱散、抗性、免疫、分类显示、头顶图标、选择目标 HUD 的长期架构。

---

## 13. 本次研究的边界说明

为了避免误导，这里明确写出本次研究的边界：

1. 我已经完整看到了 xlik 的运行时 Buff 核心、状态叠加层、属性图标配置、Tooltip 组件、UI Kit 装载机制。
2. 我没有在当前 `Reference` 目录中找到 `xlik_buff` 套件自己的 `main.lua/main.fdf` 源文件，所以本文对“Buff UI 的具体布局代码”没有伪造源码级结论，而是按现有证据做了高可信推断。
3. 我当前对你项目的建议是“架构落地方案”，不是已经替你把 Buff 系统代码全部实现完成。

如果你下一步要继续推进，最自然的延续任务就是：

- 先把 `Code/Core/Entity/Buff.lua` 升级成真正可查询、可回滚、可扩展的 Buff 核心；
- 再做一个最小可用 BuffBar。
