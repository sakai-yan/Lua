# MapRepair v84: Canon Manual-Open Log-Order Correction

## Goal
- Correct the `v83` manual-open interpretation by validating the canon YDWE open path against the last `Open map` event instead of against the whole accumulated `kkwe.log`.

## What Changed
- Updated `.planning/workspaces/maprepair-trigger-editor-compatibility/tools/canon_ydwe_chain_probe.ps1` so manual-open classification now:
  - scopes progress markers to the last fresh `Open map`
  - records whether the editor stayed alive or exited inside the observation window
  - records post-open `triggerdata.lua` UI-load evidence separately from whole-log startup markers
- Re-ran the corrected probe against `tmp/current-rerun-v30/`.

## Canon Source Chain
- `.canon/YDWE/source/Development/Component/script/ydwe/w3x2lni/open_map.lua`
  - logs `Open map`
  - calls `wtgloader(mappath)`
- `.canon/YDWE/source/Development/Component/script/ydwe/w3x2lni/wtgloader.lua`
  - loads trigger metadata through `triggerdata.lua`
  - returns immediately when the checker passes
- `.canon/YDWE/source/Development/Component/script/ydwe/triggerdata.lua`
  - logs `Loading ui from ...` for each UI root it merges
- `.canon/YDWE/source/Development/Component/script/ydwe/uiloader.lua`
  - emits `virtual_mpq 'triggerdata'` / `virtual_mpq 'triggerstrings'` as startup watcher callbacks
  - those markers are not reliable proof of progress after the last `Open map`

## Validation
- `canon_ydwe_chain_probe.cmd .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v30`
- Headless results:
  - checker = pass
  - `--debug-missing` = pass
  - `wtgloader` = `CHECK PASS`
  - `frontend_trg` = pass
  - `frontend_wtg` = pass
  - `triggerCount = 569`
- Corrected manual-open results:
  - last fresh `Open map` marker = present
  - last whole-log `triggerdata` marker line < last `Open map` line
  - last whole-log `triggerstrings` marker line < last `Open map` line
  - post-open `triggerdata.lua` UI loads = `20`
  - post-open `triggerdata` / `triggerstrings` markers = absent
  - editor exits before the `25`-second observation window ends

## Findings
- `v83` overclaimed the manual-open progress because it checked for `triggerdata` / `triggerstrings` anywhere in the log, not only after the last `Open map`.
- `v30` still clears the full canon headless parser chain, so the blocking gap is no longer:
  - WTG byte layout
  - unknown-UI metadata recovery
  - canonical `frontend_trg`
  - canonical `frontend_wtg`
- The unresolved gap now stays inside the real editor open path after `open_map.lua` / `wtgloader` begins loading UI metadata and before a proven trigger-panel load.
- The first truthful early survivor remains `018-hantmdweiacunzhuang1`, because:
  - `016-tmdlimititemlvl` is now a compact GUI `IfThenElseMultiple`
  - `017-SET 4` is pure GUI
  - `018-hantmdweiacunzhuang1` still mixes one recovered `IfThenElseMultiple` with `11` `CustomScriptCode` nodes and raw helper-guard `if` / `else` / `endif` wrappers

## Next Target
- Inspect `018-hantmdweiacunzhuang1` first.
- Follow-up order after that:
  - `020-tmdjingong009`
  - `001-SET`
  - `002-SET2`
