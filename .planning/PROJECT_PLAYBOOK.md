# Project Playbook

## Scope
- This playbook captures cross-task guidance for shared runtime and library work under `Code/`.
- Motion-library work under `Code/Logic/Process/Motion/` is still the clearest style baseline, but once a pattern proves stable it should be promoted here as a project-wide standard.
- Task-local implementation details stay in each task workspace; only reusable project-wide guidance belongs here.
- Unless a real caller contract, subsystem boundary, or compatibility constraint requires otherwise, later project work should treat the direct/flat/setup-heavy style promoted here as the default baseline in general cases.

## Shared Standards and Principles
- Localize hot-path dependencies, math helpers, constants, and frequently used methods at the top of the file.
- Prefer flat scalar config fields over grouped coordinate tables unless a real caller contract requires nesting.
- Store runtime or derived state directly on `config` / `motion` / owned instance tables when ownership is obvious.
- Prefer explicit ownership and direct data flow over adapter layers, temporary wrapper objects, or "completeness" abstractions added only for structure.
- Do more normalization, validation, and derived-value caching during setup so repeated execution paths stay short, direct, and numeric.
- Separate `prepare / resolve` helpers from `apply / mutate` helpers so public entrypoints remain thin orchestration layers.
- Only extract helpers for logic that is both genuinely shared and high-value; keep variant-specific setup close to the variant.
- Trust established internal contracts on the hot path; avoid repeated defensive checks once setup has validated the required inputs.
- Prefer O(1) core mutations for reusable runtime libraries; if a public API is O(capacity) or allocates, document that cost explicitly.
- Reuse existing project capabilities before inventing thin local helper utilities.
- Keep public comments focused on contract, field semantics, cost model, caveats, and copyable usage examples.
- Keep internal comments selective: explain the design reason or non-obvious math/flow, not every obvious line.
- Avoid compatibility aliases or duplicate names unless an actual caller needs them.
- If a motion only needs to change z and the entity layer already exposes a supported `actor.z` setter, prefer writing `actor.z` directly over wrapping another local z-only helper.
- Keep motion APIs compact; do not add aliases or compatibility wrappers without an actual caller need.
- When a module family grows, group by runtime model or core abstraction first; add thin wrappers only when they fully reuse an existing implementation.
- Separate stable structural style rules from module-specific behavior-contract choices; do not promote a one-off behavior edit into a project-wide rule without repeated evidence.

## Repeated Bug Patterns and Red Flags
- Treat stale comments in shared entry files as documentation only until the runtime behavior is confirmed in code.
- Do not assume a legacy J API shape is a mandatory modern Lua contract.
- Avoid non-terminating motions created by missing destinations or zero-progress configurations.
- Avoid widening a leaf-module task into shared Motion runtime edits unless the framework truly blocks the requested behavior.
- Do not let a post-mutation event pretend to be a veto hook; if listeners can short-circuit, document whether state has already changed and whether rollback exists.

## Shared Route and Framework Notes
- `Motion.Entry` defines the common lifecycle (`Motion.set`, `Motion.execute`, `move_func`), but leaf modules should own their own setup and move-method details.
- Recent `Charge`, `Vertical`, and `Bezier3` work confirmed that a more direct structure is preferred over extra adapter layers added only for abstract "completeness".
- When older source files conflict with newer explicit summaries or playbook promotions, prefer the newer confirmed guidance instead of copying the older file mechanically.
- When designing one-axis or bounded-direction solvers, derive directional semantics during setup when possible so the tick path does not keep branching on sign or mode.
- Storage-like libraries can borrow the same style even when they are not tick-based: preprocess invariants early, keep mutation helpers small, and document the cost model of scan/copy APIs.
- When a motion leaf module expands into a small family, group it by runtime model first and add thin wrappers only when they fully reuse an existing solver.

## Shared Tooling Guidance
- Prefer `rg` for repo search and direct source inspection for sibling-module comparisons.
- Prefer the repo-local Lua 5.3 toolchain under `.tools/lua53/bin` for fast syntax and parse validation of Lua modules.
- Use `.canon/` as read-only reference input only; do not treat it as a live editing surface during normal execution.

## Cross-Task Lessons Pending Promotion
- If the setup-time direction-normalization pattern appears again in another runtime library, promote it from task-local lesson to a stronger project principle.
- If more container-like libraries appear, consider standardizing how event timing and scan-cost caveats are documented.

## Update Log
- 2026-04-10: Rewrote the project playbook into the current planning-os structure and preserved the existing motion-module style guidance in a cleaner cross-task form.
- 2026-04-10: Added the runtime-model grouping rule for future motion-family expansions.
- 2026-04-11: Added the direct `actor.z` rule for z-only motion updates when the entity setter already exists.
- 2026-04-11: Promoted Charge/Vertical/Bezier3-style setup-time normalization, cost-model documentation, and helper layering into project-wide library guidance.
- 2026-04-11: Strengthened the motion-derived guidance into the default project-wide coding-style baseline for general future work, with explicit conflict-resolution and style-vs-behavior rules.
