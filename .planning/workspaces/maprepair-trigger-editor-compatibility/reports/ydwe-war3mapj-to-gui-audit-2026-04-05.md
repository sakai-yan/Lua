# YDWE `war3map.j` 到 GUI 全链路源码审计

## 审计目标
- 回答一个具体问题：`YDWE` 源码里是否存在“直接把地图中的 `war3map.j` 转回 GUI”的实现。
- 如果不存在，明确真实的 GUI 恢复链路是什么，`war3map.j` 在这条链里又扮演什么角色。
- 用源码与样例地图双重证据闭环，而不是凭印象下结论。

## 最终结论
1. `YDWE` 源码中没有发现一条“直接把 `war3map.j` 反编译成 GUI 并写回 `war3map.wtg/wct`”的实现链。
2. `YDWE` 中与 GUI 恢复直接相关的真实链路是：
   `TriggerData/TriggerStrings -> frontend_trg() -> frontend_wtg/frontend_wct -> 编辑器内部 GUI 节点名/GUIId 恢复`
3. `war3map.j` 在 `YDWE` 里的实际用途可以归为四类：
   编译保存、JASS 优化、JASS 文本/WTS 后处理、对象/资源引用扫描。
4. `fix-wtg` 的作用是“读取现有 `war3map.wtg`，发现未知 UI 名称后生成补充 GUI 元数据”，不是从 `war3map.j` 推导 GUI。
5. 样例地图实证进一步证明：对受保护/扩展较重的地图，`war3map.j` 是明显有损的信息源，无法单独恢复出编辑器里看到的完整 GUI 结构。

## 关键判断

### 1. 编辑器启动时，YDWE先装的是GUI元数据和WTG修复逻辑，不是JASS反编译器
- `share/script/ydwe_on_startup.lua:1-3` 在启动脚本最前面直接 `require "fix-wtg.init"`。
- `share/script/ydwe_on_startup.lua:214-224` 启动后打开 `virtual_mpq`、加载插件并执行 `uiloader:initialize()`。
- `share/script/fix-wtg/init.lua:35-46` 地图打开事件里执行的是 `lniloader.load(mappath)` 和 `wtgloader(mappath)`，入口是地图打开时的 `war3map.wtg` / LNI 触发器资源，不是 `war3map.j`。

这说明 YDWE 在编辑器打开地图时优先构建的是“GUI 元数据视图”和“WTG 兼容修复”，而不是“从 JASS 逆向还原 GUI”。

### 2. GUI 元数据来源是 `TriggerData.txt` / `TriggerStrings.txt`，不是 `war3map.j`
- `source/Development/Component/script/ydwe/uiloader.lua:90-99` 通过 `virtual_mpq.watch('UI\\TriggerData.txt', ...)`、`virtual_mpq.watch('UI\\TriggerStrings.txt', ...)` 向编辑器虚拟提供 GUI 元数据。
- `source/Development/Component/script/ydwe/triggerdata.lua:3-31` 会遍历 `ui` 配置里的包，把 old/new 两种 UI 定义格式合并，再输出统一的状态结构。
- `share/script/ui.lua:2-40` 读取 `share/mpq/config` 与 `config.user`，决定当前启用哪些 UI 包。
- `source/Development/Component/script/ydwe/ui-builder/old-reader.lua:41-95` 与 `207-241` 把旧版 `TriggerData.txt` / `TriggerStrings.txt` 解析成 `event/condition/action/call/define` 结构。
- `source/Development/Component/script/ydwe/ui-builder/new-reader.lua:50-68` 与 `112-127` 说明新版拆分格式同样先读文本定义，再合并为 UI 状态。
- `source/Development/Component/plugin/w3x2lni/script/core/slk/frontend_trg.lua:20-39`、`41-79`、`81-90` 说明 `frontend_trg()` 读取的是 `ui\\config`、`ui\\TriggerData.txt`、`ui\\TriggerStrings.txt` 形成 `w2l.trg`。

因此，GUI 的“语义字典”来自 `TriggerData` 体系，而不是来自脚本本身。

