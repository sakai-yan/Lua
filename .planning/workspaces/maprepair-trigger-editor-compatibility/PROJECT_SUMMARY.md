# Project Summary

## Current Mission
- Keep MapRepair's trigger reconstruction route editor-safe and drive the new 15-second prefix-restore harness until the repaired output survives with every trigger restored.

## Context Snapshot
- Task label: MapRepair trigger editor compatibility
- Task slug: maprepair-trigger-editor-compatibility
- Task type(s): bugfix, compatibility, audit
- Project context: brownfield
- Selected pattern: debug-first implementation with manual acceptance handoff
- Planning container: `.planning/`
- Task workspace: `.planning/workspaces/maprepair-trigger-editor-compatibility/`

## Planned Technical Route Baseline
- Keep the narrowed hybrid GUI reconstruction route.
- Emit structured GUI only for base-compatible metadata or map-local embedded GUI extension metadata.
- Collapse risky pseudo-GUI and eventless survivors back to whole-trigger custom-text when needed.
- Preserve recoverable small and medium eventful triggers as GUI skeletons with `CustomScriptCode` when that shape is closer to the healthy sample than the later front-slice whole-trigger custom-text fallback route.
- Preserve healthy-sample raw YDWE extension node names such as ` CreateUnit` while also allowing normalized aliases such as `CreateUnit` to resolve during reconstruction and validation.
- Allow structured recovery to use the full loaded YDWE metadata set when healthy-sample-compatible repo-level nodes exist.
- Recover helper init registrations as GUI events before treating them as opaque init helpers.
- Synthesize `MapInitializationEvent` only when a trigger is executed from `main` and no other recoverable GUI event exists.
- Treat standard four-line guarded boolean condition functions as recoverable GUI `conditions` when they can be parsed back into editor-style `OperatorCompare*` nodes.
- When a trigger falls back to whole-trigger custom-text, preserve the reachable closure as source-backed `war3map.j` slices instead of synthetically reordering functions.
- When a trigger falls back to whole-trigger custom-text, trim the emitted chunk to trigger-local functions plus only init-time direct external helpers; do not recursively pull action-time helper chains or unrelated `Trig_*` / `InitTrig_*` bodies from other triggers into the current chunk.
- Preserve trigger-local comment headers and trigger-local `globals ... endglobals` blocks when they sit directly above the recovered trigger body in source.
- Normalize every emitted non-empty `war3map.wct` custom-text slot to begin with editor-style `//TESH.scrollpos=0` plus `//TESH.alwaysfold=0`, and strip decorative slash-only comment preambles before the real trigger body.
- Record per-trigger risk data into:
  - `report/RecoveredGui/index.json`
  - `repair-report.json -> RecoveredGuiTriggerIndex`

## Inherited Standards and Principles
- Treat validator-backed compatibility gates as mandatory before trusting output.
- Prefer conservative fallback over pseudo-GUI that stops looking editor-readable.
- Treat the trigger-risk index as the authoritative machine-readable narrowing input for future slices.

## Bug Avoidance and Red Flags
- Checker-compatible output can still be editor-hostile.
- Repo-level YDWE extension entries should not be reintroduced as structured GUI without proof.
- Even base-compatible GUI nodes can stay editor-hostile if a trigger body is still dominated by flattened `CustomScriptCode` control flow.
- Custom-text fallback can still be editor-hostile if the emitted `war3map.wct` chunk drops locally-called helper functions, scrambles them away from source order, or drags unrelated trigger bodies or transitive helper chains into the current trigger text.
- If either editor still crashes after `v27` near `16/569`, inspect the few remaining early custom-text triggers or action-side custom-script branches for remaining parse-compatibility gaps below the now-normalized `TESH` editor header before reintroducing the removed front-slice fallback bands.
- After `v28`, the biggest remaining structural mismatch is the missing child-block control-flow layer:
  - healthy sample `totalChildBlocks = 734`
  - repaired `v28` `totalChildBlocks = 0`

## Debug Signals and Inspection Hooks
- Use the internal validator, original YDWE checker, `maprepair_wtg_inspect`, `maprepair_sample_compare`, and the new trigger-risk index as the primary structural signals.

