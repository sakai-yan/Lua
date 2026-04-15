# Debug Journal

## Audit Focus / Symptom
- Suspicious overhead and unnecessary indirection inside `Storage.lua`, especially around no-argument auto-slot selection and batch/helper APIs.

## Reproduction / Baseline
- Baseline was established through direct source inspection of `Storage.lua` and its direct dependencies, plus the project-wide style summary.
- No in-engine runtime harness was used in this task; the baseline is source-level and syntax-level only.

## Signals and Debug Interfaces
- `storage.first_free`
- `storage.size`
- Reverse lookup tables for item -> storage / slot
- `Event.onItemStorageChange(...)`
- `.tools/lua53/bin/luac.exe -p`

## Hypotheses
- `first_free` already makes no-argument empty-slot lookup effectively O(1), but the code still routes through a scan helper.
- `forEach` and `toTable` contain avoidable helper/copy overhead.
- A naive `clear` optimization could be incorrect if listeners mutate Storage again during emitted callbacks.

## Experiments
- Re-read `Storage.lua` from current source after the user asked to discard old conclusions.
- Cross-checked the route against `doc/项目代码风格总结-2026-04-11.md` and `.planning/PROJECT_PLAYBOOK.md`.
- Patched the direct fast paths and helper overhead.
- Re-scanned the file with `rg`.
- Parsed the final file with `luac -p`.

## Findings / Root Cause
- Confirmed: `first_free` is maintained strongly enough for direct no-argument auto-slot use.
- Confirmed: repeated `Storage.__storage_by_item` / `Storage.__slot_by_item` table lookups were easy to localize without widening scope.
- Confirmed: `forEach` and `toTable` could be simplified directly.
- Confirmed: caching `size` / `first_free` across `clear` emissions is unsafe under possible listener reentrancy, so the live state must be updated from `storage` each iteration.

## Fix / Mitigation Verification
- `rg` re-scan confirmed the intended simplifications and removed leftover direct reverse-lookup hot-path access.
- `.tools/lua53/bin/luac.exe -p Code/Logic/Process/Item/Storage.lua` passed.
- No new automated regression harness was added in this pass.

## Session Sync Summary
- The main subtlety was not whether Storage could be made more direct; it was ensuring `clear` stayed correct under event reentrancy.

## Task Board Sync
- Active: none
- Ready: optional runtime harness or sibling-library follow-up
- Blocked: in-engine behavioral verification without a harness
- Done: Storage reanalysis, refactor, and syntax validation

## Retained Debug Interfaces
- Existing `Event.onItemStorageChange(...)` remains the key retained diagnosis hook.
- Static getters `Storage.getByItem(item)` and `Storage.getSlotByItem(item)` remain the lightweight invariant-inspection helpers.

## Cleanup
- No temporary diagnostics were added.

## Next Questions
- Whether a future runtime harness will reveal caller behavior that depends on current batch-path edge cases.
- Whether similar low-overhead adjustments should later be propagated to `Shop.lua`.
