# Debug Journal

## Audit Focus / Symptom
- `Terrain.getZ` was implemented as a direct alias to `Jass.MHGame_GetAxisZ`, which is async/local and unsafe for synchronized gameplay logic.

## Reproduction / Baseline
- Baseline observation came from reading `Code/FrameWork/GameSetting/Terrain.lua` and seeing the one-line direct alias.
- Caller audit showed `Unit.lua` expects a synchronous numeric return value.

## Signals and Debug Interfaces
- Repo search for `Terrain.getZ` and `MHGame_GetAxisZ`
- Static read-back of rewritten `Terrain.lua`
- Retained helper: `Terrain.isReady()`

## Hypotheses
- A precomputed height-map strategy can satisfy the sync requirement while keeping the caller contract unchanged.
- `Game.hookInit` is early enough for one-time terrain preprocessing.

## Experiments
- Reviewed `doc/HeightMapZ.j` in detail and compared its interpolation paths to the rewrite.
- Audited init flow through `Game.lua` and `Main.lua`.
- Probed the environment for `lua` / `luac` executables.

## Findings / Root Cause
- Confirmed root issue: the old Terrain library exposed the async API directly.
- Confirmed viable mitigation: Terrain-local sampled height map plus cliff-aware interpolation.
- Ruled out the need for caller rewrites in the current repo state.

## Fix / Mitigation Verification
- Verified statically by removing the direct alias, preserving the public function name, and reading back the new interpolation logic.
- Added `Terrain.isReady()` and a lazy `ensureInitialized()` path as guardrails.

## Session Sync Summary
- The durable fix is to replace runtime async sampling with init-time height-map preprocessing inside `Terrain.lua`.

## Task Board Sync
- Active: none
- Ready: in-game parity smoke checks on the target map
- Blocked: local runtime execution tooling is unavailable in this workspace
- Done: implementation rewrite, init review, caller audit, and static validation notes

## Retained Debug Interfaces
- `Terrain.isReady()`

## Cleanup
- No temporary diagnostics were added in repo code.

## Next Questions
- Runtime parity on map-specific terrain edge cases still needs Warcraft-side validation.
