# MapRepair v94: v38 Quest-Timer Fallback and New `034 + 035` Pair

## Goal
- Remove the `v37` first failing restored prefix at `029-attack friend` without reopening the already cleared earlier trigger slices.

## What Changed
- Added a new whole-trigger custom-text fallback for string-heavy `CreateQuestBJ` single-timer triggers.
- Re-ran the real map into `tmp/current-rerun-v38/`.
- Resumed the restored-prefix walk from `030`.
- Followed up with complementary shell probes after the first new fail surfaced.

## Validation
- `dotnet build .tools/MapRepair/MapRepair.sln -nologo`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v38/chuzhang V2 mod2.851_repaired_current.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v38/report`
- `editor_open_probe.ps1`
  - `v38 full map` = fail
  - `v38 017 + 029 only` = pass
  - `v38 001-029 restored prefix` = pass
  - `v38 034-only` = pass
  - `v38 035-only` = pass
  - `v38 034 + 035` = fail
- `trigger_restore_walk.ps1` from `030`
  - `030-dubo` = pass
  - `031-fuhuo rock` = pass
  - `032-herospN` = pass
  - `033-001` = pass
  - `034-003` = pass
  - `035-chakan u` = fail

## Findings
- `017-SET 4` now falls back to custom-text in `v38`.
- The recovered trigger index now records:
  - `fallback reason = Fell back to custom-text because the reconstructed GUI trigger packed 10 CreateQuestBJ actions with 2128 constant characters behind a single timer event.`
- The earlier minimal failing pair is resolved:
  - `017 + 029` = pass
- The entire `001-029` restored prefix now survives the `15`-second gate.
- The new first failing restored prefix is `035-chakan u`.
- `035-chakan u` is not independently toxic:
  - `035-only` = pass
- `034-003` is not independently toxic:
  - `034-only` = pass
- The new truthful minimal pair is:
  - `034-003 + 035-chakan u`

## Next Target
- Inspect the coexistence between:
  - `034-003`
  - `035-chakan u`
- Decide whether to fall `035-chakan u` back to whole-trigger custom-text or to narrow the structured recovery on `034-003`.
- Re-run the restored-prefix walk from `035` after the next narrow fix.
