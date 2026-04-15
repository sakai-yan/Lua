# Lessons

## Candidate Lessons
- 2026-03-21: When inspecting or patching Chinese Lua files from PowerShell, force `UTF8` on reads first; otherwise display-level mojibake can be mistaken for file corruption and lead to destructive follow-up edits.
- 2026-03-21: For long Lua files with many block comments, regex-style bulk rewrites are a high-risk repair tool; if structure is already unstable, a contract-driven rebuild plus smoke is safer than another text surgery pass.
- 2026-03-19: A Theme layer fits this UI framework best as config preprocessing owned by `Component`, not as a dependency of `Frame` or `Style`.
- 2026-03-19: Restricting Theme rules to explicit object-style syntax keeps the authoring layer clearer than array-style rule lists.
- 2026-03-19: After a cleanup that deletes docs or modules, old audit reports and old smoke scripts become part of the drift surface too; they must be revalidated like code.
- 2026-03-19: CSS-like syntax is not the same thing as browser-like development experience; compile-first layout helpers should be described as helpers, not as full parity.
- 2026-03-21: In Lua Theme authoring, use a plain string fast path like `"$token"` for the common case and reserve `Theme.ref(...)` for rare fallback scenarios to reduce allocation and parsing cost.
- 2026-03-17: When the runtime already has a fast absolute-position model, a CSS-inspired builder should usually compile into that model instead of recreating browser layout behavior.
- 2026-03-17: Promoting a new framework surface is incomplete until the default bootstrap and shipped demos point at it instead of the deprecated path.
- 2026-03-15: When a framework mixes handle-level and object-level APIs, the first audit question should be "what is the ownership contract?" before reviewing helper features.
- 2026-03-15: Static adoption counts are useful for separating "documented capability" from "real platform surface".
- 2026-03-15: For foundational modules with drift across multiple files, a clean rewrite of the contract-bearing file can be safer and faster than patch-by-patch repair.
- 2026-03-15: Once one value starts carrying more than one meaningful role, a single-string runtime tag becomes technical debt very quickly; keep a primary identity, but move membership checks into a real registry.
- 2026-03-16: When the project does not actually want type inheritance, a flat bitmask model is often better than a richer metadata registry even if both use bits internally.

## Bug Avoidance Candidates
- Avoid adding more APIs that silently accept both frame instances and raw handles without a normalization layer.
- Avoid exposing cache-backed getters as if they were authoritative runtime values.
- Avoid leaving destroy cleanup fragmented across unrelated helper APIs.

## Debug Lessons
- Repo-wide search counts were a fast way to prove that the advanced abstraction layer is still mostly dormant outside documentation.
- Cross-checking code, docs, and bootstrap surfaces produced higher-value findings than file-by-file review alone.
- `luac -p` is a cheap and effective validation pass after larger Lua refactors, especially when comments and encoding make text-based patching brittle.
- Cross-reading container, UI, and gameplay call sites was necessary to see that the `DataType` problem was not one bug but one missing abstraction shared by several subsystems.
- User feedback was necessary to distinguish "needs multiple custom roles" from "needs built-in hierarchy"; those are not the same thing.

## Repeated Patterns
- Naming drift shows up in multiple places: `disable_color` versus `disbale_color`, `child` versus `childs`, and handle-versus-frame parent assumptions.
- Performance-oriented caching repeatedly appears without an accompanying truth-model contract.

## Promote Next
- Promote the ownership-contract lesson into an active principle.
- Consider building a project-local UI contract lint tool if V1 or V1.5 implementation begins.
- Promote the "primary identity plus flat explicit bit combination" pattern into an active principle for future foundational registries.
