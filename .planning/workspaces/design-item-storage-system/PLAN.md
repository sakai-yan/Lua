# Execution Plan

## Planning Mode
- Profile: Standard
- Task type(s): library design, feature delivery, framework integration

## Project Context
- Context type: Brownfield framework/library
- Selected pattern: Inspect existing contracts -> design low-overhead core -> implement in isolated file -> validate -> record follow-up risks

## Requirement Integration
- The user required reuse of existing project libraries, high efficiency, low overhead, and zero edits to sibling libraries.
- The route therefore uses `Class`, `Array`, `DataType`, and `Event`, keeps state in a fixed-slot array plus weak ownership maps, and limits file changes to `Storage.lua`.

## Technical Route Strategy
- Approved route: implement a pure storage core with fixed capacity, slot-based movement, weak global item membership maps, and a single generic storage-change event.
- Fixed decisions: no edits outside `Storage.lua`; no UI/native inventory sync logic; one-item-one-storage invariant; optional accept-rule hook for caller-specific restrictions.
- Intentionally open details: how future backpack/warehouse systems surface the storage in UI and whether startup should auto-require the module.
- Framework review: keep `Item` extension points on the `Item` class and `Event` wrapper naming aligned with existing Process modules.

## Workspace
- Project root: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua
- Planning container: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Project playbook: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/design-item-storage-system
- Task slug: design-item-storage-system
- Task-local tools directory: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/design-item-storage-system/tools
- Project toolset directory: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical reference directory: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon
- Reports directory: d:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/design-item-storage-system/reports

## Knowledge Inputs
- `Core.Entity.Item.lua` for item identity and ownership assumptions.
- `Logic.Process.Item.*` modules for event and `Item` extension style.
- `FrameWork.Manager.Event.lua` for pooled event design.
- `Lib.Base.Array.lua` and `Lib.Base.Class.lua` for low-overhead storage internals.

## Assumptions
- Stored objects are `item` instances, not item-type configs.
- Backpack and warehouse layers need the same data core but may differ in UI and surrounding gameplay rules.
- Future callers can explicitly load `Storage.lua` if startup integration is not yet allowed.

## Completion Standard
- Complete delivery means `Storage.lua` exists, exposes the storage API and event hooks, validates syntactically, and the task workspace reflects the implementation route and discovered risks.
- Not acceptable: placeholder API stubs, hidden coupling to UI/native inventory, or patching unrelated libraries against the user's scope rule.

## Audit / Debug Strategy
- Re-check slot/item ownership invariants after implementation.
- Use `luac -p` for syntax verification.
- Record obvious sibling-library contract bugs for user follow-up.

## Capability Routing Rules
- Required capabilities are written as stable names.
- Implementation is resolved at execution time.

## Phase 1

### Goal
- A reusable storage core for `item` objects exists and is validated.

### Inputs
- `Core.Entity.Item.lua`
- `Logic.Process.Item/Create.lua`, `Get.lua`, `Lose.lua`, `Delete.lua`, `Use.lua`
- `FrameWork.Manager.Event.lua`
- `Lib.Base.Array.lua`
- `Lib.Base.Class.lua`

### Outputs
- `War3/map/Logic/Process/Item/Storage.lua`
- Updated task workspace notes and summary
- Syntax validation result

### Dependencies
- Existing item and event contracts must be understood well enough to fit the new module into the current framework style.

### Technical Route
- Build a slot-array storage object with global weak item -> storage / slot lookup.
- Emit a generic storage-change event for storage/item listeners.
- Provide `Item` static helpers so callers can create and inspect storages through the existing `Item` surface.
- Auto-purge deleted items from storage when the item-delete event type is available.

### Detailed Implementation Approach
- Only `War3/map/Logic/Process/Item/Storage.lua` is edited.
- Public instance API: `add`, `remove`, `move`, `swap`, `transfer`, `exchange`, `clear`, `contains`, `get`, `slotOf`, `findEmpty`, `iterator`, `forEach`, `toTable`.
- Public static exposure: `Item.Storage`, `Item.newStorage`, `Item.getStorage`, `Item.getStorageSlot`, `Item.isStored`.
- Fixed invariants: no duplicate membership, no silent overwrite, slot occupancy tracked by direct array access.

### Risks
- Runtime integration may still require adding a startup `require`, which is out of scope for this task.
- Sibling item modules contain bugs that could affect later runtime integration.

### Requirement Alignment
- Reuse existing libraries.
- Keep the design efficient and low-overhead.
- Stay inside the single-file scope.
- Support both backpack and warehouse use cases at the storage-core layer.

### Architecture Fit Review
- The route fits the current project by extending `Item` and `Event` like other Process modules do.
- The design deliberately stops at the data layer so it can support multiple upper-layer inventory styles without forcing one runtime model.

### Explicitly Unresolved Details
- Startup auto-loading and UI/native inventory integration are deferred.
- Any later integration must preserve the one-item-one-storage invariant and avoid mutating sibling modules without explicit approval.

### Diagnostic Hooks / Signals
- `luac -p` syntax validation.
- Event-based storage change hooks for future debugging/integration.

### Relevant Experience / Standards
- Reuse project-native libraries before building new helpers.
- Keep hot paths numeric and direct.
- Avoid widening the task into unrelated framework edits.

### Required Capabilities
- `repo_audit`
- `route_detail_design`
- `phase_plan`
- `session_update`
- `test_strategy`

### Validation
- Compile `Storage.lua` with `luac -p`.
- Manually inspect the module for invariant coverage and boundary behavior.

### Expected Summary Updates
- Record the approved storage architecture, public API, validation result, and discovered external-library issues.

### Expected Tool / Report Updates
- No new tools required for this phase.
- No canonical reference was close enough to reuse directly.
- The planning workspace documents serve as the audit record.

## Replan Triggers
- The user allows edits outside `Storage.lua`.
- Runtime integration requires a different item ownership contract than the current pure-storage design assumes.
- A later requirement introduces stacking or equipment semantics that materially change slot rules.

## Definition of Done
- `Storage.lua` is implemented.
- Syntax validation passes.
- The task workspace captures route, validation, and follow-up risks.
- Discovered sibling-library issues are reported instead of silently ignored.
