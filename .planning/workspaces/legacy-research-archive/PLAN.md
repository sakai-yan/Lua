# Execution Plan

## Planning Mode
- Profile: Quick
- Task type(s): research archive, tooling archive, workspace migration

## Project Context
- Context type: brownfield mixed archive
- Selected pattern: bounded archival migration

## Requirement Integration
- The migration requirement is to separate legacy root `.planning` memory by task without fabricating confidence about ambiguous historical boundaries.
- The archive route preserves those artifacts while making split-on-resume the future default.

## Technical Route Strategy
- Keep only ambiguous pre-task-scoped artifacts here.
- Keep active MapRepair and UI task memory in their own dedicated sibling workspaces.
- Treat this workspace as a provenance store, not as an active execution board.

## Workspace
- Project root: `Lua/`
- Planning container: `.planning/`
- Task workspace: `.planning/workspaces/legacy-research-archive/`
- Task slug: `legacy-research-archive`
- Project-specific tools directory: `.planning/workspaces/legacy-research-archive/tools/`
- Reports directory: `.planning/workspaces/legacy-research-archive/reports/`
- Dynamic memory and execution artifacts stay in this archive workspace, not in the shared skill folder.

## Knowledge Inputs
- Archived reports now stored in this workspace
- The active MapRepair and UI workspaces, which define what should no longer stay mixed here

## Assumptions
- The remaining artifacts do not carry enough trustworthy context to reconstruct exact old task bundles automatically.

## Completion Standard
- The archive is acceptable only if it no longer contaminates active workspaces and clearly signals split-on-resume.
- It is not acceptable to keep adding fresh mixed execution notes here.

## Audit / Debug Strategy
- No active debug loop is planned here.
- Validate only placement, scope, and future resume rules.

## Capability Routing Rules
- Required capabilities are written as stable names.
- Implementation is resolved at execution time.

## Phase 1

### Goal
- Preserve legacy research artifacts without leaving them mixed into active task workspaces.

### Inputs
- Pre-migration reports
- Pre-migration helper tools
- Pre-migration benchmark scratch files

### Outputs
- This archival workspace with clear reuse and split rules

### Dependencies
- Accurate separation of the active MapRepair and UI task workspaces

### Technical Route
- Hold only ambiguous historical artifacts here and move everything with a clear active task identity out.

### Detailed Implementation Approach
- Store reports in `reports/`, helper artifacts in `tools/`, and scratch files in `tmp/`.
- Document in `WORKSPACE.md`, `SESSION.md`, and `TASKS.md` that any resumed thread should be split into its own sibling workspace.

### Risks
- A future user may mistake this archive for an active mixed task unless the boundary is explicit.

### Requirement Alignment
- Preserves the user's requested redivision while avoiding fabricated task identity.

### Architecture Fit Review
- An explicit archive fits the new planning model better than leaving these artifacts in the root container or forcing them into active workspaces.

### Explicitly Unresolved Details
- Which archived lines, if any, will later deserve their own dedicated workspace slug.

### Diagnostic Hooks / Signals
- Folder placement itself is the main migration signal.

### Relevant Experience / Standards
- Prefer bounded archival storage over false confidence when task identity is unclear.

### Required Capabilities
- `task_resume_select`
- `session_update`

### Validation
- Confirm the root `.planning` container no longer carries mixed active-state files.
- Confirm this workspace contains only the ambiguous historical artifacts assigned to it.

### Expected Summary Updates
- Record that split-on-resume is now the default for these artifacts.

### Expected Tool / Report Updates
- Keep only archival artifacts here unless one thread is intentionally resumed.

## Replan Triggers
- A specific archived thread becomes active again.
- Enough new context appears to justify splitting a dedicated sibling workspace.

## Definition of Done
- Active work no longer shares this workspace.
- Archived artifacts remain discoverable.
- Future resume rules are explicit.
