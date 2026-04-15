# MapRepair V46 Hotkey / Char Typing Fix

## Goal
- Fix the remaining `w3x2lni -> lni` crash after `v45`.

## Diagnosis
- A temporary instrumented `w3x2lni 2.7.2` runtime showed the next blocker precisely:
  - family: `item`
  - object: `rde0`
  - rawcode: `uhot`
  - field: `Hotkey`
  - `w3x2lni` expected a string-like value but received numeric `1`
- `MapRepair.ObjectDump` confirmed the bad rebuilt payload in `v45`:
  - `war3map.w3t`
  - `OBJ rde0`
  - `raw=uhot kind=0 value=1`

## Root Cause
- `SlkObjectRebuilder.TryBuildModification(...)` still relied on a broad integer-typing heuristic for non-`real` / non-`unreal` / non-`bool` metadata.
- Warcraft metadata marks item/unit hotkeys as type `char`.
- Because the raw payload was numeric-looking (`"1"`), the heuristic treated `char` as integer-like and wrote `uhot` as `kind=0` instead of string `kind=3`.
- The same code path also coerced any literal `TRUE` / `FALSE` into integer object-data before checking whether the metadata type was actually `bool`.

## Fix
- Treat `bool` coercion as metadata-gated instead of value-gated.
- Treat `char` as string-like metadata so numeric-looking hotkeys remain string object-data.
- Added smoke coverage for:
  - `char` hotkey `"1"` staying string
  - `bool` `"TRUE"` still writing as integer

## Validation
- `dotnet build .tools/MapRepair/MapRepair.sln -nologo`
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --no-build --project .planning/tools/maprepair_runner/MapRepair.Run.csproj -- <input> <v46-output> <v46-report>`
- `w2l.exe lni <v46-map> <out>` on:
  - `D:\Software\魔兽地图编辑\w3x2lni2.7.2\w3x2lni`
  - `D:\Software\魔兽地图编辑\[0]新整合编辑器\plugin\w3x2lni_zhCN_v2.7.3`

## Result
- New artifact: `.tools/MapRepair/chuzhang V2 mod2.851_repaired_v46.w3x`
- New report: `.tools/MapRepair/chuzhang V2 mod2.851_repair_report_v46`
- In `v46`, `rde0.uhot` now writes as string object-data:
  - `raw=uhot kind=3 value=1`
- Local `w3x2lni` conversion now completes successfully instead of crashing in `backend_lni`.
