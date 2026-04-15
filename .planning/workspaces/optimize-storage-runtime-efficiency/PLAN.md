# Execution Plan

## Planning Mode
- Profile: Standard
- Task type(s): library refactor, runtime efficiency optimization, brownfield maintenance

## Project Context
- Context type: brownfield shared runtime/library in an existing planning container
- Selected pattern: inspect current source -> rebase on project-wide style summary -> land narrow runtime refactor -> validate syntax -> sync task memory

## Requirement Integration
- The user asked for Storage optimization with high efficiency and low consumption, so the route focuses on shorter direct paths and smaller batch-path overhead instead of broader feature work.
- The user explicitly said to set aside older conclusions and analyze comprehensively again, so this plan treats current source plus current project-wide style documentation as authoritative.
- The user pointed out that the project already had a code-style experience summary, so `doc/项目代码风格总结-2026-04-11.md` is treated as the style baseline for route decisions.

## Technical Route Strategy
- Approved route: keep the fixed-slot array plus reverse lookup tables, then tighten direct runtime helpers and batch APIs where current invariants already justify a more direct implementation.
- Fixed decisions before execution:
- No new secondary occupied-slot index or larger data-structure redesign in this pass.
- No broad Event framework refactor in this pass.
- Preserve the existing post-mutation event model.
- Open details at execution time:
- Which specific helpers are worth inlining or fast-pathing after source review.
- How far batch-path optimization can go without breaking reentrant event safety.
- Framework review rule: each optimization must still fit the project style baseline of flat ownership, setup-time normalization, and hot-path trust of established contracts.

## Workspace
- Project root: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua
- Planning container: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Project playbook: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/optimize-storage-runtime-efficiency
- Task slug: optimize-storage-runtime-efficiency
- Task-local tools directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/optimize-storage-runtime-efficiency/tools
- Project toolset directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical reference directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon
- Reports directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/optimize-storage-runtime-efficiency/reports
- Dynamic memory and execution artifacts stay in the matching task workspace, not in the shared skill folder.

## Knowledge Inputs
- Project-wide style summary: `doc/项目代码风格总结-2026-04-11.md`
- Historical style lineage: `doc/Bezier3代码风格总结-2026-04-10.md`
- Cross-task memory: `.planning/PROJECT_PLAYBOOK.md`
- Direct dependency/source review: `Storage.lua`, `Array.lua`, `Class.lua`, `DataType.lua`, `Event.lua`
- No `.canon/` reference is currently authoritative for this task.

## Assumptions
- `storage.first_free` is maintained strongly enough by the mutation helpers to support direct auto-slot fast paths.
- The existing public API surface should remain recognizable to callers even if some internals become more direct.
- Syntax validation is the only fully reliable automated check available in this task environment.

## Completion Standard
- Complete delivery means `Storage.lua` is reanalyzed against the project-wide style baseline, targeted runtime-efficiency improvements are implemented, syntax validation passes, and this workspace reflects the new route and findings.
- Not acceptable:
- Leaving the task at analysis-only.
- Widening into unrelated framework work without necessity.
- Adding heavier structure just to make scan APIs cheaper if that worsens hot-path ownership or maintenance cost.

## Audit / Debug Strategy
- Inspect source-level invariants around `first_free`, reverse lookup tables, and event emission order.
- Treat reentrant event callbacks as the main semantic constraint when simplifying batch paths such as `clear`.
- Use direct source inspection, `rg`, and `luac -p` rather than building new tooling for this pass.
- Record the retained findings in `PROJECT_SUMMARY.md`, `SESSION.md`, and `DEBUG_JOURNAL.md`.

## Capability Routing Rules
- Required capabilities are written as stable names.
- Implementation is resolved at execution time.

## Phase 1

### Goal
- `Storage.lua` is optimized in the places where the current data model already supports a more direct implementation, and the resulting route is recorded clearly.

### Inputs
- `Code/Logic/Process/Item/Storage.lua`
- `doc/项目代码风格总结-2026-04-11.md`
- `.planning/PROJECT_PLAYBOOK.md`
- `Code/Lib/Base/Array.lua`
- `Code/Lib/Base/DataType.lua`
- `Code/FrameWork/Manager/Event.lua`

### Outputs
- Updated `Code/Logic/Process/Item/Storage.lua`
- Updated task workspace memory files
- Successful `luac -p` validation for `Storage.lua`

### Dependencies
- Source review and style-baseline review must finish before the final code adjustments are accepted.

### Technical Route
- Optimize the current library in place:
- Use `first_free` directly for no-argument auto-slot resolution.
- Localize hot reverse-lookup tables and other repeatedly used helpers.
- Reduce batch/helper overhead in `forEach` and `toTable`.
- Keep `clear` safe under event-triggered reentrancy by updating live state directly instead of caching mutable state across emits.

### Detailed Implementation Approach
- File scope stays inside `Code/Logic/Process/Item/Storage.lua`.
- Keep the slot-array model and weak reverse lookup tables.
- Replace repeated `Storage.__storage_by_item` / `Storage.__slot_by_item` lookups with local upvalues after class creation.
- Preserve event timing and action names.
- Allow small contract-cleanup only when it directly improves consistency, such as treating same-storage `add(item, false)` as idempotent instead of routing into an invalid move.

### Risks
- Any optimization that caches mutable state across `emit_change(...)` in a loop can become incorrect if callbacks mutate Storage again.
- A future caller may still expect behavior that is not observable from current local context; without a runtime test harness, semantic edits must stay narrow.

### Requirement Alignment
- Reanalysis from current source.
- Project-wide style alignment.
- High efficiency and low consumption.
- Narrow in-scope delivery instead of framework drift.

### Architecture Fit Review
- This route fits the project's preferred style because it keeps ownership flat, hot paths direct, and avoids decorative abstraction.
- The main route correction after review was recognizing that batch-path optimizations must respect event reentrancy, which ruled out stale local caches inside `clear`.

### Explicitly Unresolved Details
- Whether sibling libraries such as `Shop` should adopt similar optimizations is intentionally deferred.
- Any future broader optimization must keep the current task's "single-library refactor" boundary explicit.

### Diagnostic Hooks / Signals
- `storage.first_free`
- `storage.size`
- `Storage.getByItem(item)` / `Storage.getSlotByItem(item)`
- Existing `Event.onItemStorageChange(...)` listener path
- `luac -p`

### Relevant Experience / Standards
- `doc/项目代码风格总结-2026-04-11.md`
- `.planning/PROJECT_PLAYBOOK.md`
- The style rule that hot paths should trust setup-time invariants instead of repeatedly rescanning.
- The style rule that helpers should only survive when they provide real value.

### Required Capabilities
- `repo_audit`
- `route_detail_design`
- `planned_route_framework_review`
- `detail_gap_resolve`
- `test_strategy`
- `session_update`

### Validation
- Source re-review after the patch.
- `rg` search for stale direct-lookup patterns that should have been localized.
- `.tools/lua53/bin/luac.exe -p Code/Logic/Process/Item/Storage.lua`

### Expected Summary Updates
- Record the final optimization route, the reentrancy constraint discovered during `clear` review, and the validation result.

### Expected Tool / Report Updates
- No task-local helper needed for this pass.
- No project tool changes needed.
- No `.canon/` reference involved.
- No separate report file needed beyond the task memory sync.

## Replan Triggers
- Discovering that a required optimization cannot be made safely without changing `Event.lua`.
- Discovering real runtime callers that depend on a behavior not visible from current local source context.

## Definition of Done
- `Storage.lua` is updated.
- Syntax validation passes.
- The workspace reflects the reanalysis, implementation route, and validation caveats.
