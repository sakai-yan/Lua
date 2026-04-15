# MapRepair v87: First Trigger Binary-Split Result

## Goal
- Continue the trigger editor-compatibility task after the user supplied the first complementary trigger-shell split result.

## User-Confirmed Manual Results
- `tmp/v34-trigger-shell-diag/chuzhang V2 mod2.851_repaired_current_trigger_shell_001_032.w3x`
  - crashes at `34/569`
- `tmp/v34-trigger-shell-diag/chuzhang V2 mod2.851_repaired_current_trigger_shell_033_569.w3x`
  - crashes at `16/569`

## Findings
- The first blocker remains inside `001-032`.
- Shelling that whole band removes the `16/569` blocker and exposes a secondary blocker at `34/569`.
- Shelling the later half does not move the first blocker at all.

## What Changed
- Updated the active continuation plan to split `001-032` into:
  - `001-015`
  - `016-032`
- Generated those next trigger-shell variants under `tmp/v34-trigger-shell-diag/`.

## Current Conclusion
- Do not touch production repair logic yet.
- Isolate the `16/569` blocker first inside `001-032`, then return to the secondary `34/569` blocker afterward.
