# Step Plan

## Current Step
- Name: Finalize the flattened Storage pass after the user removed the old compatibility/helper route
- Parent phase: Phase 1
- Why now: The user explicitly rejected `Item` mounting and thin helper layers, so the remaining work was to bring the implementation and task memory into line with that flatter route.

## Step Objective
- `Storage.lua` reflects the project-wide direct/flat style baseline, no longer mounts onto `Item`, no longer keeps low-value helper wrappers, still preserves runtime semantics, and passes syntax validation.

## Requirement Alignment
- Reanalyze from current source instead of inheriting old conclusions.
- Follow the project-wide code-style summary.
- Do not mount `Storage` onto `Item`.
- Remove low-value wrappers such as `get_slots`, `assert_storage`, and `assert_item`.
- Keep the work efficient, low-overhead, and confined to the current module.

## Planned Technical Route
- Keep the existing slot-array plus reverse-lookup model.
- Flatten the module surface to direct `Storage` entrypoints instead of `Item` compatibility aliases.
- Inline trivial slot-table access and one-line debug checks at the relevant call sites.
- Keep `first_free` as the direct fast path for no-argument slot selection.
- Preserve post-mutation event timing and live-state safety during `clear`.
- If the mixed-encoding comment block makes narrow patching unreliable, prefer a clean in-file rewrite over fragile partial edits.

## Framework Compatibility Review
- The route must fit `Array`, `Class`, `DataType`, and `Event` without broader framework edits.
- The project-wide style summary and project playbook both support the flatter direct route.
- The main semantic constraint is still event reentrancy inside `clear`, not the removed helper layer.

## Detail Resolution Focus
- Confirm that the `Item` mount block is gone.
- Confirm that thin helper wrappers are gone and call sites are flattened.
- Confirm that direct `Storage` examples replace the old `Item.newStorage(...)` pattern.
- Confirm that syntax still passes.

## Required Inputs
- `Code/Logic/Process/Item/Storage.lua`
- `doc/椤圭洰浠ｇ爜椋庢牸鎬荤粨-2026-04-11.md`
- `.planning/PROJECT_PLAYBOOK.md`
- `.tools/lua53/bin/luac.exe`

## Relevant Project Memory
- `.planning/PROJECT_PLAYBOOK.md`
- `doc/椤圭洰浠ｇ爜椋庢牸鎬荤粨-2026-04-11.md`
- `doc/Bezier3浠ｇ爜椋庢牸鎬荤粨-2026-04-10.md`

## Standards / Bug Avoidance Applied
- Prefer flat ownership and direct state.
- Prefer hot-path trust of established invariants over redundant wrapper helpers.
- Keep compatibility aliases minimal unless real callers require them.
- Do not let a flattening pass break live state under event callbacks.

## Debug / Inspection Plan
- Audit `resolve_target_slot`, `findEmpty`, `clear`, and the public mutation APIs after helper removal.
- Check that `Class.static(Item, ...)` is gone from `Storage.lua`.
- Use `luac -p` as the immediate validation signal.

## Completion Standard
- Acceptable completion: `Storage.lua` follows the flattened route, the old `Item` mount is removed, low-value helpers are removed, and syntax validation passes.
- Not acceptable: leaving the old compatibility layer in place, leaving thin wrapper helpers behind, or regressing event-safety semantics in `clear`.

## Temporary Detailed Actions
- Refresh the route against the project-wide style summary and playbook.
- Rewrite the file if needed to escape brittle mixed-encoding comment-context patching.
- Recheck the direct API examples and direct call paths.
- Run `luac -p` on `Storage.lua`.
- Sync the actual route and findings back into the task workspace files.

## Validation
- `.tools/lua53/bin/luac.exe -p Code/Logic/Process/Item/Storage.lua`

## Replan / Abort Conditions
- Discovering a syntax or obvious invariant regression.
- Discovering that keeping runtime semantics requires a broader framework edit.

## Summary Updates Expected
- `PROJECT_SUMMARY.md` should record the flattened route, removed `Item` mount, removed thin helper layer, and validation result.
- No new `.planning/PROJECT_PLAYBOOK.md` promotion is required yet because the relevant style rules are already present there.
