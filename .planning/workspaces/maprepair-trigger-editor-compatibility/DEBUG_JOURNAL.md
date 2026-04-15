# Debug Journal

## Audit Focus / Symptom
- V25 repaired map can now be opened, but editor fidelity still breaks in three places:
- Buff object data is not readable.
- Custom object names fall back to stock/template names.
- Imported-file names/path entries become blank under `war3mapImported\`.

## Reproduction / Baseline
- User-confirmed baseline: V25 can be opened by the target Warcraft editor.
- V25 repair report confirms generated:
- `war3map.w3a`
- `war3map.w3h`
- `war3map.w3q`
- `war3map.w3t`
- `war3map.w3u`
- `war3map.imp`
- V25 repair report also confirms imported payload files still exist by readable names, including `war3mapImported\*.blp`.

## Signals and Debug Interfaces
- `.tools/MapRepair/src/MapRepair.Core/MapRepairService.cs`
- `.tools/MapRepair/src/MapRepair.Core/Internal/SlkObjectRebuilder.cs`
- `.tools/MapRepair/src/MapRepair.Core/Internal/ObjectDataFileWriter.cs`
- `.tools/MapRepair/src/MapRepair.Core/Internal/ObjectMetadataLoader.cs`
- `.tools/MapRepair/src/MapRepair.Core/Internal/ImportListWriter.cs`
- `.tools/MapRepair/src/MapRepair.Core/Internal/War3ImportFileReader.cs`
- `.tools/MapRepair/chuzhang V2 mod2.851_repair_report_v25/repair-report.md`
- `.tools/MapRepair/chuzhang V2 mod2.851_repaired_v25_diag/diagnostic-variants.md`

## Hypotheses
- `war3map.imp` issue:
- The regenerated import file is likely semantically wrong for the editor because the writer emits one fixed flag byte and does not preserve original import metadata.
- Custom-name issue:
- The rebuild path currently depends on map-embedded SLKs plus stock metadata. If custom names are missing from those SLKs, the rebuilt object data will naturally fall back to stock names.
- A secondary possibility is that object-data serialization or base-id selection is wrong enough that string fields are ignored by the editor.
- Buff issue:
- `war3map.w3h` may require behavior that the current generic object-data writer path does not satisfy.

## Experiments
- Read the V25 orchestration path in `MapRepairService`.
- Read object-data reconstruction in `SlkObjectRebuilder`.
- Read object serialization in `ObjectDataFileWriter`.
- Read import reconstruction in `ImportListWriter` and import parsing in `War3ImportFileReader`.
- Cross-checked the V25 repair report and diagnostic-variant manifest.

## Findings / Root Cause
- Confirmed: V25 rebuilt imports from the repaired archive entry names, not from preserved original import metadata.
- Confirmed: V25 object reconstruction is SLK-first and metadata-driven.
- Confirmed: unit/item/buff rebuild shares one generic object-data writer path, while ability/upgrade has specialized handling.
- Confirmed: the old import writer used a single fixed flag byte for every entry, which was a strong candidate for the blank import-manager rows.
- Implemented: import entries are now modeled as `flag + stored path`, original `war3map.imp` metadata is preserved when readable, and only missing importable archive paths are synthesized.
- Verified locally: smoke now covers both standard-path and custom-path import entries surviving a repair round with their original flags and stored paths intact.
- Proven: custom ability/unit/item/buff names are absent from the inspected embedded SLK name fields and instead live in archive profile text overlays under `Units/*.txt`.
- Implemented: archive profile text overlays are now merged into rebuilt object data for ability/unit/item/buff/upgrade profile fields.
- Not yet proven: whether Buff compatibility fails because of format assumptions, base-id guessing, or missing source data.

## Fix / Mitigation Verification
- `dotnet build .tools/MapRepair/MapRepair.sln -nologo`
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/tools/maprepair_runner/MapRepair.Run.csproj -- <input> <output> <report>`
- `dotnet run --project .planning/tools/maprepair_name_probe/MapRepair.NameProbe.csproj`
- Generated validation artifact:
- `d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\chuzhang V2 mod2.851_repaired_v26.w3x`
- `d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\chuzhang V2 mod2.851_repaired_v27.w3x`

## Session Sync Summary
- The active mission is now clearly MapRepair V25 fidelity, not Motion/UI continuation.
- The `war3map.imp` fix is implemented locally.
- The name-overlay fix is also implemented locally and awaiting editor-side confirmation in `v27`.

## Task Board Sync
- Active: validate `v27` name restoration in the editor
- Ready: `w3b/w3d` follow-up if needed, Buff-specific compatibility
- Blocked: full editor-side correctness proof remains manual
- Done: V25 implementation snapshot, `war3map.imp` preservation fix, local build/smoke, name-source probe, text-overlay merge, and `v26` / `v27` output generation

## Retained Debug Interfaces
- The V25 repair report
- Diagnostic variants
- The new implementation snapshot report in `.planning/reports`

## Cleanup
- None.

## Next Questions
- Do destructable/doodad names come from a different source than the `Units/*.txt` overlays?
- Does `war3map.w3h` need a dedicated writer or record layout?

## 2026-03-30 Asset-Fidelity Round

### Audit Focus / Symptom
- The user reports that `v32` now restores the object editors structurally, but many entries still show missing icon/model files.

### Hypotheses
- The safer `v31/v32` rollback may have narrowed unit/ability profile overlays too far, leaving icon/model fields unwritten even though the source text still contains them.
- The repair pipeline may still be dropping readable imported assets because it only copies entries discovered from `(listfile)` and readable `war3map.imp`.

### Experiments
- Re-ran `maprepair_name_probe` and confirmed source overlay text still contains fields such as unit `Art`, ability `Art`, and ability `TargetArt`.
- Dumped representative rebuilt objects from `v32` and confirmed custom unit `uico` and custom ability `aart / atat` were missing.
- Patched `MapRepairService` to preserve readable `.blp/.mdx/.mdl` files inferred from known profile-text and embedded SLK sources.
- Patched `SlkObjectRebuilder` to restore unit `Art` and ability `Art / TargetArt` while keeping tooltip-heavy fields out.
- Built, smoke-tested, and generated `chuzhang V2 mod2.851_repaired_v33.w3x`.

### Findings / Root Cause
- Confirmed: the `v31/v32` safety rollback dropped unit `Art` and ability art/model profile fields from rebuilt object data.
- Confirmed: protected-map imports referenced from `Units/*.txt` / embedded SLKs can still be readable in the source archive even when absent from `(listfile)` and the readable `war3map.imp` entry set.
- Confirmed locally in `v33`: representative custom units now carry `uico`, representative custom abilities now carry `aart / atat`, and the report now preserves previously missing assets such as `AJ9i.blp`, `AT7i.blp`, `AY18i.blp`, and `WingOfTheLucifer.MDX`.

### Fix / Mitigation Verification
- `dotnet build .tools/MapRepair/MapRepair.sln -nologo`
- `dotnet .tools/MapRepair/src/MapRepair.Smoke/bin/Debug/net8.0/MapRepair.Smoke.dll`
- `dotnet run --project .planning/tools/maprepair_runner/MapRepair.Run.csproj -- <input> <output> <report>`
- `dotnet run --no-build --project .planning/tools/maprepair_object_dump/MapRepair.ObjectDump.csproj -- <map> war3map.w3u <ids> <rawcodes> false`
- `dotnet run --no-build --project .planning/tools/maprepair_object_dump/MapRepair.ObjectDump.csproj -- <map> war3map.w3a <ids> <rawcodes> true`

### Session Sync Summary
- The active validation target is now `v33`, not `v32`.
- Local proof now covers both archive-level asset preservation and object-data-level art/model field recovery.
- Final proof is still blocked on manual Warcraft editor validation.

## 2026-03-30 V34 Correction

### Audit Focus / Symptom
- The user corrected the interpretation of the bug: `v32` object-data fields were already complete, `v33` crashes when opening the skill object editor, and the real remaining issue is missing imported payload files behind recorded paths.

### Findings / Root Cause
- Confirmed: `v33` mixed two changes together, and the field-expansion half was unsafe.
- Confirmed: preserving assets by text/SLK sources alone is not the right mental model; original object-data binaries themselves are authoritative path sources when the editor already shows complete fields.

### Fix / Mitigation
- Reverted `SlkObjectRebuilder` field widening back to the safer `v32` field set.
- Added `ObjectDataAssetCollector` so `MapRepair` now extracts file paths directly from original object-data binaries and preserves those assets by path when readable.
- Added smoke coverage proving an asset referenced only from object data survives the repair and is written into rebuilt `war3map.imp`.
- Generated `chuzhang V2 mod2.851_repaired_v34.w3x`.

### Verification
- `dotnet build .tools/MapRepair/MapRepair.sln -nologo`
- `dotnet .tools/MapRepair/src/MapRepair.Smoke/bin/Debug/net8.0/MapRepair.Smoke.dll`
- `dotnet run --project .planning/tools/maprepair_runner/MapRepair.Run.csproj -- <input> <output> <report>`
- `dotnet run --no-build --project .planning/tools/maprepair_object_dump/MapRepair.ObjectDump.csproj -- <map> war3map.w3a <ids> <rawcodes> true`

### Current Continuation Target
- Validate `v34` in the Warcraft editor first.
- If some payloads are still missing, gather a few exact missing paths from the editor for the next audit slice.

## 2026-03-30 V36 Model-Fallback Round

### Audit Focus / Symptom
- The user supplied a concrete list of still-missing model paths after the `v34` round.

### Findings / Root Cause
- Direct probes against the source archive showed that many remaining paths were present under the same basename but with `.mdx` instead of `.mdl`.
- The malformed original `war3map.w3d` payload could still hide useful path strings even when structured object-data parsing failed.

### Fix / Mitigation
- Added raw-string fallback scanning in `ObjectDataAssetCollector`.
- Added `.mdl -> .mdx` and bare-name -> `war3mapImported\...` fallback candidates in `MapRepairService`.
- Rebuilt the repaired map as `v36`.

### Verification
- Smoke passed after adding both fallback paths.
- Local `v36` report now contains the user-supplied sample models:
- `zhuzi01-04`
- `liushu`
- `bajiao`
- `shitouqipan`
- `gushu`
- `Uebungspuppe`
- `xianglu1`
- `Gate`
- `pescii`
- `war3mapImported\Farn.mdx`
- `war3mapImported\FarnSE2.mdx`
- `war3mapImported\Fern3.mdx`

## 2026-03-30 V37 Reference-Format Alignment

### Audit Focus / Symptom
- The user added a stricter rule after `v36`: if object data references `.mdl`, the repaired archive/import list should keep the `.mdl` target path instead of preserving only the readable `.mdx` fallback filename.

### Findings / Root Cause
- Confirmed with direct probes that this mismatch predates the repair logic:
- original `war3map.w3d` still contains `war3mapImported\Farn.mdl` / `war3mapImported\FarnSE2.mdl` while the source archive only contains `.mdx`
- readable `Units\unitUI.slk` still contains `PandarenSamurai.mdl`, `HeroAyame.mdl`, and `hzyn.mdl` while the source archive only contains `.mdx`
- Therefore the remaining problem was not "restore rules rewrote object data incorrectly"; it was that the repaired archive preserved the readable source filename instead of the target path the editor/object data actually references.

### Fix / Mitigation
- Extended `ReferencedAssetCollector` so `war3map.j` / `war3map.lua` string literals are now a secondary asset-reference source behind object data.
- Changed `MapRepairService` so referenced-asset fallback hits are written back under the referenced target path instead of only under the readable source archive filename.
- Added smoke coverage for both object-data and script `.mdl -> .mdx` fallback scenarios.
- Generated `chuzhang V2 mod2.851_repaired_v37.w3x`.

### Verification
- `dotnet build .tools/MapRepair/MapRepair.sln -nologo -c Release`
- `dotnet .tools/MapRepair/src/MapRepair.Smoke/bin/Release/net8.0/MapRepair.Smoke.dll`
- `dotnet run -c Release --project .planning/tools/maprepair_runner/MapRepair.Run.csproj -- <input> <output> <report>`
- `dotnet run --no-build --project .planning/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- <map> <paths...>`
- Local archive probes against `v37` confirmed:
- `war3mapImported\Farn.mdl` and `war3mapImported\FarnSE2.mdl` now exist
- `PandarenSamurai.mdl`, `HeroAyame.mdl`, and `hzyn.mdl` now exist
- `war3map.imp` now lists `Farn.mdl` instead of only the fallback `.mdx` name

### Current Continuation Target
- Validate `v37` in the Warcraft editor.
- If the editor still reports missing assets, gather exact missing paths and determine whether the next gap is unreadable source payloads, a missing reference source, or a later dedupe/import-manager nuance.

### Additional Source Probe
- On March 31, 2026, direct source-archive verification confirmed that `zhuzi01/02/03/04`, `liushu`, `bajiao`, `shitouqipan`, `gushu`, `Uebungspuppe`, and `xianglu1` are present only as readable `.mdx` payloads in the original map; the original archive does not contain same-name `.mdl` files, and the typo-like path `zhuzi02.mdI` is also absent.

## 2026-03-31 V38 False-Positive Recovery Diagnosis

### Audit Focus / Symptom
- The user reported that `v37` still failed to preserve the `zhuzi*/liushu/bajiao/shitouqipan/gushu/Uebungspuppe/xianglu1` batch even though we already considered them recovered.

### Findings / Root Cause
- Direct archive probes against `v37` showed the files are present.
- `war3map.imp` and `(listfile)` in `v37` also contain those names.
- Original `war3map.w3d` contains the references; `war3map.j` does not.
- The real problem is payload format mismatch:
- the repaired `.mdl` files begin with `MDLX`, so they still contain binary `MDX` data
- therefore the current implementation detects the references and preserves bytes, but it does not perform true `MDX -> MDL` conversion

### Fix / Mitigation
- Added archive-probe header reporting so future investigation can distinguish filename recovery from format recovery.
- Added `MapRepairService` warnings when a `.mdl` target is rebuilt from binary `MDX` bytes.
- Generated `chuzhang V2 mod2.851_repaired_v38.w3x` and the matching report.

### Verification
- `dotnet build .tools/MapRepair/MapRepair.sln -nologo -c Release`
- `dotnet .tools/MapRepair/src/MapRepair.Smoke/bin/Release/net8.0/MapRepair.Smoke.dll`
- `dotnet run -c Release --project .planning/tools/maprepair_runner/MapRepair.Run.csproj -- <input> <output> <report>`
- `dotnet run -c Release --project .planning/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- <map> <paths...>`
- `v38` report warnings now explicitly list entries such as `zhuzi01.mdl`, `liushu.mdl`, `bajiao.mdl`, `shitouqipan.mdl`, `gushu.mdl`, `Uebungspuppe.mdl`, and `xianglu1.mdl` as `.mdl` paths backed by binary `MDX` payloads.

### Current Continuation Target
- Decide whether to add real `MDX -> MDL` conversion or to rewrite the editor/object-data references to `.mdx` where safe.

## 2026-04-04 External Checker Automation Wiring

### Audit Focus / Symptom
- The remaining planned gap after the GUI-recovery pass was that `MapRepair` still relied on the internal `YdweWtgCompatibilityValidator`; we did not yet have a repeatable way to invoke the original YDWE `fix-wtg/checker.lua`.

### Findings / Root Cause
- The historical `lni-c` bootstrap path was the wrong level of attack for this environment: the native module itself was unstable to load directly, but the bundled x86 `w3x2lni-lua.exe` could still run the original checker if we supplied a Lua-side compatibility parser for YDWE new-format UI text files.
- That bridge is sufficient for reconstructed standard-GUI outputs and for the extracted `repaired_v47` real-map baseline.
- The latest repaired real-map output still fails the original checker even though smoke and the internal validator pass.
- The bridge's debug walk reports the first missing node on the latest extracted WTG as `condition InitGameCache`.

### Fix / Mitigation
- Added `.tools/MapRepair/scripts/ydwe_wtg_checker.lua` to host the original checker under the repo-local x86 runtime.
- Wired original-checker assertions into the key GUI scenarios in `MapRepair.Smoke`.
- Extended `.planning/tools/maprepair_archive_probe` with `--extract` so extracted real-map `war3map.wtg` bytes can be checked directly.

### Verification
- `dotnet build .tools/MapRepair/MapRepair.sln -nologo`
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract <map> war3map.wtg <out>`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\tmp\checker-v47.wtg`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\tmp\checker-latest.wtg --debug-missing`

