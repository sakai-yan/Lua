param(
    [Parameter(Mandatory = $true)]
    [string]$RerunRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Resolve-ExistingLiteralPath {
    param([string]$Path)
    return (Resolve-Path -LiteralPath $Path).Path
}

function Invoke-LuaProbe {
    param(
        [string]$LuaExe,
        [string]$ScriptPath,
        [string[]]$Arguments
    )

    $output = & $LuaExe $ScriptPath @Arguments 2>&1
    $exitCode = $LASTEXITCODE
    $text = ($output | ForEach-Object { $_.ToString() }) -join "`n"

    [pscustomobject]@{
        ExitCode = $exitCode
        Output = $text.Trim()
    }
}

function Get-HookGuiNames {
    param([string]$HookPath)

    $names = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($match in [regex]::Matches((Get-Content -LiteralPath $HookPath -Raw), 'GUIID_Table_Put\(([^)]+)\)')) {
        $null = $names.Add($match.Groups[1].Value)
    }

    return $names
}

function Get-EarlyTriggerUsage {
    param(
        [string]$RecoveredGuiDir,
        [int]$Count
    )

    $files = Get-ChildItem -LiteralPath $RecoveredGuiDir -Filter '*.lml' |
        Where-Object { $_.Name -match '^(\d+)-(.+)\.lml$' } |
        Sort-Object { [int]([regex]::Match($_.Name, '^(\d+)-').Groups[1].Value) } |
        Select-Object -First $Count

    $result = @()
    foreach ($file in $files) {
        $match = [regex]::Match($file.Name, '^(\d+)-(.+)\.lml$')
        $ordinal = [int]$match.Groups[1].Value
        $triggerName = $match.Groups[2].Value
        $usedNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)

        foreach ($line in (Get-Content -LiteralPath $file.FullName)) {
            $trimmed = $line.Trim()
            $bullet = [regex]::Match($trimmed, '^- ([A-Za-z_][A-Za-z0-9_]*)\b')
            if ($bullet.Success) {
                $null = $usedNames.Add($bullet.Groups[1].Value)
            }

            foreach ($callMatch in [regex]::Matches($line, 'call:([A-Za-z_][A-Za-z0-9_]*)')) {
                $null = $usedNames.Add($callMatch.Groups[1].Value)
            }
        }

        $result += [pscustomobject]@{
            Ordinal = $ordinal
            TriggerName = $triggerName
            UsedGuiNames = @($usedNames | Sort-Object)
        }
    }

    return $result
}

function Get-EditorExecutablePath {
    param([string]$YdweRoot)

    $preferred = @('YDWE.exe', 'KKWE.exe', 'worldeditydwe.exe')
    foreach ($name in $preferred) {
        $candidate = Join-Path $YdweRoot $name
        if (Test-Path -LiteralPath $candidate) {
            return $candidate
        }
    }

    $fallback = Get-ChildItem -LiteralPath $YdweRoot -Filter '*WE.exe' -File |
        Sort-Object Name |
        Select-Object -First 1
    if ($null -ne $fallback) {
        return $fallback.FullName
    }

    throw "No YDWE editor executable was found under `$YdweRoot`."
}

