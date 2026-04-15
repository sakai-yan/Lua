# MapRepair Smoke W3i / W2l Fix

## Goal
- Fix the opt-in `MapRepair.Smoke` `w2l-lni-reconstruction` path by aligning the synthetic map info file with the official `w3x2lni` parser instead of changing the official runtime package.

## Root Cause
- The failure was not in the restored official `.canon/w3x2lni` package itself.
- The synthetic map built by smoke used `W3iBinaryWriter`, and that writer emitted a `war3map.w3i` layout that did not match the official parser in `script/core/slk/frontend_w3i.lua`.
- Specifically:
  - map flags and main-ground tileset were written in the wrong order
  - the `version >= 25` layout missed the game-data-setting field
  - the flag bit positions were shifted relative to the official parser
  - `version >= 28` and `version >= 31` placeholder fields were not accounted for
- Reproducing the smoke scene outside the main test run showed the exact official runtime error:
  - `frontend_w3i.lua:35: bad argument #1 to 'unpack' (data string too short)`

## Fix
- Updated `MapRepair.Core/Internal/W3iBinaryWriter.cs` so the generated binary `war3map.w3i` now follows the field order expected by the official `w3x2lni` parser.
- Corrected the map-flag bit definitions to match the official parser.
- Added the missing `version >= 25` game-data-setting field.
- Added safe placeholder writes for the `version >= 28` and `version >= 31` parser branches.
- Tightened `MapRepair.Smoke` so if `MAPREPAIR_SMOKE_RUN_W2L=1` is enabled and staged `w2l.exe` fails, the smoke run now fails instead of silently downgrading the failure to a skip.
- Cleared the nullable warning in the staged runtime path by asserting a non-null `sourceRoot` once and reusing that verified path.

## Verification
- Probe reproduction tool:
  - `tools/maprepair_smoke_w2l_probe`
  - before the fix: official staged `w2l.exe` failed at `frontend_w3i.lua`
  - after the fix: the same synthetic repaired map now converts successfully
- Full smoke:
  - `MAPREPAIR_SMOKE_RUN_W2L=1 dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
  - result: full suite passed, including `w2l-lni-reconstruction`

## Result
- The opt-in smoke `w2l` path is now a real verification path again instead of a soft-skipped informational branch.
- The fix lives on the smoke/input-generation side and the rebuilt `w3i` writer side, not in the official `.canon/w3x2lni` package.