### Current Continuation Target
- Compare the latest extracted WTG against `repaired_v47` around the first failing path `condition InitGameCache`.

## 2026-04-04 Checker-Mismatch Resolution

### Audit Focus / Symptom
- The active plan still claimed that the latest repaired real-map output failed the original checker around helper-reported node `condition InitGameCache`.

### Findings / Root Cause
- Direct source-backed rechecks showed that the latest extracted `war3map.wtg` already passes the original YDWE checker.
- The stale `InitGameCache` failure came from `.tools/MapRepair/scripts/ydwe_wtg_checker.lua --debug-missing`, whose reader had copied the lighter `fix-wtg/checker.lua` scan layout and therefore misread embedded-call arguments.
- A prebuilt `.planning/tools/maprepair_runner/bin/...` executable also lagged the current source behavior and briefly produced a misleading "missing WTG/WCT" validation path; the source-backed harness remained authoritative.

### Fix / Mitigation
- Rewrote the bridge `--debug-missing` walk to follow `frontend_wtg.lua`'s inserted-call and array-index byte layout.
- Added an inserted-call roundtrip smoke check using `FlushGameCache(InitGameCache("RoundtripCache"))` and gated it with the corrected debug walk.

### Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/tmp/real-map-rerun/Harness/Harness.csproj`
- `dotnet run --project .planning/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract <map> war3map.wtg <out>`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\tmp\real-map-rerun\verify\war3map.wtg`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\tmp\real-map-rerun\verify\war3map.wtg --debug-missing`

