# Debug Journal

## Audit Focus / Symptom
- The vertical motion leaf module needed to grow from one direct solver into a broader but still disciplined family of common vertical motions.

## Reproduction / Baseline
- Baseline observation: the vertical library started from `Down.lua` and later needed a clearer production filename.
- Historical reference was limited to downward motion in `EffectSportDown.j`.

## Signals and Debug Interfaces
- Source audit of sibling motion modules
- Source audit of `EffectSportDown.j`
- Motion design notes from `doc/运动器与碰撞框架设计.md`
- `luac -p` parse check
- `loadfile` parse check

## Hypotheses
- The best broadening route would be to split the family by runtime model rather than add many semantic aliases.
- The entire expansion could stay inside `Down.lua` without a framework conflict.

## Experiments
- Compared sibling motion modules for tick-shape patterns and config style.
- Compared the old J reference to see which behavior was useful and which API surface was legacy baggage.
- Implemented the broadened family and reran static validation.

## Findings / Root Cause
- The framework already supported the expansion; the main design problem was API and runtime-model grouping, not missing shared capability.
- The cleanest family split was monotonic displacement, timed arc, and oscillation.

## Fix / Mitigation Verification
- Added `vertical`, `up`, `down`, `jump`, and `hover` under one leaf module.
- Kept wrappers thin and kept distinct runtime logic only where the model genuinely changed.
- Renamed the production file to `Vertical.lua` and verified it with `luac -p` and `loadfile`.

## Session Sync Summary
- The broadened requirement still fit the same task and the same framework; only the route and completion slice needed refresh.

## Task Board Sync
- Active: none
- Ready: optional in-engine smoke test
- Blocked: none
- Done: route refresh, implementation expansion, static validation, planning sync

## Retained Debug Interfaces
- No new runtime debug interface was added.

## Cleanup
- No temporary diagnostics were introduced.

## Next Questions
- Whether a future caller will justify bounce / spring vertical motion.
- Whether hover end behavior should become configurable in a later task.
