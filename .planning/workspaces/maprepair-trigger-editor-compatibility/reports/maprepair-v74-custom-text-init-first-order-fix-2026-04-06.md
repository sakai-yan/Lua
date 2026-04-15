# MapRepair V74 Custom-Text Init-First Order Fix

## Goal
- React to the user confirmation that `v19` still stopped at `16/569`.
- Align emitted `war3map.wct` custom-text chunks with the ordering pattern used by real editor-authored maps.

## Findings / Root Cause
- Good-sample extractions under `tmp/ydwe-audit-sample-v1/RecoveredGui/*.j` showed a stable pattern:
  - every custom-text chunk starts with `InitTrig_*`
- The same sample map's compiled `war3map.j` does not keep that order, which proved the editor-authored `war3map.wct` body order is not the same as raw compiled-script source order.
- `current-rerun-v19/report/RecoveredGui/*.j` still emitted all `468` custom-text chunks in `war3map.j` source order, so every chunk started with non-init functions such as:
  - `Trig_*_Conditions`
  - `Trig_*_Actions`
  - helper functions like `H2I`
- The first `16` recovered triggers in the real map were almost entirely custom-text, so this mismatch was a plausible explanation for the user-reported editor stop at `16/569` even while:
  - `maprepair_wtg_inspect`
  - the original checker
  - the corrected debug walk
  all still passed.

## Fix / Mitigation
- Changed `JassGuiReconstructionParser` so whole-trigger custom-text closure output is no longer serialized in raw `war3map.j` source order.
- The new ordering now:
  - starts with `InitTrig_*`
  - places trigger-local entry functions before the remaining reachable helper closure
- Updated smoke assertions so:
  - `gui-custom-text-callback-closure`
  - `gui-compact-control-heavy-pseudo-fallback`
  now lock the init-first ordering expectation.

## Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- Re-ran the real map into:
  - `tmp/current-rerun-v20/chuzhang V2 mod2.851_repaired_current.w3x`
- Extracted and checked:
  - `tmp/current-rerun-v20/verify/war3map.wtg`
  - `tmp/current-rerun-v20/verify/war3map.wct`
- Passed:
  - `maprepair_wtg_inspect`
  - original checker
  - corrected debug walk
- `current-rerun-v20` kept:
  - `triggerCount = 569`
  - `customTextCount = 468`
  - `GuiEventNodeCount = 257`
  - `extensionNodes = []`
- Early `v20` custom-text files now begin with:
  - `InitTrig_SET2`
  - `InitTrig_tmdlimititemlvl`
  - `InitTrig_hantmdweiacunzhuang1`

## Publish
- New rerun validation target:
  - `tmp/current-rerun-v20/chuzhang V2 mod2.851_repaired_current.w3x`
- Published the matching desktop GUI build under:
  - `.tools/MapRepair/publish/win-x64-self-contained-20260406-0922/`
  - `.tools/MapRepair/publish/win-x64-self-contained/`
  - `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260406-0922.zip`

## Next Slice If Manual Validation Still Fails
- Start from `current-rerun-v20`.
- If either editor still stops at `16/569`, compare the early custom-text bodies against sample-map body shape beyond ordering, especially:
  - root init-body layout
  - condition/action/helper body shape inside the same chunk
- If the failure point moves, pivot to the next structured GUI survivors using `RecoveredGui/index.json`.
