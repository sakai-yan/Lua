# MapRepair v92: Prefix Restore Harness And 029 Interaction Narrowing

## Goal
- Replace the stale one-shot `v35` manual-open placeholder with a repeatable real-editor `15`-second survival harness.
- Use that harness to identify the first restored failing prefix from the `v35` all-shell-safe baseline.

## What Changed
- Added `.planning/workspaces/maprepair-trigger-editor-compatibility/tools/editor_open_probe.ps1`.
- Added `.planning/workspaces/maprepair-trigger-editor-compatibility/tools/trigger_restore_walk.ps1`.
- Enforced a minimum `15`-second window in both tools.
- Added source fingerprint emission so later reruns can resume from the first changed ordinal instead of restarting blindly.
- Added automatic first-fail freezing:
  - `results.jsonl`
  - `last-pass.json`
  - `first-fail.json`
  - `variant-manifest.md`
  - `diagnostics/structural-compare.json`

## Validation
- `powershell -NoProfile -ExecutionPolicy Bypass -File .planning/workspaces/maprepair-trigger-editor-compatibility/tools/editor_open_probe.ps1 -MapPath <all-shell-map> -EditorRoot .canon/YDWE -TimeoutSeconds 15`
- `powershell -NoProfile -ExecutionPolicy Bypass -File .planning/workspaces/maprepair-trigger-editor-compatibility/tools/trigger_restore_walk.ps1 -SourceMap tmp/current-rerun-v35/chuzhang V2 mod2.851_repaired_current.w3x -IndexJson tmp/current-rerun-v35/report/RecoveredGui/index.json -OutputRoot tmp/v35-prefix-walk-v3 -StartOrdinal 1 -EndOrdinal 569 -TimeoutSeconds 15`
- `powershell -NoProfile -ExecutionPolicy Bypass -File .planning/workspaces/maprepair-trigger-editor-compatibility/tools/trigger_restore_walk.ps1 -SourceMap tmp/current-rerun-v35/chuzhang V2 mod2.851_repaired_current.w3x -IndexJson tmp/current-rerun-v35/report/RecoveredGui/index.json -OutputRoot tmp/v35-prefix-walk-v4-resume29 -StartOrdinal 29 -EndOrdinal 569 -TimeoutSeconds 15`
- Additional complementary subset maps were generated with `MapRepair.Diag --trigger-shell` and validated through `editor_open_probe.ps1`.

## Findings
- The all-shell control is stable at the real-editor `15`-second gate.
- The first full walk established:
  - `028-lostitem` prefix = pass
  - `029-attack friend` prefix = fail
- The resumed walk from `029` reproduced the same first failing restored prefix.
- Complementary subset results:
  - `029-only` = pass
  - `028-029-only` = pass
  - `001-027 + 029` = fail
  - `014-027 + 029` = pass
  - `001-013 + 029` = fail
  - `007-013 + 029` = pass
  - `001-006 + 029` = fail
  - `004-006 + 029` = pass
  - `001-003 + 029` = fail
  - `004-006 + 029` = pass
  - `001 + 029` = fail
  - `002 + 029` = pass
  - `003 + 029` = fail
  - `001-only` = pass
  - `003-only` = pass
- Therefore `029-attack friend` is not independently toxic. The current failure is interaction-specific and already narrowed to:
  - `001-SET` with `029-attack friend`
  - `003-SET 3` with `029-attack friend`

## Current Conclusion
- The old narrative around a lingering generic `16/569` blocker is now obsolete for the active `v35` line.
- The next truthful implementation slice is to make `001-SET` and `003-SET 3` coexist safely with `029-attack friend`, then rerun the prefix walk from `029`.
