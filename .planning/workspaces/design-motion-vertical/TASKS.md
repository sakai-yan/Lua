# Tasks

## Active
- None. The broadened implementation slice is complete.

## Ready
- Run an in-engine smoke test for `vertical`, `jump`, and finite `hover` if runtime verification is needed next.
- Decide later whether a distinct bounce / spring vertical model is justified by a real caller.

## Blocked
- None.

## Done
- Audited `Charge.lua`, `Bezier3.lua`, `Surround.lua`, `EffectSportDown.j`, and motion design notes to constrain the vertical-family route.
- Refreshed the `design-motion-vertical` planning route for multiple common vertical motions.
- Preserved `Motion.vertical` as the base monotonic solver.
- Added `Motion.up` and `Motion.down` as thin direction-normalizing wrappers.
- Added `Motion.jump` for timed vertical arc / hop motion.
- Added `Motion.hover` for oscillating floating motion.
- Renamed the production file from `Down.lua` to `Vertical.lua`.
- Added detailed Chinese function comments and usage examples to the library source.
- Validated `Vertical.lua` with `luac -p`.
- Validated `Vertical.lua` with `loadfile`.
- Synced planning artifacts with the broadened route, rename, validation, and documentation boundary.
