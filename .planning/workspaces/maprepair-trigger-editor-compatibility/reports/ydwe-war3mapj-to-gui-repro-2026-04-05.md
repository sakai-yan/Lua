# YDWE `war3map.j` 到 GUI 审计复现报告

## 复现目标
- 复现并验证以下结论：
- `YDWE` 没有直接的 `war3map.j -> GUI -> war3map.wtg/wct` 反编译链。
- `YDWE` 的 GUI 恢复依赖 `TriggerData/TriggerStrings` 与 `war3map.wtg/wct`。
- `fix-wtg` 处理的是现有 WTG 的未知 UI 兼容问题，不是 JASS 反编译。
- 样例地图证明 `war3map.j` 是有损信息源，不能单独代表完整编辑器 GUI。

## 环境前提
- 工作目录：`D:\Software\魔兽地图编辑\[0]新整合编辑器\Lua`
- Shell：`powershell`
- 日期：`2026-04-05`
- 关键源码根：
- `.tools/YDWE/source`
- `.tools/YDWE/share/script`
- 关键样例：
- `.tools/MapRepair/[0]一世之尊(地形开始) (2)/map/war3map.j`
- `.tools/MapRepair/[0]一世之尊(地形开始) (2)/map/war3map.wtg`
- `.tools/MapRepair/[0]一世之尊(地形开始) (2)/map/war3map.wct`
- 关键复现工具：
- `.planning/tools/maprepair_sample_compare/MapRepair.SampleCompare.csproj`
- 建议输出目录：
- `.planning/tmp/ydwe-audit-sample-v1`

## 判定规则

### 可以判定“存在直接 `war3map.j -> GUI` 链路”的证据
- 找到某个模块直接读取 `war3map.j`，构造结构化 GUI 节点/ECA 树，再调用 `backend_wtg`、`WriteWtg`、`backend_wct` 或等价写出逻辑。
- 找到某个模块把 `war3map.j` 解析结果直接喂给编辑器的 GUI 恢复接口，而不是只写回 JASS 文本。

### 可以判定“`war3map.j` 只做辅助用途”的证据
- 读取 `war3map.j` 后只做：
- 编译或覆写 `war3map.j`
- AST 优化并写回 `war3map.j`
- WTS 文本替换
- 对象 rawcode/引用扫描
- 其他与 GUI 树无关的脚本处理

### 可以判定“GUI 真正来源于 `war3map.wtg/wct`”的证据
- `frontend_wtg/frontend_wct` 负责把 `war3map.wtg/wct` 解析成内部触发器结构。
- `backend_wtg/backend_wct` 负责把内部结构写回 `war3map.wtg/wct`。
- 它们都依赖 `frontend_trg()` 提供的 GUI 元数据，而不是依赖 `war3map.j`。

### 可以判定“`fix-wtg` 不是 JASS 反编译器”的证据
- 入口先读 `war3map.wtg`
- 校验器与 reader 都按 WTG 二进制结构读取节点和参数
- 输出是 `unknownui` 元数据文件，而不是从 JASS 构造的新 WTG/WCT

## 复现步骤

### 第 1 步：确认关键目录和样例存在
执行：
```powershell
Get-ChildItem -LiteralPath '.tools\YDWE'
Get-ChildItem -LiteralPath '.tools\YDWE\source'
Get-ChildItem -LiteralPath '.tools\MapRepair\[0]一世之尊(地形开始) (2)\map'
```

预期：
- `.tools/YDWE/source`、`.tools/YDWE/share/script`、`.tools/MapRepair/[0]一世之尊(地形开始) (2)/map` 都存在。
- 样例目录中至少能看到 `war3map.j`、`war3map.wtg`、`war3map.wct`。

失败处理：
- 如果样例不在 `.tools/MapRepair` 下，全文搜索 `war3map.j`、`war3map.wtg`、`war3map.wct` 的同目录共存样本。

### 第 2 步：列出所有 `war3map.j` 消费点
执行：
```powershell
$root='D:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\YDWE'
rg -n -S "war3map\.j" `
  "$root\source\Development\Component\plugin\w3x2lni\script\core" `
  "$root\source\Development\Component\compiler\script" `
  "$root\share\script"
