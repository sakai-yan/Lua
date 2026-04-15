# MapRepair V62 Sample Helper-Registration Forensics

## Goal
- Re-run the `一世之尊` sample comparison with the corrected assumption that unknown GUI aliases found in the real `war3map.wtg` may compile away before `war3map.j` is emitted, so a checker-side missing alias is not automatically a script-side reconstruction input gap.

## Tooling Fix
- Fixed `.planning/tools/maprepair_sample_compare` so it now:
- reads `TriggerArtifacts` correctly and emits all recovered trigger artifacts
- auto-detects sibling real `war3map.wtg/wct` files next to the sample `war3map.j`
- records raw real-WTG header counts even when full GUI decode fails
- records opaque init-helper registration statistics from `InitTrig_*`

## Findings
- Reconstructed-from-`war3map.j` sample (`.planning/tmp/sample-reconstruct-compare-v5/`):
- `89` triggers
- `4` variables
- `13` recoverable GUI event nodes
- `74` custom-text fallbacks
- `89` emitted trigger artifacts
- Sibling real sample `war3map.wtg/wct` raw counts:
- `18` categories
- `20` variables
- `120` triggers
- `120` WCT trigger slots
- `4` non-empty trigger texts
- `globalCustomCodeLength = 2214`
- Repo-local full decode of the real sample WTG still fails on `Call:MFEvent_SkillUGet`, but `maprepair_sample_compare` now confirms `decodeFailureSymbolPresentInScript = false`.
- Therefore `MFEvent_SkillUGet` is a GUI-side alias present in the true WTG metadata layer, not a symbol that survives in compiled `war3map.j`.
- The init-side script evidence that does survive is dominated by opaque helper registrations rather than by standard `TriggerRegister*` calls:
- `13` total standard `TriggerRegister*` calls
- `66` opaque helper registrations
- top helpers:
- `MFCTimer_layExeRecTg`: `63`
- `MHItemRemoveEvent_Register`: `2`
- `MHHeroGetExpEvent_Register`: `1`
- `65` of the `89` init functions contain helper registrations but no standard `TriggerRegister*` call.
- Example recovered trigger notes now line up with that analysis:
- `WPSC` falls back because the init uses `MHItemRemoveEvent_Register`
- many timer-driven triggers fall back because the init uses `MFCTimer_layExeRecTg`

## Corrected Conclusion
- The earlier “sample still needs extra unknown-ui packages” conclusion was too strong.
- The real blocker revealed by the corrected comparison is:
- true WTG can contain GUI-only aliases that never appear in compiled script
- compiled script can still preserve some init semantics, but often only as opaque helper registrations
- therefore a `war3map.j`-only rebuild should not try to re-import missing GUI aliases from the checker failure list
- instead it should either:
- recognize the surviving helper-registration patterns when that can be done safely
- or keep those triggers in whole-trigger custom-text when the helper semantics are not safely recoverable

## Impact On Current Route
- Keep using the sample as evidence that `war3map.j` is lossy for editor reconstruction.
- Stop using checker-side missing aliases from the real sample WTG as proof that the reconstruction environment must load additional unknown-ui packages.
- If another pre-editor code slice is needed, inspect whether the real crash correlates with surviving helper-registered trigger patterns or with remaining pseudo-GUI bodies, not with missing `MFEvent_*` alias metadata.

## Verification
- `dotnet run --project .planning/tools/maprepair_sample_compare/MapRepair.SampleCompare.csproj -- . '.tools/MapRepair/[0]一世之尊(地形开始) (2)/map/war3map.j' '.planning/tmp/sample-reconstruct-compare-v5'`
- `Select-String -Path '.planning/tmp/sample-reconstruct-compare-v5/summary.json' -Pattern 'decodeFailure|decodeFailureSymbol' -Context 0,2`
