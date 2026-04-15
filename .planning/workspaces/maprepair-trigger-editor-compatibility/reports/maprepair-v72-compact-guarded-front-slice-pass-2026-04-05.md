# MapRepair V72 Compact Guarded Front-Slice Pass

## Goal
- React to the user confirmation that `v17` still stopped at `16/569`.
- Remove the early compact guarded pseudo-GUI cluster that still sat in the first 16 recovered triggers.

## Trigger Shape Finding
- In `v17`, the first-16 slice still contained twelve compact GUI survivors such as:
  - `clc2 baoxiang`
  - `clc1 baoxiang`
  - `czd1 baoxiang`
  - `czd2 baoxiang`
  - `czc1 baoxiang`
  - `czc2 baoxiang`
  - `czc3 baoxiang`
  - `czc4 baoxiang`
  - `czd3 baoxiang`
  - `czd5 baoxiang`
  - `czc5 baoxiang`
  - `czc6 baoxiang`
- Their common shape was:
  - `actionCount = 5`
  - `customScriptCount = 4`
  - `controlFlowCount = 3`
  - one preserved root-condition guard rendered as:
    - `if not Trig_*_Conditions() then`
    - `return`
    - `endif`
- The previous fallback rules started at the `8`-`11` control-heavy band, so this compact guarded class had never been collapsed.

## Code Changes
- Added a compact guarded pseudo-GUI fallback rule in `JassGuiReconstructionParser` for triggers that:
  - keep a root-condition guard
  - stay in the `5`-`7` action band
  - still contain `4+` custom-script lines
  - still contain `3+` control-flow markers
  - still retain custom-script body content after the guard prelude
- Added smoke coverage `gui-compact-guarded-pseudo-fallback`.

## Real Map Verification
- Re-ran the real source-backed map into:
  - `tmp/current-rerun-v18/chuzhang V2 mod2.851_repaired_current.w3x`
- Extracted and checked:
  - `tmp/current-rerun-v18/verify/war3map.wtg`
  - `tmp/current-rerun-v18/verify/war3map.wct`
- Passed:
  - `maprepair_wtg_inspect`
  - original checker
  - corrected debug walk
- Real-map metrics:
  - `triggerCount = 569`
  - `customTextCount = 468`
  - `GuiEventNodeCount = 257`
  - `extensionNodes = []`
  - `maxActionTrigger = item set`
  - `maxActionCount = 96`

## Key Result
- The early twelve-trigger `baoxiang` compact guarded cluster now emits as `custom-text` in `v18`.
- The first 16 recovered triggers now contain only one structured GUI trigger:
  - `017-SET 4`
- `004-clc2 baoxiang.j` now emits as whole-trigger custom text with:
  - `Trig_clc2_baoxiang_Conditions`
  - `Trig_clc2_baoxiang_Actions`
  - `InitTrig_clc2_baoxiang`

## Publish
- Published:
  - `.tools/MapRepair/publish/win-x64-self-contained-20260405-2356/`
  - `.tools/MapRepair/publish/win-x64-self-contained/`
  - `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260405-2356.zip`

## Next Slice If Manual Validation Still Fails
- Start from `current-rerun-v18` and the matching `20260405-2356` package.
- If either editor still stops at `16/569`, treat that as evidence that the failure is now inside the early custom-text slice rather than the previously surviving compact guarded GUI cluster.
- If the failure position moves later, pivot to the remaining structured GUI triggers that still contain `CustomScriptCode`, starting from:
  - `SET BB`
  - `Axxfz11`
  - `jianxuan7`
  - `J WSDBZ`
  - `tmdjingong dead`
