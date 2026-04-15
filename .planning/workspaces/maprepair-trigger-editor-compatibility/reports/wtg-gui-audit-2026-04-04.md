# 修补后 `war3map.wtg` GUI 审计报告

## 范围
- 审计目标：`D:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\chuzhang V2 mod2.851_repaired.w3x`
- 直接对照文件：`D:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\chuzhang V2 mod2.851_repaired\map\war3map.wtg`
- 兼容性判定基准：YDWE 的 `fix-wtg/checker.lua`
- GUI 元数据来源：MapRepair 生成的 `repair-report.md` 中列出的基础 `TriggerData.txt` 与 `YDWE share/mpq` 元数据源

## 结论
1. 当前 repaired 地图的 `war3map.wtg` 不是“少了某个 YDWE GUI 动作/函数条目”那么简单，而是 **WTG 二进制节点布局已经写坏** 了。
2. 从 YDWE `share` 元数据覆盖角度看，没有发现“私有 GUI 语义缺失”这一类问题。MapRepair 自己的修补报告明确写着 `Recovered GUI Unmatched Private Semantics: None`。
3. 真正导致编辑器无法识别 GUI 的原因有两层：
- **主因**：`LegacyGuiBinaryCodec` 把 `childId` 写到了根节点上，导致标准编辑器读取根 ECA 时从一开始就错位。
- **次因**：`JassGuiReconstructionParser` 不能把若干常见 JASS 参数形式重新编码回 WTG GUI 参数，导致大量事件节点只能回退为 custom-text。

## 证据

### 1. 当前 repaired 输出的 WTG 在首个根节点就已失真
- 本地基线 `[war3map.wtg](D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/War3/map/war3map.wtg)` 能通过 YDWE checker。
- `[chuzhang V2 mod2.851_repaired_v47.w3x](D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/MapRepair/chuzhang%20V2%20mod2.851_repaired_v47.w3x)` 也能通过同一 checker。
- 当前 `[chuzhang V2 mod2.851_repaired.w3x](D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/MapRepair/chuzhang%20V2%20mod2.851_repaired.w3x)` 无法通过 checker。
- 当前 repaired 的首个触发器是 `SET`，首个根节点被按标准 WTG 解析时得到：
- `tp = 0`
- `name = ""`
- `enable = 1409286144`
- 这已经不是“GUI 名称没定义”，而是**节点头部字段错位**。标准 WTG 中 `enable` 只能是 `0/1`。

### 2. 回归时间点
- `repaired_v47.w3x`：`war3map.wtg` 结构可被 YDWE checker 正常读取。
- `repaired_v48.w3x`、`repaired_v49.w3x`：归档里已经没有 `war3map.wtg`。
- 当前 `repaired.w3x`：重新出现了 `war3map.wtg`，但写出的根节点布局已经不符合标准格式。
- 这说明问题不是一直存在，而是 **在 v47 之后、当前非版本号 repaired 输出之前** 引入的。

### 3. YDWE `share` 元数据不是当前主因
- MapRepair 的修补报告中：
- `[repair-report.md](D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/MapRepair/chuzhang%20V2%20mod2.851_repair_report/repair-report.md#L720)` 记录了 `569 reconstructed trigger(s) used custom-text fallback...`
- `[repair-report.md](D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/MapRepair/chuzhang%20V2%20mod2.851_repair_report/repair-report.md#L722)` 与 `[repair-report.md](D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/MapRepair/chuzhang%20V2%20mod2.851_repair_report/repair-report.md#L737)` 都记录了 `569 trigger(s) were emitted as custom-text triggers.`
- `[repair-report.md](D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/MapRepair/chuzhang%20V2%20mod2.851_repair_report/repair-report.md#L739)` 开始列出了 GUI metadata sources，其中包含基础 `TriggerData.txt` 与多个 YDWE `share/mpq` 模块。
- `[repair-report.md](D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/MapRepair/chuzhang%20V2%20mod2.851_repair_report/repair-report.md#L788)` 的 `Recovered GUI Unmatched Private Semantics` 为 `None`。
- 这组证据说明：**当前没有发现“YDWE share 里缺某个私有 GUI 语义”的证据**。

## 与 GUI 对不上条目
这里的“不对应”主要不是“函数名不存在”，而是“函数名存在，但参数表达式无法被重编码回 WTG GUI 参数”，因此事件被跳过或整体触发器退回 custom-text。

按 `RecoveredGui/*.meta.txt` 统计，当前主要失配项如下：

| 函数 | 失败次数 | 典型失败参数 | 说明 |
| --- | ---: | --- | --- |
| `TriggerRegisterPlayerChatEvent` | 118 | `Player(0)` 到 `Player(11)` | `Player(n)` 没被归一化为 GUI 预设玩家值 |
| `TriggerRegisterUnitInRangeSimple` | 115 | `gg_unit_*` | 放置单位全局变量没有被编码回合法 GUI 参数 |
| `TriggerRegisterPlayerKeyEventBJ` | 48 | `Player(n)` | 同上 |
| `TriggerRegisterEnterRectSimple` | 36 | `gg_rct_*` | 区域全局变量没有被编码回 GUI 参数 |
| `TriggerRegisterUnitEvent` | 15 | `gg_unit_*` | 放置单位句柄参数未被接受 |
| `TriggerRegisterPlayerEventEndCinematic` | 12 | `Player(n)` | 同上 |
| `TriggerRegisterPlayerEventLeave` | 12 | `Player(n)` | 同上 |
| `TriggerRegisterDestDeathInRegionEvent` | 1 | `gg_rct_*` | 区域句柄参数未被接受 |
| `TriggerRegisterTimerEventPeriodic` | 1 | `.1` | 没有前导 `0` 的实数文本未被当前数值规则接受 |
| `TriggerRegisterPlayerUnitEventSimple` | 1 | `Player(PLAYER_NEUTRAL_AGGRESSIVE)` | 玩家表达式未被归一化 |

