param(
    [Parameter(Mandatory = $true)]
    [string]$SourceMap,

    [Parameter(Mandatory = $true)]
    [string]$IndexJson,

    [Parameter(Mandatory = $true)]
    [string]$OutputRoot,

    [int]$StartOrdinal = 1,

    [int]$EndOrdinal = 569,

    [int]$TimeoutSeconds = 15
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($TimeoutSeconds -lt 15) {
    $TimeoutSeconds = 15
}

function Resolve-ExistingLiteralPath {
    param([Parameter(Mandatory = $true)][string]$Path)
    return (Resolve-Path -LiteralPath $Path).Path
}

function Assert-SuccessExitCode {
    param(
        [int]$ExitCode,
        [string]$Context
    )

    if ($ExitCode -ne 0) {
        throw "$Context failed with exit code $ExitCode."
    }
}

function ConvertTo-SafeFileStem {
    param([Parameter(Mandatory = $true)][string]$Text)
    return ([regex]::Replace($Text, '[<>:"/\\|?*\x00-\x1f]', '_')).Trim()
}

function Directory-CreateSafe {
    param([Parameter(Mandatory = $true)][string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) {
        return
    }

    New-Item -ItemType Directory -Force -Path $Path | Out-Null
}

function Write-JsonFile {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)]$Value
    )

    $json = $Value | ConvertTo-Json -Depth 12
    Set-Content -LiteralPath $Path -Value $json -Encoding UTF8
}

function Append-JsonLine {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)]$Value
    )

    $json = $Value | ConvertTo-Json -Compress -Depth 12
    Add-Content -LiteralPath $Path -Value $json -Encoding UTF8
}

function Get-EditorExecutablePath {
    param([Parameter(Mandatory = $true)][string]$RootPath)

    $preferred = @('YDWE.exe', 'KKWE.exe', 'worldeditydwe.exe')
    foreach ($name in $preferred) {
        $candidate = Join-Path $RootPath $name
        if (Test-Path -LiteralPath $candidate) {
            return $candidate
        }
    }

    $fallback = Get-ChildItem -LiteralPath $RootPath -Filter '*WE.exe' -File |
        Sort-Object Name |
        Select-Object -First 1
    if ($null -ne $fallback) {
        return $fallback.FullName
    }

    throw "No Warcraft editor executable was found under `$RootPath`."
}

function Get-RoundShellSpec {
    param(
        [int]$Ordinal,
        [int]$MaxOrdinal
    )

    if ($Ordinal -ge $MaxOrdinal) {
        return $null
    }

    return ('{0:D3}-{1:D3}' -f ($Ordinal + 1), $MaxOrdinal)
}

function Get-OnlyShellSpec {
    param(
        [int]$Ordinal,
        [int]$MaxOrdinal
    )

    $segments = New-Object System.Collections.Generic.List[string]
    if ($Ordinal -gt 1) {
        if ($Ordinal -eq 2) {
            $segments.Add('001')
        }
        else {
            $segments.Add(('001-{0:D3}' -f ($Ordinal - 1)))
        }
    }

    if ($Ordinal -lt $MaxOrdinal) {
        if ($Ordinal -eq ($MaxOrdinal - 1)) {
            $segments.Add(('{0:D3}' -f $MaxOrdinal))
        }
        else {
            $segments.Add(('{0:D3}-{1:D3}' -f ($Ordinal + 1), $MaxOrdinal))
        }
    }

    if ($segments.Count -eq 0) {
        return $null
    }

    return ($segments -join ',')
}

function Invoke-TriggerShellVariant {
    param(
        [string]$DiagExePath,
        [string]$SourceMapPath,
        [string]$ShellSpec,
        [string]$WorkingRoot,
        [string]$DestinationPath
    )

    Directory-CreateSafe -Path ([System.IO.Path]::GetDirectoryName($DestinationPath))

    if ([string]::IsNullOrWhiteSpace($ShellSpec)) {
        Copy-Item -LiteralPath $SourceMapPath -Destination $DestinationPath -Force
        return $DestinationPath
    }

    $tempRoot = Join-Path $WorkingRoot ([guid]::NewGuid().ToString('N'))
    Directory-CreateSafe -Path $tempRoot

    $output = & $DiagExePath '--trigger-shell' $SourceMapPath $tempRoot $ShellSpec 2>&1
    Assert-SuccessExitCode -ExitCode $LASTEXITCODE -Context "MapRepair.Diag --trigger-shell $ShellSpec"

    $generated = Get-ChildItem -LiteralPath $tempRoot -Filter '*.w3x' -File |
        Sort-Object Name |
        Select-Object -First 1
    if ($null -eq $generated) {
        throw "No trigger-shell variant was generated for spec `$ShellSpec`."
    }

    Move-Item -LiteralPath $generated.FullName -Destination $DestinationPath -Force
    return $DestinationPath
}

