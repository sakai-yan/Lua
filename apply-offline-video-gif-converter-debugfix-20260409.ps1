$source = Join-Path $PSScriptRoot "offline-video-gif-converter-debugfix-20260409\src\App.tsx"
$target = "D:\Software\offline-video-gif-converter\src\App.tsx"

if (!(Test-Path -LiteralPath $source)) {
  throw "Missing fixed file: $source"
}

if (!(Test-Path -LiteralPath $target)) {
  throw "Missing target file: $target"
}

Copy-Item -LiteralPath $source -Destination $target -Force
Write-Host "Applied fix to $target"
