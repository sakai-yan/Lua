# MapRepair V58 Versioned Publish Refresh

## Goal
- Refresh the published GUI package after the latest script-heavy pseudo-GUI fallback without overwriting any possibly open manual-test build.

## Refresh Performed
- Build:
  - `dotnet build .tools/MapRepair/MapRepair.sln -c Release -nologo`
- Publish:
  - `dotnet publish .tools/MapRepair/src/MapRepair.Wpf/MapRepair.Wpf.csproj -c Release -r win-x64 --self-contained true -o .tools/MapRepair/publish/win-x64-self-contained-20260404-2351`
- Package:
  - `Compress-Archive` over `.tools/MapRepair/publish/win-x64-self-contained-20260404-2351`

## Published Artifact
- Path:
  - `.tools/MapRepair/publish/win-x64-self-contained-20260404-2351/MapRepair.exe`
- Last write time:
  - `2026-04-04 23:52`
- Size:
  - `153,796,947` bytes
- SHA-256:
  - `3DA0CF91D2181584782B9E318810D467552B9CD77D2A8760BEDA9AC4A7F01423`

## Zip Package
- Path:
  - `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260404-2351.zip`
- Size:
  - `65,780,150` bytes
- SHA-256:
  - `7D8B492ED864E0DAE49DD9F99895EF3913F46401A3271CBBDFB2B9A438D88663`

## Verification
- Confirmed the versioned published `MapRepair.exe` exists in the target publish directory.
- Confirmed the timestamped zip exists in `.tools/MapRepair/publish/`.
- Listed zip contents and confirmed it contains:
  - `win-x64-self-contained-20260404-2351/MapRepair.exe`
  - `win-x64-self-contained-20260404-2351/MapRepair.Core.pdb`

## Notes
- This versioned package avoids overwriting any already-open publish directory while still shipping the latest script-heavy pseudo-GUI fallback changes.
