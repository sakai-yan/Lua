# MapRepair v81: YDWE Extension Metadata And Event Alignment

## Goal
- Move the repaired trigger output closer to the healthy sample by fixing YDWE extension metadata loading, preserving healthy-sample raw node names, and recovering more YDWE event and action nodes as structured GUI instead of dropping them into custom text or flat `CustomScriptCode`.

## What Changed
- Fixed quoted YDWE extension section names such as `[" CreateUnit"]` so the healthy-sample raw GUI name is preserved while normalized aliases such as `CreateUnit` also resolve.
- Broadened structured GUI recovery to use the full loaded YDWE metadata set instead of restricting recovery back down to only base-compatible or map-local entries.
- Changed init-function event recovery so helper registrations are tried as GUI events before opaque fallback.
- Added synthetic `MapInitializationEvent` recovery only when a trigger is executed from `main` and still has no other recoverable GUI event.
- Preserved narrow custom-text fallback for opaque dispatch-heavy bodies such as `ExecuteFunc` / `TriggerExecute` / `ConditionalTriggerExecute`.

## Validation
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- Re-ran the real map into `.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v28/`

## Real-Map Result
- `v27`
  - `customTextCount = 277`
  - `war3map.wtg = 491803 bytes`
  - `war3map.wct = 1673191 bytes`
- `v28`
  - `customTextCount = 229`
  - `war3map.wtg = 624532 bytes`
  - `war3map.wct = 1529188 bytes`
- `v28` now recovers much more healthy-sample-style structured YDWE action coverage such as:
  - `RemoveLocation = 337`
  - `DisplayTextToPlayer = 152`
  - `DestroyGroup = 33`
  - bulk `SetTextTag*` action recovery

## Remaining Gap
- The next dominant mismatch is still control-flow child-block recovery:
  - healthy sample `totalChildBlocks = 734`
  - repaired `v28` `totalChildBlocks = 0`
- The missing layer is now block-structured YDWE recovery for nodes such as:
  - `IfThenElseMultiple`
  - `YDWERegionMultiple`
  - `YDWETimerStartMultiple`
  - `YDWEForLoopLocVarMultiple`
