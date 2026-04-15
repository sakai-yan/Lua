# Execution Plan

## Planning Mode
- Profile: Standard
- Task type(s): tooling, bugfix, research

## Project Context
- Context type: brownfield
- Selected pattern: provenance audit -> official restore -> local build parity note

## Requirement Integration
- The user first required the existing `.tools/w3x2lni` to be removed, reacquired from an authoritative source, and returned to a usable packaged executable state.
- The user then refined the layout requirement: keep the official source in `w3x2lni-source` and move the runnable tool into `.canon`.
- That requirement was integrated by treating upstream GitHub metadata as the source of truth, preserving a visible official source checkout at project root, moving the runtime package to `.canon/w3x2lni`, and updating known code references to prefer the new layout.

## Technical Route Strategy
- Audit the current local `w3x2lni` installation for dirty tracked files, untracked debris, and executable-hash drift.
- Confirm authoritative upstream source and release provenance from `sumneko/w3x2lni`.
- Attempt a clean local build from authoritative source using the same broad toolchain shape as the upstream workflow.
- If local build parity fails while upstream CI is green, replace the installed tool with the official packaged release and record the local build mismatch for later investigation.
- Keep future route changes constrained to reproducible provenance and validation signals rather than ad hoc local edits.

## Workspace
- Project root: `Lua/`
- Planning container: `.planning/`
- Task workspace: `.planning/workspaces/refresh-w3x2lni-toolchain/`
- Task slug: `refresh-w3x2lni-toolchain`
- Project-specific tools directory: `.planning/workspaces/refresh-w3x2lni-toolchain/tools/`
- Reports directory: `.planning/workspaces/refresh-w3x2lni-toolchain/reports/`
- Dynamic memory and execution artifacts stay in the matching task workspace, not in the shared skill folder.

## Knowledge Inputs
- Local Git audit of `.tools/w3x2lni`
- Official release metadata for `2.7.3`
- Official workflow metadata showing successful upstream builds for both `2.7.3` and current `master`
- Existing `maprepair-trigger-editor-compatibility` workspace notes about earlier `w3x2lni` path customizations

## Assumptions
- A trustworthy official packaged runtime is preferable to a locally patched rebuild when local build parity cannot be reproduced immediately.
- Keeping an authoritative source snapshot in the workspace is sufficient to satisfy the source-provenance requirement for this round.

## Completion Standard
- Complete delivery means the dirty `.tools/w3x2lni` tree is gone, the installed replacement matches the official release package, and the runtime starts successfully.
- It is not acceptable to leave the dirty local copy in place, to report only a build attempt without restoring the tool, or to silently ship a locally patched binary while claiming it is upstream-clean.

## Audit / Debug Strategy
- Inspect `git status`, executable hashes, and upstream release metadata before replacement.
- Use local build attempts only as parity diagnostics, not as the sole restore path.
- Track the exact local build failure site and the upstream-success evidence in a dedicated workspace report.

## Capability Routing Rules
- Required capabilities are written as stable names.
- Implementation is resolved at execution time.

## Phase 1

### Goal
- The official source is available at `w3x2lni-source`, the runnable package lives at `.canon/w3x2lni`, and the provenance trail is recorded.

### Inputs
- `.tools/w3x2lni`
- Upstream repo `https://github.com/sumneko/w3x2lni`
- Upstream release `https://github.com/sumneko/w3x2lni/releases/tag/2.7.3`
- Upstream workflow success pages
- Local temporary build area and official `luamake` parity attempts

### Outputs
- Visible project-root source checkout at `w3x2lni-source`
- Runnable package at `.canon/w3x2lni`
- Workspace-local authoritative source snapshot
- Workspace report describing provenance, hash deltas, local build failure, and validation results

### Dependencies
- Upstream metadata must be confirmed.
- The local dirty installation must be audited before deletion so future investigation still has evidence.

### Technical Route
- Use upstream GitHub as the provenance authority.
- Attempt local source build only to learn whether this machine can reproduce upstream CI.
- Keep the official source checkout visible at project root.
- Use the official packaged release as the runtime restore artifact under `.canon/w3x2lni` when it provides the cleanest trustworthy result.

### Detailed Implementation Approach
- Capture local `git status` and executable hashes from the pre-existing tree.
- Clone or preserve official source snapshots under workspace-local `tmp/`.
- Materialize a clean project-root source checkout at `w3x2lni-source`.
- Build official `luamake` in an ASCII-only temp path to reduce Windows path instability.
- Attempt clean source builds for upstream `2.7.3` and current `master`.
- If both local parity attempts fail while upstream CI remains green, place the official `w3x2lni-2.7.3.zip` runtime package under `.canon/w3x2lni`.
- Update known hard-coded repo paths to prefer `.canon` and fall back to the old `.tools` layout.
- Validate with executable hashes, a minimal `bin/w3x2lni-lua.exe` runtime check, and source-checkout metadata.

### Risks
- Local GitHub connectivity can fail during clone or submodule fetch.
- Local Windows compiler behavior can diverge from the upstream GitHub runner.
- Release-package restore may solve trust and usability immediately while leaving local build parity unresolved.

### Requirement Alignment
- Removes the suspect local installation.
- Replaces it from an authoritative upstream channel.
- Keeps official source at `w3x2lni-source`.
- Moves the packaged executable installation into `.canon/w3x2lni`.

### Architecture Fit Review
- This route fits the surrounding editor workspace because it restores a trusted runtime artifact without broadening scope into unrelated editor or gameplay changes.
- The route improved from "rebuild locally at all costs" to "restore trust first, then document the local build parity gap" once the upstream CI signal proved that the divergence is local-environment-specific.

### Explicitly Unresolved Details
- The exact reason this machine fails inside `bee.lua` with missing `lua_assert` remains unresolved.
- Any future attempt to solve that must preserve upstream provenance and avoid silently reintroducing local runtime patches.

### Diagnostic Hooks / Signals
- `git status --short`
- `git diff --stat`
- SHA-256 hashes for `w3x2lni.exe` and `w2l.exe`
- Upstream release metadata and workflow-run status
- Minimal `bin/w3x2lni-lua.exe` launch check

### Relevant Experience / Standards
- Prefer authoritative upstream artifacts over undocumented local tool copies.
- Prefer explicit provenance and hash checks over assumption-based trust.

### Required Capabilities
- `repo_audit`
- `source_provenance_check`
- `build_parity_probe`
- `tool_restore`
- `session_update`

### Validation
- Confirm the old local tree was dirty.
- Confirm `w3x2lni-source` points at the official upstream repo and `2.7.3` tag.
- Confirm the installed replacement hashes under `.canon/w3x2lni` match the official release package.
- Confirm `bin/w3x2lni-lua.exe` runs and reports `Lua 5.4`.

### Expected Summary Updates
- Record the official release version, the successful restore outcome, and the remaining local-build-parity gap.

### Expected Tool / Report Updates
- No project-local helper tool is required yet.
- Store the provenance and validation report in `reports/w3x2lni-official-refresh-2026-04-06.md`.

## Replan Triggers
- The user requires a true local source-built package rather than the official release package.
- A newer official upstream release becomes the required target.
- The restored official package still reproduces the user's original runtime problem.

## Definition of Done
- `w3x2lni-source` exists as a visible official source checkout.
- `.canon/w3x2lni` contains the runnable package and `.tools/w3x2lni` no longer contains the previous tree.
- The installed executables match the official release hashes.
- The runtime launches successfully for a minimal non-GUI check.
- The workspace records both the restore path and the unresolved local build parity issue.