## Reusable Experience and Lessons
- The key MapRepair lessons now live in `LESSONS.md`.
- Older detailed planning prose is preserved in `reports/legacy-*-root-2026-04-05.md`.
- The latest focused stability reports are:
  - `reports/maprepair-v68-focused-12-19-stability-pass-2026-04-05.md`
  - `reports/maprepair-v69-final-stable-band-pass-2026-04-05.md`
  - `reports/maprepair-v70-compact-control-band-pass-2026-04-05.md`
  - `reports/maprepair-v71-custom-text-helper-closure-fix-2026-04-05.md`
  - `reports/maprepair-v72-compact-guarded-front-slice-pass-2026-04-05.md`
  - `reports/maprepair-v73-custom-text-callback-closure-and-smoke-popup-fix-2026-04-06.md`
  - `reports/maprepair-v74-custom-text-init-first-order-fix-2026-04-06.md`
  - `reports/maprepair-v75-custom-text-root-action-order-fix-2026-04-06.md`
  - `reports/maprepair-v76-custom-text-source-slice-preservation-2026-04-06.md`
  - `reports/maprepair-v77-custom-text-local-closure-trim-2026-04-06.md`
  - `reports/maprepair-v78-custom-text-editor-header-normalization-2026-04-06.md`
  - `reports/maprepair-v79-healthy-sample-gui-skeleton-reversion-2026-04-06.md`
  - `reports/maprepair-v80-guarded-condition-node-recovery-2026-04-06.md`
  - `reports/maprepair-v81-ydwe-extension-metadata-and-event-alignment-2026-04-06.md`
  - `reports/maprepair-v82-action-child-block-and-arithmetic-condition-recovery-2026-04-06.md`
  - `reports/maprepair-v83-canon-ydwe-open-chain-audit-2026-04-06.md`
  - `reports/maprepair-v84-canon-manual-open-log-order-correction-2026-04-06.md`
  - `reports/maprepair-v85-canon-ydwe-metadata-alignment-and-loop-recovery-2026-04-06.md`

## Active Improvements
- The workspace is task-scoped and template-compliant instead of sharing a legacy root bundle with unrelated tasks.
- The task now emits machine-readable trigger-risk data for every recovered trigger instead of relying only on per-trigger `.meta.txt` notes.
- The task now has a real-editor `15`-second survival probe plus a prefix-restore walk harness rooted in the `v35` source rerun.
- The task now has a dedicated whole-trigger custom-text fallback for string-heavy `CreateQuestBJ` single-timer triggers such as `017-SET 4`.

## Route Review and Framework Compatibility Notes
- Validation-first continuation still fits the current codebase better than reopening a broad reconstruction rewrite.
- If the crash persists after `v27` near `16/569`, inspect the remaining early custom-text triggers or action-side custom-script branches before pivoting back to structured GUI survivors with `CustomScriptCode`.

## Tooling Guidance
- Workspace-local tools under `tools/` remain the preferred forensic helpers for this task.
- Use source-backed reruns over stale prebuilt helper binaries when acceptance sensitivity matters.
- Use `.canon/YDWE` as the authoritative YDWE runtime; treat historical `.tools/YDWE` references as archived context only.
- Use `RecoveredGui/index.json` instead of ad hoc text scraping when selecting the next survivor slice.
- Use `editor_open_probe.ps1` and `trigger_restore_walk.ps1` as the primary acceptance and narrowing path for real editor survival.
- Treat the `8`-`11`, focused `12`-`19`, and `15`-`19` stable bands as closed diagnostic classes unless later editor feedback directly contradicts the `v16` result.

## Recent Retrospective Signals
- Historical reruns and publish artifacts can confuse latest source behavior unless the current authoritative target is explicit.
- Serializing trigger-risk data directly from the reconstruction result is a safer continuation primitive than rebuilding counts from debug `.lml` text after the fact.
- Once a risky survivor bucket is fully cleared in real-map reruns, the next diagnostic slice should pivot instead of repeatedly retuning the same thresholds.
- A precise manual crash position such as `16/569` can be mapped directly back to the recovered trigger ordering and used to identify the next compact survivor bucket.

## Open Risks and Watch Items
- The user's April 6, 2026 manual validation now proves that the `001-569` trigger-shell variant opens correctly in the real editor, so the remaining blocker is still trigger-side even though the old `-loadfile` launcher heuristic stayed ambiguous.
- The new 15-second prefix walk now makes the next blocker concrete:
  - all-shell control = pass
  - `028-lostitem` prefix = pass
  - `029-attack friend` prefix = fail
