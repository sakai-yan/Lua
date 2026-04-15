# Tasks

## Active
- No active code change in progress.

## Ready
- Fix `Code/Logic/Process/Motion/Entry.lua` so motion completion clears `fsm.motion` exactly once.
- Decide and implement the intended `aspd` compatibility policy in `Code/Logic/Process/Motion/Surround.lua`.
- Tighten the accepted surround-target contract or add validation/adapter logic.
- Apply low-risk hot-path cleanups after correctness is settled.

## Blocked
- Whether legacy `aspd` should preserve J-style per-tick meaning or stay as a per-second field under the old name.

## Done
- Completed a static audit of Surround and recorded findings in `reports/surround-audit-2026-04-07.md`.
