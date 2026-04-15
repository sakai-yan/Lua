# Step Plan

## Current Step
- Name: Validate editor trigger-load compatibility after script-visible custom-function GUI recovery
- Parent phase: Phase 3
- Why now: The root cause of the `20260405-1016` crash regression was identified and fixed by narrowing structured recovery back away from repo-level YDWE extension entries, the real-map rerun is now refreshed as `current-rerun-v12`, and the newest manual-validation package is `20260405-1055`.

## Step Objective
- Confirm that reconstructed `war3map.wtg/wct` no longer emits either:
- the previously closed small all-custom / branch-heavy pseudo-GUI survivors
- or the non-standard mixed custom-text + preserved-event-tree shape that custom-text fallbacks used before `v8`
- or non-trivial eventless GUI triggers whose original event semantics may have been lost in compiled script

## Requirement Alignment
- The repaired output must satisfy the existing validator/checker gates and also avoid trigger-tree shapes that still look editor-hostile, including both small pseudo-GUI bodies and mixed custom-text triggers that still retain GUI event roots.

## Planned Technical Route
- Validate the newest published package or repaired map in the target editor.
- Keep the narrowed script-visible GUI recovery rule: if a callable name still survives in `war3map.j`, reconstruct it as GUI only when it resolves through base-compatible metadata or map-local embedded GUI extension metadata; otherwise collapse it to `CustomScriptCode`.
- Keep the new `20+` action all-custom / branch-heavy fallback rules as the current editor-compatibility floor.
- Keep the new empty-tree custom-text fallback shape as the current whole-trigger custom-text floor.
- Keep the new eventless-GUI fallback as the current floor for triggers that no longer have recoverable GUI events or conditions.
- If the crash persists, inspect the remaining large sequential GUI survivors such as `SET`, `SET2`, and `item set` rather than the previously closed small pseudo-GUI set.
- Keep smoke coverage on the new all-custom / small-branchy fallback paths as well as the earlier large, medium, compact, and script-heavy pseudo-GUI paths.

## Framework Compatibility Review
- Keep the internal validator and the original-checker bridge as independent gates.
- Treat editor compatibility as a stricter bar than checker compatibility; if a trigger body stops looking like a normal GUI tree, prefer whole-trigger custom-text over an oversized or script-heavy pseudo-GUI action list.

## Detail Resolution Focus
- Verify that the post-fix real-map output still has `extensionNodes = []` while moving the worst small pseudo-GUI outliers to custom-text.
- Confirm that `RemainingSmallRiskyGuiCount = 0` in the latest report-side audit.
- Confirm that whole-trigger custom-text fallbacks in the latest rerun no longer preserve event roots in `war3map.wtg`.
- Confirm that non-trivial eventless GUI triggers in the latest rerun are reduced to the intentionally kept empty shells only.
- Confirm that the remaining maximum-action GUI triggers are still mostly sequential setup triggers such as `item set`, `set rw`, and `SET BB`.

## Validation
- `MapRepair.Smoke` must continue to pass with original-checker assertions enabled, including `gui-all-custom-pseudo-fallback` and `gui-small-branchy-pseudo-fallback`.
- The extension-compatibility recovery smoke fixture must pass.
- The eventless-GUI fallback smoke fixture must pass.
- The script-heavy pseudo-GUI fallback smoke fixture must pass.
- The compact-pseudo-GUI fallback smoke fixture must pass.
- The medium-pseudo-GUI fallback smoke fixture must pass.
- The large-pseudo-GUI fallback smoke fixture must pass.
- Extracted latest repaired real-map output must still pass both the original checker and the corrected debug walk.
- The project-local WTG inspector should report `extensionNodes = []` on the latest real-map output.
- The latest source-backed real-map rerun should keep `RemainingSmallRiskyGuiCount = 0`, a non-script-heavy `maxActionTrigger`, materially lower post-`v8` `topEvents` counts, and `eventlessGuiCount <= 2`.
- Manual editor-side confirmation is still required because the Warcraft editor is not available locally.