- The first failing prefix is now narrowed to interaction-specific pairs rather than single-trigger poison:
  - `029-only` = pass
  - `028-029-only` = pass
  - `001 + 029` = fail
  - `002 + 029` = pass
  - `003 + 029` = fail
  - `001-only` = pass
  - `003-only` = pass
- The current truthful code-side hypothesis is no longer "029 is independently toxic"; it is that the repaired GUI shapes of `001-SET` and `003-SET 3` each still become editor-hostile when `029-attack friend` is also restored.
- `v36` resolves that earlier pairwise hypothesis:
  - `003-SET 3` now emits as `MapInitializationEvent`
  - `001 + 029` = pass
  - `003 + 029` = pass
- `v37` then pushes the remaining failure deeper into a higher-order combined band:
  - `002-SET2` now emits as custom-text
  - `001-003 + 029` = pass
  - `014-027 + 029` = pass
  - `004-013 + 029` = fail
  - `004-006 + 029 only` = pass
  - `007-013 + 029 only` = pass
- `v38` resolves that earlier `029` blocker:
  - `017-SET 4` now emits as custom-text
  - fallback reason = `10 CreateQuestBJ actions / 2128 constant characters behind a single timer event`
  - `017 + 029 only` = pass
  - `001-029` restored prefix = pass
  - the restored-prefix first fail now moves to `035-chakan u`
- The current open problem is therefore no longer the earlier `029` band. It is now the coexistence pair:
  - `034-003`
  - `035-chakan u`
- The newest narrowing shows:
  - `034-only` = pass
  - `035-only` = pass
  - `034 + 035` = fail
- The first complementary split is now user-confirmed:
  - `001-032` crashes at `34/569`
  - `033-569` crashes at `16/569`
- The second complementary split is now user-confirmed:
  - `001-015` crashes at `16/569`
  - `016-032` crashes at `34/569`
- The third complementary split is now user-confirmed:
  - `016-024` crashes at `34/569`
  - `025-032` crashes at `16/569`
- The fourth complementary split is now user-confirmed:
  - `025-028` crashes at `16/569`
  - `029-032` crashes at `16/569`
- The first blocker set therefore spans both halves of `025-032`, while a secondary blocker still exists beyond that band.
- `v35` now fixes the two strongest independently confirmed blockers:
  - `028-lostitem` = GUI, `actionCount 441`, `customScriptCount 0`
  - `032-herospN` = GUI, `eventCount 0`, `actionCount 27`, `customScriptCount 0`
- A temporary all-trigger-shell bridge artifact is now available from the `v35` baseline:
  - `tmp/v35-trigger-shell-all/chuzhang V2 mod2.851_repaired_current_trigger_shell_001_569.w3x`
- The current active manual validation target is now:
  - `tmp/current-rerun-v35/chuzhang V2 mod2.851_repaired_current.w3x`
- Manual editor validation is still pending.
- The corrected `v84` audit shows the unresolved failure now sits between the real editor's `Open map` path and a proven trigger-panel load:
  - checker = pass
  - `wtgloader` = pass
  - `frontend_trg` = pass
  - `frontend_wtg` = pass
  - the last whole-log `triggerdata` / `triggerstrings` markers occur before the last `Open map`
  - the last real editor open logs `Open map`, loads `20` UI roots through `triggerdata.lua`, and exits before the `25`-second observation window ends
- A healthy canon demo map proves the same `-loadfile` path can continue into post-open:
  - `worldeditstrings`
  - `triggerdata`
  - `triggerstrings`
- `v34` still does not reach that phase despite materially cleaner early trigger output.
- The early hook audit found `0` GUI names in the first `32` triggers that depend on `SetGUIId_Hook.cpp` alone.
- The current front slice after `v85` looks materially cleaner:
  - `016-tmdlimititemlvl` = structured GUI again
  - `018-hantmdweiacunzhuang1` = `conditionCount 3`, `customScriptCount 1`, `controlFlowCount 0`
  - `020-tmdjingong009` = `conditionCount 2`, `customScriptCount 0`
  - `002-SET2` = `customScriptCount 0`
  - `001-SET` = `customScriptCount 5`
- The newly fixed `v35` route repaired the previously isolated `028-lostitem` and `032-herospN` blocker shapes; the next likely blocker, if any, should now surface beyond `16/569`.
- Some historical report and rerun artifacts still contain pre-migration root-path text because they were preserved as snapshots.
- `v26` now restores GUI skeletons for most of the first failure band:
  - `SET` = GUI
  - `SET2` = GUI
  - `SET 3` = custom-text
  - the early `baoxiang` cluster = GUI
  - `tmdlimititemlvl` = GUI