function Invoke-EditorProbe {
    param(
        [string]$ProbeScriptPath,
        [string]$MapPath,
        [string]$EditorRootPath,
        [int]$TimeoutSeconds
    )

    $raw = & $ProbeScriptPath -MapPath $MapPath -TimeoutSeconds $TimeoutSeconds -EditorRoot $EditorRootPath
    $jsonText = ($raw | Out-String).Trim()
    if ([string]::IsNullOrWhiteSpace($jsonText)) {
        throw "editor_open_probe.ps1 produced no JSON output for `$MapPath`."
    }

    return $jsonText | ConvertFrom-Json
}

function Invoke-ArchiveExtract {
    param(
        [string]$ArchiveProbeProjectPath,
        [string]$MapPath,
        [string]$EntryPath,
        [string]$OutputPath
    )

    Directory-CreateSafe -Path ([System.IO.Path]::GetDirectoryName($OutputPath))
    $output = & dotnet run --no-build --project $ArchiveProbeProjectPath -- --extract $MapPath $EntryPath $OutputPath 2>&1
    Assert-SuccessExitCode -ExitCode $LASTEXITCODE -Context "MapRepair.ArchiveProbe --extract $EntryPath"
    return $OutputPath
}

function Invoke-WtgInspect {
    param(
        [string]$WtgInspectProjectPath,
        [string]$RepoRootPath,
        [string]$WtgPath,
        [string]$WctPath
    )

    $raw = & dotnet run --no-build --project $WtgInspectProjectPath -- $RepoRootPath $WtgPath $WctPath 2>&1
    Assert-SuccessExitCode -ExitCode $LASTEXITCODE -Context "MapRepair.WtgInspect $WtgPath"
    $jsonText = ($raw | Out-String).Trim()
    return $jsonText | ConvertFrom-Json
}

function Get-ShortInspectSummary {
    param([Parameter(Mandatory = $true)]$Inspect)

    return [ordered]@{
        triggerCount = $Inspect.triggerCount
        customTextCount = $Inspect.customTextCount
        runOnInitCount = $Inspect.runOnInitCount
        totalChildBlocks = $Inspect.totalChildBlocks
        maxActionTrigger = $Inspect.maxActionTrigger
        maxActionCount = $Inspect.maxActionCount
        topActions = @($Inspect.topActions | Select-Object -First 8)
        topConditions = @($Inspect.topConditions | Select-Object -First 8)
        firstTriggers = @($Inspect.firstTriggers | Select-Object -First 12)
    }
}

function Get-StringSha256 {
    param([Parameter(Mandatory = $true)][string]$Text)
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
    $hash = [System.Security.Cryptography.SHA256]::Create()
    try {
        return ([System.BitConverter]::ToString($hash.ComputeHash($bytes))).Replace('-', '').ToLowerInvariant()
    }
    finally {
        $hash.Dispose()
    }
}

function Get-OptionalFileSha256 {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        return $null
    }

    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

function Build-TriggerFingerprint {
    param(
        [Parameter(Mandatory = $true)]$IndexEntries,
        [Parameter(Mandatory = $true)][string]$RecoveredGuiDir
    )

    $items = New-Object System.Collections.ArrayList
    for ($ordinal = 1; $ordinal -le $IndexEntries.Count; $ordinal++) {
        $entry = $IndexEntries[$ordinal - 1]
        $name = [string]$entry.name
        $stem = '{0:D3}-{1}' -f $ordinal, $name
        $lmlPath = Join-Path $RecoveredGuiDir "$stem.lml"
        $jPath = Join-Path $RecoveredGuiDir "$stem.j"
        $metaPath = Join-Path $RecoveredGuiDir "$stem.meta.txt"
        $entryJson = $entry | ConvertTo-Json -Compress -Depth 10

        $item = [pscustomobject][ordered]@{
            ordinal = $ordinal
            name = $name
            stem = $stem
            entrySha256 = (Get-StringSha256 -Text $entryJson)
            lmlSha256 = Get-OptionalFileSha256 -Path $lmlPath
            jSha256 = Get-OptionalFileSha256 -Path $jPath
            metaSha256 = Get-OptionalFileSha256 -Path $metaPath
            lmlPath = if (Test-Path -LiteralPath $lmlPath) { $lmlPath } else { $null }
            jPath = if (Test-Path -LiteralPath $jPath) { $jPath } else { $null }
            metaPath = if (Test-Path -LiteralPath $metaPath) { $metaPath } else { $null }
        }
        [void]$items.Add($item)
    }

    return [ordered]@{
        generatedAt = (Get-Date).ToString('o')
        recoveredGuiDir = $RecoveredGuiDir
        triggerCount = $IndexEntries.Count
        items = @($items)
    }
}