### 3. `war3map.wtg/wct` 才是 YDWE/w3x2lni 的 GUI 结构化读写对象
- `source/Development/Component/plugin/w3x2lni/script/core/slk/backend.lua:55-68` 在存在 `war3map.wtg` / `war3map.wct` 时，调用 `frontend_wtg(wtg)` 和 `frontend_wct(wct)` 读入触发器结构。
- `source/Development/Component/plugin/w3x2lni/script/core/slk/backend.lua:92-107` 在需要写回地图时，调用 `backend_wtg(wtg_data, wts)` 与 `backend_wct(wct_data)` 生成新的 `war3map.wtg` / `war3map.wct`。
- `source/Development/Component/plugin/w3x2lni/script/core/slk/frontend_wtg.lua:165-205` 按 WTG 二进制布局读取 ECA 节点、参数和子块。
- `source/Development/Component/plugin/w3x2lni/script/core/slk/frontend_wtg.lua:233-245` 解码 WTG 前先取 `state = w2l:frontend_trg()`，说明 WTG 解码依赖 GUI 元数据。
- `source/Development/Component/plugin/w3x2lni/script/core/slk/backend_wtg.lua:174-204` 把内部触发器结构重新编码成 WTG ECA 节点。
- `source/Development/Component/plugin/w3x2lni/script/core/slk/backend_wtg.lua:228-239` 写 WTG 前同样先取 `state = w2l:frontend_trg()`。
- `source/Development/Component/plugin/w3x2lni/script/core/slk/frontend_wct.lua:12-39` 与 `backend_wct.lua:8-33` 说明 WCT 只负责全局自定义代码和各 trigger 的自定义文本槽位。

这条链很清楚：`YDWE/w3x2lni` 对 GUI 的结构化处理对象是 `WTG/WCT`，不是 `war3map.j` AST。

### 4. 编辑器真正把触发器显示成GUI时，关键仍然是“WTG 节点名 -> GUIId”
- `source/Development/Plugin/WE/YDTrigger/SetGUIId_Hook.cpp:10-74` 维护了一个“节点名 -> GUIId”的表。
- `source/Development/Plugin/WE/YDTrigger/SetGUIId_Hook.cpp:76-85` 在 `SetGUIId_Hook` 中把节点名写入 `This + 0x20`，把对应 GUIId 写入 `This + 0x138`，然后调用 `SetGUIUnknow(This)`。

这意味着编辑器侧的 GUI 恢复是依赖 WTG 节点名和 GUIId 映射完成的。只要没有合法的 WTG 节点名，单有 `war3map.j` 文本并不会自动变回编辑器 GUI。

## `war3map.j` 在 YDWE 中的真实用途

### A. 编译/保存用途
- `share/script/ydwe_on_save.lua:55-83` 与 `96-115` 保存地图时通过 `mpq_util:update_file(map_path, "war3map.j", ...)` 解包、处理并写回 `war3map.j`。
- `source/Development/Component/compiler/script/init.lua:7-15` 先复制出 `war3map.j`，处理后再覆盖回去。
- `source/Development/Component/compiler/script/init.lua:59-90` 后续执行的是注入、预处理、模板生成、JassHelper 编译。

这里的 `war3map.j` 是“编译输入/输出脚本文件”，不是“GUI 恢复输入”。

### B. JASS 优化用途
- `source/Development/Component/plugin/w3x2lni/script/core/slk/backend_optimizejass.lua:41-45` 读取 `common.j`、`blizzard.j`、`war3map.j`。
- `source/Development/Component/plugin/w3x2lni/script/core/slk/backend_optimizejass.lua:58-72` 把 `war3map.j` 送进 `parser.parser(...)` 和 `optimizer(...)`。
- `source/Development/Component/plugin/w3x2lni/script/core/slk/backend_optimizejass.lua:79-83` 优化后只把结果重新写回 `war3map.j`。

这条链的输出仍然是 JASS，不是 GUI 触发器结构。

