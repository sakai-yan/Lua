# Execution Plan

## Planning Mode
- Profile: Quick
- Task type(s): brownfield library refinement, targeted runtime API cleanup

## Project Context
- Context type: existing motion-framework leaf module
- Selected pattern: inspect sibling solvers, flatten the Bezier leaf-module API, validate statically, sync task memory

## Requirement Integration
- The user explicitly asked to learn from `Charge.lua`, so the route moves Bezier input fields toward flat scalar config instead of point tables.
- The user explicitly rejected table compatibility, so this round removes `start_point` / `end_point` / `control_one` / `control_two` support instead of keeping transitional aliases.
- The user also challenged whether `Motion.Entry` actually uses 3D point tables; the route therefore treats `Entry.lua` as a comment-alignment surface, not as proof of a runtime contract.
- The user still wants high efficiency and low consumption, so the runtime keeps scalar coefficient caching and an allocation-free tick path.

## Technical Route Strategy
- Keep `Motion.bezier3` and `Motion.lockOnBezier3` as the public entry points.
- Replace point-table inputs with flat scalar fields such as `end_x/end_y/end_z`, `start_x/start_y/start_z`, and `control_one_x/...`.
- Remove point-table reader helpers from `Bezier3.lua`.
- Keep fixed-endpoint and lock-on-target runtime behavior.
- Update `Motion.Entry` field-list comments to match the flattened Bezier API.
- Preserve the existing `Motion.set` / `Motion.execute` / `move_func` compatibility contract.

## Workspace
- Project root: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua
- Planning container: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Task workspace: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/implement-motion-bezier3
- Task slug: implement-motion-bezier3

## Knowledge Inputs
- Primary code references: `Charge.lua`, `Surround.lua`, `Motion.Entry`, and `Reference (not included in the project)/EffectSport/MyFucEffectSportBezier3.j`.
- Project-summary lessons reused from sibling motion tasks: prefer explicit scalar state, keep APIs unsurprising, and keep tick-time work numeric and short.

## Assumptions
- There are no current Lua call sites depending on the old point-table Bezier API.
- A duration-driven Bezier solver remains acceptable; the task does not require arc-length parameterization.
- `target` objects in lock-on mode are expected to expose numeric `x/y/z` fields directly, like sibling motion modules already assume.

## Completion Standard
- Complete delivery means `Bezier3.lua` uses flat scalar config fields only, `Entry.lua` comments no longer advertise the removed point-table fields, Chinese usage notes reflect the new API, and syntax/load validation passes.

## Audit / Debug Strategy
- Verify that `Motion.Entry` had no runtime point-table behavior, only a stale field-list comment.
- Inspect the Bezier tick path for allocation-free numeric progression.
- Validate syntax/load with the repo-local Lua 5.3 toolchain.

## Phase 1

### Goal
- `Bezier3.lua` is flattened, validated, and documented in a way that matches the local motion-module style more closely.

### Inputs
- `Code/Logic/Process/Motion/Bezier3.lua`
- `Code/Logic/Process/Motion/Charge.lua`
- `Code/Logic/Process/Motion/Surround.lua`
- `Code/Logic/Process/Motion/Entry.lua`

### Outputs
- Flattened `Bezier3.lua`
- Comment-aligned `Entry.lua`
- Updated planning artifacts

### Technical Route
- Use scalar config fields and scalar coefficient caching throughout the Bezier implementation.
- Keep fixed-endpoint and lock-on-target updates separate, with no point-table fallback layer.
- Limit `Entry.lua` changes to comment alignment.

### Risks
- Existing undocumented callers might still use the old point-table shape.
- The flattened API becomes verbose if future callers frequently construct many manual control points.
- Without an in-engine smoke test, validation remains static for now.

### Validation
- `.\.tools\lua53\bin\luac.exe -p Code\Logic\Process\Motion\Bezier3.lua`
- `.\.tools\lua53\bin\luac.exe -p Code\Logic\Process\Motion\Entry.lua`
- `.\.tools\lua53\bin\lua.exe -e "assert(loadfile(...))"`

## Replan Triggers
- Discovering an existing caller that still depends on the removed point-table API.
- Discovering a shared Motion runtime constraint that cannot be handled inside the Bezier leaf module.

## Definition of Done
- The Bezier API is flattened, validated, and reflected accurately in task memory and source comments.
