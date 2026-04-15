# Session

## Current Objective
- Drive the new 15-second prefix-restore harness from `v38` until the newly exposed `034-003 + 035-chakan u` coexistence pair is repaired and the first restored failing prefix moves beyond `035`.

## Step Plan Status
- The earlier `v84/v85` canon headless-chain audit still stands for structural validation, but it is no longer sufficient as the final acceptance signal.
- The user-confirmed split history isolated two independent blockers inside `025-032`:
  - `028-lostitem`
  - `032-herospN`
- The current implementation slice repaired both in `v35`.

## What Changed
- Added real-editor tooling in the task workspace:
  - `tools/editor_open_probe.ps1`
  - `tools/trigger_restore_walk.ps1`
- Enforced a minimum `15`-second probe window and added post-probe cooldown between walk rounds.
- Generated machine-readable walk artifacts:
  - `tmp/v35-prefix-walk-v3/results.jsonl`
  - `tmp/v35-prefix-walk-v3/trigger_fingerprint.json`
  - `tmp/v35-prefix-walk-v4-resume29/results.jsonl`
- Ran the first full prefix walk from the safe all-shell baseline and froze the first fail package.
- Updated `.tools/MapRepair/src/MapRepair.Core/Internal/Gui/JassGuiReconstructionParser.cs` so map-init execution tracing now follows helper functions called from `main`.
- Re-ran the real map into:
  - `tmp/current-rerun-v36/`
- Updated the same parser so very large single-timer structured GUI triggers can conservatively fall back to whole-trigger custom-text.
- Re-ran the real map into:
  - `tmp/current-rerun-v37/`
- Updated the parser again so string-heavy `CreateQuestBJ` single-timer triggers can conservatively fall back to whole-trigger custom-text.
- Re-ran the real map into:
  - `tmp/current-rerun-v38/`
- Resumed the restored-prefix walk from `030` and confirmed the first failing restored prefix now moves to:
  - `035-chakan u`
- Narrowed the new failing prefix to a minimal coexistence pair:
  - `034-003 + 035-chakan u`

## Decisions
- Treat the user's manual editor-open result as authoritative whenever it conflicts with the old `-loadfile` launcher-process heuristic.
- Treat "process still alive after at least 15 seconds" as the only acceptance rule for the new automation.
- Treat shell-associated editor launches as the authoritative automation path; keep `.canon/YDWE` `-loadfile` logs only as structural side evidence.
- Treat `029-attack friend` as the stable first restored failing prefix.
- Treat the old pairwise `001 + 029` / `003 + 029` failures as resolved in the latest rerun line.
- Treat the earlier `029` first-fail state as resolved in `v38`.
- Treat the current open pair as `034-003 + 035-chakan u`.

## Next Actions
- Inspect and repair the `034-003 + 035-chakan u` coexistence pair on top of `v38`.
- After the next fix, rerun `trigger_restore_walk.ps1` from `035`.

## Validation Notes
- `dotnet build .tools/MapRepair/MapRepair.sln -nologo`
  - now succeeds after the `v38` changes
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- ... current-rerun-v36 ...` succeeds.
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- ... current-rerun-v37 ...` succeeds.
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- ... current-rerun-v38 ...` succeeds.
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
  - still stops early on the pre-existing unrelated `gui-executed-eventless-trigger` assertion before it reaches the new quest-timer case

## Debug Findings
- `028-lostitem` in `v35` is now structured GUI:
  - `eventCount = 1`
  - `actionCount = 441`
  - `customScriptCount = 0`
- `032-herospN` in `v35` is now structured GUI:
  - `eventCount = 0`
  - `actionCount = 27`
  - `customScriptCount = 0`
- The first full prefix walk (`tmp/v35-prefix-walk-v3/`) established:
  - all-shell control = pass
  - `028-lostitem` prefix = pass
  - `029-attack friend` prefix = fail
- The resumed walk (`tmp/v35-prefix-walk-v4-resume29/`) reproduced the same first failing prefix at `029`.
- Complementary subset checks first showed:
  - `029-only` = pass
  - `028-029-only` = pass
  - `001-027 + 029` = fail
  - `014-027 + 029` = pass
  - `001-013 + 029` = fail
  - `007-013 + 029` = pass
  - `001-006 + 029` = fail
  - `004-006 + 029` = pass
  - `001 + 029` = fail
  - `002 + 029` = pass
  - `003 + 029` = fail
  - `001-only` = pass
  - `003-only` = pass
- `v36` changes:
  - `003-SET 3` now emits as `MapInitializationEvent`
  - `001 + 029` = pass
  - `003 + 029` = pass
- `v37` changes:
  - `002-SET2` now emits as custom-text
  - `001-003 + 029` = pass
  - `014-027 + 029` = pass
  - `004-013 + 029` = fail
  - `004-006 + 029 only` = pass
  - `007-013 + 029 only` = pass
- `v38` changes:
  - `017-SET 4` now emits as custom-text
  - fallback reason = `10 CreateQuestBJ actions / 2128 constant characters behind a single timer event`
  - `017 + 029 only` = pass
  - `001-029` restored prefix = pass
  - restored prefix walk from `030` now reaches:
    - `030-dubo` = pass
    - `031-fuhuo rock` = pass
    - `032-herospN` = pass
    - `033-001` = pass
    - `034-003` = pass
    - `035-chakan u` = fail
  - complementary narrowing now shows:
    - `034-only` = pass
    - `035-only` = pass
    - `034 + 035` = fail

## Debug State Sync
- Core debug conclusion: the previously isolated `028` and `032` blocker shapes are now repaired in the generated map.
- The `017-SET 4 + 029-attack friend` blocker is now repaired in `v38`.
- Current debug continuation target: targeted repair of the `034-003 + 035-chakan u` coexistence pair.

## Summary Sync
- `PROJECT_SUMMARY.md` should now record:
  - the `v36` `MapInitializationEvent` recovery for `003-SET 3`
  - the `v37` custom-text fallback for `002-SET2`
  - the `v38` quest-timer custom-text fallback for `017-SET 4`
  - the new first failing restored prefix at `035-chakan u`
  - the active `034-003 + 035-chakan u` coexistence pair