- `v27` further restores the early root conditions to true GUI `conditions`:
  - `clc2 baoxiang` = `OperatorCompareItemCode`
  - `tmdlimititemlvl` = `OperatorCompareBoolean`
- The newest packaged GUI build aligned with `v24` is `MapRepair-win-x64-self-contained-20260406-1317.zip`.
- `v24` keeps the same front-slice trigger counts as `v23`, but early emitted custom-text chunks now follow source-backed body shape without dragging transitive non-local helper closure into the current trigger text.
- The healthy raw `War3/map/war3map.wct` sample keeps `TESH` headers on `7/7` non-empty custom-text slots, which the earlier reconstructed `RecoveredGui/*.j` comparison had hidden.
- `v25` now mirrors that editor-authored raw-header shape on `468/468` non-empty custom-text slots while keeping the same `triggerCount = 569`, `customTextCount = 468`, and `GuiEventNodeCount = 257` as `v24`.
- `v26` rolls back the later small and medium front-slice pseudo-GUI fallback route and moves the repaired output back toward the healthy sample style with `customTextCount = 284` and `GuiEventNodeCount = 509`.
- `v27` continues that route with `customTextCount = 277` and `GuiEventNodeCount = 513`, while closing the specific guarded root-condition mismatch found by the healthy sample `LML` export.
- `v28` continues that route by restoring repo-level YDWE metadata and helper-event recovery, dropping `customTextCount` to `229`, growing `war3map.wtg` to `624532` bytes, and shrinking `war3map.wct` to `1529188` bytes, but still leaves `totalChildBlocks = 0`.
- `v83` adds the canon YDWE open-chain audit and confirms the next truthful early survivors remain:
  - `018-hantmdweiacunzhuang1`
  - `020-tmdjingong009`
  - `001-SET`
  - `002-SET2`
- The healthy local `War3/map` sample proves editor-authored custom-text can preserve source order and trigger-local globals, so `v22`'s synthetic ordering assumption is no longer the active route baseline.
- Routine smoke runs are now headless again because the staged `w2l` scenario is opt-in instead of default-on.
- The restored official `.canon/w3x2lni` runtime is healthy enough to convert the real repaired maps produced by the current fixed pipeline when staged with the same smoke-side config adjustments.
- `W3iBinaryWriter` has now been realigned with the official `w3x2lni` `frontend_w3i.lua` layout, so the synthetic smoke map no longer breaks official staged `w2l.exe` at the map-info parse step.
- The opt-in smoke `w2l-lni-reconstruction` path now fails loudly on regression instead of silently downgrading staged `w2l.exe` errors into a skip.

