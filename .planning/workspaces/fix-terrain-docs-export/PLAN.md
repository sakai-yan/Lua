# Execution Plan

## Planning Mode
- Profile: Quick
- Task type(s): mixed (`bugfix` + `documentation hardening`)

## Project Context
- Context type: framework/library
- Selected pattern: targeted hardening

## Requirement Integration
- Replace `os.execute` usage inside `Terrain.lua` because the current environment does not support it.
- Add missing comments and usage notes without broadening scope beyond the Terrain module.
- Validate the result with static parsing and repo search because no runtime harness is available in this turn.

## Technical Route Strategy
- Approved route: keep the Terrain public API intact, replace shell-based directory creation with optional Lua-side filesystem adapters (`filesystem`, `lfs`) plus explicit failure messaging, then add module/public API documentation.
- Fixed decisions: no caller changes, no algorithm rewrite, no `.canon` edits, no new shared tools.
- Open detail: if neither optional filesystem module is available, exporting should fail cleanly with an explanatory error instead of silently trying shell commands.
- Framework review rule: preserve `Terrain.getZ`/`writeHeightMap` contracts and keep initialization/query behavior unchanged.

## Workspace
- Project root: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua
- Planning container: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Task workspace: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/fix-terrain-docs-export
- Task slug: fix-terrain-docs-export
- Task-local tools directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/fix-terrain-docs-export/tools
- Project toolset directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical reference directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon
- Reports directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/fix-terrain-docs-export/reports
- Dynamic memory and execution artifacts stay in the matching task workspace, not in the shared skill folder.

## Knowledge Inputs
- The `terrain-sync-z-heightmap` workspace summary supplied the active Terrain API and risk model.
- `doc/HeightMapZ.j` informed the expected bake/import workflow wording.
- Canonical `w3x2lni` scripts showed that some local environments expose a `filesystem` module, so the new route should support it opportunistically instead of requiring it.

## Assumptions
- `Terrain.writeHeightMap` should remain available even if directory creation is only best-effort.
- Optional modules may differ by host environment, so the implementation should support both returned-module and global-`fs` styles for `filesystem`.

## Completion Standard
- Complete means: `Terrain.lua` no longer depends on `os.execute`, export failure is explicit when directory creation is unavailable, the public API is documented, and static parsing succeeds.
- Not acceptable: broad terrain refactors, silent behavior changes for query functions, or leaving the export path dependent on shell execution.

## Audit / Debug Strategy
- Inspect the existing `writeTextFile` path handling, verify adapter resolution for `filesystem`/`lfs`, and search the final file for `os.execute`.
- Reuse `luac -p` as the main static guard.
- Record route and validation outcome in `PROJECT_SUMMARY.md` and `SESSION.md`.

## Phase 1

### Goal
- Terrain export compatibility and documentation updates are implemented and statically validated.

### Inputs
- `Code/FrameWork/GameSetting/Terrain.lua`
- `doc/HeightMapZ.j`
- Prior workspace memory from `terrain-sync-z-heightmap`
- `.tools/lua53/bin/luac.exe`

### Outputs
- Updated `Terrain.lua`
- Updated planning workspace memory

### Dependencies
- The current Terrain export path and public API must be inspected first.

### Technical Route
- Replace shell directory creation with optional adapter-based directory creation and clear fallback errors.
- Add module header guidance and public function comments while preserving hot-path query behavior.

### Detailed Implementation Approach
- Add optional `filesystem` / `lfs` resolution near the top of `Terrain.lua`.
- Add helper functions to normalize optional filesystem calls and recursively create directories when `lfs` is available.
- Keep `queryZ` and the Terrain public API names unchanged.
- Add module-level usage notes plus public API doc comments.

### Risks
- Optional filesystem modules may not exist in every environment.
- Documentation edits must not accidentally alter code structure or break parsing.

### Requirement Alignment
- Environment compatibility without `os.execute`
- Missing documentation and usage guidance

### Architecture Fit Review
- This route fits the existing framework because it keeps all Terrain query contracts intact and only changes export helper internals plus docs.
- The main improvement after review was choosing optional filesystem adapters instead of simply dropping directory creation support.

### Explicitly Unresolved Details
- Whether a host exposes `filesystem`, `lfs`, or neither is resolved at runtime.
- Any fallback must remain non-shell-based and must fail explicitly rather than silently succeeding.

### Diagnostic Hooks / Signals
- `luac -p` parse success
- Repo search showing no active `os.execute` usage in `Terrain.lua`

### Relevant Experience / Standards
- Preserve shared-library public contracts.
- Prefer local-scope edits for user-requested single-module work.
- Record validation gaps explicitly when runtime testing is unavailable.

### Required Capabilities
- `repo_audit`
- `detail_gap_resolve`
- `phase_plan`
- `test_strategy`
- `session_update`

### Validation
- Run `.tools/lua53/bin/luac.exe -p` on `Terrain.lua`.
- Search the file for `os.execute`.
- Review the edited module header and public API docs for clarity.

### Expected Summary Updates
- Record the adapter-based export route, documentation additions, validation outcome, and residual risk about environments that still lack directory creation helpers.

### Expected Tool / Report Updates
- No task-local or shared mutable tools are expected.
- The main behavior inputs are `doc/HeightMapZ.j` and the prior Terrain workspace summary.
- No extra reports are required for this quick task.

## Replan Triggers
- Runtime evidence that the new adapter route breaks export behavior in the target host.
- A new user requirement to refactor other terrain modules or callers.

## Definition of Done
- `Terrain.lua` is updated, statically validated, documented, and workspace memory is synced.
