# MapRepair V46 Publish Refresh

## Goal
- Rebuild and refresh the published GUI executable from the latest source so the manual repair flow no longer runs a stale binary.

## Evidence Before Refresh
- The launch script still targets:
  - `.tools/MapRepair/Run-MapRepair.cmd`
  - `publish\win-x64-self-contained\MapRepair.exe`
- The manually generated repaired map was provably stale:
  - `chuzhang V2 mod2.851_repaired.w3x`
  - SHA-256 = `8732E7149D95C05FC0AF6A48659DE0A0ABEC2D97249A07729322BB9FAD7F203D`
- That hash exactly matched:
  - `chuzhang V2 mod2.851_repaired_v41.w3x`
- It did not match:
  - `chuzhang V2 mod2.851_repaired_v46.w3x`
  - SHA-256 = `AC914BB6D46B681DDEC2089FCE5502C0DC15EF15EEC36A47A4A3C12F309CF575`

## Refresh Performed
- Build:
  - `dotnet build .tools/MapRepair/MapRepair.sln -c Release -nologo`
- Publish:
  - `dotnet publish .tools/MapRepair/src/MapRepair.Wpf/MapRepair.Wpf.csproj -c Release -r win-x64 --self-contained true -o .tools/MapRepair/publish/win-x64-self-contained`

## Published Artifact After Refresh
- Path:
  - `.tools/MapRepair/publish/win-x64-self-contained/MapRepair.exe`
- Last write time:
  - `2026-04-02 21:34:13`
- Size:
  - `153,706,835` bytes
- SHA-256:
  - `76ABF6029B03A0048664402E0448B96DB47FB0A2636D9217AC7357D0EE00A79F`

## Result
- The published GUI package is now rebuilt from the latest local source instead of the older `v41`-equivalent binary.
- The next required proof is to run the refreshed GUI manually and verify that its new output now aligns with the `v46` baseline instead of reproducing the old `v41` hash.
