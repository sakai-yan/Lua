# Project Summary

## Approved Route Baseline
- Treat standard WTG compatibility as the hard gate; malformed reconstructed `war3map.wtg` should never be written.
- Recover GUI triggers in a hybrid form: real GUI nodes where safe, `CustomScriptCode` GUI actions where raw script must be preserved, and full custom-text when the recovered trigger body stops looking like a safe editor-readable GUI tree.
- Prefer preserving runtime behavior over forcing speculative GUI structure.

## Confirmed Findings
- The repo-local YDWE source does not contain a direct `war3map.j -> GUI -> war3map.wtg/wct` reconstruction path.
- The real YDWE GUI restoration path is `TriggerData/TriggerStrings -> frontend_trg() -> frontend_wtg/frontend_wct -> editor GUI id restoration`.
- `SetGUIId_Hook.cpp` confirms that the editor restores GUI by resolving WTG node names into GUI ids.
- All audited repo-local `war3map.j` consumers fall into compile/save, optimize, WTS/mark conversion, or reference-scan roles; none of them emits structured GUI trigger trees.
- `fix-wtg` reads existing `war3map.wtg`, validates it against loaded GUI metadata, and infers `unknownui` definitions from WTG structure when needed; it is not a JASS-to-GUI converter.
- `LegacyGuiBinaryCodec` now writes root nodes without `childId` and child nodes with `childId`, matching external reader expectations.
- `YdweWtgCompatibilityValidator` is wired into `MapRepairService`; malformed reconstructed WTG now blocks output generation instead of silently emitting broken trigger data.
- `GuiMetadataCatalog` now loads TriggerData preset aliases, and `GuiArgumentNormalizer` maps common script expressions such as `bj_KEYEVENTTYPE_DEPRESS`, `bj_KEYEVENTKEY_*`, `Player(n)`, `gg_unit_*`, `gg_rct_*`, and `gg_dest_*` back into WTG-safe argument forms.
- Structured GUI reconstruction now prefers base-compatible metadata plus map-local embedded GUI extension metadata; script-visible repo-level YDWE extension actions/calls are downgraded back to `CustomScriptCode`.
- `SetGUIId_Hook.cpp` confirms the editor's GUI restoration path is keyed off WTG node names and GUI ids.
- `JassGuiReconstructionParser` now falls back oversized, dense, compact, and script-heavy pseudo-GUI triggers to whole-trigger custom-text when reconstruction still flattens large amounts of code into `CustomScriptCode`, and now also collapses `20+` action bodies that stay almost entirely custom-script or still carry branch-heavy raw control flow.
- `w3x2lni`'s old-format custom-text path expects `wct = 1` triggers to use an empty GUI tree unless a parallel `.lml` body exists; preserved event roots inside whole-trigger custom-text are a non-standard mixed-mode shape.
- `JassGuiReconstructionParser` now emits whole-trigger custom-text fallbacks with an empty GUI tree and keeps the init/action closure only in `war3map.wct`.
- Comparing `一世之尊`'s real trigger metadata with the `war3map.j`-reconstructed version confirms that protected / extension-heavy JASS can be a heavily lossy source for editor trigger reconstruction:
- real sample: `18` categories, `20` vars, `120` triggers, `4` non-empty WCT trigger texts
- reconstructed sample: `1` category, `4` vars, `89` triggers, `65` custom-text fallbacks, `13` recoverable GUI events
- `JassGuiReconstructionParser` now falls back non-trivial eventless GUI triggers to whole-trigger custom-text when no recoverable GUI events or conditions remain.
- The improved sample compare tool now emits all `89` trigger artifacts and auto-records sibling real `war3map.wtg/wct` raw header counts plus init-helper statistics.
- On the real sample WTG, repo-local decode still stops on `Call:MFEvent_SkillUGet`, but that symbol is absent from `war3map.j`; this checker failure reflects a GUI-side alias missing from local WTG metadata, not a missing script-side reconstruction input.
- The dominant script-side init survivors in the sample are opaque helper registrations: `MFCTimer_layExeRecTg` (`63`), `MHItemRemoveEvent_Register` (`2`), and `MHHeroGetExpEvent_Register` (`1`), covering `65` of `89` init functions with no standard `TriggerRegister*` call.

