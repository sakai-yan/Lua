# Step Plan

## Current Step
- Name: Implement and statically validate the `Terrain` height-map rewrite
- Parent phase: Phase 1
- Why now: the repo currently routes `Terrain.getZ` straight to an async API that does not satisfy the user's sync requirement.

## Step Objective
- `Terrain.lua` is rewritten, the synchronous query contract is preserved, export logic is Lua-native, Chinese comments are complete enough for maintenance, and validation notes are explicitly documented.

## Requirement Alignment
- HeightMapZ-inspired synchronous terrain lookup
- Terrain-only modification scope
- High-efficiency, low-overhead implementation
- Lua-native export flow and complete Chinese documentation

## Planned Technical Route
- Follow the approved route of init-time sampling plus query-time interpolation.
- Keep `Terrain.getZ(x, y)` returning a number immediately.
- Avoid edits to any non-`Terrain` file.

## Framework Compatibility Review
- The route must fit `Game.execute()` and `Game.hookInit`, and must remain compatible with `Unit.lua`.
- The route fits cleanly because `Terrain` is loaded before entity use and only current `Unit` callers depend on immediate numeric results.
- No replan was required after review.

## Detail Resolution Focus
- Decide whether to keep helper exports such as `getLocZ` and `getUnitZ`.
- Decide whether defensive input handling should return `0.0` or raise.
- Resolve indexing layout in a way that reduces memory overhead without making the interpolation logic unreadable.

## Required Inputs
- `doc/HeightMapZ.j`
- `Code/FrameWork/GameSetting/Terrain.lua`
- `Code/Core/Entity/Unit.lua`
- `Code/Game.lua`
- `Code/Main.lua`

## Relevant Project Memory
- Current task workspace plan and the repo's existing init/caller conventions.

## Standards / Bug Avoidance Applied
- Preserve public contract when replacing a shared module.
- Avoid direct use of async/local-only terrain APIs inside sync gameplay logic.
- Keep query hot paths free of table allocation and unnecessary branching.

## Debug / Inspection Plan
- Audit init order and compare interpolation formulas to `HeightMapZ.j`.
- Retain `Terrain.isReady()` as the minimal useful runtime signal.
- Confirmation comes from code inspection, caller audit, and removal of the direct `MHGame_GetAxisZ` alias.

## Completion Standard
- Acceptable completion means real code landed in `Terrain.lua` with compatibility preserved and validation notes recorded.
- Not acceptable: TODO placeholders, leaving `getZ` unsafe, or deferring the actual rewrite.

## Temporary Detailed Actions
- Audit current Terrain, HeightMapZ, init flow, and call sites.
- Rewrite `Terrain.lua` around sampled height-map data, Lua-native export, and fast interpolation.
- Add complete Chinese comments for the module, core helpers, and public API.
- Statically review the result and run `.tools/lua53/bin/luac.exe -p`.
- Sync workspace artifacts with decisions, risks, and validation notes.

## Validation
- Read-back inspection of `Terrain.lua`
- Repo search for `Terrain.getZ` callers
- Environment probe for `lua` / `luac` availability

## Replan / Abort Conditions
- Hidden callers requiring different semantics
- Runtime constraints that make init-time sampling unacceptable
- User broadening the task beyond Terrain-only scope

## Summary Updates Expected
- The final route, compatibility assumptions, and the remaining runtime-only validation gap.