### C. JASS 文本/WTS 后处理用途
- `source/Development/Component/plugin/w3x2lni/script/core/slk/backend_convertjass.lua:35-40` 只是在 `war3map.j` 中替换 `TRIGSTR_XXX` 这类 WTS 引用。
- `source/Development/Component/plugin/w3x2lni/script/core/slk/backend_convertjass.lua:42-61` 只是在 JASS 开头添加/刷新 `//W3x2lni Data:` 标记。
- `source/Development/Component/plugin/w3x2lni/script/core/slk/backend_convertjass.lua:64-70` 入口只调用 `convert_wts()` 和 `convert_mark()`。

这一步只改 JASS 文本，不参与 GUI 重建。

### D. 对象/引用扫描用途
- `source/Development/Component/plugin/w3x2lni/script/core/slk/backend_searchjass.lua:49-90` 的核心动作是收集四字节 rawcode 和若干保留标记。
- `source/Development/Component/plugin/w3x2lni/script/core/slk/backend_searchjass.lua:121-141` 读取 `war3map.j` 后只返回 `ids, marks`。

这一步是“对象引用扫描器”，不是“触发器 GUI 反编译器”。

## `fix-wtg` 的作用边界

### 1. `fix-wtg` 入口只读取 `war3map.wtg`
- `share/script/fix-wtg/loader.lua:7-15` 先 `storm.load_file('war3map.wtg')`，再拿当前 UI 元数据执行 `checker(wtg, state)`。
- 若校验失败，`share/script/fix-wtg/loader.lua:21-31` 调 `reader(wtg, state)` 推断缺失 UI，并输出 `unknownui/define.txt`、`event.txt`、`condition.txt`、`action.txt`、`call.txt`。

### 2. `checker.lua` 只是用 UI 元数据去走一遍 WTG
- `share/script/fix-wtg/checker.lua:17-33` 根据 `ui[type][name].args` 计算某个节点应有多少参数。
- `share/script/fix-wtg/checker.lua:35-109` 读取的是 `WTG!` 头、分类、变量、ECA 结构和参数，不涉及任何 JASS。

### 3. `reader.lua` 是“从 WTG 猜未知 UI”，不是“从 JASS 猜 GUI”
- `share/script/fix-wtg/reader.lua:50-72` 在发现未知名字时用 `try_fix(type, name)` 建一个待补定义。
- `share/script/fix-wtg/reader.lua:97-112`、`130-159` 从 WTG 二进制里读取头、变量、参数类型。
- `share/script/fix-wtg/reader.lua:174-220` 基于已有 `TriggerParams`、变量类型、常量形态去猜参数类型和返回类型。

所以 `fix-wtg` 修的是“现有 WTG 无法被当前 GUI 元数据解释”的问题，而不是“没有 WTG 时从 `war3map.j` 生成 GUI”。

## 样例地图实证

### 复现实验输入
- 样例脚本：`.tools/MapRepair/[0]一世之尊(地形开始) (2)/map/war3map.j`
- 样例真值：同目录 `war3map.wtg`、`war3map.wct`
- 复现实验工具：`.planning/tools/maprepair_sample_compare/MapRepair.SampleCompare.csproj`
- 本次审计输出：`.planning/tmp/ydwe-audit-sample-v1/`

### 直接计数
- 直接统计 `war3map.j` 里的 `InitTrig_*` 函数，得到 `89` 个。
- 用 `MapRepair.SampleCompare` 对样例进行对照，得到：

| 指标 | 真实 `war3map.wtg/wct` | 仅从 `war3map.j` 恢复 |
| --- | ---: | ---: |
| 分类数 | 18 | 1 |
| 变量数 | 20 | 4 |
| 触发器数 | 120 | 89 |
| 可恢复 GUI 事件节点 | 不适用 | 13 |
| 非空 WCT 触发器文本槽位 | 4 | 74 个触发器被迫落入 custom-text |
| 全局自定义代码长度 | 2214 | 不等价 |

### 样例恢复统计
- `.planning/tmp/ydwe-audit-sample-v1/summary.json` 显示：
- `TriggerCount = 89`
- `VariableCount = 4`
- `GuiEventNodeCount = 13`
- `CustomTextTriggerCount = 74`
- `StandardRegisterCount = 13`
- `HelperRegisterCount = 66`
- `HelperOnlyTriggerCount = 65`

