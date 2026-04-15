# Project Summary

## Current Mission
- Design and maintain a compact family of common vertical motions in `Code/Logic/Process/Motion/Vertical.lua` without modifying sibling motion libraries.

## Context Snapshot
- Task label: Design Motion Vertical
- Task slug: design-motion-vertical
- Task type(s): feature, research
- Project context: brownfield motion-framework leaf module
- Selected pattern: library_or_framework_design
- Planning container: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning
- Project playbook: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/design-motion-vertical
- Project toolset: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.tools
- Canonical references: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.canon

## Planned Technical Route Baseline
- Keep the work inside `Code/Logic/Process/Motion/Vertical.lua`.
- Organize the file by runtime model, not by a long list of semantic names.
- Preserve `Motion.vertical(actor, config)` as the base monotonic rise/fall solver.
- Add `Motion.up` and `Motion.down` as thin wrappers over the monotonic solver, with `max_distance` aligned to `Charge.lua`.
- Add `Motion.jump` as a timed vertical arc / hop solver with cached progress.
- Add `Motion.hover` as an oscillating hover / float solver with cached phase step.
- Share only a few high-value helpers for input prep; z-only position commit goes directly through `actor.z`.

## Inherited Standards and Principles
- Keep motion APIs compact and explicit.
- Store runtime state on `config` / `motion`.
- Prefer setup-heavy, tick-light implementations.
- Prefer direct `actor.z` assignment for z-only motion updates when the entity layer already supports it.
- Avoid compatibility aliases unless an actual caller requires them.
- Prefer a small number of strong runtime models over many bespoke update branches.

## Bug Avoidance and Red Flags
- A finite motion must not install if it cannot make meaningful progress.
- End behavior should be explicit and predictable: exact `end_z` for monotonic and jump motions, base-z reset for finite hover.
- Wrappers should reuse runtime models instead of cloning their tick logic.
- Do not turn this file into general 3D path motion or a dumping ground for every future effect idea.

## Debug Signals and Inspection Hooks
- Static parse check: `.tools/lua53/bin/luac.exe -p Code/Logic/Process/Motion/Vertical.lua`
- Static load check: `.tools/lua53/bin/lua.exe -e "assert(loadfile('Code/Logic/Process/Motion/Vertical.lua'))"`
- Manual source review of helper count and each hot path.

## Reusable Experience and Lessons
- A vertical motion family stays cleaner when the entries map to a few runtime models: monotonic displacement, normalized-time curve, and oscillation.
- Thin wrappers can be acceptable if they only normalize input and fully reuse an existing runtime model.
- When a wrapper is semantically the same kind of bounded-distance motion as a sibling module, align the config field name instead of inventing another one.
- Time-based vertical arc motion pairs naturally with the existing Bezier-style `t` progression pattern, even though it stays entirely in z.

## Active Improvements
- `Vertical.lua` now covers direct vertical motion, directional convenience, jump/hop, and hover/floating behavior.
- The vertical module moved from a single entry to a small family without touching sibling motion files.
- The renamed file now carries detailed Chinese function comments and direct usage examples.
- The library no longer keeps redundant z-only helper and method caches.
- The `up/down` wrapper contract now uses `max_distance` rather than a separate `distance` term.
- Project memory now captures the runtime-model grouping and extension boundary for future follow-up.

## Route Review and Framework Compatibility Notes
- The broadened family still fits the existing framework by reusing `move_func`, `Motion.set`, and `Motion.execute`.
- The file remains leaf-module scoped; no `Motion.Entry` changes were needed.
- Grouping by runtime model prevented the family expansion from turning into duplicated update logic.
- Entity-layer z setters are already formalized, so direct `actor.z` writes keep the file simpler than wrapping `setPosition` for z-only motion.

## Tooling Guidance
- Preferred tools: direct source inspection plus the repo-local Lua 5.3 toolchain.
- Task-local tools active: none.
- Shared mutable project tools active: `.tools/lua53/bin/luac.exe` and `.tools/lua53/bin/lua.exe`.
- Canonical references active: none in `.canon/`; the practical references were sibling motion modules, `EffectSportDown.j`, and motion design notes.

## Recent Retrospective Signals
- The old J reference only covered straight down motion, so broadening the library required route design rather than direct translation.
- Choosing runtime-model groupings made the expansion much easier to keep readable.
- The wrapper boundary was easiest to keep honest by allowing wrappers only when they reused an existing solver completely.

## Open Risks and Watch Items
- A future caller may still need bounce, spring, or target-following vertical motion.
- Hover currently returns to base z when finite duration ends; that may not match every future effect.
- Runtime smoke testing inside the game engine has still not been run yet.

## Update Log
- 2026-04-10: Initial summary created.
- 2026-04-10: Recorded the approved direct vertical route and the no-other-libraries constraint.
- 2026-04-10: Recorded the completed `Motion.vertical` implementation and static validation results.
- 2026-04-10: Expanded the task summary to cover the vertical-motion family (`vertical`, `up`, `down`, `jump`, `hover`) and its runtime-model grouping.
- 2026-04-10: Renamed the production library file to `Vertical.lua` and replaced the source comments with detailed Chinese interface documentation.
- 2026-04-11: Removed the redundant `setActorZ` layer and switched z-only updates to direct `actor.z` assignment.
- 2026-04-11: Unified the `up/down` wrapper distance field to `max_distance` with no `distance` alias.
