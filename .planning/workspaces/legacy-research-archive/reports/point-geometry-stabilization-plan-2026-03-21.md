# Point Geometry Stabilization Plan

## 1. 问题快照

当前 `Code/FrameWork/Manager/Point.lua` 的实现本质上是在用 Cantor 配对思路，把两个坐标压成一个 Lua number：

- `Point.new(x, y)` 先算 `s = x + y`
- 再返回 `(s * (s + 1)) // 2 + y`
- `Point.get(point)` 再通过 `sqrt` 和 `floor` 反推

这个模型对“非负整数二元组”才成立。  
但当前 UI 主链路里传入的不是这个域：

- 普通 UI 位置和尺寸大量使用小数
- 相对偏移和文本阴影天然会出现负值
- 小数和负值都会进入 `Frame.position`、`Frame.size`、`Text.shadow_off`、`Tween position/size`

本地真实样本已经证明它会失真：

| 输入 | 当前输出 |
| --- | --- |
| `Point(3, 7)` | `(3, 7)` |
| `Point(0.3, 0.15)` | `(-0.15, 0.15)` |
| `Point(0.2, 0.03)` | `(-0.03, 0.03)` |
| `Point(0.018, 0.018)` | `(-0.018, 0.018)` |
| `Point(-1, 2)` | `(2, 0)` |
| `Point(0, -0.01)` | `(-nan(ind), -nan(ind))` |

这说明它不是“精度差一点”，而是数学域就错了。

## 2. 根因判断

### 2.1 当前算法只适合 `N x N`

Cantor pairing 的前提是两个输入都属于非负整数集合。  
一旦喂入：

- 小数：`//`、`floor`、`sqrt` 会把信息折叠掉
- 负值：编码后可能让 `8 * point + 1 < 0`，直接触发 `sqrt` 的非法域

所以当前 `Point.lua` 不是“实现里少了一个 if”，而是表示方式本身不适合 UI 几何。

### 2.2 这不是局部 bug，而是主链路 bug

当前受影响链路至少包括：

- `Code/Core/UI/Frame.lua`
  - `Frame.__init__`
  - `frame.position`
  - `frame.size`
  - `width/height` setter 对 size 缓存的回写
- `Code/Core/UI/Text.lua`
  - `shadow_off`
- `Code/Core/UI/Tween.lua`
  - `position`
  - `size`
- `Code/Core/UI/Theme.lua`
  - runtime position replay

所以 Point 必须按“基础值类型修复”来做，而不是只在 `Point.lua` 内补一个公式。

## 3. 方案对比

### 方案 A：继续保留“Point 是 number”，换成更聪明的数值打包

可选思路：

- ZigZag + 配对函数，先支持负整数
- 再叠加 fixed-point，把小数乘上倍率后转整数
- 或者做 53-bit 安全整数范围内的手工位打包

优点：

- 调用面看起来最像现在
- 如果压缩成功，单值缓存和传递会继续很轻

缺点：

- 仍然是“近似表示”，不是精确表示
- 必须引入固定倍率、可表示范围、溢出边界
- 一旦 UI 以后出现更大范围、更细粒度或 3D/相机相关坐标，又会重新踩边界
- 这会把一个“值对象问题”变成“量化策略问题”

结论：

- 不推荐作为 live UI geometry 的长期方案
- 只适合“明确受限、明确量化”的序列化场景

### 方案 B：把 Point 从 UI 里完全移除，只保留 `x/y/width/height`

优点：

- 语义最直
- 不再需要 Point 容器
- 最终 native API 本来也只吃数字

缺点：

- 会扩大 API 变动面
- 现有 `Point(x, y)` 写法、文档、补间、属性缓存都要一起改
- 这轮修复的 blast radius 会偏大

结论：

- 可以作为长期演进方向
- 但不是当前最稳、最小风险的第一步

### 方案 C：推荐方案，Point 改成“精确点对象”，热路径再用标量 helper 优化

核心思想：

