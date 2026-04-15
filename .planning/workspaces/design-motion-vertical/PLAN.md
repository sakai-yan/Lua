# Execution Plan

## Planning Mode
- Profile: Standard
- Task type(s): feature, research

## Project Context
- Context type: brownfield motion-framework leaf module
- Selected pattern: library_or_framework_design

## Requirement Integration
- The user explicitly broadened the task from one vertical solver to several common vertical motions, so the route now groups the work by runtime model rather than keeping a single-entry API.
- The user still wants the same style as `Charge`, `Bezier3`, and `Surround`, so the implementation must stay direct, flat-configured, setup-heavy, and local to the vertical-motion leaf module.
- The user still forbids edits to other libraries, so the solution must not lean on `Entry.lua` changes or sibling-module refactors.
- The user asked for common game motions, so the route chooses a small set with strong practical coverage instead of many naming aliases.

## Technical Route Strategy
- Rename the production library file from `Code/Logic/Process/Motion/Down.lua` to `Code/Logic/Process/Motion/Vertical.lua`.
- Preserve `Motion.vertical(actor, config)` as the base monotonic rise/fall solver.
- Add thin `Motion.up` and `Motion.down` convenience wrappers that normalize `max_distance` / `delta_z` and reuse `Motion.vertical`.
- Add `Motion.jump(actor, config)` for timed vertical arc / hop behavior using normalized progress `t`.
- Add `Motion.hover(actor, config)` for sinusoidal floating / hovering behavior with optional duration.
- Share only a few high-value helpers across the family: current actor-method resolution, start-z preparation, end-z resolution, and z-only position commit.
- Keep runtime models distinct: monotonic distance-based vertical motion, normalized-time vertical arc, and oscillating hover motion.
- Replace the current brief English comments with detailed Chinese function documentation and usage examples.
- Validate with the repo-local Lua 5.3 toolchain and keep project memory synchronized with the broadened route.

## Workspace
- Project root: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua
- Planning container: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning
- Project playbook: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/design-motion-vertical
- Task slug: design-motion-vertical
- Task-local tools directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/design-motion-vertical/tools
- Project toolset directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.tools
- Canonical reference directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.canon
- Reports directory: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/design-motion-vertical/reports
- Dynamic memory and execution artifacts stay in the matching task workspace, not in the shared skill folder.

## Knowledge Inputs
- `.planning/PROJECT_PLAYBOOK.md`
- `.planning/workspaces/implement-motion-bezier3/PROJECT_SUMMARY.md`
- The previous `design-motion-vertical` summary and session records
- `Code/Logic/Process/Motion/Charge.lua`
- `Code/Logic/Process/Motion/Bezier3.lua`
- `Code/Logic/Process/Motion/Surround.lua`
- `Reference (not included in the project)/EffectSport/EffectSportDown.j`
- `doc/运动器与碰撞框架设计.md`
- No active `.canon/` reference shapes this route.

## Assumptions
- The useful common vertical-motion coverage for this task is monotonic rise/fall, jump/hop, and hover.
- Thin `up/down` wrappers are acceptable because they add ergonomic value without adding new runtime models.
- Jump/hop can be represented as a timed z-curve while keeping x/y fixed.
- Hover can be represented as a sinusoidal z oscillation with optional finite duration.

## Completion Standard
- Complete delivery means `Vertical.lua` exposes the broadened vertical-motion family, the new entries are documented in detailed Chinese in-source notes, static validation passes, and the planning workspace reflects the broadened route and risks.
- Not acceptable: leaving the task as one monotonic solver, bloating the API with many aliases, or widening the work into shared Motion runtime edits.

## Audit / Debug Strategy
- Inspect the new family for duplication versus justified shared helpers.
- Inspect hot paths for per-tick allocations or avoidable repeated normalization.
- Validate syntax and loadability with the repo-local Lua 5.3 toolchain.
- Record the broadened route and extension boundary in task memory rather than inventing ad hoc notes.

## Capability Routing Rules
- Required capabilities are written as stable names.
- Implementation is resolved at execution time.

## Phase 1

### Goal
- `Vertical.lua` contains a compact family of common vertical motions, uses the new library filename, and passes static validation.