### Current Continuation Target
- None for this execution slice.

## 2026-04-04 Editor Trigger-Load Compatibility

### Audit Focus / Symptom
- The user reported that the repaired map still crashes when the target editor reads triggers, even though the latest `war3map.wtg/wct` passes the validator and the original YDWE checker.

### Findings / Root Cause
- A new WTG inspector showed that the pre-fix real-map output still emitted many structured action/call nodes that only existed in YDWE extension metadata rather than in the base editor trigger vocabulary.
- Representative extension-only nodes included `DisplayTextToPlayer`, `DisplayTimedTextToPlayer`, `RemoveLocation`, `DestroyGroup`, `DestroyTrigger`, `FlushGameCache`, `InitGameCache`, and `ExecuteFunc`.
- The reconstruction path accepted those nodes because `GuiMetadataCatalog` merged YDWE extensions after the base trigger data and structured reconstruction accepted any metadata hit.
- That made the output checker-compatible, but not necessarily safe for an editor that does not load the same YDWE extension trigger definitions.

### Fix / Mitigation
- Added a base-compatible metadata view in `GuiMetadataCatalog`.
- Changed structured node reconstruction and nested call parsing to use only base-compatible trigger metadata.
- Extension-only action/call nodes now degrade to `CustomScriptCode`.
- Added `.planning/tools/maprepair_wtg_inspect` and a focused smoke scenario `gui-extension-compatibility-fallback`.

### Verification
- Background smoke run completed successfully and included `gui-extension-compatibility-fallback`.
- Re-ran the real-map harness and regenerated `war3map.wtg/wct`.
- Extracted latest repaired `war3map.wtg` still passes:
- original YDWE checker
- corrected bridge `--debug-missing` walk
- `maprepair_wtg_inspect` on the post-fix real-map output reports:
- `extensionNodes = []`
- `extensionSources = []`
- `RecoveredGui/001-SET.lml` now preserves `FlushGameCache(InitGameCache("Cache"))`, `FogEnable(false)`, and `ExecuteFunc("PlayerLoadEsc")` as `CustomScriptCode` instead of structured extension nodes.

### Current Continuation Target
- Manual editor-side validation of the newest repaired output.

## 2026-04-04 Smoke Popup Triage

### Audit Focus / Symptom
- The user pointed out an earlier popup mentioning `Date: 2026-04-04 19:43:15`, `Version: 2.7.4`, and a `w3x2lni-lua.exe` stack under `C:\Users\DCY1\AppData\Local\Temp\MapRepairSmoke\...`.

### Findings / Root Cause
- The popup log was recovered from `C:\Users\DCY1\AppData\Local\Temp\MapRepairSmoke\...\w2l-stage\log\error\2026-04-04 19-31-10.log` and `...19-35-08.log`.
- The actual failure was `frontend_w3i.lua:35: bad argument #1 to 'unpack' (data string too short)`.
- That stack belongs to the synthetic smoke `w2l-stage` run, not to the current real repaired map output.
- A dedicated YDWE-side probe against `ydwe/w3x2lni/wtg_checker.lua` reports:
- the latest repaired real-map `war3map.wtg`: `CHECK PASS`;
- historical `good` / `v47` comparison samples: they still fall into the checker failure path under that exact probe.
- A temp `w2l` stage with `backend/ydwe_path.lua` pinned to the repo-local YDWE installation can run `w2l.exe lni` successfully on the latest repaired real map and emits a full `trigger/*.lml` workspace.

### Conclusion
- The user-cited popup should not be treated as evidence that the current repaired `war3map.wtg/wct` are still malformed.
- The remaining editor crash, if still reproducible manually, now points away from the current WTG parse chain and toward editor-runtime behavior we still cannot reproduce headlessly.

## 2026-04-04 Sample-Map / YDWE-Source Cross-Check

### Audit Focus / Symptom
- The user asked for a direct cross-check against the provided `一世之尊` sample map and the repo-local `YDWE/source` tree to explain why the repaired map still crashes while the editor reads triggers.

### Findings / Root Cause
- Confirmed: the three `一世之尊` WTG copies under `.tools/YDWE`, `.tools/MapRepair/[0]一世之尊(地形开始) (2)/map`, and `w3x2lni2.7.2/.../map` are byte-identical, so they are a valid "known-good editor-readable" sample.
- Confirmed: the sample map is not limited to base Warcraft GUI metadata. It depends on YDWE/XueYue-side trigger packages such as `ydtrigger`, and the sample parse path quickly reaches extension UI names such as `YDWESetAnyTypeLocalVariable`.
- Confirmed from `YDWE/source/Development/Plugin/WE/YDTrigger/SetGUIId_Hook.cpp`: the target editor registers many extension GUI ids in C++ and is therefore expected to load richer trigger vocabularies than the base `TriggerData.txt` alone.
- Confirmed: the latest source-backed repaired real-map output is structurally readable by the repo-local YDWE/w3x2lni parser chain, but its shape is still highly abnormal compared with the good sample:
- sample header: `18` categories, meaningful hand-authored category names, `120` WCT trigger-text entries;
- latest repaired header: `1` category (`Recovered GUI`), `569` triggers, `839` variables, `569` WCT trigger-text slots;
- latest repaired inspector summary: `0` whole-trigger custom-text fallbacks but `12873` `CustomScriptCode` action nodes and a max trigger action count of `871`.
- Confirmed: category id `0` is not by itself invalid, because the good sample also uses category id `0` for a normal category. The newer crash is therefore not explained by `CategoryId = 0`.
- The remaining crash is now better explained as an editor-runtime limit or plugin-side instability caused by the aggressive "decompile almost everything into GUI + many `CustomScriptCode` lines" strategy, not by a still-broken WTG byte layout, not by missing YDWE package registration, and not by the earlier extension-node mismatch that was already removed.

### Supporting Evidence
- `SetGUIId_Hook.cpp` and `ChangeGUIType_Hook.cpp` show that YDWE's editor plugin special-cases a bounded set of extension GUI ids, but there is no comparable guardrail for unusually large synthetic trigger trees dominated by thousands of `CustomScriptCode` actions.
- The latest repaired output now passes:
- the internal validator;
- the original YDWE `fix-wtg/checker.lua`;
- the corrected `ydwe/w3x2lni/wtg_checker.lua` path;
- a full repo-local `w2l.exe lni` conversion into `trigger/*.lml`.
- That means the unresolved crash sits above the byte-level parse/checker layer.

