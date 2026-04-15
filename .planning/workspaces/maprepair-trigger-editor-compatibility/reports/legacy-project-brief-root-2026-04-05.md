# Project Brief

## Problem
- MapRepair can reconstruct `war3map.wtg/wct`, but the previous output was not editor-readable because the WTG binary layout was malformed and the GUI reconstruction path fell back to full custom-text too aggressively.

## Project Context
- Context type: brownfield implementation/debug
- This work continues the earlier audit and directly modifies the existing MapRepair codebase and smoke suite.

## Goals
- Emit standard-layout, validator-compatible `war3map.wtg` output.
- Recover editor-readable GUI triggers from `war3map.j` wherever practical.
- Preserve runtime behavior when full GUI structure is still unsafe by using GUI `CustomScriptCode` actions before falling back to whole-trigger custom-text.
- Reduce the real-map fallback bucket materially from the audited baseline.

## Non-Goals
- Do not add historical compatibility for already-corrupted repaired WTG files.
- Do not attempt a full AST-driven GUI rebuild in the same step if the hybrid route is already delivering safe, material gains.

## Constraints
- The implementation must fit the existing `MapRepair.Core` architecture and smoke harness.
- Reconstructed WTG output must be blocked if it fails compatibility validation.

## Existing Knowledge Inputs
- `.planning/workspaces/maprepair-trigger-editor-compatibility/reports/wtg-gui-audit-2026-04-04.md`
- `Lua/.tools/MapRepair/src/MapRepair.Core/Internal/Gui/*`
- `Lua/.tools/YDWE/share/script/fix-wtg/*`
- latest real-map `repair-report.md` output from the new implementation

## Stakeholders / Surface
- MapRepair repaired-map output
- YDWE / KKWE / `w3x2lni` trigger-data compatibility
- GUI reconstruction quality for protected JASS maps

## Success Signals
- Smoke passes.
- Real-map reconstruction writes `war3map.wtg/wct` without validator failure.
- The custom-text trigger count drops substantially versus the audited baseline.
