# Project Summary

## Current Mission
- Keep the repo-local `w3x2lni` source and runtime layout trustworthy, upstream-traceable, and usable inside the editor workspace.

## Context Snapshot
- Task label: Refresh w3x2lni toolchain
- Task slug: refresh-w3x2lni-toolchain
- Task type(s): tooling, bugfix, research
- Project context: brownfield
- Selected pattern: provenance audit -> official restore -> local build parity note
- Planning container: `.planning/`
- Task workspace: `.planning/workspaces/refresh-w3x2lni-toolchain/`

## Planned Technical Route Baseline
- Treat `sumneko/w3x2lni` GitHub metadata as the authority for source and release provenance.
- Treat `w3x2lni-source` as the visible official source checkout.
- Treat the official packaged `2.7.3` release under `.canon/w3x2lni` as the current installed runtime baseline.
- Preserve authoritative source snapshots inside workspace-local `tmp/` when deeper inspection is needed.
- Treat local source-build parity as a follow-up investigation, not as permission to ship undocumented local runtime patches.

## Inherited Standards and Principles
- Prefer verifiable upstream artifacts over undocumented local tool copies.
- Prefer hash checks and runtime checks over assumptions about what a local binary contains.

## Bug Avoidance and Red Flags
- Do not silently keep dirty tool repos in `.tools/` when the user has asked for an authoritative restore.
- Do not claim a local binary is official when its hash does not match the official release.
- Do not conflate "official source builds in CI" with "this local machine can reproduce that build."

## Debug Signals and Inspection Hooks
- `git status --short` and `git diff --stat` for any future repo-style tool copies.
- `git -C w3x2lni-source describe --tags --always` and `git -C w3x2lni-source remote -v` for source provenance.
- SHA-256 hashes for `w3x2lni.exe` and `w2l.exe`.
- Upstream workflow-run metadata for CI parity checks.
- Minimal startup check through `bin/w3x2lni-lua.exe`.

## Reusable Experience and Lessons
- Restoring tool trust quickly is often more valuable than forcing local source-build parity in the same round.
- Building in an ASCII-only temp path helps isolate Windows path issues, but it does not automatically solve machine-specific toolchain divergence.

## Active Improvements
- The project now separates source and runtime more clearly: `w3x2lni-source` for source and `.canon/w3x2lni` for the runnable package.
- This workspace now contains a clear provenance trail and parity gap record for future debugging.

## Route Review and Framework Compatibility Notes
- The official release package fits the existing workspace because it preserves the expected runtime layout and can be consumed from `.canon/w3x2lni`.
- Future parity investigation should happen in temp build roots, not by re-dirtying `.tools/w3x2lni`.

## Tooling Guidance
- Prefer `w3x2lni-source` for source inspection and `.canon/w3x2lni` for actual runtime use.
- Prefer workspace-local temp clones and reports for future parity investigation.
- No project-local helper tool was added in this round.

## Recent Retrospective Signals
- Hash comparison immediately confirmed that the previous executables were not the official release.
- Official GitHub workflow status was the decisive signal that local build failure was an environment issue, not a provenance issue.

## Open Risks and Watch Items
- The restored official package may still surface a runtime issue unrelated to provenance if the user's original symptom had a separate cause.
- A local source-built package is still not reproducible on this machine without further build-parity investigation.

## Update Log
- 2026-04-06: Initial summary created.
- 2026-04-06: Audited the old local tree, confirmed drift from upstream, and restored `.tools/w3x2lni` from the official `2.7.3` release package.
- 2026-04-06: Preserved an authoritative source snapshot under `tmp/w3x2lni-official-2.7.3/` and recorded the unresolved local `lua_assert` parity gap.
- 2026-04-06: Materialized `w3x2lni-source`, moved the runnable package to `.canon/w3x2lni`, and updated known MapRepair code paths to prefer the new location.
