# Task Workspace

## Task Identity
- Task label: UI framework contract audit
- Task slug: ui-framework-contract-audit
- Matching rule: Reuse this workspace when the request continues the March 2026 UI framework audit, contract cleanup, theme-authoring guidance, or V1/V1.5 planning that is still anchored to these findings.
- Split rule: Create a sibling task workspace when the request becomes a separate feature-delivery slice whose success no longer centers on this audit memory.

## Scope Snapshot
- Current normalized objective: Preserve the historical UI framework audit memory so later work can resume from the right ownership, lifecycle, theme-authoring, and bootstrap-surface conclusions.
- Primary surfaces: `Code/Core/UI`, UI audit reports in this workspace, and the preserved lessons, principles, backlog, and retrospective from the audit round.
- Explicit exclusions: Do not mix active MapRepair trigger work or unrelated legacy research spikes into this workspace.

## Continuation Signals
- Reuse this workspace when: resuming the same UI audit thread, refreshing its conclusions against current code, or planning follow-up work that still depends on these contract findings.
- Create a new sibling workspace when: a future UI task has a different acceptance slice than this audit memory and would make the historical task board misleading.

## Workspace Paths
- Project root: `Lua/`
- Planning container: `.planning/`
- Task workspace: `.planning/workspaces/ui-framework-contract-audit/`
- Project-specific tools directory: `.planning/workspaces/ui-framework-contract-audit/tools/`
- Reports directory: `.planning/workspaces/ui-framework-contract-audit/reports/`

## Notes
- This workspace is currently archival: it exists to keep the UI audit recoverable as its own task instead of leaving it mixed into active MapRepair state.
- If UI implementation work resumes, refresh the brief and plan against the current repo before treating March 2026 conclusions as current truth.
