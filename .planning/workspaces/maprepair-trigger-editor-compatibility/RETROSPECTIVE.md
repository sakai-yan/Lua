# Retrospective

## Planned vs Actual
- Planned: keep MapRepair's trigger reconstruction validator-compatible and make the repaired real-map output editor-readable.
- Actual: the slice converged on a narrower hybrid GUI route plus a series of pseudo-GUI fallback refinements; the code goals landed, but final editor proof is still blocked on manual validation.

## What Worked
- Treating YDWE source and the original checker as separate evidence surfaces prevented false inferences from `war3map.j`.
- Re-running the real map after each rule refinement caught extension-node regressions quickly.
- Small project-local tools in this workspace reduced repeated forensic work.

## What Hurt
- Historical rerun artifacts and publish builds made it easy to confuse latest source behavior with stale outputs.
- Checker-passing output could still be editor-hostile, so binary validation alone was not enough.
- Manual editor proof is still outside the current environment.

## Principle Updates
- This workspace now treats validator-backed compatibility gates and conservative fallback as default rules.

## Tooling Updates
- `maprepair_archive_probe`, `maprepair_wtg_inspect`, and `maprepair_sample_compare` became the primary forensic helpers for this slice.

## Debugging Improvements
- Keep comparing GUI vocabulary drift, extension-node counts, and helper-registration evidence together.
- Keep separating environment/path failures from actual trigger-data corruption.

## Summary Updates
- The summary should continue treating trigger-tree shape and GUI vocabulary as the primary risk surface.

## Next-Time Changes
- Start the next slice from manual editor validation of the newest rerun or package before reopening reconstruction code.
- If the crash persists, inspect the remaining large sequential GUI survivors and helper-registered init patterns first.
