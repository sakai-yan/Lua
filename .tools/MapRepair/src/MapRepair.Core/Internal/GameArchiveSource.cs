using MapRepair.Core.Internal.Mpq;

namespace MapRepair.Core.Internal;

internal sealed class GameArchiveSource
{
    private readonly WarcraftArchivePaths _archivePaths;

    public GameArchiveSource(WarcraftArchivePaths archivePaths)
    {
        _archivePaths = archivePaths;
    }

    public WarcraftArchivePaths ArchivePaths => _archivePaths;

    public byte[]? TryRead(string fileName)
    {
        foreach (var archivePath in _archivePaths.ArchivePaths)
        {
            using var archive = MpqArchiveReader.Open(archivePath);
            var result = archive.ReadFile(fileName);
            if (result.Exists && result.Readable && result.Data is not null)
            {
                return result.Data;
            }
        }

        return null;
    }
}