- `Point` 不再负责压缩
- `Point` 只负责表达“一个二维几何值”
- 真正和 native 交互时，再把它解成 `x, y`
- 性能问题交给 `Frame/Text/Tween` 的热路径 helper 解决

优点：

- 语义正确
- 对当前作者写法最友好，`Point(x, y)` 还能保留
- 迁移面集中在 UI 核心模块
- 能把“正确性”和“热路径优化”两个问题拆开处理

缺点：

- 如果直接在 Tween 每 tick 新建 Point，会增加 table 分配
- 需要同时补一层标量 helper，不能只改 `Point.lua`

结论：

- 这是当前最平衡、最稳的路线
- 推荐作为正式执行方案

## 4. 推荐契约

### 4.1 `Point.lua` 的新角色

`Point` 应该从“压缩后的 number”变成“精确二维值对象”。

推荐最小契约：

- `Point(x, y)` / `Point.new(x, y)`
  - 返回一个精确 Point 对象
- `Point.get(point)`
  - 返回 `x, y`
- `Point.is(value)`
  - 判断是否为 Point 或可接受的 point-like 输入
- `Point.copy(point)`
  - 返回一个拷贝
- `Point.from(value)`
  - 统一把 point-like 输入转成 Point

建议 Point 对象本身保存：

- `x`
- `y`

不建议继续把“压缩 number”作为 Point 的公开真身。

### 4.2 `Point.get(...)` 的兼容策略

推荐让 `Point.get(...)` 支持这几类输入：

- 正式 Point 对象
- `{ x = ..., y = ... }`
- `{ [1] = ..., [2] = ... }`

对 `number` 有两种做法：

1. 保留临时兼容：
   - 只作为迁移期兜底
   - 最好单独走 `Point.getLegacy(number)`，不要和正式精确契约混在一起
2. 直接 fail fast：
   - 更干净
   - 但要先确认没有隐藏调用面

推荐折中：

- 第一轮实现保留受限 legacy decode
- 第二轮 repo sweep 完成后再考虑收紧

但必须明确：

- 旧算法已经把很多小数/负值信息破坏掉了
- 如果外部真的持久化了那些坏掉的 number，后面无法“无损恢复”

## 5. 周边模块的联动改造

### 5.1 `Frame.lua`

建议新增标量 helper：

- `Frame.setPositionXY(frame, x, y)`
- `Frame.setSizeWH(frame, width, height)`

然后做这些调整：

- `frame.position = point` 仍然保留
  - setter 内部通过 `Point.get(point)` 取 `x, y`
  - 再调用 `MHFrame_SetAbsolutePoint(...)`
- `frame.size = point` 同理
- `width` / `height` setter 不再重新压缩 number
  - 改成更新精确 size cache

这样外部作者还能写：

```lua
frame.position = Point(0.1, 0.2)
frame.size = Point(0.3, 0.15)
```

而内部热路径可以写：

```lua
frame:setPositionXY(x, y)
frame:setSizeWH(width, height)
```

### 5.2 `Text.lua`

建议新增：

- `Text.setShadowOffsetXY(text, x, y)`

然后 `shadow_off` 属性继续接受 Point-like 输入，但内部尽量走标量 helper。

### 5.3 `Tween.lua`

这是最需要同步改的地方。

如果 Point 改成对象，而 Tween 仍然每 tick 做：

```lua
frame.position = Point(value[1], value[2])
```

就会引入频繁分配。

推荐改成：

- `position` tween 直接调用 `frame:setPositionXY(...)`
- `size` tween 直接调用 `frame:setSizeWH(...)`

这样 Point 可以继续作为 authoring 层容器，但不再成为热路径分配负担。

### 5.4 `Theme.lua`

Theme runtime replay 里当前也会重新构造 Point。  
建议一并改成：

- 有 `size` 时优先走 `frame.size = ...` 或 `setSizeWH(...)`
- 有 `x/y` 时走 `frame:setPositionXY(x, y)`