function Copy-ChainProbeInputs {
    param(
        [string]$SourceRecoveredGuiDir,
        [string]$DestinationRecoveredGuiDir,
        [string]$IndexJsonPath,
        [int]$TakeCount
    )

    Directory-CreateSafe -Path $DestinationRecoveredGuiDir
    Copy-Item -LiteralPath $IndexJsonPath -Destination (Join-Path $DestinationRecoveredGuiDir 'index.json') -Force

    Get-ChildItem -LiteralPath $SourceRecoveredGuiDir -Filter '*.lml' -File |
        Sort-Object Name |
        Select-Object -First $TakeCount |
        ForEach-Object {
            Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $DestinationRecoveredGuiDir $_.Name) -Force
        }
}

function New-DiagnosticMapRoot {
    param(
        [string]$ArchiveProbeProjectPath,
        [string]$SourceRecoveredGuiDir,
        [string]$IndexJsonPath,
        [string]$MapPath,
        [string]$RootPath
    )

    Directory-CreateSafe -Path $RootPath
    Copy-Item -LiteralPath $MapPath -Destination (Join-Path $RootPath ([System.IO.Path]::GetFileName($MapPath))) -Force
    Invoke-ArchiveExtract -ArchiveProbeProjectPath $ArchiveProbeProjectPath -MapPath $MapPath -EntryPath 'war3map.wtg' -OutputPath (Join-Path $RootPath 'verify\war3map.wtg') | Out-Null
    Invoke-ArchiveExtract -ArchiveProbeProjectPath $ArchiveProbeProjectPath -MapPath $MapPath -EntryPath 'war3map.wct' -OutputPath (Join-Path $RootPath 'verify\war3map.wct') | Out-Null
    Copy-ChainProbeInputs -SourceRecoveredGuiDir $SourceRecoveredGuiDir -DestinationRecoveredGuiDir (Join-Path $RootPath 'report\RecoveredGui') -IndexJsonPath $IndexJsonPath -TakeCount 32
}

function Get-HealthySampleSummary {
    param([Parameter(Mandatory = $true)][string]$SummaryPath)
    if (-not (Test-Path -LiteralPath $SummaryPath)) {
        return $null
    }

    $summary = Get-Content -LiteralPath $SummaryPath -Raw | ConvertFrom-Json
    return [ordered]@{
        triggerCount = $summary.summary.TriggerCount
        guiEventNodeCount = $summary.summary.GuiEventNodeCount
        customTextTriggerCount = $summary.summary.CustomTextTriggerCount
        helperOnlyTriggerCount = $summary.helperInitAnalysis.helperOnlyTriggerCount
        standardRegisterCount = $summary.helperInitAnalysis.standardRegisterCount
        helperRegisterCount = $summary.helperInitAnalysis.helperRegisterCount
        rawReference = $summary.reference.raw
    }
}

$toolsRoot = Split-Path -Parent $PSCommandPath
$workspaceRoot = Split-Path -Parent $toolsRoot
$repoRoot = Resolve-ExistingLiteralPath -Path (Join-Path $toolsRoot '..\..\..\..')

$sourceMapPath = Resolve-ExistingLiteralPath -Path $SourceMap
$indexJsonPath = Resolve-ExistingLiteralPath -Path $IndexJson
$outputRootPath = if ([System.IO.Path]::IsPathRooted($OutputRoot)) {
    [System.IO.Path]::GetFullPath($OutputRoot)
}
else {
    [System.IO.Path]::GetFullPath((Join-Path $repoRoot $OutputRoot))
}

