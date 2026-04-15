using System.Text;

namespace MapRepair.Core.Internal.Gui;

internal static class LegacyGuiBinaryCodec
{
    private static readonly Encoding Utf8 = new UTF8Encoding(false);

    public static byte[] WriteWtg(LegacyGuiDocument document)
    {
        using var stream = new MemoryStream();
        using var writer = new BinaryWriter(stream, Utf8, leaveOpen: true);

        writer.Write(Utf8.GetBytes("WTG!"));
        writer.Write(7);
        writer.Write(document.Categories.Count);
        foreach (var category in document.Categories)
        {
            writer.Write(category.Id);
            WriteCString(writer, category.Name);
            writer.Write(category.Comment ? 1 : 0);
        }

        writer.Write(2);
        writer.Write(document.Variables.Count);
        foreach (var variable in document.Variables)
        {
            WriteCString(writer, variable.Name);
            WriteCString(writer, variable.Type);
            writer.Write(1);
            writer.Write(variable.IsArray ? 1 : 0);
            writer.Write(1);
            writer.Write(variable.DefaultValue is null ? 0 : 1);
            WriteCString(writer, variable.DefaultValue ?? string.Empty);
        }

        writer.Write(document.Triggers.Count);
        foreach (var trigger in document.Triggers)
        {
            WriteCString(writer, trigger.Name);
            WriteCString(writer, trigger.Description);
            writer.Write(trigger.Type);
            writer.Write(trigger.Enabled ? 1 : 0);
            writer.Write(trigger.IsCustomText ? 1 : 0);
            writer.Write(trigger.StartsClosed ? 1 : 0);
            writer.Write(trigger.RunOnMapInit ? 1 : 0);
            writer.Write(trigger.CategoryId);
            writer.Write(trigger.Events.Count + trigger.Conditions.Count + trigger.Actions.Count);

            foreach (var node in trigger.Events)
            {
                WriteRootNode(writer, node);
            }

            foreach (var node in trigger.Conditions)
            {
                WriteRootNode(writer, node);
            }

            foreach (var node in trigger.Actions)
            {
                WriteRootNode(writer, node);
            }
        }

        return stream.ToArray();
    }

    public static byte[] WriteWct(LegacyGuiDocument document)
    {
        using var stream = new MemoryStream();
        using var writer = new BinaryWriter(stream, Utf8, leaveOpen: true);
        writer.Write(1);
        WriteCString(writer, document.GlobalCustomComment);
        if (string.IsNullOrEmpty(document.GlobalCustomCode))
        {
            writer.Write(0);
        }
        else
        {
            writer.Write(Utf8.GetByteCount(document.GlobalCustomCode) + 1);
            WriteCString(writer, document.GlobalCustomCode);
        }

        writer.Write(document.Triggers.Count);
        foreach (var trigger in document.Triggers)
        {
            if (string.IsNullOrEmpty(trigger.CustomText))
            {
                writer.Write(0);
            }
            else
            {
                writer.Write(Utf8.GetByteCount(trigger.CustomText) + 1);
                WriteCString(writer, trigger.CustomText);
            }
        }

        return stream.ToArray();
    }