### 标准注册与辅助注册分布
- 标准 `TriggerRegister*` 只剩：
- `TriggerRegisterPlayerChatEvent = 10`
- `TriggerRegisterAnyUnitEventBJ = 2`
- `TriggerRegisterTimerEventSingle = 1`
- 辅助注册函数主导了剩余 init 语义：
- `MFCTimer_layExeRecTg = 63`
- `MHItemRemoveEvent_Register = 2`
- `MHHeroGetExpEvent_Register = 1`

### 样例结论
- 真实 WTG 有 `120` 个触发器，但编译后脚本只保留 `89` 个 `InitTrig_*` 定义，至少有 `31` 个编辑器可见触发器并没有完整保留成普通初始化函数。
- 可直接从脚本恢复的标准 GUI 事件只有 `13` 个，远低于真实编辑器触发器规模。
- `summary.json` 中 `DecodeFailure = "No GUI metadata registered for \`Call:MFEvent_SkillUGet\`."` 且 `DecodeFailureSymbolPresentInScript = false`，说明真实 WTG 里还存在 GUI 层独有别名，它们根本不出现在编译后的 `war3map.j` 中。

样例的证据非常直接：对这类地图，`war3map.j` 本身不是完整 GUI 信息载体。

## 数据流总图

### 打开地图时的真实 GUI 恢复链
1. `ydwe_on_startup.lua` 初始化 `virtual_mpq` 和 `uiloader`
2. `uiloader.lua` 向编辑器虚拟出 `UI\\TriggerData.txt` / `UI\\TriggerStrings.txt`
3. `frontend_trg.lua` 读取这些 GUI 元数据，构建 `state.ui`
4. `frontend_wtg.lua` / `frontend_wct.lua` 读取地图内 `war3map.wtg` / `war3map.wct`
5. 编辑器插件 `SetGUIId_Hook.cpp` 用 WTG 节点名查 GUIId，最终恢复编辑器可见 GUI

### 保存地图时的 `war3map.j` 链
1. `ydwe_on_save.lua` 取出 `war3map.j`
2. 做注入、预处理、模板、JassHelper 等编译动作
3. 把生成后的脚本重新写回 `war3map.j`

### w3x2lni 的结构化链
1. 读图时：`war3map.wtg/wct -> frontend_wtg/frontend_wct -> 内部触发器结构`
2. 写图时：`内部触发器结构 -> backend_wtg/backend_wct -> war3map.wtg/wct`
3. JASS 只作为额外优化/引用扫描/文本后处理输入

## 对“war3map.j 如何转 GUI”的最终回答
- 如果问题是“YDWE 编辑器里最终为什么能看到 GUI”，答案是：
  因为它读的是 `war3map.wtg/wct`，并用 `TriggerData` 元数据把 WTG 节点解释成 GUI。
- 如果问题是“YDWE 有没有把 `war3map.j` 直接反编译成 GUI”，答案是：
  这份源码审计没有找到这样的实现，现有证据反而持续指向“不存在”。
- 如果问题是“那为什么一些基于脚本的修复工具还能尝试恢复 GUI”，答案是：
  那属于额外实现层，不是 YDWE 这套 GUI 读写链的原生能力；当前仓库里的 `MapRepair` 正是在做这件额外工作。

## 对当前项目的直接启示
1. 不能把 YDWE 当作现成的 `war3map.j -> GUI` 反编译器去复用，它提供的是 GUI 元数据、WTG/WCT 编解码和 unknown-ui 修复能力。
2. 如果要从 `war3map.j` 恢复 GUI，必须自己补一层“脚本语义重建器”；这层逻辑不在 YDWE 的原生主链里。
3. 任何声称“只靠 YDWE 就能把 `war3map.j` 完整变回 GUI”的说法，都需要非常谨慎地核对源码入口；至少在当前仓库携带的 YDWE 源码中，没有找到这条链。
