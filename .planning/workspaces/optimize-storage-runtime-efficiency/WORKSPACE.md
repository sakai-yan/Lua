# Task Workspace

## Task Identity
- Task label: Optimize Storage Runtime Efficiency
- Task slug: optimize-storage-runtime-efficiency
- Matching rule: Reuse this workspace when a later request still targets runtime-efficiency, style-alignment, or low-overhead refactoring work inside `Code/Logic/Process/Item/Storage.lua`.
- Split rule: Create a sibling task workspace when the request becomes a new inventory feature, a broader Event framework refactor, or a multi-module item-system redesign.

## Scope Snapshot
- Current normalized objective: Reanalyze the current `Storage` library from source, using the project-wide style summary as the baseline, then land targeted runtime-efficiency improvements without widening into unrelated framework work.
- Primary surfaces: `Code/Logic/Process/Item/Storage.lua`, `doc/项目代码风格总结-2026-04-11.md`, `doc/Bezier3代码风格总结-2026-04-10.md`, `.planning/PROJECT_PLAYBOOK.md`, `Code/Lib/Base/Array.lua`, `Code/Lib/Base/Class.lua`, `Code/Lib/Base/DataType.lua`, `Code/FrameWork/Manager/Event.lua`.
- Explicit exclusions: No backpack UI work; no native inventory synchronization; no persistence; no item stacking/equipment semantics; no broad `Event.lua` API changes unless the current file becomes impossible to optimize safely without them.

## Continuation Signals
- Reuse this workspace when: The work is still about `Storage.lua` runtime paths, invariants, low-consumption refactoring, or Storage-specific follow-up validation.
- Create a new sibling workspace when: The work shifts into new gameplay semantics, project-wide style promotion, or sibling container libraries such as `Shop`.

## Workspace Paths
- Project root: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua
- Planning container: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Project playbook: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/optimize-storage-runtime-efficiency
- Task-local tools directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/optimize-storage-runtime-efficiency/tools
- Project toolset directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical reference directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon
- Reports directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/optimize-storage-runtime-efficiency/reports

## Notes
- This workspace owns `PLAN.md`, `STEP_PLAN.md`, `TASKS.md`, `SESSION.md`, `PROJECT_SUMMARY.md`, and related execution artifacts for this task only.
- Task-only helpers can live in `D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/optimize-storage-runtime-efficiency/tools`; reusable mutable project tools can move to `D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools`.
- Treat `D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon` as canonical read-only input unless the task is explicitly about maintaining reference material.
- Cross-task knowledge should be promoted intentionally into `D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/PROJECT_PLAYBOOK.md` instead of being mixed here by default.
- This workspace intentionally treats `doc/项目代码风格总结-2026-04-11.md` plus `.planning/PROJECT_PLAYBOOK.md` as the style authority for this pass.
- Earlier Storage audit artifacts may be read for history, but they are not the source of truth for the runtime optimization route in this workspace.
