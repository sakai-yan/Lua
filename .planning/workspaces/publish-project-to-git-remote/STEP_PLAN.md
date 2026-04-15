# Step Plan

## Current Step
- Name: Resolve remote target and publish boundary
- Parent phase: Phase 1
- Why now: the task cannot move into commit and push until the target remote and boundary policy are known.

## Step Objective
- The exact target remote URL is known, the user's Git identity is in local config, and the next publish edits are constrained by an explicit boundary decision.

## Requirement Alignment
- Use the requested Git identity.
- Keep progress aimed at a real upload rather than only documenting the process.
- Prevent accidental publication of nested repo metadata and oversized generated outputs.

## Planned Technical Route
- Follow the route that captures the remote URL first, then finalizes ignore or LFS policy, then refreshes staging for the initial publish.
- Fixed decisions: do not force-push; do not publish embedded `.git` directories as normal content.

## Framework Compatibility Review
- The route must fit a repo with no commits yet, no remote, tens of thousands of staged paths, and very large generated files.
- The route is reasonable only if the upload boundary is reviewed before commit.
- No replan is needed yet, but remote URL capture remains blocked.

## Detail Resolution Focus
- Resolve the exact target remote URL.
- Decide whether generated publish outputs stay in the first commit or are excluded or moved to LFS.
- Respect host size limits and avoid accidental destructive overwrite of remote history.

## Required Inputs
- User-provided remote HTTPS URL
- Current repo size and staging facts
- Local `.git/config`

## Relevant Project Memory
- Reviewed `PROJECT_PLAYBOOK.md` and the newly created task planning artifacts.

## Standards / Bug Avoidance Applied
- Prefer direct evidence over assumption.
- Avoid destructive Git operations without explicit user approval.
- Do not publish nested `.git` metadata or temp workspaces accidentally.

## Debug / Inspection Plan
- Observe current repo state, staged path classes, and file-size hotspots.
- Confirm whether direct Chrome URL capture is possible from this environment.
- Use Git inspection output to confirm whether the repo is ready for publish preparation.

## Completion Standard
- Fully acceptable completion means the remote URL blocker is resolved and the next commit-preparation step can execute immediately.
- It is not acceptable to guess the remote URL or silently choose a destructive push strategy.

## Temporary Detailed Actions
- Write the requested Git identity into local repo config.
- Record current blockers and size risks in task memory.
- Request the target remote URL from the user if browser capture remains unavailable.

## Validation
- Confirm `.git/config` contains the requested identity.
- Confirm task memory reflects the current blocker and route.

## Replan / Abort Conditions
- User requires a literal full mirror including all generated binaries and temp trees.
- Remote host policy requires a different auth or transport path than expected.

## Summary Updates Expected
- Keep `PROJECT_SUMMARY.md` updated with blocker state, large-file risks, and publish-boundary decisions.
- Nothing should be promoted into `PROJECT_PLAYBOOK.md` yet.
