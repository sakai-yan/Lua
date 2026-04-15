# MapRepair v83: Canon YDWE Open-Chain Audit

## Goal
- Prove whether `current-rerun-v30` still fails inside the real YDWE open chain or only above the editor-visible trigger panel.

## What Changed
- Added `.planning/workspaces/maprepair-trigger-editor-compatibility/tools/canon_ydwe_frontend_probe.lua`.
- Added `.planning/workspaces/maprepair-trigger-editor-compatibility/tools/canon_ydwe_chain_probe.ps1`.
- Added `.planning/workspaces/maprepair-trigger-editor-compatibility/tools/canon_ydwe_chain_probe.cmd`.
- Switched active YDWE validation from historical `.tools/YDWE` assumptions to `.canon/YDWE`.

## Validation
- `canon_ydwe_chain_probe.cmd .planning/workspaces/maprepair-trigger-editor-compatibility/tmp/current-rerun-v30`
- Canon checker:
  - `PASS`
- Canon `--debug-missing`:
  - `PASS`
- Canon `wtgloader`:
  - `CHECK PASS`
- Canon `frontend_trg`:
  - `PASS`
- Canon `frontend_wtg`:
  - `PASS`
  - `triggerCount = 569`
- Canon editor open archived in:
  - `tmp/current-rerun-v30/chain-audit-kkwe.log`

## Findings
- `current-rerun-v30` now survives the full canon headless parse chain.
- The canon editor log reaches:
  - `Open map`
  - `virtual_mpq 'triggerdata'`
  - `virtual_mpq 'triggerstrings'`
- The unresolved layer is therefore above the byte-level checker and above canonical TriggerData merge.
- Early hook-only GUI names in the first `32` repaired triggers: `0`.
- That means the remaining failure is not currently explained by:
  - broken `war3map.wtg` byte layout
  - `wtgloader` unknown-UI fallback
  - canonical `frontend_trg`
  - canonical `frontend_wtg`
  - a first-32 trigger that only survives because of `SetGUIId_Hook.cpp`

## Next Target
- The next truthful early survivor remains `018-hantmdweiacunzhuang1`.
- Follow-up order after that:
  - `020-tmdjingong009`
  - `001-SET`
  - `002-SET2`
