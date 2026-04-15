# MapRepair v86: User-Confirmed Full Trigger-Shell Open And Binary Split

## Goal
- Continue the trigger editor-compatibility task after the user supplied the critical correction that fully shelling all triggers opens the map correctly in the real editor.

## What Changed
- Added `--trigger-shell` mode to `.tools/MapRepair/src/MapRepair.Diag/Program.cs` so diagnostic trigger-shell variants can be generated from repaired maps without touching production repair logic.
- Added `--replace-trigger-data` mode to the same tool for whole-document trigger-data replacement experiments.
- Generated trigger-shell variants under `tmp/v34-trigger-shell-diag/` for:
  - `016`
  - `018`
  - `019`
  - `020`
  - `021`
  - `022`
  - `016-022`
  - `001-569`
  - `001-032`
  - `033-569`

## Validation
- `dotnet build .tools/MapRepair/src/MapRepair.Diag/MapRepair.Diag.csproj -nologo`
- `dotnet run --project .tools/MapRepair/src/MapRepair.Diag/MapRepair.Diag.csproj -- --trigger-shell ... 016 018 019 020 021 022 016-022`
- `dotnet run --project .tools/MapRepair/src/MapRepair.Diag/MapRepair.Diag.csproj -- --trigger-shell ... 001-569`
- `dotnet run --project .tools/MapRepair/src/MapRepair.Diag/MapRepair.Diag.csproj -- --trigger-shell ... 001-032 033-569`

## Findings
- The user manually confirmed that `001-569` trigger-shelling opens the repaired map correctly in the real editor.
- That result overrides the earlier `-loadfile` launcher-process heuristic and proves the remaining blocker is still trigger-side.
- Focused shells for `016`, `018`, `019`, `020`, `021`, `022`, and `016-022` did not narrow the culprit enough on their own.
- The next truthful narrowing step is a complementary binary split:
  - `001-032`
  - `033-569`

## Current Conclusion
- Do not spend more time on object-data-only or whole-document trigger-data replacement hypotheses until the binary split contradicts the user-confirmed full-shell result.
- The next manual validation should target the two complementary variants generated in `tmp/v34-trigger-shell-diag/`.
