# Task Workspace

## Task Identity
- Task label: Promote Project Coding Style
- Task slug: promote-project-coding-style
- Matching rule: Reuse this workspace only when a later request still targets the project-wide coding-style baseline derived from the motion-library work and its cross-task documentation/playbook sync.
- Split rule: Create a sibling task workspace when the request changes from documenting project-wide style to refactoring a concrete subsystem or implementing behavior changes in production code.

## Scope Snapshot
- Current normalized objective: consolidate the code-style rules previously learned while refining `Charge`, `Surround`, `Bezier3`, `Vertical`, and legacy `Down` into a project-wide default coding-style baseline for future design work in this repository.
- Primary surfaces: `.planning/PROJECT_PLAYBOOK.md`, `doc/项目代码风格总结-2026-04-11.md`, the sibling task summaries under `.planning/workspaces/`, and the motion-library source files used as evidence.
- Explicit exclusions: do not change runtime behavior in `Code/`; do not force a large backfill refactor across old modules in this round.

## Continuation Signals
- Reuse this workspace when: later requests still focus on refining, extending, applying, or questioning the project-wide coding-style baseline and its documentation/memory artifacts.
- Create a new sibling workspace when: the request becomes a concrete implementation task in a specific module, a code audit of another subsystem, or a repository-wide style migration.

## Workspace Paths
- Project root: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua
- Planning container: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Project playbook: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/promote-project-coding-style
- Task-local tools directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/promote-project-coding-style/tools
- Project toolset directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical reference directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon
- Reports directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/promote-project-coding-style/reports

## Notes
- This workspace owns the task-local route, summary, and continuation memory for the project-wide style-promotion task only.
- The strongest source signals come from the explicitly summarized Bezier3 style work on 2026-04-10 and the later playbook promotions on 2026-04-11, with `Charge`, `Surround`, `Vertical`, and legacy `Down` used as supporting lineage evidence.
- When older source files conflict with later explicit style summaries, the newer confirmed summary wins.
