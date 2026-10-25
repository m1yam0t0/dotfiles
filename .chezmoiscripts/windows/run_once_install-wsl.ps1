wsl --update
if ($LASTEXITCODE -ne 0) {
    throw 'Failed to update WSL.'
}

wsl --install -d Ubuntu-26.04
