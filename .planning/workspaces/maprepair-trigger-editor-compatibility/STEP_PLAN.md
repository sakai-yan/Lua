# Step Plan

## Current Step
- Name: Repair the `v38` `034-003 + 035-chakan u` coexistence pair
- Parent phase: Phase 1
- Why now: `v38` fixed the earlier `017-SET 4 + 029-attack friend` blocker, the `001-029` restored prefix now survives the `15`-second gate, and the first failing restored prefix moved to `035-chakan u`.

## Step Objective
- Use `tmp/current-rerun-v38/` as the authoritative repaired-map baseline.
- Treat the newly isolated coexistence pair as the active implementation target:
  - `034-003`
  - `035-chakan u`
- Decide whether the next narrow fix should:
  - fall `035-chakan u` back to whole-trigger custom-text
  - relax or rebalance the structured recovery for `034-003`
  - or repair their coexistence without reopening the cleared `001-029` band

## Requirement Alignment
- This keeps the task grounded in the real editor acceptance gate instead of the stale headless `-loadfile` exit heuristic.
- This continues the approved debug-first route with a new narrow code slice after the `v38` blocker shift.

## Planned Technical Route
- Keep `tmp/current-rerun-v38/` as the authoritative repaired-map baseline.
- Preserve the new string-heavy quest-timer custom-text fallback that converted `017-SET 4` into custom-text in `v38`.
- Use the new restored-prefix walk as the active acceptance gate:
  - `030-569` = pass
  - `034-003` = last pass
  - `035-chakan u` = first fail
- Use complementary shell probes to keep the next narrowing pair explicit before widening scope again.

## Framework Compatibility Review
- This route still fits the surrounding framework because it keeps the new `v38` fallback and only retargets the next pair that the real editor now exposes.
- The next code change should stay narrow and should not reopen the cleared `017 + 029` path.

## Detail Resolution Focus
- Record the `v38` shift:
  - `017-SET 4`
    - `custom-text`
    - fallback reason = `string-heavy CreateQuestBJ timer`
  - `017 + 029` = pass
  - `001-029` restored prefix = pass
  - new first failing restored prefix = `035-chakan u`
- Record the new pairwise narrowing:
  - `034-only` = pass
  - `035-only` = pass
  - `034 + 035` = fail
- Keep the next shape review explicit:
  - `034-003`
    - GUI
    - `eventCount = 1`
    - `conditionCount = 2`
    - `actionCount = 32`
    - `customScriptCount = 0`
  - `035-chakan u`
    - GUI
    - `eventCount = 1`
    - `conditionCount = 1`
    - `actionCount = 17`
    - `customScriptCount = 15`

## Required Inputs
- `TASKS.md`
- `SESSION.md`
- `PROJECT_SUMMARY.md`
- `tmp/current-rerun-v38/report/repair-report.json`
- `tmp/current-rerun-v38/report/RecoveredGui/017-SET 4.j`
- `tmp/current-rerun-v38/report/RecoveredGui/034-003.lml`
- `tmp/current-rerun-v38/report/RecoveredGui/035-chakan u.lml`
- `.tools/MapRepair/src/MapRepair.Core/Internal/Gui/JassGuiReconstructionParser.cs`

## Relevant Project Memory
- The new real-editor `15`-second harness remains the authoritative acceptance gate.
- The earlier `029` blocker is no longer the truthful first fail after the `v38` `017-SET 4` fallback.

## Standards / Bug Avoidance Applied
- Prefer the user's real editor result over inferred launcher-process exit codes when those disagree.
- Add smoke coverage whenever a fallback rule is relaxed.
- Keep unrelated pre-existing smoke failures separate from the new implementation slice.

## Completion Standard
- `v38` remains the authoritative rerun and its repaired trigger shapes are confirmed locally.
- The newly isolated `034 + 035` pair is explicit and truthful.
- The next code-side slice is narrowed before any broader rerun.

## Temporary Detailed Actions
- 1. Inspect the structured `034-003` nested GUI tree against the script-heavy `035-chakan u` GUI tree.
- 2. Decide the next narrow fallback or reconstruction tweak for that pair.
- 3. Add targeted smoke coverage if the new rule is generic.
- 4. Re-run the real map into `tmp/current-rerun-v39/`.
- 5. Resume the restored-prefix walk from `035`.

## Validation
- `dotnet build .tools/MapRepair/MapRepair.sln -nologo`
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
  - note: the run still stops early on the pre-existing unrelated `gui-executed-eventless-trigger` assertion before reaching the new quest-timer scenario
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- ... current-rerun-v38 ...`
- `editor_open_probe.ps1`
  - `v38 full map` = fail
  - `v38 017 + 029 only` = pass
  - `v38 001-029 prefix` = pass
  - `v38 034-only` = pass
  - `v38 035-only` = pass
  - `v38 034 + 035` = fail

## Replan / Abort Conditions
- The next narrowed `034 + 035` fix still leaves the first failing restored prefix at `035`.
- Another unrelated post-`035` blocker overtakes the current pair.

## Summary Updates Expected
- Record that `017-SET 4` now falls back to whole-trigger custom-text in `v38`.
- Record that the restored-prefix first fail moved from `029` to `035`.
- Record that the current active pair is `034-003 + 035-chakan u`.
