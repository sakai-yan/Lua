# MapRepair vs w3x2lni LNI Failure

## Scope
- Date: 2026-03-31
- MapRepair source snapshot: `.tools/MapRepair/snapshots/MapRepair-source-20260331-231719.zip`
- Upstream source reviewed: `sumneko/w3x2lni`
- Local source download used for study: `C:\Temp\codex-w3x2lni\w3x2lni-master`
- Local runtime reproduction tool: `D:\Software\魔兽地图编辑\[0]新整合编辑器\plugin\w3x2lni_zhCN_v2.7.3`

## Reproduction
- Original map copied to `C:\Temp\w2l-test\orig.w3x`
- Repaired map copied to `C:\Temp\w2l-test\repaired_v41.w3x`
- Command that succeeds:
  - `w2l.exe lni C:\Temp\w2l-test\orig.w3x C:\Temp\w2l-test\orig_lni`
- Command that fails:
  - `w2l.exe lni C:\Temp\w2l-test\repaired_v41.w3x C:\Temp\w2l-test\repaired_v41_lni_debug`

## w3x2lni Evidence
- `script/backend/convert.lua` loads the map, runs `frontend`, then `backend`, then saves files.
- `script/core/slk/frontend_obj.lua` reads object-data value kinds straight from binary:
  - `0` => integer
  - `1/2` => real/unreal
  - `3` => string
- `script/core/slk/backend_lni.lua` serializes LNI by metadata type. Integer fields eventually go through `math.floor(...)`.
- Crash reproduced from local `2.7.3` runtime and logged to `log/error/2026-03-31 23-53-04.log`.
- The failing field is:
  - object type: `unit`
  - object id: `T001`
  - field: `deathType`
  - metadata type: integer (`type = 0` in w3x2lni metadata)
  - runtime value seen by w3x2lni: string `"2"`

## MapRepair Evidence
- `MapRepair.ObjectDump` against repaired `war3map.w3u` shows:
  - `OBJ T001`
  - `raw=udea kind=3 value=2`
- That means the rebuilt object-data encodes `udea` as string kind `3`, not integer kind `0`.
- The original protected map's `war3map.w3u` is not readable through the local probe, which explains why the original `w3x2lni` run did not hit this rebuilt-value-type bug in the same way.

## Root Cause
- The direct cause of the `w3x2lni -> lni` failure is not the `.mdl/.mdx` mismatch.
- The direct cause is a value-kind mismatch introduced in rebuilt object data:
  - `MapRepair` writes `T001.udea` (`deathType`) as string kind `3`
  - `w3x2lni` metadata defines `deathType` as integer-like and expects a numeric value when exporting LNI
  - when `w3x2lni` exports that field, it crashes because the source object value is string `"2"` instead of integer `2`

## MapRepair Source Analysis
- The critical path is in `.tools/MapRepair/src/MapRepair.Core/Internal/SlkObjectRebuilder.cs`.
- `TryBuildModification(...)` decides whether a rebuilt field becomes `Int`, `Real`, `Unreal`, or `String`.
- Integer-like fallback is controlled by `LooksLikeIntType(string type)`.
- Current code explicitly rejects any metadata type containing `Type`:
  - `type.Contains("Type", StringComparison.OrdinalIgnoreCase) == false`
- For Warcraft metadata such as `deathType`, this rule is too broad.
- Result:
  - `deathType` is not recognized as integer-like
  - raw text value `"2"` falls through to `ObjectValueKind.String`
  - `ObjectDataFileWriter` then emits binary object-data kind `3`

## Why Original Map Can Still Convert
- The original conversion path does not prove the original map stores `udea` correctly.
- The stronger local explanation is:
  - the original protected `war3map.w3u` is unreadable/opaque enough that `w3x2lni` does not reconstruct this exact bad rebuilt object entry
  - after repair, `war3map.w3u` becomes readable and stable enough for `w3x2lni` to parse it
  - once parsed, the wrong `udea` value kind becomes visible and crashes LNI export

## Fix Direction
- Fix `MapRepair` typing, not `w3x2lni`, if the goal is a healthier repaired map.
- First target:
  - make `deathType` serialize as `ObjectValueKind.Int`
- Best repair point:
  - tighten `LooksLikeIntType(...)` or replace it with a whitelist/metadata-driven enum handling rule
- Safer rule:
  - do not reject all metadata names containing `Type`
  - only exclude clearly string-like families such as `unitList`, `model`, `texture`, `icon`, `sound`, `effect`, `string`
- After the fix:
  - regenerate `war3map.w3u`
  - re-run `MapRepair.ObjectDump` and confirm `raw=udea kind=0 value=2`
  - re-run `w2l.exe lni ...` against the repaired map

## Secondary Note
- The `.mdl` files backed by binary `MDX` payloads remain a real editor-fidelity problem.
- They are not the blocking reason for the current `w3x2lni -> lni` crash.
