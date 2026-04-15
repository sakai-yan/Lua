# Step Plan

## Current Step
- Name: Rename and document the vertical-motion library as `Vertical.lua`
- Parent phase: Phase 1
- Why now: the user explicitly broadened the task from one solver to several common vertical motions, and the work still fits the same leaf-module boundary.

## Step Objective
- `Vertical.lua` implements the approved vertical-motion family, uses the new library filename, carries detailed Chinese function notes, and passes static validation.

## Requirement Alignment
- Learn from sibling motion modules before coding.
- Optimize for low overhead and a short hot path.
- Keep all runtime code changes inside the vertical-motion library.
- Add several common vertical motions without creating API sprawl.

## Planned Technical Route
- Keep `Motion.vertical` as the base monotonic solver.
- Add thin `up/down` wrappers over the base solver.
- Add `jump` for timed arc / hop motion.
- Add `hover` for oscillating floating motion.
- Use only a few high-value helpers shared by the family.

## Framework Compatibility Review
- The implementation must fit the existing `move_func` adapters and `Motion.set` lifecycle.
- No framework conflict is expected because sibling leaf modules already own their setup logic and move-method callbacks.
- The route remains compatible as long as `Vertical.lua` does not try to change `Motion.Entry`.

## Detail Resolution Focus
- Choose which motions deserve their own runtime model versus a thin wrapper.
- Keep helper extraction minimal so the file stays direct.
- Preserve exact end behavior for finite motions and predictable base-z behavior for hover.
- Keep wrapper config naming aligned with sibling motion modules when the semantics match, such as using `max_distance`.

## Required Inputs
- `Code/Logic/Process/Motion/Vertical.lua`
- `Charge.lua`, `Bezier3.lua`, `Surround.lua`
- `EffectSportDown.j`
- `doc/运动器与碰撞框架设计.md`
- Repo-local Lua 5.3 validators in `.tools/lua53/bin`

## Relevant Project Memory
- `PROJECT_PLAYBOOK.md` for motion-leaf style constraints
- `implement-motion-bezier3/PROJECT_SUMMARY.md` for recent style guidance
- The earlier `design-motion-vertical` summary for the approved direct vertical baseline
- This task's refreshed `PLAN.md`

## Standards / Bug Avoidance Applied
- No per-tick table allocation.
- No shared-runtime edits outside `Vertical.lua`.
- No alias explosion.
- No non-terminating finite motion.
- No unnecessary new update loops when a wrapper can reuse an existing runtime model.

## Debug / Inspection Plan
- Audit the family layout for duplication and hot-path churn.
- Inspect the exact end behavior of `vertical`, `jump`, and finite `hover`.
- Use static syntax/load validation instead of temporary runtime instrumentation.

## Completion Standard
- A compact vertical-motion family with public usage notes, passing static validation, and synchronized planning memory.
- Not acceptable: a pile of semantic aliases, TODO-driven placeholders, or a file that now depends on changing sibling modules later.

## Temporary Detailed Actions
- Rename the file to `Vertical.lua`.
- Add detailed Chinese helper/public API notes and usage examples.
- Re-run `luac -p` and `loadfile`.
- Refresh summary, tasks, session, and lessons with the broadened route.

## Validation
- `.\.tools\lua53\bin\luac.exe -p Code\Logic\Process\Motion\Vertical.lua`
- `.\.tools\lua53\bin\lua.exe -e "assert(loadfile('Code/Logic/Process/Motion/Vertical.lua'))"`
- Manual source review of helper count and hot paths

## Replan / Abort Conditions
- A framework conflict in `Motion.Entry`
- Discovery of a real caller that requires a different vertical family split immediately
- Validation failure caused by an unforeseen loader/runtime contract

## Summary Updates Expected
- Record the final vertical-motion family, validation results, and open extension risks in `PROJECT_SUMMARY.md`.
- Promote only cross-task guidance about runtime-model grouping into `PROJECT_PLAYBOOK.md`.
