# MapRepair V51 Editor Trigger-Load Compatibility

## Goal
- Diagnose why the repaired map still crashes when the editor reads triggers, even though the reconstructed `war3map.wtg/wct` passes the internal validator and the original YDWE checker.

## Findings
- The latest source-backed repaired real-map output still produced many structured GUI action/call nodes that only existed in YDWE extension metadata, not in the base editor `TriggerData.txt`.
- A project-local WTG inspector showed that the pre-fix real-map output contained `1442` extension-only nodes, including:
  - `RemoveLocation`
  - `DisplayTextToPlayer`
  - `DisplayTimedTextToPlayer`
  - `DestroyGroup`
  - `DestroyTrigger`
  - `FlushGameCache`
  - `InitGameCache`
  - `ExecuteFunc`
- These names were being selected during reconstruction because `GuiMetadataCatalog` loaded YDWE extension packages after the base trigger data, and structured reconstruction accepted any metadata hit.
- The editor crash report therefore aligned better with a compatibility issue than with a binary-layout issue: the WTG bytes were readable by our validator and by the original checker, but they still relied on editor-side trigger definitions that may not be present in the user's target editor runtime.

## Fix
- Added a base-compatible metadata view to `GuiMetadataCatalog`.
- Changed structured GUI reconstruction to use only base-compatible trigger entries for:
  - top-level event/action recovery
  - nested call-node recovery inside arguments
- Any action/call that only resolves through YDWE extension metadata now falls back to `CustomScriptCode` instead of being emitted as a structured extension node.

## Regression Coverage
- Added `.planning/tools/maprepair_wtg_inspect` to inspect WTG/WCT outputs and count extension-only nodes.
- Added a new smoke scenario:
  - `gui-extension-compatibility-fallback`
  - verifies that extension-only actions such as `DisplayTextToPlayer`, `RemoveLocation`, and `FlushGameCache(InitGameCache(...))` are preserved as `CustomScriptCode`
  - still requires the reconstructed output to pass the original YDWE checker and the bridge debug walk

## Verification
- `MapRepair.Smoke` passes with the new compatibility-fallback scenario included.
- Re-ran the real-map harness against `chuzhang V2 mod2.851.w3x`.
- Extracted latest repaired `war3map.wtg/wct` still pass:
  - original YDWE `fix-wtg/checker.lua`
  - corrected bridge `--debug-missing` walk
- Re-ran `maprepair_wtg_inspect` on the post-fix real-map output:
  - `extensionNodes = []`
  - `extensionSources = []`
- Representative trigger proof:
  - `RecoveredGui/001-SET.lml` now preserves `FlushGameCache(InitGameCache("Cache"))`, `FogEnable(false)`, and `ExecuteFunc("PlayerLoadEsc")` as `CustomScriptCode` lines instead of extension-only structured GUI nodes.

## Remaining Gap
- I cannot directly open the Warcraft editor from this environment, so final proof that the editor no longer crashes when loading triggers still requires a manual editor-side validation pass on the new repaired output or refreshed published GUI package.