### Current Continuation Target
- Treat "full-GUI reconstruction with zero whole-trigger custom-text fallback" as the main new risk hypothesis.
- If we continue implementation, prefer a safety-oriented mitigation path such as downgrading very large or `CustomScriptCode`-dominated reconstructed triggers back to whole-trigger custom-text instead of forcing every trigger body into editor-visible pseudo-GUI nodes.

## 2026-04-05 Small-Pseudo-GUI Fallback

### Audit Focus / Symptom
- The user still reported an editor-side trigger-load crash after the earlier compact / script-heavy fallback passes.
- The latest source-backed rerun still kept many `20`-`34` action GUI triggers that were almost entirely `CustomScriptCode` or still encoded branch-heavy raw control flow.

### Findings / Root Cause
- The earlier fallback thresholds started too high for survivors such as `hero chose1`, `J baoji1`, `J LLS`, `005`, `yabiaoa`, `yabiaoc`, `tamuzhigen4`, and `zhiguliangyao4`.
- Some of those bodies were not especially large, but they were still editor-hostile because they looked like small JASS scripts flattened into GUI action rows.
- Real-map statistics on `current-rerun-v6` showed that the unresolved risk had shifted from `96+` action outliers to smaller `20+` action pseudo-GUI survivors.

### Fix / Mitigation
- Added a small all-custom fallback for `20+` action triggers whose reconstructed bodies keep at most one structured action.
- Added a small branch-heavy fallback for `20+` action triggers with `18+` `CustomScriptCode` lines and `8+` control-flow markers.
- Added smoke coverage through `gui-all-custom-pseudo-fallback` and `gui-small-branchy-pseudo-fallback`.
- Re-ran the source-backed real-map harness into `Lua/.planning/tmp/current-rerun-v7/`.
- Published a new versioned GUI package under `Lua/.tools/MapRepair/publish/win-x64-self-contained-20260405-0636/`.

### Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/tmp/current-rerun-v7/chuzhang V2 mod2.851_repaired_current.w3x .planning/tmp/current-rerun-v7/report`
- `dotnet run --project .planning/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/tmp/current-rerun-v7/chuzhang V2 mod2.851_repaired_current.w3x war3map.wtg .planning/tmp/current-rerun-v7/verify/war3map.wtg`
- `dotnet run --project .planning/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/tmp/current-rerun-v7/chuzhang V2 mod2.851_repaired_current.w3x war3map.wct .planning/tmp/current-rerun-v7/verify/war3map.wct`
- `dotnet run --project .planning/tools/maprepair_wtg_inspect/MapRepair.WtgInspect.csproj -- . .planning/tmp/current-rerun-v7/verify/war3map.wtg .planning/tmp/current-rerun-v7/verify/war3map.wct`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\tmp\current-rerun-v7\verify\war3map.wtg`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\tmp\current-rerun-v7\verify\war3map.wtg --debug-missing`
- `dotnet build .tools/MapRepair/MapRepair.sln -c Release -nologo`
- `dotnet publish .tools/MapRepair/src/MapRepair.Wpf/MapRepair.Wpf.csproj -c Release -r win-x64 --self-contained true -o .tools/MapRepair/publish/win-x64-self-contained-20260405-0636`
- Latest source-backed real-map result:
- `customTextCount = 256`
- `extensionNodes = []`
- total `CustomScriptCode` actions = `2731`
- `RemainingSmallRiskyGuiCount = 0`
- `maxActionTrigger = item set`

### Current Continuation Target
- Manual editor-side validation against the newest repaired map or `MapRepair-win-x64-self-contained-20260405-0636.zip`.
- If the crash still reproduces, inspect the remaining large sequential GUI survivors such as `SET`, `SET2`, and `item set`.

## 2026-04-05 Custom-Text Empty-Tree Alignment

### Audit Focus / Symptom
- After the small pseudo-GUI fallback pass, the repaired map still remained only checker-validated locally; we still had no editor-side proof that mixed custom-text fallback triggers were acceptable to the target editor.

### Findings / Root Cause
- Reading the repo-local `w3x2lni` old-format `frontend_lml.lua` / `backend_wtg.lua` path showed that whole-trigger custom-text is normally serialized as `wct = 1` with an empty GUI tree unless an explicit `.lml` trigger body also exists.
- `MapRepair` was still emitting custom-text fallback triggers with preserved event roots, creating a non-standard mixed-mode shape: executable closure in `war3map.wct`, but extra GUI event ECAs still present in `war3map.wtg`.
- That shape remained validator-compatible and original-checker-compatible, but it was a plausible remaining editor-hostile edge because it differed from the normal toolchain's custom-text encoding.

### Fix / Mitigation
- Changed `JassGuiReconstructionParser.BuildCustomTextTrigger()` so whole-trigger custom-text fallbacks now emit an empty GUI tree.
- Updated `MapRepair.Smoke` custom-text fallback scenarios to assert:
- `Events.Count == 0`
- preserved `InitTrig_*` text inside `CustomText`
- continued validator / original-checker acceptance
- Re-ran the real-map harness into `.planning/tmp/current-rerun-v8/`.
- Refreshed the published WPF package under `.tools/MapRepair/publish/win-x64-self-contained-20260405-0706/`.

### Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/tmp/current-rerun-v8/chuzhang V2 mod2.851_repaired_current.w3x .planning/tmp/current-rerun-v8/report`
- `dotnet run --project .planning/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/tmp/current-rerun-v8/chuzhang V2 mod2.851_repaired_current.w3x war3map.wtg .planning/tmp/current-rerun-v8/verify/war3map.wtg`
- `dotnet run --project .planning/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/tmp/current-rerun-v8/chuzhang V2 mod2.851_repaired_current.w3x war3map.wct .planning/tmp/current-rerun-v8/verify/war3map.wct`
- `dotnet run --project .planning/tools/maprepair_wtg_inspect/MapRepair.WtgInspect.csproj -- . .planning/tmp/current-rerun-v8/verify/war3map.wtg .planning/tmp/current-rerun-v8/verify/war3map.wct`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\tmp\current-rerun-v8\verify\war3map.wtg`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\tmp\current-rerun-v8\verify\war3map.wtg --debug-missing`
- Latest source-backed real-map result:
- `customTextCount = 256`
- `extensionNodes = []`
- `maxActionCount = 96`
- `maxActionTrigger = item set`
- `topEvents` counts drop materially versus `v7`, confirming that the `256` custom-text triggers no longer preserve event ECAs in `war3map.wtg`

### Current Continuation Target
- Manual editor-side validation against `.planning/tmp/current-rerun-v8/chuzhang V2 mod2.851_repaired_current.w3x` or `MapRepair-win-x64-self-contained-20260405-0706.zip`.
- If the crash still reproduces, inspect the remaining large sequential GUI survivors such as `SET`, `SET2`, and `item set`.

## 2026-04-05 Sample `war3map.j` Truth Check And Eventless-GUI Fallback

### Audit Focus / Symptom
- The user suggested using the provided `一世之尊` sample as a truth check: reconstruct `war3map.wtg` from its `war3map.j` and compare that output with the real editor-readable `war3map.wtg`.

### Findings / Root Cause
- The comparison is sharply lossy even on a known-good map:
- real sample `war3map.wtg`: `18` categories, `20` variables, `120` triggers
- real sample `war3map.wct`: `4` non-empty trigger texts, global custom code length `2069`
- reconstructed sample from `war3map.j` after the empty-tree custom-text pass:
- `89` triggers
- `4` variables
- `1` category
- only `13` recoverable GUI event nodes
- after adding conservative fallback, `65` whole-trigger custom-text triggers
- The `89` reconstructed triggers match the sample script's `InitTrig_*` count exactly, so the missing `31` editor-visible triggers do not survive in compiled script as ordinary `InitTrig_*` definitions.
- The sample `InitTrig_*` bodies contain only `13` standard `TriggerRegister*` calls:
- `10` `TriggerRegisterPlayerChatEvent`
- `2` `TriggerRegisterAnyUnitEventBJ`
- `1` `TriggerRegisterTimerEventSingle`
- That exactly matches the reconstructed sample's `GuiEventNodeCount = 13`.
- Many other sample trigger init paths instead use opaque wrappers such as `MFCTimer_layExeRecTg`.
- Some sample extension registration functions are stripped to stubs like `ConvertRace(0); return`, so their original editor event semantics are not recoverable from `war3map.j`.
- The attempted automatic `unknownui` dump path via YDWE's reader still fails on the real sample WTG (`在大量尝试后放弃修复`), which reinforces that the sample depends on a richer editor-private UI layer than the repo-local metadata set can fully infer headlessly.

