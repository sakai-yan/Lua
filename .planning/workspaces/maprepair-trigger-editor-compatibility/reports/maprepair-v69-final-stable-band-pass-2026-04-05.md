# MapRepair V69 Final Stable-Band Pass

## Goal
- Apply the final stable-mode collapse after the `v14` manual validation failure by removing every remaining `12`-`19` action structured GUI survivor that still combined control-flow with custom-script body content.

## Code Changes
- Broadened the focused `12`-`19` stability rule in `JassGuiReconstructionParser` so the band now falls back whenever:
  - `actionCount` is `12`-`19`
  - there is still any control-flow marker in the trigger
  - and the trigger body still contains custom-script lines after the simple-GUI retention check
- This turns the prior focused rule into the final stable-mode for the `12`-`19` band.

## Smoke Coverage
- Kept all previous focused-band smoke cases green.
- Added `gui-final-stable-band-pseudo-fallback` to cover the FUBEN-style shape:
  - synthesized root-condition guard
  - multiple custom-script side-effect body lines
  - no reliance on extra nested body control-flow beyond the guard itself

## Real Map Verification
- Re-ran the real source-backed map into:
  - `tmp/current-rerun-v15/chuzhang V2 mod2.851_repaired_current.w3x`
- Extracted and checked:
  - `tmp/current-rerun-v15/verify/war3map.wtg`
  - `tmp/current-rerun-v15/verify/war3map.wct`
- Passed:
  - `maprepair_wtg_inspect`
  - original checker
  - corrected debug walk
- Real-map metrics:
  - `triggerCount = 569`
  - `customTextCount = 424`
  - `GuiEventNodeCount = 306`
  - `RecoveredGui/index.json count = 569`
  - `repair-report.json RecoveredGuiTriggerIndex count = 569`
  - `extensionNodes = []`
  - `15`-`19` mixed survivors = `0`
  - focused `12`-`19` survivors = `0`

## Result
- The previously remaining `13` focused `12`-`19` survivors are now gone.
- The code-side route has now cleared both of the explicitly tracked risky survivor buckets:
  - `15`-`19` mixed survivors
  - `12`-`19` focused control-flow survivors
- The task is now blocked only on manual dual-editor validation of `v15`.

## Publish
- Published:
  - `.tools/MapRepair/publish/win-x64-self-contained-20260405-2041/`
  - `.tools/MapRepair/publish/win-x64-self-contained/`
  - `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260405-2041.zip`

## Next Slice If Manual Validation Still Fails
- Start from `current-rerun-v15` and the matching `20260405-2041` package.
- Since the tracked `12`-`19` survivor buckets are now cleared, the next diagnostic slice should pivot to the remaining structured GUI triggers that still contain any `CustomScriptCode`, ordered by:
  - highest `actionCount`
  - highest `customScriptCount`
  - presence of control-flow markers outside the already-cleared stability bands
