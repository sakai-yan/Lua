# MapRepair V63 Publish Refresh

## Goal
- Package the latest MapRepair GUI build as a fresh Windows exe release for manual editor-side validation.

## Published Artifacts
- Versioned publish directory:
- `.tools/MapRepair/publish/win-x64-self-contained-20260405-0841/`
- Refreshed stable publish directory:
- `.tools/MapRepair/publish/win-x64-self-contained/`
- Versioned zip:
- `.tools/MapRepair/publish/MapRepair-win-x64-self-contained-20260405-0841.zip`

## Execution
- Built the WPF app from current source with:
- `dotnet publish .tools/MapRepair/src/MapRepair.Wpf/MapRepair.Wpf.csproj -c Release -r win-x64 --self-contained true -o .tools/MapRepair/publish/win-x64-self-contained-20260405-0841`
- Refreshed the stable publish directory by copying the versioned output into:
- `.tools/MapRepair/publish/win-x64-self-contained/`
- Packed the versioned directory with the .NET zip API so the archive preserves the top-level versioned folder.

## Verification
- Confirmed both exe locations exist and match size `153800019` bytes:
- `.tools/MapRepair/publish/win-x64-self-contained-20260405-0841/MapRepair.exe`
- `.tools/MapRepair/publish/win-x64-self-contained/MapRepair.exe`
- Listed zip contents and confirmed it contains entries such as:
- `win-x64-self-contained-20260405-0841/MapRepair.exe`
- `win-x64-self-contained-20260405-0841/MapRepair.Core.pdb`
- `win-x64-self-contained-20260405-0841/wpfgfx_cor3.dll`

## Notes
- No MapRepair runtime code changed during this packaging-only slice; this publish refresh exists so manual validation can point at a fresh, explicit exe artifact from the current workspace state.
