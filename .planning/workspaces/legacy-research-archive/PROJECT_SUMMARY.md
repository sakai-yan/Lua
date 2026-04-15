# Project Summary

## Current Mission
- Preserve ambiguous pre-migration research artifacts without polluting active task workspaces.

## Context Snapshot
- Task label: Legacy research archive
- Task slug: legacy-research-archive
- Task type(s): research archive, tooling archive
- Project context: brownfield mixed archive
- Selected pattern: split-on-resume archival storage
- Planning container: `.planning/`
- Task workspace: `.planning/workspaces/legacy-research-archive/`

## Planned Technical Route Baseline
- Keep this workspace bounded.
- Do not add fresh mixed implementation state here.
- If any archived thread resumes, move it into a new dedicated sibling workspace.

## Inherited Standards and Principles
- Favor honest archival boundaries over fabricated detailed task history.

## Bug Avoidance and Red Flags
- Do not mistake provenance storage for an active plan.
- Do not resume mixed work from this archive without first carving out a dedicated workspace.

## Debug Signals and Inspection Hooks
- The authoritative signals here are folder placement, report filenames, and preserved helper artifacts.

## Reusable Experience and Lessons
- Filenames and artifact placement can be more trustworthy than partial legacy planning prose when reconstructing old task identity.

## Active Improvements
- The `.planning` root is now cleanly task-scoped, with this workspace acting as the bounded fallback for ambiguous history.

## Route Review and Framework Compatibility Notes
- An explicit archive fits the new planning model better than forcing unrelated research into active workspaces.

## Tooling Guidance
- `packer_smoke` and `effectmotion_init_bench.lua` are preserved here as historical helpers only.

## Recent Retrospective Signals
- If one of these research lines matters again, split it immediately instead of adding new mixed notes here.

## Open Risks and Watch Items
- Some archived artifacts still contain original pre-migration path text; treat them as provenance snapshots, not freshly curated instructions.

## Update Log
- 2026-04-05: Created this archive workspace during the `.planning` migration.