这样 Theme 的 runtime replay 也不会再绑定旧的 numeric Point 语义。

## 6. 为什么推荐“对象 + helper”而不是“只修 Point.lua”

因为这次问题有两层：

1. 表示层错误
   - 当前 number packing 失真
2. 热路径策略问题
   - 如果直接改成 table Point，但不改 Tween/Theme，热路径会多出很多对象分配

所以稳妥的修法不是只动 `Point.lua`，而是：

- `Point.lua` 负责正确
- `Frame/Text/Tween/Theme` 负责高频路径优化

这两层拆开之后，逻辑会更清晰，后续也更容易扩展。

## 7. 回归验证矩阵

至少要补这些测试：

### 7.1 真实 Point round-trip

- `Point(3, 7)` -> `(3, 7)`
- `Point(0.3, 0.15)` -> `(0.3, 0.15)`
- `Point(0.018, 0.018)` -> `(0.018, 0.018)`
- `Point(-1, 2)` -> `(-1, 2)`
- `Point(0, -0.01)` -> `(0, -0.01)`

### 7.2 Frame 几何落地

用 Jass stub 观察：

- `frame.position = Point(...)` 是否把正确 `x, y` 传给 `MHFrame_SetAbsolutePoint`
- `frame.size = Point(...)` 是否把正确 `width, height` 传给 `MHFrame_SetSize`
- `width/height` setter 是否还能维护一致的 size cache

### 7.3 Text 阴影偏移

- `text.shadow_off = Point(-0.01, 0.02)` 是否把原值正确透传给 native 层

### 7.4 Tween

- 中点帧
- 终点帧
- `position`
- `size`

要验证它们在不依赖 lossy Point packing 的前提下仍然成立。

## 8. 执行顺序建议

### 第一阶段：值类型修复

- 重写 `Point.lua`
- 建立 Point exact contract
- 决定 legacy compatibility 的边界

### 第二阶段：热路径跟进

- `Frame.setPositionXY`
- `Frame.setSizeWH`
- `Text.setShadowOffsetXY`
- `Tween` 改走标量 helper
- Theme runtime replay 改走标量 helper

### 第三阶段：验证补强

- 扩展 `.planning/tools/ui_framework_remaining_smoke.lua`
- 或新增单独的 `point_regression.lua`
- 把真实 Point decimal / negative case 纳入正式验证

### 第四阶段：收口

- 如果 compatibility fallback 只是过渡用途，再决定是否移除
- 更新 authoring 文档
- 再回头刷新 UI framework audit 中关于 geometry 的结论

## 9. 风险与规避

### 风险 1：对象 Point 带来更多 GC

规避：

- 不在 Tween 热路径里每 tick 新建 Point
- 用 `setPositionXY` / `setSizeWH` 之类的标量 helper 吃掉高频路径

### 风险 2：存在隐藏的“Point 必须是 number”契约

规避：

- 第一轮保留受限 numeric compatibility
- 在实现前后做 repo sweep
- 如果发现隐藏调用面，再定向清理

### 风险 3：旧坏数据无法恢复

规避：

- 明确区分“旧 number payload”和“新 exact Point”
- 不承诺自动修复已经失真的持久化值

## 10. 最终建议

不建议继续沿着“怎么把两个坐标更聪明地压进一个 number”这条路修。  
这条路就算能暂时补上，也会把 Point 继续绑在量化精度、取值范围、边界溢出这些长期风险上。

推荐正式方案是：

1. `Point` 改成精确二维值对象
2. `Point(x, y)` 和 `Point.get(...)` 继续保留，降低作者迁移成本
3. `Frame` / `Text` / `Tween` / Theme runtime replay 补标量 helper，专门解决热路径分配问题
4. 把真实 Point decimal / negative regression 纳入 smoke

这条路线的优点是：

- correctness 和 performance 分开治理
- blast radius 可控
- 作者写法不需要大改
- 后续要不要进一步弱化 Point，都还有演进空间
