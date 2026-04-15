# Project Summary

## Current Mission
- Reanalyze and optimize the current `Storage` library against the project's established style baseline, emphasizing high efficiency and low consumption while keeping the module flat and direct.

## Context Snapshot
- Task label: Optimize Storage Runtime Efficiency
- Task slug: optimize-storage-runtime-efficiency
- Task type(s): library refactor, runtime efficiency optimization, brownfield maintenance
- Project context: shared runtime library in a brownfield codebase
- Selected pattern: inspect current source -> rebase on project-wide style summary -> flatten in-file layering -> syntax validation -> memory sync
- Planning container: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning
- Project playbook: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.planning/workspaces/optimize-storage-runtime-efficiency
- Project toolset: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.tools
- Canonical references: D:/Software/榄斿吔鍦板浘缂栬緫/[0]鏂版暣鍚堢紪杈戝櫒/Lua/.canon

## Planned Technical Route Baseline
- Treat `doc/椤圭洰浠ｇ爜椋庢牸鎬荤粨-2026-04-11.md` plus `.planning/PROJECT_PLAYBOOK.md` as the authoritative style baseline.
- Keep the slot-array plus reverse-lookup-table structure; optimize and flatten the existing route instead of redesigning it.
- Remove the `Item` mount surface and keep `Storage` itself as the primary public API.
- Remove low-value wrappers such as `get_slots`, `assert_storage`, `assert_item`, and the extra no-arg free-slot getter helper.
- Preserve post-mutation event timing and keep batch paths safe under listener reentrancy.

## Inherited Standards and Principles
- Prefer flat data shape, direct ownership, setup-heavy normalization, and hot-path simplicity.
- Keep helpers only when they provide real shared value.
- Trust established internal contracts on the hot path instead of repeating entry-level wrappers.
- Document scan/copy cost explicitly and avoid silently widening a leaf-library task into a broader framework edit.

## Bug Avoidance and Red Flags
- Do not treat older Storage-specific audit conclusions as binding for this pass.
- Do not reintroduce an `Item` compatibility surface unless a real caller needs it.
- Do not keep thin wrappers that only hide `rawget(..., slots_modify)` or one-line debug assertions.
- Do not cache mutable live state across `emit_change(...)` inside `clear`.
- Do not widen into `Event.lua` unless a current-file solution is truly impossible.

## Debug Signals and Inspection Hooks
- `storage.first_free`
- `storage.size`
- `Storage.getByItem(item)` / `Storage.getSlotByItem(item)`
- Existing `Event.onItemStorageChange(...)` listeners
- `.tools/lua53/bin/luac.exe -p Code/Logic/Process/Item/Storage.lua`

## Reusable Experience and Lessons
- The project-wide style summary is more authoritative than any single sibling module or older audit artifact when they conflict.
- User feedback on complexity can be a reliable signal that a helper layer has fallen below the project's value threshold.
- `first_free` is already maintained strongly enough to support direct no-argument fast paths without an extra wrapper function.
- Eventful batch APIs need special care: a local caching optimization can be wrong even when the flattened code looks mechanically cleaner.

## Active Improvements
- Flattened the module API to direct `Storage.new(...)`, `Storage.getByItem(...)`, and `Storage.getSlotByItem(...)` usage.
- Removed the old `Class.static(Item, ...)` mount block.
- Removed thin helpers `get_slots`, `assert_storage`, `assert_item`, and the extra no-arg free-slot getter wrapper.
- Switched internal slot access to direct `rawget(storage, slots_modify)` / `rawget(target_storage, slots_modify)` at call sites.
- Kept direct `first_free` fast paths for no-argument slot selection.
- Preserved lower-overhead `forEach` / `toTable` paths and kept `clear` live-state safe under reentrancy.

## Route Review and Framework Compatibility Notes
- The final route fits the project style because it stays flat, direct, and avoids decorative abstraction.
- Rewriting `Storage.lua` in place was the safest execution path once the old mixed-encoding comment block started interfering with narrow patching.
- No playbook update is needed yet because the style principles used here are already captured project-wide.

## Tooling Guidance
- Preferred tools: direct source inspection with `rg` and local Lua syntax parsing with `.tools/lua53/bin/luac.exe`.
- Task-local tools active: none.
- Shared mutable project tools active: `.tools/lua53/bin/luac.exe`.
- Canonical references active: none in `.canon/`; the current anchors are the project style summary and playbook.

## Recent Retrospective Signals
- The user correction to discard old conclusions prevented the route from leaning on stale audit framing.
- The user rejection of `Item` mounting and thin helper wrappers sharpened the route into a much flatter implementation.
- Catching the `clear` reentrancy constraint early prevented the flattening pass from "optimizing" away a real safety requirement.

## Open Risks and Watch Items
- Runtime behavior beyond syntax has not been exercised in-engine in this task.
- `Shop.lua` still contains similar patterns but was intentionally left out of scope.
- Any future change to Event fan-out semantics could change what is safe to optimize inside Storage batch paths.

## Update Log
- 2026-04-11: Initial summary created.
- 2026-04-11: Rebased the task on the project-wide style summary after the user clarified the authoritative style source.
- 2026-04-11: Reanalyzed `Storage.lua` from source instead of inheriting prior Storage audit conclusions.
- 2026-04-11: Replaced the earlier helper-tightening route with a flatter route after the user rejected `Item` mounting and thin helper wrappers.
- 2026-04-11: Rewrote `Storage.lua` to remove `Item` mounting, remove thin helper layers, preserve the direct slot-array model, and keep reentrant-safe batch behavior.
- 2026-04-11: `luac -p Code/Logic/Process/Item/Storage.lua` passed.
