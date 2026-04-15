namespace MapRepair.Core.Internal;

internal sealed record TerrainInfo(
    int CornerWidth,
    int CornerHeight,
    int MapWidth,
    int MapHeight,
    int PathingWidth,
    int PathingHeight,
    float CenterOffsetX,
    float CenterOffsetY);
