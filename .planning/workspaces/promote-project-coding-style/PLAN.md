# Execution Plan

## Planning Mode
- Profile: Quick
- Task type(s): standards promotion, documentation, project-memory sync

## Project Context
- Context type: brownfield multi-library project with an existing planning container
- Selected pattern: inspect prior style evidence, extract stable cross-task rules, sync them into project memory and a durable document

## Requirement Integration
- The user explicitly said the style had already been summarized once, so the route starts from the historical summary instead of inventing a new standard from scratch.
- The user explicitly wants the result promoted to the whole project, so this task widens from Bezier-only memory to project-wide guidance.
- The user wants later project design to generally follow this style, so the route must separate stable default rules from optional behavior-specific choices.

## Technical Route Strategy
- Treat the 2026-04-10 Bezier3 style summary as the clearest historical statement of intent.
- Use `Charge.lua`, `Surround.lua`, `Vertical.lua`, and legacy `EffectSportDown.j` as concrete evidence for recurring structural patterns and lineage.
- Cross-check those findings against existing project-memory promotions in `.planning/PROJECT_PLAYBOOK.md` and the sibling task summaries.
- Produce a new project-facing summary document that states the default baseline, conflict-resolution rule, and non-mechanical exceptions.
- Update `.planning/PROJECT_PLAYBOOK.md` so the project memory matches the new stronger project-wide framing.

## Workspace
- Project root: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua
- Planning container: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Project playbook: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/promote-project-coding-style
- Task slug: promote-project-coding-style
- Task-local tools directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/promote-project-coding-style/tools
- Project toolset directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical reference directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon
- Reports directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/promote-project-coding-style/reports

## Knowledge Inputs
- Historical summary: `doc/Bezier3代码风格总结-2026-04-10.md`
- Cross-task project memory: `.planning/PROJECT_PLAYBOOK.md`
- Supporting task summaries: `implement-motion-bezier3`, `design-motion-vertical`, `audit-storage-style-efficiency`
- Source evidence: `Charge.lua`, `Surround.lua`, `Bezier3.lua`, `Vertical.lua`, and legacy `EffectSportDown.j`

## Assumptions
- The strongest current style signal comes from the latest explicitly summarized motion-library work, not from every older source file equally.
- Future tasks benefit more from a crisp default rule plus explicit exception guidance than from an overly broad list of file-specific quirks.

## Completion Standard
- Complete delivery means the project now has a durable project-wide style summary, the playbook reflects that stronger default baseline, and the task workspace records the reasoning clearly enough for later reuse.
- Not acceptable: leaving the result trapped in chat, treating all old implementation details as mandatory style rules, or silently changing production behavior.

## Audit / Debug Strategy
- Inspect the historical summary and concrete source patterns directly.
- Focus on stable recurring structure: data shape, ownership, helper boundaries, hot-path design, comment style, API surface, and cost-model communication.
- Treat module-specific behavior switches as non-style unless they clearly recur as a structural rule.

## Phase 1

### Goal
- The project-wide style baseline is documented, promoted into project memory, and grounded in existing local evidence.

### Inputs
- Existing style summary and playbook
- Motion-library source files
- Sibling task summaries

### Outputs
- `doc/项目代码风格总结-2026-04-11.md`
- Updated `.planning/PROJECT_PLAYBOOK.md`
- Current task workspace artifacts

### Dependencies
- Evidence review must finish before the style is written.

### Technical Route
- Extract the stable style rules.
- Group them into project-wide defaults, motion-derived but broadly reusable patterns, and non-mechanical exception notes.
- Sync the result into both public-facing and planning-memory layers.

### Detailed Implementation Approach
- Add a dedicated task workspace manually because the planning bootstrap script is unavailable in this environment without an installed Python interpreter.
- Write the project summary document in Chinese so it is directly reusable in later project discussion.
- Keep the playbook in concise cross-task form while the doc carries the fuller explanation.

### Risks
- Overfitting to one module's behavior contract instead of a true style rule.
- Treating older, partially outdated files as equally authoritative when newer explicit summaries already resolved the direction.

### Requirement Alignment
- Satisfies the user's request to recover the previously summarized style and promote it to a project-wide default.

### Architecture Fit Review
- This route fits the current planning-os memory model: a concise playbook for cross-task rules plus a fuller task/public document for the reasoning.
- No runtime framework changes are required because the request is about style guidance, not behavior.

### Explicitly Unresolved Details
- None significant. Future concrete tasks may still justify exceptions when a real contract requires them.

### Diagnostic Hooks / Signals
- Direct source comparison and planning-memory sync are sufficient.

### Relevant Experience / Standards
- Reuse the existing motion-style promotions already present in `.planning/PROJECT_PLAYBOOK.md`.
- Reuse the "style vs behavior contract" distinction established by the Bezier3 summary.

### Required Capabilities
- `repo_audit`
- `project_memory_sync`
- `documentation_write`
- `route_detail_design`

### Validation
- Manual source review of the updated markdown artifacts.
- Static check that the referenced paths and rules match existing local evidence.

### Expected Summary Updates
- Record the project-wide baseline, conflict-resolution rule, and the promotion date.

### Expected Tool / Report Updates
- No task-local tools needed.
- No project tool changes needed.
- No `.canon/` reference changes needed.
- No extra reports needed beyond the markdown artifacts.

## Replan Triggers
- Discovering a stronger pre-existing project-wide style artifact that contradicts the motion-derived baseline.
- Discovering that the user intended a repository-wide automatic refactor instead of a standards/documentation promotion task.

## Definition of Done
- The project-wide coding-style baseline is documented, promoted into project memory, and ready to guide later work in this repository.
