# Session

## Objective
- Eliminate the repaired-map trigger-load crash by keeping reconstructed `war3map.wtg/wct` inside an editor-compatible GUI vocabulary and trigger-tree shape while preserving runtime behavior.

## Current Status
- The requested YDWE-source audit slice is complete.
- Two new reports capture the result:
- `.planning/workspaces/maprepair-trigger-editor-compatibility/reports/ydwe-war3mapj-to-gui-audit-2026-04-05.md`
- `.planning/workspaces/maprepair-trigger-editor-compatibility/reports/ydwe-war3mapj-to-gui-repro-2026-04-05.md`
- The audit-specific sample rerun is under `.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/ydwe-audit-sample-v1/`.
- That audit confirms that repo-local YDWE does not contain a direct `war3map.j -> GUI -> war3map.wtg/wct` reconstruction chain; GUI restoration is driven by `TriggerData` metadata plus `war3map.wtg/wct`, while `war3map.j` is used for compile/save, optimization, text conversion, and reference scanning.
- Core implementation for the current editor-compatibility slice is complete.
- `MapRepair.Smoke` passes on the current build, including `gui-extension-compatibility-fallback`, `gui-all-custom-pseudo-fallback`, `gui-small-branchy-pseudo-fallback`, `gui-script-heavy-pseudo-fallback`, `gui-compact-pseudo-fallback`, `gui-medium-pseudo-fallback`, and `gui-large-pseudo-fallback`.
- The current source-backed repaired real-map rerun is under `Lua/.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v12/`.
- The latest source-backed repaired real-map output from that rerun passes the original YDWE checker and the corrected bridge `--debug-missing` walk.
- The latest published GUI package is under `Lua/.tools/MapRepair/publish/win-x64-self-contained-20260405-1055/`, with timestamped zip `MapRepair-win-x64-self-contained-20260405-1055.zip`.
- The intermediate `20260405-1016` package reintroduced `584` extension-only GUI nodes into the real repaired map and aligned with the user-reported editor crash.
- The latest rerun-side WTG inspection is back to `extensionNodes = []`.
- The latest rerun no longer forces every trigger to remain GUI:
- `569` triggers
- `839` variables
- `284` whole-trigger custom-text fallbacks
- `2634` `CustomScriptCode` action nodes
- max trigger action count remains `96`
- max surviving GUI trigger is still `item set`, a sequential setup trigger with `96` actions and `0` control-flow custom-script markers
- remaining small risky GUI trigger count is now `0` under the current fallback rules
- whole-trigger custom-text fallbacks now emit empty GUI trees instead of mixed custom-text plus preserved event roots
- `topEvents` counts drop materially in `current-rerun-v8`, confirming that the `256` custom-text triggers no longer retain event ECA roots in `war3map.wtg`
- sample comparison confirms that protected / extension-heavy `war3map.j` loses large amounts of editor trigger semantics relative to a true editor-readable `war3map.wtg`
- the latest eventless-GUI fallback pass reduces non-trivial eventless GUI triggers from `30` to `2`; only `Func` and `load` remain, both with `0` actions
- corrected sample forensics show that the real-sample WTG decode failure on `MFEvent_SkillUGet` is a GUI-side alias gap only; the symbol is absent from `war3map.j`, while `65` init functions instead survive as opaque helper registrations dominated by `MFCTimer_layExeRecTg`.

