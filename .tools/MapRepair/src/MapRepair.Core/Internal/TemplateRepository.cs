namespace MapRepair.Core.Internal;

internal sealed class TemplateRepository
{
    private readonly RepositoryPaths _paths;

    public TemplateRepository(RepositoryPaths paths)
    {
        _paths = paths;
    }

    public RepositoryPaths Paths => _paths;

    public DecodedTextFile ReadMapInfoTemplate() => TextFileCodec.Read(_paths.W3iIniPath);

    public byte[] ReadTerrainTemplate() => File.ReadAllBytes(_paths.TemplateTerrainPath);

    public byte[] ReadPathingTemplate() => File.ReadAllBytes(_paths.TemplatePathingPath);

    public byte[] ReadDoodadsTemplate() => File.ReadAllBytes(_paths.TemplateDoodadsPath);

    public byte[] ReadUnitsTemplate() => File.ReadAllBytes(_paths.TemplateUnitsPath);

    public byte[] ReadTriggerDataTemplate() => File.ReadAllBytes(_paths.TemplateTriggerDataPath);

    public byte[] ReadTriggerStringsTemplate() => File.ReadAllBytes(_paths.TemplateTriggerStringsPath);

    public byte[] ReadShadowTemplate() => File.ReadAllBytes(_paths.TemplateShadowPath);
}
