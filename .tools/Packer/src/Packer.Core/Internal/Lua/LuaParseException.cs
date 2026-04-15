namespace Packer.Core.Internal.Lua;

internal sealed class LuaParseException : Exception
{
    public LuaParseException(string message, LuaToken token)
        : base($"{message}（第 {token.Line} 行，第 {token.Column} 列）")
    {
        Token = token;
    }

    public LuaToken Token { get; }
}
