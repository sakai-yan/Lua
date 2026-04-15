# MapRepair V55 Compact Pseudo-GUI Fallback

## Goal
- Continue reducing editor-side trigger-load crash risk after the medium fallback still left compact pseudo-GUI triggers with dense `CustomScriptCode` control-flow bodies in `war3map.wtg`.

## Findings
- After the previous pass, the latest rerun still kept several risky GUI triggers below the earlier `96`-action cutoff:
  - `010 u`: `91` actions, `91` custom-script lines, `75` control-flow markers
  - `GX` / `DX` / `YF` / `js`: each still around `71`-`88` actions with mostly custom-script control flow
  - `lianhua Cf`, `J HLSUNIT`, `Miaojiangzhanshen3`, `hanweicunzhuang2`: still `78`-`90` actions with dense flattened control flow
- The remaining largest GUI trigger after removing those dense bodies was `kuangshi set`: `108` actions, but only `24` custom-script lines and `12` control-flow markers.
- The latest output still passed the validator/checker gates, so the remaining risk stayed with editor-hostile trigger shape rather than with metadata or binary-layout correctness.

## Fix
- Tightened `JassGuiReconstructionParser` fallback rules again:
  - any trigger with `>= 96` actions and either `>= 24` custom-script lines or `>= 12` control-flow markers now falls back to custom-text
  - any trigger with `>= 64` actions and either `>= 48` custom-script lines or `>= 24` control-flow markers now falls back to custom-text
  - any trigger with `>= 48` actions and `>= 20` control-flow markers now falls back to custom-text
- Added `gui-compact-pseudo-fallback` smoke coverage for a `50`-action compact pseudo-GUI body that would previously have survived as GUI.

## Verification
- `MapRepair.Smoke` passes with `gui-compact-pseudo-fallback`, `gui-medium-pseudo-fallback`, and `gui-large-pseudo-fallback`.
- Re-ran the current source-backed real map.
- Extracted latest repaired output still passes:
  - original YDWE `fix-wtg/checker.lua`
  - corrected bridge `--debug-missing` walk
- Latest output shape improved again:
  - `customTextCount = 65`
  - `extensionNodes = []`
  - `maxActionCount = 96`
  - `maxActionTrigger = item set`
  - `war3map.wtg` size `1198274`
  - `war3map.wct` size `563905`
- The largest surviving GUI triggers are now mostly sequential setup bodies such as `item set`, `set rw`, and `SET BB` rather than dense control-flow pseudo-GUI trees.

## Remaining Gap
- Direct editor-side proof is still pending because the Warcraft editor is not available in this environment.
- If the crash is still reproducible on this build, the next slice should inspect the remaining `40`-`50` action survivors with `20+` control-flow markers before attempting a larger AST rewrite.
