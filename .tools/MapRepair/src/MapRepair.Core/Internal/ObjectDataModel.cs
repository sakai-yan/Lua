namespace MapRepair.Core.Internal;

internal enum ObjectValueKind
{
    Int = 0,
    Real = 1,
    Unreal = 2,
    String = 3
}

internal sealed record ObjectModification(
    string RawCode,
    ObjectValueKind ValueKind,
    object Value,
    int Level = 0,
    int Pointer = 0);

internal sealed record ObjectDefinition(
    string BaseId,
    string NewId,
    bool IsCustom,
    IReadOnlyList<ObjectModification> Modifications);
