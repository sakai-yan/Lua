# Execution Plan

## Planning Mode
- Profile: Standard
- Task type(s): mixed (`rewrite` + `feature hardening`)

## Project Context
- Context type: framework
- Selected pattern: `rewrite_parity`

## Requirement Integration
- The user clarified that both native point-Z sampling and `MHGame_GetAxisZ` are async/local, but `MHGame_GetAxisZ` is preferred as the bake-time sampler because it is more convenient and avoids reconstructing terrain details from cliff/water metadata.
- The user restricted edits to the `Terrain` library, so compatibility work happens by preserving the existing `Terrain.getZ` call shape rather than changing callers.
- The efficiency requirement now applies to runtime rather than bake-time: accept heavier one-time offline generation if it simplifies runtime query logic into plain sampled-data interpolation.
- The user additionally required the library to use modern Lua features for export/storage flow, to provide full Chinese function comments, and to validate with the `luac` shipped in `.tools`.

## Technical Route Strategy
- Approved route: rewrite `Terrain.lua` so it prefers reading baked `HeightMapCode`, otherwise samples with `MHGame_GetAxisZ`, uses Lua-standard encoding and file output for export, and serves runtime Z queries from a simple sampled height map without cliff/water reconstruction branches.
- 发布期查询优化策略：在初始化阶段为每个采样单元预计算双线性插值系数，把热路径中的四角点读取与差值运算前移。
- Fixed decisions before execution: only `Terrain.lua` changes; `Terrain.getZ` stays synchronous; `MHGame_GetAxisZ` is used only as a sampler, not as the runtime query implementation; init uses `Game.hookInit` plus a lazy `ensureInitialized()` safeguard.
- Intentionally open details: sample density tradeoff, whether to expose manual export helpers, and how strong runtime warnings should be when baked data is missing.
- Framework review focus: verify the route fits `Game.execute()` ordering and preserves `Unit.lua` compatibility without requiring caller changes.

## Workspace
- Project root: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua
- Planning container: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning
- Task workspace: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/terrain-sync-z-heightmap
- Task slug: terrain-sync-z-heightmap
- Task-local tools directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/terrain-sync-z-heightmap/tools
- Project toolset directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.tools
- Canonical reference directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.canon
- Reports directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/terrain-sync-z-heightmap/reports
- Dynamic memory and execution artifacts stay in the matching task workspace, not in the shared skill folder.

## Knowledge Inputs
- Informed by: `doc/HeightMapZ.j`, the current `Terrain.lua`, `Unit.lua`, `Game.lua`, `Main.lua`, and `Timer.lua`.
- No canonical `.canon/` implementation was used as the direct behavioral source for this task.

## Assumptions
- `Game.execute()` runs after library load and before normal gameplay consumers need terrain height.
- Sampling via `MHGame_GetAxisZ` is acceptable for bake-time generation even though it is local/async, because the intended release workflow reads imported baked data instead of regenerating live.
- `Unit.lua` is the only current direct consumer of `Terrain.getZ`, based on repo search.

## Completion Standard
- Complete means `Terrain.lua` contains the synchronous height-map implementation, `Terrain.getZ` remains compatible, and the old unsafe direct binding is gone.
- Not acceptable: leaving `MHGame_GetAxisZ` as the main implementation, requiring caller rewrites, or stopping at a plan without real code.

## Audit / Debug Strategy
- Inspect init sequencing from `Main.lua` -> `Game.execute()` -> `Game.hookInit` callbacks.
- Compare the baked-code/export workflow against `HeightMapZ.j`, especially how generation and release-time syncing are separated.
- Use static code review and repo search as the available verification path; note explicitly when runtime validation could not be performed locally.

## Capability Routing Rules
- Required capabilities are written as stable names.
- Implementation is resolved at execution time.

## Phase 1

