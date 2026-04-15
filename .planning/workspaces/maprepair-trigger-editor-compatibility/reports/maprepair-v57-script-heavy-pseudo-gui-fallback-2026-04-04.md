# MapRepair V57 Script-Heavy Pseudo-GUI Fallback

## Goal
- Continue reducing editor-side trigger-load crash risk after the compact/dense fallback still left many `30`-`50` action GUI triggers whose bodies were dominated by `CustomScriptCode`.

## Findings
- After the previous pass, the latest rerun still kept several risky script-heavy GUI triggers:
  - `unit die 1`: `59` actions, `59` custom-script lines
  - `nianhuoshi1`: `58` actions, `44` custom-script lines
  - `Cage Cast`: `53` actions, `40` custom-script lines
  - many `36`-`39` action survivors still had `75%+` `CustomScriptCode` density or `18+` control-flow markers
- The latest output still passed the validator/checker gates, so the remaining risk again stayed with editor-hostile trigger shape rather than with metadata or binary-layout correctness.

## Fix
- Tightened `JassGuiReconstructionParser` fallback rules again:
  - added a script-heavy fallback for `>= 40` action triggers with `>= 28` custom-script lines and at least two-thirds script density
  - added a compact script-heavy fallback for `>= 36` action triggers with either `>= 18` control-flow markers or `>= 27` custom-script lines at `75%+` density
  - added a very compact script-heavy fallback for `>= 30` action triggers with `>= 24` custom-script lines and either `>= 15` control-flow markers or `80%+` script density
- Kept the dedicated `gui-script-heavy-pseudo-fallback` smoke scenario and tightened its payload so it exercises the smallest script-heavy threshold.

## Verification
- `MapRepair.Smoke` passes with `gui-script-heavy-pseudo-fallback`, `gui-compact-pseudo-fallback`, `gui-medium-pseudo-fallback`, and `gui-large-pseudo-fallback`.
- Re-ran the current source-backed real map.
- Extracted latest repaired output still passes:
  - original YDWE `fix-wtg/checker.lua`
  - corrected bridge `--debug-missing` walk
- Latest output shape improved again:
  - `customTextCount = 155`
  - `extensionNodes = []`
  - `maxActionCount = 96`
  - `maxActionTrigger = item set`
  - total `CustomScriptCode` actions reduced to `4863`
- The largest surviving GUI triggers are now mostly sequential setup bodies such as `item set`, `set rw`, `SET BB`, `bag set`, and `SET2`.

## Remaining Gap
- Direct editor-side proof is still pending because the Warcraft editor is not available in this environment.
- If the crash is still reproducible on this build, the next slice should inspect the remaining `27`-`34` action script-heavy survivors such as `zhiguliangyao4`, `tamuzhigen4`, `005`, `yabiaoa`, `yabiaoc`, `J baoji1`, and `J LLS`.
