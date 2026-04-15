# MapRepair V25 Current Implementation

## Snapshot Goal
- Record the current `MapRepair` V25 approach now that the repaired map can be opened by the target Warcraft editor.
- Freeze the current behavior before the next fidelity bugfix round.

## User-Confirmed Baseline
- V25 can now be opened.
- Remaining issues reported by the user:
- Buff object data is not readable in the editor.
- Ability names are lost and fall back to template names.
- Item, destructable, doodad, and unit names show the same fallback-to-template behavior.
- Imported-file names become blank and the displayed path becomes `war3mapImported\`.

## Evidence Used
- `.tools/MapRepair/src/MapRepair.Core/MapRepairService.cs`
- `.tools/MapRepair/src/MapRepair.Core/Internal/SlkObjectRebuilder.cs`
- `.tools/MapRepair/src/MapRepair.Core/Internal/ObjectDataFileWriter.cs`
- `.tools/MapRepair/src/MapRepair.Core/Internal/ObjectMetadataLoader.cs`
- `.tools/MapRepair/src/MapRepair.Core/Internal/ImportListWriter.cs`
- `.tools/MapRepair/src/MapRepair.Core/Internal/War3ImportFileReader.cs`
- `.tools/MapRepair/chuzhang V2 mod2.851_repair_report_v25/repair-report.md`
- `.tools/MapRepair/chuzhang V2 mod2.851_repaired_v25_diag/diagnostic-variants.md`

## Current V25 Pipeline

### 1. Archive read and preservation
- `MapRepairService.Repair(...)` opens the source MPQ and enumerates candidate names from:
- a built-in standard-entry list
- `(listfile)` when readable
- `war3map.imp` when readable
- Readable files are copied into `outputEntries`.
- Unreadable files are omitted from the repaired map, but their raw compressed/encrypted payload can still be backed up into the repair-report directory.

### 2. Object-data rebuild
- `SlkObjectRebuilder` rebuilds:
- `war3map.w3u` from map-embedded `unitdata.slk`, `UnitAbilities.slk`, `UnitBalance.slk`, `unitUI.slk`, `unitweapons.slk`
- `war3map.w3t` from map-embedded `ItemData.slk`
- `war3map.w3h` from map-embedded `AbilityBuffData.slk`
- `war3map.w3q` from map-embedded `upgradedata.slk`
- `war3map.w3a` from map-embedded `AbilityData.slk`
- Stock metadata comes from the Warcraft install archives through `ObjectMetadataLoader`.
- Units/items/buffs use the generic `BuildObjectData(...)` path.
- Abilities/upgrades use specialized paths that write level/pointer metadata into each modification record.

### 3. Object-data write shape
- `ObjectDataFileWriter` writes version `2`.
- It splits objects into original rows and custom rows.
- For unit/item/buff generic rebuild it does not write level/pointer fields.
- For ability/upgrade rebuild it does write level/pointer fields.
- String values are emitted as null-terminated UTF-8 strings.

### 4. Import rebuild
- After repair entries are assembled, V25 rebuilds `war3map.imp` from `outputEntries.Keys`.
- `ImportListWriter.CollectImportablePaths(...)` treats any non-`war3map.*` archive entry as an import candidate.
- `ImportListWriter.Write(...)` sorts distinct paths and writes one fixed flag byte for every entry before the null-terminated path string.
- No original import flags, path modes, or order are preserved.

### 5. Fallback panels/templates
- Missing `war3map.wtg` / `war3map.wct` are restored from templates.
- Missing `war3map.w3r`, `war3map.w3c`, `war3map.w3s` can be inferred from `war3map.j`, then overwritten from script inference again later in the pipeline.
- Missing `war3map.wpm`, `war3map.doo`, and `war3mapUnits.doo` are rebuilt as minimal empty files.

### 6. Final write/report
- V25 rewrites `(listfile)` from the repaired entry set.
- The repaired archive is written as a new MPQ.
- A repair report is emitted with preserved/generated/omitted files and warnings.

## V25 Report Snapshot
- Generated files recorded by the report:
- `war3map.imp`
- `war3map.w3a`
- `war3map.w3c`
- `war3map.w3h`
- `war3map.w3q`
- `war3map.w3r`
- `war3map.w3s`
- `war3map.w3t`
- `war3map.w3u`
- `war3map.wct`
- `war3map.wtg`
- `war3mapUnits.doo`
- Rebuild counts recorded by the report:
- unit: 620
- item: 657
- buff: 12
- upgrade: 2
- ability: 704
- imports regenerated: 176
- Imported payload files are still present by readable names, including multiple `war3mapImported\*.blp` entries.

## Current Likely Causes

### 1. Buff object data not readable
- Current path uses the same generic object-data rebuild/write flow as unit/item data.
- This is the main compatibility risk for `war3map.w3h` because Buff data is still failing in the editor despite being generated.
- Most likely debug targets:
- verify whether `war3map.w3h` needs a format-specific writer/layout
- verify whether base-id guessing for custom buffs is wrong
- verify whether the source `AbilityBuffData.slk` actually carries the needed custom data

### 2. Names fall back to template names across many object types
- This looks like a shared issue, not isolated to one object type.
- The current rebuild path depends on map-embedded SLKs plus stock metadata.
- If the protector stripped custom names from the embedded SLKs, V25 can still reconstruct object existence and many numeric fields but will naturally fall back to stock names.
- If the names are still present in SLK, the next likely failure points are:
- metadata mapping to the wrong raw-code field
- base-id guess causing the name diff to be suppressed
- serialization layout that makes the editor ignore string modifications

### 3. Imported-file names/paths become blank
- This is currently the strongest code-level suspect.
- `ImportListWriter` writes every import entry with one fixed flag byte and does not preserve original import metadata.
- `War3ImportFileReader` also normalizes every path into both the original path and a forced `war3mapImported\...` variant when reading.
- The current design is good enough to rediscover files by archive name, but not necessarily good enough to regenerate a semantically correct import list for the editor.

## Immediate Execution Order
- First: prove and fix `war3map.imp` semantics.
- Second: inspect whether custom names still exist in the map-embedded SLKs for the affected object types.
- Third: inspect whether `war3map.w3h` needs a dedicated format path.

## Continuation Notes
- This report is a baseline snapshot only. No runtime behavior was changed while creating it.
- The goal of the next round is not "make more files generate"; it is "keep V25 openable while restoring editor fidelity".
