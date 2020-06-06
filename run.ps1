﻿Write-Output "Setting up Environment"
$path = [Environment]::GetFolderPath("Desktop")
$currentusersid = Get-LocalUser "$env:USERNAME" | Select-Object SID | ft -HideTableHeaders | Out-String | ForEach-Object { $_.Trim() }

Unblock-File -Path .\* | Out-Null
New-Item -ItemType Directory -Path $path\EC2SteamRemotePlayTemp\ | Out-Null
copy-Item .\* -Destination $path\EC2SteamRemotePlayTemp\ -Recurse | Out-Null



Scripts\InstallFirefox.ps1
Scripts\SetWindowsSettings.ps1
Scripts\EnableAutologin.ps1


#Disable Devices
#Start-Process -FilePath "C:\ParsecTemp\Devcon\devcon.exe" -ArgumentList '/r disable "HDAUDIO\FUNC_01&VEN_10DE&DEV_0083&SUBSYS_10DE11A3*"'
#Get-PnpDevice| where {$_.friendlyname -like "Generic Non-PNP Monitor" -and $_.status -eq "OK"} | Disable-PnpDevice -confirm:$false
#Get-PnpDevice| where {$_.friendlyname -like "Microsoft Basic Display Adapter" -and $_.status -eq "OK"} | Disable-PnpDevice -confirm:$false
#Start-Process -FilePath "C:\ParsecTemp\Devcon\devcon.exe" -ArgumentList '/r disable "PCI\VEN_1013&DEV_00B8*"'


#start-process powershell.exe -verb RunAS -argument "-file $ENV:Appdata\ParsecLoader\GPUUpdaterTool.ps1"
	

Write-Host "Use GPU Updater to update your GPU Drivers!"
Write-Host "You don't need to sign into Razer Synapse"
Write-host "DONE!"

pause
