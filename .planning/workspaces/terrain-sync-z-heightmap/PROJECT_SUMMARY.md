# Project Summary

## Current Mission
- Provide a synchronous, caller-compatible terrain height query in `Terrain.lua` without relying on the async `MHGame_GetAxisZ` API.

## Context Snapshot
- Task label: Terrain sync Z heightmap rewrite
- Task slug: terrain-sync-z-heightmap
- Task type(s): mixed (`rewrite` + `feature hardening`)
- Project context: framework
- Selected pattern: `rewrite_parity`
- Planning container: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning
- Task workspace: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/terrain-sync-z-heightmap
- Project toolset: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.tools
- Canonical references: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.canon

## Planned Technical Route Baseline
- Prefer baked `HeightMapCode` at runtime so all players read identical terrain data.
- When baked data is absent, sample with `MHGame_GetAxisZ` as the generation source instead of rebuilding terrain behavior from cliff/water metadata.
- Serve `Terrain.getZ` from a fast bilinear interpolation path over sampled data and keep a lazy `ensureInitialized()` guard for early callers.
- Expose optional export support through Lua-standard file writing so the map can follow the intended “generate once, import, then sync-read” workflow.
- For release performance, precompute bilinear cell coefficients during initialization so runtime lookup only needs one cell index lookup plus the compact `a + b*rx + c*ry + d*rx*ry` evaluation.
- Keep the public API surface narrow: `isReady`, `writeHeightMap`, `getZ/getLocZ/getTerrainZ`, `getUnitZ`, and `getUnitCoordinates`.

## Inherited Standards and Principles
- Preserve public contracts of shared libraries when rewriting internals.
- Prefer one-time preprocessing over repeated expensive runtime sampling in hot paths.
- Keep scope local when the user explicitly restricts edits to one module.

## Bug Avoidance and Red Flags
- Do not route sync gameplay logic back through `MHGame_GetAxisZ`.
- Clamp edge queries correctly so interpolation never indexes outside sampled bounds.
- Avoid hidden allocations or nested-table churn in the hot query path.
- Watch for off-by-one errors in the flat-array rewrite of the sampled height map.
- Remember that missing baked code in multiplayer is still a release risk, even though the library now warns about it.

## Debug Signals and Inspection Hooks
- `Terrain.isReady()` is the retained init-state signal.
- Repo search results identifying current `Terrain.getZ` consumers are part of the compatibility record.

## Reusable Experience and Lessons
- `HeightMapZ.j` remains the best local reference for the bake/export/import workflow, even when the runtime interpolation strategy is simplified.
- The project's `Game.hookInit` model is a practical place for library-side preprocessing when callers expect sync APIs.

## Active Improvements
- Terrain height lookup now avoids the async/local-only API in normal gameplay code while still allowing `MHGame_GetAxisZ` during bake-time generation.
- Internal storage was modernized from nested tables to flatter arrays to reduce per-query overhead.
- Runtime cliff/water branching was removed in favor of denser sampling and a simpler query path.
- Runtime corner fetches were further reduced by moving bilinear coefficient derivation into initialization.
- The hot path is now a single local `queryZ` function instead of layered `getTerrainZ -> getBilinearZ -> resolveCell` wrappers.
- Init-time zero-filling and several debug/convenience public APIs were removed because they did not help runtime behavior.

## Route Review and Framework Compatibility Notes
- `Unit.lua` currently expects immediate numeric results and needs no changes with the new Terrain route.
- `Terrain` is loaded early enough that `Game.hookInit(ensureInitialized)` fits the existing startup sequence cleanly.
- Repo search shows the removed convenience APIs were unused inside the project, so trimming them did not break current in-repo callers.

## Tooling Guidance
- Preferred tools for this slice were repo search, direct file inspection, and planning-os workspace tracking.
- No task-local or shared mutable tool changes were required.
- The main behavioral reference was `doc/HeightMapZ.j`.
- Syntax validation for this module should use `.tools/lua53/bin/luac.exe`.

## Recent Retrospective Signals
- The narrow Terrain-only scope worked well because the caller contract was small and easy to preserve.
- The lack of a local Lua runtime means future similar tasks should expect explicit runtime validation gaps unless a harness is available.

## Open Risks and Watch Items
- Actual in-game parity should still be spot-checked on this specific map, especially near sharp terrain transitions.
- `SAMPLE_STEP = 64` is a convenience/accuracy tradeoff and may need tuning.
- Missing baked data in release multiplayer remains an operator error the library cannot fully save at runtime.
- If later optimization still feels necessary, the next larger gain likely lives in caller-side repeated `actor.z/target.z` access rather than in Terrain’s math itself.
- The kept `cell_coeff_*` arrays are a deliberate time-vs-memory tradeoff; if memory becomes more important than query throughput on a specific map, this is the first knob to revisit.

## Update Log
- 2026-04-08: Initial summary created.
- 2026-04-08: Recorded the synchronous Terrain height-map rewrite route and static validation outcome.