function Invoke-ManualEditorOpen {
    param(
        [string]$EditorExe,
        [string]$YdweRoot,
        [string]$MapPath,
        [string]$ArchiveLogPath,
        [int]$TimeoutSeconds = 25
    )

    $logPath = Join-Path $YdweRoot 'logs\kkwe.log'
    $startTime = Get-Date
    $launchError = $null
    $process = $null
    $timedOut = $false
    $exited = $false
    $exitCode = $null

    try {
        $startInfo = New-Object System.Diagnostics.ProcessStartInfo
        $startInfo.FileName = $EditorExe
        $startInfo.Arguments = ('-loadfile "{0}"' -f $MapPath)
        $startInfo.WorkingDirectory = $YdweRoot
        $startInfo.UseShellExecute = $true
        $process = [System.Diagnostics.Process]::Start($startInfo)
    }
    catch {
        $launchError = $_.Exception.Message
    }

    if ($null -ne $process) {
        Start-Sleep -Seconds $TimeoutSeconds
        $process.Refresh()
        if (-not $process.HasExited) {
            $timedOut = $true
            & taskkill /PID $process.Id /T /F *> $null
            Start-Sleep -Seconds 2
            try {
                $process.Refresh()
            }
            catch {
            }
        }

        $exited = $process.HasExited
        if ($exited) {
            $exitCode = $process.ExitCode
        }
    }

    $logLines = @()
    $logText = ''
    $logUpdated = $false
    if (Test-Path -LiteralPath $logPath) {
        $item = Get-Item -LiteralPath $logPath
        $logUpdated = $item.LastWriteTime -ge $startTime.AddSeconds(-2)
        Copy-Item -LiteralPath $logPath -Destination $ArchiveLogPath -Force
        $logLines = Get-Content -LiteralPath $logPath
        $logText = ($logLines | ForEach-Object { $_.ToString() }) -join "`n"
    }

    $hasOpenMap = $logText -match 'Open map'
    $hasTriggerDataAnywhere = $logText -match "virtual_mpq 'triggerdata'"
    $hasTriggerStringsAnywhere = $logText -match "virtual_mpq 'triggerstrings'"

    $lastOpenMapLine = $null
    $lastOpenMapText = $null
    $lastTriggerDataLine = $null
    $lastTriggerStringsLine = $null
    $postOpenText = ''
    $postOpenHasTriggerData = $false
    $postOpenHasTriggerStrings = $false
    $postOpenUiLoadCount = 0
    $postOpenLastLine = $null

    if ($logLines.Count -gt 0) {
        for ($i = 0; $i -lt $logLines.Count; $i++) {
            $line = [string]$logLines[$i]
            if ($line -match 'Open map') {
                $lastOpenMapLine = $i + 1
                $lastOpenMapText = $line
            }
            if ($line -match "virtual_mpq 'triggerdata'") {
                $lastTriggerDataLine = $i + 1
            }
            if ($line -match "virtual_mpq 'triggerstrings'") {
                $lastTriggerStringsLine = $i + 1
            }
        }

        if ($null -ne $lastOpenMapLine) {
            $postOpenLines = @($logLines[($lastOpenMapLine - 1)..($logLines.Count - 1)])
            $postOpenText = ($postOpenLines | ForEach-Object { $_.ToString() }) -join "`n"
            $postOpenHasTriggerData = $postOpenText -match "virtual_mpq 'triggerdata'"
            $postOpenHasTriggerStrings = $postOpenText -match "virtual_mpq 'triggerstrings'"
            $postOpenUiLoadCount = @($postOpenLines | Select-String -Pattern 'Loading ui from ').Count
            if ($postOpenLines.Count -gt 0) {
                $postOpenLastLine = [string]$postOpenLines[-1]
            }
        }
    }

    $stage = $null
    $message = $null

    if ($launchError) {
        $stage = 'manual-open-launch'
        $message = $launchError
    }
    elseif (-not $logUpdated -or -not $lastOpenMapLine) {
        $stage = 'ydwe-open-runtime-integration'
        $message = 'The canon editor did not emit a fresh `Open map` marker for this launch.'
    }
    elseif ($postOpenHasTriggerData -or $postOpenHasTriggerStrings) {
        $stage = 'editor-private-runtime-or-early-trigger-shape'
        $message = if ($postOpenHasTriggerStrings) {
            'The canon editor emitted post-open `triggerdata` and `triggerstrings` markers after the last `Open map`; the unresolved layer is above the real editor trigger-data load.'
        }
        else {
            'The canon editor emitted a post-open `triggerdata` marker after the last `Open map`, but not `triggerstrings`; the unresolved layer is inside the real editor trigger-panel load.'
        }
    }
    elseif ($timedOut) {
        $stage = 'manual-open-stayed-alive-after-open-map'
        $message = if ($postOpenUiLoadCount -gt 0) {
            "The canon editor stayed alive for the full $TimeoutSeconds-second observation window after Open map and loaded $postOpenUiLoadCount UI root(s) through triggerdata.lua, but the post-open log still emitted no trigger-panel-specific markers."
        }
        else {
            "The canon editor stayed alive for the full $TimeoutSeconds-second observation window after Open map, but the post-open log exposed no trigger-panel-specific markers."
        }
    }
    elseif ($exited) {
        $stage = if ($postOpenUiLoadCount -gt 0) {
            'manual-open-early-exit-after-wtgloader-ui-load'
        }
        else {
            'manual-open-early-exit-after-open-map'
        }
        $message = if ($postOpenUiLoadCount -gt 0) {
            "The canon editor logged Open map, loaded $postOpenUiLoadCount UI root(s) through triggerdata.lua, and then exited before the $TimeoutSeconds-second observation window ended. The post-open log never emitted triggerdata or triggerstrings, so the failure remains inside the real editor open path after open_map.lua / wtgloader and before a proven trigger-panel load."
        }
        else {
            "The canon editor logged `Open map` but exited before the $TimeoutSeconds-second observation window ended, without enough post-open log detail to prove later trigger-panel progress."
        }
    }
    else {
        $stage = 'manual-open-unclassified'
        $message = 'The canon editor launch produced a fresh `Open map` marker, but the post-open state could not be classified.'
    }

    [pscustomobject]@{
        EditorExe = $EditorExe
        LogPath = $logPath
        ArchivedLogPath = $ArchiveLogPath
        LaunchError = $launchError
        TimedOutAndKilled = $timedOut
        ProcessExited = $exited
        ExitCode = $exitCode
        LogUpdated = $logUpdated
        HasOpenMap = $hasOpenMap
        HasTriggerDataAnywhere = $hasTriggerDataAnywhere
        HasTriggerStringsAnywhere = $hasTriggerStringsAnywhere
        LastOpenMapLine = $lastOpenMapLine
        LastOpenMapText = $lastOpenMapText
        LastTriggerDataLine = $lastTriggerDataLine
        LastTriggerStringsLine = $lastTriggerStringsLine
        PostOpenHasTriggerData = $postOpenHasTriggerData
        PostOpenHasTriggerStrings = $postOpenHasTriggerStrings
        PostOpenUiLoadCount = $postOpenUiLoadCount
        PostOpenLastLine = $postOpenLastLine
        Stage = $stage
        Message = $message
    }
}