## Update Log
- 2026-04-07: Added a string-heavy `CreateQuestBJ` single-timer custom-text fallback, reran the real map into `tmp/current-rerun-v38/`, confirmed `017-SET 4` now emits as custom-text and that `017 + 029` plus the full `001-029` restored prefix both pass, then resumed the restored-prefix walk from `030` and isolated the new first-fail pair at `034-003 + 035-chakan u`.
- 2026-04-07: Added `editor_open_probe.ps1` and `trigger_restore_walk.ps1`, enforced a minimum `15`-second survival window, ran the first full prefix walk into `tmp/v35-prefix-walk-v3/`, reproduced the same first failing restored prefix at `029-attack friend` in `tmp/v35-prefix-walk-v4-resume29/`, then narrowed the failure down to the coexistence pairs `001 + 029` and `003 + 029` while proving `029-only`, `028-029-only`, `002 + 029`, `001-only`, and `003-only` all stay alive.
- 2026-04-07: Extended map-init execution tracing to follow helper functions called from `main`, reran the map into `tmp/current-rerun-v36/`, and confirmed `003-SET 3` now emits as `MapInitializationEvent` while both `001 + 029` and `003 + 029` pass.
- 2026-04-07: Added a conservative whole-trigger custom-text fallback for very large single-timer structured GUI bodies, reran the map into `tmp/current-rerun-v37/`, and confirmed `002-SET2` now falls back to custom-text, `001-003 + 029` passes, and the remaining failure band moves to `004-013 + 029`.
- 2026-04-06: Added `--trigger-shell` and `--replace-trigger-data` modes to `MapRepair.Diag`, generated focused and binary-split trigger-shell variants under `tmp/v34-trigger-shell-diag/`, adopted the user-confirmed `001-569` full-shell open as the new authoritative acceptance correction, then recorded the first split result (`001-032 -> 34/569`, `033-569 -> 16/569`), the second split result (`001-015 -> 16/569`, `016-032 -> 34/569`), the third split result (`016-024 -> 34/569`, `025-032 -> 16/569`), the fourth split result (`025-028 -> 16/569`, `029-032 -> 16/569`), isolated `028-lostitem` and `032-herospN` as the strongest independent blockers, and fixed both in `current-rerun-v35`.
- 2026-04-05: Migrated the active MapRepair task into its own task workspace and preserved legacy root-format planning notes as report snapshots.
- 2026-04-05: Tightened medium branch-heavy and mixed GUI/custom-script control-flow fallback, then reran the real map into `tmp/current-rerun-v13/`.
- 2026-04-05: Published the matching `v13` desktop GUI package under `.tools/MapRepair/publish/win-x64-self-contained-20260405-1724/` plus `MapRepair-win-x64-self-contained-20260405-1724.zip`.
- 2026-04-05: Added recovered-trigger risk indexing, tightened the focused `12`-`19` action stability rules, and reran the real map into `tmp/current-rerun-v14/`.
- 2026-04-05: Published the matching `v14` desktop GUI package under `.tools/MapRepair/publish/win-x64-self-contained-20260405-1921/` plus `MapRepair-win-x64-self-contained-20260405-1921.zip`.
- 2026-04-05: Broadened the final stable-mode `12`-`19` band collapse, reran the real map into `tmp/current-rerun-v15/`, and confirmed both tracked mid-sized survivor buckets are now empty.
- 2026-04-05: Published the matching `v15` desktop GUI package under `.tools/MapRepair/publish/win-x64-self-contained-20260405-2041/` plus `MapRepair-win-x64-self-contained-20260405-2041.zip`.
- 2026-04-05: Used the user-reported `16/569` crash position to target `tmdlimititemlvl`, added the compact `8`-`11` control-heavy fallback, reran the real map into `tmp/current-rerun-v16/`, and confirmed the compact survivor bucket is now empty.
- 2026-04-05: Published the matching `v16` desktop GUI package under `.tools/MapRepair/publish/win-x64-self-contained-20260405-2306/` plus `MapRepair-win-x64-self-contained-20260405-2306.zip`.
- 2026-04-05: Confirmed `v16` still failed at `16/569`, fixed custom-text helper-closure collection plus source-order emission, reran the real map into `tmp/current-rerun-v17/`, and verified `016-tmdlimititemlvl.j` now includes `Trig_tmdlimititemlvl_Func001C`.
- 2026-04-05: Published the matching `v17` desktop GUI package under `.tools/MapRepair/publish/win-x64-self-contained-20260405-2329/` plus `MapRepair-win-x64-self-contained-20260405-2329.zip`.
- 2026-04-05: Confirmed `v17` still failed at `16/569`, added the compact guarded pseudo-GUI fallback for the `5`-`7` action front slice, reran the real map into `tmp/current-rerun-v18/`, and confirmed the early twelve-trigger `baoxiang` cluster now emits as `custom-text`.
- 2026-04-05: Published the matching `v18` desktop GUI package under `.tools/MapRepair/publish/win-x64-self-contained-20260405-2356/` plus `MapRepair-win-x64-self-contained-20260405-2356.zip`.
- 2026-04-06: Extended custom-text closure collection to preserve generic callback helpers, changed the optional smoke `w2l` stage to skip by default, reran the real map into `tmp/current-rerun-v19/`, and confirmed the callback-closure audit drops to `0` missing `Trig_*` references.
- 2026-04-06: Published the matching `v19` desktop GUI package under `.tools/MapRepair/publish/win-x64-self-contained-20260406-0846/` plus `MapRepair-win-x64-self-contained-20260406-0846.zip`.
- 2026-04-06: Confirmed `v19` still failed at `16/569`, aligned whole-trigger custom-text emission to the sample-map init-first `war3map.wct` ordering, reran the real map into `tmp/current-rerun-v20/`, and confirmed the early custom-text files now start with `InitTrig_*`.
- 2026-04-06: Published the matching `v20` desktop GUI package under `.tools/MapRepair/publish/win-x64-self-contained-20260406-0922/` plus `MapRepair-win-x64-self-contained-20260406-0922.zip`.
- 2026-04-06: Confirmed `v20` still failed at `16/569`, aligned whole-trigger custom-text emission to the stronger sample-derived `InitTrig_* -> Trig_*Actions` function order, reran the real map into `tmp/current-rerun-v22/`, and confirmed the early custom-text files now use `Actions` as the second function.
- 2026-04-06: Published the matching `v22` desktop GUI package under `.tools/MapRepair/publish/win-x64-self-contained-20260406-0951/` plus `MapRepair-win-x64-self-contained-20260406-0951.zip`.
- 2026-04-06: Audited `MapRepair.Smoke` against the restored official `.canon/w3x2lni` package, confirmed routine smoke passes, confirmed the opt-in `w2l` scenario still self-skips after staged `w2l.exe` failure, and separately proved the same staged official runtime can convert the real repaired `v22` map successfully.
- 2026-04-06: Reproduced the opt-in smoke `w2l` failure against the official runtime, traced it to a parser-incompatible smoke-generated `war3map.w3i`, fixed `W3iBinaryWriter`, tightened the opt-in smoke failure semantics, and confirmed full smoke now passes with `MAPREPAIR_SMOKE_RUN_W2L=1`.
- 2026-04-06: Used the newly supplied healthy references plus the local `War3/map` custom-text sample to overturn the `v22` init-first / action-second assumption, changed whole-trigger custom-text emission to preserve source-backed `war3map.j` slices (including trigger-local comment headers and eligible local globals), reran the real map into `tmp/current-rerun-v23/`, and published the matching desktop GUI package under `.tools/MapRepair/publish/win-x64-self-contained-20260406-1242/` plus `MapRepair-win-x64-self-contained-20260406-1242.zip`.
- 2026-04-06: Used the user-confirmed `v23` failure to inspect early custom-text breadth, trimmed emitted chunks back to trigger-local closure plus init-time direct external helpers, added `gui-custom-text-local-closure`, reran the real map into `tmp/current-rerun-v24/`, and published the matching desktop GUI package under `.tools/MapRepair/publish/win-x64-self-contained-20260406-1317/` plus `MapRepair-win-x64-self-contained-20260406-1317.zip`.
- 2026-04-06: Compared the raw healthy-sample `war3map.wct` against the raw `v24` output, discovered that the healthy sample keeps `TESH` headers on every non-empty custom-text slot while `v24` had none, normalized emitted custom-text headers plus decorative-comment preambles, reran the real map into `tmp/current-rerun-v25/`, and confirmed raw `v25` now has `468/468` non-empty `WCT` slots with `TESH` headers while checker and `maprepair_wtg_inspect` still pass.
- 2026-04-06: Reacted to the user's “copy the healthy sample” direction, removed the small and medium front-slice pseudo-GUI fallback bands, updated smoke to assert GUI-skeleton retention, reran the real map into `tmp/current-rerun-v26/`, and confirmed the repaired output moved back toward the healthy sample style with `customTextCount = 284` and `GuiEventNodeCount = 509`.
- 2026-04-06: Reacted to the user's `v26` failure report, dumped the healthy sample's real `WTG/WCT` into `tmp/healthy-sample-lml/`, identified that the repaired front slice still kept root conditions as action-time custom-script guards, recovered standard guarded boolean condition functions back into GUI `OperatorCompare*` nodes, reran the real map into `tmp/current-rerun-v27/`, and confirmed `customTextCount = 277`, `GuiEventNodeCount = 513`, `clc2 baoxiang = OperatorCompareItemCode`, and `tmdlimititemlvl = OperatorCompareBoolean`.
- 2026-04-06: Fixed YDWE quoted raw-name metadata handling, broadened structured recovery back onto the full loaded YDWE metadata set, recovered helper init events before opaque fallback, synthesized `MapInitializationEvent` only when no other GUI events exist, reran the real map into `tmp/current-rerun-v28/`, and confirmed `customTextCount = 229`, `war3map.wtg = 624532`, `war3map.wct = 1529188`, and the remaining dominant gap is still `totalChildBlocks = 0`.
- 2026-04-06: Added action-side `IfThenElseMultiple` child-block recovery plus recursive nested-risk counting, reran the real map into `tmp/current-rerun-v29/`, and confirmed `customTextCount = 199`, `totalChildBlocks = 377`, and `IfThenElseMultiple = 161`.
- 2026-04-06: Added arithmetic infix expression normalization for integer and real GUI call nodes, reran the real map into `tmp/current-rerun-v30/`, and confirmed `016-tmdlimititemlvl` now emits as a real GUI `IfThenElseMultiple` with `OperatorIntegerAdd(GetHeroLevel(GetTriggerUnit()), 1)`, while `customTextCount = 197` and `totalChildBlocks = 382`.
- 2026-04-06: Added the canon YDWE open-chain audit tools, switched active YDWE validation from historical `.tools/YDWE` assumptions to `.canon/YDWE`, ran the initial `v30` chain audit, and confirmed the repaired map passes checker, `wtgloader`, `frontend_trg`, and `frontend_wtg`, while the next early survivor remains `018-hantmdweiacunzhuang1`.
- 2026-04-06: Corrected the manual-open log-order interpretation in `canon_ydwe_chain_probe.ps1`, reran the `v30` canon audit, and confirmed the last whole-log `triggerdata` / `triggerstrings` markers are startup lines before the last `Open map`; the real editor instead logs `Open map`, loads `20` UI roots through `triggerdata.lua`, and exits before a proven trigger-panel load.
- 2026-04-06: Aligned reconstruction metadata to `.canon/YDWE`, added array-index helper recovery, multi-guard root-condition recovery, direct `return(...)` helper recovery, and structured `ForLoopAMultiple` / `ForLoopBMultiple` / `ForForceMultiple` recovery, reran the real map through `v34`, and confirmed the early front slice is materially cleaner even though the real editor still stops before post-open `worldeditstrings` / `triggerdata` / `triggerstrings`.

