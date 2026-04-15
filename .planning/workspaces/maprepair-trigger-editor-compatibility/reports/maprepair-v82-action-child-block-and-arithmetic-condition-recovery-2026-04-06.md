# MapRepair v82: Action Child-Block And Arithmetic Condition Recovery

## Goal
- Recover editor-readable action-side control-flow blocks, with the user-reported `016-tmdlimititemlvl` front-slice stop as the primary narrowing target.

## What Changed
- Added action-body `if/else/endif` recovery in `JassGuiReconstructionParser`, so recoverable action-side control flow now emits `IfThenElseMultiple` child blocks instead of only flat `CustomScriptCode` markers.
- Added recursive nested action-risk counting so pseudo-GUI fallback still measures custom-script and control-flow pressure after child-block recovery.
- Extended `GuiArgumentNormalizer` to reconstruct simple infix integer and real arithmetic expressions into GUI call nodes such as `OperatorIntegerAdd`, `OperatorIntegerSubtract`, `OperatorRealAdd`, and `OperatorRealSubtract`.
- Updated debug LML rendering so recovered child blocks are visible in `RecoveredGui/*.lml`.
- Added smoke coverage `gui-action-if-then-else-child-block-recovery` and changed it to cover the same arithmetic-backed helper-condition shape that blocked `016-tmdlimititemlvl`.

## Validation
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v29/chuzhang V2 mod2.851_repaired_current.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v29/report`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v30/chuzhang V2 mod2.851_repaired_current.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v30/report`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract <v29-map> war3map.wtg <v29-wtg>`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract <v29-map> war3map.wct <v29-wct>`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract <v30-map> war3map.wtg <v30-wtg>`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract <v30-map> war3map.wct <v30-wct>`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_wtg_inspect/MapRepair.WtgInspect.csproj -- . <v29-wtg> <v29-wct>`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_wtg_inspect/MapRepair.WtgInspect.csproj -- . <v30-wtg> <v30-wct>`

## Real-Map Result
- `v28`
  - `customTextCount = 229`
  - `totalChildBlocks = 0`
- `v29`
  - `customTextCount = 199`
  - `totalChildBlocks = 377`
  - `IfThenElseMultiple = 161`
- `v30`
  - `customTextCount = 197`
  - `totalChildBlocks = 382`
  - `IfThenElseMultiple = 163`
- `016-tmdlimititemlvl` now writes as:
  - root GUI condition `OperatorCompareBoolean(IsUnitType(GetTriggerUnit(), UnitTypeHero), ...)`
  - action-side `IfThenElseMultiple`
  - nested comparison `OperatorCompareInteger(GetItemLevel(GetManipulatedItem()), OperatorGreaterEq, OperatorIntegerAdd(GetHeroLevel(GetTriggerUnit()), 1))`
  - then block `UnitRemoveItemSwapped` plus the preserved `DisplayTextToPlayer` custom-script line
  - else block `DoNothing`
- `019-tmdjingong1` now shows nested `IfThenElseMultiple` blocks in the recovered debug LML, which confirms the new route works on real map data beyond the targeted `016` fix.

## Remaining Gap
- Manual editor validation is still required; the Warcraft editors are not available in this environment.
- The earliest remaining mixed-control-flow survivor if `v30` still fails near `16/569` is now `018-hantmdweiacunzhuang1`, which still keeps flat helper-guard control flow around one recovered child block.
- `020-tmdjingong009` still keeps the root guard prelude as flat custom script.
- `SET` and `SET2` still keep flat loop-heavy control flow, so they remain likely early follow-up targets if the failure point moves beyond `016`.
