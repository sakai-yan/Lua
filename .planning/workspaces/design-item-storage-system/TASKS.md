# Tasks

## Active
- Summarize the implemented storage API and the discovered sibling-library issues for the user.

## Ready
- If the user later allows broader edits, wire `Logic.Process.Item.Storage` into the startup require chain.
- If future requirements demand it, extend the core with stacking or storage-specific slot rules.

## Blocked
- Runtime activation from startup is blocked by the current "do not modify other libraries" constraint.

## Done
- Audited `Item`, `Process.Item`, `Event`, and base collection libraries for storage-fit constraints.
- Implemented `War3/map/Logic/Process/Item/Storage.lua`.
- Validated `Storage.lua` with `.tools/lua53/bin/luac.exe -p`.
- Recorded key route and risk notes in the planning workspace.
