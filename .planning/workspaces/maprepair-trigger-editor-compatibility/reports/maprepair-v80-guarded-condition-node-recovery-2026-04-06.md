# MapRepair V80 Guarded Condition-Node Recovery

## Goal
- React to the user report that `v26` still stopped at `16/569`.
- Compare the healthy sample's real `WTG/WCT/LML` output against the repaired front slice and fix the remaining structural mismatch instead of adding another fallback band.

## Findings / Root Cause
- The healthy sample export under `tmp/healthy-sample-lml/` shows that simple editor-healthy GUI triggers keep root conditions as real GUI `条件` nodes such as:
  - `OperatorCompareBoolean`
  - `OperatorCompareInteger`
  - `OperatorCompareReal`
  - `OperatorCompareItemCode`
- The repaired `v26` front slice still differed in a concrete way:
  - `clc2 baoxiang`, the other `baoxiang` triggers, and `tmdlimititemlvl` had already returned to GUI skeletons
  - but their root conditions were still emitted as action-time custom-script guards:
    - `if not Trig_*_Conditions() then`
    - `return`
    - `endif`
- The original source functions for those triggers are not opaque. They follow a standard four-line boolean-guard pattern such as:
  - `if ( not ( GetItemTypeId(GetManipulatedItem()) == 'clc2' ) ) then return false endif return true`
  - `if ( not ( IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO) == true ) ) then return false endif return true`
- `TryRecoverConditionNodes(...)` only recognized the trivial one-line shape `return <expr>`, so those healthy GUI-shaped guard functions were being downgraded unnecessarily.

## Fix / Mitigation
- Extended guarded root-condition recovery so the parser now recognizes standard boolean guard functions of the form:
  - `if <expr> then return true endif return false`
  - `if <expr> then return false endif return true`
- Added comparison-expression parsing to `GuiArgumentNormalizer.TryParseConditionExpression(...)` for editor-style GUI condition nodes, including:
  - `OperatorCompareBoolean`
  - `OperatorCompareInteger`
  - `OperatorCompareReal`
  - `OperatorCompareString`
  - rawcode-typed comparisons such as `OperatorCompareItemCode`
- Tightened preset / rawcode normalization so:
  - operator presets such as `OperatorEqualENE` are accepted for `*Operator` argument types
  - `true/false` no longer leak into unrelated bare-variable paths
  - rawcode literals such as `'clc2'` are treated as rawcode-typed values instead of being accepted by unrelated comparison candidates
- Added smoke coverage `gui-guarded-comparison-condition-recovery`.

## Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v27/chuzhang V2 mod2.851_repaired_current.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v27/report`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v27/chuzhang V2 mod2.851_repaired_current.w3x war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v27/verify/war3map.wtg`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v27/chuzhang V2 mod2.851_repaired_current.w3x war3map.wct .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v27/verify/war3map.wct`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v27/chuzhang V2 mod2.851_repaired_current.w3x war3map.wts .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v27/verify/war3map.wts`
- `w3x2lni-lua.exe` dump via `tools/maprepair_wtg_lml_dump.lua` for:
  - `tmp/healthy-sample-lml/`
  - `tmp/current-rerun-v27/lml-dump/`

## Real-Map Result
- `v27` continues moving the repaired map toward the healthy sample shape:
  - `triggerCount = 569`
  - `GuiEventNodeCount = 513`
  - `CustomTextTriggerCount = 277`
- The real written `WTG/WCT` dump now shows the previously failing early triggers with true GUI conditions:
  - `004-clc2 baoxiang.lml`
    - `条件 -> OperatorCompareItemCode(GetItemTypeId(GetManipulatedItem()), OperatorEqualENE, clc2)`
  - `016-tmdlimititemlvl.lml`
    - `条件 -> OperatorCompareBoolean(IsUnitType(GetTriggerUnit(), UnitTypeHero), OperatorEqualENE, true)`
- This removes the old root custom-script guard prelude from those front-slice conditions and aligns them with the healthy sample's GUI condition-node style.

## Current Continuation Target
- Manual editor-side validation against `.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v27/chuzhang V2 mod2.851_repaired_current.w3x`.
- If the editor still stops near `16/569`, the next comparison target should be the remaining early action-side `if/else` custom-script blocks, because the root condition mismatch in the front slice is now closed for the known early failing triggers.
