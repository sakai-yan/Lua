# MapRepair V77 Custom-Text Local Closure Trim

## Goal
- Revisit the early custom-text slice after the user confirmed `v23` still stopped at `16/569`.
- Test the next planned hypothesis: even after the source-order fix, the emitted `war3map.wct` chunks might still be too broad because they keep recursively pulling non-local helper closure into early custom-text triggers.

## Findings / Root Cause
- `v23` already fixed empty-tree custom-text shape, callback-helper preservation, and source-order chunk emission, but the earliest custom-text triggers were still broader than a trigger-local editor-authored chunk.
- The clearest example was `tmp/current-rerun-v23/report/RecoveredGui/001-SET.j`, which contained `29` functions and pulled in:
  - non-local helpers such as `PlayerLoadEsc`
  - save/load utility functions
  - unrelated trigger bodies such as `Trig_aa_Actions`
  - other trigger actions such as `Trig_hero_chose1_Actions`
- `tmp/current-rerun-v23/report/RecoveredGui/559-hero chose2.j` showed the same pattern and also dragged save/load helpers plus unrelated `Trig_aa_*` functions into a single trigger chunk.
- `maprepair_wtg_inspect` still showed the same safe structural counts (`triggerCount = 569`, `customTextCount = 468`, `GuiEventNodeCount = 257`, empty child blocks), which means the remaining suspicion shifted away from WTG tree shape and toward editor-hostile custom-text breadth.
- The recursive breadth came from using the full reachable helper closure for emitted custom-text chunks, including:
  - action-time external helper chains
  - `ExecuteFunc("...")` targets
  - transitive expansion into unrelated `Trig_*` and `InitTrig_*` bodies from other triggers

## Fix / Mitigation
- Added `SelectCustomTextChunkFunctions(...)` to `JassGuiReconstructionParser`.
- The emitted `war3map.wct` chunk now keeps:
  - the current trigger's local `Trig_*` / `InitTrig_*` functions
  - direct non-local helper calls from `InitTrig_*` only, so opaque init-registration helpers such as `OpaqueRegister` remain preserved
  - source-backed order, trigger comment headers, and trigger-local `globals ... endglobals` blocks when applicable
- The emitted custom-text chunk no longer recursively follows action-time external helper chains, and it no longer imports unrelated `Trig_*` or `InitTrig_*` bodies from other triggers.
- Added smoke coverage `gui-custom-text-local-closure` to lock this behavior.

## Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v24/chuzhang V2 mod2.851_repaired_current.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v24/report`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v24/chuzhang V2 mod2.851_repaired_current.w3x war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v24/verify/war3map.wtg`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v24/chuzhang V2 mod2.851_repaired_current.w3x war3map.wct .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v24/verify/war3map.wct`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_wtg_inspect/MapRepair.WtgInspect.csproj -- d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v24/verify/war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v24/verify/war3map.wct`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v24\verify\war3map.wtg`
- `current-rerun-v24` keeps:
  - `triggerCount = 569`
  - `customTextCount = 468`
  - `GuiEventNodeCount = 257`
  - `extensionNodes = []`
- Early `v24` custom-text chunks now show the intended shrink:
  - `001-SET.j` shrank from `64575` bytes / `29` functions in `v23` to `2479` bytes / `4` local functions in `v24`
  - `559-hero chose2.j` now contains only `11` local functions instead of the previous transitive save/load spillover
  - `016-tmdlimititemlvl.j` still keeps the restored local helper and source-backed order

## Publish
- New rerun validation target:
  - `tmp/current-rerun-v24/chuzhang V2 mod2.851_repaired_current.w3x`
- New packaged desktop target:
  - `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260406-1317.zip`
- Refreshed stable desktop target:
  - `.tools/MapRepair/publish/win-x64-self-contained/`

## Next Slice If Manual Validation Still Fails
- Start from `current-rerun-v24`.
- If either editor still stops near `16/569`, inspect whether the remaining issue is no longer transitive helper breadth but the action-time external call text itself, especially:
  - `ExecuteFunc("PlayerLoadEsc")`
  - any other early custom-text bodies that still reference non-local helpers by name without embedding them
- If the failure point moves, pivot back to the remaining structured GUI survivors using `RecoveredGui/index.json`.