## Real-Map Result
- Re-running `MapRepairService` on `Lua/.tools/MapRepair/chuzhang V2 mod2.851.w3x` regenerated `war3map.wtg/wct`.
- The latest stable rerun is under `Lua/.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v12/`.
- The intermediate `20260405-1016` publish/regression rerun briefly reintroduced `584` extension-only GUI nodes before the narrower recovery rule restored the older safe shape.
- The latest console result shows:
- `569` reconstructed triggers.
- `839` reconstructed variables.
- `284` custom-text trigger fallbacks, selected by the stricter compact/dense/script-heavy/small-pseudo/eventless safety rules.
- Extracted `war3map.wtg` from that rerun passes the original YDWE checker and the corrected `--debug-missing` bridge walk.
- Post-fix WTG inspection shows:
- `extensionNodes = []`
- `maxActionCount = 96`, down from `871`
- `maxActionTrigger = item set`
- `war3map.wtg` keeps shrinking while `war3map.wct` grows because more risky trigger bodies now live in whole-trigger custom-text instead of pseudo-GUI action lists
- total `CustomScriptCode` action nodes are down to `2634`
- the current report-side audit finds `RemainingSmallRiskyGuiCount = 0` for the new `20+` action all-custom / branch-heavy pseudo-GUI thresholds
- `topEvents` counts in `v10` remain at the lower post-empty-tree level, and non-trivial eventless GUI triggers are now reduced to `2`

## Active Standards
- Validate with the independent WTG validator before trusting roundtrip success.
- Validate important reconstructed GUI outputs with the original YDWE checker as a second gate.
- When full GUI structure is unclear, prefer a GUI trigger with preserved custom-script lines over a full custom-text trigger.
- When a function name still survives in `war3map.j` and matching GUI metadata exists, prefer structured GUI recovery over downgrading it to `CustomScriptCode`.
- When a reconstructed trigger expands into dozens or hundreds of flat actions with dense `CustomScriptCode` control-flow markers or remains script-heavy enough to stop looking like editable GUI, prefer whole-trigger custom-text over a pseudo-GUI tree.
- When a `20+` action trigger is almost entirely `CustomScriptCode` or still encodes branchy raw control flow as flat action lines, prefer whole-trigger custom-text over a small pseudo-GUI body.
- When a trigger falls back to whole-trigger custom-text, prefer the standard empty-tree `wct = 1` shape over mixed custom-text plus preserved GUI event nodes.
- When a trigger has no recoverable GUI events or conditions and still expands into a non-trivial body, prefer whole-trigger custom-text over eventless GUI.
- Record route refinements explicitly when execution diverges from the earlier plan shape.

## Risks
- No active WTG checker blocker remains for the current execution slice.
- Prebuilt helper binaries under `.planning/workspaces/maprepair-trigger-editor-compatibility/tools/*/bin` can lag current source-backed behavior; use `dotnet run` or the source-backed harness for acceptance-sensitive validation.
- Direct editor-side proof that the trigger-load crash is gone is still pending because the Warcraft editor is not available in this environment.

