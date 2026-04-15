# Project Brief

## Problem
- The user wants the `Storage` library adjusted and optimized according to the project's established coding style, with an explicit emphasis on high efficiency and low consumption.
- The user then clarified that earlier conclusions should be set aside and the current code should be analyzed again comprehensively from source.

## Project Context
- Brownfield shared library work inside an existing runtime/framework codebase.
- This context favors targeted refactoring over redesign: preserve the proven slot-array model, inspect invariants and direct dependencies carefully, and avoid widening into unrelated systems.

## Project-Local Workspace
- Project root: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua
- Planning container: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Project playbook: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/optimize-storage-runtime-efficiency
- Task slug: optimize-storage-runtime-efficiency
- Task-local tools directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/optimize-storage-runtime-efficiency/tools
- Project toolset directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical reference directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon
- Reports directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/optimize-storage-runtime-efficiency/reports

## Goals
- Reanalyze `Storage.lua` from current source instead of inheriting prior audit conclusions.
- Apply the project-wide style baseline from `doc/项目代码风格总结-2026-04-11.md` and `.planning/PROJECT_PLAYBOOK.md`.
- Reduce avoidable overhead in direct runtime paths and batch/helper paths while keeping the library compact and readable.
- Validate the edited Lua file syntactically and record the task state clearly for later continuation.

## Normalized Requirements
- Use the project's historical style summary as the real style baseline rather than inferring style only from nearby modules.
- Discard old Storage-specific conclusions as binding decisions and rerun the reasoning from source.
- Prefer direct, flat, owner-local state and setup-time normalization over extra wrappers or new secondary structures.
- Optimize for low runtime overhead and low allocation without inventing a larger abstraction.
- Keep the current task centered on `Storage.lua` unless a hard blocker proves that impossible.

## Non-Goals
- No new inventory gameplay features.
- No UI or six-slot native inventory bridge.
- No persistence/save format work.
- No broader `Event.lua` refactor in this pass.
- No repository-wide refactor of sibling container libraries.

## Constraints
- `Storage.lua` is a shared library and must keep its public surface recognizable.
- `Storage` change notifications are post-mutation events running through the existing Event system.
- The module is still manually loaded by callers via `require "Logic.Process.Item.Storage"`.
- Validation is limited locally to source inspection and Lua syntax parsing in this environment; no in-engine runtime harness is available in this task.

## Existing Knowledge Inputs
- Primary style authority:
- `doc/项目代码风格总结-2026-04-11.md`
- `.planning/PROJECT_PLAYBOOK.md`
- Historical style lineage:
- `doc/Bezier3代码风格总结-2026-04-10.md`
- Direct source inputs:
- `Code/Logic/Process/Item/Storage.lua`
- `Code/Lib/Base/Array.lua`
- `Code/Lib/Base/Class.lua`
- `Code/Lib/Base/DataType.lua`
- `Code/FrameWork/Manager/Event.lua`
- No `.canon/` reference currently defines this module's expected runtime behavior.

## Audit / Debug Focus
- Check whether `first_free` is already strong enough to support O(1) auto-slot selection.
- Check whether reverse lookup tables are hit frequently enough to justify local upvalue caching.
- Check whether `forEach`, `toTable`, and `clear` contain avoidable closure/copy/helper overhead.
- Check whether event emission makes any apparent optimization unsafe because listeners can mutate `Storage` again during callbacks.

## Stakeholders / Surface
- Affected code surface: `Storage.lua` callers and any listeners using `Event.onItemStorageChange(...)`.
- Directly affected interfaces: constructor/setup fields, add/remove/move/swap/transfer/exchange paths, scan/copy helpers, and item-deletion purge handling.

## Success Signals
- The edited file follows the current project-wide style baseline more closely.
- Direct runtime paths are shorter and less indirect where the current invariants already allow it.
- Batch/helper paths remove avoidable overhead without corrupting state under event callbacks.
- `luac -p` passes on `Code/Logic/Process/Item/Storage.lua`.

## Open Questions
- No blocking question remains for this pass.
- A future follow-up may still decide whether sibling container libraries such as `Shop` should adopt the same optimizations.
