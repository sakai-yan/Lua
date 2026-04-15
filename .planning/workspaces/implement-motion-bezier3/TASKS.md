# Tasks

## Active
- None.

## Ready
- Future refinement only if real call sites need migration help, runtime feel tuning, or extra Bezier convenience APIs.

## Blocked
- None.

## Done
- Bootstrapped the `implement-motion-bezier3` planning workspace and captured the initial route.
- Implemented `Code/Logic/Process/Motion/Bezier3.lua` with fixed-endpoint and lock-on-target cubic Bezier motion.
- Added setup-time coefficient caching, optional tangent-facing, and auto-generated control points with optional height offsets.
- Validated `Bezier3.lua` with the repo-local Lua 5.3 toolchain.
- Refined `Bezier3.lua` into a lighter `Charge.lua` / `Surround.lua`-style structure and added Chinese usage documentation.
- Flattened the Bezier config contract to scalar fields such as `end_x/end_y/end_z` and removed point-table compatibility.
- Aligned the Bezier field-list comments in `Code/Logic/Process/Motion/Entry.lua` with the flattened API.
- Re-validated `Bezier3.lua` and `Entry.lua` with the repo-local Lua 5.3 toolchain after the scalar-field refactor.
- Compared the user's latest Bezier3 optimization against the earlier design route and sibling motion modules.
- Wrote `doc/Bezier3代码风格总结-2026-04-10.md` to capture the preferred style in a durable document.
- Added `.planning/PROJECT_PLAYBOOK.md` to preserve the cross-task reusable motion leaf-module style guidance.
