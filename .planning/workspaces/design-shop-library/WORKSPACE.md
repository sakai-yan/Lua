# Task Workspace

## Task Identity
- Task label: Design Shop Library
- Task slug: design-shop-library
- Matching rule: Reuse this workspace when follow-up work still targets the upper-layer `Shop.lua` runtime, its listing/stock/sale semantics, or its future `Trade.lua` integration seam.
- Split rule: Create a sibling workspace if the work becomes mainly about `Trade.lua`, native shop UI wiring, startup loading, or gameplay-specific shop content.

## Scope Snapshot
- Current normalized objective: implement a high-efficiency `Shop.lua` library above `Trade`, styled after `Charge` / `Bezier3`, supporting item sale and unit hire plus future `Trade` sale-record syncing.
- Primary surfaces: `Code/Logic/System/Shop.lua`
- Explicit exclusions: no `Trade.lua` edits yet, no startup auto-require wiring, no native Warcraft shop UI or data-object editor integration.

## Continuation Signals
- Reuse this workspace when: the next request is to refine `Shop.lua`, add shop events/hooks, or connect `Trade.lua` into `Shop.recordSaleBySeller(...)`.
- Create a new sibling workspace when: the next request is mostly about lower-layer trade events, map content setup, UI, or unrelated systems.

## Workspace Paths
- Project root: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua
- Planning container: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Project playbook: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/design-shop-library
- Task-local tools directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/design-shop-library/tools
- Project toolset directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical reference directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon
- Reports directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/design-shop-library/reports

## Notes
- This workspace now owns the implemented upper-layer shop route, including the future `Trade` handoff seam via `Shop.recordSaleBySeller(...)`.
- The current delivery is intentionally isolated to `Shop.lua` so the next integration step can happen without untangling circular dependencies.
