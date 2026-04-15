# MapRepair V65 Extension-Node Regression Fix

## Goal
- Diagnose why the freshly published `20260405-1016` package still crashed the target editor and restore the safer repaired-trigger shape without giving up map-local custom GUI support.

## Root Cause
- The broadened script-visible GUI recovery rule allowed any surviving `war3map.j` function name to resolve through repo-level YDWE extension metadata.
- On the real repaired map, that changed the output from:
- `current-rerun-v10`: `extensionNodes = []`
- to:
- `current-rerun-v11`: `extensionNodes = 584`
- Top reintroduced extension nodes in `v11` were:
- `Action:RemoveLocation` (`329`)
- `Action:DisplayTextToPlayer` (`151`)
- `Action:IssuePointOrderByIdLoc` (`48`)
- `Action:DestroyGroup` (`30`)
- plus smaller counts of `FlushGameCache`, nested `InitGameCache`, `FogEnable`, `ExecuteFunc`, and related YDWE-only nodes.
- The YDWE checker still passed, so this was an editor-runtime compatibility regression rather than a byte-layout regression.
- Concrete trigger evidence:
- `current-rerun-v11/report/RecoveredGui/001-SET.lml` promoted `FlushGameCache`, `FogEnable`, and `ExecuteFunc` back into structured GUI nodes.
- `current-rerun-v10/report/RecoveredGui/001-SET.lml` had kept those same operations as `CustomScriptCode`, which matched the earlier crash-avoidance route.

## Fix
- Added `GuiMetadataCatalog.TryGetStructuredRecoveryEntry(...)` so structured recovery now accepts:
- base-compatible metadata
- map-local embedded GUI extension metadata loaded from `map:` sources
- Updated `JassGuiReconstructionParser` and `GuiArgumentNormalizer` to use that narrower entry set.
- Preserved map-local GUI metadata by teaching candidate collection to keep:
- `ui\\config`
- `ui\\TriggerData.txt`
- `ui\\TriggerStrings.txt`
- `ui\\<package>\\action.txt`
- `ui\\<package>\\call.txt`
- `ui\\<package>\\condition.txt`
- `ui\\<package>\\event.txt`
- Added smoke coverage `gui-map-local-extension-recovery`.
- Restored `gui-extension-compatibility-fallback` to assert repo-level YDWE extension actions fall back to `CustomScriptCode`.

## Verification
- `dotnet run --project d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\src\MapRepair.Smoke\MapRepair.Smoke.csproj`
- `dotnet run --project .planning/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/tmp/current-rerun-v12/chuzhang V2 mod2.851_repaired_current.w3x .planning/tmp/current-rerun-v12/report`
- `dotnet run --no-build --project .planning/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/tmp/current-rerun-v12/chuzhang V2 mod2.851_repaired_current.w3x war3map.wtg .planning/tmp/current-rerun-v12/verify/war3map.wtg`
- `dotnet run --no-build --project .planning/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/tmp/current-rerun-v12/chuzhang V2 mod2.851_repaired_current.w3x war3map.wct .planning/tmp/current-rerun-v12/verify/war3map.wct`
- `dotnet run --no-build --project .planning/tools/maprepair_wtg_inspect/MapRepair.WtgInspect.csproj -- . .planning/tmp/current-rerun-v12/verify/war3map.wtg .planning/tmp/current-rerun-v12/verify/war3map.wct`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\tmp\current-rerun-v12\verify\war3map.wtg`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\tmp\current-rerun-v12\verify\war3map.wtg --debug-missing`
- `current-rerun-v12` result:
- `extensionNodes = []`
- `customTextCount = 284`
- `maxActionTrigger = item set`
- `maxActionCount = 96`
- checker `PASS`
- debug walk `PASS`

## Published Artifacts
- Versioned publish directory:
- `.tools/MapRepair/publish/win-x64-self-contained-20260405-1055/`
- Refreshed stable publish directory:
- `.tools/MapRepair/publish/win-x64-self-contained/`
- Versioned zip:
- `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260405-1055.zip`
