# MapRepair V73 Custom-Text Callback Closure And Smoke Popup Fix

## Goal
- React to the user confirmation that `v18` still stopped at `16/569`.
- Fix the newly confirmed callback-closure gaps inside emitted custom-text triggers and stop the optional smoke `w2l` stage from showing blocking error popups.

## Findings / Root Cause
- Auditing `v18` custom-text outputs showed `42` trigger text chunks still referenced local helpers via callback syntax such as:
  - `function Trig_SET2_Func006A`
  - `function Trig_t1_Func004A`
  - `function Trig_J_WDSXXRH_Func003A`
- Those helpers were missing because closure collection only followed:
  - direct calls like `Trig_*()`
  - a few previously hard-coded callback APIs
- It did not follow generic inline callback references embedded in arbitrary calls such as:
  - `ForForce(..., function Trig_*_Func...)`
- Side finding: the optional `w2l-lni-reconstruction` smoke scenario still launched staged `w2l.exe`, which could surface the `w3x2lni-lua.exe` crash-report popup even though that scenario was only informational and already non-blocking.

## Fix / Mitigation
- Extended custom-text closure discovery to scan generic inline `function Name` callback references in trigger body lines.
- Tightened smoke coverage so `gui-compact-guarded-pseudo-fallback` now asserts callback-helper preservation in emitted custom text.
- Changed the optional smoke `w2l-lni-reconstruction` stage to skip by default unless:
  - `MAPREPAIR_SMOKE_RUN_W2L=1`
- This keeps routine smoke runs headless and prevents the staged `w3x2lni-lua.exe` popup from interrupting local verification.

## Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- Smoke now prints:
  - `w2l-lni-reconstruction skipped: set MAPREPAIR_SMOKE_RUN_W2L=1 to enable the optional staged w2l.exe check`
- Re-ran the real map into:
  - `tmp/current-rerun-v19/chuzhang V2 mod2.851_repaired_current.w3x`
- Extracted and checked:
  - `tmp/current-rerun-v19/verify/war3map.wtg`
  - `tmp/current-rerun-v19/verify/war3map.wct`
- Passed:
  - `maprepair_wtg_inspect`
  - original checker
  - corrected debug walk
- The custom-text callback audit now reports:
  - `0` remaining `.j` chunks with missing `Trig_*` callback references
- `002-SET2.j` now includes:
  - `Trig_SET2_Func006Func001C`
  - `Trig_SET2_Func006A`
  - `Trig_SET2_Actions`
  - `InitTrig_SET2`

## Real Map Snapshot
- `triggerCount = 569`
- `customTextCount = 468`
- `GuiEventNodeCount = 257`
- `extensionNodes = []`
- Front slice remains aligned with `v18`:
  - the early `baoxiang` compact guarded cluster stays `custom-text`
  - `tmdlimititemlvl` remains `custom-text`

## Publish
- This round produced the new rerun validation target:
  - `tmp/current-rerun-v19/chuzhang V2 mod2.851_repaired_current.w3x`
- Published the matching desktop GUI build under:
  - `.tools/MapRepair/publish/win-x64-self-contained-20260406-0846/`
  - `.tools/MapRepair/publish/win-x64-self-contained/`
  - `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260406-0846.zip`

## Next Slice If Manual Validation Still Fails
- Start from `current-rerun-v19`.
- If either editor still stops at `16/569`, treat that as stronger evidence that the issue is now inside the early custom-text slice itself rather than from missing helper closure.
- The next likely inspection target should be custom-text text shape, especially:
  - banner/comment prologue
  - line-ending normalization
  - how full trigger closures compare to real editor-authored custom-text trigger bodies
