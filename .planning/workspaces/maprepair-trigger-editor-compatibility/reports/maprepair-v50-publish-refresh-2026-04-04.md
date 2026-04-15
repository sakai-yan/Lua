# MapRepair V50 Publish Refresh

## Goal
- Package and publish the latest MapRepair GUI build from the current source-backed state after the WTG checker and debug-walk fixes were completed.

## Publish Convention
- Launch script:
  - `.tools/MapRepair/Run-MapRepair.cmd`
- Publish directory:
  - `.tools/MapRepair/publish/win-x64-self-contained`
- Versioned zip artifact:
  - `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260404-1907.zip`

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
  - `2026-04-04 19:07`
- Size:
  - `153,790,803` bytes
- SHA-256:
  - `F27AB18D849F51926631D776D56CDE1E44FD24CBCC87F0CAF28CC817355A9864`

## Zip Package
- Path:
  - `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260404-1907.zip`
- Size:
  - `65,777,536` bytes
- SHA-256:
  - `0A6A1A7146A056D853BAE7E08F98E012154AD2E736B5E031128D786BAC5D64E2`

## Verification
- Confirmed the published `MapRepair.exe` exists in the target publish directory.
- Confirmed the timestamped zip exists in `.tools/MapRepair/publish/`.
- Listed zip contents and confirmed it contains:
  - `win-x64-self-contained/MapRepair.exe`
  - `win-x64-self-contained/MapRepair.Core.pdb`

## Notes
- `Compress-Archive` emitted a trailing non-fatal PowerShell module warning after the zip was already created; the resulting zip still passed content listing and should be treated as valid.
- The latest source-backed real-map and smoke validation remain recorded in `.planning/SESSION.md`; this report only captures the packaging refresh.
