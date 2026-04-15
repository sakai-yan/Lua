# Project Brief

## Problem
- The old root `.planning` workspace mixed several small research and tooling artifacts whose original task boundaries cannot now be recovered reliably.

## Project Context
- Context type: brownfield mixed archive
- This migration task is about preserving provenance without contaminating active task workspaces with ambiguous historical state.

## Project-Local Workspace
- Project root: `Lua/`
- Planning container: `.planning/`
- Task workspace: `.planning/workspaces/legacy-research-archive/`
- Task slug: `legacy-research-archive`
- Project-specific tools directory: `.planning/workspaces/legacy-research-archive/tools/`
- Reports directory: `.planning/workspaces/legacy-research-archive/reports/`

## Goals
- Keep pre-migration research artifacts recoverable.
- Avoid mixing these artifacts into active MapRepair or UI planning state.
- Make split-on-resume the default rule for any thread that becomes active again.

## Normalized Requirements
- The user asked to reorganize the project's planning workspace according to the new task-scoped model.
- Because the remaining artifacts do not expose safe, precise task boundaries, this archive is the bounded fallback instead of inventing false task histories.

## Non-Goals
- Do not pretend these artifacts still form one active task.
- Do not add new implementation work to this archive workspace.

## Constraints
- Preserve the original reports, helper files, and benchmark scratch artifacts.
- Keep the migration reversible in the sense that a future resume can split a specific thread into its own sibling workspace.

## Existing Knowledge Inputs
- Reports currently stored in this workspace `reports/`
- Helper artifacts in `tools/`
- Benchmark scratch files in `tmp/`

## Audit / Debug Focus
- N/A for active debugging; this workspace is archival.

## Stakeholders / Surface
- Project-local planning memory hygiene
- Future resume of old point, packer, benchmark, or xlik-related research

## Success Signals
- Active task workspaces are clean.
- Archived artifacts remain discoverable.
- Future resume decisions can create dedicated sibling workspaces instead of reusing this archive blindly.

## Open Questions
- If one archived line resumes, what dedicated task slug should be created for it?
