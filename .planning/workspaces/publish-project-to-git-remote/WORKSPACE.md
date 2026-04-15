# Task Workspace

## Task Identity
- Task label: Publish current project to remote Git repo
- Task slug: publish-project-to-git-remote
- Matching rule: Reuse this workspace only when a later request still targets the same normalized objective, primary surface, and completion slice.
- Split rule: Create a sibling task workspace when the request becomes materially different and the existing task board or summary would become misleading.

## Scope Snapshot
- Current normalized objective: Publish the current `Lua` project to the user's chosen remote Git repository, using the provided Git identity, while keeping the initial upload boundary safe and intentional.
- Primary surfaces: repo root state, `.git/config`, future `.gitignore` and optional `.gitattributes`, staged file boundary, large generated artifacts, remote configuration, and initial push flow.
- Explicit exclusions: no application feature work, no unrelated refactor, no destructive cleanup outside agreed ignore rules, and no remote force-push without explicit user confirmation.

## Continuation Signals
- Reuse this workspace when: the user still wants this same local project published or updated in the same remote repository flow.
- Create a new sibling workspace when: the work shifts into general repository maintenance, release engineering beyond this initial publish, or a different target repository or subtree.

## Workspace Paths
- Project root: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua
- Planning container: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Project playbook: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/publish-project-to-git-remote
- Task-local tools directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/publish-project-to-git-remote/tools
- Project toolset directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical reference directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon
- Reports directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/publish-project-to-git-remote/reports

## Notes
- This workspace owns `PLAN.md`, `STEP_PLAN.md`, `TASKS.md`, `SESSION.md`, `PROJECT_SUMMARY.md`, and related execution artifacts for this task only.
- Task-only helpers can live in `D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/publish-project-to-git-remote/tools`; reusable mutable project tools can move to `D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools`.
- Treat `D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon` as canonical read-only input unless the task is explicitly about maintaining reference material.
- Cross-task knowledge should be promoted intentionally into `D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/PROJECT_PLAYBOOK.md` instead of being mixed here by default.
- Current known blocker: the target remote URL is still unknown, and direct Chrome-tab URL capture was not available from the current shell context.
