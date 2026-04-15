# Step Plan

## Current Step
- Name: Implement and validate the first Shop runtime slice
- Parent phase: Phase 1
- Why now: the style baseline and layering constraint were clear enough to code directly once the user clarified that `Shop` sits above `Trade`.

## Step Objective
- Deliver a working `Shop.lua` with slot/listing management, scripted active selling, future external sale recording, and shop change events.

## Requirement Alignment
- Follow the direct `Charge` / `Bezier3` coding style.
- Keep the implementation efficient and low-overhead.
- Support item sale and unit hire.
- Keep the library above `Trade` and leave a clean future sync seam.

## Planned Technical Route
- Fixed-capacity slot array.
- Per-shop goods lookup map.
- Config-owned derived entry state.
- `sell(...)` for active scripted sale.
- `recordSale(...)` / `recordSaleBySeller(...)` for future `Trade` callbacks.
- Generic `Shop_Change` event.

## Framework Compatibility Review
- This route fits the already-built framework because it reuses `Class`, `Array`, `DataType`, `Event`, `Item`, `Unit`, and `Player` without changing their contracts.
- The main correction made during planning was to avoid any direct `Trade` dependency after the user clarified the layering direction.

## Detail Resolution Focus
- Resolve how a sold instance maps back to a listed template without depending on `Trade`.
- Resolve how to keep O(1) lookups while still supporting both instance-backed and type-backed goods.
- Resolve how future `Trade` integration should enter the library without reopening the implementation.

## Required Inputs
- `Code/Logic/Process/Motion/Charge.lua`
- `Code/Logic/Process/Motion/Bezier3.lua`
- `Code/Logic/Process/Item/Storage.lua`
- `Code/Logic/Process/Trade.lua`
- `.tools/lua53/bin/luac.exe`

## Relevant Project Memory
- `PROJECT_PLAYBOOK.md` for flat config, setup-time normalization, and cost-model guidance.
- The completed item storage task as the nearest container-library precedent.

## Standards / Bug Avoidance Applied
- Avoid circular coupling to `Trade`.
- Avoid dynamic table churn in sale hot paths.
- Avoid duplicate shop aliases or speculative API layers.
- Record future integration seams explicitly instead of baking in temporary assumptions.

## Debug / Inspection Plan
- Static source inspection of O(1) operations and slot bookkeeping.
- Syntax validation with `luac -p`.
- Manual review of the future `Trade` handoff API.

## Completion Standard
- The step is complete only when `Shop.lua` is implemented, validated, and the workspace artifacts reflect the new route.
- Placeholder methods or half-finished API sketches are not acceptable.

## Temporary Detailed Actions
- Implement the `Shop` class and listing-entry normalization.
- Implement `sell(...)`, `recordSale(...)`, and `recordSaleBySeller(...)`.
- Add `Shop_Change` event wrappers.
- Validate with `luac -p`.
- Sync workspace memory.

## Validation
- `D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools/lua53/bin/luac.exe -p Code/Logic/System/Shop.lua`

## Replan / Abort Conditions
- Future integration reveals missing data in the sale-record path.
- In-engine behavior proves scripted sale transfer needs a different lower-layer contract.

## Summary Updates Expected
- Record the implemented route, validation result, and future `Trade` seam in `PROJECT_SUMMARY.md`.
