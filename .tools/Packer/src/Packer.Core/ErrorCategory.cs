namespace Packer.Core;

public enum ErrorCategory
{
    Validation,
    MapperMissing,
    LuaParse,
    MatchKeyEmpty,
    MatchMismatch,
    ExcelDuplicateRow,
    FieldConflict,
    DuplicateUnitId,
    AssetReferenceMissing,
    AssetTargetConflict,
    ModelReferenceParse,
    FileCopy,
    TransformWrite,
    UnitIniWrite,
    OutputWrite
}