### Fix / Mitigation
- Added `.planning/tools/maprepair_sample_compare` to reconstruct `war3map.wtg/wct` directly from a sample script without building a synthetic archive by hand.
- Added `.tools/MapRepair/scripts/ydwe_wtg_dump_unknownui.lua` to probe YDWE-side unknown-UI inference in a reproducible way.
- Added a new parser fallback:
- if no recoverable GUI events or conditions remain
- and the trigger body is still non-trivial (`CustomScriptCode` present or more than one action)
- then emit the trigger as whole-trigger custom-text instead of eventless GUI
- Added smoke coverage:
- `gui-eventless-fallback`
- `gui-opaque-init-fallback`
- Also extended custom-text closure collection so opaque helper functions from init code are preserved in the emitted custom text.

### Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/tools/maprepair_sample_compare/MapRepair.SampleCompare.csproj -- . .tools/MapRepair/[0]一世之尊(地形开始) (2)/map/war3map.j .planning/tmp/sample-reconstruct-compare-v2`
- sample reconstructed summary:
- `TriggerCount = 89`
- `VariableCount = 4`
- `GuiEventNodeCount = 13`
- `CustomTextTriggerCount = 65`
- `dotnet run --project .planning/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/tmp/current-rerun-v10/chuzhang V2 mod2.851_repaired_current.w3x .planning/tmp/current-rerun-v10/report`
- `dotnet run --project .planning/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/tmp/current-rerun-v10/chuzhang V2 mod2.851_repaired_current.w3x war3map.wtg .planning/tmp/current-rerun-v10/verify/war3map.wtg`
- `dotnet run --project .planning/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/tmp/current-rerun-v10/chuzhang V2 mod2.851_repaired_current.w3x war3map.wct .planning/tmp/current-rerun-v10/verify/war3map.wct`
- `dotnet run --project .planning/tools/maprepair_wtg_inspect/MapRepair.WtgInspect.csproj -- . .planning/tmp/current-rerun-v10/verify/war3map.wtg .planning/tmp/current-rerun-v10/verify/war3map.wct`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\tmp\current-rerun-v10\verify\war3map.wtg`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\tmp\current-rerun-v10\verify\war3map.wtg --debug-missing`
- Latest real-map result:
- `customTextCount = 284`
- `extensionNodes = []`
- total `CustomScriptCode` actions = `2634`
- `eventlessGuiCount = 2`
- remaining eventless GUI triggers: `Func`, `load` (`0` actions each)

### Current Continuation Target
- Manual editor-side validation against `.planning/tmp/current-rerun-v10/chuzhang V2 mod2.851_repaired_current.w3x` or `MapRepair-win-x64-self-contained-20260405-0741.zip`.
- If the crash still reproduces, inspect the remaining large eventful sequential GUI survivors such as `SET`, `SET2`, and `item set`.

## 2026-04-05 Script-Visible GUI Recovery Publish

### Audit Focus / Symptom
- The user clarified the intended reconstruction rule: if a custom or YDWE function name still survives in compiled `war3map.j`, it should be reconstructed as GUI by that surviving function name instead of being forcibly downgraded to base-compatible-only GUI or raw custom script.

### Findings / Root Cause
- Confirmed in source that `GuiMetadataCatalog` already supports full-name and `script_name` lookup across YDWE extension metadata.
- Confirmed the remaining blocker was local policy inside `JassGuiReconstructionParser` and `GuiArgumentNormalizer`: structured recovery still used `TryGetBaseCompatibleEntry(...)` and `baseCompatibleOnly: true`, which overrode the richer metadata catalog even when the function name was still visible in `war3map.j`.

### Fix / Mitigation
- Removed the base-compatible-only restriction from `JassGuiReconstructionParser` so top-level action/event recovery and nested call normalization now use full metadata lookup for script-visible function names.
- Updated smoke assertions so script-visible extension cases such as `DisplayTextToPlayer`, `RemoveLocation`, `FlushGameCache(InitGameCache(...))`, and bulk `ExecuteFunc(...)` bodies remain GUI instead of regressing to `CustomScriptCode` or whole-trigger custom-text.
- Published a fresh WPF package from the updated source under `.tools/MapRepair/publish/win-x64-self-contained-20260405-1016/`.
- Refreshed the stable publish directory `.tools/MapRepair/publish/win-x64-self-contained/`.
- Packed `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260405-1016.zip` with the top-level versioned folder preserved.

### Verification
- `dotnet run --project d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\src\MapRepair.Smoke\MapRepair.Smoke.csproj`
- `dotnet publish d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\src\MapRepair.Wpf\MapRepair.Wpf.csproj -c Release -r win-x64 --self-contained true -o d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\publish\win-x64-self-contained-20260405-1016`
- Verified both exe locations exist and match size `153800019` bytes:
- `.tools/MapRepair/publish/win-x64-self-contained-20260405-1016/MapRepair.exe`
- `.tools/MapRepair/publish/win-x64-self-contained/MapRepair.exe`
- Verified the new zip contains entries such as:
- `win-x64-self-contained-20260405-1016/MapRepair.exe`
- `win-x64-self-contained-20260405-1016/MapRepair.Core.pdb`
- `win-x64-self-contained-20260405-1016/wpfgfx_cor3.dll`

### Current Continuation Target
- Manually validate the `20260405-1016` package in the Warcraft editor.
- If trigger-load crashes still reproduce, refresh the real-map rerun from the new source before drawing conclusions from the older `current-rerun-v10` metrics.

## 2026-04-05 Extension-Node Regression Fix

### Audit Focus / Symptom
- The user reported that the freshly published package still crashed while the editor was reading triggers.

### Findings / Root Cause
- A fresh real-map rerun from the `20260405-1016` source snapshot (`current-rerun-v11`) proved that the broadened script-visible GUI recovery rule had reintroduced `584` extension-only GUI nodes.
- The biggest regressions were repo-level YDWE extension actions/calls such as `RemoveLocation`, `DisplayTextToPlayer`, `DestroyGroup`, `FlushGameCache`, and nested `InitGameCache`.
- The original checker still passed on `v11`, so the regression was editor-runtime compatibility, not malformed WTG bytes.
- Side finding: map-local GUI package metadata was not being preserved at all because candidate collection ignored `ui\\config` and package-local `action/call/condition/event.txt`.

### Fix / Mitigation
- Narrowed structured GUI recovery to:
- base-compatible metadata
- map-local embedded GUI extension metadata
- Restored repo-level YDWE extension entries to the older fallback path that writes them as `CustomScriptCode`.
- Preserved map-local GUI metadata by collecting `ui\\config`, `ui\\TriggerData.txt`, `ui\\TriggerStrings.txt`, and package-local action/call/condition/event files.
- Added smoke coverage `gui-map-local-extension-recovery`.
- Re-ran the real map into `.planning/tmp/current-rerun-v12/`.
- Published the repaired build as `MapRepair-win-x64-self-contained-20260405-1055.zip`.

### Verification
- `MapRepair.Smoke` passed after the narrowed recovery rule and map-local metadata preservation fix.
- `current-rerun-v12` returned to:
- `extensionNodes = []`
- `customTextCount = 284`
- `maxActionTrigger = item set`
- `maxActionCount = 96`
- The original checker and the corrected debug walk both passed on `current-rerun-v12`.

## 2026-04-05 W3x2Lni YDWE-Path Warning Triage

