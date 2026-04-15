# Step Plan

## Current Step
- Name: Materialize `w3x2lni-source`, relocate the runtime to `.canon/w3x2lni`, and record local build parity failure
- Parent phase: Phase 1
- Why now: The existing local tool tree was confirmed dirty and its executable hashes did not match the official release package, so trust had to be restored before any deeper editor-side diagnosis.

## Step Objective
- The project must expose a visible official source checkout at `w3x2lni-source`, a trustworthy runtime package at `.canon/w3x2lni`, and enough evidence to continue local build-parity investigation later if needed.

## Requirement Alignment
- Keep official source in `w3x2lni-source`.
- Move the runnable tool into `.canon`.
- Deliver the new layout rather than leaving the task at analysis only.

## Planned Technical Route
- Follow the provenance audit -> official restore -> parity note route from `PLAN.md`.
- Keep upstream GitHub metadata as the authority for both source provenance and official runtime hashes.
- Prefer the official release package if local clean builds cannot reproduce upstream CI on this machine.
- Prefer `.canon/w3x2lni` in code, but keep a fallback to `.tools/w3x2lni` where compatibility is useful.

## Framework Compatibility Review
- The restore must fit the existing `.tools` editor workspace without requiring downstream script changes.
- Replacing the dirty local tree with the official package fits that framework better than preserving a repo clone with undocumented local edits.
- The only route correction made during execution was to stop insisting on a local source-built package once official-source local builds failed while upstream CI remained green.

## Detail Resolution Focus
- Resolve which official upstream artifact should be considered the runtime authority.
- Resolve whether the local machine can reproduce upstream CI well enough to justify a local rebuild.
- If not, restore trust immediately with the official packaged release and record the gap instead of shipping another local variant.

## Required Inputs
- Local `.tools/w3x2lni` audit output
- Official release metadata for `2.7.3`
- Official workflow success metadata for upstream builds
- Workspace-local source snapshots and temp build paths

## Relevant Project Memory
- Reviewed the newly created workspace baseline and the earlier MapRepair workspace only for context about prior `w3x2lni` path customizations.

## Standards / Bug Avoidance Applied
- Do not trust undocumented local tool binaries.
- Do not claim a local build is upstream-clean unless the source and resulting hashes are both auditable.
- Prefer authoritative releases when the local machine cannot prove source-build parity.

## Debug / Inspection Plan
- Observe local Git dirtiness, modified file list, and executable hash drift.
- Reproduce local source-build attempts in an ASCII temp path with an official `luamake` build.
- Confirm the parity gap if both `2.7.3` and current `master` still fail locally while upstream workflows are green.

## Completion Standard
- Acceptable completion: `w3x2lni-source` exists, official package is installed at `.canon/w3x2lni`, hashes matched, minimal runtime check passed, and parity gap documented.
- Not acceptable: leaving the runtime under the old path as the canonical location, reporting only a failed build, or reinstalling another unverifiable local binary.

## Temporary Detailed Actions
- 1. Audit the existing `.tools/w3x2lni` worktree and executable hashes.
- 2. Confirm official source, release, and workflow provenance.
- 3. Attempt clean local source builds using official upstream sources and a clean official `luamake`.
- 4. Materialize `w3x2lni-source` from the authoritative source snapshot.
- 5. Move the runtime package to `.canon/w3x2lni`.
- 6. Update known hard-coded paths to prefer `.canon`.
- 7. Validate installed hashes, runtime startup, and source-checkout metadata.
- 8. Write back a provenance and validation report.

## Validation
- `git status --short`
- SHA-256 comparison against the official release package
- `bin/w3x2lni-lua.exe -e "print(_VERSION)"`

## Replan / Abort Conditions
- The user explicitly requires a true local source-built package before accepting the restore.
- The official release package proves unusable in this workspace.

## Summary Updates Expected
- Record that the install now matches official `2.7.3` hashes and that local source-build parity remains a follow-up investigation rather than a restore blocker.
