# MapRepair V53 Large Pseudo-GUI Fallback

## Goal
- Diagnose the remaining editor trigger-load crash after extension-only trigger nodes were already removed from reconstructed `war3map.wtg`.

## Findings
- `SetGUIId_Hook.cpp` in YDWE confirms that the editor restores GUI by resolving WTG node names to GUI ids and then emitting JASS through the registered GUI handlers.
- The `一世之尊` sample follows the expected `wtg -> InitTrig_* / Trig_*Func###* -> war3map.j` compilation pattern, but it also depends on extra unknown-UI metadata: the repo-local YDWE checker stops on `MISSING call MFEvent_SkillUGet` when `unknownui` is absent.
- The repaired real-map output no longer had extension-only structured nodes, but it still produced editor-hostile pseudo-GUI trigger bodies:
  - `DB lv1`: `871` flat actions, `664` `CustomScriptCode` lines
  - `duihuanwupin`: `668` flat actions, `585` `CustomScriptCode` lines
  - `MZ`: `349` flat actions, `189` control-flow script markers
- These triggers were technically validator-compatible, but they were no longer shaped like normal editor-authored GUI trees.

## Fix
- Added a safety fallback in `JassGuiReconstructionParser`:
  - if a reconstructed trigger expands into hundreds of flat actions dominated by `CustomScriptCode` lines
  - or into a large number of `if` / `else` / `endif` / `loop` / `return` control-flow script markers
  - then emit the trigger as whole-trigger custom-text instead of a pseudo-GUI action list
- Added a dedicated smoke scenario `gui-large-pseudo-fallback`.

## Verification
- `MapRepair.Smoke` passes with the new large-pseudo-GUI fallback scenario enabled.
- Re-ran the current source-backed real map.
- Extracted latest repaired output still passes:
  - original YDWE `fix-wtg/checker.lua`
  - corrected bridge `--debug-missing` walk
- Latest output shape improved:
  - `customTextCount = 11`
  - `extensionNodes = []`
  - `maxActionCount = 441` down from `871`
  - `war3map.wtg` size `1682338` down from `2065545`

## Remaining Gap
- Direct editor-side proof is still pending because the Warcraft editor is not available in this environment.
