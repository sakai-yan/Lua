# MapRepair v47 Roundtrip `inEditor` Fix

## Goal
- Explain why repaired maps still lost unit tool-panel recognition after `w3x2lni -> obj`.
- Verify whether removing embedded object-source SLKs from the repaired archive fixes the exported `unit.ini` shape.

## Good Reference
- User-provided reference LNI workspace:
  - `.tools/MapRepair/[0]一世之尊(地形开始) (2)`
- Observed characteristics:
  - `table/unit.ini` sections: `430`
  - `inEditor = 0` count: `0`
  - `special = 1` count: `18`
  - repacked good map contains `Units\CommandFunc.txt`
  - repacked good map does **not** contain embedded `Units/UnitData.slk`, `UnitBalance.slk`, `UnitAbilities.slk`, or `unitUI.slk`

## Bad Roundtrip Baseline
- Current repaired-map export:
  - `.tools/MapRepair/chuzhang V2 mod2.851_repaired/table/unit.ini`
- Observed characteristics:
  - sections: `663`
  - `inEditor = 0` count: `660`
  - `special = 1` count: `45`
- Source repaired map archive:
  - `.tools/MapRepair/chuzhang V2 mod2.851_repaired_v46.w3x`
  - still contains embedded object-source SLKs:
    - `Units\UnitData.slk`
    - `Units\UnitBalance.slk`
    - `Units\UnitAbilities.slk`
    - `Units\unitUI.slk`

## Root Cause
- `MapRepair` preserved map-embedded object-source SLKs that were useful during reconstruction but harmful during later `w3x2lni` export.
- Those embedded SLKs polluted the later `w2l.exe lni` output so the exported `table/unit.ini` gained widespread `inEditor = 0`.
- Once that polluted `unit.ini` was packed back with `w2l.exe obj`, the editor tool/palette stopped recognizing units normally.

## Code Change
- Added a final pruning step in `MapRepairService` that removes embedded object-source SLKs from the repaired archive once the corresponding rebuilt object-data files already exist.
- Added `ReferencedAssetCollector.GetSlkEntryNames()` so the prune step can reuse the same canonical SLK list.

## Verification
- Generated fresh repaired map:
  - `.planning/tmp/chuzhang_v47_noslk.w3x`
- Confirmed the repaired archive no longer contains:
  - `Units\UnitData.slk`
  - `Units\UnitBalance.slk`
  - `Units\UnitAbilities.slk`
  - `Units\unitUI.slk`
- Exported that repaired map with patched local `w2l.exe lni`.
- Resulting exported `table/unit.ini`:
  - sections: `861`
  - `inEditor = 0` count: `0`
  - `inEditor = 1` count: `0`
  - `special = 1` count: `45`

## Artifacts
- Fresh repaired sample:
  - `.tools/MapRepair/chuzhang V2 mod2.851_repaired_v47.w3x`
- Fresh repair report:
  - `.tools/MapRepair/chuzhang V2 mod2.851_repair_report_v47`
- Fresh published GUI:
  - `.tools/MapRepair/publish/win-x64-self-contained/MapRepair.exe`
