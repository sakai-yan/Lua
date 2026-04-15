# MapRepair V64 Script-Visible GUI Publish

## Goal
- Publish a fresh MapRepair GUI package after enabling structured GUI recovery for script-visible custom and YDWE function names.

## Behavior Change
- `JassGuiReconstructionParser` no longer restricts structured recovery to base-compatible-only metadata.
- If a function name still survives in `war3map.j` and matching metadata exists, the current build now reconstructs that function as GUI, including nested calls resolved through `script_name`.
- GUI-only aliases that disappeared before `war3map.j` emission remain outside script-side recovery and still require helper analysis or custom-text fallback.

## Published Artifacts
- Versioned publish directory:
- `.tools/MapRepair/publish/win-x64-self-contained-20260405-1016/`
- Refreshed stable publish directory:
- `.tools/MapRepair/publish/win-x64-self-contained/`
- Versioned zip:
- `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260405-1016.zip`

## Execution
- Verified the updated source with:
- `dotnet run --project d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\src\MapRepair.Smoke\MapRepair.Smoke.csproj`
- Published the WPF app from current source with:
- `dotnet publish d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\src\MapRepair.Wpf\MapRepair.Wpf.csproj -c Release -r win-x64 --self-contained true -o d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\publish\win-x64-self-contained-20260405-1016`
- Refreshed the stable publish directory by copying the versioned output into:
- `.tools/MapRepair/publish/win-x64-self-contained/`
- Packed the versioned directory with the .NET zip API so the archive preserves the top-level versioned folder.

## Verification
- Confirmed both exe locations exist and match size `153800019` bytes:
- `.tools/MapRepair/publish/win-x64-self-contained-20260405-1016/MapRepair.exe`
- `.tools/MapRepair/publish/win-x64-self-contained/MapRepair.exe`
- Listed zip contents and confirmed it contains entries such as:
- `win-x64-self-contained-20260405-1016/MapRepair.exe`
- `win-x64-self-contained-20260405-1016/MapRepair.Core.pdb`
- `win-x64-self-contained-20260405-1016/wpfgfx_cor3.dll`

## Notes
- The latest real-map rerun metrics in `.planning/tmp/current-rerun-v10/` still belong to the earlier pre-`1016` source snapshot.
- This publish refresh exists so editor-side validation can target a package that includes the script-visible custom-function GUI recovery change.
