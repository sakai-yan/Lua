# Step Plan

## Current Step
- Name: Audit conclusion sync and Storage documentation pass
- Parent phase: Phase 1
- Why now: The audit conclusions are stable enough to codify, and the user explicitly asked for detailed Chinese function comments and usage guidance in `Storage.lua`.

## Step Objective
- `Storage.lua` exposes its real contract, event timing, and cost model clearly in Chinese comments, and the workspace / playbook capture the matching audit conclusions.

## Requirement Alignment
- Apply Charge-style project conventions to Storage.
- Judge whether Storage aligns with high-efficiency, low-consumption expectations.
- Add detailed Chinese function comments and copyable usage examples.

## Planned Technical Route
- Preserve runtime behavior.
- Document the API around the real invariants already present: fixed slot array, one-item-one-storage membership, post-mutation change notifications, and capacity-linear scan helpers.

## Framework Compatibility Review
- The route fits the current framework because it only annotates `Storage.lua` and planning memory.
- The main constraint is honesty: comments must not imply rollback support, pre-change events, or hot-path cost guarantees that the code does not provide.

## Detail Resolution Focus
- Decide which caveats belong in module-level docs versus per-method docs.
- Keep comments detailed enough for callers to use directly, but aligned with the actual code rather than imagined future behavior.

## Required Inputs
- `Code/Logic/Process/Item/Storage.lua`
- `Code/Logic/Process/Motion/Charge.lua`
- `Code/Logic/Process/Motion/Vertical.lua`
- `Code/Logic/Process/Motion/Bezier3.lua`
- `.planning/PROJECT_PLAYBOOK.md`
- `Code/FrameWork/Manager/Event.lua`
- `Code/Lib/Base/LinkedList.lua`

## Relevant Project Memory
- `.planning/PROJECT_PLAYBOOK.md`
- `.planning/workspaces/design-motion-vertical/PROJECT_SUMMARY.md`
- `.planning/workspaces/design-item-storage-system/PROJECT_SUMMARY.md`

## Standards / Bug Avoidance Applied
- Keep public entrypoints thin and contract-focused.
- Document scan/copy costs explicitly.
- Do not hide post-mutation event timing or listener short-circuit caveats.

## Debug / Inspection Plan
- Reconfirm event short-circuit semantics through `Event.execute` and `LinkedList.forEachExecute`.
- Reconfirm Storage parse validity through `luac -p`.
- The step is successful if the comments now tell callers what the code actually does, including cost-model caveats.

## Completion Standard
- Acceptable completion: `Storage.lua` has a module header, method-level Chinese docs, usage examples, and explicit event / complexity notes.
- Not acceptable: vague “to be optimized later” comments or comments copied from Motion files without adapting them to Storage semantics.

## Temporary Detailed Actions
- Update the project playbook with the promoted project-wide style rules.
- Add detailed Chinese documentation to `Storage.lua`.
- Sync workspace summary / session / tasks state.
- Parse-check `Storage.lua`.

## Validation
- `.tools/lua53/bin/luac.exe -p Code/Logic/Process/Item/Storage.lua`

## Replan / Abort Conditions
- If a comment-only pass reveals a behavior bug that must be fixed immediately.

## Summary Updates Expected
- Record the final audit conclusions and the documentation-upgrade result in `PROJECT_SUMMARY.md`.
- Promote the Charge-style library-structure rules and scan-cost documentation rule into `.planning/PROJECT_PLAYBOOK.md`.