function Set-FirstFailure {
    param(
        [System.Collections.IDictionary]$Audit,
        [string]$Stage,
        [string]$Message
    )

    if ([string]::IsNullOrWhiteSpace($Audit.firstFailStage)) {
        $Audit.firstFailStage = $Stage
        $Audit.firstFailMessage = $Message
    }
}

$toolsRoot = Split-Path -Parent $PSCommandPath
$workspaceRoot = Split-Path -Parent $toolsRoot
$repoRoot = Resolve-ExistingLiteralPath (Join-Path $toolsRoot '..\..\..\..')
$rerunRootCandidate = if ([System.IO.Path]::IsPathRooted($RerunRoot)) {
    $RerunRoot
}
else {
    Join-Path $repoRoot $RerunRoot
}
$rerunRootPath = Resolve-ExistingLiteralPath $rerunRootCandidate

$ydweRoot = Resolve-ExistingLiteralPath (Join-Path $repoRoot '.canon\YDWE')
$luaExe = Resolve-ExistingLiteralPath (Join-Path $ydweRoot 'plugin\w3x2lni_zhCN_v2.7.3\bin\w3x2lni-lua.exe')
$checkerScript = Resolve-ExistingLiteralPath (Join-Path $repoRoot '.tools\MapRepair\scripts\ydwe_wtg_checker.lua')
$wtgloaderScript = Resolve-ExistingLiteralPath (Join-Path $repoRoot '.tools\MapRepair\scripts\ydwe_wtgloader_probe.lua')
$unknownUiDumpScript = Resolve-ExistingLiteralPath (Join-Path $repoRoot '.tools\MapRepair\scripts\ydwe_wtg_dump_unknownui.lua')
$frontendScript = Resolve-ExistingLiteralPath (Join-Path $toolsRoot 'canon_ydwe_frontend_probe.lua')
$hookSourcePath = Resolve-ExistingLiteralPath (Join-Path $repoRoot '.canon\YDWE\source\Development\Plugin\WE\YDTrigger\SetGUIId_Hook.cpp')
$indexPath = Resolve-ExistingLiteralPath (Join-Path $rerunRootPath 'report\RecoveredGui\index.json')
$recoveredGuiDir = Resolve-ExistingLiteralPath (Join-Path $rerunRootPath 'report\RecoveredGui')
$chainAuditJsonPath = Join-Path $rerunRootPath 'chain-audit.json'
$chainAuditMarkdownPath = Join-Path $rerunRootPath 'chain-audit.md'
$chainAuditLogPath = Join-Path $rerunRootPath 'chain-audit-kkwe.log'
$unknownUiOutputDir = Join-Path $rerunRootPath 'unknownui'

