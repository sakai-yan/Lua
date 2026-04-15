param(
    [Parameter(Mandatory = $true)]
    [string]$MapPath,

    [int]$TimeoutSeconds = 15,

    [Parameter(Mandatory = $true)]
    [string]$EditorRoot
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

function Get-EditorExecutablePath {
    param([Parameter(Mandatory = $true)][string]$RootPath)

    $preferred = @('YDWE.exe', 'KKWE.exe', 'worldeditydwe.exe', '雪月WE.exe')
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

function Get-ProcessPathSafe {
    param($Process)
    try {
        return $Process.Path
    }
    catch {
        return $null
    }
}

function Get-ProcessNameSafe {
    param($Process)
    try {
        return $Process.ProcessName
    }
    catch {
        return $null
    }
}

function Test-IsEditorProcess {
    param(
        $Process,
        [string]$PreferredEditorExe
    )

    $name = Get-ProcessNameSafe -Process $Process
    $path = Get-ProcessPathSafe -Process $Process

    if ($path -and $PreferredEditorExe -and
        [string]::Equals([System.IO.Path]::GetFullPath($path), [System.IO.Path]::GetFullPath($PreferredEditorExe), [System.StringComparison]::OrdinalIgnoreCase)) {
        return $true
    }

    if ($name -match '^WorldEdit' -or
        $name -match 'YDWE' -or
        $name -match 'KKWE' -or
        $name -match '雪月WE') {
        return $true
    }

    if ($path -and ($path -match 'WorldEdit' -or $path -match 'YDWE' -or $path -match 'KKWE')) {
        return $true
    }

    return $false
}

function Get-EditorProcessSnapshot {
    param([string]$PreferredEditorExe)

    $snapshot = @{}
    foreach ($process in Get-Process) {
        if (-not (Test-IsEditorProcess -Process $process -PreferredEditorExe $PreferredEditorExe)) {
            continue
        }

        $snapshot[$process.Id] = $true
    }

    return $snapshot
}

function Get-NewEditorProcesses {
    param(
        $Snapshot,
        [datetime]$LaunchTime,
        [string]$PreferredEditorExe
    )

    $matches = New-Object System.Collections.ArrayList
    foreach ($process in Get-Process) {
        if ($Snapshot.ContainsKey($process.Id)) {
            continue
        }

        if (-not (Test-IsEditorProcess -Process $process -PreferredEditorExe $PreferredEditorExe)) {
            continue
        }

        try {
            if ($process.StartTime -lt $LaunchTime.AddSeconds(-2)) {
                continue
            }
        }
        catch {
        }

        [void]$matches.Add($process)
    }

    return @($matches)
}

function Stop-ProcessTreeSafe {
    param([int]$ProcessId)

    try {
        & taskkill /PID $ProcessId /T /F *> $null
    }
    catch {
    }
}

function Get-WatchedProcessFacts {
    param($Processes)

    return @($Processes | ForEach-Object {
        [pscustomobject]@{
            id = $_.Id
            name = Get-ProcessNameSafe -Process $_
            path = Get-ProcessPathSafe -Process $_
        }
    })
}

function Add-ProcessesToWatchTable {
    param(
        $WatchTable,
        $Processes
    )

    foreach ($process in @($Processes)) {
        if ($null -eq $process) {
            continue
        }

        if (-not $WatchTable.ContainsKey($process.Id)) {
            $WatchTable[$process.Id] = $process
        }
    }
}

function Resolve-LogPath {
    param(
        [string]$PreferredEditorRoot,
        $WatchedProcesses,
        [datetime]$StartTime
    )

    $roots = New-Object System.Collections.ArrayList
    [void]$roots.Add($PreferredEditorRoot)

    foreach ($item in $WatchedProcesses) {
        if ($null -eq $item.path) {
            continue
        }

        $candidateRoot = Split-Path -Parent $item.path
        if (-not [string]::IsNullOrWhiteSpace($candidateRoot) -and -not $roots.Contains($candidateRoot)) {
            [void]$roots.Add($candidateRoot)
        }
    }

    $candidates = New-Object System.Collections.ArrayList
    foreach ($root in $roots) {
        foreach ($relative in @('logs\kkwe.log', 'kkwe.log')) {
            $path = Join-Path $root $relative
            if (-not (Test-Path -LiteralPath $path)) {
                continue
            }

            $item = Get-Item -LiteralPath $path
            [void]$candidates.Add([pscustomobject]@{
                path = $path
                lastWriteTime = $item.LastWriteTime
                updated = $item.LastWriteTime -ge $StartTime.AddSeconds(-2)
            })
        }
    }

    $best = $candidates |
        Sort-Object @{ Expression = { $_.updated }; Descending = $true }, @{ Expression = { $_.lastWriteTime }; Descending = $true } |
        Select-Object -First 1

    return $best
}

function Get-LogFacts {
    param(
        $ResolvedLog,
        [string]$ArchiveLogPath
    )

    $lines = @()
    $text = ''
    $logExists = $false
    $lastOpenMapLine = $null
    $lastOpenMapText = $null
    $postOpenUiLoadCount = 0
    $postOpenHasTriggerData = $false
    $postOpenHasTriggerStrings = $false

    if ($null -ne $ResolvedLog -and (Test-Path -LiteralPath $ResolvedLog.path)) {
        $logExists = $true
        Copy-Item -LiteralPath $ResolvedLog.path -Destination $ArchiveLogPath -Force
        $lines = @(Get-Content -LiteralPath $ResolvedLog.path)
        $text = ($lines | ForEach-Object { $_.ToString() }) -join "`n"

        if (-not $ResolvedLog.updated) {
            return [pscustomobject]@{
                logExists = $logExists
                logPath = $ResolvedLog.path
                logUpdated = $false
                archivedLogPath = $ArchiveLogPath
                hasOpenMap = $false
                hasTriggerDataAnywhere = $false
                hasTriggerStringsAnywhere = $false
                lastOpenMapLine = $null
                lastOpenMapText = $null
                postOpenUiLoadCount = 0
                postOpenHasTriggerData = $false
                postOpenHasTriggerStrings = $false
                totalLogLines = $lines.Count
            }
        }

        for ($index = 0; $index -lt $lines.Count; $index++) {
            $line = [string]$lines[$index]
            if ($line -match 'Open map') {
                $lastOpenMapLine = $index + 1
                $lastOpenMapText = $line
            }
        }

        if ($null -ne $lastOpenMapLine) {
            $postOpenLines = @($lines[($lastOpenMapLine - 1)..($lines.Count - 1)])
            $postOpenText = ($postOpenLines | ForEach-Object { $_.ToString() }) -join "`n"
            $postOpenUiLoadCount = @($postOpenLines | Select-String -Pattern 'Loading ui from ').Count
            $postOpenHasTriggerData = $postOpenText -match "virtual_mpq 'triggerdata'"
            $postOpenHasTriggerStrings = $postOpenText -match "virtual_mpq 'triggerstrings'"
        }
    }

    return [pscustomobject]@{
        logExists = $logExists
        logPath = if ($logExists) { $ResolvedLog.path } else { $null }
        logUpdated = if ($null -ne $ResolvedLog) { $ResolvedLog.updated } else { $false }
        archivedLogPath = if ($logExists) { $ArchiveLogPath } else { $null }
        hasOpenMap = $text -match 'Open map'
        hasTriggerDataAnywhere = $text -match "virtual_mpq 'triggerdata'"
        hasTriggerStringsAnywhere = $text -match "virtual_mpq 'triggerstrings'"
        lastOpenMapLine = $lastOpenMapLine
        lastOpenMapText = $lastOpenMapText
        postOpenUiLoadCount = $postOpenUiLoadCount
        postOpenHasTriggerData = $postOpenHasTriggerData
        postOpenHasTriggerStrings = $postOpenHasTriggerStrings
        totalLogLines = $lines.Count
    }
}

function Try-LaunchMode {
    param(
        [string]$Mode,
        [scriptblock]$StartAction,
        $Snapshot,
        [string]$PreferredEditorExe
    )

    $launchError = $null
    $wrapper = $null
    $launchTime = Get-Date

    try {
        $wrapper = & $StartAction
    }
    catch {
        $launchError = $_.Exception.Message
    }

    Start-Sleep -Seconds 2

    $watched = @(Get-NewEditorProcesses -Snapshot $Snapshot -LaunchTime $launchTime -PreferredEditorExe $PreferredEditorExe)
    if ((@($watched).Count -eq 0) -and ($null -ne $wrapper)) {
        try {
            $wrapper.Refresh()
            if (-not $wrapper.HasExited) {
                $watched = @($wrapper)
            }
        }
        catch {
        }
    }

    return [pscustomobject]@{
        mode = $Mode
        launchTime = $launchTime
        wrapper = $wrapper
        launchError = $launchError
        watched = $watched
    }
}

$mapPath = Resolve-ExistingLiteralPath -Path $MapPath
$editorRootPath = Resolve-ExistingLiteralPath -Path $EditorRoot
$editorExePath = Resolve-ExistingLiteralPath -Path (Get-EditorExecutablePath -RootPath $editorRootPath)

$probeRoot = Join-Path ([System.IO.Path]::GetDirectoryName($mapPath)) '_editor_open_probe'
New-Item -ItemType Directory -Force -Path $probeRoot | Out-Null

$mapStem = [System.IO.Path]::GetFileNameWithoutExtension($mapPath)
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss-fff'
$jsonPath = Join-Path $probeRoot "$mapStem.$timestamp.json"
$markdownPath = Join-Path $probeRoot "$mapStem.$timestamp.md"
$archiveLogPath = Join-Path $probeRoot "$mapStem.$timestamp.kkwe.log"

$snapshot = Get-EditorProcessSnapshot -PreferredEditorExe $editorExePath
$launchAttempts = @(
    @{ mode = 'shell_open_map'; action = { Start-Process -FilePath $mapPath -PassThru } },
    @{ mode = 'editor_map_arg'; action = { Start-Process -FilePath $editorExePath -ArgumentList ('"' + $mapPath + '"') -WorkingDirectory $editorRootPath -PassThru } },
    @{ mode = 'editor_loadfile'; action = { Start-Process -FilePath $editorExePath -ArgumentList ('-loadfile "' + $mapPath + '"') -WorkingDirectory $editorRootPath -PassThru } }
)

$launchResult = $null
foreach ($attempt in $launchAttempts) {
    $candidate = Try-LaunchMode -Mode $attempt.mode -StartAction $attempt.action -Snapshot $snapshot -PreferredEditorExe $editorExePath
    if (@($candidate.watched).Count -gt 0) {
        $launchResult = $candidate
        break
    }

    if ($null -ne $candidate.wrapper) {
        try {
            $candidate.wrapper.Refresh()
            if (-not $candidate.wrapper.HasExited) {
                Stop-ProcessTreeSafe -ProcessId $candidate.wrapper.Id
            }
        }
        catch {
        }
    }

    if ($null -eq $launchResult) {
        $launchResult = $candidate
    }
}

$launchError = $launchResult.launchError
$aliveAfterTimeout = $false
$killedByTool = $false
$processExited = $false
$exitCode = $null
$watchedById = @{}
Add-ProcessesToWatchTable -WatchTable $watchedById -Processes $launchResult.watched

for ($elapsed = 0; $elapsed -lt $TimeoutSeconds; $elapsed++) {
    $rescan = Get-NewEditorProcesses -Snapshot $snapshot -LaunchTime $launchResult.launchTime -PreferredEditorExe $editorExePath
    Add-ProcessesToWatchTable -WatchTable $watchedById -Processes $rescan

    $alive = New-Object System.Collections.ArrayList
    foreach ($process in $watchedById.Values) {
        try {
            $process.Refresh()
            if (-not $process.HasExited) {
                [void]$alive.Add($process)
            }
        }
        catch {
        }
    }

    if ($alive.Count -eq 0) {
        break
    }

    if ($elapsed -eq ($TimeoutSeconds - 1)) {
        $aliveAfterTimeout = $true
        $killedByTool = $true
        foreach ($process in $alive) {
            Stop-ProcessTreeSafe -ProcessId $process.Id
        }
        Start-Sleep -Seconds 2
        break
    }

    Start-Sleep -Seconds 1
}

$stillAlive = $false
foreach ($process in $watchedById.Values) {
    try {
        $process.Refresh()
        if (-not $process.HasExited) {
            $stillAlive = $true
        }
    }
    catch {
    }
}

$processExited = -not $stillAlive
if ((@($watchedById.Values).Count -gt 0) -and $processExited) {
    foreach ($process in $watchedById.Values) {
        try {
            $process.Refresh()
            if ($process.HasExited) {
                $exitCode = $process.ExitCode
                break
            }
        }
        catch {
        }
    }
}

$watchIds = @($watchedById.Keys | Sort-Object)
$watchedFacts = Get-WatchedProcessFacts -Processes $watchedById.Values

$logCandidate = Resolve-LogPath -PreferredEditorRoot $editorRootPath -WatchedProcesses $watchedFacts -StartTime $launchResult.launchTime
$logFacts = Get-LogFacts -ResolvedLog $logCandidate -ArchiveLogPath $archiveLogPath

$status = if ($launchError -and (@($watchedById.Values).Count -eq 0)) {
    'launch_error'
}
elseif ($aliveAfterTimeout) {
    'alive_after_timeout'
}
elseif ($processExited) {
    'exited_before_timeout'
}
else {
    'unknown'
}

$result = [ordered]@{
    mapPath = $mapPath
    editorRoot = $editorRootPath
    preferredEditorExe = $editorExePath
    launchMode = $launchResult.mode
    timeoutSeconds = $TimeoutSeconds
    startedAt = $launchResult.launchTime.ToString('o')
    status = $status
    launchError = $launchError
    watchedProcessIds = $watchIds
    watchedProcesses = $watchedFacts
    processExited = $processExited
    exitCode = $exitCode
    aliveAfterTimeout = $aliveAfterTimeout
    killedByTool = $killedByTool
    logPath = $logFacts.logPath
    logExists = $logFacts.logExists
    logUpdated = $logFacts.logUpdated
    logArchivePath = $logFacts.archivedLogPath
    hasOpenMap = $logFacts.hasOpenMap
    hasTriggerDataAnywhere = $logFacts.hasTriggerDataAnywhere
    hasTriggerStringsAnywhere = $logFacts.hasTriggerStringsAnywhere
    lastOpenMapLine = $logFacts.lastOpenMapLine
    lastOpenMapText = $logFacts.lastOpenMapText
    postOpenUiLoadCount = $logFacts.postOpenUiLoadCount
    postOpenHasTriggerData = $logFacts.postOpenHasTriggerData
    postOpenHasTriggerStrings = $logFacts.postOpenHasTriggerStrings
    totalLogLines = $logFacts.totalLogLines
    jsonPath = $jsonPath
    markdownPath = $markdownPath
}

$resultJson = $result | ConvertTo-Json -Depth 10
Set-Content -LiteralPath $jsonPath -Value $resultJson -Encoding UTF8

$markdown = @()
$markdown += '# Editor Open Probe'
$markdown += ''
$markdown += '## Inputs'
$markdown += ('- map: {0}' -f $result.mapPath)
$markdown += ('- editor root: {0}' -f $result.editorRoot)
$markdown += ('- preferred editor exe: {0}' -f $result.preferredEditorExe)
$markdown += ('- launch mode: {0}' -f $result.launchMode)
$markdown += ('- timeoutSeconds: {0}' -f $result.timeoutSeconds)
$markdown += ''
$markdown += '## Result'
$markdown += ('- status: {0}' -f $result.status)
$markdown += ('- aliveAfterTimeout: {0}' -f $result.aliveAfterTimeout)
$markdown += ('- killedByTool: {0}' -f $result.killedByTool)
$markdown += ('- processExited: {0}' -f $result.processExited)
$markdown += ('- exitCode: {0}' -f $result.exitCode)
$markdown += ('- launchError: {0}' -f $result.launchError)
$markdown += ('- watchedProcessIds: {0}' -f (($result.watchedProcessIds | ForEach-Object { $_.ToString() }) -join ', '))
$markdown += ''
$markdown += '## Log'
$markdown += ('- logPath: {0}' -f $result.logPath)
$markdown += ('- logExists: {0}' -f $result.logExists)
$markdown += ('- logUpdated: {0}' -f $result.logUpdated)
$markdown += ('- logArchivePath: {0}' -f $result.logArchivePath)
$markdown += ('- hasOpenMap: {0}' -f $result.hasOpenMap)
$markdown += ('- lastOpenMapLine: {0}' -f $result.lastOpenMapLine)
$markdown += ('- lastOpenMapText: {0}' -f $result.lastOpenMapText)
$markdown += ('- postOpenUiLoadCount: {0}' -f $result.postOpenUiLoadCount)
$markdown += ('- postOpenHasTriggerData: {0}' -f $result.postOpenHasTriggerData)
$markdown += ('- postOpenHasTriggerStrings: {0}' -f $result.postOpenHasTriggerStrings)
$markdown += ('- totalLogLines: {0}' -f $result.totalLogLines)

Set-Content -LiteralPath $markdownPath -Value ($markdown -join "`r`n") -Encoding UTF8

Write-Output $resultJson
