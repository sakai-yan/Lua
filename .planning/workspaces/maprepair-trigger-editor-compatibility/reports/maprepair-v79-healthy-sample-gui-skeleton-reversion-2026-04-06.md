# MapRepair V79 Healthy-Sample GUI Skeleton Reversion

## Goal
- React to the user direction that the previous front-slice custom-text conclusions may be wrong.
- Move the repaired trigger output back toward the healthy sample style by preserving recoverable GUI skeletons instead of forcing small and medium eventful triggers into whole-trigger custom-text.

## Findings / Root Cause
- The healthy source sample `.tools/YDWE/荒魂演武(不朽开源)` remains editor-healthy while its raw `war3map.wct` has `412` slots and `0` non-empty trigger custom-text entries.
- Earlier stable reruns such as `v10` and `v12` kept the early real-map triggers in a much more sample-like shape:
  - `001-SET` = GUI trigger with a timer event plus mixed GUI actions and `CustomScriptCode`
  - `002-SET2` = GUI trigger with a timer event plus mixed GUI actions and `CustomScriptCode`
  - the `baoxiang` cluster = GUI triggers with standard unit-use-item events
- The later pseudo-GUI fallback layers added for:
  - medium branch-heavy bodies
  - medium mixed GUI/custom-script control-flow bodies
  - the compact `5`-`19` front-slice bands
  had pushed that same early slice into whole-trigger custom-text, which moved the repaired map further away from the healthy sample style instead of closer.

## Fix / Mitigation
- Removed the pseudo-GUI fallback bands that had been forcing recoverable small and medium eventful triggers back down to whole-trigger custom-text:
  - medium branch-heavy pseudo-GUI
  - medium mixed GUI/custom-script control-flow pseudo-GUI
  - compact `8`-`11` control-heavy band
  - compact `5`-`7` guarded band
  - focused / stable `12`-`19` mixed bands
- Kept the larger safety fallbacks intact for genuinely oversized or dense pseudo-GUI survivors.
- Updated the affected `MapRepair.Smoke` scenarios so they now assert GUI-skeleton retention instead of mandatory custom-text fallback.

## Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v26/chuzhang V2 mod2.851_repaired_current.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v26/report`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v26/chuzhang V2 mod2.851_repaired_current.w3x war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v26/verify/war3map.wtg`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v26/chuzhang V2 mod2.851_repaired_current.w3x war3map.wct .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v26/verify/war3map.wct`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_wtg_inspect/MapRepair.WtgInspect.csproj -- d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v26/verify/war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v26/verify/war3map.wct`

## Real-Map Result
- `v26` keeps:
  - `triggerCount = 569`
  - `extensionNodes = []` under the current checker-compatible route
  - `maxActionTrigger = item set`
  - `maxActionCount = 96`
- `v26` moves the repaired map back toward the healthy sample shape:
  - `customTextCount` drops from `468` in `v25` to `284`
  - `GuiEventNodeCount` rises from `257` in `v25` to `509`
  - first triggers now read as:
    - `SET` = GUI (`1` event, `36` actions)
    - `SET2` = GUI (`1` event, `77` actions)
    - `SET 3` = custom-text
    - `clc2 baoxiang` through `czd3 baoxiang` = GUI (`1` event, `5` actions each)
  - `016-tmdlimititemlvl` is back to GUI with its event, guard prelude, and action body preserved as mixed GUI plus `CustomScriptCode`

## Current Continuation Target
- Manual editor-side validation against `.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v26/chuzhang V2 mod2.851_repaired_current.w3x`.
- If the editor still stops near `16/569`, treat that as evidence that the remaining issue is no longer “the whole early front slice collapsed to custom-text”, because that route has now been rolled back for most of the first sixteen triggers.
