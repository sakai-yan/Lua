# Lessons

## Candidate Lessons
- Fixed-slot storage in this codebase does not benefit from forcing in a general-purpose set layer when direct slot maps already provide the required membership and lookup behavior.
- Replacing a broken stub can be cleaner than preserving file history when the intended API is small and the existing surface is effectively unusable.

## Bug Avoidance Candidates
- Treat swap-into-empty as the main `first_free` danger path.
- Validate mutator inputs even in non-debug execution so invalid calls do not silently poison container state.

## Debug Lessons
- Repo-local Lua smoke scripts are enough to validate isolated library invariants before game-engine integration exists.

## Repeated Patterns
- The project playbook's direct-state guidance continues to map well outside Motion-only work.

## Promote Next
- Wait for another fixed-slot container task before promoting the "skip Set for slot containers" lesson to the project playbook.

