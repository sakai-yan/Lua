# MapRepair V52 Publish Refresh

## Goal
- Refresh the published GUI package after the trigger-load compatibility fix so manual editor validation uses the newest source-backed build.

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
  - `2026-04-04 19:47`
- Size:
  - `153,791,315` bytes
- SHA-256:
  - `E1445F48F8D5FFE33988329202AC2439D2A8F3C8DB8A7ABC83935E670E17E65B`

## Zip Package
- Path:
  - `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260404-1947.zip`
- Size:
  - `65,777,752` bytes
- SHA-256:
  - `F5277A72F18EE73854381F5CB8125AD6DFC89B95B45D69A1B0959091C7B738F8`

## Verification
- Confirmed the published `MapRepair.exe` exists in the target publish directory.
- Confirmed the timestamped zip exists in `.tools/MapRepair/publish/`.
- Listed zip contents and confirmed it contains:
  - `win-x64-self-contained/MapRepair.exe`
  - `win-x64-self-contained/MapRepair.Core.pdb`

## Notes
- `Compress-Archive` again emitted the same trailing non-fatal PowerShell module warning after the zip was already created.
- The resulting zip still passed content listing and should be treated as valid.
