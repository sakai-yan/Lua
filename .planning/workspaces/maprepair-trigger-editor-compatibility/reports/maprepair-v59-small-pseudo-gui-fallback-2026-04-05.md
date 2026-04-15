# MapRepair V59 Small Pseudo-GUI Fallback

## Goal
- Continue reducing editor-side trigger-load crash risk after the earlier compact / script-heavy fallback passes still left many `20`-`34` action GUI triggers that were almost entirely `CustomScriptCode` or still encoded dense raw control flow.

## Findings
- The latest `current-rerun-v6` report still kept risky small pseudo-GUI survivors such as `hero chose1`, `J baoji1`, `J LLS`, `005`, `yabiaoa`, `yabiaoc`, `tamuzhigen4`, and `zhiguliangyao4`.
- Those bodies were smaller than the previous fallback thresholds, but they still looked unlike normal editor-authored GUI trees.
- The unresolved risk had shifted from very large pseudo-GUI triggers to smaller `20+` action trigger bodies that remained nearly all script or branch-heavy raw control flow.

## Fix
- Added a small all-custom fallback in `JassGuiReconstructionParser` for `20+` action triggers whose reconstructed bodies keep at most one structured GUI action.
- Added a small branch-heavy fallback for `20+` action triggers with `18+` `CustomScriptCode` lines and `8+` control-flow markers.
- Added smoke coverage through:
- `gui-all-custom-pseudo-fallback`
- `gui-small-branchy-pseudo-fallback`

## Verification
- `MapRepair.Smoke` passes with the new fallback scenarios plus the existing large / medium / compact / script-heavy pseudo-GUI coverage.
- Re-ran the current source-backed real map into `Lua/.planning/tmp/current-rerun-v7/`.
- Extracted latest repaired output still passes:
- original YDWE `fix-wtg/checker.lua`
- corrected bridge `--debug-missing` walk
- `maprepair_wtg_inspect` on the latest rerun reports:
- `extensionNodes = []`
- `customTextCount = 256`
- `maxActionCount = 96`
- `maxActionTrigger = item set`
- top `CustomScriptCode` action count reduced to `2731`
- Report-side audit of `RecoveredGui/*.lml` shows:
- `RemainingSmallRiskyGuiCount = 0`

## Published Artifact
- Versioned publish directory:
- `.tools/MapRepair/publish/win-x64-self-contained-20260405-0636/`
- Versioned zip:
- `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260405-0636.zip`

## Remaining Gap
- Direct editor-side proof is still pending because the Warcraft editor is not available in this environment.
- If the crash is still reproducible on this build, the next slice should inspect the remaining large sequential GUI survivors such as `SET`, `SET2`, and `item set`, or apply an even stricter fallback to flat `CustomScriptCode` inside `36`-`96` action setup triggers.