### Audit Focus / Symptom
- The user reported a standalone `W3x2Lni` popup showing `没有转换触发器 / 请设置YDWE关联地图` and suspected that warning might explain the remaining editor trigger-load crash.

### Findings / Root Cause
- The warning path comes from `frontend_trg.lua` failing inside `backend/data_load.lua` while resolving TriggerData roots, before it proves anything about the current repaired `war3map.wtg` byte layout.
- In this workspace, both repo-local `w3x2lni` resolver copies still relied too heavily on registry association and hard-coded `YDWE.exe` / `KKWE.exe` root names, while the bundled editor layout is exposed through `.tools/YDWE`, `share/mpq`, and `雪月WE.exe`.
- Therefore this popup is explained first by tool-root detection drift, not by a fresh regression in `current-rerun-v12`.

### Fix / Mitigation
- Patched:
- `.tools/w3x2lni/script/backend/ydwe_path.lua`
- `.tools/YDWE/plugin/w3x2lni_zhCN_v2.7.3/script/backend/ydwe_path.lua`
- `.tools/YDWE/source/Development/Component/plugin/w3x2lni/script/backend/ydwe_path.lua`
- New behavior still prefers registry association when present, but now also accepts structure-based repo-local roots and falls back to the workspace-local `.tools/YDWE` tree.

### Verification
- A direct resolver probe on the repo-local standalone `w3x2lni` copy now returns `Lua/.tools/YDWE` instead of `nil`.
- The warning is now classified as a tool-environment issue and should not be treated as standalone evidence that the latest repaired `war3map.wtg/wct` became malformed again.

## 2026-04-05 Custom-Text Helper Closure Fix

### Audit Focus / Symptom
- The user confirmed that `v16` still crashed while the editor read triggers and still stopped at `16/569`, which meant the earlier `tmdlimititemlvl -> custom-text` downgrade had not actually cleared the underlying editor-hostile shape.

### Findings / Root Cause
- Inspecting `tmp/current-rerun-v16/report/RecoveredGui/016-tmdlimititemlvl.j` showed that `Trig_tmdlimititemlvl_Actions` still called `Trig_tmdlimititemlvl_Func001C()`, but the emitted custom-text closure did not include that helper function at all.
- The omission came from `JassGuiReconstructionParser.CollectFunctionClosure(...)`, which only followed callback-style references such as `Condition(function ...)`, `TriggerAddAction/Condition(... function ...)`, and `ExecuteFunc("...")`.
- Ordinary local helper calls such as `if ( Trig_*_Func001C() ) then` were not added to the custom-text closure, so `war3map.wct` could remain structurally incomplete even while `war3map.wtg`, the internal validator, and both YDWE checker paths still passed.

### Fix / Mitigation
- Extended custom-text closure collection to scan direct local function calls while skipping language keywords.
- Changed custom-text emission to preserve source-order function output for the included closure.
- Tightened `MapRepair.Smoke` so `gui-compact-control-heavy-pseudo-fallback` now asserts the helper function is preserved ahead of the action body.
- Re-ran the real map into `.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v17/`.
- Published the matching desktop build under `.tools/MapRepair/publish/win-x64-self-contained-20260405-2329/` and packed `MapRepair-win-x64-self-contained-20260405-2329.zip`.

### Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v17/chuzhang V2 mod2.851_repaired_current.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v17/report`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v17/chuzhang V2 mod2.851_repaired_current.w3x war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v17/verify/war3map.wtg`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v17/chuzhang V2 mod2.851_repaired_current.w3x war3map.wct .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v17/verify/war3map.wct`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_wtg_inspect/MapRepair.WtgInspect.csproj -- d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v17/verify/war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v17/verify/war3map.wct`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v17\verify\war3map.wtg`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v17\verify\war3map.wtg --debug-missing`
- `current-rerun-v17/report/RecoveredGui/016-tmdlimititemlvl.j` now includes:
- `Trig_tmdlimititemlvl_Conditions`
- `Trig_tmdlimititemlvl_Func001C`
- `Trig_tmdlimititemlvl_Actions`
- `InitTrig_tmdlimititemlvl`
- Real-map metrics stayed aligned with `v16`:
- `triggerCount = 569`
- `customTextCount = 437`
- `GuiEventNodeCount = 288`
- `extensionNodes = []`
- `maxActionCount = 96`

### Current Continuation Target
- Manual editor-side validation against `.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v17/chuzhang V2 mod2.851_repaired_current.w3x` or `MapRepair-win-x64-self-contained-20260405-2329.zip`.
- If the editor still stops near `16/569`, inspect the earliest custom-text triggers for any remaining local-helper closure or ordering gaps before reopening the already-cleared pseudo-GUI survivor buckets.

## 2026-04-05 Compact Guarded Front-Slice Pass

### Audit Focus / Symptom
- The user confirmed that `v17` still stopped at `16/569`, which meant the helper-closure fix inside `tmdlimititemlvl` was not enough by itself.

### Findings / Root Cause
- Re-auditing the first 16 recovered triggers showed that `v17` still kept twelve compact guarded GUI survivors immediately before `tmdlimititemlvl`:
- `clc2 baoxiang`
- `clc1 baoxiang`
- `czd1 baoxiang`
- `czd2 baoxiang`
- `czc1 baoxiang`
- `czc2 baoxiang`
- `czc3 baoxiang`
- `czc4 baoxiang`
- `czd3 baoxiang`
- `czd5 baoxiang`
- `czc5 baoxiang`
- `czc6 baoxiang`
- Their common shape was a root-condition guard preserved as three `CustomScriptCode` lines plus a tiny body that still contained custom script, typically:
- `actionCount = 5`
- `customScriptCount = 4`
- `controlFlowCount = 3`
- The existing fallback rules did not cover this `5`-`7` action front-slice because the earlier compact-control rule started at `8` actions.

### Fix / Mitigation
- Added a compact guarded pseudo-GUI fallback rule for the `5`-`7` action band when:
- a root-condition guard is still present
- `4+` custom-script lines remain
- `3+` control-flow markers remain
- body custom-script survives after the guard prelude
- Added smoke coverage `gui-compact-guarded-pseudo-fallback`.
- Re-ran the real map into `.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v18/`.
- Published the matching desktop build under `.tools/MapRepair/publish/win-x64-self-contained-20260405-2356/` and packed `MapRepair-win-x64-self-contained-20260405-2356.zip`.

### Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v18/chuzhang V2 mod2.851_repaired_current.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v18/report`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v18/chuzhang V2 mod2.851_repaired_current.w3x war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v18/verify/war3map.wtg`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v18/chuzhang V2 mod2.851_repaired_current.w3x war3map.wct .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v18/verify/war3map.wct`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_wtg_inspect/MapRepair.WtgInspect.csproj -- d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v18/verify/war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v18/verify/war3map.wct`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v18\verify\war3map.wtg`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v18\verify\war3map.wtg --debug-missing`
- `current-rerun-v18` result:
- `triggerCount = 569`
- `customTextCount = 468`
- `GuiEventNodeCount = 257`
- `extensionNodes = []`
- `004-clc2 baoxiang.j` now contains the full custom-text closure instead of the old guarded GUI shape.

### Current Continuation Target
- Manual editor-side validation against `.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v18/chuzhang V2 mod2.851_repaired_current.w3x` or `MapRepair-win-x64-self-contained-20260405-2356.zip`.
- If the editor still stops at `16/569`, treat that as evidence that the issue is now inside the early custom-text slice rather than the previously surviving compact guarded GUI cluster.

## 2026-04-06 Custom-Text Callback Closure And Smoke Popup Fix

### Audit Focus / Symptom
- The user confirmed that `v18` still stopped at `16/569` and also reported that every smoke run still surfaced a blocking staged `w3x2lni-lua.exe` popup from the optional `w2l` reconstruction scenario.

### Findings / Root Cause
- A direct audit of `v18/report/RecoveredGui/*.j` showed `42` custom-text chunks still referenced local helpers through generic callback syntax such as `ForForce(..., function Trig_*_Func...)`, but the referenced helper functions were missing from the emitted closure text.
- The earlier custom-text closure fix only covered:
- direct `Trig_*()` calls
- a few previously hard-coded callback APIs
- It did not cover generic inline `function Name` callback references.
- The smoke popup came from the optional staged `w2l` scenario; even though the scenario already tolerated failure, it still launched the staged `w2l.exe` path by default and could surface the downstream crash-report dialog.

