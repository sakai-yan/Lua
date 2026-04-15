# Execution Plan

## Planning Mode
- Profile: Standard
- Task type(s): library design, feature delivery, framework integration

## Project Context
- Context type: Brownfield framework/library
- Selected pattern: inspect style baselines -> design low-overhead core -> implement isolated file -> validate -> record future integration seam

## Requirement Integration
- The user required style alignment with `Charge`, `Bezier3`, and the newer direct coding preference, so the route uses flat fields, config-owned derived state, and a short helper set.
- The user clarified that `Shop` is above `Trade`, so the route explicitly avoids trade-event coupling and instead adds `recordSale(...)` / `recordSaleBySeller(...)` for future lower-layer integration.
- Efficiency and low consumption shaped the fixed-capacity slot array, direct goods lookup map, and O(1) hot-path mutations.

## Technical Route Strategy
- Approved route: implement `Shop.lua` as a per-seller slot-based listing runtime with direct item/unit sale support and post-sale stock bookkeeping.
- Fixed decisions:
- One seller maps to one shop instance.
- Listed goods may be `item`, `unit`, `itemtype`, or `unittype`.
- Scripted selling lives in `sell(...)`.
- Future external/native sale syncing lives in `recordSale(...)` and `Shop.recordSaleBySeller(...)`.
- The library emits its own `Shop_Change` event instead of piggybacking on `Trade`.
- Intentionally open details:
- How `Trade.lua` will later call into `Shop.recordSaleBySeller(...)`.
- Whether startup should auto-load `Shop.lua`.
- Whether future UI/native integrations need richer stock metadata.

## Workspace
- Project root: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua
- Planning container: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Project playbook: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/design-shop-library
- Task slug: design-shop-library
- Task-local tools directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/design-shop-library/tools
- Project toolset directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical reference directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon
- Reports directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/design-shop-library/reports

## Knowledge Inputs
- `Charge.lua` and `Bezier3.lua` for direct style expectations.
- `Item.Storage.lua` for a sibling slot/container runtime pattern.
- `Trade.lua` only as a boundary reference, not an implementation dependency.
- `PROJECT_PLAYBOOK.md` for the flat-config, setup-time normalization, and O(1) mutation guidance.

## Assumptions
- Buyer resources are paid from the buyer unit's owning player.
- Scripted unit hire can transfer ownership directly without needing `Trade.lua` right now.
- Future native-trade integration will have seller, buyer, and sold-goods instance data available.

## Completion Standard
- `Code/Logic/System/Shop.lua` contains a working implementation, not a stub.
- The file compiles with `luac -p`.
- The planning workspace records the route, validation result, and future integration seam.
- Not acceptable: empty file, TODO-only scaffolding, or hidden `Trade` coupling.

## Audit / Debug Strategy
- Review the implementation for O(1) lookup/mutation paths.
- Review the API surface for the future `Trade` handoff seam.
- Validate syntax with the repo-local Lua 5.3 `luac`.

## Capability Routing Rules
- Required capabilities are written as stable names.
- Implementation is resolved at execution time.

## Phase 1

### Goal
- Deliver the initial upper-layer shop runtime in `Shop.lua`.

### Inputs
- `Code/Logic/Process/Motion/Charge.lua`
- `Code/Logic/Process/Motion/Bezier3.lua`
- `Code/Logic/Process/Item/Storage.lua`
- `Code/Logic/Process/Trade.lua`
- `.planning/PROJECT_PLAYBOOK.md`

### Outputs
- `Code/Logic/System/Shop.lua`
- Updated planning workspace notes
- Lua syntax validation result

### Dependencies
- Existing `Item`, `Unit`, `Player`, and `Event` contracts must remain the only required lower-level building blocks.

### Technical Route
- Use a fixed-capacity slot array plus per-shop goods -> slot weak map.
- Normalize entry config once during `add(...)`.
- Split sale handling into:
- scripted active sale: `sell(...)`
- external/native sale bookkeeping: `recordSale(...)` and `recordSaleBySeller(...)`
- Emit one generic `Shop_Change` event for add/remove/restock/sell notifications.

### Detailed Implementation Approach
- Implement only `Code/Logic/System/Shop.lua`.
- Public instance API:
- `isEmpty`, `isFull`, `space`
- `contains`, `get`, `getEntry`, `slotOf`, `match`, `stockOf`, `costOf`
- `findEmpty`, `add`, `remove`, `restock`, `clear`
- `canSell`, `recordSale`, `sell`
- `iterator`, `forEach`, `toTable`
- Public static API:
- `ACTION_*`
- `getBySeller`
- `recordSaleBySeller`
- Event wrapper surface:
- `Event.onShopChange`
- `Event.offShopChange`

### Risks
- In-engine behavior for scripted `UnitAddItem` and ownership transfer still needs smoke testing later.
- `Trade.lua` integration details may still force small API adjustments once that work starts.
- `Shop.lua` is not auto-loaded yet.

### Requirement Alignment
- Reuse existing project libraries.
- Stay direct, flat, and low-overhead.
- Support both item sale and unit hire.
- Stay above `Trade` while leaving a clean integration seam.

### Architecture Fit Review
- The route fits the current framework by behaving like a pure runtime/container library, similar in spirit to `Item.Storage.lua`.
- Avoiding direct `Trade` dependency keeps the layering clean and prevents premature circular coupling.

### Explicitly Unresolved Details
- Future `Trade.lua` call sites and native event wiring.
- Startup loading policy.
- Any UI/native shop visualization work.

### Diagnostic Hooks / Signals
- `Shop_Change` event hooks.
- `Shop.match(...)` and `Shop.recordSaleBySeller(...)` as future integration probes.
- `luac -p` syntax validation.

### Relevant Experience / Standards
- Flat scalar config fields and setup-time normalization from the project playbook.
- Direct slot-array design proven in `Item.Storage.lua`.
- Avoiding compatibility wrappers unless there is a real caller need.

### Required Capabilities
- `repo_audit`
- `route_detail_design`
- `phase_plan`
- `session_update`
- `test_strategy`

### Validation
- `D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/lua53/bin/luac.exe -p Code/Logic/System/Shop.lua`
- Manual source review of API surface and cost model

### Expected Summary Updates
- Record the implemented shop architecture, validation result, and future `Trade` seam.

### Expected Tool / Report Updates
- No new tools required.
- No direct `.canon` baseline matched this task closely enough to reuse.

## Replan Triggers
- The user requests immediate `Trade.lua` integration.
- Native in-engine behavior shows that scripted sale transfer semantics need a different lower-layer contract.
- Future requirements add stacking, refresh timers, or richer shop-state rules that materially change the entry model.

## Definition of Done
- `Shop.lua` is implemented.
- Syntax validation passes.
- Workspace notes describe the route and future handoff seam.
