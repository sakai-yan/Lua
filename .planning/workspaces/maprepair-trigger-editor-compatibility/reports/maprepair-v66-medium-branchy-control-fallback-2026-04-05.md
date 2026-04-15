# MapRepair V66 Medium Branchy / Mixed-Control Fallback

## Goal
- React to the new manual editor validation signal that the `v12` repaired map still crashes while reading triggers.
- Remove the remaining medium-size pseudo-GUI survivors that still looked editor-hostile even though extension nodes had already been eliminated.

## Trigger Shape Finding
- `current-rerun-v12` and the earlier safer `v10` had the same structural trigger summary, so the persistent crash was not another repo-level extension-node regression.
- Workspace inspection of `current-rerun-v12/report/RecoveredGui/*.lml` showed:
- `SET` remained GUI with `36` actions, `16` `CustomScriptCode` lines, and `5` control-flow markers.
- `SET2` remained GUI with `77` actions, `18` `CustomScriptCode` lines, and `6` control-flow markers.
- Another `43` GUI triggers still matched a medium branch-heavy shape around `20+` actions with `14+` `CustomScriptCode` lines and `7+` control-flow markers.
- In total, `57` GUI triggers matched the union of:
- `20+` actions, `14+` `CustomScriptCode`, `7+` control-flow
- `20+` actions, `15+` `CustomScriptCode`, `5+` control-flow

## Fix
- Added two new conservative fallback gates in `JassGuiReconstructionParser`:
- medium branch-heavy pseudo-GUI fallback
- mixed GUI/custom-script control-flow fallback
- Added smoke coverage:
- `gui-medium-branchy-pseudo-fallback`
- `gui-medium-control-pseudo-fallback`

## Verification
- `dotnet run --project d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\src\MapRepair.Smoke\MapRepair.Smoke.csproj`
- `dotnet run --project d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\tools\maprepair_runner\MapRepair.Run.csproj -- d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\chuzhang V2 mod2.851.w3x d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v13\chuzhang V2 mod2.851_repaired_current.w3x d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v13\report`
- `dotnet run --project d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\tools\maprepair_archive_probe\MapRepair.ArchiveProbe.csproj -- --extract d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v13\chuzhang V2 mod2.851_repaired_current.w3x war3map.wtg d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v13\verify\war3map.wtg`
- `dotnet run --project d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\tools\maprepair_archive_probe\MapRepair.ArchiveProbe.csproj -- --extract d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v13\chuzhang V2 mod2.851_repaired_current.w3x war3map.wct d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v13\verify\war3map.wct`
- `dotnet run --project d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\tools\maprepair_wtg_inspect\MapRepair.WtgInspect.csproj -- d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v13\verify\war3map.wtg d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v13\verify\war3map.wct`
- `d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\scripts\ydwe_wtg_checker.lua d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\YDWE d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v13\verify\war3map.wtg`
- `d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\scripts\ydwe_wtg_checker.lua d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\YDWE d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v13\verify\war3map.wtg --debug-missing`

## Result
- `current-rerun-v13` still passes both checker gates.
- `customTextCount` rises from `284` to `347`.
- `GuiEventNodeCount` drops from `509` to `446`.
- `CustomScriptCode` action nodes drop from `2634` to `1599`.
- `SET` now falls back to whole-trigger custom-text with note:
- `16` custom-script lines
- `5` control-flow markers
- `36` actions
- `SET2` now falls back to whole-trigger custom-text with note:
- `18` custom-script lines
- `6` control-flow markers
- `77` actions
- The remaining GUI survivors no longer include any trigger matching the new:
- `20+` actions, `14+` `CustomScriptCode`, `7+` control-flow
- `20+` actions, `15+` `CustomScriptCode`, `5+` control-flow

## Next Slice If Needed
- Manual editor validation is still required.
- If `v13` still crashes, inspect the remaining `15`-`19` action mixed GUI/custom-script survivors first.
