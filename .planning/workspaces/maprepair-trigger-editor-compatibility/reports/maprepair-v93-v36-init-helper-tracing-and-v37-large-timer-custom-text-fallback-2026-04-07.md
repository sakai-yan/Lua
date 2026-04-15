# MapRepair v93: Init Helper Tracing And Large Timer Custom-Text Fallback

## Goal
- Continue the `029-attack friend` coexistence line after the first `v35` prefix walk.
- Remove the already proven pairwise failures and push the remaining blocker band forward.

## What Changed
- Updated `JassGuiReconstructionParser.ExtractRunOnMapInitTriggerGlobals()` so it now follows helper functions called from `main` and collects `TriggerExecute` / `ConditionalTriggerExecute` calls one layer deeper.
- Re-ran the real map into `tmp/current-rerun-v36/`.
- Updated `ShouldFallbackPseudoGuiTrigger(...)` with a conservative custom-text fallback for very large single-timer structured GUI triggers.
- Re-ran the real map into `tmp/current-rerun-v37/`.

## Validation
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v36/chuzhang V2 mod2.851_repaired_current.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v36/report`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v37/chuzhang V2 mod2.851_repaired_current.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v37/report`
- Real-editor `15`-second probe checks against focused `MapRepair.Diag --trigger-shell` variants from `v36` and `v37`.

## Findings
- `v36`:
  - `003-SET 3` now emits as GUI with `MapInitializationEvent`.
  - `001 + 029` = pass.
  - `003 + 029` = pass.
  - full `001-029` prefix still = fail.
- `v37`:
  - `002-SET2` now emits as whole-trigger custom-text.
  - `001-003 + 029` = pass.
  - full `001-029` prefix still = fail.
  - `014-027 + 029` = pass.
  - `004-013 + 029` = fail.
  - `004-006 + 029 only` = pass.
  - `007-013 + 029 only` = pass.

## Current Conclusion
- The original `001 + 029` and `003 + 029` pairwise blockers are no longer the active problem.
- The remaining blocker has moved forward to a higher-order coexistence band inside `004-013 + 029`.
