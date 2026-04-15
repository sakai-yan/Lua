# MapRepair V45 Object-Data Typing Fix

## Goal
- Repair the confirmed `w3x2lni -> lni` blockers caused by rebuilt object-data type mismatches in `MapRepair`.

## Confirmed Fixes
- Fixed enum-like unit metadata typing so `deathType` now serializes as integer object-data.
- Fixed indexed profile-field splitting so comma-delimited values such as `Buttonpos=0,2` now expand into separate numeric object-data modifications instead of being written back as string payloads.
- Fixed grouped profile metadata handling so duplicate field families can emit all indexed rawcodes instead of only the first one.
- Added smoke coverage for:
  - `deathType -> Int`
  - `moveType -> String`
  - indexed value splitting
  - implicit first-index expansion for grouped profile metadata

## Validation
- `dotnet build .tools/MapRepair/MapRepair.sln -nologo`
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/tools/maprepair_runner/MapRepair.Run.csproj -- <input> <v45-output> <v45-report>`

## Repaired Artifact
- Output map: `.tools/MapRepair/chuzhang V2 mod2.851_repaired_v45.w3x`
- Report: `.tools/MapRepair/chuzhang V2 mod2.851_repair_report_v45`

## Concrete Evidence
- In `v45`, `war3map.w3u` now stores:
  - `T001.udea` as `kind=0 value=2`
- In `v45`, `war3map.w3t` now stores:
  - `plcl.ubpx` as `kind=0 value=0`
  - `plcl.ubpy` as `kind=0 value=0`
- Cross-checking dumped `w3u/w3t/w3h/w3a/w3q` against `w3x2lni` integer rawcodes no longer shows any `kind=3` payloads on known integer rawcodes in those five families.

## Remaining Gap
- Local `w3x2lni` `w2l.exe lni ...` still shows a wrapper-era modal failure on the user's installed `2.7.3` package.
- The two confirmed `MapRepair` blockers identified this round are fixed in source and validated in the rebuilt map.
- The next unresolved issue is narrower and appears to be beyond the already-fixed `udea` / `Buttonpos` object-data typing bugs.