## Key Evidence Collected
- `SetGUIId_Hook.cpp` confirms that the editor restores GUI by resolving WTG node names to GUI ids first and then emitting JASS through the registered GUI handlers.
- `w3x2lni`'s `frontend_lml.lua` / `backend_wtg.lua` path confirms that old-format custom-text triggers normally serialize as `wct = 1` with an empty GUI trigger tree unless an explicit `.lml` body is also present.
- The real `一世之尊` sample and the reconstructed-from-`war3map.j` sample differ sharply:
- real sample: `18` categories, `20` vars, `120` triggers, `4` non-empty trigger texts
- reconstructed sample: `1` category, `4` vars, `89` triggers, `65` custom-text fallbacks, `13` recoverable GUI events
- In the sample, the `89` reconstructed triggers match the `InitTrig_*` count exactly, proving that at least `31` editor-visible triggers do not survive in compiled script as normal `InitTrig_*` definitions.
- Sample `InitTrig_*` bodies contain only `13` standard `TriggerRegister*` calls, which exactly matches the reconstructed sample's `GuiEventNodeCount = 13`.
- The improved sample compare run shows `66` opaque helper registrations across the `89` init functions, dominated by `MFCTimer_layExeRecTg` (`63`) plus `MHItemRemoveEvent_Register` (`2`) and `MHHeroGetExpEvent_Register` (`1`).
- The real-sample WTG decode failure symbol `MFEvent_SkillUGet` does not occur anywhere in `war3map.j`, confirming that the checker's missing-alias stop is not evidence that script-side reconstruction must import extra unknown-ui definitions.
- The YDWE-source audit also confirms the corresponding positive chain:
- `uiloader.lua` virtualizes `UI\\TriggerData.txt` / `UI\\TriggerStrings.txt`
- `frontend_trg.lua` builds GUI metadata from those files
- `frontend_wtg.lua` / `backend_wtg.lua` and `frontend_wct.lua` / `backend_wct.lua` are the real GUI binary codecs
- `SetGUIId_Hook.cpp` maps WTG node names back to editor GUI ids
- Sample helper/event wrappers such as `MFCTimer_layExeRecTg` and some extension registrations are not semantically recoverable from protected script because key helper bodies are reduced to stubs like `ConvertRace(0); return`.
- Script-visible function names in `war3map.j` are now reconstructed as structured GUI only when they resolve through base-compatible metadata or map-local embedded GUI extension metadata.
- The rerun-side extension-node regression is closed again:
- latest rerun output has `extensionNodes = []`
- latest rerun output still passes the original checker and the corrected debug walk
- The latest fallback layers now convert:
- oversized pseudo-GUI outliers such as `DB lv1`, `duihuanwupin`, `MZ`, `MZ 2`, `TZ1`, `TZ2`, `hecheng S1`, `lianhua Cw`, `exp and gold`, `BD dead`, and `hero chose3`
- medium-size dense pseudo-GUI triggers such as `save`, `e`, `JX`, `JX 2`, `FX`, `FX 2`, `QX`, `QX 2`, `MZYY`, `MZYY 2`, `hero chose2`, `lianhua Sw`, `hecheng C1`, `hecheng C2`, `tuilingpeifang2`, and `miaozhaizhimen4`
- script-heavy compact survivors such as `010 u`, `GX`, `GX 2`, `DX`, `DX 2`, `YF`, `YF 2`, `js`, `js 2`, `lianhua Cf`, `J HLSUNIT`, `kuangshi set`, `C1baoxiang`, `C2baoxiang`, `C3baoxiang`, and `J SMYD`
- smaller all-custom or branch-heavy pseudo-GUI survivors such as `hero chose1`, `J baoji1`, `J LLS`, `005`, `yabiaoa`, `yabiaoc`, `tamuzhigen4`, and `zhiguliangyao4`
- The latest source-backed real-map audit reports `RemainingSmallRiskyGuiCount = 0` for the small all-custom / branch-heavy thresholds added in this slice.

## Route Changes Accepted
- Keep the hybrid GUI reconstruction route.
- Prefer reconstructing script-visible GUI calls only when they resolve through base-compatible metadata or map-local embedded GUI extension metadata; downgrade repo-level YDWE extension entries back to `CustomScriptCode`.
- Fall back oversized, dense, compact, and script-heavy pseudo-GUI triggers to whole-trigger custom-text when reconstruction still flattens too much raw script into GUI action lists.
- Fall back `20+` action triggers to whole-trigger custom-text when they stay almost entirely `CustomScriptCode` or still encode dense raw control flow as small pseudo-GUI bodies.
- Fall back non-trivial eventless GUI triggers to whole-trigger custom-text when no recoverable GUI events or conditions remain and the trigger body still contains multiple actions or any `CustomScriptCode`.
- Do not treat repo-local checker failures on GUI-only aliases from the sample real WTG as script-side reconstruction blockers; use helper-registration analysis instead, and only preserve structured GUI when the relevant function names still survive in `war3map.j`.

## Remaining Work
- Manual editor-side validation is still needed to confirm that the newest repaired output no longer crashes while reading triggers.
- If the crash is still reproducible on the newest package, the next implementation slice should inspect the remaining large sequential GUI survivors such as `SET`, `SET2`, and `item set`, and also sanity-check whether any surviving real-map init patterns resemble the sample's helper-registered triggers rather than missing unknown-ui aliases.
- Future acceptance checks should keep using the source-backed harness or `dotnet run` entry points when current MapRepair source behavior matters.
- Trigger-load compatibility findings for this slice are recorded in `.planning/workspaces/maprepair-trigger-editor-compatibility/reports/maprepair-v61-sample-j-vs-wtg-and-eventless-fallback-2026-04-05.md`.
- Corrected sample-forensics findings for the unknown-alias/helper-registration question are recorded in `.planning/workspaces/maprepair-trigger-editor-compatibility/reports/maprepair-v62-sample-helper-forensics-2026-04-05.md`.
- The latest publish refresh for manual validation is recorded in `.planning/workspaces/maprepair-trigger-editor-compatibility/reports/maprepair-v65-extension-node-regression-fix-2026-04-05.md`.
- The new YDWE-source audit reports should be reused when future discussion drifts toward “reuse YDWE directly for `war3map.j -> GUI` reconstruction”; the answer is now source-backed instead of inferential.

## 2026-04-05 Addendum
- The standalone `W3x2Lni` warning `没有转换触发器 / 请设置YDWE关联地图` was traced to repo-local `ydwe_path.lua` lookup drift, not to a fresh `war3map.wtg/wct` checker failure.
- Repo-local standalone and plugin `w3x2lni` copies now accept the workspace-local `.tools/YDWE` layout and structure-based YDWE roots such as `share/ui`, `share/mpq`, `plugin`, or the current `雪月WE.exe` packaging.
