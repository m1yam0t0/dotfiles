$ErrorActionPreference = 'Stop'
$scriptPath = Join-Path $PSScriptRoot '../home/dot_local/bin/gh-ext.ps1'
$testRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('gh-ext-test-' + [guid]::NewGuid())
$testGhDirectory = Join-Path $testRoot 'gh'
$testList = Join-Path $testGhDirectory 'extension-list'
$previousConfigHome = $env:XDG_CONFIG_HOME
$previousPath = $env:Path
$previousExitCode = $global:LASTEXITCODE

# Never invoke the real GitHub CLI or modify installed extensions.
function gh {
    $invocation = $args -join ' '
    $testCalls.Add($invocation)
    $global:LASTEXITCODE = if ($invocation -eq $testFailedCommand) { 5 } else { 0 }
    if ($invocation -eq 'extension list') { $testListOutput }
}

$cases = @(
    @{
        Name = 'Install skips comments and blank lines'
        Command = 'install'
        Calls = @('extension install --force owner/first', 'extension install --force owner/second')
    },
    @{
        Name = 'Install stops at failure'
        Command = 'install'
        FailedCommand = 'extension install --force owner/first'
        Error = 'Failed to install owner/first (exit code 5).'
        Calls = @('extension install --force owner/first')
    },
    @{
        Name = 'Upgrade saves repositories'
        Command = 'upgrade'
        Output = @("gh first`towner/first`tv1.0.0", 'gh second owner/second v2.0.0')
        ExpectedList = @('owner/first', 'owner/second')
        Calls = @('extension upgrade --all', 'extension list')
    },
    @{
        Name = 'Upgrade handles no installed extensions'
        Command = 'upgrade'
        Output = @()
        ExpectedList = @()
        Calls = @('extension upgrade --all', 'extension list')
    },
    @{
        Name = 'Upgrade failure preserves list'
        Command = 'upgrade'
        FailedCommand = 'extension upgrade --all'
        Error = 'Failed to upgrade extensions (exit code 5).'
        Calls = @('extension upgrade --all')
    },
    @{
        Name = 'Listing failure preserves list'
        Command = 'upgrade'
        FailedCommand = 'extension list'
        Error = 'Failed to list extensions (exit code 5).'
        Calls = @('extension upgrade --all', 'extension list')
    },
    @{
        Name = 'Malformed output preserves list'
        Command = 'upgrade'
        Output = @('unexpected')
        Error = 'Unexpected extension list output: unexpected'
        Calls = @('extension upgrade --all', 'extension list')
    },
    @{
        Name = 'Invalid command'
        Command = 'invalid'
        Error = 'Specify install or upgrade. Run gh-ext -Help for usage.'
        Calls = @()
    }
)

try {
    New-Item -ItemType Directory -Path $testGhDirectory | Out-Null
    $env:XDG_CONFIG_HOME = $testRoot
    Copy-Item -LiteralPath $scriptPath -Destination (Join-Path $testRoot 'gh-ext.ps1')
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot '../home/dot_local/bin/executable_gh-ext') -Destination (Join-Path $testRoot 'gh-ext')
    $env:Path = $testRoot + [System.IO.Path]::PathSeparator + $env:Path
    if ((Get-Command gh-ext).Source -ne (Join-Path $testRoot 'gh-ext.ps1')) {
        throw 'gh-ext did not resolve to the PowerShell script.'
    }
    Write-Output 'PASS: gh-ext resolves to PowerShell alongside the Bash script'
    foreach ($case in $cases) {
        $originalList = "# comment`n`n owner/first `nowner/second"
        [System.IO.File]::WriteAllText($testList, $originalList)
        $testCalls = New-Object 'System.Collections.Generic.List[string]'
        $testFailedCommand = $case.FailedCommand
        $testListOutput = $case.Output
        $actualError = $null
        try {
            & $scriptPath $case.Command | Out-Null
        } catch {
            $actualError = $_.Exception.Message
        }
        if ($actualError -ne $case.Error) {
            throw "$($case.Name): unexpected error '$actualError'."
        }
        if (($testCalls -join "`n") -ne ($case.Calls -join "`n")) {
            throw "$($case.Name): unexpected calls: $($testCalls -join ', ')."
        }
        if ($case.ContainsKey('ExpectedList')) {
            if (((Get-Content -LiteralPath $testList) -join "`n") -ne ($case.ExpectedList -join "`n")) {
                throw "$($case.Name): incorrect repository list."
            }
            $bytes = [System.IO.File]::ReadAllBytes($testList)
            if ($bytes.Length -ge 3 -and $bytes[0] -eq 239 -and $bytes[1] -eq 187 -and $bytes[2] -eq 191) {
                throw "$($case.Name): unexpected UTF-8 BOM."
            }
        } elseif ([System.IO.File]::ReadAllText($testList) -ne $originalList) {
            throw "$($case.Name): extension list was modified."
        }
        Write-Output "PASS: $($case.Name)"
    }

    $testCalls.Clear()
    gh-ext -Help | Out-Null
    Remove-Item -LiteralPath $testList
    & $scriptPath -h | Out-Null
    $actualError = $null
    try { & $scriptPath install | Out-Null } catch { $actualError = $_.Exception.Message }
    if ($actualError -ne "File not found: $testList. Please create it first." -or $testCalls.Count -ne 0) {
        throw 'Help or missing-list handling failed.'
    }
    Write-Output 'PASS: Help and missing list'
} finally {
    $env:XDG_CONFIG_HOME = $previousConfigHome
    $env:Path = $previousPath
    $global:LASTEXITCODE = $previousExitCode
    if (Test-Path -LiteralPath $testList) { Remove-Item -LiteralPath $testList }
    foreach ($name in @('gh-ext', 'gh-ext.ps1')) {
        $testScript = Join-Path $testRoot $name
        if (Test-Path -LiteralPath $testScript) { Remove-Item -LiteralPath $testScript }
    }
    if (Test-Path -LiteralPath $testGhDirectory) { Remove-Item -LiteralPath $testGhDirectory }
    if (Test-Path -LiteralPath $testRoot) { Remove-Item -LiteralPath $testRoot }
}
