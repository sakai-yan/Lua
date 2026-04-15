# MapRepair V67 Publish Refresh

## Goal
- Package the latest `v13` source-backed trigger-compatibility changes into a new desktop GUI release so manual testing can use an up-to-date executable instead of the older `20260405-1055` build.

## Published Artifacts
- Versioned publish directory:
- `.tools/MapRepair/publish/win-x64-self-contained-20260405-1724/`
- Refreshed stable publish directory:
- `.tools/MapRepair/publish/win-x64-self-contained/`
- Versioned zip:
- `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260405-1724.zip`

## Commands
- `dotnet publish d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\src\MapRepair.Wpf\MapRepair.Wpf.csproj -c Release -r win-x64 --self-contained true -o d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\publish\win-x64-self-contained-20260405-1724`
- Copied the versioned output into the stable publish directory:
- `.tools/MapRepair/publish/win-x64-self-contained/`
- Created the zip with the .NET zip API using `includeBaseDirectory = true` so the archive keeps the top-level versioned folder.

## Verification
- Confirmed:
- `.tools/MapRepair/publish/win-x64-self-contained-20260405-1724/MapRepair.exe`
- `.tools/MapRepair/publish/win-x64-self-contained/MapRepair.exe`
- `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260405-1724.zip`
- Listed zip contents and confirmed entries such as:
- `win-x64-self-contained-20260405-1724/MapRepair.exe`
- `win-x64-self-contained-20260405-1724/MapRepair.Core.pdb`
- `win-x64-self-contained-20260405-1724/wpfgfx_cor3.dll`

## Context
- This package aligns with the `v13` trigger fallback changes from `maprepair-v66-medium-branchy-control-fallback-2026-04-05.md`.
- The next manual validation target can use either:
- `tmp/current-rerun-v13/chuzhang V2 mod2.851_repaired_current.w3x`
- `MapRepair-win-x64-self-contained-20260405-1724.zip`
