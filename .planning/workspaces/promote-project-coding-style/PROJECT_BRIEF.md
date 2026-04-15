# Project Brief

## Problem
- The project already learned a preferred style while refining the motion libraries, but that guidance is scattered across `doc/Bezier3代码风格总结-2026-04-10.md`, `.planning/PROJECT_PLAYBOOK.md`, and several sibling task summaries.
- The user asked to treat that learned style as the default code-style baseline for the whole project in general future design work, not just for one motion module.

## Goals
- Reconstruct the stable style rules from the historical summary and the concrete source patterns in `Charge`, `Surround`, `Bezier3`, `Vertical`, and legacy `Down`.
- Distinguish true style rules from module-specific behavior choices.
- Produce one durable project-facing summary document in `doc/`.
- Sync the promoted rules into `.planning/PROJECT_PLAYBOOK.md` so later sibling tasks can reuse them directly.

## Non-Goals
- No runtime behavior changes in production Lua code.
- No repository-wide refactor of older modules just to match the new wording immediately.
- No claim that every old file already matches the latest strongest form of the style perfectly.

## Constraints
- The style baseline should reflect the user's historical preference as expressed in existing project artifacts, not a new invented standard.
- The general rule should still allow justified exceptions when a real caller contract, subsystem boundary, or compatibility requirement exists.
- The resulting guidance should be strong enough to steer future design, while still separating style from behavior contract details.

## Knowledge Inputs
- `doc/Bezier3代码风格总结-2026-04-10.md`
- `.planning/PROJECT_PLAYBOOK.md`
- `.planning/workspaces/implement-motion-bezier3/PROJECT_SUMMARY.md`
- `.planning/workspaces/design-motion-vertical/PROJECT_SUMMARY.md`
- `.planning/workspaces/audit-storage-style-efficiency/PROJECT_SUMMARY.md`
- `Code/Logic/Process/Motion/Charge.lua`
- `Code/Logic/Process/Motion/Surround.lua`
- `Code/Logic/Process/Motion/Bezier3.lua`
- `Code/Logic/Process/Motion/Vertical.lua`
- `Reference (not included in the project)/EffectSport/EffectSportDown.j`

## Expected Deliverables
- A project-wide style summary document.
- Updated project playbook guidance.
- Task-local planning memory describing the route and the resulting baseline.

## Open Questions
- None blocking. The task is documentation and standards promotion, and the evidence already exists locally.
