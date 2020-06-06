Write-Output "Installing Audio Drivers"

$Installer = $env:TEMP + "\razer-surround-driver.exe"; 
$RZRTMP = $env:TEMP + "\RZRTMP\"; 


(New-Object System.Net.WebClient).DownloadFile("http://rzr.to/surround-pc-download", $Installer)


$OriginalLocation = Get-Location
Set-Location -Path $RZRTMP
7z.exe x $Installer -y | Out-Null
		
$InstallerManifest = '$TEMP\RazerSurroundInstaller\InstallerManifest.xml'
$regex = '(?<=<SilentMode>)[^<]*'
(Get-Content $InstallerManifest) -replace $regex, 'true' | Set-Content $InstallerManifest -Encoding UTF8
		

Set-Location -Path '$TEMP\RazerSurroundInstaller'
Start-Process RzUpdateManager.exe
Set-Service -Name audiosrv -StartupType Automatic
		
Set-Location $OriginalLocation
