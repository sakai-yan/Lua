# MapRepair V71 Custom-Text Helper Closure Fix

## Goal
- React to the user confirmation that `v16` still crashed while the editor read triggers at `16/569`.
- Audit whether the `custom-text` fallback for `016-tmdlimititemlvl` still emitted an editor-hostile `war3map.wct` closure.

## Findings / Root Cause
- `v16` already downgraded `tmdlimititemlvl` to whole-trigger `custom-text`, but its emitted `016-tmdlimititemlvl.j` still omitted `Trig_tmdlimititemlvl_Func001C` even though `Trig_tmdlimititemlvl_Actions` called it directly.
- `JassGuiReconstructionParser.CollectFunctionClosure(...)` only followed callback-style references such as:
  - `Condition(function ...)`
  - `TriggerAddAction/TriggerAddCondition(... function ...)`
  - `ExecuteFunc("...")`
- It did not follow ordinary local helper calls such as `if ( Trig_*_Func001C() ) then`, so the generated `war3map.wct` text could stay checker-compatible while still being structurally incomplete for editor-side trigger loading.

## Fix / Mitigation
- Extended `JassGuiReconstructionParser` so custom-text closure discovery now also scans direct local function calls while skipping language keywords.
- Changed custom-text emission to preserve source-order function output for the included closure, instead of queue order.
- Tightened `MapRepair.Smoke` coverage for `gui-compact-control-heavy-pseudo-fallback` so it now asserts:
  - the helper function is present in emitted custom text
  - the helper stays ahead of the action body in the serialized closure

## Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- Re-ran the real map into:
  - `tmp/current-rerun-v17/chuzhang V2 mod2.851_repaired_current.w3x`
- Extracted and checked:
  - `tmp/current-rerun-v17/verify/war3map.wtg`
  - `tmp/current-rerun-v17/verify/war3map.wct`
- Passed:
  - `maprepair_wtg_inspect`
  - original checker
  - corrected debug walk
- `016-tmdlimititemlvl.j` in `v17` now includes:
  - `Trig_tmdlimititemlvl_Conditions`
  - `Trig_tmdlimititemlvl_Func001C`
  - `Trig_tmdlimititemlvl_Actions`
  - `InitTrig_tmdlimititemlvl`
- Real-map metrics remain structurally aligned with `v16`:
  - `triggerCount = 569`
  - `customTextCount = 437`
  - `GuiEventNodeCount = 288`
  - `extensionNodes = []`
  - `maxActionTrigger = item set`
  - `maxActionCount = 96`

## Publish
- Published:
  - `.tools/MapRepair/publish/win-x64-self-contained-20260405-2329/`
  - `.tools/MapRepair/publish/win-x64-self-contained/`
  - `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260405-2329.zip`

## Next Slice If Manual Validation Still Fails
- Start from `current-rerun-v17` and the matching `20260405-2329` package.
- If either editor still stops around `16/569`, inspect the earliest custom-text triggers for any remaining unresolved local-helper or closure-shape gaps before reopening the already-cleared pseudo-GUI survivor buckets.
- If the failure point moves past the early custom-text slice, then pivot back to the remaining structured GUI triggers that still contain `CustomScriptCode`.
