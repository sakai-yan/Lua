# Tasks

## Active
- Use the new `v38` prefix-restore artifacts as the authoritative gate:
  - `tmp/current-rerun-v38/`
  - `tmp/v38-prefix-check-029/`
  - `tmp/v38-prefix-walk-resume30/`
  - `tmp/v38-034-035-check/`
- Current first failing restored prefix:
  - `035-chakan u`
  - latest failing prefix map: `tmp/v38-prefix-walk-resume30/variants/035-chakan u-prefix.w3x`
- Current narrowing state:
  - `v38`: `017-SET 4` = custom-text
  - `v38`: `017 + 029 only` = pass
  - `v38`: `001-029 restored prefix` = pass
  - `v38`: `034-only` = pass
  - `v38`: `035-only` = pass
  - `v38`: `034 + 035` = fail

## Ready
- Inspect the `034-003` nested structured GUI tree against the script-heavy `035-chakan u` GUI tree.
- Decide whether `035-chakan u` should fall back to whole-trigger custom-text or whether the coexistence bug is better fixed through `034-003`.
- After the next fix, rerun `trigger_restore_walk.ps1` from `035`.

## Blocked
- Final end-to-end proof still depends on the shell-associated real editor process remaining alive for the full 15-second window.

## Done
- Added `.planning/workspaces/maprepair-trigger-editor-compatibility/tools/editor_open_probe.ps1`.
- Added `.planning/workspaces/maprepair-trigger-editor-compatibility/tools/trigger_restore_walk.ps1`.
- Enforced a minimum `15`-second survival window in both real-editor probes and prefix walks.
- Generated `trigger_fingerprint.json` for the `v35` source rerun and the walk outputs.
- Ran the first full prefix walk into `tmp/v35-prefix-walk-v3/` and established:
  - control = pass
  - last pass = `028-lostitem`
  - first fail = `029-attack friend`
- Re-ran from `029` into `tmp/v35-prefix-walk-v4-resume29/` and reproduced the same first fail.
- Narrowed the original `v35` interaction band down to trigger-specific combinations:
  - `001 + 029` = fail
  - `003 + 029` = fail
  - `002 + 029` = pass
  - `001-only` = pass
  - `003-only` = pass
- Added recursive init-helper tracing and reran into `tmp/current-rerun-v36/`.
- Confirmed in `v36`:
  - `003-SET 3` now emits as `MapInitializationEvent`
  - `001 + 029` = pass
  - `003 + 029` = pass
- Added a large single-timer custom-text fallback and reran into `tmp/current-rerun-v37/`.
- Confirmed in `v37`:
  - `002-SET2` now emits as custom-text
  - `001-003 + 029` = pass
  - `014-027 + 029` = pass
  - `004-013 + 029` remains the current failing combined band
- Added a string-heavy `CreateQuestBJ` single-timer custom-text fallback and reran into `tmp/current-rerun-v38/`.
- Confirmed in `v38`:
  - `017-SET 4` now emits as custom-text
  - `017 + 029 only` = pass
  - `001-029` restored prefix = pass
  - the first failing restored prefix moved to `035-chakan u`
  - `034-only` = pass
  - `035-only` = pass
  - `034 + 035` = fail
- Added `.planning/workspaces/maprepair-trigger-editor-compatibility/tools/canon_ydwe_chain_probe.cmd` plus the supporting canon frontend probe, then corrected the manual-open log-order classification in `canon_ydwe_chain_probe.ps1`.
- Aligned `GuiMetadataCatalog` to `.canon/YDWE`, added array-index helper recovery, multi-guard root-condition recovery, direct `return(...)` condition recovery, and structured `ForLoopAMultiple` / `ForLoopBMultiple` / `ForForceMultiple` recovery through `v34`.
- Added `--trigger-shell` and `--replace-trigger-data` modes to `.tools/MapRepair/src/MapRepair.Diag/Program.cs`.
- User-confirmed the split chain that isolated the first blocker set down to `025-032`, then showed both `025-028` and `029-032` independently preserved the first crash.
- Implemented:
  - rawcode-compatible `SetVariable` normalization
  - structured eventless-trigger retention when the trigger is explicitly executed elsewhere
  - large all-`SetVariable` GUI trigger retention
- Added smoke coverage for:
  - executed eventless GUI triggers
  - large structured `SetVariable` triggers
- Re-ran the real map into `tmp/current-rerun-v35/` and confirmed:
  - `028-lostitem` = GUI, `actionCount 441`, `customScriptCount 0`
  - `032-herospN` = GUI, `eventCount 0`, `actionCount 27`, `customScriptCount 0`
  - `RecoveredGui.CustomTextTriggerCount` dropped from `60` to `50`
