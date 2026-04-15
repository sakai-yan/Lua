# MapRepair V56 Publish Refresh

## Goal
- Refresh the published GUI package after the compact/dense pseudo-GUI fallback so manual editor validation uses the newest source-backed build.

## Refresh Performed
- Build:
  - `dotnet build .tools/MapRepair/MapRepair.sln -c Release -nologo`
- Publish:
  - `dotnet publish .tools/MapRepair/src/MapRepair.Wpf/MapRepair.Wpf.csproj -c Release -r win-x64 --self-contained true -o .tools/MapRepair/publish/win-x64-self-contained`
- Package:
  - `Compress-Archive` over `.tools/MapRepair/publish/win-x64-self-contained`

## Published Artifact
- Path:
  - `.tools/MapRepair/publish/win-x64-self-contained/MapRepair.exe`
- Last write time:
  - `2026-04-04 23:22`
- Size:
  - `153,795,411` bytes
- SHA-256:
  - `21400FE621EAF4844A937A60CB4307150AF26E0F47D0F6C11BE2D7B325F37209`

## Zip Package
- Path:
  - `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260404-2321.zip`
- Size:
  - `65,779,602` bytes
- SHA-256:
  - `A7FA68AEB7863C4A75DD3B51CD0552A98817F73C7D5778DF7171A898E1F640EC`

## Verification
- Confirmed the published `MapRepair.exe` exists in the target publish directory.
- Confirmed the timestamped zip exists in `.tools/MapRepair/publish/`.
- Listed zip contents and confirmed it contains:
  - `win-x64-self-contained/MapRepair.exe`
  - `win-x64-self-contained/MapRepair.Core.pdb`

## Notes
- This package includes the compact/dense pseudo-GUI fallback changes validated by the latest smoke run and source-backed real-map rerun.
