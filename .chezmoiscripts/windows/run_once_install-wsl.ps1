wsl --update
if ($LASTEXITCODE -ne 0) {
    throw 'Failed to update WSL.'
}

wsl --install -d Ubuntu-26.04
if ($LASTEXITCODE -ne 0) {
    throw 'Failed to install Ubuntu-26.04.'
}

wsl --set-default Ubuntu-26.04
if ($LASTEXITCODE -ne 0) {
    throw 'Failed to set Ubuntu-26.04 as the default WSL distribution.'
}