Directory-CreateSafe -Path $outputRootPath
$variantsRoot = Join-Path $outputRootPath 'variants'
$diagnosticsRoot = Join-Path $outputRootPath 'diagnostics'
$tempDiagRoot = Join-Path $outputRootPath '.diag-temp'
Directory-CreateSafe -Path $variantsRoot
Directory-CreateSafe -Path $diagnosticsRoot
Directory-CreateSafe -Path $tempDiagRoot

$editorRootPath = Resolve-ExistingLiteralPath -Path (Join-Path $repoRoot '.canon\YDWE')
$editorExePath = Get-EditorExecutablePath -RootPath $editorRootPath
$editorProbeScriptPath = Resolve-ExistingLiteralPath -Path (Join-Path $toolsRoot 'editor_open_probe.ps1')
$chainProbeScriptPath = Resolve-ExistingLiteralPath -Path (Join-Path $toolsRoot 'canon_ydwe_chain_probe.ps1')
$diagProjectPath = Resolve-ExistingLiteralPath -Path (Join-Path $repoRoot '.tools\MapRepair\src\MapRepair.Diag\MapRepair.Diag.csproj')
$archiveProbeProjectPath = Resolve-ExistingLiteralPath -Path (Join-Path $toolsRoot 'maprepair_archive_probe\MapRepair.ArchiveProbe.csproj')
$wtgInspectProjectPath = Resolve-ExistingLiteralPath -Path (Join-Path $toolsRoot 'maprepair_wtg_inspect\MapRepair.WtgInspect.csproj')
$healthySampleSummaryPath = Join-Path $workspaceRoot 'tmp\sample-huanghunyanwu-v1\summary.json'

$indexEntries = Get-Content -LiteralPath $indexJsonPath -Raw | ConvertFrom-Json
if ($indexEntries.Count -lt 1) {
    throw "Index file contains no trigger entries: `$indexJsonPath`."
}

if ($EndOrdinal -gt $indexEntries.Count) {
    throw "EndOrdinal `$EndOrdinal` exceeds trigger count `$($indexEntries.Count)`."
}

if ($StartOrdinal -lt 1 -or $StartOrdinal -gt $EndOrdinal) {
    throw "StartOrdinal `$StartOrdinal` must be within 1..$EndOrdinal."
}

$sourceRerunRoot = Split-Path -Parent $sourceMapPath
$sourceRecoveredGuiDir = Resolve-ExistingLiteralPath -Path (Join-Path $sourceRerunRoot 'report\RecoveredGui')

$fingerprint = Build-TriggerFingerprint -IndexEntries $indexEntries -RecoveredGuiDir $sourceRecoveredGuiDir
Write-JsonFile -Path (Join-Path $outputRootPath 'trigger_fingerprint.json') -Value $fingerprint
Write-JsonFile -Path (Join-Path $sourceRerunRoot 'trigger_fingerprint.json') -Value $fingerprint

$resultsPath = Join-Path $outputRootPath 'results.jsonl'
$manifestPath = Join-Path $outputRootPath 'variant-manifest.md'
$lastPassPath = Join-Path $outputRootPath 'last-pass.json'
$firstFailPath = Join-Path $outputRootPath 'first-fail.json'
$summaryPath = Join-Path $outputRootPath 'summary.json'

Set-Content -LiteralPath $resultsPath -Value '' -Encoding UTF8
$manifest = @()
$manifest += '# Trigger Restore Walk'
$manifest += ''
$manifest += '## Inputs'
$manifest += ('- sourceMap: {0}' -f $sourceMapPath)
$manifest += ('- indexJson: {0}' -f $indexJsonPath)
$manifest += ('- outputRoot: {0}' -f $outputRootPath)
$manifest += ('- startOrdinal: {0}' -f $StartOrdinal)
$manifest += ('- endOrdinal: {0}' -f $EndOrdinal)
$manifest += ('- timeoutSeconds: {0}' -f $TimeoutSeconds)
$manifest += ('- editorRoot: {0}' -f $editorRootPath)
$manifest += ('- editorExe: {0}' -f $editorExePath)
$manifest += ''
$manifest += '## Rounds'
Set-Content -LiteralPath $manifestPath -Value ($manifest -join "`r`n") -Encoding UTF8

$buildOutput = & dotnet build $diagProjectPath -nologo 2>&1
Assert-SuccessExitCode -ExitCode $LASTEXITCODE -Context 'dotnet build MapRepair.Diag'
$buildOutput = & dotnet build $archiveProbeProjectPath -nologo 2>&1
Assert-SuccessExitCode -ExitCode $LASTEXITCODE -Context 'dotnet build MapRepair.ArchiveProbe'
$buildOutput = & dotnet build $wtgInspectProjectPath -nologo 2>&1
Assert-SuccessExitCode -ExitCode $LASTEXITCODE -Context 'dotnet build MapRepair.WtgInspect'