$mapFile = Get-ChildItem -LiteralPath $rerunRootPath -Filter '*.w3x' -File | Select-Object -First 1
if ($null -eq $mapFile) {
    throw "No repaired map `.w3x` file was found under `$rerunRootPath`."
}

$mapPath = $mapFile.FullName
$wtgPath = Resolve-ExistingLiteralPath (Join-Path $rerunRootPath 'verify\war3map.wtg')
$wctPath = Resolve-ExistingLiteralPath (Join-Path $rerunRootPath 'verify\war3map.wct')

$indexEntries = Get-Content -LiteralPath $indexPath -Raw | ConvertFrom-Json
$earlyTriggerNames = @($indexEntries | Select-Object -First 32 | ForEach-Object { $_.name })
$earlyTriggerUsage = Get-EarlyTriggerUsage -RecoveredGuiDir $recoveredGuiDir -Count 32
$hookGuiNames = Get-HookGuiNames -HookPath $hookSourcePath

$checker = Invoke-LuaProbe -LuaExe $luaExe -ScriptPath $checkerScript -Arguments @($ydweRoot, $wtgPath)
$debugMissing = Invoke-LuaProbe -LuaExe $luaExe -ScriptPath $checkerScript -Arguments @($ydweRoot, $wtgPath, '--debug-missing')
$wtgloader = Invoke-LuaProbe -LuaExe $luaExe -ScriptPath $wtgloaderScript -Arguments @($ydweRoot, $wtgPath)
$unknownUiDump = $null
if ($wtgloader.ExitCode -ne 0) {
    $unknownUiDump = Invoke-LuaProbe -LuaExe $luaExe -ScriptPath $unknownUiDumpScript -Arguments @($ydweRoot, $wtgPath, $unknownUiOutputDir)
}

$frontendProbeRaw = Invoke-LuaProbe -LuaExe $luaExe -ScriptPath $frontendScript -Arguments @($ydweRoot, $wtgPath)
$frontendProbe = $frontendProbeRaw.Output | ConvertFrom-Json
$editorExe = Get-EditorExecutablePath -YdweRoot $ydweRoot
$manualOpen = Invoke-ManualEditorOpen -EditorExe $editorExe -YdweRoot $ydweRoot -MapPath $mapPath -ArchiveLogPath $chainAuditLogPath

$metadataNameSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
if ($frontendProbe.frontendTrgPass) {
    foreach ($kind in @('event', 'condition', 'action', 'call')) {
        foreach ($name in $frontendProbe.metadataNames.$kind) {
            $null = $metadataNameSet.Add([string]$name)
        }
    }
}

$hookOnlyByName = [ordered]@{}
foreach ($trigger in $earlyTriggerUsage) {
    foreach ($name in $trigger.UsedGuiNames) {
        if (-not $hookGuiNames.Contains([string]$name)) {
            continue
        }
        if ($metadataNameSet.Contains([string]$name)) {
            continue
        }

        if (-not $hookOnlyByName.Contains($name)) {
            $hookOnlyByName[$name] = [ordered]@{
                name = $name
                ordinals = @()
                triggers = @()
            }
        }

        $hookOnlyByName[$name].ordinals += $trigger.Ordinal
        $hookOnlyByName[$name].triggers += $trigger.TriggerName
    }
}

$hookOnlyGuiNames = @($hookOnlyByName.Values)

