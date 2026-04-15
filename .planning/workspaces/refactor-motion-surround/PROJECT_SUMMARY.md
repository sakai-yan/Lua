# Project Summary

## Current Mission
- Audit and refine the Motion Surround implementation before changing runtime behavior.

## Context Snapshot
- Task label: Refactor Motion Surround
- Task slug: refactor-motion-surround
- Task type(s): code audit, library review, refactor prep
- Project context: brownfield runtime module
- Selected pattern: audit first, then targeted fix/refactor
- Planning container: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning
- Task workspace: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/refactor-motion-surround
- Project toolset: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.tools
- Canonical references: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.canon

## Planned Technical Route Baseline
- Treat the J implementation as behavior context, not as a drop-in contract.
- Verify whether observed issues belong to `Surround.lua` or the shared Motion FSM layer before patching.
- Prefer fixing shared runtime contract bugs before adding local workarounds in Surround.

## Inherited Standards and Principles
- Keep motion APIs simple at call sites, but make internal semantics explicit.
- Avoid silent legacy aliases when the old unit semantics changed.
- Prefer hot-path simplicity and predictable completion behavior over convenience magic.

## Bug Avoidance and Red Flags
- Repeated completion callbacks caused by failing to clear `fsm.motion`.
- Legacy field aliases (`aspd`) that preserve names but silently change units.
- Accepting generic target tables without fully defining liveness and coordinate guarantees.

## Debug Signals and Inspection Hooks
- The next implementation pass should verify that `onEnd` fires exactly once for `dur` expiry and dead-target termination.
- If compatibility changes land, add a quick repro for old `aspd`-style inputs versus per-second inputs.

## Reusable Experience and Lessons
- A shared runtime-layer bug can make a leaf-module review look worse than it is; audit the execution contract before localizing blame.
- J-to-Lua compatibility needs semantic review, not just field-name carryover.

## Active Improvements
- Created a dedicated Surround audit report for future fix work.

## Route Review and Framework Compatibility Notes
- Surround's `dur` and dead-target exits are currently correct only at the return-value level; the Motion framework does not actually clear the motion slot afterward.
- The current API surface looks broader than the concrete runtime checks.
- Hot-path lookups and angle conversions are small but easy wins once correctness is settled.

## Tooling Guidance
- Preferred approach: static source audit plus targeted reference comparison.
- Task-local tools active: none.
- Shared mutable project tools active: none used in this review pass.
- Canonical references active: the J surround implementation under `Reference (not included in the project)` served as the main behavior reference for this audit.

## Recent Retrospective Signals
- Comparing the leaf module against both its sibling motion module and the older J implementation surfaced compatibility drift quickly.

## Open Risks and Watch Items
- Fixing only `Surround.lua` without correcting `Motion.Entry` would leave completion semantics broken.
- Preserving the `aspd` alias without deciding its units will keep migration behavior ambiguous.
- If the module is expected to orbit non-unit targets, the target contract needs explicit enforcement.

## Update Log
- 2026-04-06: Initial summary created.
- 2026-04-07: Added static audit findings for Surround, including shared cancellation bug, legacy `aspd` mismatch, and hot-path improvement opportunities.
