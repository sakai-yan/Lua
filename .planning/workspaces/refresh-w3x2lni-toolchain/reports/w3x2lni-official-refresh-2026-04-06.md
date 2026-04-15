# w3x2lni Official Refresh Report

## Scope
- Task slug: `refresh-w3x2lni-toolchain`
- Date: `2026-04-06`
- Goal: remove the dirty repo-local `.tools/w3x2lni`, restore a trustworthy upstream package, and keep enough provenance to continue local build-parity work later if needed.

## Upstream Authority
- Repo: `https://github.com/sumneko/w3x2lni`
- Latest release used for runtime restore: `2.7.3`
- Release page: `https://github.com/sumneko/w3x2lni/releases/tag/2.7.3`
- Official packaged asset: `https://github.com/sumneko/w3x2lni/releases/download/2.7.3/w3x2lni-2.7.3.zip`
- Successful upstream workflow for `master`: `https://github.com/sumneko/w3x2lni/actions/runs/20329620400`
- Successful upstream workflow for `2.7.3`: `https://github.com/sumneko/w3x2lni/actions/runs/20329544068`

## Pre-Restore Findings
- The old `.tools/w3x2lni` worktree was dirty.
- Modified tracked files:
- `config.ini`
- `make.lua`
- `script/backend/ydwe_path.lua`
- Modified submodule state:
- `3rd/bee.lua`
- Untracked path:
- `script/%SystemDrive%/`

## Pre-Restore Hash Drift
- Old installed `w3x2lni.exe` SHA-256:
- `9F3D3795681EEA78733275D6A9271A5F10C808933E4081206F0DBD37075EFFCE`
- Old installed `w2l.exe` SHA-256:
- `09CCC1A4E3C8C94372A84108401D5A6C0FC1A2E889DAAB22B0242E84CD34F23A`
- Official `2.7.3` `w3x2lni.exe` SHA-256:
- `B5B2F0023E1575FD543789AE5FA7D00D6B9337FF85D9E289A0EF62B22374F6AC`
- Official `2.7.3` `w2l.exe` SHA-256:
- `3F7BC5FA228960DEAE5F7596B315CBE7678B98F4A8DEFE3CA3EC4C5713894C15`

## Source Snapshot
- Authoritative source snapshot preserved at:
- `tmp/w3x2lni-official-2.7.3/`

## Local Build-Parity Probe
- Built a clean official `luamake` from `actboy168/luamake` in an ASCII-only temp path.
- Attempted clean local builds against official `w3x2lni` `2.7.3` and current official `master`.
- Result: both local attempts failed on this machine in `3rd/bee.lua/bee/lua/file.h` with missing `lua_assert`.
- Conclusion: the remaining build mismatch is local-environment-specific because upstream CI for the same upstream refs is green.

## Restore Action
- Deleted the previous `.tools/w3x2lni` directory.
- Replaced it with the contents of the official packaged asset `w3x2lni-2.7.3.zip`.

## Layout Migration
- Materialized a visible project-root source checkout at `w3x2lni-source/`.
- Preserved the official upstream remote in that checkout:
- `https://github.com/sumneko/w3x2lni.git`
- Confirmed the checkout tag/commit baseline:
- tag `2.7.3`
- short SHA `05e3e37`
- Moved the runnable package to `.canon/w3x2lni/`.
- Updated known MapRepair code paths to prefer `.canon/w3x2lni` and fall back to `.tools/w3x2lni`.

## Post-Restore Validation
- Installed `w3x2lni.exe` SHA-256:
- `B5B2F0023E1575FD543789AE5FA7D00D6B9337FF85D9E289A0EF62B22374F6AC`
- Installed `w2l.exe` SHA-256:
- `3F7BC5FA228960DEAE5F7596B315CBE7678B98F4A8DEFE3CA3EC4C5713894C15`
- Minimal runtime check:
- `bin/w3x2lni-lua.exe -e "print(_VERSION)"` returned `Lua 5.4`
- Source-checkout validation:
- `git -C w3x2lni-source remote -v` points to the official upstream repo
- `git -C w3x2lni-source describe --tags --always` returns `2.7.3`

## Outcome
- The requested trust restore is complete.
- The installed tool now matches the official packaged release.
- Future work is only needed if the user wants a true local source-built package or if a new runtime issue is still reproducible on the restored official install.