## 2026-04-06 v82 Update
- `tmp/current-rerun-v30/` is now the primary manual validation target.
- The earlier `v28` child-block gap has been materially narrowed:
  - `v28`: `customTextCount = 229`, `totalChildBlocks = 0`
  - `v29`: `customTextCount = 199`, `totalChildBlocks = 377`
  - `v30`: `customTextCount = 197`, `totalChildBlocks = 382`
- The user-reported `16/569` slice now has a new code-side state:
  - `016-tmdlimititemlvl` writes as a root GUI condition plus an action-side `IfThenElseMultiple`
  - its helper-backed comparison now normalizes `GetHeroLevel(GetTriggerUnit()) + 1` into `OperatorIntegerAdd(...)`
- If `v30` still fails near `16/569`, the next early mixed survivors should be inspected in this order:
  - `018-hantmdweiacunzhuang1`
  - `020-tmdjingong009`
  - `001-SET`
  - `002-SET2`
- The current route baseline now includes `reports/maprepair-v82-action-child-block-and-arithmetic-condition-recovery-2026-04-06.md`.

## 2026-04-06 v83 Update
- `tmp/current-rerun-v30/chain-audit.json` is now the authoritative canon audit artifact.
- The canon chain reaches every expected parser layer:
  - checker = pass
  - `--debug-missing` = pass
  - `wtgloader` = `CHECK PASS`
  - `frontend_trg` = pass
  - `frontend_wtg` = pass
  - `triggerCount = 569`
