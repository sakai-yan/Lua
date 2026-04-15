# MapRepair v85: Canon YDWE Metadata Alignment And Loop Recovery

## Goal
- Continue the repaired-map editor-open fix by aligning reconstruction metadata to `.canon/YDWE`, cleaning the remaining early mixed survivors, and validating the real editor-open path against a healthy canon demo-map control.

## What Changed
- Updated `GuiMetadataCatalog` to load YDWE extension metadata from `.canon/YDWE/share/mpq`.
- Added array-index helper condition recovery in `GuiArgumentNormalizer`.
- Added multi-guard root-condition recovery in `JassGuiReconstructionParser`.
- Added direct `return(...)` condition recovery for helper functions.
- Added structured recovery for:
  - `ForLoopAMultiple`
  - `ForLoopBMultiple`
  - `ForForceMultiple`
- Re-ran the real map through `MapRepairService` into `tmp/current-rerun-v34/`.
- Re-ran the corrected canon chain probe on `tmp/current-rerun-v34/`.
- Ran one healthy canon demo map through the same `雪月WE.exe -loadfile` path as a control.

## Validation
- Real repaired map:
  - `tmp/current-rerun-v34/`
  - checker = pass
  - `--debug-missing` = pass
  - `wtgloader` = `CHECK PASS`
  - `frontend_trg` = pass
  - `frontend_wtg` = pass
  - `triggerCount = 569`
- Healthy control:
  - `.canon/YDWE/1----雪月编辑器演示-----/[雪月]任务系统.w3x`
  - post-open `worldeditstrings` = present
  - post-open `triggerdata` = present
  - post-open `triggerstrings` = present

## Trigger Reconstruction Findings
- `016-tmdlimititemlvl`
  - recovered back to structured GUI `IfThenElseMultiple`
  - `customScriptCount = 1`
- `018-hantmdweiacunzhuang1`
  - now recovers:
    - 3 GUI root conditions
    - structured outer hero-level gate
    - structured inner local-player gate
    - structured `DisplayTextToPlayer` else branch
  - current risk:
    - `customScriptCount = 1`
    - `controlFlowCount = 0`
- `020-tmdjingong009`
  - now recovers 2 GUI conditions
  - `customScriptCount = 0`
- `002-SET2`
  - now recovers nested `ForLoopAMultiple` / `ForLoopBMultiple`
  - now recovers `ForForceMultiple`
  - `customScriptCount = 0`
- `001-SET`
  - now recovers `ForLoopAMultiple`
  - `customScriptCount` drops from `11` to `5`

## Summary Metrics
- `RecoveredGui.CustomTextTriggerCount` drops to `60`.
- Early front-slice risk now looks materially better than `v30`.

## Canon Open Findings
- The repaired `v34` map still does not reach post-open:
  - `worldeditstrings`
  - `triggerdata`
  - `triggerstrings`
- Instead, it still stops after:
  - `Open map`
  - `wtgloader`-driven `triggerdata.lua` UI-root loading
- Because the healthy control does reach the later markers on the same `-loadfile` path, the manual-open chain remains a valid acceptance signal and the remaining blocker is still real.

## Current Conclusion
- The blocking gap is no longer explained by:
  - canon parser layers
  - missing YDWE extension metadata
  - the old `016` / `018` / `020` front-slice condition gaps
  - the old `002` loop / player-group callback flattening
- The next truthful step is to isolate whether the remaining stop is still trigger-side or has moved to another pre-trigger-panel map surface, then continue with:
  - `019-tmdjingong1`
  - `022-hantmdweiacunzhuang2`
  - residual raw actions in `001-SET`
