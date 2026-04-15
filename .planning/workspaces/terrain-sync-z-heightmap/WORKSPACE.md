# Task Workspace

## Task Identity
- Task label: Terrain sync Z heightmap rewrite
- Task slug: terrain-sync-z-heightmap
- Matching rule: Reuse this workspace only when a later request still targets the same normalized objective, primary surface, and completion slice.
- Split rule: Create a sibling task workspace when the request becomes materially different and the existing task board or summary would become misleading.

## Scope Snapshot
- Current normalized objective: Replace the unsafe async `Terrain.getZ` implementation with a synchronous height-map-based terrain Z query inspired by `doc/HeightMapZ.j`.
- Primary surfaces: `Code/FrameWork/GameSetting/Terrain.lua`, `doc/HeightMapZ.j`, and the `Code/Core/Entity/Unit.lua` call contract that depends on `Terrain.getZ(x, y)` returning a number immediately.
- Explicit exclusions: No edits outside `Terrain.lua`; no rollout changes to `Unit`, `Ability`, `Missile`, or other callers; no file export/import workflow unless later requested.

## Continuation Signals
- Reuse this workspace when: the request is still about synchronous terrain Z lookup, height-map generation, cliff interpolation, or follow-up validation for the `Terrain` library.
- Create a new sibling workspace when: the task expands into a broader terrain subsystem redesign, runtime tooling, map-side benchmarking, or a multi-file API migration.

## Workspace Paths
- Project root: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua
- Planning container: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning
- Task workspace: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/terrain-sync-z-heightmap
- Task-local tools directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/terrain-sync-z-heightmap/tools
- Project toolset directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.tools
- Canonical reference directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.canon
- Reports directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/terrain-sync-z-heightmap/reports

## Notes
- This workspace owns `PLAN.md`, `STEP_PLAN.md`, `TASKS.md`, `SESSION.md`, `PROJECT_SUMMARY.md`, and related execution artifacts for this task only.
- Task-only helpers can live in `D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/terrain-sync-z-heightmap/tools`; reusable mutable project tools can move to `D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.tools`.
- Treat `D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.canon` as canonical read-only input unless the task is explicitly about maintaining reference material.
- Cross-task knowledge should be promoted intentionally instead of being mixed here by default.