### Goal
- `Terrain.lua` is rewritten to provide synchronous terrain Z lookup with init-time precomputation and caller-compatible query APIs.

### Inputs
- `doc/HeightMapZ.j`
- `Code/FrameWork/GameSetting/Terrain.lua`
- `Code/Core/Entity/Unit.lua`
- `Code/Game.lua`
- `Code/Main.lua`

### Outputs
- Rewritten `Terrain.lua`
- Updated planning workspace artifacts documenting route, validation, and risks

### Dependencies
- Height-map behavior and init sequencing must be understood well enough to preserve compatibility.

### Technical Route
- Replace the direct API alias with a private bake/read pipeline.
- Capture sampled axis-Z values on a denser fixed grid.
- Use a single bilinear interpolation path at runtime and drop cliff/water reconstruction logic.

### Detailed Implementation Approach
- Rewrite `Code/FrameWork/GameSetting/Terrain.lua` into a stateful module with one-time init state, world-bound capture, flat-array sample storage, baked-code encoder/decoder, fast query helpers, Lua `io.open`-based export helpers, and full Chinese comments for public and core internal functions.
- Fixed implementation details: no cross-file edits, runtime query path stays allocation-free, release-time syncing relies on baked `HeightMapCode`, and syntax validation uses `.tools/lua53/bin/luac.exe`.
- Keep bilinear interpolation semantics unchanged while replacing per-query corner reconstruction with precomputed `a/b/c/d` cell coefficients.

### Risks
- Runtime parity still depends on chosen sample density because removing cliff/water reconstruction trades metadata complexity for denser sampling.
- Incorrect index math in the flat-array rewrite could distort heights near cell boundaries.
- If baked code is missing in multiplayer, the fallback live generation path remains local-only and should be treated as development-only.

### Requirement Alignment
- Sync-safe terrain Z lookup
- Terrain-only modification scope
- Efficiency and low query overhead
- HeightMapZ-inspired bake/export/import behavior

### Architecture Fit Review
- The route fits the existing framework because `Terrain` is already required before entity use, and `Game.hookInit` allows eager construction without caller changes.
- The design was tightened by flattening storage arrays, exposing a manual export helper, and separating baked-code runtime use from local-only live generation.

### Explicitly Unresolved Details
- Whether the default `SAMPLE_STEP` should remain `64`, become `32`, or be made map-specific.
- Any unresolved detail must keep `Terrain.getZ(x, y)` synchronous and preserve Terrain-only edit scope unless the user broadens it.

### Diagnostic Hooks / Signals
- `Terrain.isReady()` is sufficient as a retained signal for init state.
- Repo search results and static formula comparison serve as the current audit record.

### Relevant Experience / Standards
- Preserve existing public contracts when replacing foundational library behavior.
- Prefer one-time preprocessing over repeated expensive runtime calls in hot paths.

### Required Capabilities
- `repo_audit`
- `route_detail_design`
- `planned_route_framework_review`
- `phase_plan`
- `test_strategy`
- `project_summary_curate`

### Validation
- Static review of `Terrain.lua` logic and interpolation branches
- Repo search to verify current call-site compatibility
- Use `.tools/lua53/bin/luac.exe -p` for syntax validation

### Expected Summary Updates
- Record the chosen synchronous height-map route, compatibility notes, and remaining runtime validation risk.

### Expected Tool / Report Updates
- No task-local or project-shared tool changes are required for this slice.
- The main record lives in the planning markdown artifacts for this task.

## Replan Triggers
- Discovery of hidden callers that need a different terrain-height contract
- Runtime verification showing unacceptable divergence from expected terrain height
- User widening the task beyond `Terrain.lua`

## Definition of Done
- `Terrain.getZ` is synchronous and no longer directly aliases `MHGame_GetAxisZ`
- The height-map implementation is present in `Terrain.lua`
- Existing `Unit` compatibility is preserved without editing other files
- Validation notes and remaining risks are written into the task workspace
