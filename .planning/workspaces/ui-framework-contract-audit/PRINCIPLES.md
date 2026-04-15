# Principles

## Active Principles
- Prefer one explicit ownership contract for UI trees. If compatibility requires supporting more than one input form, put the conversion behind an adapter instead of letting every module guess.
- Treat `destroy()` as the single authoritative teardown boundary for framework-owned runtime state.
- Never present cache-backed getters as runtime truth unless the cache invalidation and synchronization rules are explicit and enforced.
- In performance-sensitive Lua foundations, keep a deterministic primary identity for compatibility, but model multi-role custom types through explicit bit combinations rather than hidden string-type relationships.

## Deprecated Principles
- None yet.
