Lua 5.3.6 local install

Source archive:
https://www.lua.org/ftp/lua-5.3.6.tar.gz

Official archive SHA-256:
fc5fd69bb8736323f026672b1b7235da613d7177e72558893a0bdcd320466d60

Release date:
2020-09-14

Build details:
- Built locally from the official Lua.org source archive
- Built with Visual Studio 2022 MSVC x64
- Official default compatibility macro kept: LUA_COMPAT_5_2
- No system PATH changes were made

Useful paths:
- Runtime: .tools\\lua53\\bin\\lua.exe
- Compiler: .tools\\lua53\\bin\\luac.exe
- Headers: .tools\\lua53\\include
- Library: .tools\\lua53\\lib\\lua53.lib
- Versioned source tree: .tools\\lua-5.3.6

Note:
This install is intended to better match projects that target Lua 5.3 semantics.
