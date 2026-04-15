# Execution Plan

## Planning Mode
- Profile: standard
- Task type(s): brownfield feature repair, binary-format compatibility, GUI reconstruction

## Project Context
- Context type: brownfield
- Selected pattern: debug-first implementation

## Requirement Integration
- The audit phase is complete.
- The active requirement is to make MapRepair emit editor-readable `war3map.wtg/wct` output and recover as much editable GUI structure as is practical without breaking runtime behavior.

## Technical Route Strategy
- Restore standard WTG root/child node layout in `LegacyGuiBinaryCodec`.
- Add an independent YDWE-style WTG compatibility validator and block malformed reconstructed output from being written.
- Replace event-only argument parsing with type-aware normalization for common recovered JASS expressions such as `Player(n)`, `gg_unit_*`, `gg_rct_*`, `gg_dest_*`, and `.1`.
- Reconstruct triggers as GUI by default using:
- GUI event nodes where metadata and arguments can be encoded.
- GUI action nodes when a direct action mapping exists.
- `CustomScriptCode` GUI actions when inlining raw action lines is safer than falling back to full custom-text.
- Root-condition GUI nodes only for simple encodable returns; otherwise preserve condition semantics as custom-script guard actions.

## Route Refinement
- The original comprehensive route called for a full AST-driven recovery of actions, conditions, and control-flow blocks.
- Execution-time framework review showed that a GUI plus `CustomScriptCode` hybrid fits the current MapRepair architecture better and preserves runtime behavior faster than a full AST rewrite.
- This is an approved route refinement, not a silent scope reduction: the output is editor-readable GUI trigger data, but some trigger bodies remain represented as GUI custom-script actions instead of structured GUI blocks.

## Workspace
- Project root: `D:\Software\魔兽地图编辑\[0]新整合编辑器\Lua`
- Planning workspace: `.planning/workspaces/maprepair-trigger-editor-compatibility`

## Validation Strategy
- `MapRepair.Smoke` must pass.
- The internal YDWE-style validator must accept reconstructed WTG output.
- The original YDWE `fix-wtg/checker.lua` must accept the important reconstructed GUI outputs through the repo-local bridge.
- A real-map run against `chuzhang V2 mod2.851.w3x` must regenerate `war3map.wtg/wct` and reduce editor-hostile pseudo-GUI materially from the audited baseline.

## Completion Standard
- New reconstructed WTG output is blocked if it is not validator-compatible.
- Smoke covers standard-layout roundtrip, GUI recovery, root-condition guards, and `w3x2lni` export compatibility.
- Real-map repair output is materially improved and documented in `SESSION.md` / `PROJECT_SUMMARY.md`.

## Remaining Work
- Local code and artifact work for the trigger-load crash is complete through the small pseudo-GUI fallback slice.
- Final confirmation still requires a manual editor-side validation pass that the newest repaired map or package `win-x64-self-contained-20260405-0636` no longer crashes while reading triggers.
