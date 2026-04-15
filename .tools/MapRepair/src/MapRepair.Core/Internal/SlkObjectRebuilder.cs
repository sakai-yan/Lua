using System.Globalization;
using MapRepair.Core.Internal.Slk;

namespace MapRepair.Core.Internal;

internal sealed record RebuiltObjectData(
    string FileName,
    byte[] Data,
    IReadOnlyList<string> Warnings);

internal sealed class SlkObjectRebuilder
{
    private static readonly HashSet<string> KnownIntLikeMetadataTypes = new(StringComparer.OrdinalIgnoreCase)
    {
        "deathType"
    };

    private static readonly HashSet<string> KnownStringLikeMetadataTypes = new(StringComparer.OrdinalIgnoreCase)
    {
        "char"
    };

    private static readonly HashSet<string> UnitOverlayFields = new(StringComparer.OrdinalIgnoreCase)
    {
        "Name"
    };

    private static readonly HashSet<string> AbilityOverlayFields = new(StringComparer.OrdinalIgnoreCase)
    {
        "Name",
        "EditorSuffix"
    };

    private readonly GameArchiveSource _gameArchiveSource;
    private readonly ObjectMetadataLoader _metadataLoader;

    public SlkObjectRebuilder(GameArchiveSource gameArchiveSource)
    {
        _gameArchiveSource = gameArchiveSource;
        _metadataLoader = new ObjectMetadataLoader(gameArchiveSource);
    }

    public IReadOnlyList<RebuiltObjectData> Rebuild(IReadOnlyDictionary<string, byte[]> mapEntries)
    {
        var results = new List<RebuiltObjectData>();
        var profileOverrides = ArchiveProfileTextOverlay.BuildDifferences(mapEntries, _gameArchiveSource);
        var rawBuffProfileOverrides = ArchiveProfileTextOverlay.BuildRaw(mapEntries);

        AddIfNotNull(results, RebuildUnits(mapEntries, profileOverrides));
        AddIfNotNull(results, RebuildItems(mapEntries, profileOverrides));
        AddIfNotNull(results, RebuildBuffs(mapEntries, rawBuffProfileOverrides));
        AddIfNotNull(results, RebuildUpgrades(mapEntries, profileOverrides));
        AddIfNotNull(results, RebuildAbilities(mapEntries, profileOverrides));

        return results;
    }

    private RebuiltObjectData? RebuildUnits(
        IReadOnlyDictionary<string, byte[]> mapEntries,
        IReadOnlyDictionary<string, IReadOnlyDictionary<string, string>> profileOverrides)
    {
        var mapTables = LoadTables(
            mapEntries,
            new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                ["UnitData"] = @"units\unitdata.slk",
                ["UnitAbilities"] = @"Units\UnitAbilities.slk",
                ["UnitBalance"] = @"Units\UnitBalance.slk",
                ["UnitUI"] = @"Units\unitUI.slk",
                ["UnitWeapons"] = @"units\unitweapons.slk"
            });

        if (!mapTables.ContainsKey("UnitData"))
        {
            return null;
        }

        var stockTables = LoadStockTables(mapTables.Keys);
        var metadata = _metadataLoader.LoadUnitMetadata()
            .Where(entry => entry.UseUnit || entry.UseHero || entry.UseBuilding)
            .ToArray();

