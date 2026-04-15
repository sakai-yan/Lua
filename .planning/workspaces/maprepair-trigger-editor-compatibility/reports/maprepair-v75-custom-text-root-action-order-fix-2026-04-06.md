# MapRepair V75 Custom-Text Root-Action Order Fix

## Goal
- React to the user confirmation that `v20` still stopped at `16/569`.
- Align early custom-text chunks with the stronger sample-map function-order pattern where the second function is `Trig_*Actions`.

## Findings / Root Cause
- Sample-map extractions under `tmp/ydwe-audit-sample-v1/RecoveredGui/*.j` showed a stronger invariant than the earlier init-first finding:
  - every sample custom-text chunk starts with `InitTrig_*`
  - every sample custom-text chunk uses `Trig_*Actions` as the second function
- `current-rerun-v20/report/RecoveredGui/*.j` still violated that pattern for many early triggers because the closure collector was still walking the init body itself first, which naturally queued:
  - `TriggerAddCondition(...)`
  - before `TriggerAddAction(...)`
- That meant the practical output order for many early triggers stayed:
  - `InitTrig_*`
  - `Trig_*_Conditions`
  - `Trig_*Actions`
- The user-reported `016-tmdlimititemlvl` stop still matched that remaining mismatch.

## Fix / Mitigation
- Changed `JassGuiReconstructionParser.CollectFunctionClosure(...)` so the init function no longer re-seeds closure order from its own registration body.
- The init function now acts only as the chunk anchor; root action functions are queued ahead of root condition functions, and remaining helper closure follows afterward.
- Updated smoke assertions so the compact control and guarded custom-text scenarios require the root action function immediately after `InitTrig_*`.

## Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- Re-ran the real map into:
  - `tmp/current-rerun-v22/chuzhang V2 mod2.851_repaired_current.w3x`
- Extracted and checked:
  - `tmp/current-rerun-v22/verify/war3map.wtg`
  - `tmp/current-rerun-v22/verify/war3map.wct`
- Passed:
  - `maprepair_wtg_inspect`
  - original checker
  - corrected debug walk
- `current-rerun-v22` kept:
  - `triggerCount = 569`
  - `customTextCount = 468`
  - `GuiEventNodeCount = 257`
  - `extensionNodes = []`
- Early `v22` custom-text files now begin with:
  - `InitTrig_SET2 -> Trig_SET2_Actions`
  - `InitTrig_clc2_baoxiang -> Trig_clc2_baoxiang_Actions`
  - `InitTrig_tmdlimititemlvl -> Trig_tmdlimititemlvl_Actions`

## Publish
- New rerun validation target:
  - `tmp/current-rerun-v22/chuzhang V2 mod2.851_repaired_current.w3x`
- Published the matching desktop GUI build under:
  - `.tools/MapRepair/publish/win-x64-self-contained-20260406-0951/`
  - `.tools/MapRepair/publish/win-x64-self-contained/`
  - `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260406-0951.zip`

## Next Slice If Manual Validation Still Fails
- Start from `current-rerun-v22`.
- If either editor still stops at `16/569`, compare the early custom-text body content itself against sample-map bodies, because the known closure and ordering mismatches are now all closed.
- If the failure point moves, pivot to the next structured GUI survivors using `RecoveredGui/index.json`.