    public static LegacyGuiDocument ReadWtgAndWct(byte[] wtgBytes, byte[] wctBytes, GuiMetadataCatalog metadata)
    {
        using var wtgStream = new MemoryStream(wtgBytes);
        using var wtgReader = new BinaryReader(wtgStream, Utf8, leaveOpen: true);
        var signature = Utf8.GetString(wtgReader.ReadBytes(4));
        if (!string.Equals(signature, "WTG!", StringComparison.Ordinal))
        {
            throw new InvalidDataException("Invalid WTG signature.");
        }

        var version = wtgReader.ReadInt32();
        if (version != 7)
        {
            throw new InvalidDataException($"Unsupported WTG version: {version}");
        }

        var categories = new List<LegacyGuiCategory>();
        var categoryCount = wtgReader.ReadInt32();
        for (var index = 0; index < categoryCount; index++)
        {
            categories.Add(new LegacyGuiCategory(
                wtgReader.ReadInt32(),
                ReadCString(wtgReader),
                wtgReader.ReadInt32() != 0));
        }

        if (wtgReader.ReadInt32() != 2)
        {
            throw new InvalidDataException("Unexpected WTG variable header.");
        }

        var variables = new List<LegacyGuiVariable>();
        var variableCount = wtgReader.ReadInt32();
        for (var index = 0; index < variableCount; index++)
        {
            var name = ReadCString(wtgReader);
            var type = ReadCString(wtgReader);
            if (wtgReader.ReadInt32() != 1)
            {
                throw new InvalidDataException($"Unexpected WTG variable marker for `{name}`.");
            }

            var isArray = wtgReader.ReadInt32() != 0;
            _ = wtgReader.ReadInt32();
            var hasDefault = wtgReader.ReadInt32() != 0;
            var defaultValue = ReadCString(wtgReader);
            variables.Add(new LegacyGuiVariable(name, type, isArray, hasDefault ? defaultValue : null));
        }

        var wct = ReadWct(wctBytes);
        var triggers = new List<LegacyGuiTrigger>();
        var triggerCount = wtgReader.ReadInt32();
        for (var index = 0; index < triggerCount; index++)
        {
            var trigger = new LegacyGuiTrigger
            {
                Name = ReadCString(wtgReader),
                Description = ReadCString(wtgReader),
                Type = wtgReader.ReadInt32(),
                Enabled = wtgReader.ReadInt32() != 0,
                IsCustomText = wtgReader.ReadInt32() != 0,
                StartsClosed = wtgReader.ReadInt32() != 0,
                RunOnMapInit = wtgReader.ReadInt32() != 0,
                CategoryId = wtgReader.ReadInt32(),
                CustomText = index < wct.TriggerTexts.Count ? wct.TriggerTexts[index] : string.Empty
            };

            var rootCount = wtgReader.ReadInt32();
            for (var nodeIndex = 0; nodeIndex < rootCount; nodeIndex++)
            {
                var node = ReadRootNode(wtgReader, metadata);
                switch (node.Kind)
                {
                    case LegacyGuiFunctionKind.Event:
                        trigger.Events.Add(node);
                        break;
                    case LegacyGuiFunctionKind.Condition:
                        trigger.Conditions.Add(node);
                        break;
                    case LegacyGuiFunctionKind.Action:
                        trigger.Actions.Add(node);
                        break;
                    default:
                        throw new InvalidDataException($"Unsupported root node kind: {node.Kind}");
                }
            }

            triggers.Add(trigger);
        }

        return new LegacyGuiDocument(categories, variables, triggers, wct.GlobalComment, wct.GlobalCode);
    }

    private static (string GlobalComment, string GlobalCode, IReadOnlyList<string> TriggerTexts) ReadWct(byte[] bytes)
    {
        using var stream = new MemoryStream(bytes);
        using var reader = new BinaryReader(stream, Utf8, leaveOpen: true);
        var version = reader.ReadInt32();
        if (version != 1)
        {
            throw new InvalidDataException($"Unsupported WCT version: {version}");
        }

        var globalComment = ReadCString(reader);
        var globalCodeLength = reader.ReadInt32();
        var globalCode = globalCodeLength == 0 ? string.Empty : ReadCString(reader);
        var triggerTexts = new List<string>();
        var triggerCount = reader.ReadInt32();
        for (var index = 0; index < triggerCount; index++)
        {
            var textLength = reader.ReadInt32();
            triggerTexts.Add(textLength == 0 ? string.Empty : ReadCString(reader));
        }

        return (globalComment, globalCode, triggerTexts);
    }

    private static void WriteRootNode(BinaryWriter writer, LegacyGuiNode node)
    {
        writer.Write((int)node.Kind);
        WriteNodeBody(writer, node);
    }

    private static void WriteChildNode(BinaryWriter writer, LegacyGuiNode node, int childId)
    {
        writer.Write((int)node.Kind);
        writer.Write(childId);
        WriteNodeBody(writer, node);
    }

    private static void WriteEmbeddedNode(BinaryWriter writer, LegacyGuiNode node)
    {
        writer.Write((int)node.Kind);
        WriteNodeBody(writer, node);
    }

    private static void WriteNodeBody(BinaryWriter writer, LegacyGuiNode node)
    {
        WriteCString(writer, node.Name);
        writer.Write(node.Enabled ? 1 : 0);
        foreach (var argument in node.Arguments)
        {
            WriteArgument(writer, argument);
        }

        writer.Write(node.ChildBlocks.Sum(block => block.Nodes.Count));
        for (var blockIndex = 0; blockIndex < node.ChildBlocks.Count; blockIndex++)
        {
            foreach (var child in node.ChildBlocks[blockIndex].Nodes)
            {
                WriteChildNode(writer, child, blockIndex);
            }
        }
    }