        return BuildObjectData("war3map.w3u", mapTables, stockTables, metadata, "unit", profileOverrides, UnitOverlayFields);
    }

    private RebuiltObjectData? RebuildItems(
        IReadOnlyDictionary<string, byte[]> mapEntries,
        IReadOnlyDictionary<string, IReadOnlyDictionary<string, string>> profileOverrides)
    {
        var mapTables = LoadTables(
            mapEntries,
            new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                ["ItemData"] = @"Units\ItemData.slk"
            });

        if (!mapTables.ContainsKey("ItemData"))
        {
            return null;
        }

        var stockTables = LoadStockTables(mapTables.Keys);
        var metadata = _metadataLoader.LoadUnitMetadata()
            .Where(entry => entry.UseItem)
            .ToArray();

        return BuildObjectData("war3map.w3t", mapTables, stockTables, metadata, "item", profileOverrides);
    }

    private RebuiltObjectData? RebuildBuffs(
        IReadOnlyDictionary<string, byte[]> mapEntries,
        IReadOnlyDictionary<string, IReadOnlyDictionary<string, string>> profileOverrides)
    {
        var mapTables = LoadTables(
            mapEntries,
            new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                ["AbilityBuffData"] = @"units\abilitybuffdata.slk"
            });

        if (!mapTables.ContainsKey("AbilityBuffData"))
        {
            return null;
        }

        var stockTables = LoadStockTables(mapTables.Keys);
        var metadata = _metadataLoader.LoadAbilityBuffMetadata().ToArray();

        return BuildObjectData("war3map.w3h", mapTables, stockTables, metadata, "buff", profileOverrides);
    }

    private RebuiltObjectData? RebuildUpgrades(
        IReadOnlyDictionary<string, byte[]> mapEntries,
        IReadOnlyDictionary<string, IReadOnlyDictionary<string, string>> profileOverrides)
    {
        var mapTables = LoadTables(
            mapEntries,
            new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                ["UpgradeData"] = @"units\upgradedata.slk"
            });

        if (!mapTables.ContainsKey("UpgradeData"))
        {
            return null;
        }

        var stockTables = LoadStockTables(mapTables.Keys);
        var metadata = _metadataLoader.LoadUpgradeMetadata().ToArray();
        return BuildUpgradeObjectData(mapTables["UpgradeData"], stockTables.GetValueOrDefault("UpgradeData"), metadata, profileOverrides);
    }

    private RebuiltObjectData? RebuildAbilities(
        IReadOnlyDictionary<string, byte[]> mapEntries,
        IReadOnlyDictionary<string, IReadOnlyDictionary<string, string>> profileOverrides)
    {
        var mapTables = LoadTables(
            mapEntries,
            new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                ["AbilityData"] = @"Units\AbilityData.slk"
            });

        if (!mapTables.ContainsKey("AbilityData"))
        {
            return null;
        }

        var stockTables = LoadStockTables(mapTables.Keys);
        var metadata = _metadataLoader.LoadAbilityMetadata().ToArray();
        return BuildAbilityObjectData(mapTables["AbilityData"], stockTables.GetValueOrDefault("AbilityData"), metadata, profileOverrides);
    }

    private RebuiltObjectData? BuildObjectData(
        string outputFileName,
        IReadOnlyDictionary<string, SlkTable> mapTables,
        IReadOnlyDictionary<string, SlkTable> stockTables,
        IReadOnlyList<ObjectMetadataEntry> metadata,
        string objectKindLabel,
        IReadOnlyDictionary<string, IReadOnlyDictionary<string, string>> profileOverrides,
        IReadOnlySet<string>? allowedProfileFields = null)
    {
        var mapRows = MergeRows(mapTables);
        var stockRows = MergeRows(stockTables);

        if (mapRows.Count == 0)
        {
            return null;
        }

        var objects = new List<ObjectDefinition>();
        var warnings = new List<string>();

        foreach (var mapRow in mapRows.Values)
        {
            var isCustom = !stockRows.TryGetValue(mapRow.Id, out var stockRow);
            var baseId = isCustom
                ? GuessBaseId(mapRow, stockRows.Values)
                : mapRow.Id;
            if (isCustom && stockRows.TryGetValue(baseId, out var guessedBaseRow))
            {
                stockRow = guessedBaseRow;
            }

            var modifications = BuildModifications(mapRow, stockRow, metadata, out var modificationWarnings);
            if (profileOverrides.TryGetValue(mapRow.Id, out var profileOverride))
            {
                ApplyProfileOverrides(metadata, profileOverride, modifications, allowedProfileFields);
            }
            warnings.AddRange(modificationWarnings);

            if (!isCustom && modifications.Count == 0)
            {
                continue;
            }

            objects.Add(new ObjectDefinition(
                baseId,
                mapRow.Id,
                isCustom,
                modifications));
        }

        if (objects.Count == 0)
        {
            return null;
        }

        warnings.Insert(0, $"已从 {objectKindLabel} SLK 重建 {objects.Count} 个对象到 `{outputFileName}`。");
        return new RebuiltObjectData(
            outputFileName,
            ObjectDataFileWriter.Write(objects, originalModificationUsesBaseIdTerminator: false),
            warnings.Distinct(StringComparer.OrdinalIgnoreCase).ToArray());
    }

    private IReadOnlyDictionary<string, SlkTable> LoadTables(
        IReadOnlyDictionary<string, byte[]> mapEntries,
        IReadOnlyDictionary<string, string> fileNameByTable)
    {
        var tables = new Dictionary<string, SlkTable>(StringComparer.OrdinalIgnoreCase);
        foreach (var entry in fileNameByTable)
        {
            if (!mapEntries.TryGetValue(entry.Value, out var data))
            {
                continue;
            }

            tables[entry.Key] = SlkTableParser.Parse(entry.Key, data);
        }

        return tables;
    }

    private IReadOnlyDictionary<string, SlkTable> LoadStockTables(IEnumerable<string> tableNames)
    {
        var tables = new Dictionary<string, SlkTable>(StringComparer.OrdinalIgnoreCase);
        foreach (var tableName in tableNames.Distinct(StringComparer.OrdinalIgnoreCase))
        {
            var archivePath = tableName switch
            {
                "UnitData" => @"Units\unitdata.slk",
                "UnitAbilities" => @"Units\UnitAbilities.slk",
                "UnitBalance" => @"Units\UnitBalance.slk",
                "UnitUI" => @"Units\unitUI.slk",
                "UnitWeapons" => @"Units\unitweapons.slk",
                "ItemData" => @"Units\ItemData.slk",
                "AbilityBuffData" => @"Units\AbilityBuffData.slk",
                "UpgradeData" => @"Units\upgradedata.slk",
                "AbilityData" => @"Units\AbilityData.slk",
                _ => string.Empty
            };

            if (string.IsNullOrWhiteSpace(archivePath))
            {
                continue;
            }

            var data = _gameArchiveSource.TryRead(archivePath);
            if (data is null)
            {
                continue;
            }

            tables[tableName] = SlkTableParser.Parse(tableName, data);
        }

        return tables;
    }

    private static Dictionary<string, CombinedSlkRow> MergeRows(IReadOnlyDictionary<string, SlkTable> tables)
    {
        var merged = new Dictionary<string, CombinedSlkRow>(StringComparer.OrdinalIgnoreCase);
        foreach (var table in tables.Values)
        {
            foreach (var row in table.Rows.Values)
            {
                if (!merged.TryGetValue(row.Id, out var combined))
                {
                    combined = new CombinedSlkRow(row.Id);
                    merged[row.Id] = combined;
                }

                combined.AddTable(table.Name, row.Values);
            }
        }

        return merged;
    }

    private static List<ObjectModification> BuildModifications(
        CombinedSlkRow mapRow,
        CombinedSlkRow? baseRow,
        IReadOnlyList<ObjectMetadataEntry> metadata,
        out IReadOnlyList<string> warnings)
    {
        var modifications = new List<ObjectModification>();
        var warningList = new List<string>();

        foreach (var entry in metadata)
        {
            if (!mapRow.TryGetValue(entry.SlkTable, entry.Field, out var mapValue))
            {
                continue;
            }

            if (!TryNormalizeRawValue(entry, mapValue, out var normalizedMapValue))
            {
                continue;
            }

            if (baseRow is not null &&
                baseRow.TryGetValue(entry.SlkTable, entry.Field, out var baseValue) &&
                TryNormalizeRawValue(entry, baseValue, out var normalizedBaseValue) &&
                string.Equals(normalizedMapValue, normalizedBaseValue, StringComparison.Ordinal))
            {
                continue;
            }

            if (!TryBuildModification(entry, normalizedMapValue, out var modification))
            {
                warningList.Add($"无法将 SLK 字段 `{entry.SlkTable}/{entry.Field}` 的值 `{mapValue}` 映射到物编字段 `{entry.RawCode}`。");
                continue;
            }

            modifications.Add(modification);
        }

        warnings = warningList;
        return modifications;
    }

    private static RebuiltObjectData? BuildAbilityObjectData(
        SlkTable mapTable,
        SlkTable? stockTable,
        IReadOnlyList<ObjectMetadataEntry> metadata,
        IReadOnlyDictionary<string, IReadOnlyDictionary<string, string>> profileOverrides)
    {
        if (stockTable is null)
        {
            return null;
        }

        var objects = new List<ObjectDefinition>();
        var warnings = new List<string>();

        foreach (var row in mapTable.Rows.Values)
        {
            var values = row.Values;
            var isCustom = !stockTable.Rows.ContainsKey(row.Id);
            var baseId = isCustom
                ? GuessAbilityBaseId(row, stockTable)
                : row.Id;
            stockTable.Rows.TryGetValue(baseId, out var baseRow);
            var abilitySection = ResolveAbilitySection(baseId, values, baseRow?.Values);

            var modifications = BuildAbilityModifications(baseId, abilitySection, values, baseRow?.Values, metadata, warnings);
            if (profileOverrides.TryGetValue(row.Id, out var profileOverride))
            {
                ApplyAbilityProfileOverrides(baseId, abilitySection, metadata, profileOverride, modifications, AbilityOverlayFields);
            }
            if (!isCustom && modifications.Count == 0)
            {
                continue;
            }

            objects.Add(new ObjectDefinition(baseId, row.Id, isCustom, modifications));
        }

        if (objects.Count == 0)
        {
            return null;
        }

        warnings.Insert(0, $"已从 ability SLK 重建 {objects.Count} 个对象到 `war3map.w3a`。");
        return new RebuiltObjectData(
            "war3map.w3a",
            ObjectDataFileWriter.Write(objects, includeLevelAndPointer: true, originalModificationUsesBaseIdTerminator: true),
            warnings.Distinct(StringComparer.OrdinalIgnoreCase).ToArray());
    }

    private static RebuiltObjectData? BuildUpgradeObjectData(
        SlkTable mapTable,
        SlkTable? stockTable,
        IReadOnlyList<ObjectMetadataEntry> metadata,
        IReadOnlyDictionary<string, IReadOnlyDictionary<string, string>> profileOverrides)
    {
        if (stockTable is null)
        {
            return null;
        }

        var objects = new List<ObjectDefinition>();
        var warnings = new List<string>();

        foreach (var row in mapTable.Rows.Values)
        {
            var values = row.Values;
            var isCustom = !stockTable.Rows.ContainsKey(row.Id);
            var baseId = row.Id;
            stockTable.Rows.TryGetValue(baseId, out var baseRow);

            var modifications = BuildUpgradeModifications(values, baseRow?.Values, metadata, warnings);
            if (profileOverrides.TryGetValue(row.Id, out var profileOverride))
            {
                ApplyUpgradeProfileOverrides(metadata, profileOverride, modifications);
            }
            if (!isCustom && modifications.Count == 0)
            {
                continue;
            }

            objects.Add(new ObjectDefinition(baseId, row.Id, isCustom, modifications));
        }

        if (objects.Count == 0)
        {
            return null;
        }

        warnings.Insert(0, $"已从 upgrade SLK 重建 {objects.Count} 个对象到 `war3map.w3q`。");
        return new RebuiltObjectData(
            "war3map.w3q",
            ObjectDataFileWriter.Write(objects, includeLevelAndPointer: true, originalModificationUsesBaseIdTerminator: true),
            warnings.Distinct(StringComparer.OrdinalIgnoreCase).ToArray());
    }

    private static List<ObjectModification> BuildAbilityModifications(
        string baseId,
        string abilitySection,
        IReadOnlyDictionary<string, string> values,
        IReadOnlyDictionary<string, string>? baseValues,
        IReadOnlyList<ObjectMetadataEntry> metadata,
        ICollection<string> warnings)
    {
        var modifications = new List<ObjectModification>();

        foreach (var entry in values)
        {
            if (entry.Key is "alias" or "code")
            {
                continue;
            }

            if (!TryResolveAbilityMetadata(baseId, abilitySection, entry.Key, metadata, out var metadataEntry, out var level, out var pointer))
            {
                continue;
            }

            if (!TryNormalizeRawValue(metadataEntry, entry.Value, out var normalizedValue))
            {
                continue;
            }

            if (baseValues is not null &&
                baseValues.TryGetValue(entry.Key, out var baseValue) &&
                TryNormalizeRawValue(metadataEntry, baseValue, out var normalizedBaseValue) &&
                string.Equals(normalizedValue, normalizedBaseValue, StringComparison.Ordinal))
            {
                continue;
            }

            if (!TryBuildModification(metadataEntry, normalizedValue, out var modification))
            {
                warnings.Add($"无法将能力字段 `{entry.Key}` 的值 `{entry.Value}` 映射到 `{metadataEntry.RawCode}`。");
                continue;
            }

            modifications.Add(modification with { Level = level, Pointer = pointer });
        }

        return modifications;
    }

    private static List<ObjectModification> BuildUpgradeModifications(
        IReadOnlyDictionary<string, string> values,
        IReadOnlyDictionary<string, string>? baseValues,
        IReadOnlyList<ObjectMetadataEntry> metadata,
        ICollection<string> warnings)
    {
        var modifications = new List<ObjectModification>();

        foreach (var entry in values)
        {
            if (entry.Key is "upgradeid")
            {
                continue;
            }

            var metadataEntry = metadata.FirstOrDefault(candidate =>
                candidate.SlkTable.Equals("UpgradeData", StringComparison.OrdinalIgnoreCase) &&
                candidate.Field.Equals(entry.Key, StringComparison.OrdinalIgnoreCase));
            if (metadataEntry is null)
            {
                continue;
            }

            if (!TryNormalizeRawValue(metadataEntry, entry.Value, out var normalizedValue))
            {
                continue;
            }

            if (baseValues is not null &&
                baseValues.TryGetValue(entry.Key, out var baseValue) &&
                TryNormalizeRawValue(metadataEntry, baseValue, out var normalizedBaseValue) &&
                string.Equals(normalizedValue, normalizedBaseValue, StringComparison.Ordinal))
            {
                continue;
            }

            if (!TryBuildModification(metadataEntry, normalizedValue, out var modification))
            {
                warnings.Add($"无法将升级字段 `{entry.Key}` 的值 `{entry.Value}` 映射到 `{metadataEntry.RawCode}`。");
                continue;
            }

            modifications.Add(modification with { Level = 1, Pointer = 0 });
        }

        return modifications;
    }

    private static void ApplyProfileOverrides(
        IReadOnlyList<ObjectMetadataEntry> metadata,
        IReadOnlyDictionary<string, string> profileOverride,
        List<ObjectModification> modifications,
        IReadOnlySet<string>? allowedProfileFields = null)
    {
        var metadataByField = metadata
            .GroupBy(entry => entry.Field, StringComparer.OrdinalIgnoreCase)
            .ToDictionary(group => group.Key, group => group.ToArray(), StringComparer.OrdinalIgnoreCase);

        foreach (var entry in profileOverride)
        {
            if (allowedProfileFields is not null && !allowedProfileFields.Contains(entry.Key))
            {
                continue;
            }

            if (!metadataByField.TryGetValue(entry.Key, out var metadataEntries))
            {
                continue;
            }

            var usedIndexes = metadataEntries
                .Where(candidate => candidate.Index > 0)
                .Select(candidate => candidate.Index)
                .ToHashSet();
            var nextImplicitIndex = 1;

            foreach (var metadataEntry in metadataEntries.OrderBy(candidate => candidate.Index <= 0 ? 0 : candidate.Index))
            {
                var effectiveIndex = metadataEntries.Length > 1 && metadataEntry.Index <= 0
                    ? GetNextImplicitIndex()
                    : metadataEntry.Index;

                if (!TryNormalizeRawValue(entry.Value, effectiveIndex, out var normalizedValue))
                {
                    continue;
                }

                if (!TryBuildModification(metadataEntry, normalizedValue, out var modification))
                {
                    continue;
                }

                ReplaceModification(modifications, modification, includeLevelAndPointer: false);
            }

            int GetNextImplicitIndex()
            {
                while (usedIndexes.Contains(nextImplicitIndex))
                {
                    nextImplicitIndex++;
                }

                usedIndexes.Add(nextImplicitIndex);
                return nextImplicitIndex++;
            }
        }
    }

    private static void ApplyAbilityProfileOverrides(
        string baseId,
        string abilitySection,
        IReadOnlyList<ObjectMetadataEntry> metadata,
        IReadOnlyDictionary<string, string> profileOverride,
        List<ObjectModification> modifications,
        IReadOnlySet<string>? allowedProfileFields = null)
    {
        foreach (var entry in profileOverride)
        {
            if (allowedProfileFields is not null && !allowedProfileFields.Contains(entry.Key))
            {
                continue;
            }

            if (!TryResolveAbilityMetadata(baseId, abilitySection, entry.Key, metadata, out var metadataEntry, out var level, out var pointer))
            {
                continue;
            }

            if (!TryNormalizeRawValue(metadataEntry, entry.Value, out var normalizedValue))
            {
                continue;
            }

            if (!TryBuildModification(metadataEntry, normalizedValue, out var modification))
            {
                continue;
            }

            ReplaceModification(modifications, modification with { Level = level, Pointer = pointer }, includeLevelAndPointer: true);
        }
    }

    private static void ApplyUpgradeProfileOverrides(
        IReadOnlyList<ObjectMetadataEntry> metadata,
        IReadOnlyDictionary<string, string> profileOverride,
        List<ObjectModification> modifications)
    {
        var metadataByField = metadata
            .GroupBy(entry => entry.Field, StringComparer.OrdinalIgnoreCase)
            .ToDictionary(group => group.Key, group => group.First(), StringComparer.OrdinalIgnoreCase);

        foreach (var entry in profileOverride)
        {
            if (!metadataByField.TryGetValue(entry.Key, out var metadataEntry))
            {
                continue;
            }

            if (!TryNormalizeRawValue(metadataEntry, entry.Value, out var normalizedValue))
            {
                continue;
            }

            if (!TryBuildModification(metadataEntry, normalizedValue, out var modification))
            {
                continue;
            }

            ReplaceModification(modifications, modification with { Level = 1, Pointer = 0 }, includeLevelAndPointer: true);
        }
    }

    private static void ReplaceModification(
        List<ObjectModification> modifications,
        ObjectModification replacement,
        bool includeLevelAndPointer)
    {
        for (var index = modifications.Count - 1; index >= 0; index--)
        {
            var current = modifications[index];
            var matches = includeLevelAndPointer
                ? current.RawCode.Equals(replacement.RawCode, StringComparison.OrdinalIgnoreCase) &&
                  current.Level == replacement.Level &&
                  current.Pointer == replacement.Pointer
                : current.RawCode.Equals(replacement.RawCode, StringComparison.OrdinalIgnoreCase);
            if (!matches)
            {
                continue;
            }

            modifications.RemoveAt(index);
        }

        modifications.Add(replacement);
    }

    private static bool TryResolveAbilityMetadata(
        string baseId,
        string abilitySection,
        string slkFieldName,
        IReadOnlyList<ObjectMetadataEntry> metadata,
        out ObjectMetadataEntry metadataEntry,
        out int level,
        out int pointer)
    {
        metadataEntry = default!;
        level = 0;
        pointer = 0;

        if (TryParseAbilityDataField(slkFieldName, out level, out pointer))
        {
            var dataPointer = pointer;
            var dataCandidates = metadata.Where(entry =>
                    entry.SlkTable.Equals("AbilityData", StringComparison.OrdinalIgnoreCase) &&
                    entry.Field.Equals("Data", StringComparison.OrdinalIgnoreCase) &&
                    entry.DataIndex == dataPointer)
                .ToArray();

            var selectedDataEntry = SelectAbilityMetadata(baseId, abilitySection, dataCandidates);
            if (selectedDataEntry is null)
            {
                return false;
            }

            metadataEntry = selectedDataEntry;
            return true;
        }

        var coreField = slkFieldName;
        if (TryParseLevelSuffix(slkFieldName, out var fieldWithoutSuffix, out var parsedLevel))
        {
            coreField = fieldWithoutSuffix;
            level = parsedLevel;
        }

        var candidates = metadata.Where(entry =>
                entry.Field.Equals(coreField, StringComparison.OrdinalIgnoreCase))
            .ToArray();
        var abilityDataCandidates = candidates.Where(entry =>
                entry.SlkTable.Equals("AbilityData", StringComparison.OrdinalIgnoreCase))
            .ToArray();
        if (abilityDataCandidates.Length > 0)
        {
            candidates = abilityDataCandidates;
        }

        var selectedEntry = SelectAbilityMetadata(baseId, abilitySection, candidates);
        if (selectedEntry is null)
        {
            return false;
        }

        metadataEntry = selectedEntry;

        if (level == 0 && metadataEntry.Repeat > 0)
        {
            level = 1;
        }

        if (metadataEntry.DataIndex > 0)
        {
            pointer = metadataEntry.DataIndex;
        }

        return true;
    }

    private static ObjectMetadataEntry? SelectAbilityMetadata(
        string baseId,
        string abilitySection,
        IReadOnlyList<ObjectMetadataEntry> candidates)
    {
        if (candidates.Count == 0)
        {
            return null;
        }

        foreach (var candidate in candidates)
        {
            if (MatchesAbilitySpecificTarget(candidate, baseId))
            {
                return candidate;
            }
        }

        if (!string.IsNullOrWhiteSpace(abilitySection))
        {
            var sectionCandidates = candidates
                .Where(candidate =>
                    !candidate.UseSpecific &&
                    candidate.Section.Equals(abilitySection, StringComparison.OrdinalIgnoreCase))
                .ToArray();
            if (sectionCandidates.Length > 0)
            {
                return sectionCandidates[0];
            }
        }

        var genericCandidates = candidates
            .Where(candidate => !candidate.UseSpecific && string.IsNullOrWhiteSpace(candidate.Section))
            .ToArray();
        if (genericCandidates.Length == 1)
        {
            return genericCandidates[0];
        }

        return candidates.Count == 1 ? candidates[0] : null;
    }

    private static bool TryParseAbilityDataField(string fieldName, out int level, out int pointer)
    {
        level = 0;
        pointer = 0;

        if (fieldName.Length < 6 || !fieldName.StartsWith("Data", StringComparison.OrdinalIgnoreCase))
        {
            return false;
        }

        var dataPointerChar = fieldName[4];
        if (!char.IsLetter(dataPointerChar))
        {
            return false;
        }

        if (!int.TryParse(fieldName[5..], NumberStyles.Integer, CultureInfo.InvariantCulture, out level))
        {
            return false;
        }

        pointer = char.ToUpperInvariant(dataPointerChar) - 'A' + 1;
        return pointer > 0;
    }

    private static bool TryParseLevelSuffix(string fieldName, out string coreField, out int level)
    {
        coreField = fieldName;
        level = 0;
        var lastNonDigit = fieldName.Length - 1;
        while (lastNonDigit >= 0 && char.IsDigit(fieldName[lastNonDigit]))
        {
            lastNonDigit--;
        }

        if (lastNonDigit == fieldName.Length - 1 || lastNonDigit < 0)
        {
            return false;
        }

        coreField = fieldName[..(lastNonDigit + 1)];
        return int.TryParse(fieldName[(lastNonDigit + 1)..], NumberStyles.Integer, CultureInfo.InvariantCulture, out level);
    }

    internal static bool TryNormalizeRawValue(ObjectMetadataEntry? entry, string rawValue, out string normalizedValue)
    {
        return TryNormalizeRawValue(rawValue, entry?.Index ?? 0, out normalizedValue);
    }

    internal static bool TryNormalizeRawValue(string rawValue, int index, out string normalizedValue)
    {
        normalizedValue = rawValue;

        if (index <= 0)
        {
            return true;
        }

        var segments = rawValue.Split(',');
        if (index > segments.Length)
        {
            normalizedValue = string.Empty;
            return false;
        }

        normalizedValue = segments[index - 1].Trim();
        return !string.IsNullOrWhiteSpace(normalizedValue);
    }

    internal static bool TryBuildModification(ObjectMetadataEntry entry, string rawValue, out ObjectModification modification)
    {
        modification = new ObjectModification(entry.RawCode, ObjectValueKind.String, rawValue);

        if (entry.Type.Equals("bool", StringComparison.OrdinalIgnoreCase) &&
            TryParseBoolean(rawValue, out var boolValue))
        {
            modification = new ObjectModification(entry.RawCode, ObjectValueKind.Int, boolValue ? 1 : 0);
            return true;
        }

        if (entry.Type.Equals("real", StringComparison.OrdinalIgnoreCase) &&
            float.TryParse(rawValue, NumberStyles.Float, CultureInfo.InvariantCulture, out var realValue))
        {
            modification = new ObjectModification(entry.RawCode, ObjectValueKind.Real, realValue);
            return true;
        }

        if (entry.Type.Equals("unreal", StringComparison.OrdinalIgnoreCase) &&
            float.TryParse(rawValue, NumberStyles.Float, CultureInfo.InvariantCulture, out var unrealValue))
        {
            modification = new ObjectModification(entry.RawCode, ObjectValueKind.Unreal, unrealValue);
            return true;
        }

        if (LooksLikeIntType(entry.Type) &&
            int.TryParse(rawValue, NumberStyles.Integer, CultureInfo.InvariantCulture, out var intValue))
        {
            modification = new ObjectModification(entry.RawCode, ObjectValueKind.Int, intValue);
            return true;
        }

        modification = new ObjectModification(entry.RawCode, ObjectValueKind.String, rawValue);
        return true;
    }

    private static bool TryParseBoolean(string rawValue, out bool value)
    {
        if (rawValue.Equals("TRUE", StringComparison.OrdinalIgnoreCase))
        {
            value = true;
            return true;
        }

        if (rawValue.Equals("FALSE", StringComparison.OrdinalIgnoreCase))
        {
            value = false;
            return true;
        }

        value = false;
        return false;
    }

    private static bool LooksLikeIntType(string type) =>
        KnownIntLikeMetadataTypes.Contains(type) ||
        type.Equals("int", StringComparison.OrdinalIgnoreCase) ||
        type.Equals("bool", StringComparison.OrdinalIgnoreCase) ||
        KnownStringLikeMetadataTypes.Contains(type) == false &&
        type.EndsWith("Flags", StringComparison.OrdinalIgnoreCase) ||
        type.Contains("List", StringComparison.OrdinalIgnoreCase) == false &&
        type.Contains("string", StringComparison.OrdinalIgnoreCase) == false &&
        type.Contains("char", StringComparison.OrdinalIgnoreCase) == false &&
        type.Contains("model", StringComparison.OrdinalIgnoreCase) == false &&
        type.Contains("texture", StringComparison.OrdinalIgnoreCase) == false &&
        type.Contains("icon", StringComparison.OrdinalIgnoreCase) == false &&
        type.Contains("sound", StringComparison.OrdinalIgnoreCase) == false &&
        type.Contains("effect", StringComparison.OrdinalIgnoreCase) == false &&
        type.Contains("race", StringComparison.OrdinalIgnoreCase) == false &&
        type.Contains("Type", StringComparison.OrdinalIgnoreCase) == false;

    private static bool MatchesAbilitySpecificTarget(ObjectMetadataEntry candidate, string baseId)
    {
        if (!candidate.UseSpecific)
        {
            return false;
        }

        var targets = (candidate.SpecificTargets ?? string.Empty)
            .Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
        return targets.Contains(baseId, StringComparer.OrdinalIgnoreCase);
    }

    private static string ResolveAbilitySection(
        string baseId,
        IReadOnlyDictionary<string, string> values,
        IReadOnlyDictionary<string, string>? baseValues)
    {
        if (baseValues is not null &&
            baseValues.TryGetValue("code", out var baseCode) &&
            !string.IsNullOrWhiteSpace(baseCode))
        {
            return baseCode;
        }

        if (values.TryGetValue("code", out var code) &&
            !string.IsNullOrWhiteSpace(code))
        {
            return code;
        }

        return baseId;
    }

    private static string GuessAbilityBaseId(SlkRow row, SlkTable stockTable)
    {
        if (stockTable.Rows.ContainsKey(row.Id))
        {
            return row.Id;
        }

        if (row.Values.TryGetValue("code", out var code) &&
            !string.IsNullOrWhiteSpace(code))
        {
            if (stockTable.Rows.ContainsKey(code))
            {
                return code;
            }

            var familyCandidates = stockTable.Rows.Values
                .Where(candidate =>
                    candidate.Values.TryGetValue("code", out var candidateCode) &&
                    candidateCode.Equals(code, StringComparison.OrdinalIgnoreCase))
                .ToArray();
            if (familyCandidates.Length > 0)
            {
                return GuessBaseId(row.Values, familyCandidates);
            }
        }

        return GuessBaseId(row.Values, stockTable.Rows.Values);
    }

    private static string GuessBaseId(CombinedSlkRow row, IEnumerable<CombinedSlkRow> stockRows)
    {
        var bestScore = int.MinValue;
        var bestId = "hfoo";

        foreach (var candidate in stockRows)
        {
            var score = 0;
            foreach (var ((tableName, fieldName), value) in row.Values)
            {
                if (!candidate.TryGetValue(tableName, fieldName, out var candidateValue))
                {
                    continue;
                }

                if (string.Equals(value, candidateValue, StringComparison.Ordinal))
                {
                    score += fieldName switch
                    {
                        "race" or "unitClass" or "movetp" or "unitSound" => 6,
                        "file" or "Name" or "name" => 8,
                        _ => 1
                    };
                }
            }

            if (score > bestScore)
            {
                bestScore = score;
                bestId = candidate.Id;
            }
        }

        return bestId;
    }

    private static string GuessBaseId(IReadOnlyDictionary<string, string> rowValues, IEnumerable<SlkRow> stockRows)
    {
        var bestScore = int.MinValue;
        var bestId = "AHbz";

        foreach (var candidate in stockRows)
        {
            var score = 0;
            foreach (var (fieldName, value) in rowValues)
            {
                if (!candidate.Values.TryGetValue(fieldName, out var candidateValue))
                {
                    continue;
                }

                if (string.Equals(value, candidateValue, StringComparison.Ordinal))
                {
                    score += fieldName switch
                    {
                        "code" => 12,
                        "DataA" or "DataB" or "DataC" or "DataD" or "DataE" or "DataF" => 8,
                        "Tip" or "Ubertip" or "Name" => 4,
                        _ => 1
                    };
                }
            }

            if (score > bestScore)
            {
                bestScore = score;
                bestId = candidate.Id;
            }
        }

        return bestId;
    }

    private static void AddIfNotNull(ICollection<RebuiltObjectData> results, RebuiltObjectData? value)
    {
        if (value is not null)
        {
            results.Add(value);
        }
    }

    private sealed class CombinedSlkRow
    {
        public CombinedSlkRow(string id)
        {
            Id = id;
        }

        public string Id { get; }

        public Dictionary<(string Table, string Field), string> Values { get; } = new();

        public void AddTable(string tableName, IReadOnlyDictionary<string, string> values)
        {
            foreach (var entry in values)
            {
                Values[(tableName, entry.Key)] = entry.Value;
            }
        }

        public bool TryGetValue(string tableName, string fieldName, out string value) =>
            Values.TryGetValue((tableName, fieldName), out value!);
    }
}
