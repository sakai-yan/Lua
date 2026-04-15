# MapRepair V78 Custom-Text Editor Header Normalization

## Goal
- Revisit the still-failing early custom-text slice after the user confirmed `v24` still stopped near `16/569`.
- Compare the raw healthy-sample `war3map.wct` slots against the raw `v24` output instead of relying only on reconstructed `RecoveredGui/*.j` artifacts.

## Findings / Root Cause
- The local healthy sample `War3/map/war3map.wct` has `7/7` non-empty custom-text slots starting with:
  - `//TESH.scrollpos=0`
  - `//TESH.alwaysfold=0`
- The raw `v24` output had `0/468` non-empty custom-text slots with those editor-authored `TESH` headers.
- The same raw `v24` slots also still preserved decorative source-noise prefixes in some early chunks, such as:
  - `/////////////`
  - `/////////////////////////////////////`
- That mismatch did not show up in the reconstructed `RecoveredGui/*.j` comparisons, which meant the previous source-shape audit had been missing an editor-facing `WCT` detail that survives in healthy maps.
- The integrated editor log `logs/kkwe.log` confirmed the `v24` open attempt started on `2026-04-06 14:32:20` and then stopped without reaching the later `virtual_mpq 'triggerdata'` / `virtual_mpq 'triggerstrings'` phase that appears in successful opens, which kept the suspicion on editor-side trigger-text handling.

## Fix / Mitigation
- Normalized every emitted whole-trigger custom-text chunk in `JassGuiReconstructionParser` so it now:
  - prepends `//TESH.scrollpos=0`
  - prepends `//TESH.alwaysfold=0`
  - strips decorative comment-only preambles such as `/////////////` before the real trigger body
  - keeps the existing source-backed local-closure route below that normalized editor header
- Extended `MapRepair.Smoke` so the custom-text fallback scenarios now assert the editor header is present.
- Added a source-slice smoke input that includes a decorative `/////////////` preamble and now asserts that the generated custom text strips it out.
- Re-ran the real map into `.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v25/`.

## Verification
- `dotnet run --project .tools/MapRepair/src/MapRepair.Smoke/MapRepair.Smoke.csproj`
- `dotnet run --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_runner/MapRepair.Run.csproj -- .tools/MapRepair/chuzhang V2 mod2.851.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v25/chuzhang V2 mod2.851_repaired_current.w3x .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v25/report`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v25/chuzhang V2 mod2.851_repaired_current.w3x war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v25/verify/war3map.wtg`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_archive_probe/MapRepair.ArchiveProbe.csproj -- --extract .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v25/chuzhang V2 mod2.851_repaired_current.w3x war3map.wct .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v25/verify/war3map.wct`
- `dotnet run --no-build --project .planning/workspaces/maprepair-trigger-editor-compatibility/tools/maprepair_wtg_inspect/MapRepair.WtgInspect.csproj -- d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v25/verify/war3map.wtg .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v25/verify/war3map.wct`
- `.\.tools\YDWE\plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe .\.tools\MapRepair\scripts\ydwe_wtg_checker.lua .\.tools\YDWE .\.planning\workspaces\maprepair-trigger-editor-compatibility\tmp\current-rerun-v25\verify\war3map.wtg`
- `current-rerun-v25` kept:
  - `triggerCount = 569`
  - `customTextCount = 468`
  - `GuiEventNodeCount = 257`
  - `extensionNodes = []`
- Raw `v25` `war3map.wct` now has:
  - `468/468` non-empty custom-text slots with `TESH` headers
  - early slots `001`-`016` starting with editor-style `TESH` headers instead of bare function declarations
  - decorative slash-only preambles removed from the first failing front slice

## Current Continuation Target
- Manual editor-side validation against `.planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v25/chuzhang V2 mod2.851_repaired_current.w3x`.
- If the editor still stops near `16/569`, treat that as evidence that matching the healthy raw `WCT` editor header shape was necessary but not sufficient, and inspect the remaining early custom-text body shape below the new `TESH` header.
