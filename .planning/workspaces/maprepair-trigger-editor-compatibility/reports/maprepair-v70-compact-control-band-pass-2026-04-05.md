# MapRepair V70 Compact Control-Band Pass

## Goal
- React to the manual editor signal that loading still crashed at `16/569`, which mapped directly to recovered trigger `016-tmdlimititemlvl`.
- Remove the remaining compact `8`-`11` action control-heavy pseudo-GUI bucket that was still surviving after `v15`.

## Trigger Shape Finding
- The reported crash position `16/569` matches `016-tmdlimititemlvl`.
- In `v15`, `tmdlimititemlvl` was still GUI with:
  - `actionCount = 9`
  - `customScriptCount = 7`
  - `controlFlowCount = 6`
- The same compact control-heavy band still contained multiple similar survivors, including:
  - `attack`
  - `J TSJ`
  - `fBSCL`
  - `jianxuan other`
  - `qijian dead`
  - `J BXHJ`
  - `Lock Animation`
  - `bag into`
  - `tmdlimititemlvl`
  - `012`
  - `J LTMT`
  - `removecache`
  - `002`

## Code Changes
- Added a compact control-heavy fallback rule in `JassGuiReconstructionParser` for the `8`-`11` action band:
  - `actionCount` in `8`-`11`
  - `customScriptCount >= 6`
  - `controlFlowCount >= 6`
- Added smoke coverage `gui-compact-control-heavy-pseudo-fallback`.

## Real Map Verification
- Re-ran the real source-backed map into:
  - `tmp/current-rerun-v16/chuzhang V2 mod2.851_repaired_current.w3x`
- Extracted and checked:
  - `tmp/current-rerun-v16/verify/war3map.wtg`
  - `tmp/current-rerun-v16/verify/war3map.wct`
- Passed:
  - `maprepair_wtg_inspect`
  - original checker
  - corrected debug walk
- Real-map metrics:
  - `triggerCount = 569`
  - `customTextCount = 437`
  - `GuiEventNodeCount = 288`
  - `RecoveredGui/index.json count = 569`
  - `repair-report.json RecoveredGuiTriggerIndex count = 569`
  - `extensionNodes = []`
  - compact `8`-`11` control-heavy survivors = `0`
  - focused `12`-`19` survivors = `0`

## Key Result
- `tmdlimititemlvl` is now emitted as `custom-text`.
- Its recorded fallback reason in `v16` is:
  - `Fell back to custom-text because the reconstructed GUI trigger stayed in the compact 8-11 action control-heavy band with 7 custom-script lines and 6 control-flow markers.`
- The code-side route has now cleared all three explicitly tracked risky survivor buckets:
  - `15`-`19` mixed survivors
  - focused `12`-`19` survivors
  - compact `8`-`11` control-heavy survivors

## Publish
- Published:
  - `.tools/MapRepair/publish/win-x64-self-contained-20260405-2306/`
  - `.tools/MapRepair/publish/win-x64-self-contained/`
  - `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260405-2306.zip`

## Next Slice If Manual Validation Still Fails
- Start from `current-rerun-v16` and the matching `20260405-2306` package.
- Since the known `16/569` trigger bucket is now cleared, the next diagnostic slice should pivot to the remaining structured GUI triggers that still contain `CustomScriptCode`, ordered by:
  - highest `actionCount`
  - highest `customScriptCount`
  - highest `eventCount` among non-custom-text survivors
