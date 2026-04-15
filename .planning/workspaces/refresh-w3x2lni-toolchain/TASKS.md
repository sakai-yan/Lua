# Tasks

## Active
- None. The requested restore is complete.

## Ready
- If the user still wants a locally source-built package instead of the official release package, investigate why this machine fails inside `3rd/bee.lua/bee/lua/file.h` with missing `lua_assert` while upstream CI is green.
- If the user reports a runtime problem with the restored official package, reproduce it against the now-clean installation before reintroducing any local patches.

## Blocked
- No blocker for the requested restore.
- Optional local-build-parity investigation depends on whether the user wants that extra work.

## Done
- Audited the previous `.tools/w3x2lni` tree and confirmed it was dirty: modified `config.ini`, `make.lua`, `script/backend/ydwe_path.lua`, modified submodule `3rd/bee.lua`, and untracked `script/%SystemDrive%/`.
- Verified that the previous `w3x2lni.exe` and `w2l.exe` hashes did not match the official `2.7.3` release package.
- Confirmed official upstream provenance from `sumneko/w3x2lni`, including latest release `2.7.3` and successful upstream workflow runs for both `2.7.3` and current `master`.
- Preserved an authoritative source snapshot under `tmp/w3x2lni-official-2.7.3/`.
- Built a clean official `luamake` in an ASCII temp path and used it to probe local source-build parity.
- Recorded that both clean local-source attempts still failed at the `bee.lua` layer on this machine despite upstream CI success.
- Materialized a visible official source checkout at `w3x2lni-source`, preserving the official `origin` remote and checked-out `2.7.3` commit.
- Moved the runnable package from `.tools/w3x2lni` to `.canon/w3x2lni`.
- Updated known MapRepair code paths to prefer `.canon/w3x2lni` and fall back to `.tools/w3x2lni`.
- Validated the relocated installation by matching official hashes and running `.canon/w3x2lni/bin/w3x2lni-lua.exe`, which reported `Lua 5.4`.
