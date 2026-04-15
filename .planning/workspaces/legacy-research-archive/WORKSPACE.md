# Task Workspace

## Task Identity
- Task label: Legacy research archive
- Task slug: legacy-research-archive
- Matching rule: Reuse this workspace only for migration, triage, or lookup of pre-task-scoped artifacts whose original task boundaries cannot now be reconstructed safely.
- Split rule: If any archived line of work becomes active again, create a dedicated sibling workspace for that task and move only its relevant artifacts out of this archive.

## Scope Snapshot
- Current normalized objective: Preserve pre-migration research artifacts that are clearly not part of the active MapRepair or UI audit workspaces, without inventing false detailed task histories.
- Primary surfaces: archived reports in this workspace `reports/`, small helper artifacts in this workspace `tools/`, and benchmark scratch files in this workspace `tmp/`.
- Explicit exclusions: Do not treat this workspace as an active mixed task, and do not add new implementation work here.

## Continuation Signals
- Reuse this workspace when: performing archival triage or recovering provenance for one of the pre-migration research artifacts stored here.
- Create a new sibling workspace when: a specific archived research thread resumes and needs its own plan, task board, and completion standard.

## Workspace Paths
- Project root: `Lua/`
- Planning container: `.planning/`
- Task workspace: `.planning/workspaces/legacy-research-archive/`
- Project-specific tools directory: `.planning/workspaces/legacy-research-archive/tools/`
- Reports directory: `.planning/workspaces/legacy-research-archive/reports/`

## Notes
- This workspace is an explicit archival holding space for legacy artifacts whose exact task identity is no longer recoverable with confidence.
- The default future action is split-on-resume, not continued mixed execution here.