### Fix / Mitigation
- Extended custom-text closure discovery to capture generic inline callback references written as `function <Name>` inside trigger body lines.
- Tightened smoke coverage so `gui-compact-guarded-pseudo-fallback` now asserts callback-helper preservation in emitted custom text.
- Changed `RunW2lLniReconstructionScenario()` to skip by default unless `MAPREPAIR_SMOKE_RUN_W2L=1`, which keeps routine smoke runs headless.
- Re-ran the real map into `.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v19/`.

### Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- Smoke now prints:
- `w2l-lni-reconstruction skipped: set MAPREPAIR_SMOKE_RUN_W2L=1 to enable the optional staged w2l.exe check`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v19/chuzhang V2 mod2.851_repaired_current.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v19/report`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v19/chuzhang V2 mod2.851_repaired_current.w3x war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v19/verify/war3map.wtg`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v19/chuzhang V2 mod2.851_repaired_current.w3x war3map.wct .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v19/verify/war3map.wct`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_wtg_inspect/MapRepair.WtgInspect.csproj -- d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v19/verify/war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v19/verify/war3map.wct`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v19\verify\war3map.wtg`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v19\verify\war3map.wtg --debug-missing`
- The custom-text callback audit now reports:
- `0` remaining emitted `.j` chunks with missing `Trig_*` callback references
- `002-SET2.j` now includes:
- `Trig_SET2_Func006Func001C`
- `Trig_SET2_Func006A`
- `Trig_SET2_Actions`
- `InitTrig_SET2`

### Current Continuation Target
- Manual editor-side validation against `.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v19/chuzhang V2 mod2.851_repaired_current.w3x` or the last published package `MapRepair-win-x64-self-contained-20260405-2356.zip`.
- If the editor still stops at `16/569`, the next likely surface is now early custom-text text shape rather than helper closure loss or the old staged smoke popup.

## 2026-04-06 Custom-Text Init-First Ordering Fix

### Audit Focus / Symptom
- The user confirmed that `v19` still stopped at `16/569`, which meant the callback-helper closure fix was not enough by itself.

### Findings / Root Cause
- Good-sample `war3map.wct` extractions under `tmp/ydwe-audit-sample-v1/RecoveredGui/*.j` showed a stable pattern:
- every custom-text chunk starts with `InitTrig_*`.
- The same sample map's compiled `war3map.j` does not keep that ordering, which proved that editor-authored `war3map.wct` ordering is not the same as raw compiled-script source order.
- `current-rerun-v19/report/RecoveredGui/*.j` still emitted all `468` custom-text chunks in `war3map.j` source order, so every chunk started with non-init functions such as `Trig_*_Conditions`, `Trig_*_Actions`, or helper functions like `H2I`.
- The first `16` recovered triggers were almost entirely custom-text, so this remaining mismatch was a plausible explanation for why the editor still stopped at `16/569` even while validator and checker gates kept passing.

### Fix / Mitigation
- Changed `JassGuiReconstructionParser.CollectFunctionClosure(...)` so custom-text chunks are no longer serialized in raw source order.
- The new ordering anchors each chunk on `InitTrig_*`, then emits trigger-local entry functions before the remaining reachable helper closure.
- Updated smoke assertions so:
- `gui-custom-text-callback-closure`
- `gui-compact-control-heavy-pseudo-fallback`
- now lock the init-first ordering expectation.
- Re-ran the real map into `.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v20/`.
- Published the matching desktop build as `MapRepair-win-x64-self-contained-20260406-0922.zip`.

### Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v20/chuzhang V2 mod2.851_repaired_current.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v20/report`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v20/chuzhang V2 mod2.851_repaired_current.w3x war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v20/verify/war3map.wtg`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v20/chuzhang V2 mod2.851_repaired_current.w3x war3map.wct .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v20/verify/war3map.wct`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_wtg_inspect/MapRepair.WtgInspect.csproj -- d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v20/verify/war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v20/verify/war3map.wct`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v20\verify\war3map.wtg`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v20\verify\war3map.wtg --debug-missing`
- `current-rerun-v20` kept:
- `triggerCount = 569`
- `customTextCount = 468`
- `GuiEventNodeCount = 257`
- `extensionNodes = []`
- Early `v20` custom-text files now begin with:
- `InitTrig_SET2`
- `InitTrig_tmdlimititemlvl`
- `InitTrig_hantmdweiacunzhuang1`

### Current Continuation Target
- Manual editor-side validation against `.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v20/chuzhang V2 mod2.851_repaired_current.w3x` or `MapRepair-win-x64-self-contained-20260406-0922.zip`.
- If the editor still stops at `16/569`, the next likely surface is now early custom-text body shape rather than helper closure loss or chunk ordering.

## 2026-04-06 Custom-Text Root-Action Order Fix

### Audit Focus / Symptom
- The user confirmed that `v20` still stopped at `16/569`, which meant the init-first fix alone was not enough.

### Findings / Root Cause
- A second-pass comparison against the good sample map showed a stronger invariant than the earlier init-first result:
- every sample custom-text chunk uses `Trig_*Actions` as the second function.
- `current-rerun-v20/report/RecoveredGui/*.j` still violated that pattern for many early triggers, including:
- `004-clc2 baoxiang`
- `016-tmdlimititemlvl`
- `018-hantmdweiacunzhuang1`
- The remaining mismatch came from `CollectFunctionClosure(...)` still letting the init function re-seed closure order from its own body, which naturally queued:
- `TriggerAddCondition(...)`
- before `TriggerAddAction(...)`
- As a result, the practical output order still stayed:
- `InitTrig_*`
- `Trig_*_Conditions`
- `Trig_*Actions`

### Fix / Mitigation
- Changed `JassGuiReconstructionParser.CollectFunctionClosure(...)` so the init function no longer re-seeds custom-text closure order from its own registration body.
- The init function now acts only as the chunk anchor; root action functions are emitted ahead of root condition functions, and helper closure follows afterward.
- Updated smoke assertions so the compact control and guarded custom-text scenarios require the root action function immediately after `InitTrig_*`.
- Re-ran the real map into `.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v22/`.
- Published the matching desktop build as `MapRepair-win-x64-self-contained-20260406-0951.zip`.

### Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v22/chuzhang V2 mod2.851_repaired_current.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v22/report`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v22/chuzhang V2 mod2.851_repaired_current.w3x war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v22/verify/war3map.wtg`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v22/chuzhang V2 mod2.851_repaired_current.w3x war3map.wct .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v22/verify/war3map.wct`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_wtg_inspect/MapRepair.WtgInspect.csproj -- d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v22/verify/war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v22/verify/war3map.wct`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v22\verify\war3map.wtg`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v22\verify\war3map.wtg --debug-missing`
- `current-rerun-v22` kept:
- `triggerCount = 569`
- `customTextCount = 468`
- `GuiEventNodeCount = 257`
- `extensionNodes = []`
- Early `v22` custom-text files now begin with:
- `InitTrig_tmdlimititemlvl`
- `Trig_tmdlimititemlvl_Actions`
- and no longer put `Trig_tmdlimititemlvl_Conditions` in second position.

### Current Continuation Target
- Manual editor-side validation against `.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v22/chuzhang V2 mod2.851_repaired_current.w3x` or `MapRepair-win-x64-self-contained-20260406-0951.zip`.
- If the editor still stops at `16/569`, the next likely surface is now early custom-text body content rather than helper closure loss or the two known function-order mismatches.

## 2026-04-06 Custom-Text Local-Closure Trim

### Audit Focus / Symptom
- The user confirmed that `v23` still stopped at `16/569`, which meant source-order custom-text preservation alone was not enough.

