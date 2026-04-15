# Task Workspace

## Task Identity
- Task label: MapRepair trigger editor compatibility
- Task slug: maprepair-trigger-editor-compatibility
- Matching rule: Reuse this workspace when a later request still targets MapRepair's `war3map.wtg/wct` editor-load compatibility, YDWE or `w3x2lni` trigger-data compatibility, or manual validation of the repaired real-map trigger outputs.
- Split rule: Create a sibling task workspace when the request pivots to a materially different MapRepair objective such as object-data fidelity, import preservation, packaging automation, or another repair surface with its own completion standard.

## Scope Snapshot
- Current normalized objective: Eliminate repaired-map trigger-load crashes by keeping reconstructed `war3map.wtg/wct` inside an editor-compatible GUI vocabulary and trigger-tree shape while preserving runtime behavior.
- Primary surfaces: `.tools/MapRepair`, canonical `.canon/YDWE` source/runtime validation, reports in this workspace, and rerun artifacts in this workspace `tmp/`.
- Explicit exclusions: Do not mix unrelated UI framework work, legacy runtime benchmarks, or generic Lua research into this workspace.

## Continuation Signals
- Reuse this workspace when: continuing the trigger editor compatibility slice, re-running manual validation against `current-rerun-*` artifacts, or extending the current hybrid GUI reconstruction route.
- Create a new sibling workspace when: the task adopts a different success criterion than trigger editor compatibility or the current task board would stop being a truthful continuation target.

## Workspace Paths
- Project root: `Lua/`
- Planning container: `.planning/`
- Task workspace: `.planning/workspaces/maprepair-trigger-editor-compatibility/`
- Project-specific tools directory: `.planning/workspaces/maprepair-trigger-editor-compatibility/tools/`
- Reports directory: `.planning/workspaces/maprepair-trigger-editor-compatibility/reports/`

## Notes
- This workspace owns the current planning state, MapRepair-specific reports, and trigger-compatibility rerun artifacts for this task only.
- Historical reports and reruns may still mention their original pre-migration `.planning/...` locations; use this workspace path as the authoritative location going forward.
