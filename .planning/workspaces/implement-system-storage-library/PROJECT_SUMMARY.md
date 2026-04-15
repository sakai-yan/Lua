# Project Summary

## Current Mission
- Provide a reusable, low-overhead `Logic.System.Storage` core for backpack or warehouse style item storage.

## Context Snapshot
- Task label: Implement System Storage Library
- Task slug: implement-system-storage-library
- Task type(s): feature
- Project context: brownfield framework/library
- Selected pattern: inspect current surface -> minimal implementation -> validation -> memory sync
- Planning container: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning
- Project playbook: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/implement-system-storage-library
- Project toolset: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.tools
- Canonical references: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.canon

## Planned Technical Route Baseline
- `Code/Logic/System/Storage.lua` owns the runtime data-layer container.
- Runtime state is a fixed slot array plus `item -> slot` and `item -> storage` weak lookup tables.
- Public mutation APIs are only `store`, `take`, and `swap`.
- `take` is slot-oriented.
- Same-storage swap and cross-storage swap share one flat, slot-oriented `swap` path.
- Only `normalize_slot` and `refresh_first_free` remain as internal helpers.

## Inherited Standards and Principles
- Prefer flat owned state and direct data flow.
- Keep hot-path mutations O(1) when possible.
- Avoid abstraction layers that do not add concrete caller value.
- Treat user-marked deprecated siblings as out of route.
- Public comments should explain contract, cost, caveats, and usage examples in a directly reusable way.

## Bug Avoidance and Red Flags
- Do not allow one item to belong to more than one storage at once.
- Do not silently store non-`item` values.
- Do not let same-storage swap-to-empty drift `first_free`.
- Do not reintroduce event, `Class`, or compatibility layers without an actual caller need.

## Debug Signals and Inspection Hooks
- `storage.size`
- `storage.first_free`
- `storage:get(slot)`
- `storage:slotOf(item)`
- `storage:contains(item)`

## Reusable Experience and Lessons
- For fixed-slot containers, reverse lookup tables already cover uniqueness and membership; forcing `Set` into the runtime would only duplicate state here.
- User clarification about deprecated sibling modules should be applied early, before route design hardens around old code.

## Active Improvements
- Added a complete `Logic.System.Storage` implementation where only a broken stub existed before.
- Added lightweight runtime guards so invalid `item` or `storage` inputs return explicit errors in mutators.
- Flattened the implementation again after review by removing low-value helper layers.
- Added detailed Chinese documentation across the whole module.

## Route Review and Framework Compatibility Notes
- A plain table module fits the current `Logic.System` layer and the project playbook better than a heavier class/event route.
- The implementation intentionally stays as a pure data layer and leaves item lifecycle sync to future scoped work.
- The user review confirmed that some earlier helper extraction was too aggressive for this module size; the flatter route is the better fit here.

## Tooling Guidance
- Preferred tools: `rg`, `.tools/lua53/bin/luac.exe`, `.tools/lua53/bin/lua.exe`
- Task-local tools active: none
- Shared mutable project tools active: repo-local Lua 5.3 binaries
- Canonical references active: none in `.canon/`; local project style and sibling `System` modules were the relevant inputs

## Recent Retrospective Signals
- Replacing the broken file outright was lower-risk than trying to salvage the one-line stub.
- A tiny Lua smoke script gave enough confidence for this isolated runtime task without expanding into game-engine integration work.

## Open Risks and Watch Items
- There is still no automatic sync if an item is destroyed while stored.
- The module is not wired into any higher-level bag or warehouse system yet.
- Future stacking or acceptance rules would require a separate design pass.

## Update Log
- 2026-04-12: Initial summary created.
- 2026-04-12: Recorded the deprecated-sibling constraint, the flat fixed-slot route, and the final validation evidence.
- 2026-04-12: Reflattened the module after user review and added detailed Chinese comments and usage notes.
