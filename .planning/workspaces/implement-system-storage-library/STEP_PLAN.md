# Step Plan

## Current Step
- Name: Flatten `System.Storage` and add detailed Chinese documentation
- Parent phase: Phase 1
- Why now: `Code/Logic/System/Storage.lua` was incomplete, and the user asked for direct delivery rather than a broader redesign.

## Step Objective
- Finish a self-contained storage runtime that preserves slot invariants under store, take, and same/cross-storage swap.

## Requirement Alignment
- Keep the code simple and direct.
- Keep the API centered on `item`.
- Support same-storage and cross-storage position exchange.
- Ignore deprecated `Process/Item/Storage.lua`.
- Reduce low-value helper extraction.
- Add detailed Chinese function comments and usage notes.

## Planned Technical Route
- Use fixed slots plus reverse lookup.
- Keep `first_free` cached for cheap auto-slot store.
- Use a plain module table instead of a class/event surface.
- Narrow `take/swap` to slot-oriented public entrypoints so the public path is easier to read.

## Framework Compatibility Review
- `Logic.System` already contains both simple plain-table modules and heavier class-based modules; this task fits the simpler side.
- No surrounding framework contract forced `Class`, events, or extra compatibility wrappers.
- The route fits the project playbook's preference for direct ownership and hot-path simplicity.

## Detail Resolution Focus
- Slot-oriented `swap` signature for same-storage and cross-storage usage.
- Correct `first_free` maintenance when an occupied slot swaps with an empty slot.
- Which helpers are genuinely high-value enough to keep.
- Detailed Chinese comments that explain contract without adding more abstraction.

## Required Inputs
- `.planning/PROJECT_PLAYBOOK.md`
- `Code/Logic/System/Shop.lua`
- `Code/Logic/System/Group.lua`
- `Code/Lib/Base/DataType.lua`
- `Code/Logic/System/Storage.lua`

## Relevant Project Memory
- Project playbook guidance on flat state and O(1) mutations.
- The user clarification that `Process/Item/Storage.lua` is deprecated.

## Standards / Bug Avoidance Applied
- Do not duplicate a deprecated sibling route.
- Do not add abstraction layers without a concrete caller need.
- Keep the runtime path numeric and table-direct.
- Reject invalid mutator inputs rather than writing broken state.

## Debug / Inspection Plan
- Parse with repo-local `luac`.
- Execute a small Lua smoke script that checks store, take, and both swap branches.
- Confirm `size`, `slotOf`, `contains`, and `first_free` after each operation.

## Completion Standard
- Runtime file implemented.
- Parse check passed.
- Smoke run passed.
- Planning memory updated.

## Temporary Detailed Actions
- Remove low-value helper functions and flatten the mutator code.
- Rework comments into detailed Chinese module and function docs.
- Run parse validation.
- Run smoke validation.
- Sync workspace notes and summary.

## Validation
- Passed: `.tools/lua53/bin/luac.exe -p Code/Logic/System/Storage.lua`
- Passed: repo-local Lua smoke script for store/take/swap and invalid-input guards after the flattening pass

## Replan / Abort Conditions
- Discovery of a hidden existing caller contract that requires a different public API.
- Smoke validation exposing slot-map drift or invalid `first_free` updates.

## Summary Updates Expected
- Record the final state model, validation evidence, and residual item-lifecycle risk in `PROJECT_SUMMARY.md`.
- Do not promote a new project-wide principle yet; one implementation is not enough evidence.
