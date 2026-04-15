# Execution Plan

## Planning Mode
- Profile: Quick
- Task type(s): mixed (`migration`, `tooling`)

## Project Context
- Context type: brownfield
- Selected pattern: `migration_cutover`

## Requirement Integration
- Active user requirements: publish the current local project to a remote Git repo, use Git identity `sakai / yanmeng5v1@qq.com`, and finish the upload flow rather than only describing it.
- Integration into the route: first capture the missing remote target, then sanitize upload scope, then commit and push. Validation must include both repository boundary checks and remote push success.

## Technical Route Strategy
- Approved route:
  1. Lock in local Git identity for this repo.
  2. Resolve the target remote repository URL.
  3. Finalize the publish boundary by excluding embedded VCS metadata, temp workspaces, and any oversized generated artifacts that should not be in the main repo, or route those artifacts through LFS if the user explicitly wants them kept.
  4. Refresh staging to match the agreed boundary.
  5. Create the initial commit on the local branch.
  6. Add the remote and push the branch.
- Fixed decisions before execution: no force-push without explicit user approval; do not publish nested `.git` directories as ordinary content; do not ignore large generated outputs accidentally.
- Intentionally open details: the exact remote URL, whether the target host is GitHub/Gitee/etc., and whether large generated publish outputs should be excluded or tracked with LFS.
- Framework review: each execution step must be checked against the actual repo size, current staged boundary, and the remote host's push constraints before moving to the next step.

## Workspace
- Project root: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua
- Planning container: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Project playbook: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/publish-project-to-git-remote
- Task slug: publish-project-to-git-remote
- Task-local tools directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/publish-project-to-git-remote/tools
- Project toolset directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical reference directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon
- Reports directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/publish-project-to-git-remote/reports
- Dynamic memory and execution artifacts stay in the matching task workspace, not in the shared skill folder.

## Knowledge Inputs
- Inputs used: current repo inspection, `PROJECT_PLAYBOOK.md`, current `.git/config`, top-level size scan, and large-file scan.
- No `.canon` reference materially changes this publishing route.

## Assumptions
- The user wants a safe first publish, not an accidental mirror of nested repos and temp artifacts.
- The target remote can be reached over HTTPS with the machine's existing credential setup once the URL is known.
- The current local branch `main` is an acceptable initial push target unless the remote dictates otherwise.

## Completion Standard
- Complete delivery means the repo has the requested Git identity, the agreed file boundary is staged, the initial commit exists locally, `origin` is configured, and the push to the target remote branch succeeds.
- Not acceptable: stopping at analysis only, silently publishing nested `.git` metadata, or forcing a destructive overwrite of an existing remote history without the user's explicit approval.

## Audit / Debug Strategy
- Inspect file classes and sizes before the initial commit.
- Verify whether large generated artifacts require exclusion or LFS.
- Track blockers and decisions in `SESSION.md` and `TASKS.md`.

## Capability Routing Rules
- Required capabilities are written as stable names.
- Implementation is resolved at execution time.

## Phase 1

### Goal
- The remote target is known, the repo boundary is intentional, the initial commit exists, and the remote push completes successfully.

### Inputs
- Local repo state
- Target remote HTTPS URL
- User-provided Git identity
- Remote host push behavior and size constraints

### Outputs
- Updated local Git config
- Finalized ignore or LFS policy if needed
- Initial commit hash
- Configured `origin`
- Successful branch push

### Dependencies
- The target remote URL must be provided or otherwise discovered.
- The publish boundary must be agreed when large generated artifacts are involved.

### Technical Route
- Use Git locally to set identity, manage staging, commit, and push.
- Use ignore rules or LFS only as needed to make the first publish safe and acceptable to the remote host.

### Detailed Implementation Approach
- Patch `.git/config` directly because `git config` file locking failed in the current shell environment.
- Add repo-boundary files such as `.gitignore` and optionally `.gitattributes` only after the target remote and upload scope are confirmed.
- Use `git add`, `git commit`, `git remote add`, and `git push` for the actual publish once network approval is granted.

### Risks
- Remote repo may already contain history and reject a normal initial push.
- The user may want a literal mirror including outputs that exceed normal host size limits.
- Git LFS may be required depending on host policy and selected scope.
- Remote URL capture from the browser is currently blocked in this environment.

### Requirement Alignment
- Satisfies the request to upload the current project and use the provided Git identity.

### Architecture Fit Review
- The route fits the current repo state because it starts with boundary control before any commit or push, which is necessary for a repo with 76k+ staged paths and oversized generated outputs.
- The route was improved by separating safe publish preparation from the still-missing remote target.

### Explicitly Unresolved Details
- Exact remote URL
- Whether `.tools/**/publish` outputs stay in the first publish or move behind exclusion or LFS
- Whether the remote's default branch naming or existing history requires a different push strategy

### Diagnostic Hooks / Signals
- `git status --short --branch`
- large-file scans
- `git remote -v`
- push output and host-side rejection messages

### Relevant Experience / Standards
- Prefer direct evidence over assumption.
- Avoid destructive repo actions without explicit confirmation.
- Do not let embedded repos or temp workspace outputs leak into the main repository by accident.

### Required Capabilities
- `repo_audit`
- `risk_model`
- `tool_select`
- `phase_plan`
- `project_summary_curate`

### Validation
- Confirm local identity values.
- Confirm the staged boundary after ignore or LFS decisions.
- Confirm the local commit exists.
- Confirm remote configuration and successful push.

### Expected Summary Updates
- Record the final remote host, branch, and publish-boundary decisions.

### Expected Tool / Report Updates
- No new helper is required yet.
- No `.canon` reference is required for this task.
- Keep any future publish-audit notes in the task workspace reports directory only if they become useful.

## Replan Triggers
- The remote already has history and needs merge, pull, or explicit overwrite handling.
- The user requires a literal full mirror including generated outputs above host limits.
- The target host requires SSH instead of HTTPS.

## Definition of Done
- The remote repo URL is configured.
- The committed content matches the agreed upload boundary.
- The initial push succeeds.
- The user can continue from this repo without manual cleanup of accidental nested-repo metadata.
