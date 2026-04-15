# Project Brief

## Problem
- `Code/Logic/System/Shop.lua` existed as an empty file after an interrupted earlier attempt.
- The user needed a reusable shop library that follows the newer direct style learned from `Charge.lua`, `Bezier3.lua`, and the item storage core: flat config fields, low allocation, short hot paths, and no compatibility ballast.
- The library must allow selling `item` goods and hiring `unit` goods, while staying above `Trade.lua` instead of being coupled into it.

## Project Context
- Context type: brownfield framework/library
- Why it matters: the route must fit the existing `Item`, `Unit`, `Event`, and `Player` contracts, but should still keep the implementation isolated to one new library file.

## Project-Local Workspace
- Project root: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua
- Planning container: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Project playbook: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/design-shop-library
- Task slug: design-shop-library
- Task-local tools directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/design-shop-library/tools
- Project toolset directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical reference directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon
- Reports directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/design-shop-library/reports

## Goals
- Implement a slot-based shop runtime with O(1) core lookups and updates.
- Support listed goods backed by `item`, `unit`, `itemtype`, and `unittype`.
- Provide a scripted active-sale path (`sell`) and a future lower-layer sync path (`recordSale` / `recordSaleBySeller`).
- Expose a compact shop change event for stock/listing observers.
- Keep the work isolated to `Code/Logic/System/Shop.lua` plus planning-memory updates.

## Normalized Requirements
- Style must follow the newer motion-library direction: flat scalar fields, direct field access, minimal helper count, and setup-time normalization.
- The shop library is above `Trade.lua`; it should not depend on trade events or require a reverse integration now.
- Selling a unit is treated as hiring, but both flows should stay under the same shop runtime.
- The implementation should be efficient and low-overhead, not a placeholder plan or API sketch.

## Non-Goals
- No edits to `Trade.lua` in this step.
- No object editor/native shop stock integration.
- No startup auto-loading changes.
- No gameplay-specific shop content population.

## Constraints
- Reuse project-native primitives such as `Class`, `Array`, `DataType`, `Event`, `Item`, `Unit`, and `Player`.
- Avoid circular dependency assumptions with `Trade.lua`.
- Keep slot/listing mutation O(1); only scans/copies may be O(capacity).

## Existing Knowledge Inputs
- `Code/Logic/Process/Motion/Charge.lua`
- `Code/Logic/Process/Motion/Bezier3.lua`
- `Code/Logic/Process/Item/Storage.lua`
- `Code/Logic/Process/Trade.lua`
- `.planning/PROJECT_PLAYBOOK.md`

## Audit / Debug Focus
- Ensure the library remains above `Trade` instead of depending on trade-event internals.
- Verify the handoff seam for future `Trade` integration is explicit and stable.
- Verify syntax statically with the repo-local Lua 5.3 toolchain.

## Stakeholders / Surface
- Library/runtime users who need scripted shops.
- Future `Trade.lua` integration work that will report native sales into this library.
- Event listeners that need stock/listing change hooks.

## Success Signals
- `Shop.lua` implements the planned API and compiles with `luac -p`.
- The file contains a clear `Trade` integration seam via `recordSaleBySeller(...)`.
- The library style matches the current direct/flat project preference.

## Open Questions
- Native trade-event integration and in-engine smoke testing remain future work.