- The initial `v83` manual-open read treated whole-log `triggerdata` / `triggerstrings` markers as if they belonged to the last `Open map`.
- Early hook-only GUI names: `0`
- The next remaining early mixed-control-flow survivors stay:
  - `018-hantmdweiacunzhuang1`
  - `020-tmdjingong009`
  - `001-SET`
  - `002-SET2`

## 2026-04-06 v84 Update
- `reports/maprepair-v84-canon-manual-open-log-order-correction-2026-04-06.md` now records the corrected editor-open classification.
- The headless canon chain still reaches every expected parser layer:
  - checker = pass
  - `--debug-missing` = pass
  - `wtgloader` = `CHECK PASS`
  - `frontend_trg` = pass
  - `frontend_wtg` = pass
  - `triggerCount = 569`
- The corrected real-editor state is:
  - last fresh `Open map` marker = present
  - post-open `triggerdata.lua` UI loads = `20`
  - post-open `triggerdata` / `triggerstrings` markers = absent
  - editor exits before the `25`-second observation window ends
- The next remaining early mixed-control-flow survivors still stay:
  - `018-hantmdweiacunzhuang1`
  - `020-tmdjingong009`
  - `001-SET`
  - `002-SET2`

## 2026-04-06 v85 Update
- `reports/maprepair-v85-canon-ydwe-metadata-alignment-and-loop-recovery-2026-04-06.md` now records the current reconstruction changes and the healthy demo-map control open.
- Metadata loading now uses `.canon/YDWE/share/mpq` instead of the missing historical `.tools/YDWE` tree.
- `v34` materially cleans the early front slice:
  - `016-tmdlimititemlvl` = structured GUI `IfThenElseMultiple`
  - `018-hantmdweiacunzhuang1` = structured outer / inner / local-player condition flow with `customScriptCount = 1`
  - `020-tmdjingong009` = `customScriptCount = 0`
  - `002-SET2` = structured `ForLoopAMultiple`, `ForLoopBMultiple`, and `ForForceMultiple`
  - `001-SET` = structured `ForLoopAMultiple`
