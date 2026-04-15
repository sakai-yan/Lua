# Project Brief

## Problem
- `Code/Logic/System/Storage.lua` was effectively empty and cannot currently support backpack or warehouse data storage.

## Project Context
- Context type: brownfield library/framework work
- Why it matters: the route should match the repo's newer flat, setup-heavy style and avoid dragging in deprecated sibling implementations.

## Project-Local Workspace
- Project root: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua
- Planning container: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning
- Project playbook: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/implement-system-storage-library
- Task slug: implement-system-storage-library

## Goals
- Deliver a usable `Logic.System.Storage` module for `item` objects.
- Keep the implementation direct, low-overhead, and easy to extend later.
- Support same-storage and cross-storage slot exchange without extra adapter layers.

## Normalized Requirements
- Follow the project style summary and project playbook rather than older ad hoc container style.
- Prioritize high efficiency and low consumption.
- Target `item` as the primary stored object.
- Keep the mutation API focused on `store`, `take`, and `swap`.
- Support swap inside one storage and across two storages.
- Do not reference `Code/Logic/Process/Item/Storage.lua`; the user marked it deprecated.
- Keep the code simple and avoid excessive abstraction.

## Non-Goals
- No event system.
- No bag UI or warehouse UI.
- No native Warcraft inventory sync.
- No stack logic, filtering rules, ownership rules, or persistence layer.
- No auto-purge on item destroy in this pass.

## Constraints
- Stay inside `Code/Logic/System/Storage.lua` for runtime implementation.
- Respect the repo preference for flat data ownership and thin public entrypoints.
- Validate with repo-local Lua 5.3 tooling when possible.

## Existing Knowledge Inputs
- `.planning/PROJECT_PLAYBOOK.md`
- `.planning/workspaces/promote-project-coding-style/PROJECT_SUMMARY.md`
- `Code/Logic/System/Shop.lua`
- `Code/Logic/System/Group.lua`
- `Code/Lib/Base/DataType.lua`
- `Code/Lib/Base/Set.lua`

## Audit / Debug Focus
- Slot bookkeeping invariants: `slot -> item`, `item -> slot`, `item -> storage`, `size`, and `first_free`.
- Same-storage swap with an empty slot.
- Cross-storage swap into an occupied slot and into an empty slot.

## Stakeholders / Surface
- Future backpack and warehouse logic under `Logic.System`.
- Callers that need a lightweight item container without UI or event coupling.

## Success Signals
- `Storage.new(...)` creates a valid fixed-slot container.
- `store`, `take`, and `swap` maintain slot mappings and `first_free` correctly.
- Lua syntax parse passes.
- Minimal smoke execution passes with same-storage and cross-storage cases.

## Open Questions
- Whether future item destruction should auto-sync storage state.
- Whether future higher-level systems need typed acceptance rules or stacking.

