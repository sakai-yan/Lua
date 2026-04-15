namespace MapRepair.Core.Internal;

internal sealed record ObjectMetadataEntry(
    string RawCode,
    string Field,
    string SlkTable,
    int Index,
    int DataIndex,
    int Repeat,
    string Type,
    string Section,
    bool UseUnit,
    bool UseHero,
    bool UseBuilding,
    bool UseItem,
    bool UseSpecific,
    string? SpecificTargets);
