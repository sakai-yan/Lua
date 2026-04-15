# Project Brief

## Problem
- The current `Lua` project exists locally as a Git repo with no commits and no configured remote, but the user wants the current project uploaded into an existing remote Git repository.

## Project Context
- Context type: brownfield
- Why this context matters: the work must preserve an existing large local tree, respect current workspace conventions, and avoid pushing accidental temp data, embedded VCS metadata, or oversized generated artifacts.

## Project-Local Workspace
- Project root: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua
- Planning container: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning
- Project playbook: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/PROJECT_PLAYBOOK.md
- Task workspace: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/publish-project-to-git-remote
- Task slug: publish-project-to-git-remote
- Task-local tools directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/publish-project-to-git-remote/tools
- Project toolset directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.tools
- Canonical reference directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.canon
- Reports directory: D:/Software/魔兽地图编辑/[0]新整合编辑器/Lua/.planning/workspaces/publish-project-to-git-remote/reports

## Goals
- Configure the repo to use the user's Git identity.
- Resolve the target remote repository URL.
- Finalize a safe upload boundary for the first publish.
- Create the initial commit for the agreed project contents.
- Push the current project state to the agreed remote branch successfully.

## Normalized Requirements
- User wants the current whole project uploaded to a Git repository already opened in Chrome.
- User provided Git identity: `user.name = sakai`, `user.email = yanmeng5v1@qq.com`.
- The flow should complete end-to-end from this local repo if the target remote URL is available.
- Upload scope needs a practical repository boundary because the current tree includes embedded `.git` directories, large temp trees, and generated binaries over normal GitHub object limits.

## Non-Goals
- No application code changes unrelated to publishing.
- No history rewriting after the initial publish unless the user explicitly asks.
- No force-pushing over existing remote history without explicit confirmation.

## Constraints
- Remote URL is not yet known locally.
- Chrome tab URL could not be read from the current shell context.
- `git status` shows a brand-new repo state with no commits yet and about 76,941 staged paths.
- The tree contains embedded repos and lock files that should not be published as normal project content.
- The tree also contains generated binaries above 95 MB, especially under `.tools/.../publish/`, which will exceed normal GitHub object limits unless excluded or moved to LFS.
- Networked push operations will require remote access approval in this environment.

## Existing Knowledge Inputs
- The project playbook mainly captures shared code-style guidance and does not materially change this publishing workflow.
- Existing repo inspection shows `.planning`, `.tools`, `.canon`, and `w3x2lni-source` contain high-volume generated or embedded-repo content that must be reviewed before publish.
- Current Git config already uses credential manager globally, so HTTPS remote auth may work once the target URL is known.

## Audit / Debug Focus
- Inspect the staged file boundary, especially embedded `.git` content, `.planning/workspaces/*/tmp`, and oversized generated binaries.

## Stakeholders / Surface
- Local repo state in `Lua/`
- Future remote repository contents
- User-facing Git history and branch state
- Any host-side file-size or LFS policy on the target remote

## Success Signals
- `git config` shows the requested local identity.
- `git remote -v` shows the intended remote URL.
- The first commit contains only the agreed project boundary.
- `git push` completes successfully and the user can see the uploaded project in the remote repo.

## Open Questions
- What is the exact HTTPS remote URL for the target repository?
- Should the first publish exclude generated publish outputs and task temp directories by default, or does the user want a literal mirror including those heavy artifacts?
