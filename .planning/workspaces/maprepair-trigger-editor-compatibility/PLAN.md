# Execution Plan

## Planning Mode
- Profile: Standard
- Task type(s): bugfix, compatibility, audit

## Project Context
- Context type: brownfield
- Selected pattern: debug-first implementation with manual acceptance handoff

## Requirement Integration
- The planning workspace must now follow the task-scoped `.planning/workspaces/<task-slug>/` model.
- The active requirement remains editor-safe `war3map.wtg/wct` output for the repaired real map.
- `.canon/YDWE` is now the authoritative YDWE runtime and source baseline for open-chain validation.
- Final acceptance still depends on manual editor validation, but the current execution slice must first classify the remaining failure against the canon open chain instead of assuming another trigger rewrite is warranted.

## Technical Route Strategy
- Keep the current hybrid GUI reconstruction route.
- Preserve the narrowed rule that structured GUI is emitted only for base-compatible metadata or map-local embedded GUI extension metadata.
- Preserve the fallback layers that collapse risky pseudo-GUI and eventless survivors back to whole-trigger custom-text.
- Treat the newest rerun as the current canon-audit target and use `.canon/YDWE` checker, `wtgloader`, `frontend_trg`, `frontend_wtg`, and editor-log evidence before widening the code slice again.

## Workspace
- Project root: `Lua/`
- Planning container: `.planning/`
- Task workspace: `.planning/workspaces/maprepair-trigger-editor-compatibility/`
- Task slug: `maprepair-trigger-editor-compatibility`
- Project-specific tools directory: `.planning/workspaces/maprepair-trigger-editor-compatibility/tools/`
- Reports directory: `.planning/workspaces/maprepair-trigger-editor-compatibility/reports/`
- Dynamic memory and execution artifacts stay in the matching task workspace, not in the shared skill folder.

## Knowledge Inputs
- `PROJECT_SUMMARY.md`
- `TASKS.md`
- `LESSONS.md`
- `.planning/workspaces/maprepair-trigger-editor-compatibility/reports/legacy-plan-root-2026-04-05.md`
- `.planning/workspaces/maprepair-trigger-editor-compatibility/reports/legacy-session-root-2026-04-05.md`
- `.planning/workspaces/maprepair-trigger-editor-compatibility/reports/legacy-project-summary-root-2026-04-05.md`

## Assumptions
- The code-side trigger reconstruction route is currently in its safest known state.
- The most valuable next information comes from manual editor validation, not from another wide speculative refactor.

## Completion Standard
- The active planning state is template-compliant and resumable.
- The current manual validation target is explicit.
- If validation fails, the next implementation slice is narrowed before coding resumes.

## Audit / Debug Strategy
- Keep internal validator, original checker, and workspace-local inspector as independent structural gates.
- Use canon open-chain validation as the current classification gate, then use manual editor validation as the final visible-UI acceptance gate.
- If the canon chain reaches `triggerdata` / `triggerstrings`, inspect remaining large sequential GUI survivors and helper-registration evidence before broadening scope.

## Capability Routing Rules
- Required capabilities are written as stable names.
- Implementation is resolved at execution time.

## Phase 1

### Goal
- Preserve a clean, resumable planning state while keeping the newest editor-validation target explicit.

### Inputs
- Latest rerun artifacts under `tmp/current-rerun-v12/`
- Latest published package `MapRepair-win-x64-self-contained-20260405-1055.zip`
- Legacy root-format planning snapshots in `reports/`

### Outputs
- Template-compliant planning files
- Clear continuation target for manual validation or the next narrowed fix slice

### Dependencies
- Existing MapRepair code and rerun artifacts stay intact

### Technical Route
- Keep the current narrowed reconstruction route and treat manual validation as the next external gate.

### Detailed Implementation Approach
- Preserve old root-format planning notes as report snapshots.
- Keep current top-level workspace files concise, authoritative, and aligned with the new skill rules.
- Use `TASKS.md` and `STEP_PLAN.md` to drive the next concrete slice.

### Risks
- Manual validation may still fail despite checker success.
- Older rerun and report artifacts may still mention pre-migration root paths.

### Requirement Alignment
- Satisfies the user's workspace redivision request.
- Keeps the active MapRepair trigger-compatibility task ready for future continuation.

### Architecture Fit Review
- This route fits the already-built MapRepair and checker workflow better than reopening a speculative reconstruction rewrite before manual proof.

### Explicitly Unresolved Details
- Whether the newest rerun fully clears the editor crash
- Which remaining trigger survivors should be audited first if it does not

### Diagnostic Hooks / Signals
- `maprepair_wtg_inspect`
- `maprepair_sample_compare`
- Internal validator and original YDWE checker

### Relevant Experience / Standards
- Prefer validator-backed compatibility gates.
- Prefer conservative fallback over pseudo-GUI that stops looking editor-readable.

### Required Capabilities
- `execution_takeover`
- `task_resume_select`
- `planned_route_framework_review`
- `session_update`

### Validation
- Validate bundle structure with `validate_planning_bundle.py`
- Preserve current rerun/package references
- Keep manual validation as the next explicit acceptance gate

### Expected Summary Updates
- Record that the workspace is now task-scoped and that legacy root-format notes live under `reports/`

### Expected Tool / Report Updates
- No new tool is required for the migration itself.
- Keep legacy root-format planning files as report snapshots only.

## Replan Triggers
- Manual editor validation still reproduces the crash
- The latest rerun/package ceases to be the authoritative validation target
- Another MapRepair surface becomes the dominant task

## Definition of Done
- The active workspace validates under the new planning rules.
- Manual validation remains the first actionable continuation target.
- Historical planning context is preserved without polluting the new top-level files.
