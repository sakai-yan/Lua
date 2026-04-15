# Project Summary

## Current Mission
- Promote the motion-derived coding style into a project-wide default baseline for future code design work in this repository.

## Context Snapshot
- Task label: Promote Project Coding Style
- Task slug: promote-project-coding-style
- Task type(s): standards promotion, documentation, project-memory sync
- Project context: brownfield multi-library project
- Selected pattern: inspect prior evidence, extract stable rules, sync public/project memory
- Planning container: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Project playbook: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/promote-project-coding-style
- Project toolset: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical references: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon

## Planned Technical Route Baseline
- Start from the historical Bezier3 style summary on 2026-04-10.
- Use the current motion libraries and legacy `Down` reference as code evidence and lineage.
- Promote only the stable structural rules into the project-wide baseline.
- Keep behavior-specific choices out of the general standard unless they clearly repeat as a structural rule.

## Inherited Standards and Principles
- Prefer flat config/data shape, direct ownership, setup-heavy normalization, and hot-path simplicity.
- Keep helpers few and high-value.
- Keep comments contract-focused and cost-aware.
- Reuse existing capabilities instead of rebuilding thin wrappers.
- Allow exceptions only when a real caller contract or subsystem boundary justifies them.

## Bug Avoidance and Red Flags
- Treating one-off behavior choices as mandatory style.
- Copying older file quirks over newer explicit summaries.
- Widening a style-promotion task into unnecessary runtime edits.

## Debug Signals and Inspection Hooks
- Primary evidence files:
- `doc/Bezier3代码风格总结-2026-04-10.md`
- `Code/Logic/Process/Motion/Charge.lua`
- `Code/Logic/Process/Motion/Surround.lua`
- `Code/Logic/Process/Motion/Bezier3.lua`
- `Code/Logic/Process/Motion/Vertical.lua`
- `Reference (not included in the project)/EffectSport/EffectSportDown.j`
- Existing memory anchors:
- `.planning/PROJECT_PLAYBOOK.md`
- `.planning/workspaces/implement-motion-bezier3/PROJECT_SUMMARY.md`
- `.planning/workspaces/design-motion-vertical/PROJECT_SUMMARY.md`
- `.planning/workspaces/audit-storage-style-efficiency/PROJECT_SUMMARY.md`

## Reusable Experience and Lessons
- The project's strongest style signal is now explicit enough to be reused outside Motion-only work.
- Newer confirmed summaries should outrank older source quirks when they conflict.
- The most reusable part of the motion work is the structural discipline, not any one module's exact runtime semantics.

## Active Improvements
- Added a durable project-wide style summary document.
- Strengthened the project playbook so future tasks can treat this style as the default baseline in general cases.
- Created a dedicated planning workspace to preserve the reasoning for later reuse.

## Route Review and Framework Compatibility Notes
- The promotion route cleanly fits the existing planning container model.
- No `.canon/` changes or runtime code edits were needed.

## Tooling Guidance
- Preferred tools: direct source inspection with `rg`, plus markdown/playbook sync.
- Task-local tools active: none.
- Shared mutable project tools active: none needed for this documentation task.
- Canonical references active: none in `.canon/`; the evidence comes from local source and planning artifacts.

## Recent Retrospective Signals
- The historical Bezier3 summary already contained the key distinction between style and behavior; reusing that saved the task from inventing a new doctrine.
- `Vertical` and the Storage audit made it clear that the motion-derived style had already started spreading beyond Motion-only work.

## Open Risks and Watch Items
- Some older modules still reflect earlier, looser stages of the style and should not automatically override the newer baseline.
- Future tasks may still need deliberate exceptions when external contracts force nesting, aliases, or broader compatibility layers.

## Update Log
- 2026-04-11: Initial summary created.
- 2026-04-11: Recorded the project-wide promotion route, the evidence sources, and the stronger default-baseline framing.
