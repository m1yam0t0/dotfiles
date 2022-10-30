$env:SHELL += "powershell.exe"
$env:Path += ";$env:UserProfile\.local\bin"
Set-Alias -Name g -Value git
