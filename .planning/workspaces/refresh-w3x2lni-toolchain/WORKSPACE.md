# Task Workspace

## Task Identity
- Task label: Refresh w3x2lni toolchain
- Task slug: refresh-w3x2lni-toolchain
- Matching rule: Reuse this workspace when a later request still targets replacing or validating the repo-local `.tools/w3x2lni` installation, tracing local build parity against the official upstream source, or auditing the installed `w3x2lni` package provenance.
- Split rule: Create a sibling task workspace when the request pivots to a different Warcraft toolchain, to MapRepair trigger repair behavior, or to unrelated editor integration work.

## Scope Snapshot
- Current normalized objective: Keep a visible official source checkout at `w3x2lni-source`, move the runnable `w3x2lni` package under `.canon/w3x2lni`, and keep the local build-parity evidence recorded for later investigation.
- Primary surfaces: `w3x2lni-source`, `.canon/w3x2lni`, workspace-local `tmp/` source and release artifacts, official upstream `sumneko/w3x2lni` provenance, and local `luamake` parity notes.
- Explicit exclusions: Do not mix MapRepair trigger compatibility fixes, YDWE runtime-path shims outside the packaged official tree, or unrelated Lua gameplay code changes into this workspace.

## Continuation Signals
- Reuse this workspace when: validating the installed official package, comparing hashes or upstream releases, or continuing the local-source-build parity investigation for `w3x2lni`.
- Create a new sibling workspace when: the work changes from restoring `w3x2lni` itself to another tool, another subsystem, or a broader editor packaging pipeline.

## Workspace Paths
- Project root: `Lua/`
- Planning container: `.planning/`
- Task workspace: `.planning/workspaces/refresh-w3x2lni-toolchain/`
- Project-specific tools directory: `.planning/workspaces/refresh-w3x2lni-toolchain/tools/`
- Reports directory: `.planning/workspaces/refresh-w3x2lni-toolchain/reports/`

## Notes
- This workspace owns `PLAN.md`, `STEP_PLAN.md`, `TASKS.md`, `SESSION.md`, `PROJECT_SUMMARY.md`, and related execution artifacts for this task only.
- Cross-task knowledge should be promoted intentionally instead of being mixed here by default.
- The authoritative source snapshot currently also exists at project-root `w3x2lni-source/`.
- The installed runtime package currently lives under `.canon/w3x2lni/` and matches the official `w3x2lni-2.7.3.zip` release hashes.
