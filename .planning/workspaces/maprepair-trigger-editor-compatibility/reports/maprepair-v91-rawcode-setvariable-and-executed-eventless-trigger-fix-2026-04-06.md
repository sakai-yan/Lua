# MapRepair v91: Rawcode SetVariable And Executed Eventless Trigger Fix

## Goal
- Repair the two independently confirmed blockers inside `025-032`:
  - `028-lostitem`
  - `032-herospN`

## What Changed
- Updated `GuiArgumentNormalizer` so rawcode literals now normalize for integer/global `SetVariable` routes.
- Updated `JassGuiReconstructionParser` so:
  - explicitly executed eventless triggers can stay GUI when structured
  - very large all-`SetVariable` triggers are no longer forced into custom-text
- Added smoke coverage for:
  - executed eventless GUI triggers
  - large structured `SetVariable` triggers
- Re-ran the real map into `tmp/current-rerun-v35/`.

## Validation
- `dotnet build .tools/MapRepair/MapRepair.sln -nologo`
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
  - reached the new trigger scenarios successfully
  - later stopped on the unrelated pre-existing `quoted-ydwe-extension-metadata` failure
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- ... current-rerun-v35 ...`

## Findings
- `028-lostitem` is now GUI in `v35`:
  - `eventCount = 1`
  - `actionCount = 441`
  - `customScriptCount = 0`
- `032-herospN` is now GUI in `v35`:
  - `eventCount = 0`
  - `actionCount = 27`
  - `customScriptCount = 0`
- Summary metrics improved:
  - `RecoveredGui.CustomTextTriggerCount`: `60 -> 50`
  - `RecoveredGui.GuiEventNodeCount`: `755 -> 770`

## Current Conclusion
- The previously isolated `028` and `032` blocker shapes are fixed in the generated map.
- The next truthful gate is manual editor validation of `tmp/current-rerun-v35/chuzhang V2 mod2.851_repaired_current.w3x`.
