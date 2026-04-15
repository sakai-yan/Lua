# Execution Plan

## Planning Mode
- Profile: Standard
- Task type(s): feature

## Project Context
- Context type: brownfield framework/library
- Selected pattern: inspect current surface -> define minimal container contract -> implement isolated runtime module -> validate with syntax and smoke checks -> sync planning memory

## Requirement Integration
- The user requirement to ignore deprecated `Process/Item/Storage.lua` was treated as a hard route constraint.
- The efficiency and simplicity requirements were integrated by keeping the module inside one file with fixed-slot arrays and direct reverse lookup tables.
- The request for only store/take/swap behavior kept the public mutation API intentionally narrow.
- The later user correction to "flatten the code as much as possible" was integrated by removing low-value helper layers and making `take/swap` slot-oriented.
- The later user request for detailed Chinese comments was integrated by expanding the module header and every public function contract comment.

## Technical Route Strategy
- Implement `Logic.System.Storage` as a plain table module with `Storage.__index = Storage`.
- Keep state in `_slots`, `_slot_by_item`, `storage_by_item`, `size`, `capacity`, and `first_free`.
- Support `store(item, slot?)`, `take(slot)`, and `swap(left_slot, right_slot)` / `swap(left_slot, target_storage, right_slot)`.
- Keep small query helpers (`isEmpty`, `isFull`, `space`, `contains`, `get`, `slotOf`) for callers and validation.
- Do not add event dispatch, `Class` wrapping, or compatibility aliases without an actual caller need.

## Workspace
- Project root: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua
- Planning container: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning
- Project playbook: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/implement-system-storage-library
- Task slug: implement-system-storage-library

## Knowledge Inputs
- Project playbook guidance on flat config/data shape, direct ownership, and O(1) mutation paths.
- `Shop.lua` and `Group.lua` as current `System`-layer shape references.
- `DataType.lua` and `Set.lua` as base utility references.

## Assumptions
- `item` tables are already marked with `DataType.set(item, "item")`.
- A lightweight data layer is the correct scope for `Logic.System.Storage`.
- Future integration work can layer extra behavior on top without forcing it into this file now.

## Completion Standard
- `Code/Logic/System/Storage.lua` is fully implemented and parse-valid.
- Core operations behave correctly in a minimal smoke run.
- Planning memory records the deprecated-sibling constraint and the final route.
- No placeholder stubs remain in the runtime file.

## Audit / Debug Strategy
- Check slot normalization and `first_free` updates.
- Smoke test same-storage move-via-swap, cross-storage occupied swap, cross-storage move-to-empty, and take.
- Reject invalid runtime inputs in mutators without silently corrupting state.

## Capability Routing Rules
- Required capabilities: `repo_audit`, `phase_plan`, `detail_gap_resolve`, `planned_route_framework_review`, `test_strategy`, `session_update`

## Phase 1

### Goal
- Finish a direct, efficient item storage runtime in `Code/Logic/System/Storage.lua`.

### Inputs
- `Code/Logic/System/Storage.lua`
- `Code/Logic/System/Shop.lua`
- `Code/Logic/System/Group.lua`
- `.planning/PROJECT_PLAYBOOK.md`
- `Code/Lib/Base/DataType.lua`

### Outputs
- Implemented `Storage` module
- Validation notes
- Updated planning memory

### Dependencies
- Current project style guidance
- Repo-local Lua toolchain

### Technical Route
- Use a fixed slot array for storage positions.
- Use weak item-keyed maps for reverse lookup and global ownership.
- Use `first_free` caching to keep default `store` cheap.

### Detailed Implementation Approach
- Rebuild the broken file instead of trying to patch the partial stub.
- Keep the constructor and all methods in one flat module.
- Allow same-storage `swap(left_slot, right_slot)` and cross-storage `swap(left_slot, other_storage, right_slot)`.
- Support empty-target swap by allowing the target slot to be empty.
- Remove low-value helpers such as `is_item`, `is_storage`, and `resolve_*`.
- Add detailed Chinese comments for module contract, usage, return values, error values, and complexity.

### Risks
- Incorrect `first_free` maintenance after swap-to-empty.
- Hidden coupling with future item lifecycle behavior not in scope today.

### Requirement Alignment
- Matches the user's minimal API request.
- Matches the user's efficiency and simplicity request.
- Respects the user's clarification that the old sibling storage is deprecated.

### Architecture Fit Review
- The route fits the newer project style better than reusing a heavier eventful container design.
- The final design stays inside `Logic.System` and avoids broad framework edits.

### Explicitly Unresolved Details
- Automatic sync when an item is destroyed elsewhere.
- Any future acceptance filtering or stacking semantics.

### Diagnostic Hooks / Signals
- `storage.size`
- `storage.first_free`
- `storage:get(slot)`
- `storage:slotOf(item)`

### Relevant Experience / Standards
- Project playbook rules about flat owned state and O(1) mutation paths.

### Required Capabilities
- `detail_gap_resolve`
- `planned_route_framework_review`
- `test_strategy`
- `session_update`

### Validation
- `.tools/lua53/bin/luac.exe -p Code/Logic/System/Storage.lua`
- Repo-local Lua smoke script covering store/take/swap branches

### Expected Summary Updates
- Record the final module route, validation evidence, and residual lifecycle risks.

### Expected Tool / Report Updates
- No new task-local helper tools expected.
- Reuse `.tools/lua53/bin/luac.exe` and `.tools/lua53/bin/lua.exe`.

## Replan Triggers
- A caller requires event hooks, stacking, or item-destroy auto-sync in this same file.
- Validation reveals slot bookkeeping or `first_free` drift.
- Another subsystem forces a different public API shape.

## Definition of Done
- The runtime file is implemented, validated, and documented enough for reuse.
- The planning workspace reflects the final route and the deprecated-sibling constraint.
