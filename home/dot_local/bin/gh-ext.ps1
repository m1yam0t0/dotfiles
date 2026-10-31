param(
    [Parameter(Position = 0)]
    [string]$Command,
    [Alias('h')]
    [switch]$Help
)

$ErrorActionPreference = 'Stop'
$configHome = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } else { Join-Path $HOME '.config' }
$extensionList = Join-Path $configHome 'gh/extension-list'

if ($Help) {
    Write-Output @"
Usage: gh-ext <install|upgrade> [-Help]

Commands:
    install: Install GitHub CLI extensions from $extensionList
    upgrade: Upgrade GitHub CLI extensions and update $extensionList
"@
    return
}

if ($Command -notin @('install', 'upgrade')) {
    throw 'Specify install or upgrade. Run gh-ext -Help for usage.'
}
if (-not (Test-Path -LiteralPath $extensionList -PathType Leaf)) {
    throw "File not found: $extensionList. Please create it first."
}

if ($Command -eq 'install') {
    foreach ($line in Get-Content -LiteralPath $extensionList -Encoding UTF8) {
        $extension = $line.Trim()
        if (-not $extension -or $extension.StartsWith('#')) { continue }
        gh extension install --force $extension
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to install $extension (exit code $LASTEXITCODE)."
        }
    }
} else {
    gh extension upgrade --all
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to upgrade extensions (exit code $LASTEXITCODE)."
    }
    $installedExtensions = @(gh extension list)
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to list extensions (exit code $LASTEXITCODE)."
    }
    $repositories = @(
        foreach ($line in $installedExtensions) {
            if (-not $line.Trim()) { continue }
            $fields = $line.Trim() -split '\s+'
            if ($fields.Count -lt 3) {
                throw "Unexpected extension list output: $line"
            }
            $fields[2]
        }
    )
    # Keep the shared list compatible with Bash and Windows PowerShell 5.1.
    [System.IO.File]::WriteAllLines($extensionList, [string[]]$repositories, (New-Object System.Text.UTF8Encoding $false))
}
