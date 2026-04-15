# MapRepair V60 Custom-Text Empty-Tree Alignment

## Goal
- Align whole-trigger custom-text fallback with the standard `w3x2lni` / YDWE old-format `war3map.wtg/wct` shape instead of keeping mixed custom-text + GUI-event trees.

## Findings
- `w3x2lni`'s `frontend_lml.lua` / `backend_wtg.lua` path treats old-format custom-text triggers as `wct = 1` entries whose GUI tree is empty unless a parallel `.lml` trigger body exists.
- `MapRepair`'s `BuildCustomTextTrigger()` still preserved recovered event roots on custom-text fallback, creating a checker-compatible but non-standard mixed-mode trigger shape.
- That shape was a plausible remaining editor-hostile edge even after extension-only nodes and the earlier pseudo-GUI outliers had already been removed.

## Fix
- Changed `JassGuiReconstructionParser.BuildCustomTextTrigger()` so custom-text triggers now emit an empty GUI tree and keep only the reconstructed custom-text closure in `war3map.wct`.
- Updated `MapRepair.Smoke` custom-text fallback scenarios to assert:
- empty GUI trees on custom-text fallback
- preserved `InitTrig_*` text inside the custom-text closure
- continued validator / original-checker acceptance

## Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/tmp/current-rerun-v8/chuzhang V2 mod2.851_repaired_current.w3x .planning/tmp/current-rerun-v8/report`
- `dotnet run --project .planning/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/tmp/current-rerun-v8/chuzhang V2 mod2.851_repaired_current.w3x war3map.wtg .planning/tmp/current-rerun-v8/verify/war3map.wtg`
- `dotnet run --project .planning/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/tmp/current-rerun-v8/chuzhang V2 mod2.851_repaired_current.w3x war3map.wct .planning/tmp/current-rerun-v8/verify/war3map.wct`
- `dotnet run --project .planning/tools/maprepair_wtg_inspect/MapRepair.WtgInspect.csproj -- . .planning/tmp/current-rerun-v8/verify/war3map.wtg .planning/tmp/current-rerun-v8/verify/war3map.wct`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\tmp\current-rerun-v8\verify\war3map.wtg`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\tmp\current-rerun-v8\verify\war3map.wtg --debug-missing`

## Real-Map Result
- The latest stable rerun is now `Lua/.planning/tmp/current-rerun-v8/`.
- The latest package refresh is `Lua/.tools/MapRepair/publish/win-x64-self-contained-20260405-0706/` plus `MapRepair-win-x64-self-contained-20260405-0706.zip`.
- Post-fix inspection still reports:
- `triggerCount = 569`
- `variableCount = 839`
- `customTextCount = 256`
- `extensionNodes = []`
- `maxActionCount = 96`
- `maxActionTrigger = item set`
- The `topEvents` counts drop materially versus `v7` because the `256` whole-trigger custom-text fallbacks no longer keep preserved event roots inside `war3map.wtg`.

## Remaining Gap
- Manual editor-side validation is still required to confirm whether removing mixed-mode custom-text trigger trees clears the remaining trigger-load crash.
- If the crash still reproduces, the next likely slice remains the surviving large sequential GUI triggers such as `SET`, `SET2`, and `item set`.