$audit = [ordered]@{
    mapPath = $mapPath
    wtgPath = $wtgPath
    wctPath = $wctPath
    checkerPass = $checker.ExitCode -eq 0 -and $checker.Output -match 'PASS'
    debugMissingPass = $debugMissing.ExitCode -eq 0 -and $debugMissing.Output -match 'PASS'
    wtgloaderCheckPass = $wtgloader.ExitCode -eq 0 -and $wtgloader.Output -match 'CHECK PASS'
    frontendTrgPass = [bool]$frontendProbe.frontendTrgPass
    frontendWtgPass = [bool]$frontendProbe.frontendWtgPass
    triggerCount = if ([bool]$frontendProbe.frontendWtgPass) { [int]$frontendProbe.triggerCount } else { $null }
    firstFailStage = $null
    firstFailMessage = $null
    hookOnlyGuiNames = $hookOnlyGuiNames
    earlyTriggerNames = $earlyTriggerNames
    nextSuspectTriggers = @()
    hookAudit = [ordered]@{
        hookGuiCount = $hookGuiNames.Count
        earlyTriggerCount = $earlyTriggerUsage.Count
        earlyHookOnlyCount = $hookOnlyGuiNames.Count
    }
    probeCommands = [ordered]@{
        checker = "`"$luaExe`" `"$checkerScript`" `"$ydweRoot`" `"$wtgPath`""
        debugMissing = "`"$luaExe`" `"$checkerScript`" `"$ydweRoot`" `"$wtgPath`" --debug-missing"
        wtgloader = "`"$luaExe`" `"$wtgloaderScript`" `"$ydweRoot`" `"$wtgPath`""
        frontend = "`"$luaExe`" `"$frontendScript`" `"$ydweRoot`" `"$wtgPath`""
        manualOpen = "`"$editorExe`" -loadfile `"$mapPath`""
    }
    checker = $checker
    debugMissing = $debugMissing
    wtgloader = $wtgloader
    unknownUiDump = $unknownUiDump
    frontendProbe = $frontendProbe
    manualOpen = $manualOpen
}

if (-not $audit.checkerPass) {
    Set-FirstFailure -Audit $audit -Stage 'checker-byte-layout' -Message $checker.Output
}
elseif (-not $audit.debugMissingPass) {
    Set-FirstFailure -Audit $audit -Stage 'checker-debug-missing' -Message $debugMissing.Output
}
elseif (-not $audit.wtgloaderCheckPass) {
    $message = if ($unknownUiDump -and $unknownUiDump.ExitCode -eq 0) {
        "The canonical wtgloader check failed and the unknown-ui dump was populated under `unknownui/`."
    }
    else {
        $wtgloader.Output
    }
    Set-FirstFailure -Audit $audit -Stage 'wtgloader-metadata-unknownui' -Message $message
}
elseif (-not $audit.frontendTrgPass) {
    Set-FirstFailure -Audit $audit -Stage 'frontend_trg' -Message ([string]$frontendProbe.firstFailMessage)
}
elseif (-not $audit.frontendWtgPass) {
    Set-FirstFailure -Audit $audit -Stage 'frontend_wtg' -Message ([string]$frontendProbe.firstFailMessage)
}
else {
    Set-FirstFailure -Audit $audit -Stage ([string]$manualOpen.Stage) -Message ([string]$manualOpen.Message)
    if ($manualOpen.Stage -in @(
            'editor-private-runtime-or-early-trigger-shape',
            'manual-open-early-exit-after-wtgloader-ui-load',
            'manual-open-early-exit-after-open-map'
        )) {
        $audit.nextSuspectTriggers = @(
            '018-hantmdweiacunzhuang1',
            '020-tmdjingong009',
            '001-SET',
            '002-SET2'
        )
    }
}

$json = $audit | ConvertTo-Json -Depth 10
Set-Content -LiteralPath $chainAuditJsonPath -Value $json -Encoding UTF8

