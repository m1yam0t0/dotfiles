wsl --update
if ($LASTEXITCODE -ne 0) {
    throw 'Failed to update WSL.'
}

$distributionName = 'Ubuntu-26.04'
$installedDistributions = @(wsl --list --quiet)
if ($LASTEXITCODE -ne 0) {
    throw 'Failed to list installed WSL distributions.'
}

# WSL output can contain UTF-16 NUL characters when captured by PowerShell.
$installedDistributions = @($installedDistributions | ForEach-Object {
    ($_ -replace "`0", '').Trim()
})

if ($installedDistributions -contains $distributionName) {
    Write-Output "$distributionName is already installed. Skip installation."
} else {
    wsl --install -d $distributionName
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install $distributionName."
    }
}

wsl --set-default $distributionName
if ($LASTEXITCODE -ne 0) {
    throw "Failed to set $distributionName as the default WSL distribution."
}
