# Project Brief

## Problem
- `Code/FrameWork/GameSetting/Terrain.lua` currently exposes `Jass.MHGame_GetAxisZ` directly as `Terrain.getZ`.
- `MHGame_GetAxisZ` is an async/local API, so different players can observe different Z values for the same coordinates.
- The project needs a synchronous terrain-height query that keeps the current call shape but avoids desync-prone runtime sampling.

## Project Context
- Which project context applies: `framework`.
- Why does this context change the planning approach? `Terrain` is a shared runtime library consumed by entity code, so compatibility, init timing, and low per-call overhead matter more than one-off implementation speed.

## Project-Local Workspace
- Project root: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua
- Planning container: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning
- Task workspace: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/terrain-sync-z-heightmap
- Task slug: terrain-sync-z-heightmap
- Task-local tools directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/terrain-sync-z-heightmap/tools
- Project toolset directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.tools
- Canonical reference directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.canon
- Reports directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/terrain-sync-z-heightmap/reports

## Goals
- Port the useful behavior from `doc/HeightMapZ.j` into `Terrain.lua`.
- Keep `Terrain.getZ(x, y)` synchronous and immediately returning `number`.
- Preserve compatibility with existing `Unit` code without editing any non-`Terrain` file.
- Prefer a low-overhead runtime path: do the expensive work once at init, keep query-time work allocation-free.

## Normalized Requirements
- Study `doc/HeightMapZ.j` and adapt its terrain-height strategy instead of direct async API access.
- Only modify the `Terrain` library.
- Optimize for efficiency and low consumption, which pushes the design toward precomputed height data plus fast interpolation.
- Keep the public usage compatible with existing consumers such as `Unit.z`.

## Non-Goals
- Editing `Unit.lua`, `Ability.lua`, `Region.lua`, `Missile.lua`, or any other caller.
- Building a map-side export/import pipeline for serialized height-map code.
- Adding new debugging UI or benchmark tooling outside the planning workspace.

## Constraints
- The implementation must live entirely inside `Code/FrameWork/GameSetting/Terrain.lua`.
- Existing game code expects `Terrain.getZ` to be a synchronous numeric lookup.
- The current workspace does not expose a local Lua interpreter or Warcraft runtime for direct execution tests.
- The solution must fit the existing `Game.hookInit` initialization model.

## Existing Knowledge Inputs
- `doc/HeightMapZ.j` is the behavioral baseline for precomputed terrain-height lookup and cliff handling.
- `Code/Core/Entity/Unit.lua` defines the immediate compatibility contract for `Terrain.getZ`.
- `Code/Game.lua` and `Code/Main.lua` define the init sequence available to the library.
- No `.canon/` implementation was copied directly; the task relied on in-repo docs and current runtime code.

## Audit / Debug Focus
- Verify that init-time sampling happens before normal gameplay consumers need terrain Z.
- Check that the cliff and triangle interpolation logic matches the `HeightMapZ.j` intent.
- Watch for indexing mistakes caused by rewriting the original 2D table approach into flatter arrays.

## Stakeholders / Surface
- `Terrain.getZ`, `Terrain.getLocZ`, and any future terrain-height helpers in `Terrain.lua`.
- `Unit.z` getter/setter and any future entity systems that use terrain height.

## Success Signals
- `Terrain.getZ` no longer calls `MHGame_GetAxisZ` directly.
- `Unit.lua` remains unchanged and still works with the new `Terrain.getZ`.
- The new implementation performs a one-time sample pass and then uses fast pure-Lua interpolation for queries.

## Open Questions
- Runtime parity on this specific map should still be confirmed in Warcraft, especially around walkable destructibles and unusual cliff/water boundaries.
