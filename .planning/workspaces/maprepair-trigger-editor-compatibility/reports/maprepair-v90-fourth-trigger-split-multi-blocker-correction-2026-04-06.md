# MapRepair v90: Fourth Trigger Split Multi-Blocker Correction

## Goal
- Continue the trigger editor-compatibility task after the user supplied the fourth split result, which disproved the simple single-blocker assumption inside `025-032`.

## User-Confirmed Manual Results
- `tmp/v34-trigger-shell-diag/chuzhang V2 mod2.851_repaired_current_trigger_shell_025_028.w3x`
  - crashes at `16/569`
- `tmp/v34-trigger-shell-diag/chuzhang V2 mod2.851_repaired_current_trigger_shell_029_032.w3x`
  - crashes at `16/569`

## Findings
- The first blocker set spans both halves of `025-032`; a plain binary split is no longer enough.
- The strongest local suspects by trigger-risk shape are:
  - `028-lostitem`
    - custom-text
    - `441` flat custom-script actions
  - `032-herospN`
    - custom-text
    - eventless

## What Changed
- Updated the active continuation plan from pure halving to targeted cross-isolation.
- Generated these next trigger-shell variants under `tmp/v34-trigger-shell-diag/`:
  - `025-027,029-032`
  - `025-031`

## Current Conclusion
- Do not touch production repair logic yet.
- Use the next two manual targeted opens to determine whether `028-lostitem`, `032-herospN`, or both independently preserve the `16/569` crash.