代表性证据：
- `[565-ct2.meta.txt](D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/MapRepair/chuzhang%20V2%20mod2.851_repair_report/RecoveredGui/565-ct2.meta.txt)` 记录了 `TriggerRegisterPlayerChatEvent` 的 `Player(0..11)` 全部无法编码回 WTG。
- `[001-SET.lml](D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/MapRepair/chuzhang%20V2%20mod2.851_repair_report/RecoveredGui/001-SET.lml)` 显示 `SET` 触发器的事件本应是 `TriggerRegisterTimerEventSingle (const:5.00)`，说明逻辑级恢复本身是有内容的，但最终写回的 WTG 节点格式已经损坏。

## 根因分析

### A. `LegacyGuiBinaryCodec` 把根节点和子节点的 `childId` 语义写反了
标准 WTG 里：
- 根 ECA：没有 `childId`
- 子 ECA：才有 `childId`

但当前 MapRepair 代码里：
- `[LegacyGuiBinaryCodec.cs](D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/MapRepair/src/MapRepair.Core/Internal/Gui/LegacyGuiBinaryCodec.cs#L219)` 的 `WriteNode(...)`
- `[LegacyGuiBinaryCodec.cs](D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/MapRepair/src/MapRepair.Core/Internal/Gui/LegacyGuiBinaryCodec.cs#L224)` 在 `isRoot` 时写入 `childId`
- `[LegacyGuiBinaryCodec.cs](D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/MapRepair/src/MapRepair.Core/Internal/Gui/LegacyGuiBinaryCodec.cs#L239)` 写子块时依然传了 `isRoot: true`
- `[LegacyGuiBinaryCodec.cs](D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/MapRepair/src/MapRepair.Core/Internal/Gui/LegacyGuiBinaryCodec.cs#L269)` / `[LegacyGuiBinaryCodec.cs](D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/MapRepair/src/MapRepair.Core/Internal/Gui/LegacyGuiBinaryCodec.cs#L272)` 的读路径也同样把 `childId` 当成根节点字段读取

这套读写逻辑可以自圆其说，但**不符合外部编辑器/ YDWE / w3x2lni 约定的标准 WTG 布局**。  
它正好解释了当前 repaired 地图的首个根节点为何会被标准读取器看成：
- `tp = 0`
- `name = ""`
- `enable = 1409286144`

因为那个多写出来的根节点 `childId=0` 被标准读取器误当成了空字符串的开始。

### B. `JassGuiReconstructionParser` 的参数回写规则覆盖不够
- `[JassGuiReconstructionParser.cs](D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/MapRepair/src/MapRepair.Core/Internal/Gui/JassGuiReconstructionParser.cs#L280)` 的 `TryBuildEventNode(...)` 在 GUI 元数据已存在时，会逐个调用 `TryParseArgument(...)`。
- `[JassGuiReconstructionParser.cs](D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/MapRepair/src/MapRepair.Core/Internal/Gui/JassGuiReconstructionParser.cs#L322)` 明确把失败记录为 `could not be encoded back into WTG`。
- `[JassGuiReconstructionParser.cs](D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/MapRepair/src/MapRepair.Core/Internal/Gui/JassGuiReconstructionParser.cs#L420)` 的 `TryParseArgument(...)` 只接受：
- `udg_*` 变量
- 引号字符串
- 数字
- `'ABCD'` rawcode
- `true/false/null/全大写预设`
- 能被 GUI metadata 识别的 call node

它 **没有覆盖** 以下常见恢复输入：
- `Player(0)` / `Player(PLAYER_NEUTRAL_AGGRESSIVE)`
- `gg_unit_*`
- `gg_rct_*`
- `gg_dest_*`
- 无前导零的实数写法，比如 `.1`

所以很多事件即使在 GUI metadata 中有对应函数名，也会因为参数无法重编码而被跳过。

## 判断
- “YDWE share 里缺少 GUI 动作/函数条目”不是当前 repaired 地图 GUI 无法识别的主因。
- 当前最核心的问题是 **WTG 根节点编码格式错误**。
- 第二层问题是 **JASS 参数到 GUI 参数的归一化不足**，使得大量事件无法被恢复成可编辑 GUI 节点。

## 建议修复方向
1. 先修 `LegacyGuiBinaryCodec`：
- 根节点不要写 `childId`
- 子节点才写 `childId`
- 子块递归写入时应使用 `isRoot: false`
- 读路径也要同步调整

2. 再补 `JassGuiReconstructionParser.TryParseArgument`：
- 支持把 `Player(n)` 归一化为 GUI 玩家预设
- 识别 `gg_unit_*`、`gg_rct_*`、`gg_dest_*` 这类放置对象/区域/可破坏物全局
- 接受 `.1` 这种无前导零实数，或在进入编码前先正规化为 `0.1`

3. 修完后优先做两条回归检查：
- 当前 repaired 输出是否能通过 YDWE `fix-wtg/checker.lua`
- 当前 repaired 输出的首个根节点是否仍会被标准读取成 `name=""`
