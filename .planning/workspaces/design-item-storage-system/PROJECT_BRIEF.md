# Project Brief

## Problem
- The project needs a reusable storage core for `item` instances that can serve both backpack and warehouse scenarios without cloning logic across systems.

## Project Context
- Context: Brownfield framework/library work.
- Why it matters: The new module must fit the existing `Item`/`Event`/`Class` framework, reuse base libraries, and avoid edits to adjacent runtime modules.

## Project-Local Workspace
- Project root: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua
- Planning container: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Project playbook: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/design-item-storage-system
- Task slug: design-item-storage-system
- Task-local tools directory: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/design-item-storage-system/tools
- Project toolset directory: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical reference directory: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon
- Reports directory: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/design-item-storage-system/reports

## Goals
- Implement `War3/map/Logic/Process/Item/Storage.lua`.
- Keep the core efficient: fixed slots, O(1) membership lookup, low-allocation operations, and no per-tick work.
- Make the API generic enough for both backpack and warehouse callers.
- Expose storage change hooks in the project's existing event style.

## Normalized Requirements
- Use existing project libraries instead of inventing parallel infrastructure.
- Follow high-efficiency, low-overhead design principles.
- Do not modify other libraries; only implement inside `Storage.lua`.
- Report discovered errors in sibling libraries instead of patching them under this task.
- Store `item` objects as the core unit of data.

## Non-Goals
- UI and drag-drop presentation.
- Native Warcraft six-slot inventory synchronization.
- Save/load persistence.
- Item stacking, sorting policies, or special equipment semantics beyond the storage core.

## Constraints
- Existing `Item` and `Event` modules define the surrounding runtime contract.
- The new work must remain isolated to `Storage.lua`.
- Validation can only rely on static checks unless a larger runtime harness is introduced later.

## Existing Knowledge Inputs
- The project playbook emphasizes reusing existing project capabilities and keeping hot paths direct.
- Existing Process modules extend `Item` and `Event` rather than creating disconnected subsystems.
- No canonical `.canon` implementation for item storage was found that fit this task directly.

## Audit / Debug Focus
- Confirm the new storage core keeps slot/item ownership invariants.
- Audit sibling item modules for obvious contract bugs that could affect future integration.

## Stakeholders / Surface
- Future backpack and warehouse implementations.
- `Item` callers that need a generic storage layer.
- Event listeners that need storage change notifications.

## Success Signals
- `Storage.lua` provides a complete API for add/remove/move/swap/transfer/exchange/clear.
- The module validates with `luac -p`.
- The design remains decoupled from UI and native inventory mechanics.

## Open Questions
- Whether a future integration pass should auto-load `Storage.lua` from startup.
- Whether later systems need stacking, sorting, or equipment-aware slot rules.
