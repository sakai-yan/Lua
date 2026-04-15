# MapRepair V54 Medium Pseudo-GUI Fallback

## Goal
- Continue reducing editor-side trigger-load crash risk after the first large-trigger fallback still left medium-size pseudo-GUI triggers in `war3map.wtg`.

## Findings
- After the first fallback pass, the latest rerun still kept several risky GUI triggers:
  - `lostitem`: `441` actions
  - `save`: `187` actions, `144` custom-script lines
  - `e`: `127` actions, `111` custom-script lines
  - `JX` / `FX` / `QX` / `MZYY`: each still around `96`-`112` actions with dense control-flow script fragments
- The WCT custom-text encoding shape remained compatible with the `w3x2lni` `frontend_lml/backend_wct` path, so the leading remaining risk stayed with medium-size pseudo-GUI trees rather than with obviously malformed WCT bytes.

## Fix
- Tightened `JassGuiReconstructionParser` fallback rules:
  - any trigger with `>= 256` actions now falls back to custom-text
  - any trigger with `>= 96` actions and `>= 64` `CustomScriptCode` lines now falls back to custom-text
  - any trigger with `>= 96` actions and `>= 16` control-flow custom-script markers now falls back to custom-text
- Added `gui-medium-pseudo-fallback` smoke coverage.

## Verification
- `MapRepair.Smoke` passes with both `gui-medium-pseudo-fallback` and `gui-large-pseudo-fallback`.
- Re-ran the current source-backed real map.
- Extracted latest repaired output still passes:
  - original YDWE `fix-wtg/checker.lua`
  - corrected bridge `--debug-missing` walk
- Latest output shape improved again:
  - `customTextCount = 30`
  - `extensionNodes = []`
  - `maxActionCount = 108`
  - `war3map.wtg` size `1427365`
  - `war3map.wct` size `405939`

## Remaining Gap
- Direct editor-side proof is still pending because the Warcraft editor is not available in this environment.