```

预期：
- 命中主要集中在：
- 编译保存脚本
- `backend_optimizejass.lua`
- `backend_convertjass.lua`
- `backend_searchjass.lua`
- 以及少量路径/资源清理逻辑
- 不应出现“读取 `war3map.j` 后直接生成 `war3map.wtg/wct`”的调用链。

记录证据：
- 把每个命中按“编译”“优化”“文本处理”“引用扫描”分类。

### 第 3 步：验证保存阶段只是在处理 `war3map.j`
执行：
```powershell
$p='.tools\YDWE\share\script\ydwe_on_save.lua'
$lines=Get-Content -LiteralPath $p
for($i=55; $i -le 115; $i++){ '{0,4}: {1}' -f $i, $lines[$i-1] }

$p='.tools\YDWE\source\Development\Component\compiler\script\init.lua'
$lines=Get-Content -LiteralPath $p
for($i=7; $i -le 15; $i++){ '{0,4}: {1}' -f $i, $lines[$i-1] }
for($i=59; $i -le 90; $i++){ '{0,4}: {1}' -f $i, $lines[$i-1] }
```

预期：
- 可以看到 `mpq_util:update_file(map_path, "war3map.j", ...)`
- 可以看到 `fs.copy_file(... / 'war3map.j', ...)`
- 以及注入、Wave、模板、JassHelper 等脚本编译步骤
- 看不到从 JASS 生成 GUI/WTG 的逻辑

判定：
- 这一步只能证明 `war3map.j` 是编译输入/输出，不能证明存在 GUI 反编译。

### 第 4 步：验证 `war3map.j` 的另外三个主要用途
执行：
```powershell
$files = @(
  '.tools\YDWE\source\Development\Component\plugin\w3x2lni\script\core\slk\backend_optimizejass.lua',
  '.tools\YDWE\source\Development\Component\plugin\w3x2lni\script\core\slk\backend_convertjass.lua',
  '.tools\YDWE\source\Development\Component\plugin\w3x2lni\script\core\slk\backend_searchjass.lua'
)
foreach($p in $files){ Write-Host "==== $p ===="; Get-Content -LiteralPath $p | Select-Object -First 170 }
```

预期：
- `backend_optimizejass.lua`：读取 `war3map.j`，`parser.parser(...)` 后只写回优化后的 JASS。
- `backend_convertjass.lua`：只做 WTS 替换与文件头标记。
- `backend_searchjass.lua`：只返回 `ids, marks` 一类引用扫描结果。

判定：
- 如果输出仍然只落在 JASS 文本或对象引用上，则不能把它们算作 GUI 反编译链。

### 第 5 步：确认 GUI 元数据来自 `TriggerData` / `TriggerStrings`
执行：
```powershell
$files = @(
  '.tools\YDWE\source\Development\Component\script\ydwe\uiloader.lua',
  '.tools\YDWE\source\Development\Component\script\ydwe\triggerdata.lua',
  '.tools\YDWE\source\Development\Component\script\ydwe\ui-builder\old-reader.lua',
  '.tools\YDWE\source\Development\Component\script\ydwe\ui-builder\new-reader.lua',
  '.tools\YDWE\source\Development\Component\plugin\w3x2lni\script\core\slk\frontend_trg.lua'
)
foreach($p in $files){ Write-Host "==== $p ===="; Get-Content -LiteralPath $p | Select-Object -First 120 }
```

预期：
- `uiloader.lua` 监视 `UI\TriggerData.txt`、`UI\TriggerStrings.txt`
- `triggerdata.lua` 从 `ui` 列表加载 old/new UI 包并合并
- `frontend_trg.lua` 通过 `ui\config` 和 `TriggerData/TriggerStrings` 构建 `w2l.trg`

判定：
- GUI 元数据字典来自 UI 文本资源，而不是来自 `war3map.j`。

### 第 6 步：确认结构化 GUI 读写对象是 `war3map.wtg/wct`
执行：
```powershell
$files = @(
  '.tools\YDWE\source\Development\Component\plugin\w3x2lni\script\core\slk\backend.lua',
  '.tools\YDWE\source\Development\Component\plugin\w3x2lni\script\core\slk\frontend_wtg.lua',
  '.tools\YDWE\source\Development\Component\plugin\w3x2lni\script\core\slk\backend_wtg.lua',
  '.tools\YDWE\source\Development\Component\plugin\w3x2lni\script\core\slk\frontend_wct.lua',
  '.tools\YDWE\source\Development\Component\plugin\w3x2lni\script\core\slk\backend_wct.lua'
)
foreach($p in $files){ Write-Host "==== $p ===="; Get-Content -LiteralPath $p | Select-Object -First 260 }
```

重点看：
- `backend.lua` 中 `convert_wtg(w2l)`
- `frontend_wtg(wtg)` / `frontend_wct(wct)`
- `backend_wtg(wtg_data, wts)` / `backend_wct(wct_data)`
- `state = w2l:frontend_trg()`

预期：
- 读图时从 `war3map.wtg/wct` 解析内部触发器结构
- 写图时从内部结构重新编码成 `war3map.wtg/wct`
- 整个过程依赖 `frontend_trg()` 提供 UI 语义

判定：
- 这里才是 YDWE/w3x2lni 的 GUI 主链。

### 第 7 步：确认编辑器恢复 GUI 依赖 `SetGUIId`
执行：
```powershell
$p='.tools\YDWE\source\Development\Plugin\WE\YDTrigger\SetGUIId_Hook.cpp'
$lines=Get-Content -LiteralPath $p
for($i=1; $i -le 90; $i++){ '{0,4}: {1}' -f $i, $lines[$i-1] }
```

预期：
- 看到节点名到 `CC_GUIID_*` 的映射表
- 看到 `SetGUIId_Hook` 把 `name` 和 `id` 写进编辑器内部对象

判定：
- 编辑器显示 GUI 的关键仍然是 WTG 节点名与 GUIId，而不是 JASS 文本自身。

### 第 8 步：确认 `fix-wtg` 只修现有 `war3map.wtg`
执行：
```powershell
$files = @(
  '.tools\YDWE\share\script\fix-wtg\init.lua',
  '.tools\YDWE\share\script\fix-wtg\loader.lua',
  '.tools\YDWE\share\script\fix-wtg\checker.lua',
  '.tools\YDWE\share\script\fix-wtg\reader.lua'
)
foreach($p in $files){ Write-Host "==== $p ===="; Get-Content -LiteralPath $p | Select-Object -First 220 }
```

预期：
- `loader.lua` 入口先 `storm.load_file('war3map.wtg')`
- `checker.lua` 和 `reader.lua` 都在按 WTG 二进制结构读节点
- 输出是 `unknownui/*.txt`

判定：
- 这是 WTG unknown-ui 修复链，不是 JASS 反编译链。

### 第 9 步：统计样例 `war3map.j` 的 `InitTrig_*` 数量
执行：
```powershell
$p='.tools\MapRepair\[0]一世之尊(地形开始) (2)\map\war3map.j'
rg -c "^function InitTrig_" $p
```

预期：
- 返回 `89`

判定：
- 这是样例中脚本层可直接观察到的 trigger init 数量。

### 第 10 步：运行样例对比工具
执行：
```powershell
$proj='D:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\tools\maprepair_sample_compare\MapRepair.SampleCompare.csproj'
$script='D:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\[0]一世之尊(地形开始) (2)\map\war3map.j'
$out='D:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\tmp\ydwe-audit-sample-v1'
dotnet run --project $proj -- 'D:\Software\魔兽地图编辑\[0]新整合编辑器\Lua' $script $out
```

预期：
- 生成：
- `summary.json`
- `sample-reconstructed.wtg`
- `sample-reconstructed.wct`
- `RecoveredGui/` 目录

失败处理：
- 尽量用绝对路径传给 `dotnet run --project`；在当前环境里，相对路径的 csproj 参数更容易触发 `MSB1009`。

### 第 11 步：读取样例对比结果
执行：
```powershell
$p='D:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\tmp\ydwe-audit-sample-v1\summary.json'
$json=Get-Content -LiteralPath $p -Raw | ConvertFrom-Json
[ordered]@{
  TriggerCount = $json.summary.TriggerCount
  VariableCount = $json.summary.VariableCount
  GuiEventNodeCount = $json.summary.GuiEventNodeCount
  CustomTextTriggerCount = $json.summary.CustomTextTriggerCount
  StandardRegisterCount = $json.helperInitAnalysis.standardRegisterCount
  HelperRegisterCount = $json.helperInitAnalysis.helperRegisterCount
  HelperOnlyTriggerCount = $json.helperInitAnalysis.helperOnlyTriggerCount
  RealCategoryCount = $json.reference.raw.categoryCount
  RealVariableCount = $json.reference.raw.variableCount
  RealTriggerCount = $json.reference.raw.triggerCount
  RealWctTriggerCount = $json.reference.raw.wctTriggerCount
  RealNonEmptyWctTriggerCount = $json.reference.raw.nonEmptyTriggerTextCount
  RealGlobalCustomCodeLength = $json.reference.raw.globalCustomCodeLength
  DecodeFailure = $json.reference.decodeFailure
  DecodeFailureSymbolPresentInScript = $json.reference.decodeFailureSymbolPresentInScript
} | ConvertTo-Json
```

预期：
- 近似得到：
- `TriggerCount = 89`
- `VariableCount = 4`
- `GuiEventNodeCount = 13`
- `CustomTextTriggerCount = 74`
- `StandardRegisterCount = 13`
- `HelperRegisterCount = 66`
- `HelperOnlyTriggerCount = 65`
- `RealCategoryCount = 18`
- `RealVariableCount = 20`
- `RealTriggerCount = 120`
- `RealWctTriggerCount = 120`
- `RealNonEmptyWctTriggerCount = 4`
- `RealGlobalCustomCodeLength = 2214`
- `DecodeFailureSymbolPresentInScript = false`

判定：
- 如果真实 WTG/WCT 信息显著多于 `war3map.j` 可恢复信息，则 `war3map.j` 不能被视为 GUI 的完整等价源。

### 第 12 步：读取辅助注册分布
执行：
```powershell
$p='D:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\tmp\ydwe-audit-sample-v1\summary.json'
$json=Get-Content -LiteralPath $p -Raw | ConvertFrom-Json
$json.helperInitAnalysis.standardRegisterFunctions | ConvertTo-Json
$json.helperInitAnalysis.helperRegisterFunctions | ConvertTo-Json
```

预期：
- 标准注册集中在：
- `TriggerRegisterPlayerChatEvent = 10`
- `TriggerRegisterAnyUnitEventBJ = 2`
- `TriggerRegisterTimerEventSingle = 1`
- 辅助注册集中在：
- `MFCTimer_layExeRecTg = 63`
- `MHItemRemoveEvent_Register = 2`
- `MHHeroGetExpEvent_Register = 1`

判定：
- 即使 `war3map.j` 里还残留触发器初始化函数，也常常只剩 opaque helper 调用，而不是完整可逆的编辑器事件语义。

## 复现后的结论判定

### 满足以下全部条件时，可判定“不存在直接 `war3map.j -> GUI` 链路”
1. `war3map.j` 的所有消费点都落在编译、优化、文本处理、引用扫描范围内。
2. `frontend_wtg/backend_wtg/frontend_wct/backend_wct` 才是 GUI 结构化读写主链。
3. `frontend_trg()` 的输入是 `TriggerData/TriggerStrings`，不是 JASS。
4. `fix-wtg` 的输入是 `war3map.wtg`，输出是 `unknownui` 元数据。
5. 样例地图对照显示真实 WTG/WCT 信息量显著高于仅从 JASS 可恢复的信息。

### 满足以下条件时，可判定“GUI 恢复真正依赖 WTG/WCT + TriggerData”
1. 编辑器侧存在 `SetGUIId` 这类“节点名 -> GUIId”恢复逻辑。
2. WTG 编解码模块前后都依赖 `frontend_trg()`。
3. 打开地图时优先装载的是 UI 元数据与 WTG 修复逻辑。

## 失败分支与注意事项
- `source/Development` 与 `share/script` 存在镜像实现时，以 `source/Development` 为源码真值，再用 `share/script` 验证打包版行为。
- 如果样例对比工具无法直接读取某个真实 WTG，至少保留原始头部计数、WCT 槽位数和 decode failure 信息；不要因为单点解码失败就放弃整条证据链。
- 如果用 `dotnet run --project` 传相对 csproj 路径失败，直接切换为绝对路径。
- 如果 `rg` 不可用，退回 `Select-String`，但要保证输出仍然包含文件路径和行号。
- 如果 PowerShell 读中文文件出现显示级乱码，不要先修改文件；先只把它当作终端编码问题处理。

## 本次审计建议固定引用的结果文件
- 审计报告：`.planning/reports/ydwe-war3mapj-to-gui-audit-2026-04-05.md`
- 复现报告：`.planning/reports/ydwe-war3mapj-to-gui-repro-2026-04-05.md`
- 样例复现实验输出：`.planning/tmp/ydwe-audit-sample-v1/`

## 一句话结论
- 按上述步骤复现后，应稳定得到同一结论：
  `YDWE` 没有直接把 `war3map.j` 转回 GUI 的原生链路；它的 GUI 恢复依赖 `war3map.wtg/wct`、`TriggerData`/`TriggerStrings` 和 unknown-ui 修复，而 `war3map.j` 只承担编译、优化、文本处理和引用扫描等辅助角色。
