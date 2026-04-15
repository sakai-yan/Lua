# Project Brief

## Problem
- The repo-local `.tools/w3x2lni` tree was not a clean upstream copy.
- The local Git worktree contained modified tracked files, an untracked stray path, and executable hashes that did not match the official release package.
- The user requested deletion of the local copy, re-acquisition from an authoritative source, and a restored packaged executable installation.

## Project Context
- Context: brownfield tooling maintenance.
- Why it matters: the tool is already wired into a larger Warcraft editor workspace, so the safest route is provenance-first replacement instead of speculative local customization.

## Project-Local Workspace
- Project root: `Lua/`
- Planning container: `.planning/`
- Task workspace: `.planning/workspaces/refresh-w3x2lni-toolchain/`
- Task slug: `refresh-w3x2lni-toolchain`
- Project-specific tools directory: `.planning/workspaces/refresh-w3x2lni-toolchain/tools/`
- Reports directory: `.planning/workspaces/refresh-w3x2lni-toolchain/reports/`

## Goals
- Replace `.tools/w3x2lni` with an authoritative upstream package.
- Preserve an authoritative upstream source snapshot for inspection.
- Verify that the restored package is runnable and that the installed executable hashes match the official release.
- Record the local-source-build mismatch so future work can continue from evidence instead of guesswork.

## Normalized Requirements
- Delete the existing `.tools/w3x2lni` directory rather than trying to patch it in place.
- Use the official upstream project as the authority for source provenance.
- Deliver a usable packaged executable installation in `.tools/w3x2lni`.
- Prefer a trustworthy official binary package over a locally patched rebuild if the local machine cannot reproduce the upstream CI build cleanly.

## Non-Goals
- No gameplay or gameplay-script changes.
- No MapRepair trigger reconstruction changes.
- No attempt to fork or permanently customize upstream `w3x2lni` behavior in this round.

## Constraints
- The project path contains non-ASCII characters and `[]`, which complicated some local Windows build subprocesses.
- Network access to GitHub was intermittent during cloning and submodule fetches.
- The local machine could run official release binaries, but a clean local source build diverged from upstream CI at the `bee.lua` layer.

## Existing Knowledge Inputs
- The existing `maprepair-trigger-editor-compatibility` workspace already recorded that repo-local `w3x2lni` path handling had been customized earlier.
- Official upstream metadata came from:
- `https://github.com/sumneko/w3x2lni`
- `https://github.com/sumneko/w3x2lni/releases/tag/2.7.3`
- `https://github.com/sumneko/w3x2lni/actions/runs/20329620400`

## Audit / Debug Focus
- Verify whether the current local tree is dirty relative to upstream.
- Verify whether installed executables match the official release package.
- If a clean local build fails, capture the exact failure layer and contrast it with upstream CI success.

## Stakeholders / Surface
- The local editor workspace that invokes `.tools/w3x2lni`.
- Any workflow that depends on `w3x2lni.exe`, `w2l.exe`, or `bin/w3x2lni-lua.exe`.

## Success Signals
- `.tools/w3x2lni` is a clean packaged official distribution.
- Installed executable hashes match the official `2.7.3` release package.
- `bin/w3x2lni-lua.exe` starts successfully and reports `Lua 5.4`.
- The source-provenance and build-parity notes are captured in this workspace.

## Open Questions
- None required for the restore itself.
- A follow-up question remains only for future work: why this machine cannot reproduce the upstream CI build locally.
