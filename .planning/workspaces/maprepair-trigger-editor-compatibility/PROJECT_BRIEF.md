# Project Brief

## Problem
- MapRepair's trigger reconstruction path has been narrowed to an editor-safer hybrid GUI route, but the remaining failure still has to be classified above or below the real YDWE open chain before another trigger rewrite is justified.

## Project Context
- Context type: brownfield implementation/debug
- This task continues a live compatibility-fix thread in the existing `.tools/MapRepair` codebase and depends on prior reruns, checker evidence, source audits, and canonical YDWE runtime validation from `.canon/YDWE`.

## Project-Local Workspace
- Project root: `Lua/`
- Planning container: `.planning/`
- Task workspace: `.planning/workspaces/maprepair-trigger-editor-compatibility/`
- Task slug: `maprepair-trigger-editor-compatibility`
- Project-specific tools directory: `.planning/workspaces/maprepair-trigger-editor-compatibility/tools/`
- Reports directory: `.planning/workspaces/maprepair-trigger-editor-compatibility/reports/`

## Goals
- Keep the trigger reconstruction route inside editor-compatible GUI vocabulary and tree shape.
- Preserve runtime behavior when full GUI recovery is still unsafe.
- Finish the migration to a task-scoped planning workspace without losing the current MapRepair continuation state.

## Normalized Requirements
- The workspace must now comply with the new task-scoped planning model.
- The active technical slice remains trigger editor compatibility, not a fresh object-data or packaging task.
- `.canon/YDWE` is now the authoritative YDWE runtime and source tree for this task; historical `.tools/YDWE` references are not trustworthy continuation inputs.
- The next proof step is a canon-backed open-chain audit on `current-rerun-v30`, followed by trigger-shape narrowing only if that audit proves the failure sits above the parse chain.

## Non-Goals
- Do not reopen unrelated UI framework work or legacy research here.
- Do not treat binary-checker success as sufficient proof that the editor-side crash is gone.
- Do not discard the detailed pre-migration planning context; keep it as report snapshots instead.

## Constraints
- We can launch the canon editor and archive `kkwe.log`, but we still cannot fully automate visible UI confirmation of the exact trigger row where the editor stops.
- The current route must stay compatible with the existing MapRepair architecture and smoke harness.
- Active execution memory needs to be concise and template-compliant, while older detailed notes remain preserved for reference.

## Existing Knowledge Inputs
- `.planning/workspaces/maprepair-trigger-editor-compatibility/reports/legacy-project-brief-root-2026-04-05.md`
- `.planning/workspaces/maprepair-trigger-editor-compatibility/reports/legacy-plan-root-2026-04-05.md`
- `.planning/workspaces/maprepair-trigger-editor-compatibility/reports/legacy-step-plan-root-2026-04-05.md`
- `.planning/workspaces/maprepair-trigger-editor-compatibility/reports/legacy-session-root-2026-04-05.md`
- `.planning/workspaces/maprepair-trigger-editor-compatibility/reports/legacy-project-summary-root-2026-04-05.md`
- `.planning/workspaces/maprepair-trigger-editor-compatibility/reports/wtg-gui-audit-2026-04-04.md`
- `.planning/workspaces/maprepair-trigger-editor-compatibility/reports/ydwe-war3mapj-to-gui-audit-2026-04-05.md`

## Audit / Debug Focus
- Confirm that `current-rerun-v30` passes the canon YDWE checker, `wtgloader`, `frontend_trg`, and `frontend_wtg` chain under `.canon/YDWE/source`.
- Determine whether the remaining failure still sits below TriggerData parsing or only above the editor-visible trigger panel.
- If the canon chain reaches `triggerdata` / `triggerstrings`, inspect the remaining early mixed-control-flow survivors in the already-agreed order instead of reopening broader reconstruction work.

## Stakeholders / Surface
- `.tools/MapRepair`
- `.canon/YDWE` runtime and `source/Development/...` source tree
- Repaired real-map outputs under this workspace `tmp/`

## Success Signals
- The active workspace is template-compliant and resumable under the new planning rules.
- The canon open-chain audit names one concrete failing layer instead of leaving the task at "still crashes".
- If the failure is above the parse chain, the next remaining trigger-shape surface is narrowed to a concrete early survivor bucket.

## Open Questions
- Does the newest rerun truly clear the trigger-load crash in the target editor?
- If not, are the remaining large sequential GUI survivors still too editor-hostile, or is another hidden trigger-data edge still present?
