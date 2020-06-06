Write-Output "Installing Tools"

Set-ExecutionPolicy Bypass -Scope Process -Force; iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

choco install -y firefox
choco install -y 7zip
choco install -y steam



Install-WindowsFeature Direct-Play | Out-Null
Install-WindowsFeature Net-Framework-Core | Out-Null
