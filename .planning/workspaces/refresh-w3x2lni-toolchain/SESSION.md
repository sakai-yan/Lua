# Session

## Current Objective
- Keep a visible official source checkout at `w3x2lni-source`, move the runnable package to `.canon/w3x2lni`, and capture the local build-parity evidence.

## Step Plan Status
- `STEP_PLAN.md` is current for the completed official-restore round on 2026-04-06.

## What Changed
- Confirmed the pre-existing `.tools/w3x2lni` tree was not a clean upstream copy.
- Confirmed the pre-existing executable hashes differed from the official `2.7.3` release package.
- Cloned and preserved an authoritative `2.7.3` source snapshot in workspace-local `tmp/`.
- Built a clean official `luamake` in an ASCII temp path.
- Confirmed that clean local builds against official source still failed on this machine at the `bee.lua` layer with missing `lua_assert`, even though upstream GitHub Actions runs are successful.
- Replaced `.tools/w3x2lni` with the official `2.7.3` release package.
- Validated `bin/w3x2lni-lua.exe`, `w3x2lni.exe`, and `w2l.exe` hashes after replacement.
- Materialized `w3x2lni-source` at project root from the authoritative source snapshot.
- Moved the runnable package to `.canon/w3x2lni`.
- Updated known MapRepair code paths so they now prefer `.canon/w3x2lni` and only fall back to `.tools/w3x2lni`.

## Requirement Updates Assimilated
- The explicit request to delete the current tool and restore it from an authoritative source turned the task from a soft audit into a provenance-first replacement task.
- The follow-up request added a layout requirement: source must be visible at `w3x2lni-source`, and the runtime package must live under `.canon`.

## Planned Route Framework Compatibility
- The restore path was reviewed against the existing `.tools` workspace expectations.
- Installing the official packaged release fit cleanly because it preserves the expected runtime layout: `bin/`, `data/`, `script/`, `template/`, `w2l.exe`, and `w3x2lni.exe`.
- The only conflicting route was "must build locally from source before restoring anything"; that route was demoted once upstream CI success proved the remaining gap is machine-local rather than upstream provenance failure.

## Decisions
- Used the official upstream GitHub repo and release metadata as the provenance authority.
- Preserved an authoritative source snapshot in the workspace.
- Used the official release package as the installed runtime because it is more trustworthy than another local patched build while local parity remains unresolved.
- Kept the visible source checkout at project root and the runtime package under `.canon` so source and runnable artifacts are now clearly separated.

## Blockers
- No blocker for the completed restore.
- Remaining blocker only for optional future work: the local machine still cannot reproduce the upstream source build.

## Next Actions
- Keep the restored official package in place unless the user reports a new runtime issue.
- If requested later, investigate the local `lua_assert` build-parity failure without reintroducing silent local runtime patches.

## Validation Notes
- `git status --short` on the old tree showed tracked-file modifications and an untracked stray directory.
- SHA-256 comparison showed the old `w3x2lni.exe` and `w2l.exe` differed from the official release.
- After replacement, installed hashes matched the official `2.7.3` package:
- `w3x2lni.exe`: `B5B2F0023E1575FD543789AE5FA7D00D6B9337FF85D9E289A0EF62B22374F6AC`
- `w2l.exe`: `3F7BC5FA228960DEAE5F7596B315CBE7678B98F4A8DEFE3CA3EC4C5713894C15`
- `bin/w3x2lni-lua.exe -e "print(_VERSION)"` printed `Lua 5.4`.
- `git -C w3x2lni-source remote -v` still points to `https://github.com/sumneko/w3x2lni.git`.
- `git -C w3x2lni-source describe --tags --always` returns `2.7.3`.
- `.tools/w3x2lni` no longer exists after the move.

## Debug Findings
- Official upstream workflow runs are green for both `2.7.3` and current `master`.
- Clean local builds still failed on this machine inside `3rd/bee.lua/bee/lua/file.h` with missing `lua_assert`.
- That makes the remaining mismatch local-environment-specific rather than evidence that upstream source or release provenance is bad.

## Debug State Sync
- Core debug conclusion: the installed tool problem was real at the provenance level because the local tree and hashes had drifted, but local source-build parity remains a separate machine-specific problem.
- Current debug continuation target: none unless the user requests deeper local build-parity work.
- Task-board changes applied: moved the restore work to `Done` and left only optional parity follow-up in `Ready`.

## Summary Sync
- Added the project-root source checkout location, the `.canon` runtime location, the restored hash values, and the remaining local-build-parity risk.

## Delivery Integrity
- The restore stayed aligned with the completion standard because the dirty local tree was removed and a verified official package was installed.
- The only unfinished slice is an optional deeper parity investigation, which is not required for the requested restore outcome.
