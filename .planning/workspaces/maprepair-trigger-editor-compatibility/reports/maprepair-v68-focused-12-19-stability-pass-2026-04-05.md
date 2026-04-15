# MapRepair V68 Focused 12-19 Stability Pass

## Goal
- Implement the stable-priority follow-up slice after `v13` by adding machine-readable recovered-trigger risk indexing and collapsing the remaining `12`-`19` action mixed pseudo-GUI shapes that were still plausible editor crash candidates.

## Code Changes
- Added per-trigger recovered risk entries to the repair output:
  - `report/RecoveredGui/index.json`
  - `repair-report.json -> RecoveredGuiTriggerIndex`
- Recorded risk fields per recovered trigger:
  - `name`
  - `isCustomText`
  - `eventCount`
  - `conditionCount`
  - `actionCount`
  - `customScriptCount`
  - `controlFlowCount`
  - `fallbackReason`
  - `matchedPrivateSemantics`
- Tightened `JassGuiReconstructionParser` with a second stability-focused fallback layer:
  - `15`-`19` action mixed pseudo-GUI fallback
  - synthesized root-condition guard plus extra body control-flow fallback
  - `12`-`19` action control-flow plus non-trivial custom-script side-effect fallback
- Kept the prior safety boundaries unchanged:
  - no repo-level extension-node reintroduction
  - whole-trigger custom-text still emits an empty GUI tree

## Smoke Coverage
- Added and passed:
  - `gui-focused-mixed-pseudo-fallback`
  - `gui-guarded-mixed-pseudo-fallback`
  - `gui-script-side-effect-mixed-pseudo-fallback`
- Smoke also now asserts that:
  - `RecoveredGui/index.json` exists
  - `repair-report.json` contains `RecoveredGuiTriggerIndex`
  - the trigger risk index covers every recovered trigger in the sample reconstruction path

## Real Map Verification
- Re-ran the real source-backed map into:
  - `tmp/current-rerun-v14/chuzhang V2 mod2.851_repaired_current.w3x`
- Extracted and checked:
  - `tmp/current-rerun-v14/verify/war3map.wtg`
  - `tmp/current-rerun-v14/verify/war3map.wct`
- Passed:
  - `maprepair_wtg_inspect`
  - original checker
  - corrected debug walk
- Real-map metrics:
  - `triggerCount = 569`
  - `customTextCount = 411`
  - `GuiEventNodeCount = 327`
  - `RecoveredGui/index.json count = 569`
  - `repair-report.json RecoveredGuiTriggerIndex count = 569`
  - `extensionNodes = []`
  - `15`-`19` mixed survivors = `0`
  - remaining focused `12`-`19` GUI survivors with control-flow and custom script = `13`

## Remaining Focused 12-19 Survivors
- `quntijitui` (`14 / 9 / 3`)
- `xiaoyun` (`14 / 6 / 3`)
- `biaoche 2` (`14 / 6 / 3`)
- `FUBEN1` (`13 / 11 / 3`)
- `zidongheyao2` (`13 / 9 / 9`)
- `t2` (`13 / 8 / 3`)
- `J HY X` (`13 / 8 / 3`)
- `J2` (`13 / 8 / 3`)
- `set goldandwood` (`13 / 6 / 6`)
- `FUBEN5` (`12 / 10 / 3`)
- `J WDSXXRH` (`12 / 9 / 3`)
- `J HYZ` (`12 / 9 / 3`)
- `J QXJF2` (`12 / 8 / 3`)

## Publish
- Published:
  - `.tools/MapRepair/publish/win-x64-self-contained-20260405-1921/`
  - `.tools/MapRepair/publish/win-x64-self-contained/`
  - `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260405-1921.zip`

## Next Slice If Manual Validation Still Fails
- Start from `current-rerun-v14` and the matching `20260405-1921` package.
- Inspect the `13` remaining focused `12`-`19` survivors first.
- If either editor still crashes after that narrowed slice, switch to the final stable mode:
  - collapse every `12`-`19` action survivor that still has control-flow plus non-trivial custom-script body content.
