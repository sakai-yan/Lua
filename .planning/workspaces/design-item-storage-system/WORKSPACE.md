# Task Workspace

## Task Identity
- Task label: Design Item Storage System
- Task slug: design-item-storage-system
- Matching rule: Reuse this workspace when the request still targets the reusable item-storage core in `War3/map/Logic/Process/Item/Storage.lua`.
- Split rule: Create a sibling task workspace when the request shifts into UI inventory presentation, native Warcraft item-bar syncing, persistence, or unrelated Item framework fixes.

## Scope Snapshot
- Current normalized objective: Design and implement a reusable, low-overhead storage core for `item` objects that can back both backpack and warehouse systems.
- Primary surfaces: `War3/map/Logic/Process/Item/Storage.lua`, `War3/map/Core/Entity/Item.lua`, `War3/map/FrameWork/Manager/Event.lua`, `War3/map/Lib/Base/Array.lua`, `War3/map/Lib/Base/Class.lua`.
- Explicit exclusions: No edits outside `Storage.lua`; no UI; no native six-slot inventory synchronization; no persistence or save format work.

## Continuation Signals
- Reuse this workspace when: The work is still about slot management, item ownership inside storage, cross-storage movement, or storage-level events.
- Create a new sibling workspace when: The task becomes about backpack UX, sorting policies beyond the current core, equipment semantics, or fixing separate item/ability/trade bugs.

## Workspace Paths
- Project root: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua
- Planning container: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Project playbook: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/design-item-storage-system
- Task-local tools directory: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/design-item-storage-system/tools
- Project toolset directory: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical reference directory: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon
- Reports directory: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/design-item-storage-system/reports

## Notes
- This workspace owns `PLAN.md`, `STEP_PLAN.md`, `TASKS.md`, `SESSION.md`, `PROJECT_SUMMARY.md`, and related execution artifacts for this storage-core task only.
- The implemented core is intentionally data-layer only; higher-level callers must decide whether and when stored items map to native Warcraft inventory handles.
- Discovered sibling-library issues should be recorded here and reported to the user, but not patched in-place under the current scope constraint.
