# Project Brief

## Problem
- `Terrain.lua` still relied on `os.execute` to create export directories, but the current user environment does not support that function.
- The module also lacked clear top-level usage guidance and public function documentation, which made the baked height-map workflow harder to reuse safely.

## Project Context
- Context: brownfield framework/library hardening.
- Why it matters: the work must preserve the existing Terrain API while only adjusting one shared module and its documentation.

## Project-Local Workspace
- Project root: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua
- Planning container: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Task workspace: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/fix-terrain-docs-export
- Task slug: fix-terrain-docs-export
- Task-local tools directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/fix-terrain-docs-export/tools
- Project toolset directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical reference directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon
- Reports directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/fix-terrain-docs-export/reports

## Goals
- Remove the runtime dependency on `os.execute` from `Terrain.lua`.
- Keep `Terrain.writeHeightMap` useful by supporting optional filesystem helpers when available and by returning explicit errors when directory creation is impossible.
- Add module-level usage notes plus public API comments for the Terrain library.
- Validate that the edited Lua file still parses.

## Normalized Requirements
- User requirement: current environment does not support `os.execute`.
  Technical translation: replace shell-based directory creation with Lua-side optional adapters (`filesystem`, `lfs`) plus a clear fallback error path.
- User requirement: missing function comments and usage instructions.
  Technical translation: add a module header that explains the bake/import workflow and add public API doc comments for `isReady`, `writeHeightMap`, `getZ` aliases, `getUnitZ`, and `getUnitCoordinates`.

## Non-Goals
- No changes to caller modules such as `Unit.lua`.
- No changes to terrain interpolation math, sampling density, or runtime sync strategy.
- No attempt to guarantee directory creation in environments that expose neither `filesystem` nor `lfs`.

## Constraints
- Public Terrain API must remain source-compatible.
- `.canon` remains read-only reference input.
- Validation is limited to static Lua parsing in this workspace; no in-game runtime harness is available in this turn.

## Existing Knowledge Inputs
- The prior workspace `terrain-sync-z-heightmap` documents the current Terrain public API and risk model.
- `doc/HeightMapZ.j` remains the local behavior/workflow reference for generate-import-validate usage.
- Existing repo conventions favor local-scope edits and LuaDoc-style comments for shared libraries.

## Audit / Debug Focus
- Inspect the export path handling in `Terrain.writeHeightMap` and verify that no `os.execute` dependency remains in the module.

## Stakeholders / Surface
- Terrain library maintainers and any caller relying on `Terrain.writeHeightMap` or public height query helpers.

## Success Signals
- `Terrain.lua` contains no active `os.execute` usage.
- Public docs clearly explain how to bake and import `TerrainHeightMapCode`.
- `luac -p` succeeds for the edited module.

## Open Questions
- No blocking questions remained after local inspection; the route could proceed with a module-local change.
