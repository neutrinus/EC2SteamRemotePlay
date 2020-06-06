Write-Output "Setting up Environment"
$path = [Environment]::GetFolderPath("Desktop")
$currentusersid = Get-LocalUser "$env:USERNAME" | Select-Object SID | ft -HideTableHeaders | Out-String | ForEach-Object { $_.Trim() }

Unblock-File -Path .\* | Out-Null
New-Item -ItemType Directory -Path $path\EC2SteamRemotePlayTemp\ | Out-Null
copy-Item .\* -Destination $path\EC2SteamRemotePlayTemp\ -Recurse | Out-Null



Scripts\SetWindowsSettings.ps1

Scripts\InstallTools.ps1
Scripts\InstallAudio.ps1

Scripts\InstallGPU.ps1

#Scripts\EnableAutologin.ps1

	
Write-Host "Use GPU Updater to update your GPU Drivers!"
Write-Host "You don't need to sign into Razer Synapse"
Write-host "DONE!"

pause
