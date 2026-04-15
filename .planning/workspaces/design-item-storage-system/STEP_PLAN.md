# Step Plan

## Current Step
- Name: Implement and validate the storage core
- Parent phase: Phase 1
- Why now: The surrounding `Item` and `Event` contracts have been inspected and the route is stable enough to code directly.

## Step Objective
- `Storage.lua` must provide the storage API, `Item` static exposure, storage-change events, and deleted-item cleanup, then pass syntax validation.

## Requirement Alignment
- Reuse existing project libraries.
- Keep the design efficient and low-overhead.
- Avoid edits outside `Storage.lua`.
- Support both backpack and warehouse at the data-core layer.

## Planned Technical Route
- Use a fixed-capacity slot array plus weak global membership maps.
- Expose a generic storage-change event instead of a larger custom callback framework.
- Keep one-item-one-storage as a hard invariant.
- Extend `Item` statically to match the surrounding Process-module style.

## Framework Compatibility Review
- The route fits the existing framework because current Process modules already extend `Item` and wrap `Event`.
- No conflict was found that forced shared-runtime edits.
- The main compatibility constraint is to remain data-layer only and let future callers decide how storage relates to native Warcraft inventory handles.

## Detail Resolution Focus
- Resolve the exact public API names and event payload shape.
- Decide how deleted items are purged from storage without editing sibling files.
- Keep the implementation simple enough to audit quickly.

## Required Inputs
- `Core.Entity.Item.lua`
- `Logic.Process.Item/*.lua`
- `FrameWork.Manager.Event.lua`
- `.tools/lua53/bin/luac.exe`

## Relevant Project Memory
- `PROJECT_PLAYBOOK.md` for the "reuse project capabilities" and "keep hot paths direct" guidance.
- Existing task workspace templates for continuity.

## Standards / Bug Avoidance Applied
- Avoid widening the scope into shared framework fixes.
- Avoid hidden overwrite behavior in slot operations.
- Record discovered sibling-library bugs instead of silently depending on broken behavior.

## Debug / Inspection Plan
- Inspect `Storage.lua` for slot ownership invariants and empty-slot tracking.
- Use `luac -p` for syntax validation.
- Confirm that the API stays decoupled from UI/native inventory semantics.

## Completion Standard
- A full implementation plus validation and synchronized planning notes.
- Placeholder methods, TODO-only modules, or "wire it later" without a working core are not acceptable.

## Temporary Detailed Actions
- Implement the `ItemStorage` class and its slot-management helpers.
- Add the storage-change event and `Item` static helper exposure.
- Hook deleted-item purge if the item-delete event type is already available.
- Validate with `luac -p`.
- Synchronize workspace artifacts.

## Validation
- `luac -p War3/map/Logic/Process/Item/Storage.lua`
- Manual API and invariant inspection

## Replan / Abort Conditions
- Discovering that the storage core must alter sibling runtime modules to work at all.
- A new user requirement that turns the task into UI/native-inventory work.

## Summary Updates Expected
- Write back the implemented architecture, validation result, and external-library bug notes.
- No project-playbook promotion is needed yet because the findings are still item-module-specific.
