# Project Summary

## Current Mission
- Provide a reusable, low-overhead storage core for `item` instances that can back both backpack and warehouse systems.

## Context Snapshot
- Task label: Design Item Storage System
- Task slug: design-item-storage-system
- Task type(s): library design, feature delivery
- Project context: brownfield framework/library
- Selected pattern: inspect -> design -> isolated implementation -> validate -> record follow-up risks
- Planning container: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Project playbook: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/design-item-storage-system
- Project toolset: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical references: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon

## Planned Technical Route Baseline
- `Storage.lua` owns the data-layer storage core.
- Internal state uses a fixed-capacity slot array plus weak item -> storage / slot lookup tables.
- Public operations are slot-oriented: add/remove/move/swap/transfer/exchange/clear.
- The module exposes a single generic storage-change event and `Item` static helper accessors.
- The design intentionally does not decide UI or native inventory synchronization policy.

## Inherited Standards and Principles
- Reuse project-native capabilities before building new helpers.
- Keep hot paths direct and numeric.
- Extend existing framework surfaces (`Item`, `Event`) instead of creating disconnected APIs.
- Stay inside the single-file scope under the current user constraint.

## Bug Avoidance and Red Flags
- Do not allow one item to exist in multiple storages at once.
- Do not silently overwrite an occupied slot.
- Do not couple the storage core to native Warcraft inventory assumptions too early.
- Adjacent item modules already show bugs; avoid building new logic on top of those assumptions without re-checking.

## Debug Signals and Inspection Hooks
- `Event.onItemStorageChange(...)` is the retained hook for future integration/debugging.
- `Storage.getByItem(item)` and `Storage.getSlotByItem(item)` are the direct invariant-inspection helpers.

## Reusable Experience and Lessons
- A simple slot array plus explicit transfer semantics is a better fit than heavier container abstractions for this use case.
- Generic change events keep the integration surface smaller while still supporting UI and gameplay listeners.

## Active Improvements
- Added a reusable storage core instead of forcing backpack and warehouse systems to invent separate item-container logic.

## Route Review and Framework Compatibility Notes
- The storage core fits current framework conventions cleanly as long as higher layers explicitly choose when it is loaded and how it relates to native inventory handles.
- Startup integration would require a later, broader-scoped change.

## Tooling Guidance
- Prefer `.tools/lua53/bin/luac.exe -p` for fast Lua syntax validation.
- No task-local helper tools were needed for this implementation.
- No `.canon` reference directly matched this task.

## Recent Retrospective Signals
- Reusing the project's `Event` and `Class` infrastructure kept the implementation compact.
- Searching `.canon` too broadly was low-signal for this task; direct source inspection was more valuable.

## Open Risks and Watch Items
- `Storage.lua` is not auto-loaded yet under the current scope.
- `Core.Entity.Item.lua` and `Logic.Process.Item` contain apparent bugs that may affect later runtime integration.
- Future stacking/equipment requirements could force an additional design pass.

## Update Log
- 2026-04-11: Initial summary created.
- 2026-04-11: Implemented `War3/map/Logic/Process/Item/Storage.lua` with slot-based storage, storage-change events, and deleted-item purge handling.
- 2026-04-11: Recorded adjacent item-module risk notes for user follow-up instead of patching sibling libraries.