$markdown = @()
$markdown += '# Canon YDWE Chain Audit'
$markdown += ''
$markdown += '## Inputs'
$markdown += ('- Rerun root: {0}' -f $rerunRootPath)
$markdown += ('- Map: {0}' -f $mapPath)
$markdown += ('- WTG: {0}' -f $wtgPath)
$markdown += ('- WCT: {0}' -f $wctPath)
$markdown += ('- Canon YDWE root: {0}' -f $ydweRoot)
$markdown += ''
$markdown += '## Probe Results'
$markdown += ('- checker: {0}' -f $audit.checkerPass)
$markdown += ('- debug-missing: {0}' -f $audit.debugMissingPass)
$markdown += ('- wtgloader: {0}' -f $audit.wtgloaderCheckPass)
$markdown += ('- frontend_trg: {0}' -f $audit.frontendTrgPass)
$markdown += ('- frontend_wtg: {0}' -f $audit.frontendWtgPass)
$markdown += ('- triggerCount: {0}' -f $audit.triggerCount)
$markdown += ''
$markdown += '## Classification'
$markdown += ('- firstFailStage: {0}' -f $audit.firstFailStage)
$markdown += ('- firstFailMessage: {0}' -f $audit.firstFailMessage)
$markdown += ''
$markdown += '## Manual Open'
$markdown += ('- editor: {0}' -f $manualOpen.EditorExe)
$markdown += ('- archived log: {0}' -f $manualOpen.ArchivedLogPath)
$markdown += ('- log updated: {0}' -f $manualOpen.LogUpdated)
$markdown += ('- process exited: {0}' -f $manualOpen.ProcessExited)
$markdown += ('- exit code: {0}' -f $manualOpen.ExitCode)
$markdown += ('- timed out and killed: {0}' -f $manualOpen.TimedOutAndKilled)
$markdown += ('- Open map marker: {0}' -f $manualOpen.HasOpenMap)
$markdown += ('- triggerdata marker anywhere in log: {0}' -f $manualOpen.HasTriggerDataAnywhere)
$markdown += ('- triggerstrings marker anywhere in log: {0}' -f $manualOpen.HasTriggerStringsAnywhere)
$markdown += ('- last Open map line: {0}' -f $manualOpen.LastOpenMapLine)
$markdown += ('- last triggerdata line: {0}' -f $manualOpen.LastTriggerDataLine)
$markdown += ('- last triggerstrings line: {0}' -f $manualOpen.LastTriggerStringsLine)
$markdown += ('- post-open triggerdata marker: {0}' -f $manualOpen.PostOpenHasTriggerData)
$markdown += ('- post-open triggerstrings marker: {0}' -f $manualOpen.PostOpenHasTriggerStrings)
$markdown += ('- post-open UI load count: {0}' -f $manualOpen.PostOpenUiLoadCount)
$markdown += ('- last post-open line: {0}' -f $manualOpen.PostOpenLastLine)
$markdown += ''
$markdown += '## Hook Audit'
$markdown += ('- earlyTriggerNames: {0}' -f (([string[]]$audit.earlyTriggerNames) -join ', '))
$markdown += ('- hookOnlyGuiNames: {0}' -f $audit.hookOnlyGuiNames.Count)
if ($audit.hookOnlyGuiNames.Count -gt 0) {
    foreach ($entry in $audit.hookOnlyGuiNames) {
        $markdown += ('- {0}: ordinals {1}; triggers {2}' -f $entry.name, (([int[]]$entry.ordinals) -join ', '), (([string[]]$entry.triggers) -join ', '))
    }
}
else {
    $markdown += '- No early GUI names were found to depend on the C++ hook alone.'
}
$markdown += ''
$markdown += '## Next Targets'
if ($audit.nextSuspectTriggers.Count -gt 0) {
    foreach ($trigger in $audit.nextSuspectTriggers) {
        $markdown += ('- {0}' -f $trigger)
    }
}
else {
    $markdown += '- No early-trigger follow-up is active until the failing layer moves back above the headless parse chain.'
}
$markdown += ''
$markdown += '## Commands'
$markdown += '```text'
$markdown += $audit.probeCommands.checker
$markdown += $audit.probeCommands.debugMissing
$markdown += $audit.probeCommands.wtgloader
$markdown += $audit.probeCommands.frontend
$markdown += $audit.probeCommands.manualOpen
$markdown += '```'

Set-Content -LiteralPath $chainAuditMarkdownPath -Value ($markdown -join "`r`n") -Encoding UTF8

Write-Output "Wrote $chainAuditJsonPath"
Write-Output "Wrote $chainAuditMarkdownPath"
