# MapRepair V61 Sample `war3map.j` vs Real `war3map.wtg` And Eventless-GUI Fallback

## Goal
- Use the provided `一世之尊` sample as a truth check by comparing:
- the real editor-readable `war3map.wtg/wct`
- the `war3map.wtg/wct` reconstructed from the sample's `war3map.j`
- then translate the mismatch into a safer fallback rule for the real repair target.

## Findings
- The sample's real trigger metadata is far richer than what survives in `war3map.j`:
- real sample `war3map.wtg`: `18` categories, `20` variables, `120` triggers
- real sample `war3map.wct`: `4` non-empty trigger texts, global custom code length `2069`
- reconstructed-from-`war3map.j` sample after the new empty-tree custom-text alignment:
- `89` triggers
- `4` variables
- `1` category (`Recovered GUI`)
- `13` recoverable GUI event nodes
- `65` whole-trigger custom-text fallbacks
- The `89` reconstructed triggers match the `InitTrig_*` count in `war3map.j`; the missing `31` editor-visible triggers therefore do not survive in compiled script as normal `InitTrig_*` trigger definitions.
- The sample `InitTrig_*` bodies contain only `13` standard `TriggerRegister*` calls:
- `10` `TriggerRegisterPlayerChatEvent`
- `2` `TriggerRegisterAnyUnitEventBJ`
- `1` `TriggerRegisterTimerEventSingle`
- This exactly matches the reconstructed sample's `GuiEventNodeCount = 13`.
- Many other sample trigger inits instead use opaque helper wrappers such as `MFCTimer_layExeRecTg`, while some extension registration functions in the protected script are reduced to stubs like `ConvertRace(0); return`, so their original editor event semantics are no longer recoverable from `war3map.j`.

## Conclusion
- The sample proves that `war3map.j` is a lossy source for editor trigger reconstruction on protected / extension-heavy maps.
- When a trigger init has no recoverable GUI event nodes, keeping a non-trivial GUI action body is riskier than falling back to whole-trigger custom-text, because the original trigger may have had editor-visible event semantics that no longer survive in script.

## Fix
- Added a new fallback in `JassGuiReconstructionParser`:
- if a trigger still has no recoverable GUI events or conditions
- and its remaining GUI body is non-trivial (`CustomScriptCode` present or more than one action)
- then emit it as whole-trigger custom-text instead of eventless GUI
- Added smoke coverage:
- `gui-eventless-fallback`
- `gui-opaque-init-fallback`
- Extended custom-text closure collection so opaque init helper functions are preserved inside the fallback custom text.

## Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/tools/maprepair_sample_compare/MapRepair.SampleCompare.csproj -- . .tools/MapRepair/[0]一世之尊(地形开始) (2)/map/war3map.j .planning/tmp/sample-reconstruct-compare-v2`
- `dotnet run --project .planning/tools/maprepair_wtg_inspect/MapRepair.WtgInspect.csproj -- . .planning/tmp/sample-reconstruct-compare-v2/sample-reconstructed.wtg .planning/tmp/sample-reconstruct-compare-v2/sample-reconstructed.wct`
- `dotnet run --project .planning/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/tmp/current-rerun-v10/chuzhang V2 mod2.851_repaired_current.w3x .planning/tmp/current-rerun-v10/report`
- `dotnet run --project .planning/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/tmp/current-rerun-v10/chuzhang V2 mod2.851_repaired_current.w3x war3map.wtg .planning/tmp/current-rerun-v10/verify/war3map.wtg`
- `dotnet run --project .planning/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/tmp/current-rerun-v10/chuzhang V2 mod2.851_repaired_current.w3x war3map.wct .planning/tmp/current-rerun-v10/verify/war3map.wct`
- `dotnet run --project .planning/tools/maprepair_wtg_inspect/MapRepair.WtgInspect.csproj -- . .planning/tmp/current-rerun-v10/verify/war3map.wtg .planning/tmp/current-rerun-v10/verify/war3map.wct`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\tmp\current-rerun-v10\verify\war3map.wtg`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\tmp\current-rerun-v10\verify\war3map.wtg --debug-missing`

## Real-Map Result
- The latest stable rerun is now `Lua/.planning/tmp/current-rerun-v10/`.
- The latest package refresh is `Lua/.tools/MapRepair/publish/win-x64-self-contained-20260405-0741/` plus `MapRepair-win-x64-self-contained-20260405-0741.zip`.
- Latest real-map inspection:
- `triggerCount = 569`
- `variableCount = 839`
- `customTextCount = 284` up from `256`
- total `CustomScriptCode` actions = `2634` down from `2731`
- `maxActionCount = 96`
- `maxActionTrigger = item set`
- `extensionNodes = []`
- `eventlessGuiCount = 2` down from `30`
- the only remaining eventless GUI triggers are `Func` and `load`, both with `0` actions

## Remaining Gap
- Manual editor-side validation is still required.
- If the editor still crashes on `v10`, the next likely slice remains the surviving large eventful sequential GUI triggers such as `SET`, `SET2`, and `item set`.