## Reusable Knowledge
- When auditing Warcraft trigger restoration, separate three surfaces explicitly:
- `war3map.j` consumers
- `TriggerData` metadata loaders
- `war3map.wtg/wct` codecs
- They often coexist in the same toolchain, but they do not imply the same capability.
- In repo-local YDWE, the presence of `war3map.j` parsers does not imply GUI reconstruction; the decisive check is whether any `war3map.j` consumer actually builds or writes WTG/WCT trigger structures.
- A small amount of argument normalization plus allowing action-only GUI triggers eliminates a disproportionately large share of fallback.
- Inline comments on JASS function headers can silently break function discovery if the parser matches raw lines instead of comment-stripped lines.
- Validator-compatible pseudo-GUI can still be editor-hostile even when metadata is correct; the remaining risk is often trigger-tree shape, not binary layout or metadata lookup.
- The original YDWE checker can be automated without the historical `lni-c` native bootstrap by running it under the repo-local x86 `w3x2lni-lua.exe` plus a Lua-side parser shim for YDWE UI text files.
- YDWE debug helpers that walk `war3map.wtg` must follow `frontend_wtg.lua`'s inserted-call byte layout; the lighter `fix-wtg/checker.lua` scan logic is not reliable enough for pinpoint diagnostics on embedded call arguments.
- GUI-only aliases that disappeared before `war3map.j` emission are still not reconstructable from script alone; for those, use helper-registration analysis or whole-trigger custom-text rather than speculative alias reinjection.
- If a non-base GUI entry is required for structured recovery, the map must also carry the matching `ui\\config` / package metadata so the editor can resolve it again on load.
- Even when metadata is correct, a repaired WTG can remain editor-hostile if it encodes complex logic as flat `CustomScriptCode` action lists instead of normal GUI child blocks or custom-text triggers, even when those bodies are only `27`-`40` actions long.
- Even `20`-`25` action triggers can remain editor-hostile if they are almost entirely `CustomScriptCode`, even when they are not especially branch-heavy; loop-only or execute-only pseudo-GUI bodies should be treated as risky.
- Old-format custom-text triggers should be treated as empty-tree `war3map.wtg` entries with their executable closure living in `war3map.wct`; preserving event roots inside those triggers creates a non-standard mixed-mode shape.
- Protected / extension-heavy `war3map.j` can preserve only the `InitTrig_*` subset of the editor trigger tree; helper-based event registrations and editor-only comment/script triggers may not be reconstructable from script at all.
- If a reconstructed trigger ends up eventless only because its original event semantics were hidden behind opaque helper calls or stripped library stubs, eventless GUI is less trustworthy than whole-trigger custom-text.
- A real WTG may contain GUI-only aliases such as `MFEvent_SkillUGet` that never appear in compiled `war3map.j`; their absence from script is expected and should not by itself drive reconstruction work toward unknown-ui package supplementation.
- When sample `InitTrig_*` bodies lack `TriggerRegister*`, inspect surviving helper registrations such as `MFCTimer_layExeRecTg`, `MHItemRemoveEvent_Register`, or `MHHeroGetExpEvent_Register` before concluding the script has no usable init semantics left.

## Route-Review Findings
- A full AST rewrite was not the best first execution step for this codebase.
- The current hybrid reconstruction path now reaches full trigger coverage on the real sample map while staying validator-compatible under the internal gate and passing the original checker on the latest source-backed rerun.
- For editor-side compatibility, "validator-compatible" is not enough by itself; the more important question is whether the recovered function names still survive in compiled script and can be mapped back into legal GUI nodes without inventing missing GUI-only aliases.
- For editor-side compatibility, "still GUI" is not enough by itself either; trigger bodies that degenerate into flat script-heavy pseudo-GUI action lists should be collapsed back to custom-text before writing `war3map.wtg`, even when they fall well below the earlier `96`-action threshold.
- The latest small-pseudo fallback pass cleared the previously surviving `20`-`34` action all-custom / branch-heavy pseudo-GUI set without disturbing the current maximum-action sequential survivors such as `item set`.

## 2026-04-05 Addendum
- The warning `没有转换触发器 / 请设置YDWE关联地图` comes from `frontend_trg.lua -> backend/data_load.lua` failing to resolve TriggerData roots, so by itself it diagnoses a `w3x2lni` environment/path issue rather than a newly malformed repaired `war3map.wtg/wct`.
- Repo-local standalone and plugin `w3x2lni` `ydwe_path.lua` copies now fall back to the workspace-local `.tools/YDWE` tree and accept structure-based roots instead of depending only on registry association plus hard-coded executable names.