$diagExePath = Resolve-ExistingLiteralPath -Path (Join-Path (Split-Path -Parent $diagProjectPath) 'bin\Debug\net8.0\MapRepair.Diag.exe')

$controlMapPath = Join-Path $variantsRoot '000-all-shell-positive-control.w3x'
Invoke-TriggerShellVariant -DiagExePath $diagExePath -SourceMapPath $sourceMapPath -ShellSpec ('001-{0:D3}' -f $EndOrdinal) -WorkingRoot $tempDiagRoot -DestinationPath $controlMapPath | Out-Null
$controlProbe = Invoke-EditorProbe -ProbeScriptPath $editorProbeScriptPath -MapPath $controlMapPath -EditorRootPath $editorRootPath -TimeoutSeconds $TimeoutSeconds
Start-Sleep -Seconds 2
$controlRecord = [ordered]@{
    kind = 'control'
    ordinal = 0
    triggerName = '(all-shell-positive-control)'
    mapPath = $controlMapPath
    probe = $controlProbe
}
Append-JsonLine -Path $resultsPath -Value $controlRecord
Add-Content -LiteralPath $manifestPath -Value ("`r`n### 000 Control`r`n`r`n- map: {0}`r`n- aliveAfter15s: {1}`r`n- log: {2}`r`n" -f $controlMapPath, $controlProbe.aliveAfterTimeout, $controlProbe.logArchivePath) -Encoding UTF8

if (-not $controlProbe.aliveAfterTimeout) {
    $controlFailure = [ordered]@{
        status = 'control_failed'
        control = $controlRecord
    }
    Write-JsonFile -Path $firstFailPath -Value $controlFailure
    Write-JsonFile -Path $summaryPath -Value $controlFailure
    throw "The all-shell positive control exited before the $TimeoutSeconds-second gate. Aborting restore walk."
}

$lastPassingRecord = $controlRecord
$firstFailureRecord = $null

for ($ordinal = $StartOrdinal; $ordinal -le $EndOrdinal; $ordinal++) {
    $entry = $indexEntries[$ordinal - 1]
    $triggerName = [string]$entry.name
    $safeName = ConvertTo-SafeFileStem -Text $triggerName
    $roundMapPath = Join-Path $variantsRoot ('{0:D3}-{1}-prefix.w3x' -f $ordinal, $safeName)
    $shellSpec = Get-RoundShellSpec -Ordinal $ordinal -MaxOrdinal $EndOrdinal

    Invoke-TriggerShellVariant -DiagExePath $diagExePath -SourceMapPath $sourceMapPath -ShellSpec $shellSpec -WorkingRoot $tempDiagRoot -DestinationPath $roundMapPath | Out-Null
    $probe = Invoke-EditorProbe -ProbeScriptPath $editorProbeScriptPath -MapPath $roundMapPath -EditorRootPath $editorRootPath -TimeoutSeconds $TimeoutSeconds
    Start-Sleep -Seconds 2

    $record = [ordered]@{
        kind = 'prefix'
        ordinal = $ordinal
        triggerName = $triggerName
        shellSpec = $shellSpec
        mapPath = $roundMapPath
        probe = $probe
    }

    Append-JsonLine -Path $resultsPath -Value $record
    Add-Content -LiteralPath $manifestPath -Value ("`r`n### {0:D3} {1}`r`n`r`n- map: {2}`r`n- shellSpec: {3}`r`n- aliveAfter15s: {4}`r`n- log: {5}`r`n" -f $ordinal, $triggerName, $roundMapPath, $shellSpec, $probe.aliveAfterTimeout, $probe.logArchivePath) -Encoding UTF8

    if ($probe.aliveAfterTimeout) {
        $lastPassingRecord = $record
        Write-JsonFile -Path $lastPassPath -Value $lastPassingRecord
        continue
    }

    $firstFailureRecord = $record
    Write-JsonFile -Path $firstFailPath -Value $firstFailureRecord
    break
}

