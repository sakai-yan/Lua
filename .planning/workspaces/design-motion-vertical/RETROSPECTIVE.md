# Retrospective

## Planned vs Actual
- The original plan targeted a single vertical solver, but the user expanded the requirement mid-task.
- The task still stayed in one workspace because the primary surface and subsystem did not change; only the completion slice widened.

## What Worked
- Reusing the same workspace and updating the plan avoided mixing this expansion into a new unrelated history.
- Grouping the implementation by runtime model kept the file readable.
- The repo-local Lua 5.3 validation loop remained enough for static correctness checks.

## What Hurt
- The old J reference did not provide much guidance beyond straight downward motion, so the broader family needed local design judgment.

## Principle Updates
- Captured the runtime-model-first rule for motion-family expansion.
- Captured the rule that thin wrappers must fully reuse an existing solver.

## Tooling Updates
- No new tool was needed; the existing Lua 5.3 toolchain remained sufficient.

## Debugging Improvements
- When a leaf module expands beyond its original route, refresh the task plan immediately instead of treating the change as a note-only tweak.

## Summary Updates
- `PROJECT_SUMMARY.md` now holds the broader family route, validation status, and open extension risks.

## Next-Time Changes
- For future motion-family expansions, decide the runtime-model split first; it prevents late API bloat.
