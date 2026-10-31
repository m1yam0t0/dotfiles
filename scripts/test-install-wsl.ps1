$ErrorActionPreference = 'Stop'
$installerPath = Join-Path $PSScriptRoot '../home/.chezmoiscripts/windows/run_once_install-wsl.ps1'
$previousExitCode = $global:LASTEXITCODE

# Shadow the native command so tests never update, install, or modify real WSL.
function wsl {
    $command = $args -join ' '
    $testCalls.Add($command)
    $global:LASTEXITCODE = if ($command -eq $testFailedCommand) { 5 } else { 0 }
    if ($command -eq '--list --quiet') {
        $testDistributionOutput
    }
}

$cases = @(
    @{
        Name = 'Already installed'
        Output = @('Ubuntu-26.04')
        Calls = @('--update', '--list --quiet', '--set-default Ubuntu-26.04')
    },
    @{
        Name = 'Captured UTF-16 output and whitespace'
        Output = @('Debian', "  U`0b`0u`0n`0t`0u`0-`02`06`0.`00`04`0 `r")
        Calls = @('--update', '--list --quiet', '--set-default Ubuntu-26.04')
    },
    @{
        Name = 'No distributions'
        Output = @()
        Calls = @('--update', '--list --quiet', '--install -d Ubuntu-26.04', '--set-default Ubuntu-26.04')
    },
    @{
        Name = 'Another Ubuntu version'
        Output = @('Ubuntu-24.04')
        Calls = @('--update', '--list --quiet', '--install -d Ubuntu-26.04', '--set-default Ubuntu-26.04')
    },
    @{
        Name = 'Update failure'
        FailedCommand = '--update'
        Error = 'Failed to update WSL.'
        Calls = @('--update')
    },
    @{
        Name = 'Listing failure'
        FailedCommand = '--list --quiet'
        Error = 'Failed to list installed WSL distributions.'
        Calls = @('--update', '--list --quiet')
    },
    @{
        Name = 'Installation failure'
        FailedCommand = '--install -d Ubuntu-26.04'
        Error = 'Failed to install Ubuntu-26.04.'
        Calls = @('--update', '--list --quiet', '--install -d Ubuntu-26.04')
    },
    @{
        Name = 'Default selection failure'
        Output = @('Ubuntu-26.04')
        FailedCommand = '--set-default Ubuntu-26.04'
        Error = 'Failed to set Ubuntu-26.04 as the default WSL distribution.'
        Calls = @('--update', '--list --quiet', '--set-default Ubuntu-26.04')
    }
)

try {
    foreach ($case in $cases) {
        $testCalls = New-Object 'System.Collections.Generic.List[string]'
        $testDistributionOutput = $case.Output
        $testFailedCommand = $case.FailedCommand
        $actualError = $null
        try {
            & $installerPath | Out-Null
        } catch {
            $actualError = $_.Exception.Message
        }
        if ($actualError -ne $case.Error) {
            throw "$($case.Name): unexpected error '$actualError'."
        }
        if (($testCalls -join "`n") -ne ($case.Calls -join "`n")) {
            throw "$($case.Name): unexpected WSL commands: $($testCalls -join ', ')."
        }
        Write-Output "PASS: $($case.Name)"
    }
} finally {
    $global:LASTEXITCODE = $previousExitCode
}