### Inputs
- `Code/Logic/Process/Motion/Vertical.lua`
- `Code/Logic/Process/Motion/Charge.lua`
- `Code/Logic/Process/Motion/Bezier3.lua`
- `Code/Logic/Process/Motion/Surround.lua`
- `Code/Logic/Process/Motion/Entry.lua`
- `Reference (not included in the project)/EffectSport/EffectSportDown.j`
- `doc/运动器与碰撞框架设计.md`

### Outputs
- Renamed and documented `Code/Logic/Process/Motion/Vertical.lua`
- Updated task workspace memory describing the broadened API family, validation, and extension boundary

### Dependencies
- Reuse the existing vertical-motion route baseline and refresh it against the new user requirement.

### Technical Route
- Keep the file organized by runtime model: monotonic displacement, timed arc, oscillation.
- Let the public API map to those models directly instead of multiplying custom update loops without need.
- Keep wrappers thin and reuse the monotonic solver instead of cloning its runtime logic.

### Detailed Implementation Approach
- Rework shared prep into a few high-value helpers for z-only motion.
- Keep `Motion.vertical` as the base direct solver.
- Add `Motion.up` and `Motion.down` as direction-normalizing wrappers around `Motion.vertical`, and align their bounded-distance field name with `Charge.lua` by using `max_distance`.
- Add `Motion.jump` using cached `t` progression and a vertical arc term.
- Add `Motion.hover` using cached phase-step progression and `sin` on z only.
- Keep all runtime state on `config`.
- Add detailed Chinese comments for shared helpers and public entries, including concrete calling examples.

### Risks
- The API may still be too small if a real caller later needs bounce or damped spring motion.
- Thin wrappers can drift into unnecessary alias surface if more names are added without a real need.
- Hover with a finite duration returns to base z at the end; if a caller wants a different termination rule, that will need a later design pass.

### Requirement Alignment
- Learn sibling style before designing the new module.
- Keep the implementation high-efficiency and low-overhead.
- Add several common vertical motions without touching other libraries.

### Architecture Fit Review
- The route fits the existing framework because it only uses `move_func`, `Motion.set`, and the existing motion lifecycle.
- Grouping entries by runtime model avoids the common failure mode of a sprawling file full of bespoke one-off update logic.
- Keeping all changes inside `Vertical.lua` respects the user's boundary and the current project playbook.

### Explicitly Unresolved Details
- Whether a future caller will need bounce, spring, or target-following vertical motion.
- Any future expansion must still justify itself as a distinct runtime model or a genuinely useful thin wrapper.

### Diagnostic Hooks / Signals
- Lua syntax parsing with `luac`
- Lua load validation with `loadfile`
- Manual source review of each hot path

### Relevant Experience / Standards
- Prefer flat scalar config over nested structures.
- Store runtime state on `config`.
- Keep hot paths short and numeric.
- Prefer a small number of strong runtime models over a large list of semantic aliases.

### Required Capabilities
- `repo_audit`
- `route_detail_design`
- `planned_route_framework_review`
- `phase_plan`
- `test_strategy`
- `project_summary_curate`

### Validation
- `D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/lua53/bin/luac.exe -p Code/Logic/Process/Motion/Vertical.lua`
- `D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/lua53/bin/lua.exe -e "assert(loadfile('Code/Logic/Process/Motion/Vertical.lua'))"`
- Final source inspection for helper count, hot-path simplicity, and exact end behavior

### Expected Summary Updates
- Record the broadened API family, runtime-model grouping, validation status, and remaining extension risks.

### Expected Tool / Report Updates
- No task-local helper tool is planned for this phase.
- Reuse the repo-local Lua 5.3 toolchain under `.tools/lua53`.
- No `.canon/` reference is active for this task.
- No extra report file is required unless a later compatibility review needs it.

## Replan Triggers
- Discovering a real caller that needs another distinct vertical runtime model.
- Discovering that one of the chosen motions cannot be expressed cleanly inside `Vertical.lua` alone.
- Discovering that the current wrapper boundary starts creating more API churn than ergonomic value.

## Definition of Done
- `Vertical.lua` contains the expanded vertical-motion family and detailed Chinese in-source API notes.
- Static validation succeeds.
- The task workspace records the broadened route, validation, lessons, and open risks.
- No other motion library or shared runtime file was modified.