    private static void WriteArgument(BinaryWriter writer, LegacyGuiArgument argument)
    {
        writer.Write((int)argument.Kind);
        WriteCString(writer, argument.Value);
        if (argument.Kind == LegacyGuiArgumentKind.Call && argument.CallNode is not null)
        {
            writer.Write(1);
            WriteEmbeddedNode(writer, argument.CallNode);
        }
        else
        {
            writer.Write(0);
        }

        if (argument.ArrayIndex is not null)
        {
            writer.Write(1);
            WriteArgument(writer, argument.ArrayIndex);
        }
        else
        {
            writer.Write(0);
        }
    }

    private static LegacyGuiNode ReadRootNode(BinaryReader reader, GuiMetadataCatalog metadata)
    {
        var kind = (LegacyGuiFunctionKind)reader.ReadInt32();
        return ReadNodeBody(reader, metadata, kind);
    }

    private static LegacyGuiNode ReadChildNode(BinaryReader reader, GuiMetadataCatalog metadata, out int childId)
    {
        var kind = (LegacyGuiFunctionKind)reader.ReadInt32();
        childId = reader.ReadInt32();
        return ReadNodeBody(reader, metadata, kind);
    }

    private static LegacyGuiNode ReadEmbeddedNode(BinaryReader reader, GuiMetadataCatalog metadata)
    {
        var kind = (LegacyGuiFunctionKind)reader.ReadInt32();
        return ReadNodeBody(reader, metadata, kind);
    }

    private static LegacyGuiNode ReadNodeBody(BinaryReader reader, GuiMetadataCatalog metadata, LegacyGuiFunctionKind kind)
    {
        var name = ReadCString(reader);
        var node = new LegacyGuiNode(kind, name)
        {
            Enabled = reader.ReadInt32() != 0
        };

        if (!metadata.TryGetEntry(kind, name, out var metadataEntry))
        {
            throw new InvalidDataException($"No GUI metadata registered for `{kind}:{name}`.");
        }

        foreach (var _ in metadataEntry.EffectiveArguments)
        {
            node.Arguments.Add(ReadArgument(reader, metadata));
        }

        var childCount = reader.ReadInt32();
        var blocks = new Dictionary<int, LegacyGuiNodeBlock>();
        for (var index = 0; index < childCount; index++)
        {
            var child = ReadChildNode(reader, metadata, out var nestedChildId);
            if (!blocks.TryGetValue(nestedChildId, out var block))
            {
                block = new LegacyGuiNodeBlock($"block-{nestedChildId}");
                blocks[nestedChildId] = block;
                node.ChildBlocks.Add(block);
            }

            block.Nodes.Add(child);
        }

        return node;
    }

    private static LegacyGuiArgument ReadArgument(BinaryReader reader, GuiMetadataCatalog metadata)
    {
        var kind = (LegacyGuiArgumentKind)reader.ReadInt32();
        var value = ReadCString(reader);
        var hasCall = reader.ReadInt32() != 0;
        LegacyGuiNode? callNode = null;
        if (hasCall)
        {
            callNode = ReadEmbeddedNode(reader, metadata);
        }

        var hasArrayIndex = reader.ReadInt32() != 0;
        LegacyGuiArgument? arrayIndex = null;
        if (hasArrayIndex)
        {
            arrayIndex = ReadArgument(reader, metadata);
        }

        return kind switch
        {
            LegacyGuiArgumentKind.Preset => LegacyGuiArgument.Preset(value),
            LegacyGuiArgumentKind.Variable when arrayIndex is not null => LegacyGuiArgument.Array(value, arrayIndex),
            LegacyGuiArgumentKind.Variable => LegacyGuiArgument.Variable(value),
            LegacyGuiArgumentKind.Constant => LegacyGuiArgument.Constant(value),
            LegacyGuiArgumentKind.Call when callNode is not null => LegacyGuiArgument.Call(callNode),
            LegacyGuiArgumentKind.Disabled => LegacyGuiArgument.Disabled(value),
            _ => throw new InvalidDataException($"Unsupported GUI argument kind: {kind}")
        };
    }

    private static void WriteCString(BinaryWriter writer, string value)
    {
        writer.Write(Utf8.GetBytes(value));
        writer.Write((byte)0);
    }

    private static string ReadCString(BinaryReader reader)
    {
        using var stream = new MemoryStream();
        while (true)
        {
            var current = reader.ReadByte();
            if (current == 0)
            {
                return Utf8.GetString(stream.ToArray());
            }

            stream.WriteByte(current);
        }
    }
}