if ($null -ne $firstFailureRecord) {
    $failedOrdinal = [int]$firstFailureRecord.ordinal
    $failedEntry = $indexEntries[$failedOrdinal - 1]
    $failedName = [string]$failedEntry.name
    $safeFailedName = ConvertTo-SafeFileStem -Text $failedName

    $stableLastPassMap = Join-Path $diagnosticsRoot 'last-pass.w3x'
    $stableFailPrefixMap = Join-Path $diagnosticsRoot 'fail-prefix.w3x'
    $stableOnlyMap = Join-Path $diagnosticsRoot ('{0:D3}-{1}-only.w3x' -f $failedOrdinal, $safeFailedName)

    Copy-Item -LiteralPath $lastPassingRecord.mapPath -Destination $stableLastPassMap -Force
    Copy-Item -LiteralPath $firstFailureRecord.mapPath -Destination $stableFailPrefixMap -Force

    $onlyShellSpec = Get-OnlyShellSpec -Ordinal $failedOrdinal -MaxOrdinal $EndOrdinal
    Invoke-TriggerShellVariant -DiagExePath $diagExePath -SourceMapPath $sourceMapPath -ShellSpec $onlyShellSpec -WorkingRoot $tempDiagRoot -DestinationPath $stableOnlyMap | Out-Null

    $failPrefixProbe = Invoke-EditorProbe -ProbeScriptPath $editorProbeScriptPath -MapPath $stableFailPrefixMap -EditorRootPath $editorRootPath -TimeoutSeconds $TimeoutSeconds
    Start-Sleep -Seconds 2
    $onlyProbe = Invoke-EditorProbe -ProbeScriptPath $editorProbeScriptPath -MapPath $stableOnlyMap -EditorRootPath $editorRootPath -TimeoutSeconds $TimeoutSeconds
    Start-Sleep -Seconds 2

    Append-JsonLine -Path $resultsPath -Value ([ordered]@{
        kind = 'diagnostic-fail-prefix'
        ordinal = $failedOrdinal
        triggerName = $failedName
        mapPath = $stableFailPrefixMap
        probe = $failPrefixProbe
    })
    Append-JsonLine -Path $resultsPath -Value ([ordered]@{
        kind = 'diagnostic-n-only'
        ordinal = $failedOrdinal
        triggerName = $failedName
        mapPath = $stableOnlyMap
        probe = $onlyProbe
    })

    $chainRoot = Join-Path $diagnosticsRoot 'chain-probe'
    if (Test-Path -LiteralPath $chainRoot) {
        Remove-Item -LiteralPath $chainRoot -Recurse -Force
    }
    New-DiagnosticMapRoot -ArchiveProbeProjectPath $archiveProbeProjectPath -SourceRecoveredGuiDir $sourceRecoveredGuiDir -IndexJsonPath $indexJsonPath -MapPath $stableFailPrefixMap -RootPath $chainRoot
    $chainOutput = & $chainProbeScriptPath $chainRoot 2>&1
    Assert-SuccessExitCode -ExitCode $LASTEXITCODE -Context 'canon_ydwe_chain_probe.ps1'
    $chainAuditJsonPath = Join-Path $chainRoot 'chain-audit.json'
    $chainAudit = Get-Content -LiteralPath $chainAuditJsonPath -Raw | ConvertFrom-Json

    $inspectRoots = @{
        lastPass = Join-Path $diagnosticsRoot 'inspect-last-pass'
        failPrefix = Join-Path $diagnosticsRoot 'inspect-fail-prefix'
        nOnly = Join-Path $diagnosticsRoot 'inspect-n-only'
    }

    foreach ($key in $inspectRoots.Keys) {
        if (Test-Path -LiteralPath $inspectRoots[$key]) {
            Remove-Item -LiteralPath $inspectRoots[$key] -Recurse -Force
        }
        Directory-CreateSafe -Path $inspectRoots[$key]
    }

    Invoke-ArchiveExtract -ArchiveProbeProjectPath $archiveProbeProjectPath -MapPath $stableLastPassMap -EntryPath 'war3map.wtg' -OutputPath (Join-Path $inspectRoots.lastPass 'war3map.wtg') | Out-Null
    Invoke-ArchiveExtract -ArchiveProbeProjectPath $archiveProbeProjectPath -MapPath $stableLastPassMap -EntryPath 'war3map.wct' -OutputPath (Join-Path $inspectRoots.lastPass 'war3map.wct') | Out-Null
    Invoke-ArchiveExtract -ArchiveProbeProjectPath $archiveProbeProjectPath -MapPath $stableFailPrefixMap -EntryPath 'war3map.wtg' -OutputPath (Join-Path $inspectRoots.failPrefix 'war3map.wtg') | Out-Null
    Invoke-ArchiveExtract -ArchiveProbeProjectPath $archiveProbeProjectPath -MapPath $stableFailPrefixMap -EntryPath 'war3map.wct' -OutputPath (Join-Path $inspectRoots.failPrefix 'war3map.wct') | Out-Null
    Invoke-ArchiveExtract -ArchiveProbeProjectPath $archiveProbeProjectPath -MapPath $stableOnlyMap -EntryPath 'war3map.wtg' -OutputPath (Join-Path $inspectRoots.nOnly 'war3map.wtg') | Out-Null
    Invoke-ArchiveExtract -ArchiveProbeProjectPath $archiveProbeProjectPath -MapPath $stableOnlyMap -EntryPath 'war3map.wct' -OutputPath (Join-Path $inspectRoots.nOnly 'war3map.wct') | Out-Null

    $lastPassInspect = Invoke-WtgInspect -WtgInspectProjectPath $wtgInspectProjectPath -RepoRootPath $repoRoot -WtgPath (Join-Path $inspectRoots.lastPass 'war3map.wtg') -WctPath (Join-Path $inspectRoots.lastPass 'war3map.wct')
    $failPrefixInspect = Invoke-WtgInspect -WtgInspectProjectPath $wtgInspectProjectPath -RepoRootPath $repoRoot -WtgPath (Join-Path $inspectRoots.failPrefix 'war3map.wtg') -WctPath (Join-Path $inspectRoots.failPrefix 'war3map.wct')
    $nOnlyInspect = Invoke-WtgInspect -WtgInspectProjectPath $wtgInspectProjectPath -RepoRootPath $repoRoot -WtgPath (Join-Path $inspectRoots.nOnly 'war3map.wtg') -WctPath (Join-Path $inspectRoots.nOnly 'war3map.wct')

    $fingerprintItem = $fingerprint.items[$failedOrdinal - 1]
    $healthySampleSummary = Get-HealthySampleSummary -SummaryPath $healthySampleSummaryPath
    $classification = if (-not $firstFailureRecord.probe.aliveAfterTimeout -and $failPrefixProbe.aliveAfterTimeout -and $onlyProbe.aliveAfterTimeout) {
        'sequence_sensitive_prefix_failure'
    }
    elseif (-not $onlyProbe.aliveAfterTimeout) {
        'independent_trigger_poison'
    }
    elseif (-not $failPrefixProbe.aliveAfterTimeout) {
        'prefix_interaction_poison'
    }
    else {
        'unknown'
    }

    $diagnosticCompare = [ordered]@{
        failedOrdinal = $failedOrdinal
        failedTriggerName = $failedName
        classification = $classification
        sourceMapPath = $sourceMapPath
        lastPass = [ordered]@{
            mapPath = $stableLastPassMap
            roundRecord = $lastPassingRecord
            inspect = Get-ShortInspectSummary -Inspect $lastPassInspect
        }
        failPrefix = [ordered]@{
            mapPath = $stableFailPrefixMap
            roundRecord = $firstFailureRecord
            probe = $failPrefixProbe
            inspect = Get-ShortInspectSummary -Inspect $failPrefixInspect
            chainAuditPath = $chainAuditJsonPath
            chainAudit = [ordered]@{
                firstFailStage = $chainAudit.firstFailStage
                firstFailMessage = $chainAudit.firstFailMessage
                manualOpen = $chainAudit.manualOpen
            }
        }
        nOnly = [ordered]@{
            mapPath = $stableOnlyMap
            shellSpec = $onlyShellSpec
            probe = $onlyProbe
            inspect = Get-ShortInspectSummary -Inspect $nOnlyInspect
        }
        failedTriggerIndexEntry = $failedEntry
        failedTriggerArtifacts = $fingerprintItem
        healthySample = $healthySampleSummary
    }

    Write-JsonFile -Path (Join-Path $diagnosticsRoot 'structural-compare.json') -Value $diagnosticCompare

    $compareMarkdown = @()
    $compareMarkdown += '# Prefix Failure Diagnostic'
    $compareMarkdown += ''
    $compareMarkdown += '## Failure'
    $compareMarkdown += ('- ordinal: {0:D3}' -f $failedOrdinal)
    $compareMarkdown += ('- trigger: {0}' -f $failedName)
    $compareMarkdown += ('- classification: {0}' -f $classification)
    $compareMarkdown += ''
    $compareMarkdown += '## Probe Results'
    $compareMarkdown += ('- last-pass map: {0}' -f $stableLastPassMap)
    $compareMarkdown += ('- fail-prefix map: {0}' -f $stableFailPrefixMap)
    $compareMarkdown += ('- n-only map: {0}' -f $stableOnlyMap)
    $compareMarkdown += ('- fail-prefix aliveAfter15s: {0}' -f $failPrefixProbe.aliveAfterTimeout)
    $compareMarkdown += ('- n-only aliveAfter15s: {0}' -f $onlyProbe.aliveAfterTimeout)
    $compareMarkdown += ''
    $compareMarkdown += '## Structural Compare'
    $compareMarkdown += ('- last-pass customTextCount: {0}' -f $lastPassInspect.customTextCount)
    $compareMarkdown += ('- fail-prefix customTextCount: {0}' -f $failPrefixInspect.customTextCount)
    $compareMarkdown += ('- n-only customTextCount: {0}' -f $nOnlyInspect.customTextCount)
    $compareMarkdown += ('- last-pass totalChildBlocks: {0}' -f $lastPassInspect.totalChildBlocks)
    $compareMarkdown += ('- fail-prefix totalChildBlocks: {0}' -f $failPrefixInspect.totalChildBlocks)
    $compareMarkdown += ('- n-only totalChildBlocks: {0}' -f $nOnlyInspect.totalChildBlocks)
    $compareMarkdown += ''
    $compareMarkdown += '## Chain Audit'
    $compareMarkdown += ('- firstFailStage: {0}' -f $chainAudit.firstFailStage)
    $compareMarkdown += ('- firstFailMessage: {0}' -f $chainAudit.firstFailMessage)
    $compareMarkdown += ('- chainAuditJson: {0}' -f $chainAuditJsonPath)
    $compareMarkdown += ''
    $compareMarkdown += '## Trigger Evidence'
    $compareMarkdown += ('- indexEntry: {0}' -f (($failedEntry | ConvertTo-Json -Compress -Depth 10)))
    $compareMarkdown += ('- lmlPath: {0}' -f $fingerprintItem.lmlPath)
    $compareMarkdown += ('- jPath: {0}' -f $fingerprintItem.jPath)
    $compareMarkdown += ('- metaPath: {0}' -f $fingerprintItem.metaPath)
    $compareMarkdown += ('- lmlSha256: {0}' -f $fingerprintItem.lmlSha256)
    $compareMarkdown += ('- jSha256: {0}' -f $fingerprintItem.jSha256)
    $compareMarkdown += ('- metaSha256: {0}' -f $fingerprintItem.metaSha256)
    if ($null -ne $healthySampleSummary) {
        $compareMarkdown += ''
        $compareMarkdown += '## Healthy Sample'
        $compareMarkdown += ('- triggerCount: {0}' -f $healthySampleSummary.triggerCount)
        $compareMarkdown += ('- guiEventNodeCount: {0}' -f $healthySampleSummary.guiEventNodeCount)
        $compareMarkdown += ('- customTextTriggerCount: {0}' -f $healthySampleSummary.customTextTriggerCount)
        $compareMarkdown += ('- reference nonEmptyTriggerTextCount: {0}' -f $healthySampleSummary.rawReference.nonEmptyTriggerTextCount)
    }

    Set-Content -LiteralPath (Join-Path $diagnosticsRoot 'structural-compare.md') -Value ($compareMarkdown -join "`r`n") -Encoding UTF8
}

$summary = [ordered]@{
    status = if ($null -eq $firstFailureRecord) { 'completed' } else { 'failed' }
    sourceMap = $sourceMapPath
    outputRoot = $outputRootPath
    startOrdinal = $StartOrdinal
    endOrdinal = $EndOrdinal
    timeoutSeconds = $TimeoutSeconds
    controlPassed = [bool]$controlProbe.aliveAfterTimeout
    lastPass = $lastPassingRecord
    firstFail = $firstFailureRecord
    fingerprintPath = (Join-Path $outputRootPath 'trigger_fingerprint.json')
    resultsPath = $resultsPath
    manifestPath = $manifestPath
}

Write-JsonFile -Path $summaryPath -Value $summary
if ($null -ne $lastPassingRecord) {
    Write-JsonFile -Path $lastPassPath -Value $lastPassingRecord
}

Write-Output ($summary | ConvertTo-Json -Depth 12)
