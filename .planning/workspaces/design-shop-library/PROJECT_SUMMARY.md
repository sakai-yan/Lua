# Project Summary

## Current Mission
- Provide a reusable, low-overhead upper-layer shop runtime for selling items and hiring units without coupling the implementation to `Trade.lua`.

## Context Snapshot
- Task label: Design Shop Library
- Task slug: design-shop-library
- Task type(s): library design, feature delivery, framework integration
- Project context: brownfield framework/library
- Selected pattern: inspect style baselines -> implement isolated low-overhead core -> validate -> preserve future integration seam
- Planning container: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Project playbook: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/design-shop-library
- Project toolset: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical references: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon

## Planned Technical Route Baseline
- `Shop.lua` owns the upper-layer runtime.
- One seller maps to one shop instance.
- Internal state uses a fixed-capacity slot array plus a per-shop goods -> slot weak map.
- Listed goods may be `item`, `unit`, `itemtype`, or `unittype`.
- `sell(...)` handles scripted active sale and charges buyer-owner resources.
- `recordSale(...)` and `recordSaleBySeller(...)` are the future lower-layer/native sync seam.
- A generic `Shop_Change` event reports add/remove/restock/sell mutations.

## Inherited Standards and Principles
- Localize frequently used dependencies and helpers at the top of the file.
- Normalize config and derived state during setup so sale hot paths stay short.
- Prefer flat scalar entry fields over nested config objects.
- Keep API surface compact and avoid speculative aliases.
- Keep O(1) mutations explicit and document O(capacity) scan/copy helpers.

## Bug Avoidance and Red Flags
- Do not couple `Shop` directly to `Trade` before the integration step is actually requested.
- Do not let instance-backed goods pretend they have reusable stock.
- Do not silently scan all slots in hot-path sale bookkeeping when a direct lookup is possible.
- Do not rely on `unit.owner` returning a wrapped player object; normalize owner through `Player.getPlayerByHandle(...)` when needed.

## Debug Signals and Inspection Hooks
- `Event.onShopChange(...)`
- `shop:match(...)`
- `Shop.recordSaleBySeller(...)`
- Static syntax validation through `.tools/lua53/bin/luac.exe -p`

## Reusable Experience and Lessons
- The storage-style slot array + weak lookup map pattern transfers cleanly from item storage to shop listings.
- Future lower-layer integration is easier when the upper-layer library already exposes an explicit “sale already happened” recording API.
- The newer preferred style is not just “faster”; it also means fewer intermediate abstractions and more direct ownership of derived state.

## Active Improvements
- Added the first real `Shop.lua` implementation where the file was previously empty.
- Established a clean future `Trade` integration seam without forcing the integration in the same step.

## Route Review and Framework Compatibility Notes
- The final route fits the current framework cleanly because it reuses existing primitives instead of inventing a detached runtime.
- Avoiding `Trade` coupling was the key route correction after the user's clarification.
- The runtime supports both exact-instance listings and template-backed listings while still keeping O(1) sale matching through direct goods/type lookup.

## Tooling Guidance
- Preferred tools: direct source inspection, `rg`, and `.tools/lua53/bin/luac.exe`.
- Task-local tools active: none.
- Shared mutable project tools active: the repo-local Lua 5.3 toolchain under `.tools/lua53`.
- No close `.canon` baseline was used for implementation.

## Recent Retrospective Signals
- The strongest useful comparison was `Item.Storage.lua`, not broader repo-wide searches.
- The user clarification about `Shop` vs `Trade` prevented a likely circular-coupling design mistake.

## Open Risks and Watch Items
- The new library has static validation only; it still needs in-engine smoke testing.
- `Shop.lua` is not auto-loaded yet.
- The eventual `Trade.lua` integration may still want a small API adjustment once the native sale flow is exercised.

## Update Log
- 2026-04-11: Initial summary created.
- 2026-04-11: Implemented `Code/Logic/System/Shop.lua` as an upper-layer slot-based shop runtime with sale bookkeeping and future `Trade` sync seams.
- 2026-04-11: Validated `Shop.lua` syntax with the repo-local Lua 5.3 `luac`.
