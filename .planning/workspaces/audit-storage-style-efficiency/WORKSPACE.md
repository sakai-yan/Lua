# Task Workspace

## Task Identity
- Task label: Audit Storage Style Efficiency
- Task slug: audit-storage-style-efficiency
- Matching rule: Reuse this workspace when the request still targets the current `Storage` 库 in `Code/Logic/Process/Item/Storage.lua`, especially its代码风格、效率/消耗表现、事件语义、使用文档或注释完善。
- Split rule: Create a sibling task workspace when the request shifts into背包 UI、原生六格同步、存档持久化、物品堆叠/装备语义、或 unrelated Item framework fixes.

## Scope Snapshot
- Current normalized objective: Audit the current `Storage` library against the project's Charge-style coding conventions and efficiency expectations, then add detailed Chinese function comments and usage guidance without changing runtime behavior.
- Primary surfaces: `Code/Logic/Process/Item/Storage.lua`, `Code/Logic/Process/Motion/Charge.lua`, `Code/Logic/Process/Motion/Vertical.lua`, `Code/Logic/Process/Motion/Bezier3.lua`, `Code/FrameWork/Manager/Event.lua`, `Code/Lib/Base/LinkedList.lua`, `Code/Lib/Base/Array.lua`, `.planning/PROJECT_PLAYBOOK.md`.
- Explicit exclusions: No backpack UI work; no native inventory sync; no persistence; no cross-module behavior refactors beyond project-memory / documentation updates unless the user explicitly asks for fixes.

## Continuation Signals
- Reuse this workspace when: The work is still about `Storage.lua` style alignment, audit findings, efficiency review, event semantics, or Storage documentation.
- Create a new sibling workspace when: The task becomes about implementing a new inventory feature, changing `Storage` runtime semantics, or fixing unrelated item/event framework bugs across multiple modules.

## Workspace Paths
- Project root: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua
- Planning container: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Project playbook: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/audit-storage-style-efficiency
- Task-local tools directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/audit-storage-style-efficiency/tools
- Project toolset directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical reference directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon
- Reports directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/audit-storage-style-efficiency/reports

## Notes
- This workspace owns `PLAN.md`, `STEP_PLAN.md`, `TASKS.md`, `SESSION.md`, `PROJECT_SUMMARY.md`, and related execution artifacts for this task only.
- Task-only helpers can live in `D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/audit-storage-style-efficiency/tools`; reusable mutable project tools can move to `D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools`.
- Treat `D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon` as canonical read-only input unless the task is explicitly about maintaining reference material.
- Cross-task knowledge should be promoted intentionally instead of being mixed here by default.
- This workspace records both the audit findings and the follow-up comment / usage-documentation pass for the same `Storage` surface.
- Current route bias: preserve behavior, document semantics explicitly, and surface optimization opportunities before changing contracts.
