# MapRepair Smoke Audit Against Official W3x2lni

## Goal
- Re-check `MapRepair.Smoke` against the freshly restored official runtime at `Lua/.canon/w3x2lni/` without modifying the runtime package itself.

## Baseline And Scope
- Audited the live runtime layout under `.canon/w3x2lni/`.
- Did not modify `.canon/w3x2lni/`.
- Checked the smoke-side staging logic only:
  - rewrite staged `config.ini` from `data_ui = ${YDWE}` to `data_ui = ${DATA}`
  - rewrite staged `script/gui/push_error.lua` to pass `-s` into `script/crashreport/init.lua`
- Note: the project summary from the earlier toolchain-refresh task still mentions a root-level `w3x2lni-source/`, but no such checkout currently exists in this repo. This audit therefore used the installed official runtime package and its shipped Lua scripts as the authoritative baseline.

## What Was Verified
- Normal smoke run now passes against the restored official package:
  - `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
  - Result: `MapRepair smoke passed.`
- The opt-in staged `w2l` scenario still does not complete successfully:
  - `MAPREPAIR_SMOKE_RUN_W2L=1 dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
  - Result:
    - `w2l-lni-reconstruction skipped: staged w2l.exe failed`
    - stdout only reached early progress output plus the staged `w3x2lni-lua.exe` path banner
    - overall smoke still reported `MapRepair smoke passed`
- The staged-layout assumptions themselves are compatible with the official package:
  - the official package contains the exact directories and files the smoke stage copies:
    - `w2l.exe`
    - `bin/`
    - `script/`
    - `data/`
    - `config.ini`
  - the shipped `script/crashreport/init.lua` already supports the `-s` flag that smoke injects into staged `push_error.lua`
- The same staged official runtime succeeds on a real repaired map:
  - staged `.canon/w3x2lni` to a workspace temp directory with the same smoke-side `config.ini` and `push_error.lua` adjustments
  - ran `w2l.exe lni` against `tmp/current-rerun-v22/chuzhang V2 mod2.851_repaired_current.w3x`
  - result:
    - exit code `0`
    - `w2l-output/` populated successfully
    - no staged crashreport log was produced

## Conclusion
- The restored official `.canon/w3x2lni` package is not the thing currently failing this audit.
- Current routine smoke behavior is healthy again because the optional `w2l` stage is skipped by default and the main suite passes.
- There is still a real smoke-side issue in the opt-in `w2l-lni-reconstruction` scenario:
  - either the synthetic repaired map produced by that scenario is not acceptable to official `w2l.exe`
  - or the scenario's failure handling is too weak because it downgrades a reproducible non-zero `w2l.exe` result into a skip while still allowing the overall smoke run to pass

## Practical Interpretation
- If the question is "does the current official `w3x2lni` package break normal smoke runs?" the answer is no.
- If the question is "is there still an error path inside smoke when explicitly checking `w2l.exe`?" the answer is yes.

## Recommended Next Slice
- Compare the synthetic `w2l-gui-reconstruction_repaired.w3x` artifact against a real repaired map that the same staged official runtime can convert successfully.
- Once that synthetic-map delta is understood, either:
  - fix the synthetic smoke scenario input, or
  - keep it opt-in but make a non-zero `w2l.exe` exit fail loudly instead of silently turning into a skipped informational branch.
