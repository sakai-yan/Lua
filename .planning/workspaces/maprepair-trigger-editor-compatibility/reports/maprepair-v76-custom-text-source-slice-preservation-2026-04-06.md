# MapRepair V76 Custom-Text Source-Slice Preservation

## Goal
- Re-evaluate the early custom-text route after the user reported `v22` still stopped at `16/569`.
- Use the newly supplied healthy references to check whether the `v20/v22` init-first / action-second custom-text ordering rule actually matches editor-authored trigger text.

## Findings / Root Cause
- The newly supplied `.tools/YDWE/荒魂演武(不朽开源)` source map is editor-healthy and its `war3map.wct` has:
  - `version = 1`
  - `count = 412`
  - `nonEmpty = 0`
  which means the reference map does not rely on whole-trigger custom-text at all.
- The local healthy sample under `War3/map` is editor-healthy and its `war3map.wct` has:
  - `version = 1`
  - `count = 14`
  - `nonEmpty = 7`
- Those healthy `War3/map` custom-text chunks contradict the current `v22` assumption:
  - they preserve raw script source order
  - they do not force `InitTrig_*` to be the first function
  - they can include trigger-local `globals` blocks between the trigger header comments and the function bodies
- `JassGuiReconstructionParser` still rebuilt whole-trigger custom-text by reassembling selected functions, which meant it could:
  - synthetically reorder functions away from source order
  - drop trigger-local non-function text such as mid-file `globals` blocks
  - normalize chunk shape away from what healthy editor-authored samples actually look like

## Fix / Mitigation
- Changed `JassGuiReconstructionParser.BuildCustomTextChunk(...)` to prefer source-backed chunk extraction over synthetic function reassembly.
- The new custom-text writer now:
  - takes the selected function closure as a set
  - reorders that set back into `war3map.j` source order
  - preserves nearby trigger comment headers
  - preserves trigger-local `globals ... endglobals` blocks when they are anchored by trigger header comments
  - merges adjacent source spans instead of rebuilding them with a synthetic `InitTrig_*`-first layout
- Added smoke coverage `gui-custom-text-source-slice-globals`.
- Updated the custom-text smoke expectations so they now lock source-order preservation instead of the earlier init-first / action-second assumption.

## Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- Re-ran the real map into:
  - `tmp/current-rerun-v23/chuzhang V2 mod2.851_repaired_current.w3x`
- Rebuilt the desktop package into:
  - `.tools/MapRepair/publish/win-x64-self-contained-20260406-1242/`
  - `.tools/MapRepair/publish/win-x64-self-contained/`
  - `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260406-1242.zip`
- `current-rerun-v23/report/repair-report.json` keeps:
  - `triggerCount = 569`
  - `customTextCount = 468`
  - `GuiEventNodeCount = 257`
  - `RecoveredGuiTriggerIndex count = 569`
- Early `v23` custom-text evidence now matches the source-backed route:
  - `016-tmdlimititemlvl.j` restores the original `Conditions -> helper -> Actions -> InitTrig` order and keeps the trigger header comments
  - `001-SET.j` and `002-SET2.j` no longer use the synthetic init-first layout

## Publish
- New rerun validation target:
  - `tmp/current-rerun-v23/chuzhang V2 mod2.851_repaired_current.w3x`
- New packaged desktop target:
  - `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260406-1242.zip`

## Next Slice If Manual Validation Still Fails
- Start from `current-rerun-v23`.
- If either editor still stops near `16/569`, treat that as evidence that the remaining issue is deeper than function ordering alone and inspect:
  - the earliest source-backed custom-text chunks (`SET`, `SET2`, `tmdlimititemlvl`)
  - how much external helper text each chunk still pulls in
  - whether the next reduction should shrink whole-trigger fallback breadth rather than keep restyling it
- If the failure point moves, pivot to the next structured GUI survivors using `RecoveredGui/index.json`.
