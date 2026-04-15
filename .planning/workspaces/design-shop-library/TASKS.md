# Tasks

## Active
- None. The initial `Shop.lua` implementation slice is complete and validated statically.

## Ready
- Integrate `Trade.lua` with `Shop.recordSaleBySeller(...)` when that follow-up is requested.
- Run an in-engine smoke test for scripted item sale, scripted unit hire, and external sale recording.
- Decide whether `Shop.lua` should be auto-loaded during startup or kept as an explicit require.

## Blocked
- Native/runtime verification is blocked until a follow-up execution slice or test harness is requested.

## Done
- Implemented `Code/Logic/System/Shop.lua` as an upper-layer slot-based shop runtime.
- Added active scripted sale support via `sell(...)`.
- Added future `Trade` sync seams via `recordSale(...)` and `recordSaleBySeller(...)`.
- Added `Shop_Change` event hooks and O(1) listing/lookup helpers.
- Validated syntax with the repo-local Lua 5.3 `luac`.
