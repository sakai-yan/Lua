# Project Brief

## Problem
- `Code/Logic/Process/Motion/Bezier3.lua` is effectively empty, while sibling motion solvers (`Charge.lua`, `Surround.lua`) already define the local conventions for config validation, runtime-state storage, and per-tick execution. The task is to implement a usable cubic Bezier motion library without changing any non-Bezier file.

## Project Context
- Brownfield runtime library work inside an existing motion framework.
- The implementation has to fit the current `Motion.set -> Motion.execute -> move_method` contract and the repo's existing lightweight mutation style instead of inventing a new abstraction layer.

## Project-Local Workspace
- Project root: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua
- Planning container: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Task workspace: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/implement-motion-bezier3
- Task slug: implement-motion-bezier3
- Task-local tools directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/implement-motion-bezier3/tools
- Project toolset directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical reference directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon
- Reports directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/implement-motion-bezier3/reports

## Goals
- Deliver a cubic Bezier motion solver in `Bezier3.lua`.
- Keep the API and internal style aligned with `Charge.lua` and `Surround.lua`.
- Optimize for low allocation and low per-tick overhead.
- Keep the change surface limited to the Bezier module.

## Normalized Requirements
- Study `Charge.lua` and `Surround.lua` and follow their config-driven, no-extra-object runtime style.
- Use the legacy J `MyFucEffectSportBezier3.j` implementation only as behavior inspiration, especially for static-endpoint and lock-on-endpoint Bezier motion semantics.
- Prefer high-efficiency, low-consumption implementation choices: cache hot-path data on the motion config, avoid per-tick table creation, and keep math scalarized.
- Only modify Bezier-related code, which constrains the design to fit the existing shared Motion runtime instead of asking for shared helpers elsewhere.

## Non-Goals
- Refactoring `Motion.Entry`.
- Changing `Charge.lua`, `Surround.lua`, `Vertical.lua`, or missile/collision modules.
- Reworking the broader motion/collision architecture described in docs.

## Constraints
- Single-file implementation constraint for production code.
- Must remain compatible with the current `Motion` runtime contract.
- Must not rely on extra runtime allocations inside the per-tick update path.
- The project is not currently in a detected git repo, so validation is static/source-based instead of git-diff-driven.

## Existing Knowledge Inputs
- Existing motion style comes from `Charge.lua` and `Surround.lua`: validate lightly, store runtime fields on `config`, and register a `move_method` onto the shared Motion FSM.
- `Motion.Entry` documents Bezier-related fields (`start_point`, `end_point`, `control_one`, `control_two`, `control_t`) and defines the execution contract this module must fit.
- The legacy J reference shows two important behavior modes: a fixed endpoint curve and a lock-on-target curve with moving endpoint.
- No `.canon` reference was needed for this pass; the main behavioral references are repo-local source files and the legacy J file.

## Audit / Debug Focus
- Verify that the Bezier solver does not allocate during tick updates, that progress terminates cleanly at `t = 1`, and that any optional target-lock mode updates only the endpoint while keeping the cached curve shape stable.

## Stakeholders / Surface
- Future motion callers that want cubic Bezier movement.
- The shared Motion FSM, as a compatibility target rather than an edit target.

## Success Signals
- `Bezier3.lua` exports concrete motion entry points instead of being a stub.
- The implementation exposes a clean fixed-endpoint API and a lock-on-target variant.
- The code follows the local motion-module style and passes static syntax/loading checks.

## Open Questions
- Choose the Bezier API surface that is most consistent with existing motion naming without overfitting to unused legacy call sites.
- Decide how much convenience to provide for missing control points while still keeping the hot path simple.