- `RecoveredGui.CustomTextTriggerCount` drops to `60`.
- The real canon editor still stops before post-open `worldeditstrings` / `triggerdata` / `triggerstrings`, while a healthy canon demo map does reach those markers on the same `-loadfile` path.
*** Add File: D:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\reports\maprepair-v84-canon-manual-open-log-order-correction-2026-04-06.md
# MapRepair v84: Canon Manual-Open Log-Order Correction

## Goal
- Correct the `v83` manual-open interpretation by validating the canon YDWE open path against the last `Open map` event instead of against the whole accumulated `kkwe.log`.

## What Changed
- Updated `.planning/workspaces/maprepair-trigger-editor-compatibility/tools/canon_ydwe_chain_probe.ps1` so manual-open classification now:
  - scopes progress markers to the last fresh `Open map`
  - records whether the editor stayed alive or exited inside the observation window
  - records post-open `triggerdata.lua` UI-load evidence separately from whole-log startup markers
- Re-ran the corrected probe against `tmp/current-rerun-v30/`.

## Canon Source Chain
- `.canon/YDWE/source/Development/Component/script/ydwe/w3x2lni/open_map.lua`
  - logs `Open map`
  - calls `wtgloader(mappath)`
- `.canon/YDWE/source/Development/Component/script/ydwe/w3x2lni/wtgloader.lua`
  - loads trigger metadata through `triggerdata.lua`
  - returns immediately when the checker passes
- `.canon/YDWE/source/Development/Component/script/ydwe/triggerdata.lua`
  - logs `Loading ui from ...` for each UI root it merges
- `.canon/YDWE/source/Development/Component/script/ydwe/uiloader.lua`
  - emits `virtual_mpq 'triggerdata'` / `virtual_mpq 'triggerstrings'` as startup watcher callbacks
  - those markers are not reliable proof of progress after the last `Open map`

## Validation
- `canon_ydwe_chain_probe.cmd .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v30`
- Headless results:
  - checker = pass
  - `--debug-missing` = pass
  - `wtgloader` = `CHECK PASS`
  - `frontend_trg` = pass
  - `frontend_wtg` = pass
  - `triggerCount = 569`
- Corrected manual-open results:
  - last fresh `Open map` marker = present
  - last whole-log `triggerdata` marker line < last `Open map` line
  - last whole-log `triggerstrings` marker line < last `Open map` line
  - post-open `triggerdata.lua` UI loads = `20`
  - post-open `triggerdata` / `triggerstrings` markers = absent
  - editor exits before the `25`-second observation window ends

## Findings
- `v83` overclaimed the manual-open progress because it checked for `triggerdata` / `triggerstrings` anywhere in the log, not only after the last `Open map`.
- `v30` still clears the full canon headless parser chain, so the blocking gap is no longer:
  - WTG byte layout
  - unknown-UI metadata recovery
  - canonical `frontend_trg`
  - canonical `frontend_wtg`
- The unresolved gap now stays inside the real editor open path after `open_map.lua` / `wtgloader` begins loading UI metadata and before a proven trigger-panel load.
- The first truthful early survivor remains `018-hantmdweiacunzhuang1`, because:
  - `016-tmdlimititemlvl` is now a compact GUI `IfThenElseMultiple`
  - `017-SET 4` is pure GUI
  - `018-hantmdweiacunzhuang1` still mixes one recovered `IfThenElseMultiple` with `11` `CustomScriptCode` nodes and raw helper-guard `if` / `else` / `endif` wrappers

## Next Target
- Inspect `018-hantmdweiacunzhuang1` first.
- Follow-up order after that:
  - `020-tmdjingong009`
  - `001-SET`
  - `002-SET2`
