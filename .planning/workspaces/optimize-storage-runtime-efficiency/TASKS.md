# Tasks

## Active
- No active work remains inside this turn after validation and memory sync.

## Ready
- If the user wants deeper assurance, add a targeted runtime/reentrancy harness for `Storage`.
- If the user wants broader consistency, audit whether `Shop.lua` should receive the same style-aligned flattening.

## Blocked
- Full in-engine behavioral verification is blocked by the absence of a ready-made runtime test harness in this task.

## Done
- Rebased the task on `doc/椤圭洰浠ｇ爜椋庢牸鎬荤粨-2026-04-11.md` and the project playbook after the user clarified the authoritative style source.
- Reanalyzed `Storage.lua` from source instead of inheriting old audit conclusions.
- Replaced the earlier helper-tightening route with a flatter route after the user rejected `Item` mounting and thin helper wrappers.
- Rewrote `Storage.lua` to keep the slot-array model while removing the `Class.static(Item, ...)` mount block.
- Removed thin helper layers such as `get_slots`, `assert_storage`, `assert_item`, and the extra no-argument free-slot getter helper.
- Kept direct `first_free` fast paths, lower-overhead `forEach` / `toTable`, and live-state-safe `clear` behavior.
- Updated the module comments/examples to use direct `Storage` entrypoints.
- Ran `.tools/lua53/bin/luac.exe -p Code/Logic/Process/Item/Storage.lua` successfully.
