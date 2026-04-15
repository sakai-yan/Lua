# Project Summary

## Current Mission
- Capture the user's preferred motion leaf-module code style from the latest Bezier3 optimization and preserve it as reusable project guidance.

## Context Snapshot
- Task label: Implement Motion Bezier3
- Task slug: implement-motion-bezier3
- Task type(s): brownfield library refinement, targeted API cleanup
- Project context: existing motion-framework leaf module
- Selected pattern: inspect sibling solvers, flatten the Bezier API, validate statically, sync task memory
- Planning container: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Task workspace: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/implement-motion-bezier3
- Project toolset: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical references: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon

## Planned Technical Route Baseline
- Keep the public entry points `Motion.bezier3` / `Motion.lockOnBezier3`.
- Use flat scalar config fields such as `end_x/end_y/end_z`, `start_x/start_y/start_z`, and `control_one_x/...`.
- Remove support for grouped point-table config fields.
- Keep runtime state on `config` and keep the tick path close to "advance t -> evaluate -> setPosition -> optional setFace".
- Cache full fixed-end coefficients and lock-on base coefficients during setup so tick updates stay numeric and allocation-free.
- Use duration/progress-driven completion and clamp to `t = 1` on the last step.
- Keep `Entry.lua` changes comment-only for field-list alignment.

## Inherited Standards and Principles
- Keep motion APIs simple at the call site and explicit internally.
- Store runtime state on the config/motion table.
- Prefer hot-path simplicity and predictable completion behavior over compatibility magic.
- Avoid editing shared runtime behavior when a leaf-module solution is sufficient.

## Bug Avoidance and Red Flags
- Reintroducing point-table compatibility in the name of convenience.
- Per-tick table creation or helper-object allocation.
- Drifting into a wider Motion framework refactor.
- Leaving `Entry.lua` comments advertising a removed Bezier contract.
- Ending near `t = 1` without clamping exactly to the final endpoint.

## Debug Signals and Inspection Hooks
- Static inspection of `Motion.Entry` to separate stale comments from actual runtime behavior.
- Syntax/load validation for the edited files.
- Source review of `t` progression, final endpoint placement, and optional facing behavior.
- Repo-local validation commands:
- `D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/lua53/bin/luac.exe -p Code/Logic/Process/Motion/Bezier3.lua`
- `D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/lua53/bin/luac.exe -p Code/Logic/Process/Motion/Entry.lua`
- `D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/lua53/bin/lua.exe -e "assert(loadfile(...))"`

## Reusable Experience and Lessons
- Sibling motion modules favor scalar config and direct field access over grouped point objects.
- A stale comment list in a shared entry file is not the same thing as an enforced runtime contract.
- When there are no current callers, a leaf-module API can be simplified decisively instead of carrying compatibility ballast.
- The user's preferred style is even stricter than the earlier Bezier design route: flatter config, fewer helper layers, stronger contract trust, and a smaller API surface.
- When learning style from a concrete optimized file, separate "this is how the code is structured" from "this is the behavior contract that should be preserved."

## Active Improvements
- Flattened the Bezier3 config surface to match the local motion style more closely.
- Removed the point-table reader layer from Bezier setup.
- Aligned the Bezier field-list comments in `Entry.lua` with the real API.
- Added `doc/Bezier3代码风格总结-2026-04-10.md` as a durable explanation of the style expectations revealed by the user's Bezier3 rewrite.
- Added `.planning/PROJECT_PLAYBOOK.md` so those style expectations can guide sibling tasks without re-deriving them.

## Route Review and Framework Compatibility Notes
- The Bezier solver still fits the existing Motion runtime without any shared behavior changes.
- Fixed-endpoint and lock-on-target modes keep separate setup caches: full coefficients for fixed endpoints, base coefficients for lock-on endpoints.
- Lock-on mode now reads `target.x/y/z` directly each tick, which matches the assumption already used by sibling motion modules.
- Optional tangent-facing remains off the default path.

## Tooling Guidance
- Preferred tools: direct source inspection, `rg`, and the repo-local Lua 5.3 syntax/load validators.
- Task-local tools active: none.
- Shared mutable project tools active: the repo-local Lua 5.3 toolchain under `.tools/lua53`.
- Canonical references active: none. The practical references are sibling motion modules and the legacy J file in the repo.
- Style-guidance artifacts:
- `doc/Bezier3代码风格总结-2026-04-10.md`
- `.planning/PROJECT_PLAYBOOK.md`

## Recent Retrospective Signals
- Comparing Bezier3 against `Charge.lua` made the unnecessary point-table layer stand out quickly.
- Checking `Motion.Entry` directly prevented overfitting to a stale comment list.
- The repo-local Lua 5.3 toolchain remains the fastest correctness gate for this kind of leaf-module work.
- Comparing the user's rewritten Bezier3 against the earlier design route revealed that the key preference is not just "faster" but "structurally more direct."

## Open Risks and Watch Items
- Any undiscovered caller using `end_point` or `control_one` tables will now break and would need migration.
- The flattened API is more explicit but also more verbose when callers hand-write both control points.
- Runtime behavior still needs an in-engine smoke test when the first real caller lands.

## Update Log
- 2026-04-09: Initial summary created.
- 2026-04-09: Added the approved Bezier3 implementation route, constraints, and performance focus.
- 2026-04-09: Recorded the completed API shape and syntax/load validation results.
- 2026-04-09: Recorded the lighter sibling-style refactor and the addition of Chinese in-file usage documentation.
- 2026-04-09: Recorded the scalar-field API cleanup, removal of point-table compatibility, and `Entry.lua` comment alignment.
- 2026-04-10: Recorded the style-summary document and promoted the reusable guidance into the project playbook.
