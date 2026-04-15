# Lessons

## Candidate Lessons
- When a motion leaf module expands, the cleanest scaling rule is to add runtime models, not just names.
- A z-only arc solver can stay very small if it reuses normalized progress instead of inventing a bespoke state machine.

## Bug Avoidance Candidates
- Thin wrappers should only normalize inputs and delegate immediately to the real solver.
- Finite oscillation needs a clear landing rule at the end, or future callers will get surprising z snaps.

## Debug Lessons
- Local motion design docs are useful for clarifying conceptual boundaries even when they do not contain a final API.
- Comparing against sibling runtime-model shapes is a faster filter than searching for legacy name parity.

## Repeated Patterns
- Flat scalar config plus runtime state on `config` keeps paying off across motion leaf modules.
- Setup-time normalization remains the easiest way to keep per-tick logic compact.

## Promote Next
- The runtime-model grouping rule is a good candidate for future promotion if another motion family expansion follows the same path.