### Findings / Root Cause
- `current-rerun-v23/report/RecoveredGui/001-SET.j` still contained `29` functions and had expanded into:
- `PlayerLoadEsc`
- save/load helper functions
- unrelated trigger bodies such as `Trig_aa_Actions`
- `Trig_hero_chose1_Actions`
- `current-rerun-v23/report/RecoveredGui/559-hero chose2.j` showed the same non-local closure bleed.
- `maprepair_wtg_inspect` still reported structurally safe counts (`triggerCount = 569`, `customTextCount = 468`, `GuiEventNodeCount = 257`, `extensionNodes = []`), which narrowed the remaining suspicion to editor-hostile custom-text breadth rather than WTG tree shape.

### Fix / Mitigation
- Added `SelectCustomTextChunkFunctions(...)` so emitted custom-text chunks now keep:
- trigger-local `Trig_*` / `InitTrig_*` functions
- direct non-local helper calls from `InitTrig_*` only
- source-backed order, comment headers, and trigger-local globals when present
- The emitted chunk no longer recursively follows action-time external helper chains, and it no longer imports unrelated `Trig_*` / `InitTrig_*` bodies from other triggers.
- Added smoke coverage `gui-custom-text-local-closure`.
- Re-ran the real map into `.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v24/`.
- Published the matching desktop build as `MapRepair-win-x64-self-contained-20260406-1317.zip`.

### Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v24/chuzhang V2 mod2.851_repaired_current.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v24/report`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v24/chuzhang V2 mod2.851_repaired_current.w3x war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v24/verify/war3map.wtg`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v24/chuzhang V2 mod2.851_repaired_current.w3x war3map.wct .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v24/verify/war3map.wct`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_wtg_inspect/MapRepair.WtgInspect.csproj -- d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v24/verify/war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v24/verify/war3map.wct`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v24\verify\war3map.wtg`
- `current-rerun-v24` kept:
- `triggerCount = 569`
- `customTextCount = 468`
- `GuiEventNodeCount = 257`
- `extensionNodes = []`
- Early `v24` chunk shrink:
- `001-SET.j`: `64575` bytes / `29` functions -> `2479` bytes / `4` local functions
- `559-hero chose2.j`: transitive save/load spillover removed; now only `11` local functions
- `016-tmdlimititemlvl.j` still keeps the restored helper and source-backed order

### Current Continuation Target
- Manual editor-side validation against `.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v24/chuzhang V2 mod2.851_repaired_current.w3x` or `MapRepair-win-x64-self-contained-20260406-1317.zip`.
- If the editor still stops at `16/569`, the next likely surface is now the action-time external call text itself rather than transitive helper closure bleed, helper loss, or chunk ordering.

## 2026-04-06 Custom-Text Editor Header Normalization

### Audit Focus / Symptom
- The user confirmed that `v24` still stopped at `16/569`, which meant the local-closure trim still was not enough by itself.

### Findings / Root Cause
- A raw `war3map.wct` comparison exposed an editor-facing mismatch that the reconstructed `RecoveredGui/*.j` audit had hidden:
  - healthy local sample `War3/map/war3map.wct`: `7/7` non-empty custom-text slots begin with `//TESH.scrollpos=0` plus `//TESH.alwaysfold=0`
  - `current-rerun-v24/verify/war3map.wct`: `0/468` non-empty custom-text slots had those editor-authored headers
- The same raw `v24` early slots also still preserved decorative slash-only preambles such as `/////////////`, which do not appear in the healthy raw sample.
- `kkwe.log` recorded the `v24` open attempt at `2026-04-06 14:32:20` and then stopped before the later `virtual_mpq 'triggerdata'` / `virtual_mpq 'triggerstrings'` phase that successful opens reach, which kept the suspicion on editor-side trigger-text handling rather than the already-green structural checker path.

### Fix / Mitigation
- Normalized emitted whole-trigger custom-text so it now:
  - prepends `//TESH.scrollpos=0`
  - prepends `//TESH.alwaysfold=0`
  - strips decorative comment-only preambles before the real trigger body
  - keeps the existing source-backed local-closure route below that editor header
- Extended `MapRepair.Smoke` so custom-text fallback scenarios now assert the editor header shape, and the source-slice scenario now proves decorative slash-only preambles are stripped.
- Re-ran the real map into `.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v25/`.

### Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v25/chuzhang V2 mod2.851_repaired_current.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v25/report`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v25/chuzhang V2 mod2.851_repaired_current.w3x war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v25/verify/war3map.wtg`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v25/chuzhang V2 mod2.851_repaired_current.w3x war3map.wct .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v25/verify/war3map.wct`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_wtg_inspect/MapRepair.WtgInspect.csproj -- d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v25/verify/war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v25/verify/war3map.wct`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v25\verify\war3map.wtg`
- `current-rerun-v25` keeps:
  - `triggerCount = 569`
  - `customTextCount = 468`
  - `GuiEventNodeCount = 257`
  - `extensionNodes = []`
- Raw `v25` `war3map.wct` now has `468/468` non-empty custom-text slots with `TESH` headers.

### Current Continuation Target
- Manual editor-side validation against `.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v25/chuzhang V2 mod2.851_repaired_current.w3x`.
- If the editor still stops at `16/569`, treat that as evidence that matching the healthy raw `WCT` editor header shape was necessary but not sufficient, and inspect the remaining early custom-text body shape below the now-normalized header.

## 2026-04-06 Action Child-Block And Arithmetic Condition Recovery

### Commands
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v29/chuzhang V2 mod2.851_repaired_current.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v29/report`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v30/chuzhang V2 mod2.851_repaired_current.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v30/report`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v30/chuzhang V2 mod2.851_repaired_current.w3x war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v30/verify/war3map.wtg`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v30/chuzhang V2 mod2.851_repaired_current.w3x war3map.wct .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v30/verify/war3map.wct`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_wtg_inspect/MapRepair.WtgInspect.csproj -- . .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v30/verify/war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v30/verify/war3map.wct`

### Findings
- The first pass (`v29`) proved the new route works on the real map:
  - `totalChildBlocks = 377`
  - `IfThenElseMultiple = 161`
  - `customTextCount = 199`
- The second pass (`v30`) narrowed the user-reported `16/569` slice directly:
  - `totalChildBlocks = 382`
  - `IfThenElseMultiple = 163`
  - `customTextCount = 197`
  - `016-tmdlimititemlvl` now emits as an action-side `IfThenElseMultiple`
- The missing piece between `v29` and `v30` was helper-backed arithmetic expression normalization inside the recovered `if` condition:
  - `GetHeroLevel(GetTriggerUnit()) + 1` now normalizes into `OperatorIntegerAdd(...)`
- Remaining early mixed survivors if manual validation still fails near the same front slice:
  - `018-hantmdweiacunzhuang1`
  - `020-tmdjingong009`
  - loop-heavy flat control flow in `SET` and `SET2`

## 2026-04-06 Canon YDWE Open-Chain Audit

### Commands
- `.planning/workspaces/maprepair-trigger-editor-compatibility/tools/canon_ydwe_chain_probe.cmd d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v30`
- `d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.canon\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\scripts\ydwe_wtg_checker.lua d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.canon\YDWE d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v30\verify\war3map.wtg`
- `d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.canon\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\scripts\ydwe_wtg_checker.lua d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.canon\YDWE d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v30\verify\war3map.wtg --debug-missing`
- `d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.canon\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\scripts\ydwe_wtgloader_probe.lua d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.canon\YDWE d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v30\verify\war3map.wtg`
- `d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.canon\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\tools\canon_ydwe_frontend_probe.lua d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.canon\YDWE d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v30\verify\war3map.wtg`

### Findings
- `current-rerun-v30` passes the full canon headless parse chain:
  - checker = `PASS`
  - `--debug-missing` = `PASS`
  - `wtgloader` = `CHECK PASS`
  - `frontend_trg` = `PASS`
  - `frontend_wtg` = `PASS`
  - `triggerCount = 569`
- The canon editor open archived in `tmp/current-rerun-v30/chain-audit-kkwe.log` reaches:
  - `Open map`
  - `virtual_mpq 'triggerdata'`
  - `virtual_mpq 'triggerstrings'`
- The early hook audit found `0` GUI names in the first `32` repaired triggers that depend on `SetGUIId_Hook.cpp` alone.
- The unresolved layer is now above the headless parse chain and the first truthful follow-up target remains `018-hantmdweiacunzhuang1`.
